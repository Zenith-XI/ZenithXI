-----------------------------------
-- func: erascalingtest
-- desc: Test era attribute scaling (C++ implementation)
--       Compares calculated era multipliers to actual in-game stats
--       to verify the C++ era scaling patch is working correctly
-- usage: !erascalingtest [playername]
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 5,
    parameters = 's',
}

-----------------------------------
-- Era Scaling Configuration
-- Must match values in battleentity.cpp GetEraScaledMultiplier calls
-----------------------------------
local eraConfig =
{
    -- STR -> ATT
    twoHandedStrAtt   = { start = 0.75, endVal = 0.75 },  -- Flat 0.75
    handToHandStrAtt  = { start = 0.50, endVal = 0.625 }, -- 0.5 -> 0.625
    oneHandMainStrAtt = { start = 0.50, endVal = 0.75 },  -- 0.5 -> 0.75
    oneHandOffStrAtt  = { start = 0.50, endVal = 0.50 },  -- Flat 0.5
    rangedStrAtt      = { start = 0.50, endVal = 0.625 }, -- 0.5 -> 0.625
    -- DEX -> ACC
    twoHandedDexAcc   = { start = 0.75, endVal = 0.75 },  -- Flat 0.75
    handToHandDexAcc  = { start = 0.50, endVal = 0.75 },  -- 0.5 -> 0.75
    oneHandMainDexAcc = { start = 0.50, endVal = 0.75 },  -- 0.5 -> 0.75
    oneHandOffDexAcc  = { start = 0.50, endVal = 0.75 },  -- 0.5 -> 0.75
    -- AGI -> RACC
    rangedAgiRacc     = { start = 0.50, endVal = 0.75 },  -- 0.5 -> 0.75
    -- VIT -> DEF
    playerVitDef      = { start = 0.50, endVal = 1.00 },  -- 0.5 -> 1.0
}

-----------------------------------
-- Skill type to readable name mapping
-----------------------------------
local skillNames =
{
    [xi.skill.HAND_TO_HAND] = 'Hand-to-Hand',
    [xi.skill.DAGGER]       = 'Dagger',
    [xi.skill.SWORD]        = 'Sword',
    [xi.skill.GREAT_SWORD]  = 'Great Sword',
    [xi.skill.AXE]          = 'Axe',
    [xi.skill.GREAT_AXE]    = 'Great Axe',
    [xi.skill.SCYTHE]       = 'Scythe',
    [xi.skill.POLEARM]      = 'Polearm',
    [xi.skill.KATANA]       = 'Katana',
    [xi.skill.GREAT_KATANA] = 'Great Katana',
    [xi.skill.CLUB]         = 'Club',
    [xi.skill.STAFF]        = 'Staff',
    [xi.skill.ARCHERY]      = 'Archery',
    [xi.skill.MARKSMANSHIP] = 'Marksmanship',
    [xi.skill.THROWING]     = 'Throwing',
}

-----------------------------------
-- Helper: Get skill name from type
-----------------------------------
local function getSkillName(skillType)
    return skillNames[skillType] or 'Unknown'
end

-----------------------------------
-- Helper: Resolve target (self, cursor, or named player)
-----------------------------------
local function resolveTarget(player, targetName)
    if targetName and targetName ~= '' then
        local target = GetPlayerByName(targetName)
        if target == nil then
            player:printToPlayer(
                string.format('Player [%s] not found or not online.', targetName),
                xi.msg.channel.SYSTEM_3
            )
            return nil
        end

        return target
    end

    -- Try cursor target first
    local cursorTarget = player:getCursorTarget()
    if cursorTarget and cursorTarget:getObjType() == xi.objType.PC then
        return cursorTarget
    end

    -- Fall back to self
    return player
end

-----------------------------------
-- Helper: Calculate era scaling value (matches C++ formula)
-----------------------------------
local function getEraScaledMultiplier(level, startValue, endValue)
    if level < 37 then
        return startValue
    elseif level >= 75 then
        return endValue
    else
        return startValue + (endValue - startValue) * ((level - 37) / 38.0)
    end
end

-----------------------------------
-- Helper: Calculate level-based DEF factor (from C++)
-----------------------------------
local function getLevelDefFactor(level)
    if level < 51 then
        return level
    elseif level < 61 then
        return 2 * level - 42
    elseif level < 91 then
        return level + 18
    else
        return level + 18 + math.floor((level - 89) / 2)
    end
end

