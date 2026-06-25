-----------------------------------
-- Shared-Inventory Guild Vendors
--
-- Lets several NPCs share one dynamic guild shop (one inventory + price pool).
-- The base xi.guildShops keys shop config (xi.data.guildShops[name]) and live
-- state (xi.guildShops.state[name]) by npc:getName(), so differently-named NPCs
-- cannot share a pool. This module adds an npcName -> shopKey alias (default key
-- is the npc's own name) and re-implements the public xi.guildShops.* entry
-- points keyed by that shop key. Because price is derived from the shared stock,
-- sharing the state shares the prices automatically.
--
-- The price/restock math is a faithful copy of scripts/globals/guild_shops.lua;
-- keep it identical so non-aliased shops behave exactly as before.
--
-- Public module for ZenithXI
-----------------------------------
local m = Module:new('c_guildShopSharing')

xi              = xi or {}
xi.guildShops   = xi.guildShops or {}
xi.guildShops.state = xi.guildShops.state or {}

-- npcName -> canonical shop key. Any NPC not listed uses its own name as the key.
xi.guildShops.alias = xi.guildShops.alias or
{
    ['Vicious_Eye']   = 'Amulya',
    ['Celestina']     = 'Yabby_Tanmikey',
    ['Mololo']        = 'Kamilah',
    ['Chomo_Jinjahl'] = 'Kopopo',
}

-- Resolve an NPC display name to its shop key (alias or the name itself).
xi.guildShops.shopKeyFor = function(name)
    return xi.guildShops.alias[name] or name
end

local function keyFor(npc)
    return xi.guildShops.shopKeyFor(npc:getName())
end

-- One-time warning if an aliased NPC points at a shop key with no config.
local warnedMissing = {}
local function warnMissingShop(npc)
    local name = npc:getName()
    if xi.guildShops.alias[name] ~= nil and not warnedMissing[name] then
        warnedMissing[name] = true
        printf('[guildShopSharing] %s aliased to %s but no shop config found', name, keyFor(npc))
    end
end

-----------------------------------
-- Ported helpers (math identical to scripts/globals/guild_shops.lua)
-----------------------------------

local priceFloorOf = function(cfg)
    return cfg.priceFloor or (cfg.maxStock * 3 / 4)
end

local calcBuyPrice = function(buyMax, priceFloor, maxStock, stock)
    local kneeRatio = 2 / 3
    if priceFloor <= 0 then
        return buyMax
    end

    local knee = kneeRatio * priceFloor
    if stock <= knee then
        return math.floor(buyMax * (125 - math.floor(150 * stock / priceFloor)) / 125)
    end

    return math.floor(buyMax * (200 - math.floor(100 * (stock - knee) / (maxStock - knee))) / 1000)
end

local calcSellPrice = function(base, maxStock, stock)
    if maxStock <= 0 then
        return math.floor(base * 3 / 2)
    end

    local index = math.floor(200 * stock / maxStock)
    return math.floor(base * (600 - index) / 400)
end

-- State is keyed by shop key, so aliased NPCs share one live state table.
local getShopState = function(key)
    local state = xi.guildShops.state[key]
    if state == nil then
        state =
        {
            lastRoll = -1,
            items    = {},
        }

        xi.guildShops.state[key] = state
    end

    return state
end

local shopConfig = function(shop, itemId)
    for _, cfg in ipairs(shop.stock) do
        if cfg.id == itemId then
            return cfg
        end
    end
end

local shopFor = function(npc)
    return xi.data.guildShops[keyFor(npc)]
end

local rejected = function(trade)
    return { itemNo = 0, count = 0, trade = trade }
end

local rollShopDay = function(key, shop)
    local state = getShopState(key)
    local today = VanadielUniqueDay()
    if state.lastRoll == today then
        return state
    end

    local firstRoll = state.lastRoll < 0
    local days      = firstRoll and 0 or (today - state.lastRoll)

    for _, cfg in ipairs(shop.stock) do
        local prev  = state.items[cfg.id]
        local stock = prev and prev.stock or cfg.initial

        if not firstRoll and cfg.restockRate > 0 and stock < cfg.targetStock then
            stock = math.min(cfg.targetStock, stock + cfg.restockRate * days)
        end

        stock = math.min(stock, cfg.targetStock)

        state.items[cfg.id] =
        {
            stock     = stock,
            buyPrice  = calcBuyPrice(cfg.buyMax, priceFloorOf(cfg), cfg.maxStock, stock),
            sellPrice = cfg.sellPrice or calcSellPrice(GetReadOnlyItem(cfg.id):getBasePrice(), cfg.maxStock, stock),
            offered   = stock > 0,
        }
    end

    state.lastRoll = today

    return state
end

local guildShopIsOpen = function(npc)
    local shop = shopFor(npc)
    if shop == nil then
        return false
    end

    local hour = VanadielHour()
    return hour >= shop.hours[1] and hour < shop.hours[2]
end

-----------------------------------
-- Overridden public entry points (shop-key aware)
-----------------------------------

m:addOverride('xi.guildShops.onTrigger', function(player, npc)
    local shop = shopFor(npc)
    if shop == nil then
        warnMissingShop(npc)
        return false
    end

    npc:facePlayer(player)
    rollShopDay(keyFor(npc), shop)

    return player:openGuildShop(npc, shop.hours[1], shop.hours[2])
end)

m:addOverride('xi.guildShops.onPlayerBuy', function(player, npc, itemId, quantity)
    local shop = shopFor(npc)

    if shop == nil or not guildShopIsOpen(npc) then
        return rejected(-1)
    end

    local cfg = shopConfig(shop, itemId)
    if cfg == nil then
        return rejected(-1)
    end

    local state = rollShopDay(keyFor(npc), shop)
    local item  = state.items[itemId]

    if not item.offered then
        return rejected(-1)
    end

    quantity = math.min(quantity, item.stock)
    if quantity <= 0 then
        return rejected(-1)
    end

    local cost = item.buyPrice * quantity
    if player:getGil() < cost then
        return rejected(-1)
    end

    if not player:addItem(itemId, quantity) then
        return rejected(-1)
    end

    player:delGil(cost)
    item.stock = item.stock - quantity

    return { itemNo = itemId, count = item.stock, trade = quantity }
end)

m:addOverride('xi.guildShops.onBuyList', function(player, npc)
    local shop = shopFor(npc)
    if shop == nil then
        return {}
    end

    local state = rollShopDay(keyFor(npc), shop)

    local items = {}
    for _, cfg in ipairs(shop.stock) do
        local item = state.items[cfg.id]
        if item.offered then
            items[#items + 1] =
            {
                id    = cfg.id,
                count = item.stock,
                price = item.buyPrice,
                max   = cfg.maxStock,
            }
        end
    end

    return items
end)

m:addOverride('xi.guildShops.onPlayerSell', function(player, npc, itemId, quantity)
    local shop = shopFor(npc)

    if shop == nil or not guildShopIsOpen(npc) then
        return rejected(-4)
    end

    local cfg = shopConfig(shop, itemId)
    if cfg == nil or cfg.noSell then
        return rejected(-4)
    end

    local state = rollShopDay(keyFor(npc), shop)
    local item  = state.items[itemId]

    local want   = math.min(quantity, cfg.maxStock - item.stock)
    local stacks = player:findItems(itemId, xi.inventoryLocation.INVENTORY)
    local sold   = 0
    for _ = 1, #stacks do
        local front = player:findItems(itemId, xi.inventoryLocation.INVENTORY)[1]
        local take  = front and math.min(want - sold, front:getQuantity() - front:getReservedValue()) or 0
        if take <= 0 then
            break
        end

        player:delItem(itemId, take)
        sold = sold + take
    end

    if sold <= 0 then
        return rejected(-4)
    end

    player:addGil(item.sellPrice * sold)
    item.stock = item.stock + sold

    local trade = (sold < quantity) and -1 or sold
    return { itemNo = itemId, count = item.stock, trade = trade, sold = sold, price = item.sellPrice }
end)

m:addOverride('xi.guildShops.onSellList', function(player, npc)
    local shop = shopFor(npc)
    if shop == nil then
        return {}
    end

    local state = rollShopDay(keyFor(npc), shop)

    local items = {}
    for _, cfg in ipairs(shop.stock) do
        if not cfg.noSell then
            local item  = state.items[cfg.id]
            local price = item.sellPrice
            if cfg.hidden then
                price = bit.bor(price, 0x80000000)
            end

            items[#items + 1] =
            {
                id    = cfg.id,
                count = item.stock,
                price = price,
                max   = cfg.maxStock,
            }
        end
    end

    return items
end)

m:addOverride('xi.guildShops.onGameHour', function(player, npc)
    local shop = shopFor(npc)
    if shop == nil then
        return
    end

    if VanadielHour() == shop.hours[2] then
        xi.guildShops.onShopClose(player, npc)
    end
end)

m:addOverride('xi.guildShops.onShopClose', function(player, npc)
    local shop = shopFor(npc)
    if shop ~= nil then
        player:sendGuildClose(shop.hours[1], shop.hours[2])
    end

    player:clearGuildShop()
end)

return m
