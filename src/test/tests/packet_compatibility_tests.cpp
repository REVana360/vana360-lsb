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
#include "map/entities/char_entity.h"
#include "map/entities/mob_entity.h"
#include "map/entities/npc_entity.h"
#include "map/enums/four_cc.h"
#include "map/enums/item_lockflg.h"
#include "map/enums/msg_basic.h"
#include "map/items/item.h"
#include "map/map_session.h"
#include "map/packets/basic.h"
#include "map/packets/c2s/0x01a_action.h"
#include "map/packets/c2s/0x050_equip_set.h"
#include "map/packets/c2s/0x061_clistatus.h"
#include "map/packets/c2s/0x0dd_equip_inspect.h"
#include "map/packets/char_update.h"
#include "map/packets/entity_update.h"
#include "map/packets/legacy_packet_adapter.h"
#include "map/packets/s2c/0x008_enterzone.h"
#include "map/packets/s2c/0x01c_item_max.h"
#include "map/packets/s2c/0x01f_item_list.h"
#include "map/packets/s2c/0x020_item_attr.h"
#include "map/packets/s2c/0x027_talknumwork2.h"
#include "map/packets/s2c/0x028_battle2.h"
#include "map/packets/s2c/0x029_battle_message.h"
#include "map/packets/s2c/0x02a_talknumwork.h"
#include "map/packets/s2c/0x02d_battle_message2.h"
#include "map/packets/s2c/0x03c_shop_list.h"
#include "map/packets/s2c/0x050_equip_list.h"
#include "map/packets/s2c/0x061_clistatus.h"
#include "map/packets/s2c/0x0ac_command_data.h"
#include "map/packets/s2c/0x0c9_equip_inspect_general.h"
#include "map/trade_container.h"

#include <catch2/catch_test_macros.hpp>

static_assert(sizeof(GP_SHOP_LEGACY) == 8);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_ENTERZONE::PacketData) == 0x34);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_ITEM_MAX::PacketData) == 0x64);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_ITEM_LIST::PacketData) == 0x10);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_ITEM_ATTR::PacketData) == 0x2C);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_TALKNUMWORK2::PacketData) == 0x70);
static_assert(sizeof(GP_CLI_COMMAND_EQUIP_SET) == 8);
static_assert(offsetof(GP_CLI_COMMAND_EQUIP_SET, Category) == 6);
static_assert(offsetof(GP_CLI_COMMAND_ACTION, ActIndex) == 8);
static_assert(offsetof(GP_CLI_COMMAND_ACTION, ActionID) == 10);
static_assert(offsetof(GP_CLI_COMMAND_ACTION, Weaponskill) == 12);
static_assert(offsetof(GP_CLI_COMMAND_EQUIP_INSPECT, Legacy.ActIndex) == 8);
static_assert(GP_CLI_COMMAND_EQUIP_INSPECT::getMinSize() == 12);
static_assert(offsetof(CLISTATUS, su_lv) + sizeof(GP_SERV_HEADER) == 0x52);
static_assert(sizeof(CommandDataTbl_t) == 224);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(CommandDataTbl_t, JobAbilities) == 0x44);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_BATTLE_MESSAGE::PacketData) == 0x1C);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(GP_SERV_COMMAND_BATTLE_MESSAGE::PacketData, Data) == 0x0C);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(GP_SERV_COMMAND_BATTLE_MESSAGE::PacketData, MessageNum) == 0x18);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_TALKNUMWORK::PacketData) == 0x40);
static_assert(sizeof(GP_SERV_HEADER) + sizeof(GP_SERV_COMMAND_BATTLE_MESSAGE2::PacketData) == 0x1C);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(GP_SERV_COMMAND_BATTLE_MESSAGE2::PacketData, Data) == 0x10);
static_assert(sizeof(GP_SERV_HEADER) + offsetof(GP_SERV_COMMAND_BATTLE_MESSAGE2::PacketData, MessageNum) == 0x18);

TEST_CASE("Lobby client profile requires the exact July Xbox marker", "[packet][vana360]")
{
    REQUIRE(isLegacyXboxClientProfile("july-2009-xbox"));
    REQUIRE_FALSE(isLegacyXboxClientProfile(""));
    REQUIRE_FALSE(isLegacyXboxClientProfile("july-2009-pc"));
    REQUIRE_FALSE(isLegacyXboxClientProfile("july-2009-xbox-extra"));
}

