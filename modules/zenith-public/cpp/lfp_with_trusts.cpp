/************************************************************************
 * LFP With Trusts Module
 *
 * This module allows players to toggle LFP status while trusts are
 * deployed, bypassing client-side restrictions.
 *
 * Exposes player:setSeekingParty(value) method binding to Lua.
 ************************************************************************/
#include "map/utils/moduleutils.h"

#include "common/lua.h"
#include "map/entities/charentity.h"
#include "map/lua/lua_baseentity.h"
#include "map/packets/char_status.h"
#include "map/packets/char_sync.h"
#include "map/packets/s2c/0x0b4_config.h"
#include "map/utils/charutils.h"

class LfpWithTrustsModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        // Bind setSeekingParty as a method on CBaseEntity
        // Usage: player:setSeekingParty(true/false)
        lua["CBaseEntity"]["setSeekingParty"] = [](CLuaBaseEntity* PLuaEntity, bool value) -> bool
        {
            TracyZoneScoped;

            if (PLuaEntity == nullptr)
            {
                return false;
            }

            CBaseEntity* PEntity = PLuaEntity->GetBaseEntity();
            if (PEntity == nullptr || PEntity->objtype != TYPE_PC)
            {
                return false;
            }

            auto* PChar = static_cast<CCharEntity*>(PEntity);

            if (PChar->playerConfig.InviteFlg != value)
            {
                PChar->playerConfig.InviteFlg = value;
                PChar->updatemask |= UPDATE_HP;
                charutils::SaveCharStats(PChar);
                charutils::SavePlayerSettings(PChar);
                PChar->pushPacket<GP_SERV_COMMAND_CONFIG>(PChar);
                PChar->pushPacket<CCharStatusPacket>(PChar);
                PChar->pushPacket<CCharSyncPacket>(PChar);
            }

            return true;
        };
    }
};

REGISTER_CPP_MODULE(LfpWithTrustsModule);
