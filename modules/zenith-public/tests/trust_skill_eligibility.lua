-- ZenithXI Trust level restrictions, ZENITHDEV-200 (modules/zenith-public/lua/2-base/trust_tp_skills.lua,
-- git patch 122-TrustLevelRestrictionsAndTesting.patch, modules/zenith-public/sql/add_weaponskills_trusts.sql).
--
-- Changes against LSB:
-- - No Trust weaponskill or TP skill below level 5. LSB lets a Trust use its whole TP list at any level.
-- - Player weaponskills, and the mob-skill copies of them (Trion, Semih, Maat), follow the normal
--   weaponskill skill requirement for the Trust's main job. LSB gives every listed skill at once.
-- - Unique skills: Zenith gates (Stellar 60, Lux 50, King Cobra Clamp 30, Bear Killer 24, Berserk-Ruf 40),
--   Royal Bash / Royal Savior follow Shield Bash / Sentinel, every other unique skill opens at level 5.
-- - Five fallback weaponskills (Kupipi, Curilla, Semih, Volker, Trion) are used from level 5 only until
--   their replacement is available; Halver gets Double Thrust, Leg Sweep, Raiden Thrust and Penta Thrust.
-- - Job abilities need the Trust's main job level, or its support job level (WAR support = level / 2).
--
-- The TP skill rules live in the module's xi.trust.canUseTpSkill, which the patched engine calls for each
-- skill when a Trust is summoned. The table cases call it directly; it relies on the patch's
-- hasLearnedWeaponskill / hasLearnedAbility answering for Trusts (LSB answers only for players), and
-- trust:hasLearnedAbility is the patch's gambit check itself. The "TP skills used in combat" cases summon
-- the Trust, engage a mob and record which TP skill it really performs, so they also fail if the engine
-- stops calling the hook. Expected levels come from the engine's skill caps (player:getMaxSkillLevel) and
-- data/weapon_skills.yaml: the first level whose cap for the Trust's main job reaches the weaponskill's
-- skill level (PLD sword: Burning Blade 30 at 9, Red Lotus Blade 50 at 16).

local weaponskill = xi.weaponskill
local ja          = xi.jobAbility
local mobSkill    = xi.mobSkill

-- Prishe: a unique skill with no Zenith gate (upstream has no enum for this Trust copy)
local nullifyingDropkick = 3234