-----------------------------------
-- Helper: Detect weapon type and get scaling keys
-----------------------------------
local function detectWeaponType(target)
    local mainWeapon = target:getEquippedItem(xi.slot.MAIN)
    local weaponType = 'None'
    local attScalingKey = nil
    local accScalingKey = nil
    local skillName = ''

    if mainWeapon then
        local skillType = mainWeapon:getSkillType()
        skillName = getSkillName(skillType)

        if mainWeapon:isTwoHanded() then
            weaponType = 'Two-Handed'
            attScalingKey = 'twoHandedStrAtt'
            accScalingKey = 'twoHandedDexAcc'
        elseif mainWeapon:isHandToHand() or skillType == xi.skill.HAND_TO_HAND then
            weaponType = 'Hand-to-Hand'
            attScalingKey = 'handToHandStrAtt'
            accScalingKey = 'handToHandDexAcc'
        else
            weaponType = 'One-Handed'
            attScalingKey = 'oneHandMainStrAtt'
            accScalingKey = 'oneHandMainDexAcc'
        end
    end

    return weaponType, skillName, attScalingKey, accScalingKey
end

-----------------------------------
-- Helper: Check if ranged weapon equipped
-----------------------------------
local function hasRangedWeapon(target)
    local rangedWeapon = target:getEquippedItem(xi.slot.RANGED)
    if rangedWeapon then
        local skillType = rangedWeapon:getSkillType()
        return true, getSkillName(skillType)
    end

    return false, 'None'
end

-----------------------------------
-- Helper: Calculate expected DEF and compare
-----------------------------------
local function testDEF(player, target, level, vit, actualDef)
    local config = eraConfig.playerVitDef
    local vitMultiplier = getEraScaledMultiplier(level, config.start, config.endVal)
    local vitContrib = math.floor(vit * vitMultiplier)
    local levelFactor = getLevelDefFactor(level)

    -- Get the raw DEF mod (gear, traits, effects, etc.)
    local defMod = target:getMod(xi.mod.DEF)

    -- Expected DEF = 8 + levelFactor + vitContrib + mods
    local expectedBaseDef = 8 + levelFactor + vitContrib
    local expectedTotalDef = expectedBaseDef + defMod

    -- Compare actual to expected total (including mods)
    local diff = actualDef - expectedTotalDef
    local passed = math.abs(diff) <= 2 -- Allow small rounding tolerance

    player:printToPlayer('--- DEF Test (VIT -> DEF) ---', xi.msg.channel.SYSTEM_3)
    player:printToPlayer(
        string.format('  VIT: %d | Multiplier: %.3f | VIT contrib: %d',
            vit, vitMultiplier, vitContrib),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  Base=8 + LevelFactor=%d + VITcontrib=%d = %d',
            levelFactor, vitContrib, expectedBaseDef),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  DEF Mod (gear/traits): %+d', defMod),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  Expected total: %d + (%+d) = %d | Actual: %d | Diff: %+d',
            expectedBaseDef, defMod, expectedTotalDef, actualDef, diff),
        xi.msg.channel.SYSTEM_3
    )

    if passed then
        if diff == 0 then
            player:printToPlayer('  [PASS] DEF matches exactly!', xi.msg.channel.SYSTEM_3)
        else
            player:printToPlayer(
                string.format('  [PASS] DEF within tolerance (diff=%+d)', diff),
                xi.msg.channel.SYSTEM_3
            )
        end
    else
        player:printToPlayer(
            string.format('  [FAIL] DEF mismatch by %+d (check for missing mods)', diff),
            xi.msg.channel.SYSTEM_3
        )
    end

    return passed, diff
end

-----------------------------------
-- Helper: Test ATT contribution
-----------------------------------
local function testATT(player, level, str, attKey, actualAtt)
    if not attKey then
        player:printToPlayer('--- ATT Test (STR -> ATT) ---', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('  [SKIP] No main weapon equipped', xi.msg.channel.SYSTEM_3)
        return true, 0
    end

    local config = eraConfig[attKey]
    local strMultiplier = getEraScaledMultiplier(level, config.start, config.endVal)
    local strContrib = math.floor(str * strMultiplier)

    -- ATT includes: 8 + strContrib + weaponSkill + mods
    -- We just verify strContrib is reasonable
    local minExpected = 8 + strContrib
    local passed = actualAtt >= minExpected
    local diff = actualAtt - minExpected

    player:printToPlayer('--- ATT Test (STR -> ATT) ---', xi.msg.channel.SYSTEM_3)
    player:printToPlayer(
        string.format('  STR: %d | Multiplier: %.3f | STR contrib: %d',
            str, strMultiplier, strContrib),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  Min expected (8+STR): %d | Actual ATT: %d | Diff: %+d',
            minExpected, actualAtt, diff),
        xi.msg.channel.SYSTEM_3
    )

    if passed then
        player:printToPlayer(
            string.format('  [PASS] ATT >= minimum (diff=%d from skill/gear)', diff),
            xi.msg.channel.SYSTEM_3
        )
    else
        player:printToPlayer(
            string.format('  [FAIL] ATT is LOWER than minimum by %d!', -diff),
            xi.msg.channel.SYSTEM_3
        )
    end

    return passed, diff
