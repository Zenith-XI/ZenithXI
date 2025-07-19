local m = Module:new('xolotl_pet_logic')

local isSummoning = false
local petResummonTime = 180

local spawnPet = function(mob, pet, spawnPos)
    if pet == nil or mob == nil then return end

    isSummoning = true
    -- Fake a Summoning animation
    mob:entityAnimationPacket(xi.animationString.CAST_SUMMONER_START)
    mob:timer(5000, function(mob)
        mob:entityAnimationPacket(xi.animationString.CAST_SUMMONER_STOP)
        pet:setSpawn(spawnPos.x + 2, spawnPos.y, spawnPos.z, spawnPos.rot)
        pet:spawn()
        if mob:isEngaged() then pet:updateEnmity(mob:getTarget()) end
        pet:follow(mob, xi.followType.ROAM);
        isSummoning = false
    end)
end

local handlePetResummonTimer = function(mob)
    local xolotlID = mob:getID()

    if GetSystemTime() >=
        (GetServerVariable('[XOLOTL]HoundTOD') + petResummonTime) then
        if not GetMobByID(xolotlID + 1):isSpawned() and not isSummoning then
            spawnPet(mob, GetMobByID(xolotlID + 1), mob:getPos())
        end
    end

    if GetSystemTime() >=
        (GetServerVariable('[XOLOTL]SacrificeTOD') + petResummonTime) then
        if not GetMobByID(xolotlID + 2):isSpawned() and not isSummoning then
            spawnPet(mob, GetMobByID(xolotlID + 2), mob:getPos())
        end
    end
end

-- Placeholder for Superlink logic
local handleGroupAggro = function(xolotlID, target)
    -- This function needs the Xolotl ID as mobid to loop through the group
    for i = xolotlID, xolotlID + 2 do
        local m = GetMobByID(i)

        if m and m:getCurrentAction() == xi.act.ROAMING then
            m:updateEnmity(target)
        end
    end
end

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotl.onMobFight',
              function(mob, target)
    super(mob)
    handlePetResummonTimer(mob)
    handleGroupAggro(mob:getID(), target)
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotl.onMobRoam', function(mob)
    super(mob)
    handlePetResummonTimer(mob)
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Hound_Warrior.onMobDespawn',
              function(mob)
    super(mob)
    SetServerVariable('[XOLOTL]HoundTOD', GetSystemTime())
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Sacrifice.onMobDespawn',
              function(mob)
    super(mob)
    SetServerVariable('[XOLOTL]SacrificeTOD', GetSystemTime())
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Hound_Warrior.onMobRoam',
              function(mob)
    super(mob)
    local xolotl = GetMobByID(mob:getID() - 1)
    mob:follow(xolotl, xi.followType.ROAM)

    if mob and mob:getCurrentAction() == xi.act.ROAMING and
        not xolotl:isSpawned() then DespawnMob(mob:getID())
    end
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Sacrifice.onMobRoam',
              function(mob)
    super(mob)
    local xolotl = GetMobByID(mob:getID() - 2)
    mob:follow(xolotl, xi.followType.ROAM)

    if mob and mob:getCurrentAction() == xi.act.ROAMING and
        not xolotl:isSpawned() then DespawnMob(mob:getID())
    end

end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Hound_Warrior.onMobFight',
              function(mob, target)
    super(mob)
    local xolotlID = mob:getID() - 1
    handleGroupAggro(xolotlID, target)
end)

m:addOverride('xi.zones.Attohwa_Chasm.mobs.Xolotls_Sacrifice.onMobFight',
              function(mob, target)
    super(mob)
    local xolotlID = mob:getID() - 2
    handleGroupAggro(xolotlID, target)
end)

return m
