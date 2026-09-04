/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

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

#include "base.h"

enum class GP_CLI_COMMAND_EQUIP_INSPECT_KIND : uint8_t
{
    Check      = 0x00,
    CheckName  = 0x01,
    CheckParam = 0x02,
};

// https://github.com/atom0s/XiPackets/tree/main/world/client/0x00DD
// This packet is sent by the client when inspecting entities.
// This is used for several means of inspection such as: /check, /checkname, /checkparam
// The July 2009 client sends only the first 12 bytes. Its ActIndex is a 16-bit
// value at offset 0x08 and the modern Kind field is not present.
GP_CLI_PACKET_VLA(GP_CLI_COMMAND_EQUIP_INSPECT, Kind,
                  uint32_t UniqueNo; // PS2: UniqueNo
                  union {
                      uint32_t ActIndex; // PS2: ActIndex
                      struct
                      {
                          uint16_t ActIndex;
                          uint16_t padding0A;
                      } Legacy; };
                  uint8_t Kind;         // PS2: (New; did not exist.)
                  uint8_t padding00[3]; // PS2: (New; did not exist.)
                  auto    isLegacy() const->bool { return this->header.size * 4U == this->getMinSize(); }

                  auto getActIndex() const->uint16_t { return this->isLegacy() ? this->Legacy.ActIndex : static_cast<uint16_t>(this->ActIndex); }

                  auto getKind() const->GP_CLI_COMMAND_EQUIP_INSPECT_KIND { return this->isLegacy() ? GP_CLI_COMMAND_EQUIP_INSPECT_KIND::Check : static_cast<GP_CLI_COMMAND_EQUIP_INSPECT_KIND>(this->Kind); });
