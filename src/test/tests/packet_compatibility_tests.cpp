/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

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

#include "login/login_packets.h"
#include "login/session.h"
#include "map/action/action.h"
#include "map/enums/four_cc.h"
#include "map/map_session.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x01a_action.h"
#include "map/packets/c2s/0x050_equip_set.h"
#include "map/packets/c2s/0x061_clistatus.h"
#include "map/packets/legacy_packet_adapter.h"
#include "map/packets/s2c/0x028_battle2.h"
#include "map/packets/s2c/0x03c_shop_list.h"
#include "map/packets/s2c/0x061_clistatus.h"
#include "map/packets/s2c/0x0ac_command_data.h"

#include <catch2/catch_test_macros.hpp>

static_assert(sizeof(GP_SHOP_LEGACY) == 8);
static_assert(sizeof(GP_CLI_COMMAND_EQUIP_SET) == 8);
static_assert(offsetof(GP_CLI_COMMAND_EQUIP_SET, Category) == 6);
static_assert(offsetof(GP_CLI_COMMAND_ACTION, ActIndex) == 8);
static_assert(offsetof(GP_CLI_COMMAND_ACTION, ActionID) == 10);
static_assert(offsetof(CLISTATUS, su_lv) + sizeof(GP_SERV_HEADER) == 0x52);
static_assert(sizeof(CommandDataTbl_t) == 224);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(CommandDataTbl_t, JobAbilities) == 0x44);

TEST_CASE("Lobby client profile requires the exact July Xbox marker", "[packet][vana360]")
{
    REQUIRE(isLegacyXboxClientProfile("july-2009-xbox"));
    REQUIRE_FALSE(isLegacyXboxClientProfile(""));
    REQUIRE_FALSE(isLegacyXboxClientProfile("july-2009-pc"));
    REQUIRE_FALSE(isLegacyXboxClientProfile("july-2009-xbox-extra"));
}

TEST_CASE("Legacy short action packets allow payload-free July actions", "[packet][vana360]")
{
    GP_CLI_COMMAND_ACTION packet{};
    packet.header.size = 16 / 4; // GP_CLI_HEADER exposes four-byte units.

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::CastMagic;
    REQUIRE_FALSE(packet.validate(nullptr, nullptr).valid());

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Talk;
    MapSession modernSession;
    REQUIRE_FALSE(packet.validate(&modernSession, nullptr).valid());

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Attack;
    REQUIRE(GP_CLI_COMMAND_ACTION::supportsLegacyShortForm(packet.ActionID));

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::HomepointMenu;
    REQUIRE(GP_CLI_COMMAND_ACTION::supportsLegacyShortForm(packet.ActionID));

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::SendResRdy;
    REQUIRE(packet.validate(nullptr, nullptr).valid());
}

TEST_CASE("Legacy header-only clistatus skips absent fields", "[packet][vana360]")
{
    GP_CLI_COMMAND_CLISTATUS packet{};
    packet.header.size = sizeof(GP_CLI_HEADER) / 4;
    packet.unknown00   = 0xFF;
    REQUIRE(packet.validate(nullptr, nullptr).valid());

    packet.header.size = sizeof(GP_CLI_COMMAND_CLISTATUS) / 4;
    REQUIRE_FALSE(packet.validate(nullptr, nullptr).valid());
}

TEST_CASE("Legacy lobby entries keep content and character IDs distinct", "[packet][vana360]")
{
    lpkt_chr_info_sub2 characterInfo{};
    constexpr uint32_t characterId = 0x12345678;

    loginPackets::setLegacyCharacterIds(characterInfo,
                                        loginPackets::legacyContentId(2),
                                        characterId);

    REQUIRE(characterInfo.ffxi_id == 0x00030000);
    REQUIRE(loginPackets::getLegacyCharacterId(characterInfo) == characterId);

    std::array<uint8_t, 40> selection{};
    std::memcpy(selection.data() + 28, &characterInfo.ffxi_id, sizeof(uint32_t));
    std::memcpy(selection.data() + 32, &characterId, sizeof(uint32_t));
    REQUIRE(loginPackets::getSelectedCharacterId(selection.data(), true) == characterId);

    std::array<uint8_t, 16> dataEntry{};
    loginPackets::setDataCharacterIds(dataEntry.data(), true, characterInfo.ffxi_id, characterId);
    uint32_t dataContentId   = 0;
    uint32_t dataCharacterId = 0;
    std::memcpy(&dataContentId, dataEntry.data(), sizeof(dataContentId));
    std::memcpy(&dataCharacterId, dataEntry.data() + 4, sizeof(dataCharacterId));
    REQUIRE(dataContentId == 0x00030000);
    REQUIRE(dataCharacterId == characterId);
}

