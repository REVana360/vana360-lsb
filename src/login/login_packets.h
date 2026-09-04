/*
===========================================================================

  Copyright (c) 2023 LandSandBoat Dev Teams

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

#include <cstddef>
#include <cstdint>
#include <cstring>

// Source for this entire reference is from atom0s's dump at https://github.com/atom0s/XiPackets
// Thank you for your service to the community, atom0s!

struct packet_t
{
    //
    // Packet Header
    //

    uint32_t packet_size;   // PS2: packet_size
    uint32_t terminator;    // PS2: terminator
    uint32_t command;       // PS2: command
    uint8_t  identifer[16]; // PS2: identifer
};

namespace loginPackets
{

inline uint32_t getTerminator()
{
    uint8_t terminator[4] = { 0x49, 0x58, 0x46, 0x46 }; // "IXFF" special terminator

    return terminator[0] | (terminator[1] << 8) | (terminator[2] << 16) | (terminator[3] << 24);
}

inline void copyHashIntoPacket(packet_t& packet, uint8_t hash[16])
{
    for (uint8_t i = 0; i < 16; i++)
    {
        packet.identifer[i] = hash[i];
    }
}

inline void clearIdentifier(packet_t& packet)
{
    for (uint8_t i = 0; i < 16; i++)
    {
        packet.identifer[i] = 0;
    }
}

} // namespace loginPackets

// PS2: lpkt_next_login: https://github.com/atom0s/XiPackets/blob/main/lobby/S2C_0x000B_ResponseNextLogin.md
struct lpkt_next_login : packet_t
{
    //
    // Packet Data
    //

    uint32_t ffxi_id;            // PS2: ffxi_id
    uint32_t ffxi_id_world;      // PS2: ffxi_id_world
    char     character_name[16]; // PS2: character_name
    uint32_t server_id;          // PS2: server_id
    uint32_t server_ip;          // PS2: server_ip
    uint32_t server_port;        // PS2: server_port
    uint32_t cache_ip;           // PS2: cache_ip
    uint32_t cache_port;         // PS2: cache_port
};

// https://github.com/atom0s/XiPackets/blob/main/lobby/CharacterInfo.md
struct TC_OPERATION_MAKE
{
    uint16_t mon_no;
    uint8_t  mjob_no;
    uint8_t  sjob_no;
    uint16_t face_no;
    uint8_t  town_no;
    uint8_t  gen_flag;
    uint8_t  hair_no;
    uint8_t  size;
    uint16_t world_no;
    uint16_t GrapIDTbl[8];
    uint8_t  zone_no;
    uint8_t  mjob_level;
    uint8_t  open_flag;
    uint8_t  GMCallCounter;
    uint16_t version;
    uint8_t  skill1;
    uint8_t  zone_no2;
    uint8_t  TC_OPERATION_WORK_USER_RANK_LEVEL_SD_;
    uint8_t  TC_OPERATION_WORK_USER_RANK_LEVEL_BS_;
    uint8_t  TC_OPERATION_WORK_USER_RANK_LEVEL_WS_;
    uint8_t  ErrCounter;
    uint16_t TC_OPERATION_WORK_USER_FAME_SD_COMMON_;
    uint16_t TC_OPERATION_WORK_USER_FAME_BS_COMMON_;
    uint16_t TC_OPERATION_WORK_USER_FAME_WS_COMMON_;
    uint16_t TC_OPERATION_WORK_USER_FAME_DARK_GUILD_;
    uint32_t PlayTime;
    uint32_t get_job_flag;
    uint8_t  job_lev[16];
    uint32_t FirstLoginDate;
    uint32_t Gold;
    uint8_t  skill2;
    uint8_t  skill3;
    uint8_t  skill4;
    uint8_t  skill5;
    uint32_t ChatCounter;
    uint32_t PartyCounter;
    uint8_t  skill6;
    uint8_t  skill7;
    uint8_t  skill8;
    uint8_t  skill9;
};

// PS2: lpkt_chr_info_sub2 https://github.com/atom0s/XiPackets/blob/main/lobby/S2C_0x0020_ResponseChrInfo2.md
struct lpkt_chr_info_sub2
{
    uint32_t          ffxi_id;            // PS2: ffxi_id
    uint16_t          ffxi_id_world;      // PS2: ffxi_id_world
    uint16_t          worldid;            // PS2: worldid
    uint16_t          status;             // PS2: status
    uint8_t           renamef : 1;        // PS2: renamef
    uint8_t           race_change : 1;    // PS2: (New; did not exist.)
    uint8_t           unused : 6;         // PS2: (New; did not exist.)
    uint8_t           ffxi_id_world_tbl;  // PS2: (New; did not exist.)
    char              character_name[16]; // PS2: character_name
    char              world_name[16];     // PS2: world_name
    TC_OPERATION_MAKE character_info;     // PS2: character_info
};

namespace loginPackets
{

inline constexpr uint32_t legacyContentId(size_t slot)
{
    return static_cast<uint32_t>(slot + 1) << 16;
}

inline void setLegacyCharacterIds(lpkt_chr_info_sub2& characterInfo, uint32_t contentId, uint32_t characterId)
{
    characterInfo.ffxi_id = contentId;
    std::memcpy(&characterInfo.ffxi_id_world, &characterId, sizeof(characterId));
}

inline void setModernCharacterIds(lpkt_chr_info_sub2& characterInfo, uint32_t characterId)
{
    characterInfo.ffxi_id           = characterId;
    characterInfo.ffxi_id_world     = characterId & 0xFFFF;
    characterInfo.worldid           = 0;
    characterInfo.ffxi_id_world_tbl = (characterId >> 16) & 0xFF;
}

inline void setCharacterIds(lpkt_chr_info_sub2& characterInfo, bool legacyXboxClient, uint32_t contentId, uint32_t characterId)
{
    if (legacyXboxClient)
    {
        setLegacyCharacterIds(characterInfo, contentId, characterId);
    }
    else
    {
        setModernCharacterIds(characterInfo, characterId);
    }
}

inline uint32_t getLegacyCharacterId(const lpkt_chr_info_sub2& characterInfo)
{
    uint32_t characterId = 0;
    std::memcpy(&characterId, &characterInfo.ffxi_id_world, sizeof(characterId));
    return characterId;
}

inline uint32_t getModernCharacterId(const lpkt_chr_info_sub2& characterInfo)
{
    return characterInfo.ffxi_id;
}

inline uint32_t getCharacterId(const lpkt_chr_info_sub2& characterInfo, bool legacyXboxClient)
{
    return legacyXboxClient ? getLegacyCharacterId(characterInfo) : getModernCharacterId(characterInfo);
}

inline uint32_t getSelectedCharacterId(const uint8_t* packet, bool legacyXboxClient)
{
    uint32_t characterId = 0;
    std::memcpy(&characterId, packet + (legacyXboxClient ? 32 : 28), sizeof(characterId));
    return characterId;
}

inline void setDataCharacterIds(uint8_t* entry, bool legacyXboxClient, uint32_t contentId, uint32_t characterId)
{
    std::memcpy(entry, &contentId, sizeof(contentId));
    if (legacyXboxClient)
    {
        std::memcpy(entry + 4, &characterId, sizeof(characterId));
        return;
    }

    const uint16_t characterIdMain = characterId & 0xFFFF;
    const uint8_t  worldId         = 0;
    const uint8_t  characterIdHigh = (characterId >> 16) & 0xFF;
    std::memcpy(entry + 4, &characterIdMain, sizeof(characterIdMain));
    std::memcpy(entry + 6, &worldId, sizeof(worldId));
    std::memcpy(entry + 7, &characterIdHigh, sizeof(characterIdHigh));
}

} // namespace loginPackets

// PS2: lpkt_chr_info2 https://github.com/atom0s/XiPackets/blob/main/lobby/S2C_0x0020_ResponseChrInfo2.md
struct lpkt_chr_info2 : packet_t
{
    //
    // Packet Data
    //

    uint32_t           characters;         // PS2: characters
    lpkt_chr_info_sub2 character_info[16]; // PS2: character_info
};

// PS2: lpkt_world_name https://github.com/atom0s/XiPackets/blob/main/lobby/S2C_0x0023_ResponseWorldList.md
struct lpkt_world_name
{
    uint32_t no;       // PS2: no
    char     name[16]; // PS2: name
};

// PS2: lpkt_world_list https://github.com/atom0s/XiPackets/blob/main/lobby/S2C_0x0023_ResponseWorldList.md
struct lpkt_world_list : packet_t
{
    uint32_t        sumofworld;    // PS2: sumofworld
    lpkt_world_name world_name[1]; // PS2: world_name // size is 1 as we do not support multiple worlds yet.
};

// PS2: lpkt_deletechr https://github.com/atom0s/XiPackets/blob/main/lobby/C2S_0x0014_RequestDeleteChr.md
struct lpkt_deletechr
{
    //
    // Packet Header
    //

    uint32_t packet_size;   // PS2: packet_size
    uint32_t terminator;    // PS2: terminator
    uint32_t command;       // PS2: command
    uint8_t  identifer[16]; // PS2: identifer

    //
    // Packet Data
    //

    uint32_t ffxi_id;       // PS2: ffxi_id
    uint32_t ffxi_id_world; // PS2: ffxi_id_world
    uint8_t  passwd[16];    // PS2: passwd
};
