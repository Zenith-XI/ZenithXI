/*
===========================================================================

  Copyright (c) 2010-2015 Darkstar Dev Teams

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

#pragma once

#include "enums/automaton.h"
#include "pet_entity.h"

#include <map/entities/types/automaton_equip.h>

#include <array>

class CCharEntity;

class CAutomatonEntity : public CPetEntity
{
public:
    CAutomatonEntity();
    ~CAutomatonEntity();

    AutomatonEquip       m_Equip{};
    std::array<uint8, 8> m_ElementMax{};
    std::array<uint8, 8> m_ElementEquip{};

    auto getFrame() const -> AutomatonFrame;
    auto getHead() const -> AutomatonHead;
    auto getAttachment(uint8 slotid) const -> uint8;
    auto hasAttachment(uint8 attachment) const -> bool;

    auto getElementMax(uint8 element) const -> uint8;
    auto getElementCapacity(uint8 element) const -> uint8;

    void burdenTick();
    auto getBurden() const -> const std::array<uint8, 8>&;
    void setAllBurden(uint8 burden);
    void setBurdenArray(std::array<uint8, 8> burdenArray);
    auto addBurden(uint8 element, int8 burden) -> uint8;
    auto getOverloadChance(uint8 element) const -> uint8;

    //
    // CPetEntity, CMobEntity, etc.
    //

    void PostTick() override;

    void Spawn() override;
    void Die() override;

    auto ValidTarget(CBattleEntity* PInitiator, uint16 targetFlags) -> bool override;

    void OnMobSkillFinished(CMobSkillState&, action_t&) override;
    void OnCastFinished(CMagicState&, action_t&) override;

private:
    std::array<uint8, 8> burden_{};
};
