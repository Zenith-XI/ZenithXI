/************************************************************************
 * Fishing Fatigue
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
 * This module implements fishing fatigue, which limits the number of fish
 * a player can catch in a day. The regular limit is 200 fish/items as
 * per retail, but is limited to 20 fish/items for new accounts until
 * they have reached a required rank in any of the three nations.
 *
 * The amount of fish caught is tracked in the player's char_vars, and
 * resets at JST midnight. We inspect the Fishing Minigame 2 Packet
 * (0x110) and check if minigame sends the NewFishingCaught
 * animation. If the character had hooked a small/big fish or an item
 * as well, we increase the char_var by 1.
 *
 * Limiting the fishing action is done by inspecting the Player Action
 * packet (0x01A) to see if the player is attempting a Fish Action (0x0E).
 * If the daily cap was reached, we set the lastCastTime to 600 seconds in
 * the future. This will cause the FishingAction to automatically fail
 * into CatchNothing. A message will be sent to the player informing them
 * the limit has been reached.
 *
 * This script will allow for players to resume fishing after Ranking
 * up their nation and changing zones, up to the new limit. Changing
 * Allegiance won't cause you to lose your unlocked 200 daily cap.
 ************************************************************************/
#include "map/utils/charutils.h"
#include "map/utils/fishingutils.h"
#include "map/utils/moduleutils.h"
#include <enums/chat_message_type.h>
#include <packets/c2s/0x066_fishing.h>
#include <packets/c2s/0x110_fishing_2.h>
#include <packets/s2c/0x017_chat_std.h>

class FishingFatigueModule : public CPPModule
{
    void OnInit() override
    {
    }

    auto OnIncomingPacket(MapSession* session, CCharEntity* PChar, CBasicPacket& packet) -> bool override
    {
        TracyZoneScoped;

        std::string CAUGHT = "[FISHING]CAUGHT";

        // player fishing start action
        if (packet.getType() == 0x01A)
        {
            const auto typedPacket = packet.as<GP_CLI_COMMAND_ACTION>();
            // Only intercept for fishing action
            if (static_cast<GP_CLI_COMMAND_ACTION_ACTIONID>(typedPacket->ActionID) != GP_CLI_COMMAND_ACTION_ACTIONID::Fish)
            {
                return false;
            }

            TracyZoneScoped;

            // process the main packet first
            typedPacket->process(session, PChar);

            // Check if player has reached fishing limit, and if so cause the minigame to not catch anything
            uint16       caughtToday   = charutils::GetCharVar(PChar, CAUGHT);
            const uint8  RANK_REQUIRED = 3;
            const uint16 FISHING_LOWER = 20;  // Lower limit for fishing (when conditions not met)
            const uint16 FISHING_UPPER = 200; // Upper limit for fishing

            uint8 rankSandoria           = PChar->profile.rank[NATION_SANDORIA];
            uint8 rankBastok             = PChar->profile.rank[NATION_BASTOK];
            uint8 rankWindurst           = PChar->profile.rank[NATION_WINDURST];
            bool  isSufficientNationRank = (rankSandoria >= RANK_REQUIRED || rankBastok >= RANK_REQUIRED || rankWindurst >= RANK_REQUIRED);

            uint16 limit = isSufficientNationRank ? FISHING_UPPER : FISHING_LOWER;

            if (caughtToday >= limit)
            {
                if (PChar->GetLocalVar("FishingFatigueMessage") == 0)
                {
                    PChar->pushPacket<GP_SERV_COMMAND_CHAT_STD>(PChar, MESSAGE_SYSTEM_3, fmt::format("You have reached your daily fishing limit. "));
                    PChar->SetLocalVar("FishingFatigueMessage", 1);
                }
                PChar->lastCastTime += 600; // ensure first FISHACTION_CHECK auto fails and they catch nothing
            }

            // block running other modules/main packet process function
            return true;
        }

        // When player ends fishing the minigame
        if (packet.getType() == 0x110)
        {
            const auto typedPacket = packet.as<GP_CLI_COMMAND_FISHING_2>();
            // Only intercept for minigame completion action
            if (static_cast<GP_CLI_COMMAND_FISHING_2_MODE>(typedPacket->mode) != GP_CLI_COMMAND_FISHING_2_MODE::RequestEndMiniGame)
            {
                return false;
            }

            TracyZoneScoped;

            // process the main packet first
            typedPacket->process(session, PChar);

            // Increment caught fish if something was hooked
            // The engine only ever sets NewFishingCaught (not the legacy FishingCaught) when a catch resolves
            const auto animationID = PChar->animation;
            if (animationID == xi::Animation::NewFishingCaught && PChar->hookedFish != nullptr)
            {
                uint8 catchType = PChar->hookedFish->catchtype;
                if (catchType >= FISHINGCATCHTYPE_SMALLFISH && catchType <= FISHINGCATCHTYPE_ITEM)
                {
                    uint16 caught          = charutils::GetCharVar(PChar, CAUGHT);
                    auto   nextJstMidnight = earth_time::jst::get_next_midnight(earth_time::now());
                    PChar->setCharVar(CAUGHT, caught + 1, earth_time::timestamp(nextJstMidnight));
                }
            }

            // block running other modules/main packet process function
            return true;
        }

        return false;
    }
};

REGISTER_CPP_MODULE(FishingFatigueModule);
