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

#include "map/packets/c2s/0x01a_action.h"
#include "map/packets/c2s/0x061_clistatus.h"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("Legacy short action packets only allow SendResRdy", "[packet][vana360]")
{
    GP_CLI_COMMAND_ACTION packet{};
    packet.header.size = 16 / 4; // GP_CLI_HEADER exposes four-byte units.

    packet.ActionID = GP_CLI_COMMAND_ACTION_ACTIONID::Attack;
    REQUIRE_FALSE(packet.validate(nullptr, nullptr).valid());

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
