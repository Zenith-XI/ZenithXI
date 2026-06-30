/************************************************************************
 * SpawnGroupBindings
 * Adds entity bindings to allow mob:getSpawnGroupID and mob:setSpawnGroup
 * to be used in mob's onMobInitialize function
 ************************************************************************/
#include "map/utils/moduleutils.h"

class SpawnGroupBindings : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        lua["CBaseEntity"]["getSpawnGroupID"] = [](CLuaBaseEntity* PLuaBaseEntity) -> std::optional<uint32_t>
        {
            if (!PLuaBaseEntity)
            {
                return std::nullopt;
            }

            auto PMob = dynamic_cast<CMobEntity*>(PLuaBaseEntity->GetBaseEntity());
            if (!PMob || !PMob->m_spawnGroup)
            {
                return std::nullopt;
            }

            return PMob->m_spawnGroup->getGroupID();
        };

        lua["CBaseEntity"]["setSpawnGroup"] = [](CLuaBaseEntity* PLuaBaseEntity, uint32_t spawnGroupID, uint32 maxspawns) -> void
        {
            if (!PLuaBaseEntity)
            {
                return;
            }

            auto PMob = dynamic_cast<CMobEntity*>(PLuaBaseEntity->GetBaseEntity());
            if (!(PMob && PMob->loc.zone && PMob->targid < 0x700))
            {
                ShowWarning("Attempting to set spawn group for invalid entity type (%s).", PLuaBaseEntity->getName());
                return;
            }

            auto zone   = PMob->loc.zone;
            auto zoneID = zone->GetID();
            // Mostly copy from zoneutils spawn-group building
            if (PMob->m_spawnGroup)
            {
                ShowError(fmt::format("Mob {} ID {} in zone {} is being added to a spawn group, but it's already in a group!", PMob->packetName, PMob->id, zoneID));
                return;
            }

            if (!zone->m_spawnGroups.contains(spawnGroupID))
            {
                zone->m_spawnGroups.insert(std::make_pair(spawnGroupID, new spawnGroup(maxspawns, zoneID, spawnGroupID)));
            }
            auto* spawnGroup = zone->m_spawnGroups.at(spawnGroupID).get();
            if (spawnGroup)
            {
                PMob->m_spawnGroup = spawnGroup;
                spawnGroup->addMember(PMob->targid);

                if (PMob->m_SpawnType == SPAWNTYPE_SCRIPTED)
                {
                    ShowError(fmt::format("Mob {} ID {} in zone {} is set to SPAWNTYPE_SCRIPTED AND is in a group. This is not compatible and has been updated!", PMob->packetName, PMob->id, zoneID));
                    PMob->m_SpawnType = SPAWNTYPE_NORMAL;
                }

                if (PMob->m_RespawnTime <= 0s)
                {
                    ShowError(fmt::format("Mob {} ID {} in zone {} has a respawn time of 0s AND is in a group. This is not compatible and has been updated!", PMob->packetName, PMob->id, zoneID));
                    PMob->m_RespawnTime = 5min;
                }
            }
            else
            {
                ShowError(fmt::format("Could not get Spawn Group!"));
            }

            if (PMob->m_spawnGroup)
            {
                // ensure spawn group is randomized including this mob
                PMob->m_spawnGroup->resetPool();
            }
        };
    }
};

REGISTER_CPP_MODULE(SpawnGroupBindings);