TEST_CASE("Modern lobby character IDs retain current LSB layout", "[packet][vana360]")
{
    lpkt_chr_info_sub2 characterInfo{};
    constexpr uint32_t characterId = 0x00123456;

    loginPackets::setCharacterIds(characterInfo, false, characterId, characterId);

    REQUIRE(characterInfo.ffxi_id == characterId);
    REQUIRE(characterInfo.ffxi_id_world == 0x3456);
    REQUIRE(characterInfo.worldid == 0);
    REQUIRE(characterInfo.ffxi_id_world_tbl == 0x12);
    REQUIRE(loginPackets::getCharacterId(characterInfo, false) == characterId);

    std::array<uint8_t, 40> request{};
    const uint32_t          legacyDecoy = 0x00ABCDEF;
    std::memcpy(request.data() + 28, &characterId, sizeof(characterId));
    std::memcpy(request.data() + 32, &legacyDecoy, sizeof(legacyDecoy));
    REQUIRE(loginPackets::getSelectedCharacterId(request.data(), false) == characterId);
    REQUIRE(loginPackets::getSelectedCharacterId(request.data(), true) == legacyDecoy);

    std::array<uint8_t, 16> dataEntry{};
    loginPackets::setDataCharacterIds(dataEntry.data(), false, characterId, characterId);
    REQUIRE(dataEntry[0] == 0x56);
    REQUIRE(dataEntry[1] == 0x34);
    REQUIRE(dataEntry[2] == 0x12);
    REQUIRE(dataEntry[3] == 0x00);
    REQUIRE(dataEntry[4] == 0x56);
    REQUIRE(dataEntry[5] == 0x34);
    REQUIRE(dataEntry[6] == 0x00);
    REQUIRE(dataEntry[7] == 0x12);
}