-- { level, skill or ability id, expected, why }
local tpSkillCases =
{
    {
        trust = 'KUPIPI',
        checks =
        {
            { 4, weaponskill.SHINING_STRIKE, false, 'level 5 TP floor' },
            { 5, weaponskill.SHINING_STRIKE, true, 'fallback from level 5' },
            { 5, weaponskill.STARLIGHT, false, 'Starlight needs club 100' },
            { 33, weaponskill.SHINING_STRIKE, true, 'fallback until Starlight' },
            { 34, weaponskill.SHINING_STRIKE, false, 'fallback replaced by Starlight' },
            { 34, weaponskill.STARLIGHT, true, 'Starlight at 34' },
        },
    },
    {
        trust = 'CURILLA',
        checks =
        {
            { 4, weaponskill.BURNING_BLADE, false, 'level 5 TP floor' },
            { 5, weaponskill.BURNING_BLADE, true, 'fallback from level 5 (normally level 9)' },
            { 15, weaponskill.BURNING_BLADE, true, 'fallback until Red Lotus Blade' },
            { 15, weaponskill.RED_LOTUS_BLADE, false, 'Red Lotus Blade needs sword 50' },
            { 16, weaponskill.BURNING_BLADE, false, 'fallback replaced by Red Lotus Blade' },
            { 16, weaponskill.RED_LOTUS_BLADE, true, 'Red Lotus Blade at 16' },
            { 64, weaponskill.SWIFT_BLADE, false, 'Swift Blade needs sword 225' },
            { 65, weaponskill.SWIFT_BLADE, true, 'Swift Blade at 65' },
        },
    },
    {
        trust = 'TRION',
        checks =
        {
            { 5, weaponskill.BURNING_BLADE, true, 'fallback from level 5' },
            { 15, weaponskill.BURNING_BLADE, true, 'fallback until his Red Lotus Blade' },
            { 15, mobSkill.TRION_RED_LOTUS_BLADE, false, 'Red Lotus Blade copy follows sword 50' },
            { 16, weaponskill.BURNING_BLADE, false, 'fallback replaced by Red Lotus Blade' },
            { 16, mobSkill.TRION_RED_LOTUS_BLADE, true, 'Red Lotus Blade copy at 16' },
            { 23, mobSkill.TRION_FLAT_BLADE, false, 'Flat Blade copy follows sword 75' },
            { 24, mobSkill.TRION_FLAT_BLADE, true, 'Flat Blade copy at 24' },
            { 67, mobSkill.TRION_SAVAGE_BLADE, false, 'Savage Blade copy follows sword 240' },
            { 68, mobSkill.TRION_SAVAGE_BLADE, true, 'Savage Blade copy at 68' },
            { 14, mobSkill.ROYAL_BASH_TRUST, false, 'Royal Bash follows Shield Bash (PLD 15)' },
            { 15, mobSkill.ROYAL_BASH_TRUST, true, 'Royal Bash at 15' },
            { 29, mobSkill.ROYAL_SAVIOR_TRUST, false, 'Royal Savior follows Sentinel (PLD 30)' },
            { 30, mobSkill.ROYAL_SAVIOR_TRUST, true, 'Royal Savior at 30' },
        },
    },
    {
        trust = 'VOLKER',
        checks =
        {
            { 5, weaponskill.FAST_BLADE, true, 'fallback from level 5' },
            { 16, weaponskill.FAST_BLADE, true, 'fallback until Red Lotus Blade' },
            { 16, weaponskill.RED_LOTUS_BLADE, false, 'Red Lotus Blade needs sword 50 (WAR B)' },
            { 17, weaponskill.FAST_BLADE, false, 'fallback replaced by Red Lotus Blade' },
            { 17, weaponskill.RED_LOTUS_BLADE, true, 'Red Lotus Blade at 17' },
            { 72, weaponskill.SAVAGE_BLADE, false, 'Savage Blade needs sword 240' },
            { 73, weaponskill.SAVAGE_BLADE, true, 'Savage Blade at 73' },
            { 39, mobSkill.VOLKER_BERSERK, false, 'Berserk-Ruf gate 40' },
            { 40, mobSkill.VOLKER_BERSERK, true, 'Berserk-Ruf at 40' },
        },
    },
    {
        trust = 'SEMIH_LAFIHNA',
        checks =
        {
            { 4, mobSkill.FLAME_ARROW, false, 'level 5 TP floor' },
            { 5, mobSkill.FLAME_ARROW, true, 'Flaming Arrow fallback from level 5' },
            { 54, mobSkill.FLAME_ARROW, true, 'fallback until Sidewinder' },
            { 54, mobSkill.SEMIH_SIDEWINDER, false, 'Sidewinder copy follows archery 175' },
            { 55, mobSkill.FLAME_ARROW, false, 'fallback replaced by Sidewinder' },
            { 55, mobSkill.SEMIH_SIDEWINDER, true, 'Sidewinder copy at 55' },
            -- The engine's RNG archery cap is 223 at 65 and 227 at 66
            { 65, mobSkill.SEMIH_ARCHING_ARROW, false, 'Arching Arrow copy follows archery 225' },
            { 66, mobSkill.SEMIH_ARCHING_ARROW, true, 'Arching Arrow copy at 66' },
            { 49, mobSkill.LUX_ARROW, false, 'Lux Arrow gate 50' },
            { 50, mobSkill.LUX_ARROW, true, 'Lux Arrow at 50' },
            { 59, mobSkill.STELLAR_ARROW, false, 'Stellar Arrow gate 60' },
            { 60, mobSkill.STELLAR_ARROW, true, 'Stellar Arrow at 60' },
        },
    },
    {
        trust = 'NANAA_MIHGO',
        checks =
        {
            { 4, weaponskill.WASP_STING, false, 'level 5 TP floor' },
            { 5, weaponskill.WASP_STING, true, 'Wasp Sting at 5' },
            { 59, weaponskill.DANCING_EDGE, false, 'Dancing Edge needs dagger 200' },
            { 60, weaponskill.DANCING_EDGE, true, 'Dancing Edge at 60' },
            { 29, mobSkill.KING_COBRA_CLAMP, false, 'King Cobra Clamp gate 30' },
            { 30, mobSkill.KING_COBRA_CLAMP, true, 'King Cobra Clamp at 30' },
        },
    },
    {
        trust = 'MAAT',
        checks =
        {
            { 4, mobSkill.MAAT_COMBO, false, 'level 5 TP floor' },
            { 5, mobSkill.MAAT_COMBO, true, 'Combo copy at 5' },
            { 23, mobSkill.MAAT_ONE_INCH_PUNCH, false, 'One Inch Punch copy follows hand-to-hand 75' },
            { 24, mobSkill.MAAT_ONE_INCH_PUNCH, true, 'One Inch Punch copy at 24' },
            { 23, mobSkill.BEAR_KILLER, false, 'Bear Killer gate 24' },
            { 24, mobSkill.BEAR_KILLER, true, 'Bear Killer at 24' },
            { 69, mobSkill.MAAT_ASURAN_FISTS, false, 'Asuran Fists copy follows hand-to-hand 250' },
            { 70, mobSkill.MAAT_ASURAN_FISTS, true, 'Asuran Fists copy at 70' },
        },
    },
    {
        trust = 'AYAME',
        checks =
        {
            { 4, weaponskill.TACHI_ENPI, false, 'level 5 TP floor' },
            { 5, weaponskill.TACHI_ENPI, true, 'Tachi: Enpi at 5' },
            { 22, weaponskill.TACHI_GOTEN, false, 'Tachi: Goten needs great katana 70' },
            { 23, weaponskill.TACHI_GOTEN, true, 'Tachi: Goten at 23' },
            { 69, weaponskill.TACHI_KASHA, false, 'Tachi: Kasha needs great katana 250' },
            { 70, weaponskill.TACHI_KASHA, true, 'Tachi: Kasha at 70' },
        },
    },
    {
        trust = 'HALVER',
        checks =
        {
            { 4, weaponskill.DOUBLE_THRUST, false, 'level 5 TP floor' },
            { 5, weaponskill.DOUBLE_THRUST, true, 'Double Thrust at 5' },
            { 27, weaponskill.RAIDEN_THRUST, false, 'Raiden Thrust needs polearm 70 (PLD E)' },
            { 28, weaponskill.RAIDEN_THRUST, true, 'Raiden Thrust at 28' },
            { 39, weaponskill.LEG_SWEEP, false, 'Leg Sweep needs polearm 100' },
            { 40, weaponskill.LEG_SWEEP, true, 'Leg Sweep at 40' },
            { 55, weaponskill.PENTA_THRUST, false, 'Penta Thrust needs polearm 150' },
            { 56, weaponskill.PENTA_THRUST, true, 'Penta Thrust at 56' },
        },
    },
    {
        trust = 'EXCENMILLE',
        checks =
        {
            { 39, weaponskill.LEG_SWEEP, false, 'Leg Sweep needs polearm 100' },
            { 40, weaponskill.LEG_SWEEP, true, 'Leg Sweep at 40' },
        },
    },
    {
        trust = 'IRON_EATER',
        checks =
        {
            { 4, weaponskill.SHIELD_BREAK, false, 'level 5 TP floor' },
            { 5, weaponskill.SHIELD_BREAK, true, 'Shield Break at 5' },
            -- Great axe, his main job's weapon: the Trust's own combat skill type is sword
            { 67, weaponskill.STEEL_CYCLONE, false, 'Steel Cyclone needs great axe 240' },
            { 68, weaponskill.STEEL_CYCLONE, true, 'Steel Cyclone at 68' },
        },
    },
    {
        trust = 'PRISHE',
        checks =
        {
            { 4, nullifyingDropkick, false, 'level 5 TP floor' },
            { 5, nullifyingDropkick, true, 'ungated unique skill opens at level 5' },
            { 75, nullifyingDropkick, true, 'ungated unique skill stays available' },
        },
    },
}

