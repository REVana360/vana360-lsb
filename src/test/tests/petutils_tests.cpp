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

#include "map/utils/petutils.h"

#include <catch2/catch_test_macros.hpp>

#include <array>
#include <utility>

TEST_CASE("pets: elemental spirit perpetuation uses pre-2012 costs", "[pet][summoner]")
{
    constexpr std::array<std::pair<uint8, int16>, 38> expectedCosts{
        std::pair<uint8, int16>{ 1, 2 },
        { 4, 2 },
        { 5, 3 },
        { 8, 3 },
        { 9, 4 },
        { 13, 4 },
        { 14, 5 },
        { 17, 5 },
        { 18, 6 },
        { 22, 6 },
        { 23, 7 },
        { 26, 7 },
        { 27, 8 },
        { 31, 8 },
        { 32, 9 },
        { 35, 9 },
        { 36, 10 },
        { 39, 10 },
        { 40, 11 },
        { 44, 11 },
        { 45, 12 },
        { 48, 12 },
        { 49, 13 },
        { 53, 13 },
        { 54, 14 },
        { 57, 14 },
        { 58, 15 },
        { 62, 15 },
        { 63, 16 },
        { 66, 16 },
        { 67, 17 },
        { 71, 17 },
        { 72, 18 },
        { 80, 18 },
        { 81, 19 },
        { 94, 19 },
        { 95, 20 },
        { 99, 20 },
    };

    for (const auto& [level, cost] : expectedCosts)
    {
        CHECK(petutils::PerpetuationCost(PETID_FIRESPIRIT, level) == cost);
        CHECK(petutils::PerpetuationCost(PETID_DARKSPIRIT, level) == cost);
    }
}
