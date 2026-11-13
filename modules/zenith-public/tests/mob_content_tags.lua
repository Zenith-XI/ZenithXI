-- ZenithXI monster content tags (modules/zenith-public/data/zones/*/mobs.yaml, ZENITHDEV-287).
--
-- The YAML overlays apply the Zenith All Tagged Monsters Review to LSB's mob templates: 203 of the
-- 426 tagged templates lose their content gate (content: none) and 47 move from wotg to rotz, cop
-- or toau. The other 176 keep their tag. A zone inserts only the mobs whose template content is
-- enabled, and it does that once, when the zone first loads. xi_test loads zones lazily, so each
-- case switches RESTRICT_CONTENT on, turns off the expansions named in its row, and then enters the
-- zone for the first time.
--
-- The zones were picked so that the gate hides nothing another test file uses: in the first four,
-- the templates below are the only mobs or NPCs carrying the gated tags, and no other test file
-- enters Halvung or Arrapago Reef. A precondition fails the case if its zone was loaded earlier.
--
-- Bites without the overlays for every mob marked 'loads': LSB keeps the wotg/abyssea/rov tag, so
-- the gate removes it. The 'gated' rows (a retag with its own expansion off, and kept tags) are
-- gated with or without the overlays; they guard against the overlay lifting more than it should.

describe('Zenith monster content tags', function()
    local loads = true
    local gated = false

    local zoneCases =
    {
        {
            name  = 'lifts the abyssea and wotg gates in Outer Horutoto Ruins',
            zone  = xi.zone.OUTER_HORUTOTO_RUINS,
            off   = { 'ABYSSEA', 'WOTG' },
            on    = {},
            mobs  =
            {
                { 'Fetor_Bats',        17571874, loads },
                { 'Fuligo',            17571883, loads },
                { 'Thorn_Bat',         17571904, loads },
                { 'Ah_Puch',           17571903, loads },
                { 'Desmodont',         17571870, loads },
                { 'Legalox_Heftyhind', 17571873, loads },
            },
        },
        {
            name  = 'lifts abyssea and moves Lizardtrap to toau in Aydeewa Subterrane',
            zone  = xi.zone.AYDEEWA_SUBTERRANE,
            off   = { 'ABYSSEA', 'WOTG' },
            on    = { 'TOAU' },
            mobs  =
            {
                { 'Deforester',  17055868, loads },
                { 'Mycoskulker', 17056019, loads },
                { 'Slime_Eater', 17056096, loads },
                { 'Lizardtrap',  17056140, loads },
            },
        },
        {
            name  = 'moves Autarch from wotg to rotz in Upper Delkfutt\'s Tower',
            zone  = xi.zone.UPPER_DELKFUTTS_TOWER,
            off   = { 'WOTG' },
            on    = { 'ROTZ' },
            mobs  =
            {
                { 'Autarch', 17424488, loads },
            },
        },
        {
            name  = 'moves three NMs from wotg to cop in Castle Zvahl Baileys',
            zone  = xi.zone.CASTLE_ZVAHL_BAILEYS,
            off   = { 'WOTG' },
            on    = { 'COP' },
            mobs  =
            {
                { 'Likho',            17436714, loads },
                { 'Marquis_Naberius', 17436876, loads },
                { 'Marquis_Sabnock',  17436881, loads },
            },
        },
        {
            name  = 'keeps a toau retag and a kept wotg tag gated in Halvung',
            zone  = xi.zone.HALVUNG,
            off   = { 'TOAU', 'WOTG' },
            on    = {},
            mobs  =
            {
                { 'Copper_Borer', 17031220, gated },
                { 'Flammeri',     17031312, gated },
            },
        },
        {
            name  = 'lifts abyssea and rov but keeps Euryale on wotg in Arrapago Reef',
            zone  = xi.zone.ARRAPAGO_REEF,
            off   = { 'ABYSSEA', 'ROV', 'WOTG' },
            on    = { 'TOAU' },
            mobs  =
            {
                { 'Dweomershell',   16998744, loads },
                { 'Nirgali',        16998618, loads },
                { 'Nostokulshedra', 16998669, loads },
                { 'Euryale',        16998696, gated },
            },
        },
    }

    for _, case in ipairs(zoneCases) do
        it(case.name, function()
            assert(GetZone(case.zone) == nil, string.format('precondition: zone %d was loaded before this case set its content gates', case.zone))

            xi.test.world:setSetting('main.RESTRICT_CONTENT', true)
            for _, expansion in ipairs(case.off) do
                xi.test.world:setSetting('main.ENABLE_' .. expansion, false)
            end

            for _, expansion in ipairs(case.on) do
                xi.test.world:setSetting('main.ENABLE_' .. expansion, true)
            end

            xi.test.world:spawnPlayer({ zone = case.zone })
            assert(GetZone(case.zone) ~= nil, string.format('precondition: zone %d did not load', case.zone))

            local wrong = {}
            for _, row in ipairs(case.mobs) do
                local name, id, expected = row[1], row[2], row[3]
                local mob                = GetEntityByID(id, nil, true)

                if expected and mob == nil then
                    table.insert(wrong, string.format('%s (%d) was gated out', name, id))
                elseif expected and mob:getName() ~= name then
                    table.insert(wrong, string.format('precondition: %d is %s, not %s', id, mob:getName(), name))
                elseif not expected and mob ~= nil then
                    table.insert(wrong, string.format('%s (%d) loaded with its expansion off', name, id))
                end
            end

            assert(#wrong == 0, table.concat(wrong, '; '))
        end)
    end
end)