TEST_CASE("Legacy short action packets preserve the July action buffer", "[packet][vana360]")
{
    GP_CLI_COMMAND_ACTION packet{};
    packet.header.size  = 16 / 4; // GP_CLI_HEADER exposes four-byte units.
    packet.ActionBuf[0] = 0x12345678;

    MapSession legacySession;
    legacySession.legacyXboxClient = true;
    CCharEntity character;

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::CastMagic;
    REQUIRE_FALSE(packet.validate(nullptr, nullptr).valid());

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Talk;
    MapSession modernSession;
    REQUIRE_FALSE(packet.validate(&modernSession, nullptr).valid());

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Attack;
    REQUIRE(GP_CLI_COMMAND_ACTION::supportsLegacyShortForm(packet.ActionID));

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::HomepointMenu;
    REQUIRE(GP_CLI_COMMAND_ACTION::supportsLegacyShortForm(packet.ActionID));

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Weaponskill;
    REQUIRE(packet.validate(&legacySession, &character).valid());
    REQUIRE(packet.primaryActionParam() == 0x5678);

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::JobAbility;
    REQUIRE(packet.validate(&legacySession, &character).valid());
    REQUIRE(packet.primaryActionParam() == 0x5678);

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Mount;
    REQUIRE_FALSE(GP_CLI_COMMAND_ACTION::supportsLegacyShortForm(packet.ActionID));

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::SendResRdy;
    REQUIRE(packet.validate(nullptr, nullptr).valid());
}

TEST_CASE("July 2009 Enter Zone ends after 32 zone bytes", "[packet][vana360]")
{
    CCharEntity character;
    for (std::size_t index = 0; index < sizeof(character.m_ZonesVisitedList); ++index)
    {
        character.m_ZonesVisitedList[index] = static_cast<uint8_t>(index + 1);
    }

    GP_SERV_COMMAND_ENTERZONE packet(&character);
    REQUIRE(packet.getType() == 0x008);
    REQUIRE(packet.getSize() == 0x34);

    legacy_packet_adapter::adaptForJuly2009Xbox(packet);

    REQUIRE(packet.getSize() == 0x24);
    for (std::size_t index = 0; index < 32; ++index)
    {
        REQUIRE(packet.ref<uint8_t>(0x04 + index) == static_cast<uint8_t>(index + 1));
    }
}

TEST_CASE("July 2009 equip inspect accepts the short Check request", "[packet][vana360]")
{
    GP_CLI_COMMAND_EQUIP_INSPECT packet{};
    packet.header.size      = 12 / 4;
    packet.UniqueNo         = 0x01020304;
    packet.Legacy.ActIndex  = 0x1234;
    packet.Legacy.padding0A = 0xABCD;

    CCharEntity character;
    MapSession  modernSession;
    REQUIRE_FALSE(packet.validate(&modernSession, &character).valid());

    MapSession legacySession;
    legacySession.legacyXboxClient = true;
    REQUIRE(packet.validate(&legacySession, &character).valid());
    REQUIRE(packet.getActIndex() == 0x1234);
    REQUIRE(packet.getKind() == GP_CLI_COMMAND_EQUIP_INSPECT_KIND::Check);
}

