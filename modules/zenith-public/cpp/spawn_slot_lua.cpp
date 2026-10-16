/************************************************************************
 * Spawn Slot Lua bindings
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
 * Since LSB fb1a23fd82 most placeholder lotteries live in the `slots:`
 * section of data/zones/<zone>/mobs.yaml and are rolled in C++
 * (SpawnSlot::TrySpawn) instead of xi.mob.phOnDespawn. Base gives Lua no
 * way to read or change a slot member's chance or cooldown, so the Zenith
 * PH boost (lua/2-base/phOnMobDespawn.lua) could not reach those NMs.
 *
 * Adds to every entity:
 *   mob:getSpawnSlotEntry() -> { chance, cooldown, readyIn } or nil
 *       chance   : 0-100, the member's roll chance (0 = placeholder)
 *       cooldown : seconds the member sits out after it is killed
 *       readyIn  : seconds left before it can win a roll again (0 = ready)
 *   mob:setSpawnSlotEntry({ chance = n, cooldown = s, readyIn = s }) -> bool
 *       every field is optional
 ************************************************************************/
#include "map/utils/moduleutils.h"

#include "common/lua.h"
#include "common/timer.h"
#include "map/entities/mob_entity.h"
#include "map/lua/lua_base_entity.h"
#include "map/spawn_slot.h"

#include <algorithm>

namespace
{

// SpawnSlot only hands out its entries as const. The module owns no state of its
// own, so the cast is how a slot member's fields get edited without a base patch.
auto findEntry(CLuaBaseEntity* PLuaBaseEntity) -> SpawnSlotEntry*
{
    auto* PMob = dynamic_cast<CMobEntity*>(PLuaBaseEntity->GetBaseEntity());
    if (!PMob || !PMob->GetSpawnSlot())
    {
        return nullptr;
    }

    auto& entries = const_cast<std::vector<SpawnSlotEntry>&>(PMob->GetSpawnSlot()->GetEntries());
    auto  it      = std::ranges::find(entries, PMob, &SpawnSlotEntry::mob);

    return it != entries.end() ? &*it : nullptr;
}

} // namespace

class SpawnSlotLuaModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        ::lua["CBaseEntity"]["getSpawnSlotEntry"] = [](CLuaBaseEntity* PLuaBaseEntity) -> sol::object
        {
            const SpawnSlotEntry* entry = findEntry(PLuaBaseEntity);
            if (!entry)
            {
                return sol::lua_nil;
            }

            const auto now = timer::now();

            sol::table table = ::lua.create_table();
            table["chance"]   = entry->spawnChance;
            table["cooldown"] = timer::count_seconds(entry->cooldown);
            table["readyIn"]  = entry->readyAt > now ? timer::count_seconds(entry->readyAt - now) : 0;

            return table;
        };

        ::lua["CBaseEntity"]["setSpawnSlotEntry"] = [](CLuaBaseEntity* PLuaBaseEntity, const sol::table& params) -> bool
        {
            SpawnSlotEntry* entry = findEntry(PLuaBaseEntity);
            if (!entry)
            {
                return false;
            }

            if (const auto chance = params.get<sol::optional<int32>>("chance"))
            {
                entry->spawnChance = static_cast<uint8>(std::clamp<int32>(*chance, 0, 100));
            }

            if (const auto cooldown = params.get<sol::optional<int32>>("cooldown"))
            {
                entry->cooldown = std::chrono::seconds(std::max<int32>(*cooldown, 0));
            }

            if (const auto readyIn = params.get<sol::optional<int32>>("readyIn"))
            {
                entry->readyAt = timer::now() + std::chrono::seconds(std::max<int32>(*readyIn, 0));
            }

            return true;
        };
    }
};

REGISTER_CPP_MODULE(SpawnSlotLuaModule);
