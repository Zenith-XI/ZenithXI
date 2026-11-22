-----------------------------------
-- NPC content tags
--
-- Replaces modules/zenith-public/sql/npc_expansion_tags.sql, which stopped
-- doing anything when upstream moved zone NPCs out of `npc_list` and into
-- data/zones/<zone>/npcs.yaml (3b73f021e4). It rewrote `npc_list.content_tag`
-- for 29 NPCs; that column is only read for instanced zones now.
--
-- How content gating works now: each yaml NPC carries an optional `content:`
-- key (data/enums/content.yaml). zoneutils::InsertNPCs() asks
-- luautils::IsContentEnabled(), which is false only when RESTRICT_CONTENT is on
-- and ENABLE_<TAG> is off. A gated NPC is moved to x = y = z = 0, set to
-- status DISAPPEAR and taken off widescan. xi.pre(xi.expansion.<TAG>) is the
-- same predicate, so it is what this module asks. With RESTRICT_CONTENT = 0,
-- the shipped default, no gate fires and this module changes nothing.
--
-- The yaml tags differ from the ones the SQL set, so there are two jobs:
--   * Tag COP / SOA: hide the NPC when that expansion is off (same effect as the
--     engine's own gate). Guild Point NPCs are yaml `rotz`, Crafter Point NPCs
--     are yaml `rov` (Yek_Falimeygo is already `soa`).
--   * Tag false (the SQL's NULL): the NPC is always available. The yaml tags
--     Trust NPCs `trust_quests` and Explorer Moogles `wotg`, so when the engine
--     hid one of those, or hid a COP / SOA NPC whose own tag is enabled, this
--     puts it back.
-- Putting back means undoing exactly what the engine did: restoring x, y, z (the
-- rotation is never touched) and, when `status` is given, the yaml status.
-- A NPC is only touched while it sits at the origin, which is where the
-- engine's gate leaves it.
--
-- Limits:
--   * Widescan cannot be restored: Lua has no binding for it, so a put-back NPC
--     stays off widescan until the next normal load.
--   * x, y, z are copies of the yaml `at` values and must match
--     data/zones/<zone>/npcs.yaml. NPCs are looked up by id and the name is
--     checked. When the name does not match (LSB renumbers NPCs on retail
--     updates), the zone's only NPC with that name is used and a line asks for
--     the table to be updated; a name that is missing or not unique (the two
--     RuLude_Gardens Explorer_Moogles) is skipped with a log line instead.
--   * Explorer_Moogle has no `status`: whether it shows is up to
--     xi.server.setExplorerMoogles() (EXPLORER_MOOGLE_LV), which runs inside
--     Zone.onInitialize before this does. 17772773 (RuLude_Gardens) has no such
--     script, so its yaml status is restored.
--   * Where a tag is stricter in the yaml than in the SQL (rotz vs cop, rov vs
--     soa) and the later expansion is off but the earlier one is on, the engine
--     hides the NPC and this puts it back, which is what the SQL did.
--
-- Public module for ZenithXI
-----------------------------------
require('modules/module_utils')

local m = Module:new('c-n_npc_content_tags')

-----------------------------------
-- Zone script name -> npcid -> entry
--   name   = NPC script name, checked against the entity
--   tag    = ENABLE_<tag> that gates the NPC, or false for always available
--   x/y/z  = yaml `at` position
--   status = yaml status to restore, when it is not left to a script
-----------------------------------
local contentNpcs =
{
    ['Southern_San_dOria'] =
    {
        [17719548] = { name = 'Alivatand',       tag = 'COP', x = -179.458, y = -1.0,    z =   15.857, status = xi.status.NORMAL }, -- Guild Point: Leathercraft
        [17720013] = { name = 'Wolden-Bolden',   tag = 'SOA', x = -182.96,  y = -2.0,    z =   -0.3,   status = xi.status.NORMAL }, -- Crafter Point: Leathercraft
        [17719985] = { name = 'Gondebaud',       tag = false, x =  123.754, y =  0.0,    z =   92.125, status = xi.status.NORMAL }, -- Trust
    },

    ['Northern_San_dOria'] =
    {
        [17723627] = { name = 'Macuillie',       tag = 'COP', x = -191.738, y = 11.001,  z =  138.656, status = xi.status.NORMAL }, -- Guild Point: Smithing
        [17723628] = { name = 'Andreas',         tag = 'COP', x = -189.282, y = 10.999,  z =  262.626, status = xi.status.NORMAL }, -- Guild Point: Woodworking
        [17723851] = { name = 'Ore_Guzzler',     tag = 'SOA', x = -180.0,   y = 12.0,    z =  143.0,   status = xi.status.NORMAL }, -- Crafter Point: Smithing
        [17723850] = { name = 'Luren',           tag = 'SOA', x = -171.71,  y = 12.0,    z =  258.7,   status = xi.status.NORMAL }, -- Crafter Point: Woodworking
        [17723648] = { name = 'Explorer_Moogle', tag = false, x =  116.44,  y = -0.199,  z =   -8.459 },
    },

    ['Bastok_Mines'] =
    {
        [17735810] = { name = 'Hemewmew',        tag = 'COP', x =  117.97,  y =  2.017,  z =  -10.438, status = xi.status.NORMAL }, -- Guild Point: Alchemy
        [17736062] = { name = 'Yek_Falimeygo',   tag = 'SOA', x =  121.26,  y =  2.0,    z =   -2.67,  status = xi.status.NORMAL }, -- Crafter Point: Alchemy
        [17735856] = { name = 'Explorer_Moogle', tag = false, x =   81.646, y =  0.0,    z =  -64.102 },
    },

    ['Bastok_Markets'] =
    {
        [17739917] = { name = 'Ellard',          tag = 'COP', x = -214.355, y = -6.814,  z =  -63.809, status = xi.status.NORMAL }, -- Guild Point: Goldsmithing
        [17740210] = { name = 'Puyutete',        tag = 'SOA', x = -215.72,  y = -6.82,   z =  -55.53,  status = xi.status.NORMAL }, -- Crafter Point: Goldsmithing
    },

    ['Port_Bastok'] =
    {
        [17744189] = { name = 'Clarion_Star',    tag = false, x =   81.478, y =  7.5,    z =  -24.169, status = xi.status.NORMAL }, -- Trust
    },

    ['Metalworks'] =
    {
        [17748091] = { name = 'Lorena',          tag = 'COP', x = -104.99,  y =  2.0,    z =   30.995, status = xi.status.NORMAL }, -- Guild Point: Smithing
        [17748196] = { name = 'Esvin',           tag = 'SOA', x = -111.85,  y =  2.53,   z =   22.45,  status = xi.status.NORMAL }, -- Crafter Point: Smithing
    },

    ['Windurst_Waters'] =
    {
        [17752313] = { name = 'Qhum_Knaidjn',    tag = 'COP', x = -112.561, y = -2.0,    z =   55.205, status = xi.status.NORMAL }, -- Guild Point: Cooking
        [17752575] = { name = 'Isanie',          tag = 'SOA', x = -119.16,  y = -2.0,    z =   50.1,   status = xi.status.NORMAL }, -- Crafter Point: Cooking
    },

    ['Port_Windurst'] =
    {
        [17760444] = { name = 'Fennella',        tag = 'COP', x = -177.811, y = -2.835,  z =   65.639, status = xi.status.NORMAL }, -- Guild Point: Fishing
        [17760450] = { name = 'Explorer_Moogle', tag = false, x =  183.24,  y = -11.999, z =  217.73 },
    },

    ['Windurst_Woods'] =
    {
        [17764583] = { name = 'Samigo-Pormigo',  tag = 'COP', x =   -9.782, y = -5.249,  z = -134.432, status = xi.status.NORMAL }, -- Guild Point: Bonecraft
        [17764584] = { name = 'Hauh_Colphioh',   tag = 'COP', x =  -38.173, y = -1.25,   z = -113.679, status = xi.status.NORMAL }, -- Guild Point: Clothcraft
        [17764827] = { name = 'Tergil',          tag = 'SOA', x =   -1.61,  y = -5.25,   z = -133.81,  status = xi.status.NORMAL }, -- Crafter Point: Bonecraft
        [17764826] = { name = 'Julissois',       tag = 'SOA', x =  -34.74,  y = -1.25,   z = -122.74,  status = xi.status.NORMAL }, -- Crafter Point: Clothcraft
        [17764794] = { name = 'Wetata',          tag = false, x =  -23.825, y =  2.533,  z =  -44.567, status = xi.status.NORMAL }, -- Trust
    },

    ['RuLude_Gardens'] =
    {
        [17772772] = { name = 'Explorer_Moogle', tag = false, x =    1.0,   y =  0.0,    z =    0.0 },
        [17772773] = { name = 'Explorer_Moogle', tag = false, x =   -5.687, y =  8.999,  z =  -41.341, status = xi.status.NORMAL },
    },

    ['Selbina'] =
    {
        [17793131] = { name = 'Explorer_Moogle', tag = false, x =   10.41,  y = -14.558, z =   62.831 },
    },

    ['Mhaura'] =
    {
        [17797253] = { name = 'Explorer_Moogle', tag = false, x =    6.227, y = -4.0,    z =   71.938 },
    },
}

-- The NPC an entry means: the one at npcId when its name matches, otherwise (LSB
-- renumbered it) the zone's only NPC with that name, otherwise nil
local function findNpc(zone, npcId, name)
    local npc = GetNPCByID(npcId)

    if npc and npc:getName() == name then
        return npc
    end

    local matches = {}

    for _, entity in ipairs(zone:queryEntitiesByName(name)) do
        if entity:getObjType() == xi.objType.NPC then
            table.insert(matches, entity)
        end
    end

    if #matches == 1 then
        print(fmt('[NpcContentTags] {} is NPC {} now, not {}; update the table', name, matches[1]:getID(), npcId))
        return matches[1]
    end

    print(fmt('[NpcContentTags] NPC {} is not {} and {} NPCs have that name; skipped', npcId, name, #matches))
    return nil
end

local function applyContentTags(npcs, zone)
    for npcId, entry in pairs(npcs) do
        local npc = findNpc(zone, npcId, entry.name)

        if npc and entry.tag and xi.pre(xi.expansion[entry.tag]) then
            -- The tag the SQL set is gated off: hide it the way the engine hides gated NPCs
            npc:setStatus(xi.status.DISAPPEAR)
            npc:setPos(0, 0, 0)
        elseif
            npc and
            npc:getXPos() == 0 and
            npc:getYPos() == 0 and
            npc:getZPos() == 0
        then
            -- The engine hid it for its own yaml tag, which the SQL replaced: put it back
            npc:setPos(entry.x, entry.y, entry.z)

            if entry.status then
                npc:setStatus(entry.status)
            end
        end
    end
end

for zoneName, npcs in pairs(contentNpcs) do
    m:addOverride(string.format('xi.zones.%s.Zone.onInitialize', zoneName), function(zone)
        super(zone)

        applyContentTags(npcs, zone)
    end)
end

return m
