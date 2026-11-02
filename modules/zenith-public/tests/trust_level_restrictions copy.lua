-- ZenithXI trust level restrictions (modules/zenith-public/lua/4-additive/trusts/trust_level_restrictions.lua).
--
-- Brygid, Kuyin Hathdenna, Moogle and Star Sibyl can only be called at level 50 or above;
-- below that xi.trust.canCast returns -1. LSB has no level requirement for them.
-- The last case casts Brygid for real, so the trust spell's own casting check is what runs.

describe('Zenith trust level restrictions', function()
    ---@type CClientEntityPair
    local player

    local function canCast(spellId)
        return xi.trust.canCast(GetPlayerByID(player:getID()), GetSpell(spellId))
    end

    local function trustCount()
        local count = 0
        for _, member in ipairs(player:getPartyWithTrusts()) do
            if member:isTrust() then
                count = count + 1
            end
        end

        return count
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 49 })
        assert(player:getGMLevel() == 0, 'precondition: the test character is a GM, LSB lets GMs call anything')
        -- Shantotto is not restricted, so this also shows nothing else blocks a call here.
        assert(canCast(xi.magic.spell.SHANTOTTO) == 0, 'precondition: a level 49 player cannot call an unrestricted trust here')
    end)

    local restricted =
    {
        { name = 'Brygid',          spell = xi.magic.spell.BRYGID          },
        { name = 'Kuyin Hathdenna', spell = xi.magic.spell.KUYIN_HATHDENNA },
        { name = 'Moogle',          spell = xi.magic.spell.MOOGLE          },
        { name = 'Star Sibyl',      spell = xi.magic.spell.STAR_SIBYL      },
    }

    for _, row in ipairs(restricted) do
        it(string.format('refuses %s below level 50 and allows it at 50', row.name), function()
            local result = canCast(row.spell)
            assert(result == -1, string.format('expected a level 49 call of %s to be refused (-1), got %d', row.name, result))

            -- Control: at level 50 LSB and the module agree.
            player:setLevel(50)
            result = canCast(row.spell)
            assert(result == 0, string.format('expected a level 50 call of %s to be allowed, got %d', row.name, result))
        end)
    end

    it('summons Brygid from a real cast only once the player is level 50', function()
        local function castBrygid()
            player.actions:useSpell(player, xi.magic.spell.BRYGID)
            for _ = 1, 5 do
                xi.test.world:skipTime(2)
            end
        end

        player:addSpell(xi.magic.spell.BRYGID)

        castBrygid()
        assert(trustCount() == 0, 'a level 49 player summoned Brygid')

        -- The same cast at level 50 works, so the refusal above was the level and not the setup.
        player:setLevel(50)
        castBrygid()
        assert(trustCount() == 1, 'precondition: a level 50 cast of Brygid did not summon her')
    end)
end)