end

-----------------------------------
-- Helper: Test ACC contribution
-----------------------------------
local function testACC(player, level, dex, accKey, actualAcc)
    if not accKey then
        player:printToPlayer('--- ACC Test (DEX -> ACC) ---', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('  [SKIP] No main weapon equipped', xi.msg.channel.SYSTEM_3)
        return true, 0
    end

    local config = eraConfig[accKey]
    local dexMultiplier = getEraScaledMultiplier(level, config.start, config.endVal)
    local dexContrib = math.floor(dex * dexMultiplier)

    -- ACC includes: skill + dexContrib + mods
    -- We just verify dexContrib is part of the total
    local passed = actualAcc >= dexContrib

    player:printToPlayer('--- ACC Test (DEX -> ACC) ---', xi.msg.channel.SYSTEM_3)
    player:printToPlayer(
        string.format('  DEX: %d | Multiplier: %.3f | DEX contrib: %d',
            dex, dexMultiplier, dexContrib),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  DEX contrib: %d | Actual ACC: %d',
            dexContrib, actualAcc),
        xi.msg.channel.SYSTEM_3
    )

    if passed then
        player:printToPlayer(
            string.format('  [PASS] ACC includes DEX contribution'),
            xi.msg.channel.SYSTEM_3
        )
    else
        player:printToPlayer(
            string.format('  [FAIL] ACC seems too low!'),
            xi.msg.channel.SYSTEM_3
        )
    end

    return passed, actualAcc - dexContrib
end

-----------------------------------
-- Helper: Test RATT contribution
-----------------------------------
local function testRATT(player, level, str, hasRanged, actualRatt)
    if not hasRanged then
        player:printToPlayer('--- RATT Test (STR -> RATT) ---', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('  [SKIP] No ranged weapon equipped', xi.msg.channel.SYSTEM_3)
        return true, 0
    end

    local config = eraConfig.rangedStrAtt
    local strMultiplier = getEraScaledMultiplier(level, config.start, config.endVal)
    local strContrib = math.floor(str * strMultiplier)

    local minExpected = 8 + strContrib
    local passed = actualRatt >= minExpected

    player:printToPlayer('--- RATT Test (STR -> RATT) ---', xi.msg.channel.SYSTEM_3)
    player:printToPlayer(
        string.format('  STR: %d | Multiplier: %.3f | STR contrib: %d',
            str, strMultiplier, strContrib),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  Min expected: %d | Actual RATT: %d',
            minExpected, actualRatt),
        xi.msg.channel.SYSTEM_3
    )

    if passed then
        player:printToPlayer('  [PASS] RATT >= minimum', xi.msg.channel.SYSTEM_3)
    else
        player:printToPlayer('  [FAIL] RATT is too low!', xi.msg.channel.SYSTEM_3)
    end

    return passed, actualRatt - minExpected
end

