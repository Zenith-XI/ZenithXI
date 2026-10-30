-- ZenithXI era furnishing Moghancements (modules/zenith-public/sql/era_furnishing_moghancements.sql).
--
-- Eight modern furnishings no longer grant their Moghancement, and keep their elemental aura: with one of them
-- out, an Armor Box of a weaker element gets no Moghancement of its own, since the element balance stays theirs.

describe('Zenith era furnishing Moghancements', function()
    local cases =
    {
        { name = 'Stuffed Chocobo',      id = xi.item.STUFFED_CHOCOBO,      mods = { xi.mod.MOGHANCEMENT_GIL_BONUS_P } },
        { name = 'Prishe Statue',        id = xi.item.PRISHE_STATUE,        mods = { xi.mod.MOGHANCEMENT_GIL_BONUS_P } },
        { name = 'Harpsichord',          id = xi.item.HARPSICHORD,          mods = { xi.mod.MOGHANCEMENT_GIL_BONUS_P } },
        { name = 'Far East Hearth',      id = xi.item.FAR_EAST_HEARTH,      mods = { xi.mod.COMBAT_SKILLUP_RATE } },
        { name = 'Vana\'clock',          id = xi.item.VANACLOCK,            mods = { xi.mod.EXP_BONUS, xi.mod.CAPACITY_BONUS } },
        { name = 'Murrey Grisaille',     id = xi.item.MURREY_GRISAILLE,     mods = { xi.mod.EXP_BONUS } },
        { name = 'Moss Green Grisaille', id = xi.item.MOSS_GREEN_GRISAILLE, mods = { xi.mod.CAPACITY_BONUS } },
        { name = 'Aurum Coffer',         id = 3735,                         mods = { xi.mod.MOGHANCEMENT_GIL_BONUS_P } },
    }

    ---@type CClientEntityPair
    local player

    local function place(itemId, x)
        player:addItem(itemId)
        player.actions:moveItem(xi.inv.INVENTORY, player:findItem(itemId, xi.inv.INVENTORY):getSlotID(), xi.inv.MOGSAFE, 1)
        player.actions:placeFurniture(xi.inv.MOGSAFE, player:findItem(itemId, xi.inv.MOGSAFE):getSlotID(), x, 0)
        player.actions:finishFurnishing()
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.BASTOK_MARKETS })
        if player:isInEvent() then
            player.events:finish()
        end

        player:gotoMogHouse(xi.zone.BASTOK_MINES)
        if player:isInEvent() then
            player.events:finish()
        end
    end)

    for _, case in ipairs(cases) do
        describe(case.name, function()
            it('grants no Moghancement', function()
                place(case.id, 0)

                for _, mod in ipairs(case.mods) do
                    assert(player:getMod(mod) == 0, string.format('mod %d is %d', mod, player:getMod(mod)))
                end
            end)

            it('keeps its elemental aura', function()
                place(case.id, 0)
                place(xi.item.ARMOR_BOX, 6)

                assert(player:getMod(xi.mod.SYNTH_MATERIAL_LOSS_WATER) == 0, 'its aura lost to a weaker element')
            end)
        end)
    end

    it('leaves other furnishings their Moghancement', function()
        place(xi.item.ARMOR_BOX, 0)

        assert(player:getMod(xi.mod.SYNTH_MATERIAL_LOSS_WATER) == 10, 'Armor Box lost its Moghancement')
    end)

    it('leaves Prishe Statue II its Moghancement', function()
        place(xi.item.PRISHE_STATUE_II, 0)

        assert(player:getMod(xi.mod.SYNTH_MATERIAL_LOSS_FIRE) == 10, 'Prishe Statue II lost its Moghancement')
    end)
end)