local abilityCases =
{
    {
        trust = 'TRION', -- PLD/WAR
        checks =
        {
            { 9, ja.PROVOKE, false, 'Provoke comes from WAR support (5), support level is half' },
            { 10, ja.PROVOKE, true, 'Provoke at 10' },
            { 29, ja.SENTINEL, false, 'Sentinel PLD 30' },
            { 30, ja.SENTINEL, true, 'Sentinel at 30' },
        },
    },
    {
        trust = 'HALVER', -- PLD/WAR
        checks =
        {
            { 29, ja.BERSERK, false, 'Berserk comes from WAR support (15)' },
            { 30, ja.BERSERK, true, 'Berserk at 30' },
            { 29, ja.SENTINEL, false, 'Sentinel PLD 30' },
            { 30, ja.SENTINEL, true, 'Sentinel at 30' },
        },
    },
    {
        trust = 'CURILLA',
        checks =
        {
            { 29, ja.SENTINEL, false, 'Sentinel PLD 30' },
            { 30, ja.SENTINEL, true, 'Sentinel at 30' },
        },
    },
    {
        trust = 'AYAME',
        checks =
        {
            { 14, ja.THIRD_EYE, false, 'Third Eye SAM 15' },
            { 15, ja.THIRD_EYE, true, 'Third Eye at 15' },
            { 24, ja.HASSO, false, 'Hasso SAM 25' },
            { 25, ja.HASSO, true, 'Hasso at 25' },
            { 29, ja.MEDITATE, false, 'Meditate SAM 30' },
            { 30, ja.MEDITATE, true, 'Meditate at 30' },
        },
    },
    {
        trust = 'SEMIH_LAFIHNA',
        checks =
        {
            { 29, ja.BARRAGE, false, 'Barrage RNG 30' },
            { 30, ja.BARRAGE, true, 'Barrage at 30' },
            { 74, ja.DOUBLE_SHOT, false, 'Double Shot is level 75 in Zenith data' },
            { 75, ja.DOUBLE_SHOT, true, 'Double Shot at 75' },
        },
    },
    {
        trust = 'NANAA_MIHGO',
        checks =
        {
            { 59, ja.DESPOIL, false, 'Despoil is level 60 in Zenith data' },
            { 60, ja.DESPOIL, true, 'Despoil at 60' },
        },
    },
    {
        trust = 'VOLKER',
        checks =
        {
            { 14, ja.BERSERK, false, 'Berserk WAR 15' },
            { 15, ja.BERSERK, true, 'Berserk at 15' },
            { 44, ja.AGGRESSOR, false, 'Aggressor WAR 45' },
            { 45, ja.AGGRESSOR, true, 'Aggressor at 45' },
        },
    },
}

