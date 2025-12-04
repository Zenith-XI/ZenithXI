/*
===========================================================================

  Copyright (c) 2024 ZenithXI Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

/************************************************************************
 * GM Account Bindings Module
 *
 * This module provides Lua bindings for account-based zone restriction
 * enforcement. It allows the Lua zone restriction module to query
 * account IDs and linked accounts from the gm_account_bindings table.
 *
 * Exposes:
 *   - GetAccountIdFromCharId(charId) - Global function
 *   - GetLinkedAccountIds(accountId) - Global function
 *   - player:getAccountId() - Entity method
 ************************************************************************/
#include "map/utils/moduleutils.h"

#include "common/database.h"
#include "common/lua.h"
#include "map/entities/charentity.h"
#include "map/lua/lua_baseentity.h"

class GMAccountBindingsModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        // Global function: GetAccountIdFromCharId(charId)
        // Returns the account ID for a given character ID
        // Usage: local accountId = GetAccountIdFromCharId(charId)
        lua["GetAccountIdFromCharId"] = [](uint32 charId) -> uint32
        {
            TracyZoneScoped;

            if (charId == 0)
            {
                return 0;
            }

            const auto rset = db::preparedStmt(
                "SELECT accid FROM chars WHERE charid = ? LIMIT 1",
                charId);

            if (rset && rset->rowsCount() && rset->next())
            {
                return rset->get<uint32>("accid");
            }

            return 0;
        };

        // Global function: GetLinkedAccountIds(accountId)
        // Returns a table of linked account IDs from gm_account_bindings
        // Queries both directions: where this account is the GM or the personal account
        // Usage: local linkedAccounts = GetLinkedAccountIds(accountId)
        lua["GetLinkedAccountIds"] = [](sol::this_state s, uint32 accountId) -> sol::table
        {
            TracyZoneScoped;

            sol::state_view luaState(s);
            auto            table = luaState.create_table();

            if (accountId == 0)
            {
                return table;
            }

            // Query for linked accounts in both directions
            // If accountId is the GM, return the personal accounts
            // If accountId is the personal account, return the GM accounts
            const auto rset = db::preparedStmt(
                "SELECT "
                "  CASE WHEN gm_account_id = ? THEN personal_account_id "
                "  ELSE gm_account_id END AS linked_id "
                "FROM gm_account_bindings "
                "WHERE gm_account_id = ? OR personal_account_id = ?",
                accountId,
                accountId,
                accountId);

            if (rset && rset->rowsCount())
            {
                while (rset->next())
                {
                    table.add(rset->get<uint32>("linked_id"));
                }
            }

            return table;
        };

        // Entity method: player:getAccountId()
        // Returns the account ID for a player entity
        // Usage: local accountId = player:getAccountId()
        lua["CBaseEntity"]["getAccountId"] = [](CLuaBaseEntity* PLuaEntity) -> uint32
        {
            TracyZoneScoped;

            if (PLuaEntity == nullptr)
            {
                return 0;
            }

            CBaseEntity* PEntity = PLuaEntity->GetBaseEntity();
            if (PEntity == nullptr || PEntity->objtype != TYPE_PC)
            {
                return 0;
            }

            auto* PChar = static_cast<CCharEntity*>(PEntity);
            return PChar->accid;
        };
    }
};

REGISTER_CPP_MODULE(GMAccountBindingsModule);