TEST_CASE("July 2009 packet adaptation is applied at the recipient boundary", "[packet][vana360]")
{
    CBasicPacket equip{};
    equip.setType(0x050);
    equip.setSize(0x08);
    equip.ref<uint8_t>(0x06) = 0xFF;
    legacy_packet_adapter::adaptFromJuly2009Xbox(equip);
    REQUIRE(equip.ref<uint8_t>(0x06) == 0);

    CBasicPacket character{};
    character.setType(0x00D);
    character.setSize(0x6C);
    character.ref<uint8_t>(0x0A) = 0x18;
    for (uint8_t index = 0; index < 18; ++index)
    {
        character.ref<uint8_t>(0x48 + index) = static_cast<uint8_t>(0x20 + index);
    }
    for (uint8_t index = 0; index < 16; ++index)
    {
        character.ref<uint8_t>(0x5A + index) = static_cast<uint8_t>('A' + index);
    }

    legacy_packet_adapter::adaptForJuly2009Xbox(character);

    REQUIRE(character.getSize() == 0x60);
    for (uint8_t index = 0; index < 18; ++index)
    {
        REQUIRE(character.ref<uint8_t>(0x3E + index) == static_cast<uint8_t>(0x20 + index));
    }
    for (uint8_t index = 0; index < 16; ++index)
    {
        REQUIRE(character.ref<uint8_t>(0x50 + index) == static_cast<uint8_t>('A' + index));
    }

    CBasicPacket entity{};
    entity.setType(0x00E);
    entity.setSize(0x58);
    entity.ref<uint8_t>(0x0A)  = 0x1F;
    entity.ref<uint16_t>(0x30) = 0;
    legacy_packet_adapter::adaptForJuly2009Xbox(entity);
    REQUIRE(entity.getSize() == 0x48);

    entity.setSize(0x58);
    entity.ref<uint8_t>(0x0A)  = 0x01;
    entity.ref<uint16_t>(0x30) = 0;
    legacy_packet_adapter::adaptForJuly2009Xbox(entity);
    REQUIRE(entity.getSize() == 0x38);

    entity.setSize(0x58);
    entity.ref<uint8_t>(0x0A)  = 0x1F;
    entity.ref<uint16_t>(0x30) = 1;
    legacy_packet_adapter::adaptForJuly2009Xbox(entity);
    REQUIRE(entity.getSize() == 0x48);

    action_t action{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::BasicAttack,
        .targets    = {
            {
                   .actorId = 0x05060708,
                   .results = {
                    {
                           .animation     = static_cast<ActionAnimation>(12),
                           .hitDistortion = HitDistortion::Light,
                           .param         = 7,
                           .messageID     = MsgBasic::AttackHits,
                    },
                },
            },
        },
    };
    GP_SERV_COMMAND_BATTLE2 battleAction(action);
    legacy_packet_adapter::adaptForJuly2009Xbox(battleAction);
    REQUIRE(battleAction.getSize() == 0x24);
    REQUIRE(battleAction.ref<uint8_t>(0x04) == 0x22);
    REQUIRE(unpackBitsBE(battleAction, 40, 32) == 0x01020304);
    REQUIRE(unpackBitsBE(battleAction, 72, 6) == 1);
    REQUIRE(unpackBitsBE(battleAction, 78, 4) == 0);
    REQUIRE(unpackBitsBE(battleAction, 82, 4) == static_cast<uint8_t>(ActionCategory::BasicAttack));
    REQUIRE(unpackBitsBE(battleAction, 86, 32) == static_cast<uint32_t>(FourCC::BasicAttack));
    REQUIRE(unpackBitsBE(battleAction, 118, 32) == 0);
    REQUIRE(unpackBitsBE(battleAction, 150, 32) == 0x05060708);
    REQUIRE(unpackBitsBE(battleAction, 182, 4) == 1);
    REQUIRE(unpackBitsBE(battleAction, 186, 3) == static_cast<uint8_t>(ActionResolution::Hit));
    REQUIRE(unpackBitsBE(battleAction, 189, 2) == 1);
    REQUIRE(unpackBitsBE(battleAction, 191, 11) == 12);
    REQUIRE(unpackBitsBE(battleAction, 202, 4) == 0);
    REQUIRE(unpackBitsBE(battleAction, 206, 2) == static_cast<uint8_t>(HitDistortion::Light));
    REQUIRE(unpackBitsBE(battleAction, 208, 3) == 0);
    REQUIRE(unpackBitsBE(battleAction, 211, 16) == 7);
    REQUIRE(unpackBitsBE(battleAction, 227, 10) == static_cast<uint16_t>(MsgBasic::AttackHits));
    REQUIRE(unpackBitsBE(battleAction, 237, 32) == 0);
    REQUIRE(unpackBitsBE(battleAction, 269, 1) == 0);
    REQUIRE(unpackBitsBE(battleAction, 270, 1) == 0);

    action_t oversizedAction{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::BasicAttack,
    };
    for (uint32_t index = 0; index < 15; ++index)
    {
        action_target_t target{ .actorId = 0x05060708 + index };
        for (uint32_t result = 0; result < 8; ++result)
        {
            target.results.emplace_back(action_result_t{
                .animation        = static_cast<ActionAnimation>(12),
                .param            = 7,
                .messageID        = MsgBasic::AttackHits,
                .additionalEffect = ActionProcAddEffect::FireDamage,
                .addEffectParam   = 3,
                .addEffectMessage = MsgBasic::AddEffectAdditionalDamage,
            });
        }
        oversizedAction.targets.emplace_back(std::move(target));
    }
    GP_SERV_COMMAND_BATTLE2 oversizedPacket(oversizedAction);
    legacy_packet_adapter::adaptForJuly2009Xbox(oversizedPacket);
    REQUIRE(unpackBitsBE(oversizedPacket, 72, 6) < 15);

    action_t effectAction{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::BasicAttack,
        .targets    = {
            {
                   .actorId = 0x05060708,
                   .results = {
                    {
                           .animation        = static_cast<ActionAnimation>(12),
                           .hitDistortion    = HitDistortion::Light,
                           .param            = 7,
                           .messageID        = MsgBasic::AttackHits,
                           .additionalEffect = ActionProcAddEffect::FireDamage,
                           .addEffectParam   = 3,
                           .addEffectMessage = MsgBasic::AddEffectAdditionalDamage,
                    },
                },
            },
        },
    };
    GP_SERV_COMMAND_BATTLE2 effectPacket(effectAction);
    legacy_packet_adapter::adaptForJuly2009Xbox(effectPacket);
    REQUIRE(effectPacket.getSize() == 0x28);
    REQUIRE(effectPacket.ref<uint8_t>(0x04) == 0x27);
    REQUIRE(unpackBitsBE(effectPacket, 269, 1) == 1);
    REQUIRE(unpackBitsBE(effectPacket, 270, 6) == static_cast<uint8_t>(ActionProcAddEffect::FireDamage));
    REQUIRE(unpackBitsBE(effectPacket, 276, 4) == 0);
    REQUIRE(unpackBitsBE(effectPacket, 280, 14) == 3);
    REQUIRE(unpackBitsBE(effectPacket, 294, 10) == static_cast<uint16_t>(MsgBasic::AddEffectAdditionalDamage));
    REQUIRE(unpackBitsBE(effectPacket, 304, 1) == 0);

    action_t weaponSkillStart{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::SkillStart,
        .actionid   = static_cast<uint32_t>(FourCC::SkillUse),
        .targets    = {
            {
                   .actorId = 0x05060708,
                   .results = {
                    {
                           .param = 5,
                    },
                },
            },
        },
    };
    GP_SERV_COMMAND_BATTLE2 weaponSkillPacket(weaponSkillStart);
    legacy_packet_adapter::adaptForJuly2009Xbox(weaponSkillPacket);
    REQUIRE(unpackBitsBE(weaponSkillPacket, 82, 4) == static_cast<uint8_t>(ActionCategory::SkillStart));
    REQUIRE(unpackBitsBE(weaponSkillPacket, 86, 32) == static_cast<uint32_t>(FourCC::SkillUse));

    action_t parryAction{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::BasicAttack,
        .targets    = {
            {
                   .actorId = 0x05060708,
                   .results = {
                    {
                           .resolution = ActionResolution::Parry,
                           .modifier   = ActionModifier::Resist,
                    },
                },
            },
        },
    };
    GP_SERV_COMMAND_BATTLE2 parryPacket(parryAction);
    legacy_packet_adapter::adaptForJuly2009Xbox(parryPacket);
    REQUIRE(unpackBitsBE(parryPacket, 186, 3) == static_cast<uint8_t>(ActionResolution::Parry));
    REQUIRE(unpackBitsBE(parryPacket, 237, 32) == static_cast<uint32_t>(ActionModifier::Resist));

    action_t criticalAction{
        .actorId    = 0x01020304,
        .actiontype = ActionCategory::BasicAttack,
        .targets    = {
            {
                   .actorId = 0x05060708,
                   .results = {
                    {
                           .info          = ActionInfo::CriticalHit,
                           .hitDistortion = HitDistortion::Heavy,
                    },
                },
            },
        },
    };
    GP_SERV_COMMAND_BATTLE2 criticalPacket(criticalAction);
    legacy_packet_adapter::adaptForJuly2009Xbox(criticalPacket);
    REQUIRE(unpackBitsBE(criticalPacket, 202, 4) ==
            (static_cast<uint8_t>(ActionInfo::CriticalHit) & 0x0F));

    CBasicPacket commandData{};
    commandData.setType(0x0AC);
    commandData.setSize(0xE4);
    commandData.ref<uint8_t>(0x04) = 0x11;
    commandData.ref<uint8_t>(0x23) = 0x12;
    commandData.ref<uint8_t>(0x44) = 0x22;
    commandData.ref<uint8_t>(0x46) = 0x01; // Ability 16: Mighty Strikes.
    commandData.ref<uint8_t>(0x69) = 0x23;
    commandData.ref<uint8_t>(0x84) = 0x33;
    commandData.ref<uint8_t>(0xA3) = 0x34;
    commandData.ref<uint8_t>(0xC4) = 0x44;
    commandData.ref<uint8_t>(0xD3) = 0x45;
    legacy_packet_adapter::adaptForJuly2009Xbox(commandData);
    REQUIRE(commandData.getSize() == 0xB0);
    REQUIRE(commandData.ref<uint8_t>(0x06) == 0x22);
    REQUIRE(commandData.ref<uint8_t>(0x08) == 0x01);
    REQUIRE(commandData.ref<uint8_t>(0x2B) == 0x23);
    REQUIRE(commandData.ref<uint8_t>(0x34) == 0x44);
    REQUIRE(commandData.ref<uint8_t>(0x43) == 0x45);
    for (std::size_t offset = 0x44; offset < 0x64; ++offset)
    {
        REQUIRE(commandData.ref<uint8_t>(offset) == 0);
    }
    REQUIRE(commandData.ref<uint8_t>(0x64) == 0x11);
    REQUIRE(commandData.ref<uint8_t>(0x83) == 0x12);
}