describe('Zenith trust skill eligibility #trusts', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
    end)

    local function summon(trustName, level)
        player:clearTrusts()
        player:setLevel(level)

        local trust = player:spawnTrust(xi.magic.spell[trustName])
        assert(trust ~= nil, string.format('precondition: %s did not spawn', trustName))
        assert(trust:getMainLvl() == level, string.format('precondition: %s is level %d, expected %d', trustName, trust:getMainLvl(), level))

        return trust
    end

    local function runChecks(trustName, checks, query, kind)
        for _, check in ipairs(checks) do
            local level, id, expected, why = check[1], check[2], check[3], check[4]
            local trust  = summon(trustName, level)
            local actual = query(trust, id)

            assert(actual == expected, string.format('%s level %d, %s %d: expected %s, got %s (%s)',
                trustName, level, kind, id, tostring(expected), tostring(actual), why))
        end
    end

    for _, case in ipairs(tpSkillCases) do
        it(string.format('gates %s TP skills by level', case.trust), function()
            assert(type(xi.trust.canUseTpSkill) == 'function', 'xi.trust.canUseTpSkill is missing: lua/2-base/trust_tp_skills.lua did not load')
            runChecks(case.trust, case.checks, function(trust, id)
                return xi.trust.canUseTpSkill(trust, id)
            end, 'TP skill')
        end)
    end

    for _, case in ipairs(abilityCases) do
        it(string.format('gates %s job abilities by job level', case.trust), function()
            runChecks(case.trust, case.checks, function(trust, id)
                return trust:hasLearnedAbility(id)
            end, 'ability')
        end)
    end

    it('defines the Stellar Arrow and Lux Arrow mob skill enums', function()
        assert(mobSkill.STELLAR_ARROW == 3489, string.format('expected STELLAR_ARROW 3489, got %s', tostring(mobSkill.STELLAR_ARROW)))
        assert(mobSkill.LUX_ARROW == 3490, string.format('expected LUX_ARROW 3490, got %s', tostring(mobSkill.LUX_ARROW)))
    end)

    describe('TP skills used in combat', function()
        ---@type CTestEntity
        local mob

        before_each(function()
            -- Trusts engage with the master instead of waiting for the master's first swing
            player:setCharVar('TrustEngageType', 1)

            mob = player.entities:moveTo('Wild_Rabbit')
            mob:respawn()
            mob:setUnkillable(true)
        end)

        -- Leave West Ronfaure as other tests expect it: no trusts out and a fresh rabbit with no enmity,
        -- or the next player (who may reuse this character ID) cannot call a trust.
        after_each(function()
            player:clearTrusts()
            mob:setUnkillable(false)
            mob:respawn()
        end)

        -- Summons the Trust at the level, engages the rabbit and records each TP skill it performs,
        -- topping its TP up every second, until it has used `wanted` skills or `seconds` pass.
        local function observeTpSkills(trustName, level, wanted, seconds, stopAt)
            local trust = summon(trustName, level)
            local used  = {}

            trust:setTrustTPSkillSettings(ai.tp.ASAP, ai.s.RANDOM, 0)
            trust:addListener('WEAPONSKILL_STATE_EXIT', 'ZENITH_TEST_TP_SKILL', function(entity, skillId, completed)
                table.insert(used, skillId)
            end)

            player.actions:engage(mob)
            for _ = 1, 5 do
                xi.test.world:skipTime(1)
            end

            assert(trust:isEngaged(), string.format('precondition: %s did not engage the mob', trustName))

            for _ = 1, seconds do
                if #used >= wanted or (stopAt and used[#used] == stopAt) then
                    break
                end

                player:setHP(player:getMaxHP())
                trust:setHP(trust:getMaxHP())
                trust:setTP(3000)
                xi.test.world:skipTime(1)
            end

            trust:removeListener('ZENITH_TEST_TP_SKILL')

            return used
        end

        local function describeUsed(used)
            local ids = {}
            for _, id in ipairs(used) do
                table.insert(ids, tostring(id))
            end

            return '{' .. table.concat(ids, ', ') .. '}'
        end

        it('uses no TP skill below level 5', function()
            local used = observeTpSkills('KUPIPI', 4, 1, 15)

            assert(#used == 0, string.format('a level 4 Kupipi used TP skills %s', describeUsed(used)))
        end)

        -- At level 5 the fallback is the only skill each of these Trusts is eligible for. Four uses, so a
        -- random pick from LSB's full list cannot pass by chance (Kupipi: 1 in 81).
        local fallbacks =
        {
            { 'KUPIPI', weaponskill.SHINING_STRIKE },
            { 'CURILLA', weaponskill.BURNING_BLADE },
            { 'TRION', weaponskill.BURNING_BLADE },
            { 'VOLKER', weaponskill.FAST_BLADE },
            { 'SEMIH_LAFIHNA', mobSkill.FLAME_ARROW },
        }

        for _, fallback in ipairs(fallbacks) do
            it(string.format('uses only the fallback TP skill for %s at level 5', fallback[1]), function()
                local used = observeTpSkills(fallback[1], 5, 4, 40)

                assert(#used >= 1, string.format('a level 5 %s used no TP skill', fallback[1]))
                for _, id in ipairs(used) do
                    assert(id == fallback[2], string.format('a level 5 %s used %s, expected only %d', fallback[1], describeUsed(used), fallback[2]))
                end
            end)
        end

        it('drops the Curilla fallback once Red Lotus Blade is available', function()
            local used = observeTpSkills('CURILLA', 16, 4, 40)

            assert(#used >= 1, 'a level 16 Curilla used no TP skill')
            for _, id in ipairs(used) do
                assert(id == weaponskill.RED_LOTUS_BLADE, string.format('a level 16 Curilla used %s, expected only Red Lotus Blade', describeUsed(used)))
            end
        end)

        it('gives Naji no fallback before Burning Blade', function()
            local used = observeTpSkills('NAJI', 5, 1, 15)

            assert(#used == 0, string.format('a level 5 Naji used TP skills %s; he has no fallback', describeUsed(used)))
        end)

        it('gives Halver Leg Sweep at level 40 and holds Penta Thrust back', function()
            local used = observeTpSkills('HALVER', 40, 20, 120, weaponskill.LEG_SWEEP)

            local seen = {}
            for _, id in ipairs(used) do
                seen[id] = true
            end

            assert(not seen[weaponskill.PENTA_THRUST], string.format('a level 40 Halver used Penta Thrust: %s', describeUsed(used)))
            assert(seen[weaponskill.LEG_SWEEP], string.format('a level 40 Halver never used Leg Sweep: %s', describeUsed(used)))
        end)
    end)
end)
