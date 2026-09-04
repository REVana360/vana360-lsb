/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

===========================================================================
*/

#include "legacy_packet_adapter.h"

#include "basic.h"
#include "entity_update.h"
#include "s2c/0x028_battle2.h"

#include <cstring>

namespace
{

constexpr uint8_t sendName  = 0x08;
constexpr uint8_t sendModel = 0x10;
constexpr uint8_t sendName2 = 0x40;

void adaptEquipRequest(CBasicPacket& packet)
{
    constexpr std::size_t categoryOffset = 0x06;
    packet.ref<uint8_t>(categoryOffset)  = 0; // July 2009 equips only from inventory.
}

void adaptCharUpdate(CBasicPacket& packet)
{
    constexpr std::size_t modernGrapOffset = 0x48;
    constexpr std::size_t modernNameOffset = 0x5A;
    constexpr std::size_t legacyGrapOffset = 0x3E;
    constexpr std::size_t legacyNameOffset = 0x50;
    constexpr std::size_t grapSize         = legacyNameOffset - legacyGrapOffset;
    constexpr std::size_t nameSize         = 16;

    const uint8_t flags = packet.ref<uint8_t>(0x0A);
    if (flags & sendModel)
    {
        std::memmove(packet[legacyGrapOffset], packet[modernGrapOffset], grapSize);
    }

    if (flags & sendName)
    {
        std::memmove(packet[legacyNameOffset], packet[modernNameOffset], nameSize);
        packet.setSize(0x60);
    }
    else if (flags & sendModel)
    {
        packet.setSize(legacyNameOffset);
    }
    else
    {
        std::memset(packet[legacyGrapOffset], 0, 0x40 - legacyGrapOffset);
        packet.setSize(0x40);
    }
}

void adaptEntityUpdate(CBasicPacket& packet)
{
    if (auto* entityUpdate = dynamic_cast<CEntityUpdatePacket*>(&packet))
    {
        entityUpdate->useJuly2009Layout();
    }

    const uint8_t  flags     = packet.ref<uint8_t>(0x0A);
    const uint16_t modelType = packet.ref<uint16_t>(0x30);
    const bool     longModel =
        modelType == 1 || modelType == 2 || modelType == 3 || modelType == 4 || modelType == 7;
    const bool hasName = (flags & (sendName | sendName2)) != 0;
    packet.setSize(longModel || hasName ? 0x48 : 0x38);
}

void adaptBattleAction(CBasicPacket& packet)
{
    if (auto* battleAction = dynamic_cast<GP_SERV_COMMAND_BATTLE2*>(&packet))
    {
        battleAction->useJuly2009Layout();
    }
}

void adaptCommandData(CBasicPacket& packet)
{
    constexpr std::size_t modernWeaponSkillsOffset = 0x04;
    constexpr std::size_t modernAbilitiesOffset    = 0x44;
    constexpr std::size_t modernTraitsOffset       = 0xC4;

    constexpr std::size_t legacyAbilitiesOffset    = 0x06;
    constexpr std::size_t legacyTraitsOffset       = 0x34;
    constexpr std::size_t legacyWeaponSkillsOffset = 0x64;

    constexpr std::size_t weaponSkillsSize = 32;
    constexpr std::size_t abilitiesSize    = 38;
    constexpr std::size_t traitsSize       = 16;
    constexpr std::size_t headerSize       = 4;
    constexpr std::size_t abilityBiasBytes = 2;

    std::array<uint8_t, weaponSkillsSize> weaponSkills{};
    std::array<uint8_t, abilitiesSize>    abilities{};
    std::array<uint8_t, traitsSize>       traits{};

    std::memcpy(weaponSkills.data(), packet[modernWeaponSkillsOffset], weaponSkills.size());
    // The July client adds 16 to command-data ability bit positions. Modern
    // server ability bits already use those client-facing IDs.
    std::memcpy(abilities.data(), packet[modernAbilitiesOffset + abilityBiasBytes], abilities.size());
    std::memcpy(traits.data(), packet[modernTraitsOffset], traits.size());

    std::memset(packet[headerSize], 0, 0xB0 - headerSize);
    std::memcpy(packet[legacyAbilitiesOffset], abilities.data(), abilities.size());
    std::memcpy(packet[legacyTraitsOffset], traits.data(), traits.size());
    std::memcpy(packet[legacyWeaponSkillsOffset], weaponSkills.data(), weaponSkills.size());
    packet.setSize(0xB0);
}

} // namespace

namespace legacy_packet_adapter
{

void adaptFromJuly2009Xbox(CBasicPacket& packet)
{
    switch (packet.getType())
    {
        case 0x050:
            adaptEquipRequest(packet);
            break;
        default:
            break;
    }
}

void adaptForJuly2009Xbox(CBasicPacket& packet)
{
    switch (packet.getType())
    {
        case 0x00D:
            adaptCharUpdate(packet);
            break;
        case 0x00E:
            adaptEntityUpdate(packet);
            break;
        case 0x028:
            adaptBattleAction(packet);
            break;
        case 0x0AC:
            adaptCommandData(packet);
            break;
        default:
            break;
    }
}

} // namespace legacy_packet_adapter
