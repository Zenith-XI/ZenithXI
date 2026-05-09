/************************************************************************
 * Clear Teleport Binding
 *************************************************************************
 * Copyright (c) 2026 ZenithXI Dev Teams
 *************************************************************************
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://www.gnu.org/licenses/
 *************************************************************************
 * Adds a `clearTeleport` method to the CBaseEntity Lua usertype so that
 * Lua scripts (e.g., the !resetoutpost GM command) can lock previously
 * unlocked teleport bits without requiring a patch against
 * src/map/lua/lua_baseentity.{h,cpp}.
 *
 * Usage from Lua:
 *   target:clearTeleport(teleType)            -- zero out an entire field
 *   target:clearTeleport(teleType, bitval)    -- clear a single bit (1 << bitval)
 *
 * Supported types: OUTPOST_*, RUNIC_PORTAL, PAST_MAW, CAMPAIGN_*
 ************************************************************************/
#include "common/lua.h"
#include "map/entities/charentity.h"
#include "map/lua/lua_baseentity.h"
#include "map/utils/charutils.h"
#include "map/utils/moduleutils.h"
#include "map/zone.h"

class ClearTeleportBindingModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        // Lua: target:clearTeleport(teleType, [bitval])
        lua["CBaseEntity"]["clearTeleport"] = [](CLuaBaseEntity* PLuaEntity, uint8 teleType, sol::object const& bitvalObj) -> void
        {
            TracyZoneScoped;

            if (PLuaEntity == nullptr)
            {
                return;
            }

            CBaseEntity* PEntity = PLuaEntity->GetBaseEntity();
            if (PEntity == nullptr || PEntity->objtype != TYPE_PC)
            {
                return;
            }

            auto* PChar = static_cast<CCharEntity*>(PEntity);
            auto  type  = static_cast<TELEPORT_TYPE>(teleType);

            if (bitvalObj == sol::lua_nil)
            {
                switch (type)
                {
                    case TELEPORT_TYPE::OUTPOST_SANDY:
                        PChar->teleport.outpostSandy = 0;
                        break;
                    case TELEPORT_TYPE::OUTPOST_BASTOK:
                        PChar->teleport.outpostBastok = 0;
                        break;
                    case TELEPORT_TYPE::OUTPOST_WINDY:
                        PChar->teleport.outpostWindy = 0;
                        break;
                    case TELEPORT_TYPE::RUNIC_PORTAL:
                        PChar->teleport.runicPortal = 0;
                        break;
                    case TELEPORT_TYPE::PAST_MAW:
                        PChar->teleport.pastMaw = 0;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_SANDY:
                        PChar->teleport.campaignSandy = 0;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_BASTOK:
                        PChar->teleport.campaignBastok = 0;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_WINDY:
                        PChar->teleport.campaignWindy = 0;
                        break;
                    default:
                        ShowError("CBaseEntity::clearTeleport : Parameter 1 out of bounds.");
                        return;
                }
            }
            else
            {
                uint32 bit = 1u << bitvalObj.as<uint32>();
                switch (type)
                {
                    case TELEPORT_TYPE::OUTPOST_SANDY:
                        PChar->teleport.outpostSandy &= ~bit;
                        break;
                    case TELEPORT_TYPE::OUTPOST_BASTOK:
                        PChar->teleport.outpostBastok &= ~bit;
                        break;
                    case TELEPORT_TYPE::OUTPOST_WINDY:
                        PChar->teleport.outpostWindy &= ~bit;
                        break;
                    case TELEPORT_TYPE::RUNIC_PORTAL:
                        PChar->teleport.runicPortal &= ~bit;
                        break;
                    case TELEPORT_TYPE::PAST_MAW:
                        PChar->teleport.pastMaw &= ~bit;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_SANDY:
                        PChar->teleport.campaignSandy &= ~bit;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_BASTOK:
                        PChar->teleport.campaignBastok &= ~bit;
                        break;
                    case TELEPORT_TYPE::CAMPAIGN_WINDY:
                        PChar->teleport.campaignWindy &= ~bit;
                        break;
                    default:
                        ShowError("CBaseEntity::clearTeleport : Parameter 1 out of bounds.");
                        return;
                }
            }

            charutils::SaveTeleport(PChar, type);
        };
    }
};

REGISTER_CPP_MODULE(ClearTeleportBindingModule);