-----------------------------------
-- Helper: Test RACC contribution
-----------------------------------
local function testRACC(player, level, agi, hasRanged, actualRacc)
    if not hasRanged then
        player:printToPlayer('--- RACC Test (AGI -> RACC) ---', xi.msg.channel.SYSTEM_3)
        player:printToPlayer('  [SKIP] No ranged weapon equipped', xi.msg.channel.SYSTEM_3)
        return true, 0
    end

    local config = eraConfig.rangedAgiRacc
    local agiMultiplier = getEraScaledMultiplier(level, config.start, config.endVal)
    local agiContrib = math.floor(agi * agiMultiplier)

    local passed = actualRacc >= agiContrib

    player:printToPlayer('--- RACC Test (AGI -> RACC) ---', xi.msg.channel.SYSTEM_3)
    player:printToPlayer(
        string.format('  AGI: %d | Multiplier: %.3f | AGI contrib: %d',
            agi, agiMultiplier, agiContrib),
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer(
        string.format('  AGI contrib: %d | Actual RACC: %d',
            agiContrib, actualRacc),
        xi.msg.channel.SYSTEM_3
    )

    if passed then
        player:printToPlayer('  [PASS] RACC includes AGI contribution', xi.msg.channel.SYSTEM_3)
    else
        player:printToPlayer('  [FAIL] RACC seems too low!', xi.msg.channel.SYSTEM_3)
    end

    return passed, actualRacc - agiContrib
end

-----------------------------------
-- Main command trigger
-----------------------------------
commandObj.onTrigger = function(player, targetName)
    local target = resolveTarget(player, targetName)
    if target == nil then
        return
    end

    local targetNameStr = target:getName()
    local level = target:getMainLvl()

    -- Get base stats
    local str = target:getStat(xi.mod.STR)
    local dex = target:getStat(xi.mod.DEX)
    local agi = target:getStat(xi.mod.AGI)
    local vit = target:getStat(xi.mod.VIT)

    -- Get actual combat stats
    local actualAtt = target:getStat(xi.mod.ATT)
    local actualAcc = target:getStat(xi.mod.ACC)
    local actualDef = target:getStat(xi.mod.DEF)
    local actualRatt = target:getStat(xi.mod.RATT)
    local actualRacc = target:getStat(xi.mod.RACC)

    -- Get weapon info
    local weaponType, skillName, attScalingKey, accScalingKey = detectWeaponType(target)
    local hasRanged, rangedSkill = hasRangedWeapon(target)

    -- Print header
    player:printToPlayer(
        '============ Era Scaling Test (C++) ============',
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        string.format('Target: %s | Level: %d', targetNameStr, level),
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        string.format('Base Stats: STR=%d DEX=%d AGI=%d VIT=%d', str, dex, agi, vit),
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        string.format('Combat Stats: ATT=%d ACC=%d DEF=%d RATT=%d RACC=%d',
            actualAtt, actualAcc, actualDef, actualRatt, actualRacc),
        xi.msg.channel.SYSTEM_3
    )

    local weaponDisplay = weaponType
    if skillName ~= '' then
        weaponDisplay = string.format('%s (%s)', weaponType, skillName)
    end

    player:printToPlayer(
        string.format('Weapon: %s | Ranged: %s', weaponDisplay, hasRanged and rangedSkill or 'None'),
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        '================================================',
        xi.msg.channel.SYSTEM_3
    )

    -- Track test results
    local testsPassed = 0
    local testsTotal = 0

    -- Test DEF (most reliable since formula is well-known)
    testsTotal = testsTotal + 1
    local defPass = testDEF(player, target, level, vit, actualDef)
    if defPass then
        testsPassed = testsPassed + 1
    end

    -- Test ATT
    testsTotal = testsTotal + 1
    local attPass = testATT(player, level, str, attScalingKey, actualAtt)
    if attPass then
        testsPassed = testsPassed + 1
    end

    -- Test ACC
    testsTotal = testsTotal + 1
    local accPass = testACC(player, level, dex, accScalingKey, actualAcc)
    if accPass then
        testsPassed = testsPassed + 1
    end

    -- Test RATT if ranged equipped
    if hasRanged then
        testsTotal = testsTotal + 1
        local rattPass = testRATT(player, level, str, hasRanged, actualRatt)
        if rattPass then
            testsPassed = testsPassed + 1
        end

        testsTotal = testsTotal + 1
        local raccPass = testRACC(player, level, agi, hasRanged, actualRacc)
        if raccPass then
            testsPassed = testsPassed + 1
        end
    end

    -- Print summary
    player:printToPlayer(
        '================================================',
        xi.msg.channel.SYSTEM_3
    )

    local summaryStatus = (testsPassed == testsTotal) and 'ALL PASSED' or 'SOME FAILED'
    player:printToPlayer(
        string.format('SUMMARY: %d/%d tests PASSED (%s)', testsPassed, testsTotal, summaryStatus),
        xi.msg.channel.SYSTEM_3
    )

    -- Show era scaling info for current level
    player:printToPlayer(
        '------------------------------------------------',
        xi.msg.channel.SYSTEM_3
    )
    player:printToPlayer('Era Multipliers at current level:', xi.msg.channel.SYSTEM_3)

    local vitMult = getEraScaledMultiplier(level, eraConfig.playerVitDef.start, eraConfig.playerVitDef.endVal)
    player:printToPlayer(
        string.format('  VIT->DEF: %.3f (%.2f @ L<37, %.2f @ L75+)',
            vitMult, eraConfig.playerVitDef.start, eraConfig.playerVitDef.endVal),
        xi.msg.channel.SYSTEM_3
    )

    if attScalingKey then
        local cfg = eraConfig[attScalingKey]
        local mult = getEraScaledMultiplier(level, cfg.start, cfg.endVal)
        player:printToPlayer(
            string.format('  STR->ATT: %.3f (%.2f @ L<37, %.2f @ L75+)',
                mult, cfg.start, cfg.endVal),
            xi.msg.channel.SYSTEM_3
        )
    end

    if accScalingKey then
        local cfg = eraConfig[accScalingKey]
        local mult = getEraScaledMultiplier(level, cfg.start, cfg.endVal)
        player:printToPlayer(
            string.format('  DEX->ACC: %.3f (%.2f @ L<37, %.2f @ L75+)',
                mult, cfg.start, cfg.endVal),
            xi.msg.channel.SYSTEM_3
        )
    end

    player:printToPlayer(
        '================================================',
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        'Tip: Test at L30, L50, L75 to verify scaling.',
        xi.msg.channel.SYSTEM_3
    )

    player:printToPlayer(
        'Tip: Unequip all gear for cleanest DEF test.',
        xi.msg.channel.SYSTEM_3
    )
end

return commandObj