TEST_CASE("July 2009 player Check restores historical job fields", "[packet][vana360]")
{
    CCharEntity viewer;
    CCharEntity target;
    viewer.visibleGmLevel = 3;
    target.id             = 0x01020304;
    target.targid         = 0x1234;
    target.SetMJob(1);
    target.SetSJob(3);
    target.SetMLevel(4);
    target.SetSLevel(2);

    GP_SERV_COMMAND_EQUIP_INSPECT::GENERAL packet(&viewer, &target);
    REQUIRE(packet.getType() == 0x0C9);
    REQUIRE(packet.getSize() == 0x54);
    REQUIRE(packet.ref<uint8_t>(0x0A) == 0x01);

    legacy_packet_adapter::adaptForJuly2009Xbox(packet);

    REQUIRE(packet.getSize() == 0x50);
    REQUIRE(packet.ref<uint32_t>(0x04) == target.id);
    REQUIRE(packet.ref<uint16_t>(0x08) == target.targid);
    REQUIRE(packet.ref<uint8_t>(0x12) == 1);
    REQUIRE(packet.ref<uint8_t>(0x13) == 3);
    REQUIRE(packet.ref<uint8_t>(0x23) == 4);
    REQUIRE(packet.ref<uint8_t>(0x24) == 2);
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

TEST_CASE("July 2009 command data preserves ability bit positions", "[packet][vana360]")
{
    struct AbilityFixture
    {
        uint8_t     abilityIndex;
        std::size_t modernByte;
        std::size_t legacyByte;
    };

    constexpr std::array<AbilityFixture, 2> fixtures{ {
        { 16, 0x46, 0x06 }, // Mighty Strikes -> July bit 0.
        { 32, 0x48, 0x08 }, // Warcry -> July bit 16.
    } };

    for (const auto& fixture : fixtures)
    {
        CCharEntity character;
        character.m_Abilities[fixture.abilityIndex / 8] = static_cast<uint8_t>(1U << (fixture.abilityIndex % 8));

        GP_SERV_COMMAND_COMMAND_DATA command(&character);
        REQUIRE(command.getType() == 0x0AC);
        REQUIRE(command.getSize() == 0xE4);
        REQUIRE(command.ref<uint8_t>(fixture.modernByte) == 1);

        legacy_packet_adapter::adaptForJuly2009Xbox(command);

        std::array<uint8_t, 0xB0> expected{};
        expected[0x00] = 0xAC;
        expected[0x01] = 0x58; // setSize(0xB0).
        // Historical pre-00d41fddca layout (a467cd067e^): canonical IDs are
        // shifted down by 16 bits in the July command-data packet.
        expected[fixture.legacyByte] = 1;

        REQUIRE(command.getType() == 0x0AC);
        REQUIRE(command.getSize() == 0xB0);
        for (std::size_t offset = 0; offset < expected.size(); ++offset)
        {
            REQUIRE(command.ref<uint8_t>(offset) == expected[offset]);
        }
    }
}

TEST_CASE("July 2009 Battle2 fixtures keep legacy result boundaries", "[packet][vana360]")
{
    struct BattleFixture
    {
        bool        hasProc;
        bool        hasReact;
        bool        truncated;
        std::size_t expectedSize;
        uint8_t     expectedWorkSize;
        uint8_t     expectedTargetCount;
        uint8_t     expectedFirstResultCount;
    };

    constexpr std::array<BattleFixture, 4> fixtures{ {
        { false, false, false, 0x24, 0x22, 1, 1 },
        { true, false, false, 0x28, 0x27, 1, 1 },
        { false, true, false, 0x28, 0x27, 1, 1 },
        { true, false, true, 0xFC, 0xFB, 2, 8 },
    } };

    for (const auto& fixture : fixtures)
    {
        action_t action{
            .actorId    = 0x01020304,
            .actiontype = ActionCategory::BasicAttack,
            .targets    = {
                {
                       .actorId = 0x05060708,
                       .results = {
                        {
                               .animation     = ActionAnimation::RedTrigger,
                               .info          = ActionInfo::CriticalHit,
                               .hitDistortion = HitDistortion::Medium,
                               .knockback     = Knockback::Level3,
                               .param         = 0x1234,
                               .messageID     = MsgBasic::AttackHits,
                               .modifier      = ActionModifier::CriticalHit,
                        },
                    },
                },
            },
        };

        auto& result = action.targets.front().results.front();
        if (fixture.hasProc)
        {
            result.additionalEffect = ActionProcAddEffect::FireDamage;
            result.addEffectInfo    = 2;
            result.addEffectParam   = 0x1234;
            result.addEffectMessage = MsgBasic::AddEffectAdditionalDamage;
        }
        if (fixture.hasReact)
        {
            result.spikesEffect  = ActionReactKind::BlazeSpikes;
            result.spikesInfo    = 3;
            result.spikesParam   = 0x2345;
            result.spikesMessage = MsgBasic::AddEffectAdditionalDamage;
        }
        if (fixture.truncated)
        {
            action.targets.clear();
            for (uint32_t targetIndex = 0; targetIndex < 2; ++targetIndex)
            {
                auto& target = action.addTarget(0x05060708 + targetIndex);
                for (uint32_t resultIndex = 0; resultIndex < 8; ++resultIndex)
                {
                    auto& truncatedResult            = target.results.emplace_back();
                    truncatedResult.animation        = ActionAnimation::RedTrigger;
                    truncatedResult.param            = 7;
                    truncatedResult.messageID        = MsgBasic::AttackHits;
                    truncatedResult.additionalEffect = ActionProcAddEffect::FireDamage;
                    truncatedResult.addEffectParam   = 3;
                    truncatedResult.addEffectMessage = MsgBasic::AddEffectAdditionalDamage;
                }
            }
        }

        GP_SERV_COMMAND_BATTLE2 packet(action);
        legacy_packet_adapter::adaptForJuly2009Xbox(packet);

        REQUIRE(packet.getType() == 0x028);
        REQUIRE(packet.getSize() == fixture.expectedSize);
        REQUIRE(packet.ref<uint8_t>(0x04) == fixture.expectedWorkSize);
        REQUIRE(unpackBitsBE(packet, 40, 32) == 0x01020304);
        REQUIRE(unpackBitsBE(packet, 72, 6) == fixture.expectedTargetCount);
        REQUIRE(unpackBitsBE(packet, 82, 4) == static_cast<uint8_t>(ActionCategory::BasicAttack));
        REQUIRE(unpackBitsBE(packet, 86, 32) == static_cast<uint32_t>(FourCC::BasicAttack));
        REQUIRE(unpackBitsBE(packet, 150, 32) == 0x05060708);
        REQUIRE(unpackBitsBE(packet, 182, 4) == fixture.expectedFirstResultCount);

        if (!fixture.truncated)
        {
            REQUIRE(unpackBitsBE(packet, 186, 3) == static_cast<uint8_t>(ActionResolution::Hit));
            REQUIRE(unpackBitsBE(packet, 189, 2) == 1);
            REQUIRE(unpackBitsBE(packet, 191, 11) == static_cast<uint16_t>(ActionAnimation::RedTrigger));
            REQUIRE(unpackBitsBE(packet, 202, 4) == static_cast<uint8_t>(ActionInfo::CriticalHit));
            REQUIRE(unpackBitsBE(packet, 206, 2) == static_cast<uint8_t>(HitDistortion::Medium));
            REQUIRE(unpackBitsBE(packet, 208, 3) == static_cast<uint8_t>(Knockback::Level3));
            REQUIRE(unpackBitsBE(packet, 211, 16) == 0x1234);
            REQUIRE(unpackBitsBE(packet, 227, 10) == static_cast<uint16_t>(MsgBasic::AttackHits));
            REQUIRE(unpackBitsBE(packet, 237, 32) == static_cast<uint32_t>(ActionModifier::CriticalHit));
            REQUIRE(unpackBitsBE(packet, 269, 1) == (fixture.hasProc ? 1 : 0));
            if (fixture.hasProc)
            {
                REQUIRE(unpackBitsBE(packet, 270, 6) == static_cast<uint8_t>(ActionProcAddEffect::FireDamage));
                REQUIRE(unpackBitsBE(packet, 276, 4) == 2);
                REQUIRE(unpackBitsBE(packet, 280, 14) == 0x1234);
                REQUIRE(unpackBitsBE(packet, 294, 10) == static_cast<uint16_t>(MsgBasic::AddEffectAdditionalDamage));
                REQUIRE(unpackBitsBE(packet, 304, 1) == 0);
            }
            else
            {
                REQUIRE(unpackBitsBE(packet, 270, 1) == (fixture.hasReact ? 1 : 0));
                if (fixture.hasReact)
                {
                    REQUIRE(unpackBitsBE(packet, 271, 6) == static_cast<uint8_t>(ActionReactKind::BlazeSpikes));
                    REQUIRE(unpackBitsBE(packet, 277, 4) == 3);
                    REQUIRE(unpackBitsBE(packet, 281, 14) == 0x2345);
                    REQUIRE(unpackBitsBE(packet, 295, 10) == static_cast<uint16_t>(MsgBasic::AddEffectAdditionalDamage));
                }
            }
        }
        else
        {
            constexpr uint32_t secondTargetOffset = 1138;
            REQUIRE(unpackBitsBE(packet, secondTargetOffset, 32) == 0x05060709);
            REQUIRE(unpackBitsBE(packet, secondTargetOffset + 32, 4) == 7);
        }
    }
}

TEST_CASE("July 2009 battle messages preserve legacy parameter layouts", "[packet][vana360]")
{
    CCharEntity player;
    player.id     = 0x01000001;
    player.targid = 0x0101;

    CMobEntity target;
    target.id     = 0x01000002;
    target.targid = 0x0202;

    struct BattleMessageFixture
    {
        int32_t  param;
        int32_t  value;
        MsgBasic message;
    };

    constexpr std::array<BattleMessageFixture, 5> battleMessages{ {
        { 1, 7, MsgBasic::SkillGain },
        { 1, 4, MsgBasic::SkillLevelUp },
        { 4, 0, MsgBasic::CheckDefault },
        { 0, 0, MsgBasic::CheckImpossibleToGauge },
        { 10, 0, MsgBasic::Obtains },
    } };

    for (const auto& fixture : battleMessages)
    {
        GP_SERV_COMMAND_BATTLE_MESSAGE packet(&player, &target, fixture.param, fixture.value, fixture.message);
        std::array<uint8_t, 0x1C>      before{};
        std::memcpy(before.data(), packet[0], before.size());

        legacy_packet_adapter::adaptForJuly2009Xbox(packet);

        REQUIRE(packet.getType() == 0x029);
        REQUIRE(packet.getSize() == 0x1C);
        REQUIRE(std::memcmp(before.data(), packet[0], before.size()) == 0);
        REQUIRE(packet.ref<uint32_t>(0x04) == player.id);
        REQUIRE(packet.ref<uint32_t>(0x08) == target.id);
        REQUIRE(packet.ref<int32_t>(0x0C) == fixture.param);
        REQUIRE(packet.ref<int32_t>(0x10) == fixture.value);
        REQUIRE(packet.ref<uint16_t>(0x14) == player.targid);
        REQUIRE(packet.ref<uint16_t>(0x16) == target.targid);
        REQUIRE(packet.ref<uint16_t>(0x18) == static_cast<uint16_t>(fixture.message));
        REQUIRE(packet.ref<uint8_t>(0x1A) == 0);
        REQUIRE(packet.ref<uint8_t>(0x1B) == 0);
    }

    constexpr std::array<BattleMessageFixture, 3> battleMessages2{ {
        { 42, 0, MsgBasic::ExperiencePointsGained },
        { 42, 2, MsgBasic::ExpChain },
        { 5, 0, MsgBasic::LevelUp },
    } };

    for (const auto& fixture : battleMessages2)
    {
        GP_SERV_COMMAND_BATTLE_MESSAGE2 packet(&player, &target, fixture.param, fixture.value, fixture.message);
        std::array<uint8_t, 0x1C>       before{};
        std::memcpy(before.data(), packet[0], before.size());

        legacy_packet_adapter::adaptForJuly2009Xbox(packet);

        REQUIRE(packet.getType() == 0x02D);
        REQUIRE(packet.getSize() == 0x1C);
        REQUIRE(std::memcmp(before.data(), packet[0], before.size()) == 0);
        REQUIRE(packet.ref<uint32_t>(0x04) == player.id);
        REQUIRE(packet.ref<uint32_t>(0x08) == target.id);
        REQUIRE(packet.ref<uint16_t>(0x0C) == player.targid);
        REQUIRE(packet.ref<uint16_t>(0x0E) == target.targid);
        REQUIRE(packet.ref<int32_t>(0x10) == fixture.param);
        REQUIRE(packet.ref<int32_t>(0x14) == fixture.value);
        REQUIRE(packet.ref<uint16_t>(0x18) == static_cast<uint16_t>(fixture.message));
        REQUIRE(packet.ref<uint8_t>(0x1A) == 0);
        REQUIRE(packet.ref<uint8_t>(0x1B) == 0);
    }
}

TEST_CASE("July 2009 item capacity uses the pre-Mog Sack layout", "[packet][vana360]")
{
    CCharEntity                      character;
    constexpr std::array<uint8_t, 7> capacity{ 20, 30, 40, 50, 60, 70, 80 };
    for (std::size_t index = 0; index < capacity.size(); ++index)
    {
        character.getStorage(static_cast<uint8_t>(index))->AddBuff(capacity[index]);
    }

    GP_SERV_COMMAND_ITEM_MAX packet(&character);
    REQUIRE(packet.getType() == 0x01C);
    REQUIRE(packet.getSize() == 0x64);
    REQUIRE(packet.ref<uint8_t>(0x0A) == 81);  // Modern Mog Sack count.
    REQUIRE(packet.ref<uint16_t>(0x30) == 81); // Modern Mog Sack usable count.

    legacy_packet_adapter::adaptForJuly2009Xbox(packet);

    REQUIRE(packet.getType() == 0x01C);
    REQUIRE(packet.getSize() == 0x34);
    for (std::size_t index = 0; index < 6; ++index)
    {
        REQUIRE(packet.ref<uint8_t>(0x04 + index) == capacity[index] + 1);
        const uint16_t expectedUsable = index == LOC_MOGLOCKER ? 0 : capacity[index] + 1;
        REQUIRE(packet.ref<uint16_t>(0x14 + index * sizeof(uint16_t)) == expectedUsable);
    }
    for (std::size_t offset = 0x0A; offset < 0x14; ++offset)
    {
        REQUIRE(packet.ref<uint8_t>(offset) == 0);
    }
    for (std::size_t offset = 0x20; offset < 0x34; ++offset)
    {
        REQUIRE(packet.ref<uint8_t>(offset) == 0);
    }
}

TEST_CASE("July 2009 formatted messages use conditional packet lengths", "[packet][vana360]")
{
    CCharEntity player;
    player.id     = 0x01020304;
    player.targid = 0x0506;
    player.name   = "Vanatest";

    GP_SERV_COMMAND_TALKNUMWORK unnamed(&player, 123, 16534, 2, 3, 4, false);
    REQUIRE(unnamed.getSize() == 0x40);

    legacy_packet_adapter::adaptForJuly2009Xbox(unnamed);

    REQUIRE(unnamed.getType() == 0x02A);
    REQUIRE(unnamed.getSize() == 0x20);
    REQUIRE(unnamed.ref<uint32_t>(0x04) == player.id);
    REQUIRE(unnamed.ref<uint32_t>(0x08) == 16534);
    REQUIRE(unnamed.ref<uint32_t>(0x0C) == 2);
    REQUIRE(unnamed.ref<uint32_t>(0x10) == 3);
    REQUIRE(unnamed.ref<uint32_t>(0x14) == 4);
    REQUIRE(unnamed.ref<uint16_t>(0x18) == player.targid);
    REQUIRE(unnamed.ref<uint16_t>(0x1A) == (123 | 0x8000));

    CNpcEntity npc;
    npc.id     = 0x01020305;
    npc.targid = 0x0507;
    npc.name   = "Cletae";

    GP_SERV_COMMAND_TALKNUMWORK named(&npc, 456, 7, 8, 9, 10, true);
    REQUIRE(named.getSize() == 0x40);

    legacy_packet_adapter::adaptForJuly2009Xbox(named);

    REQUIRE(named.getType() == 0x02A);
    REQUIRE(named.getSize() == 0x30);
    REQUIRE(named.ref<uint16_t>(0x1A) == 456);
    for (std::size_t index = 0; index < npc.name.size(); ++index)
    {
        REQUIRE(named.ref<uint8_t>(0x1E + index) == npc.name[index]);
    }
}

TEST_CASE("July 2009 shop lists use eight-byte rows", "[packet][vana360]")
{
    constexpr std::array<uint16_t, 14> itemIds{
        2129,
        505,
        856,
        852,
        878,
        858,
        857,
        1640,
        859,
        1628,
        853,
        2123,
        2518,
        854,
    };
    constexpr std::array<uint32_t, 14> prices{
        75,
        100,
        80,
        600,
        600,
        600,
        2400,
        2500,
        1500,
        16000,
        3000,
        2500,
        3000,
        3000,
    };

    CCharEntity character;
    MapSession  session;
    character.PSession = &session;
    character.Container->setSize(17);
    for (uint8_t index = 0; index < itemIds.size(); ++index)
    {
        character.Container->setItem(index, itemIds[index], index, prices[index]);
        character.Container->setRestriction(index, GuildRestriction{ 5, index });
    }

    GP_SERV_COMMAND_SHOP_LIST modern(&character);
    REQUIRE(modern.getType() == 0x03C);
    REQUIRE(modern.getSize() == 0xB0);

    session.legacyXboxClient = true;
    GP_SERV_COMMAND_SHOP_LIST legacy(&character);
    REQUIRE(legacy.getType() == 0x03C);
    REQUIRE(legacy.getSize() == 0x78);
    for (uint8_t index = 0; index < itemIds.size(); ++index)
    {
        const std::size_t offset = 0x08 + index * sizeof(GP_SHOP_LEGACY);
        REQUIRE(legacy.ref<uint32_t>(offset) == prices[index]);
        REQUIRE(legacy.ref<uint16_t>(offset + 4) == itemIds[index]);
        REQUIRE(legacy.ref<uint8_t>(offset + 6) == index);
        REQUIRE(legacy.ref<uint8_t>(offset + 7) == 0);
    }
}

TEST_CASE("July 2009 item and equip packets retain stable layouts", "[packet][vana360]")
{
    CItem item(16534);
    item.setStackSize(99);
    item.setQuantity(7);
    item.setCharPrice(1234);
    item.setLocationID(LOC_INVENTORY);
    item.setSlotID(3);
    for (std::size_t index = 0; index < sizeof(item.m_extra); ++index)
    {
        item.m_extra[index] = static_cast<uint8_t>(0xA0 + index);
    }

    GP_SERV_COMMAND_ITEM_LIST itemList(&item, ItemLockFlg::Normal);
    std::array<uint8_t, 0x10> itemListBefore{};
    std::memcpy(itemListBefore.data(), itemList[0], itemListBefore.size());
    legacy_packet_adapter::adaptForJuly2009Xbox(itemList);

    REQUIRE(itemList.getSize() == 0x10);
    REQUIRE(std::memcmp(itemListBefore.data(), itemList[0], itemListBefore.size()) == 0);
    REQUIRE(itemList.ref<uint32_t>(0x04) == 7);
    REQUIRE(itemList.ref<uint16_t>(0x08) == 16534);
    REQUIRE(itemList.ref<uint8_t>(0x0A) == LOC_INVENTORY);
    REQUIRE(itemList.ref<uint8_t>(0x0B) == 3);
    REQUIRE(itemList.ref<uint8_t>(0x0C) == static_cast<uint8_t>(ItemLockFlg::Normal));

    GP_SERV_COMMAND_ITEM_ATTR itemAttr(&item, LOC_INVENTORY, 3);
    std::array<uint8_t, 0x2C> itemAttrBefore{};
    std::memcpy(itemAttrBefore.data(), itemAttr[0], itemAttrBefore.size());
    legacy_packet_adapter::adaptForJuly2009Xbox(itemAttr);

    REQUIRE(itemAttr.getSize() == 0x2C);
    REQUIRE(std::memcmp(itemAttrBefore.data(), itemAttr[0], itemAttrBefore.size()) == 0);
    REQUIRE(itemAttr.ref<uint32_t>(0x04) == 7);
    REQUIRE(itemAttr.ref<uint32_t>(0x08) == 1234);
    REQUIRE(itemAttr.ref<uint16_t>(0x0C) == 16534);
    REQUIRE(itemAttr.ref<uint8_t>(0x0E) == LOC_INVENTORY);
    REQUIRE(itemAttr.ref<uint8_t>(0x0F) == 3);
    REQUIRE(itemAttr.ref<uint8_t>(0x10) == static_cast<uint8_t>(ItemLockFlg::Unknown0));
    for (std::size_t index = 0; index < sizeof(item.m_extra); ++index)
    {
        REQUIRE(itemAttr.ref<uint8_t>(0x11 + index) == item.m_extra[index]);
    }

    GP_SERV_COMMAND_EQUIP_LIST equip(3, SLOT_MAIN, LOC_INVENTORY);
    std::array<uint8_t, 0x08>  equipBefore{};
    std::memcpy(equipBefore.data(), equip[0], equipBefore.size());
    legacy_packet_adapter::adaptForJuly2009Xbox(equip);

    REQUIRE(equip.getSize() == 0x08);
    REQUIRE(std::memcmp(equipBefore.data(), equip[0], equipBefore.size()) == 0);
    REQUIRE(equip.ref<uint8_t>(0x04) == 3);
    REQUIRE(equip.ref<uint8_t>(0x05) == SLOT_MAIN);
    REQUIRE(equip.ref<uint8_t>(0x06) == LOC_INVENTORY);
}

TEST_CASE("July 2009 fishing messages retain the legacy layout", "[packet][vana360]")
{
    CCharEntity player;
    player.id     = 0x01020304;
    player.targid = 0x0506;
    player.name   = "Vanatest";

    GP_SERV_COMMAND_TALKNUMWORK2 packet(&player, 16534, 777, 2);
    std::array<uint8_t, 0x70>    before{};
    std::memcpy(before.data(), packet[0], before.size());

    legacy_packet_adapter::adaptForJuly2009Xbox(packet);

    REQUIRE(packet.getSize() == 0x70);
    REQUIRE(std::memcmp(before.data(), packet[0], before.size()) == 0);
    REQUIRE(packet.ref<uint32_t>(0x04) == player.id);
    REQUIRE(packet.ref<uint16_t>(0x08) == player.targid);
    REQUIRE(packet.ref<uint16_t>(0x0A) == (777 | 0x8000));
    REQUIRE(packet.ref<uint32_t>(0x10) == 16534);
    REQUIRE(packet.ref<uint32_t>(0x14) == 2);
    for (std::size_t index = 0; index < player.name.size(); ++index)
    {
        REQUIRE(packet.ref<uint8_t>(0x20 + index) == player.name[index]);
    }
}

TEST_CASE("July 2009 player updates preserve model and name fields", "[packet][vana360]")
{
    CCharEntity character;
    character.id        = 0x01020304;
    character.targid    = 0x0456;
    character.name      = "Vanatest";
    character.health.hp = character.health.modhp = 27;
    character.look.size                          = MODEL_EQUIPPED;
    character.look.face                          = 8;
    character.look.race                          = 1;
    character.look.head                          = 2;
    character.look.body                          = 3;
    character.look.hands                         = 4;
    character.look.legs                          = 5;
    character.look.feet                          = 6;
    character.look.main                          = 7;
    character.look.sub                           = 8;
    character.look.ranged                        = 9;

    CCharUpdatePacket packet(&character, ENTITY_SPAWN, UPDATE_ALL_CHAR);
    REQUIRE(packet.getType() == 0x00D);
    REQUIRE(packet.ref<uint16_t>(0x48) == 0x0108);
    REQUIRE(packet.ref<uint8_t>(0x5A) == 'V');

    legacy_packet_adapter::adaptForJuly2009Xbox(packet);

    constexpr std::array<uint16_t, 9> expectedModel{
        0x0108,
        0x1002,
        0x2003,
        0x3004,
        0x4005,
        0x5006,
        0x6007,
        0x7008,
        0x8009,
    };
    REQUIRE(packet.getType() == 0x00D);
    REQUIRE(packet.getSize() == 0x60);
    REQUIRE(packet.ref<uint32_t>(0x04) == 0x01020304);
    REQUIRE(packet.ref<uint16_t>(0x08) == 0x0456);
    REQUIRE(packet.ref<uint8_t>(0x0A) == UPDATE_ALL_CHAR);
    for (std::size_t index = 0; index < expectedModel.size(); ++index)
    {
        REQUIRE(packet.ref<uint16_t>(0x3E + index * sizeof(uint16_t)) == expectedModel[index]);
    }
    for (std::size_t index = 0; index < character.name.size(); ++index)
    {
        REQUIRE(packet.ref<uint8_t>(0x50 + index) == character.name[index]);
    }
    for (std::size_t index = character.name.size(); index < 16; ++index)
    {
        REQUIRE(packet.ref<uint8_t>(0x50 + index) == 0);
    }
}

TEST_CASE("July 2009 NPC updates preserve standard and equipped models", "[packet][vana360]")
{
    struct NpcFixture
    {
        uint16_t    modelType;
        std::string name;
        uint8_t     expectedFlags;
    };

    const std::array<NpcFixture, 2> fixtures{ {
        { MODEL_STANDARD, "FieldManual", UPDATE_ALL_MOB },
        { MODEL_EQUIPPED, "Cletae", 0x57 },
    } };

    for (const auto& fixture : fixtures)
    {
        CNpcEntity npc;
        npc.id          = 0x010E61B5;
        npc.targid      = 0x01B5;
        npc.name        = fixture.name;
        npc.look.size   = fixture.modelType;
        npc.look.face   = 8;
        npc.look.race   = 1;
        npc.look.head   = 2;
        npc.look.body   = 3;
        npc.look.hands  = 4;
        npc.look.legs   = 5;
        npc.look.feet   = 6;
        npc.look.main   = 7;
        npc.look.sub    = 8;
        npc.look.ranged = 9;

        CEntityUpdatePacket packet(&npc, ENTITY_SPAWN, UPDATE_ALL_MOB);
        legacy_packet_adapter::adaptForJuly2009Xbox(packet);

        REQUIRE(packet.getType() == 0x00E);
        REQUIRE(packet.getSize() == 0x48);
        REQUIRE(packet.ref<uint32_t>(0x04) == 0x010E61B5);
        REQUIRE(packet.ref<uint16_t>(0x08) == 0x01B5);
        REQUIRE(packet.ref<uint8_t>(0x0A) == fixture.expectedFlags);
        REQUIRE(packet.ref<uint16_t>(0x30) == fixture.modelType);

        if (fixture.modelType == MODEL_STANDARD)
        {
            REQUIRE(packet.ref<uint16_t>(0x32) == 0x0108);
            for (std::size_t index = 0; index < fixture.name.size(); ++index)
            {
                REQUIRE(packet.ref<uint8_t>(0x34 + index) == fixture.name[index]);
            }
        }
        else
        {
            constexpr std::array<uint16_t, 10> expectedLook{
                MODEL_EQUIPPED,
                0x0108,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
            };
            for (std::size_t index = 0; index < expectedLook.size(); ++index)
            {
                REQUIRE(packet.ref<uint16_t>(0x30 + index * sizeof(uint16_t)) == expectedLook[index]);
            }
        }
    }
}

TEST_CASE("July 2009 NPC lifecycle masks match legacy handlers", "[packet][vana360]")
{
    struct LifecycleFixture
    {
        ENTITYUPDATE updateType;
        bool         npc;
        uint16_t     modelType;
        uint8_t      modernFlags;
        uint8_t      legacyFlags;
        std::size_t  legacySize;
    };

    constexpr std::array<LifecycleFixture, 3> fixtures{ {
        { ENTITY_SPAWN, true, MODEL_DOOR, UPDATE_ALL_MOB, 0x07, 0x48 },
        { ENTITY_DESPAWN, true, MODEL_STANDARD, 0x30, UPDATE_DESPAWN, 0x38 },
        { ENTITY_DESPAWN, false, MODEL_STANDARD, 0x30, UPDATE_COMBAT, 0x38 },
    } };

    for (const auto& fixture : fixtures)
    {
        std::unique_ptr<CBaseEntity> entity;
        if (fixture.npc)
        {
            entity = std::make_unique<CNpcEntity>();
        }
        else
        {
            entity = std::make_unique<CMobEntity>();
        }

        entity->id        = 0x010E61B5;
        entity->targid    = 0x01B5;
        entity->name      = "Lifecycle";
        entity->look.size = fixture.modelType;

        CEntityUpdatePacket source(entity.get(), fixture.updateType, UPDATE_ALL_MOB);
        REQUIRE(source.ref<uint8_t>(0x0A) == fixture.modernFlags);

        auto packet = source.copy();
        legacy_packet_adapter::adaptForJuly2009Xbox(*packet);

        REQUIRE(packet->getType() == 0x00E);
        REQUIRE(packet->getSize() == fixture.legacySize);
        REQUIRE(packet->ref<uint8_t>(0x0A) == fixture.legacyFlags);
    }
}

TEST_CASE("July 2009 client status ends before modern fields", "[packet][vana360]")
{
    CCharEntity character;
    MapSession  legacySession;
    legacySession.legacyXboxClient = true;
    character.PSession             = &legacySession;
    character.health.modhp         = 27;
    character.health.modmp         = 11;
    character.SetMJob(1);
    character.SetSJob(0);
    character.SetMLevel(4);
    character.SetSLevel(0);
    character.jobs.job[1]                    = 4;
    character.jobs.exp[1]                    = 321;
    character.profile.title                  = 17;
    character.profile.rank[0]                = 1;
    character.profile.rankpoints             = 123;
    character.profile.home_point.destination = xi::ZoneId::SouthernSanDoria;
    character.profile.nation                 = 0;

    GP_SERV_COMMAND_CLISTATUS packet(&character);

    REQUIRE(packet.getType() == 0x061);
    REQUIRE(packet.getSize() == 0x54);
    REQUIRE(packet.ref<int32_t>(0x04) == 27);
    REQUIRE(packet.ref<int32_t>(0x08) == 11);
    REQUIRE(packet.ref<uint8_t>(0x0C) == 1);
    REQUIRE(packet.ref<uint8_t>(0x0D) == 4);
    REQUIRE(packet.ref<uint16_t>(0x10) == 321);
    REQUIRE(packet.ref<uint16_t>(0x44) == 17);
    REQUIRE(packet.ref<uint16_t>(0x46) == 1);
    REQUIRE(packet.ref<uint16_t>(0x48) == 123);
    REQUIRE(packet.ref<uint16_t>(0x4A) == static_cast<uint16_t>(xi::ZoneId::SouthernSanDoria));
    REQUIRE(packet.ref<uint8_t>(0x50) == 0);
    REQUIRE(packet.ref<uint8_t>(0x52) == 0);
    REQUIRE(packet.ref<uint8_t>(0x53) == 0);
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
    REQUIRE(commandData.ref<uint8_t>(0x06) == 0x01);
    REQUIRE(commandData.ref<uint8_t>(0x29) == 0x23);
    REQUIRE(commandData.ref<uint8_t>(0x34) == 0x44);
    REQUIRE(commandData.ref<uint8_t>(0x43) == 0x45);
    for (std::size_t offset = 0x44; offset < 0x64; ++offset)
    {
        REQUIRE(commandData.ref<uint8_t>(offset) == 0);
    }
    REQUIRE(commandData.ref<uint8_t>(0x64) == 0x11);
    REQUIRE(commandData.ref<uint8_t>(0x83) == 0x12);
}
