/************************************************************************
 * Fishing Rank Limit
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
 * Anti-botting: a character below rank 3 in every nation may land 20
 * catches a day instead of LSB's 200.
 *
 * LSB owns the fishing mechanics and the daily accounting. It counts
 * landed catches in the [Fish]DailyPoints char var (lost catches and
 * zero-base-price items do not count), resets it at JST midnight, and
 * enforces its own 200 catch and 20,000 fatigue limits. This module only
 * reads that counter.
 *
 * When a limited character casts (Player Action packet 0x01A, Fish), the
 * cast is refused before fishing starts, the way LSB refuses a cast in a
 * Mog House: the client is released from fishing and nothing else
 * changes. LSB has already validated the packet by then. Every other
 * packet, and every allowed cast, goes on to LSB untouched.
 *
 * Rank 3 in any nation lifts the limit, so changing allegiance keeps it
 * lifted. A running chart quest ignores this limit, as it ignores LSB's.
 ************************************************************************/
#include "map/entities/char_entity.h"
#include "map/enums/chat_message_type.h"
#include "map/packets/c2s/0x01a_action.h"
#include "map/packets/s2c/0x017_chat_std.h"
#include "map/packets/s2c/0x052_eventucoff.h"
#include "map/utils/moduleutils.h"

#include <algorithm>

namespace
{

constexpr uint8 UNLOCK_RANK           = 3;
constexpr int32 LIMITED_DAILY_CATCHES = 20;

// Mirrors the chart check in fishingutils::FishingAction, which skips LSB's daily limits
auto isChartActive(const CCharEntity* PChar) -> bool
{
    return (PChar->getZone() == xi::ZoneId::ValkurmDunes && PChar->GetLocalVar("pChartActive") == 1) ||
           (PChar->getZone() == xi::ZoneId::BuburimuPeninsula && PChar->GetLocalVar("bChartActive") == 1);
}

auto isLimited(const CCharEntity* PChar) -> bool
{
    const bool ranked = std::ranges::any_of(PChar->profile.rank,
                                            [](const uint8 rank)
                                            {
                                                return rank >= UNLOCK_RANK;
                                            });

    return !ranked && !isChartActive(PChar) && PChar->getCharVar("[Fish]DailyPoints") >= LIMITED_DAILY_CATCHES;
}

} // namespace

class FishingRankLimitModule : public CPPModule
{
    void OnInit() override
    {
    }

    auto OnIncomingPacket(MapSession* session, CCharEntity* PChar, CBasicPacket& packet) -> bool override
    {
        if (packet.getType() != static_cast<uint16>(GP_CLI_COMMAND_ACTION::packetId))
        {
            return false;
        }

        if (packet.as<GP_CLI_COMMAND_ACTION>()->ActionID != GP_CLI_COMMAND_ACTION_ACTIONID::Fish || !isLimited(PChar))
        {
            return false;
        }

        PChar->pushPacket<GP_SERV_COMMAND_CHAT_STD>(PChar, CHAT_MESSAGE_TYPE::MESSAGE_SYSTEM_1, "You have reached your daily fishing limit. Reach rank 3 in any nation to raise it.");
        PChar->pushPacket<GP_SERV_COMMAND_EVENTUCOFF>(PChar, GP_SERV_COMMAND_EVENTUCOFF_MODE::Fishing);

        return true;
    }
};

REGISTER_CPP_MODULE(FishingRankLimitModule);
