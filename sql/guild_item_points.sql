SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for guild_item_points
-- ----------------------------
DROP TABLE IF EXISTS `guild_item_points`;
CREATE TABLE `guild_item_points` (
  `guildid` tinyint(1) unsigned NOT NULL,
  `itemid` smallint(5) unsigned NOT NULL,
  `rank` smallint(1) unsigned NOT NULL,
  `points` smallint(5) unsigned NOT NULL DEFAULT '0',
  `max_points` smallint(5) unsigned NOT NULL DEFAULT '0',
  `pattern` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`itemid`,`pattern`)
) ENGINE=Aria TRANSACTIONAL=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records
-- ----------------------------

-- max_points use the limits from before the November 8, 2016 retail increase.
-- Source: https://forum.square-enix.com/ffxi/threads/51624

-- --------------------------------------------------------
-- Guild Point Rewards
-- --------------------------------------------------------
--
-- Guild turn-in items were modified on 11/20/2011
-- Wiki: https://ffxiclopedia.fandom.com/wiki/Guild_Points/Items?oldid=1060231
-- Patch Notes: Some of the items requested by guildworkers' union representatives have changed.
-- Patch Notes Link: https://forum.square-enix.com/ffxi/threads/15044
--
-- Guild point rewards for Cooking Guild turn-in items were increased in 10/12/2011.
-- Patch Notes: Guild point rewards for Cooking Guild crafting quests have been increased
-- Patch Notes Link: https://forum.square-enix.com/ffxi/threads/15044
--
-- Values in this file are based on historical data from the FFXIclopedia wiki
-- pre-oct 2011 revisions when available for era-accurate values.
--
-- For HQ items where no wiki value was obtainable (and no LSB value existed),
-- 15% was added to the NQ value.
-- --------------------------------------------------------

-- ========================================================
-- ITEM CORRECTIONS (pre-oct 2011 historical data)
-- UPDATE to new item, DELETE old item, INSERT new items
-- ========================================================

-- Fishing / Amateur
INSERT INTO `guild_item_points` VALUES (0,4360,0,24,1200,0); -- Bastore Sardine (24 / 1200)
INSERT INTO `guild_item_points` VALUES (0,4472,0,30,1280,1); -- Crayfish (30 / 1280)
INSERT INTO `guild_item_points` VALUES (0,4360,0,24,1200,2); -- Bastore Sardine (24 / 1200)
INSERT INTO `guild_item_points` VALUES (0,5125,0,12,1120,3); -- Moat Carp -> Phanauet Newt (12/1120)
INSERT INTO `guild_item_points` VALUES (0,4472,0,30,1280,4); -- Crayfish (30 / 1280)
INSERT INTO `guild_item_points` VALUES (0,4314,0,300,2560,5); -- Bibikibo (300 / 2560)
INSERT INTO `guild_item_points` VALUES (0,4401,0,30,1280,6); -- Moat Carp (30 / 1280)
INSERT INTO `guild_item_points` VALUES (0,4443,0,24,1200,7); -- Cobalt Jellyfish (24 / 1200)

-- Fishing / Recruit
INSERT INTO `guild_item_points` VALUES (0,4515,1,60,1680,0); -- Copper Frog (60 / 1680)
INSERT INTO `guild_item_points` VALUES (0,4289,1,45,1600,1); -- Forest Carp (45 / 1600)
INSERT INTO `guild_item_points` VALUES (0,4514,1,60,1680,2); -- Quus (60 / 1680)
INSERT INTO `guild_item_points` VALUES (0,4379,1,60,1680,3); -- Cheval Salmon (60 / 1680)
INSERT INTO `guild_item_points` VALUES (0,4500,1,24,1520,4); -- Bastore Sweeper -> Greedie (24/1520)
INSERT INTO `guild_item_points` VALUES (0,4500,1,24,1520,5); -- Bastore Sweeper -> Greedie (24/1520)
INSERT INTO `guild_item_points` VALUES (0,4313,1,675,3760,6); -- Blindfish (675 / 3760)
INSERT INTO `guild_item_points` VALUES (0,4403,1,60,1680,7); -- Yellow Globe (60 / 1680)

-- Fishing / Initiate
INSERT INTO `guild_item_points` VALUES (0,4464,2,138,2240,0); -- Pipira (138 / 2240)
INSERT INTO `guild_item_points` VALUES (0,4469,2,300,2880,1); -- Giant Catfish (300 / 2880)
INSERT INTO `guild_item_points` VALUES (0,4361,2,156,2320,2); -- Nebimonite (156 / 2320)
INSERT INTO `guild_item_points` VALUES (0,4426,2,156,2320,3); -- Tricolored Carp (156 / 2320)
INSERT INTO `guild_item_points` VALUES (0,4315,2,720,4000,4); -- Lungfish (720 / 4000)
INSERT INTO `guild_item_points` VALUES (0,5121,2,714,4000,5); -- Moorish Idol (714 / 4000)
INSERT INTO `guild_item_points` VALUES (0,4290,2,156,2320,6); -- Elshimo Frog (156 / 2320)
INSERT INTO `guild_item_points` VALUES (0,4483,2,156,2320,7); -- Tiger Cod (156 / 2320)

-- Fishing / Novice
INSERT INTO `guild_item_points` VALUES (0,4354,3,78,6720,0); -- Shining Trout (78/6720)
INSERT INTO `guild_item_points` VALUES (0,4528,3,375,3280,1); -- Crystal Bass (375 / 3280)
INSERT INTO `guild_item_points` VALUES (0,4482,3,240,2880,2); -- Nosteau Herring (240 / 2880)
INSERT INTO `guild_item_points` VALUES (0,4428,3,60,2160,3); -- Veydal Wrasse -> Dark Bass (60/2160)
INSERT INTO `guild_item_points` VALUES (0,4480,3,300,3040,4); -- Gugru Tuna (300 / 3040)
INSERT INTO `guild_item_points` VALUES (0,4580,3,375,3280,5); -- Coral Butterfly (375 / 3280)
INSERT INTO `guild_item_points` VALUES (0,4428,3,60,2160,6); -- Shining Trout -> Dark Bass (60/2160)
INSERT INTO `guild_item_points` VALUES (0,4481,3,96,2320,7); -- Ogre Eel (96 / 2320)

-- Fishing / Apprentice
INSERT INTO `guild_item_points` VALUES (0,4462,4,900,4480,0); -- Monke-Onke (900 / 4480)
INSERT INTO `guild_item_points` VALUES (0,4306,4,576,3920,1); -- Giant Donko (576 / 3920)
INSERT INTO `guild_item_points` VALUES (0,4383,4,576,3920,2); -- Gold Lobster (576 / 3920)
INSERT INTO `guild_item_points` VALUES (0,4470,4,459,3600,3); -- Icefish (459 / 3600)
INSERT INTO `guild_item_points` VALUES (0,4385,4,93,2480,4); -- Zafmlug Bass (93 / 2480)
INSERT INTO `guild_item_points` VALUES (0,4383,4,576,3920,5); -- Gold Lobster (576 / 3920)
INSERT INTO `guild_item_points` VALUES (0,4291,4,78,2400,6); -- Black Eel -> Sandfish (78/2400)
INSERT INTO `guild_item_points` VALUES (0,4385,4,93,2480,7); -- Zafmlug Bass (93 / 2480)

-- Fishing / Journeyman
INSERT INTO `guild_item_points` VALUES (0,4427,5,900,4560,0); -- Gold Carp (900 / 4560)
INSERT INTO `guild_item_points` VALUES (0,4579,5,525,3920,1); -- Elshimo Newt (525 / 3920)
INSERT INTO `guild_item_points` VALUES (0,4479,5,900,4560,2); -- Bhefhel Marlin (900 / 4560)
INSERT INTO `guild_item_points` VALUES (0,4402,5,900,4560,3); -- Red Terrapin (900 / 4560)
INSERT INTO `guild_item_points` VALUES (0,4399,5,900,4560,4); -- Bluetail (900 / 4560)
INSERT INTO `guild_item_points` VALUES (0,4479,5,900,4560,5); -- Bhefhel Marlin (900 / 4560)
INSERT INTO `guild_item_points` VALUES (0,4317,5,120,2800,6); -- Trilobite (120 / 2800)
INSERT INTO `guild_item_points` VALUES (0,4399,5,900,4560,7); -- Bluetail (900 / 4560)

-- Fishing / Craftsman
INSERT INTO `guild_item_points` VALUES (0,4473,6,1320,5120,0); -- Crescent Fish (1320 / 5120)
INSERT INTO `guild_item_points` VALUES (0,4473,6,1320,5120,1); -- Crescent Fish (1320 / 5120)
INSERT INTO `guild_item_points` VALUES (0,4288,6,1200,5040,2); -- Trumpet Shell -> Zebra Eel (1200/5040)
INSERT INTO `guild_item_points` VALUES (0,4288,6,1200,5040,3); -- Zebra Eel (1200 / 5040)
INSERT INTO `guild_item_points` VALUES (0,4471,6,1200,5040,4); -- Bladefish (1200 / 5040)
INSERT INTO `guild_item_points` VALUES (0,4288,6,1200,5040,5); -- Zebra Eel (1200 / 5040)
INSERT INTO `guild_item_points` VALUES (0,4473,6,1320,5120,6); -- Crescent Fish (1320 / 5120)
INSERT INTO `guild_item_points` VALUES (0,4485,6,1200,5040,7); -- Noble Lady (1200 / 5040)

-- Fishing / Artisan
INSERT INTO `guild_item_points` VALUES (0,4477,7,1500,5360,0); -- Gavial Fish (1500 / 5360)
INSERT INTO `guild_item_points` VALUES (0,4307,7,1800,5600,1); -- Jungle Catfish (1800 / 5600)
INSERT INTO `guild_item_points` VALUES (0,4478,7,1500,5360,2); -- Three-eyed Fish (1500 / 5360)
INSERT INTO `guild_item_points` VALUES (0,4307,7,1800,5600,3); -- Jungle Catfish (1800 / 5600)
INSERT INTO `guild_item_points` VALUES (0,4451,7,1500,5360,4); -- Silver Shark (1500 / 5360)
INSERT INTO `guild_item_points` VALUES (0,4478,7,1500,5360,5); -- Three-eyed Fish (1500 / 5360)
INSERT INTO `guild_item_points` VALUES (0,4477,7,1500,5360,6); -- Gavial Fish (1500 / 5360)
INSERT INTO `guild_item_points` VALUES (0,4451,7,1500,5360,7); -- Silver Shark (1500 / 5360)

-- Fishing / Adept
INSERT INTO `guild_item_points` VALUES (0,4454,8,1800,5680,0); -- Emperor Fish (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (0,4454,8,1800,5680,1); -- Emperor Fish (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (0,4461,8,1800,5680,2); -- Bastore Bream (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (0,4304,8,2100,5840,3); -- Grimmonite (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4474,8,1800,5680,4); -- Gigant Squid (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (0,4304,8,2100,5840,5); -- Grimmonite (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4474,8,1800,5680,6); -- Gigant Squid (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (0,4304,8,2100,5840,7); -- Grimmonite (2100 / 5840)

-- Fishing / Veteran
INSERT INTO `guild_item_points` VALUES (0,4475,9,2100,5840,0); -- Sea Zombie (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4476,9,2100,5840,1); -- Titanictus (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4475,9,2100,5840,2); -- Sea Zombie (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4316,9,2850,6240,3); -- Armored Pisces (2850 / 6240)
INSERT INTO `guild_item_points` VALUES (0,4476,9,2100,5840,4); -- Titanictus (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4463,9,2100,5840,5); -- Takitaro (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4463,9,2100,5840,6); -- Takitaro (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (0,4384,9,2100,5360,7); -- Black Sole: max 5840 -> 5360

-- Woodworking / Amateur
INSERT INTO `guild_item_points` VALUES (1,17095,0,105,1680,0); -- Ash Pole (105 / 1680)
INSERT INTO `guild_item_points` VALUES (1,17122,0,120,1680,0); -- Ash Pole +1 (120 / 1680)
INSERT INTO `guild_item_points` VALUES (1,17049,0,13,1200,1); -- Humus -> Maple Wand (13/1200)
INSERT INTO `guild_item_points` VALUES (1,17087,0,13,1200,1); -- Rich Humus -> Maple Wand +1 (13/1200)
INSERT INTO `guild_item_points` VALUES (1,22,0,94,1600,2); -- Workbench (94 / 1600)
INSERT INTO `guild_item_points` VALUES (1,17088,0,16,1200,3); -- Workbench -> Ash Staff (16/1200)
INSERT INTO `guild_item_points` VALUES (1,17024,0,18,1200,4); -- Lauan Shield -> Ash Club (18/1200)
INSERT INTO `guild_item_points` VALUES (1,17137,0,26,1200,4); -- Lauan Shield +1 -> Ash Club +1 (26/1200)
INSERT INTO `guild_item_points` VALUES (1,16832,0,27,1280,5); -- Harpoon (27 / 1280)
INSERT INTO `guild_item_points` VALUES (1,16862,0,30,1280,5); -- Harpoon +1 (30 / 1280)
INSERT INTO `guild_item_points` VALUES (1,12289,0,30,1280,6); -- Lauan Shield (30 / 1280)
INSERT INTO `guild_item_points` VALUES (1,12333,0,38,1280,6); -- Lauan Shield +1 (38 / 1280)
INSERT INTO `guild_item_points` VALUES (1,17345,0,12,1120,7); -- Humus -> Flute (12/1120)
INSERT INTO `guild_item_points` VALUES (1,17372,0,14,1120,7); -- Rich Humus -> Flute +1 (14/1120)
INSERT INTO `guild_item_points` VALUES (1,17123,0,24,1200,3); -- Ash Staff +1 - Amateur Pattern D

-- Woodworking / Recruit
INSERT INTO `guild_item_points` VALUES (1,17153,1,134,2080,0); -- Self Bow (134 / 2080)
INSERT INTO `guild_item_points` VALUES (1,17176,1,154,2080,0); -- Self Bow +1 (154 / 2080)
INSERT INTO `guild_item_points` VALUES (1,12985,1,325,2800,1); -- Holly Clogs (325 / 2800)
INSERT INTO `guild_item_points` VALUES (1,12991,1,406,2800,1); -- Holly Clogs +1 (406 / 2800)
INSERT INTO `guild_item_points` VALUES (1,12984,1,31,1520,2); -- Bamboo Fishing Rod -> Ash Clogs (31/1520)
INSERT INTO `guild_item_points` VALUES (1,23,1,158,2160,3); -- Maple Table (158 / 2160)
INSERT INTO `guild_item_points` VALUES (1,17050,1,74,1760,4); -- Willow Wand (74 / 1760)
INSERT INTO `guild_item_points` VALUES (1,17138,1,119,1760,4); -- Willow Wand +1 (119 / 1760)
INSERT INTO `guild_item_points` VALUES (1,17216,1,45,1600,5); -- Light Crossbow (45 / 1600)
INSERT INTO `guild_item_points` VALUES (1,17228,1,53,1600,5); -- Light Crossbow +1 (53 / 1600)
INSERT INTO `guild_item_points` VALUES (1,17096,1,423,3120,6); -- Holly Pole (423 / 3120)
INSERT INTO `guild_item_points` VALUES (1,17124,1,435,3120,6); -- Holly Pole +1 (435 / 3120)
INSERT INTO `guild_item_points` VALUES (1,12290,1,121,2000,7); -- Maple Shield  (121 / 2000)
INSERT INTO `guild_item_points` VALUES (1,12330,1,152,2000,7); -- Maple Shield +1 (152 / 2000)
INSERT INTO `guild_item_points` VALUES (1,12983,1,39,1520,2); -- Ash Clogs +1 - Recruit Pattern C

-- Woodworking / Initiate
INSERT INTO `guild_item_points` VALUES (1,17051,2,266,2720,0); -- Yew Wand: 261 -> 266
INSERT INTO `guild_item_points` VALUES (1,17140,2,414,2720,0); -- Yew Wand +1 (414 / 2720)
INSERT INTO `guild_item_points` VALUES (1,17353,2,12,1680,1); -- Shihei -> Maple Harp (12/1680)
INSERT INTO `guild_item_points` VALUES (1,92,2,246,2720,2); -- Tarutaru Stool (246 / 2720)
INSERT INTO `guild_item_points` VALUES (1,17354,2,500,3440,3); -- Harp (500 / 3440)
INSERT INTO `guild_item_points` VALUES (1,17374,2,600,3440,3); -- Harp +1 (600 / 3440)
INSERT INTO `guild_item_points` VALUES (1,16834,2,400,3200,4); -- Brass Spear (400 / 3200)
INSERT INTO `guild_item_points` VALUES (1,16864,2,410,3200,4); -- Brass Spear +1 (410 / 3200)
INSERT INTO `guild_item_points` VALUES (1,12291,2,363,3120,5); -- Elm Shield (363 / 3120)
INSERT INTO `guild_item_points` VALUES (1,12319,2,457,3120,5); -- Elm Shield +1 (457 / 3120)
INSERT INTO `guild_item_points` VALUES (1,17090,2,601,3680,6); -- Elm Staff (601 / 3680)
INSERT INTO `guild_item_points` VALUES (1,17126,2,887,3680,6); -- Elm Staff +1 (887 / 3680)
INSERT INTO `guild_item_points` VALUES (1,17025,2,290,2880,7); -- Chestnut Club (290 / 2880)
INSERT INTO `guild_item_points` VALUES (1,17139,2,447,2880,7); -- Solid Club (447 / 2880)
INSERT INTO `guild_item_points` VALUES (1,17373,2,14,1680,1); -- Maple Harp +1 - Initiate Pattern B

-- Woodworking / Novice
INSERT INTO `guild_item_points` VALUES (1,17217,3,471,3520,0); -- Crossbow (471 / 3520)
INSERT INTO `guild_item_points` VALUES (1,17225,3,471,3520,0); -- Crossbow +1 (471 / 3520)
INSERT INTO `guild_item_points` VALUES (1,17155,3,1250,4880,1); -- Composite Bow (1250 / 4880)
INSERT INTO `guild_item_points` VALUES (1,17179,3,1300,4880,1); -- Composite Bow +1 (1300 / 4880)
INSERT INTO `guild_item_points` VALUES (1,17162,3,3116,6240,2); -- Great Bow (3116 / 6240)
INSERT INTO `guild_item_points` VALUES (1,17180,3,3496,6240,2); -- Great Bow  +1 (3496 / 6240)
INSERT INTO `guild_item_points` VALUES (1,17424,3,300,3040,3); -- Spiked Club (300 / 3040)
INSERT INTO `guild_item_points` VALUES (1,17425,3,330,3040,3); -- Spiked Club +1 (330 / 3040)
INSERT INTO `guild_item_points` VALUES (1,12986,3,612,3840,4); -- Chestnut Sabots (612 / 3840)
INSERT INTO `guild_item_points` VALUES (1,13022,3,646,3840,4); -- Chestnut Sabots +1 (646 / 3840)
INSERT INTO `guild_item_points` VALUES (1,17052,3,714,4080,5); -- Chestnut Wand (714 / 4080)
INSERT INTO `guild_item_points` VALUES (1,17141,3,1134,4080,5); -- Solid Wand (1134 / 4080)
INSERT INTO `guild_item_points` VALUES (1,12292,3,830,4320,6); -- Mahogany Shield (830 / 4320)
INSERT INTO `guild_item_points` VALUES (1,12334,3,1043,4320,6); -- Strong Shield (1043 / 4320)
INSERT INTO `guild_item_points` VALUES (1,16835,3,840,4320,7); -- Spear (840 / 4320)
INSERT INTO `guild_item_points` VALUES (1,16865,3,870,4320,7); -- Spear +1 (870 / 4320)

-- Woodworking / Apprentice
INSERT INTO `guild_item_points` VALUES (1,12987,4,1344,5040,0); -- Ebony Sabots (1344 / 5040)
INSERT INTO `guild_item_points` VALUES (1,13023,4,1400,5040,0); -- Ebony Sabots +1 (1400 / 5040)
INSERT INTO `guild_item_points` VALUES (1,17091,4,1218,4960,1); -- Oak Staff (1218 / 4960)
INSERT INTO `guild_item_points` VALUES (1,17127,4,1798,4960,1); -- Oak Staff +1 (1798 / 4960)
INSERT INTO `guild_item_points` VALUES (1,16845,4,1535,5280,2); -- Lance (1535 / 5280)
INSERT INTO `guild_item_points` VALUES (1,16876,4,1561,5280,2); -- Lance +1 (1561 / 5280)
INSERT INTO `guild_item_points` VALUES (1,17218,4,1710,5440,3); -- Zamburak (1710 / 5440)
INSERT INTO `guild_item_points` VALUES (1,17229,4,1748,5440,3); -- Zamburak +1 (1748 / 5440)
INSERT INTO `guild_item_points` VALUES (1,17027,4,1248,4960,4); -- Oak Cudgel (1248 / 4960)
INSERT INTO `guild_item_points` VALUES (1,17142,4,1768,4960,4); -- Oak Cudgel +1 (1768 / 4960)
INSERT INTO `guild_item_points` VALUES (1,16836,4,1350,5040,5); -- Halberd (1350 / 5040)
INSERT INTO `guild_item_points` VALUES (1,16866,4,1400,5040,5); -- Halberd +1 (1400 / 5040)
INSERT INTO `guild_item_points` VALUES (1,17053,4,1360,5120,6); -- Rose Wand (1360 / 5120)
INSERT INTO `guild_item_points` VALUES (1,17143,4,2160,5120,6); -- Rose Wand +1 (2160 / 5120)
INSERT INTO `guild_item_points` VALUES (1,12293,4,1950,5600,7); -- Oak Shield (1950 / 5600)
INSERT INTO `guild_item_points` VALUES (1,12331,4,2450,5600,7); -- Oak Shield +1 (2450 / 5600)

-- Woodworking / Journeyman
INSERT INTO `guild_item_points` VALUES (1,17355,5,2500,6000,0); -- Rose Harp (2500 / 6000)
INSERT INTO `guild_item_points` VALUES (1,17376,5,3000,6000,0); -- Rose Harp +1 (3000 / 6000)
INSERT INTO `guild_item_points` VALUES (1,17030,5,1102,4880,1); -- Great Club (1102 / 4880)
INSERT INTO `guild_item_points` VALUES (1,17408,5,1160,4880,1); -- Great Club +1 (1160 / 4880)
INSERT INTO `guild_item_points` VALUES (1,16847,5,2580,6000,2); -- Mythril Lance (2580 / 6000)
INSERT INTO `guild_item_points` VALUES (1,16877,5,2640,6000,2); -- Mythril Lance +1 (2640 / 6000)
INSERT INTO `guild_item_points` VALUES (1,17219,5,2550,6000,3); -- Arbalest (2550 / 6000)
INSERT INTO `guild_item_points` VALUES (1,17226,5,2625,6000,3); -- Arbalest +1 (2625 / 6000)
INSERT INTO `guild_item_points` VALUES (1,16871,5,4070,6560,4); -- Kamayari: max 6562 -> 6560
INSERT INTO `guild_item_points` VALUES (1,16872,5,4162,6562,4); -- Kamayari +1 (4162 / 6562)
INSERT INTO `guild_item_points` VALUES (1,17164,5,4080,6560,5); -- War Bow (4080 / 6560)
INSERT INTO `guild_item_points` VALUES (1,17173,5,4160,6560,5); -- War Bow +1 (4160 / 6560)
INSERT INTO `guild_item_points` VALUES (1,17098,5,1560,5360,6); -- Oak Pole (1560 / 5360)
INSERT INTO `guild_item_points` VALUES (1,17120,5,1620,5360,6); -- Oak Pole +1 (1620 / 5360)
INSERT INTO `guild_item_points` VALUES (1,21,5,158,2880,7); -- Kaman -> Desk (158/2880)
-- Remove Kaman +1 (no HQ for Desk)

-- Woodworking / Craftsman
INSERT INTO `guild_item_points` VALUES (1,49,6,1278,5120,0); -- Coffer (1278 / 5120)
INSERT INTO `guild_item_points` VALUES (1,17157,6,3655,6480,1); -- Rapid Bow (3655 / 6480)
INSERT INTO `guild_item_points` VALUES (1,17189,6,3762,6480,1); -- Rapid Bow +1 (3762 / 6480)
INSERT INTO `guild_item_points` VALUES (1,17054,6,1912,5680,2); -- Ebony Wand (1912 / 5680)
INSERT INTO `guild_item_points` VALUES (1,17427,6,3037,5680,2); -- Ebony Wand +1 (3037 / 5680)
INSERT INTO `guild_item_points` VALUES (1,17561,6,4375,6640,3); -- Partisan -> Revenging Staff (4375/6640)
INSERT INTO `guild_item_points` VALUES (1,17562,6,5031,6640,3); -- Partisan +1 -> Revenging Staff +1 (5031/6640)
INSERT INTO `guild_item_points` VALUES (1,51,6,195,3200,4); -- Chest (195 / 3200)
INSERT INTO `guild_item_points` VALUES (1,17092,6,2310,5920,5); -- Mahogany Staff (2310 / 5920)
INSERT INTO `guild_item_points` VALUES (1,17520,6,2310,5920,5); -- Heavy Staff (2310 / 5920)
INSERT INTO `guild_item_points` VALUES (1,17350,6,1200,5040,6); -- Angel's Flute (1200 / 5040)
INSERT INTO `guild_item_points` VALUES (1,17378,6,1280,5040,6); -- Angel's Flute +1 (1280 / 5040)
INSERT INTO `guild_item_points` VALUES (1,17240,6,3300,6320,7); -- Mahogany Pole -> Lightning Bow (3300/6320)
INSERT INTO `guild_item_points` VALUES (1,17241,6,4125,6320,7); -- Mahogany Pole +1 -> Lightning Bow +1 (4125/6320)

-- Woodworking / Artisan
INSERT INTO `guild_item_points` VALUES (1,56,7,4900,6800,0); -- Commode (4900 / 6800)
INSERT INTO `guild_item_points` VALUES (1,12295,7,2817,6160,1); -- Round Shield (2817 / 6160)
INSERT INTO `guild_item_points` VALUES (1,12352,7,2990,6160,1); -- Round Shield +1 (2990 / 6160)
INSERT INTO `guild_item_points` VALUES (1,95,7,2500,6000,2); -- Water Barrel (2500 / 6000)
INSERT INTO `guild_item_points` VALUES (1,59,7,4594,6720,3); -- Chiffonier (4594 / 6720)
INSERT INTO `guild_item_points` VALUES (1,30,7,7010,7120,4); -- Bureau (7010 / 7120)
INSERT INTO `guild_item_points` VALUES (1,104,7,427,3920,5); -- Tarutaru Folding Screen (427 / 3920)
INSERT INTO `guild_item_points` VALUES (1,17100,7,4350,6640,6); -- Ebony Pole (4350 / 6640)
INSERT INTO `guild_item_points` VALUES (1,17525,7,4495,6640,6); -- Ebony Pole +1 (4495 / 6640)
INSERT INTO `guild_item_points` VALUES (1,17357,7,2587,6080,7); -- Couse -> Ebony Harp (2587/6080)
INSERT INTO `guild_item_points` VALUES (1,17833,7,2700,6080,7); -- Couse +1 -> Ebony Harp +1 (2700/6080)

-- Woodworking / Adept
INSERT INTO `guild_item_points` VALUES (1,16849,8,2650,6160,0); -- Cermet Lance (2650 / 6160)
INSERT INTO `guild_item_points` VALUES (1,16879,8,3312,6160,0); -- Cermet Lance +1 (3312 / 6160)
INSERT INTO `guild_item_points` VALUES (1,17441,8,600,4320,1); -- Mythic Harp -> Eremite's Wand (600/4320)
INSERT INTO `guild_item_points` VALUES (1,17442,8,690,4320,1); -- Mythic Harp +1 -> Eremite's Wand +1 (690/4320)
INSERT INTO `guild_item_points` VALUES (1,17101,8,4740,6800,2); -- Mythic Pole (4740 / 6800)
INSERT INTO `guild_item_points` VALUES (1,17526,8,5727,6800,2); -- Mythic Pole +1 (5727 / 6800)
INSERT INTO `guild_item_points` VALUES (1,17236,8,6235,7040,3); -- Credenza -> Leo Crossbow (6235/7040)
INSERT INTO `guild_item_points` VALUES (1,17221,8,5425,6880,4); -- Repeating Crossbow (5425 / 6880)
INSERT INTO `guild_item_points` VALUES (1,17233,8,6200,6880,4); -- Machine Crossbow (6200 / 6880)
INSERT INTO `guild_item_points` VALUES (1,12364,8,2560,6080,5); -- Nymph Shield (2560 / 6080)
INSERT INTO `guild_item_points` VALUES (1,12365,8,2760,6080,5); -- Nymph Shield +1 (2760 / 6080)
INSERT INTO `guild_item_points` VALUES (1,16890,8,1200,5120,6); -- Armoire -> Obelisk Lance (1200/5120)
INSERT INTO `guild_item_points` VALUES (1,55,8,3200,6320,7); -- Cabinet (3200 / 6320)
INSERT INTO `guild_item_points` VALUES (1,17237,8,7040,7040,3); -- Leo Crossbow +1 - Adept Pattern D
INSERT INTO `guild_item_points` VALUES (1,16891,8,1300,5120,6); -- Obelisk Lance +1 - Adept Pattern G

-- Woodworking / Veteran
INSERT INTO `guild_item_points` VALUES (1,16840,9,7200,7200,0); -- Ox Tongue: 7950/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (1,16894,9,7200,7200,0); -- Ox Tongue +1: 7950/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (1,17205,9,7440,7440,1); -- Gendawa: 11305/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (1,17206,9,7440,7440,1); -- Gendawa +1: 12255/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (1,18142,9,7680,7680,2); -- Shigeto Bow: 18550/7680 -> 7680/7680
INSERT INTO `guild_item_points` VALUES (1,18143,9,18550,7680,2); -- Shigeto Bow +1 (18550 / 7680)
INSERT INTO `guild_item_points` VALUES (1,17102,9,1200,5200,3); -- Eight-Sided Pole (1200 / 5200)
INSERT INTO `guild_item_points` VALUES (1,17568,9,1800,5200,3); -- Eight-Sided Pole +1 (1800 / 5200)
INSERT INTO `guild_item_points` VALUES (1,139,9,7520,7520,4); -- Star Globe: 13430/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (1,17364,9,5697,6960,5); -- Cythara Anglica (5697 / 6960)
INSERT INTO `guild_item_points` VALUES (1,17837,9,7022,6960,5); -- Cythara Anglica +1 (7022 / 6960)
INSERT INTO `guild_item_points` VALUES (1,76,9,7520,7520,6); -- Royal Bookshelf: 14625/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (1,77,9,7520,7520,7); -- Bookshelf: 14600/7520 -> 7520/7520

-- Blacksmithing / Amateur
INSERT INTO `guild_item_points` VALUES (2,16390,0,61,1440,0); -- Bronze Knuckles (61 / 1440)
INSERT INTO `guild_item_points` VALUES (2,16440,0,61,1440,0); -- Bronze Knuckles +1 (61 / 1440)
INSERT INTO `guild_item_points` VALUES (2,16535,0,67,1440,1); -- Bronze Sword (67 / 1440)
INSERT INTO `guild_item_points` VALUES (2,16623,0,67,1440,1); -- Bronze Sword +1: 75/1440 -> 67/1440
INSERT INTO `guild_item_points` VALUES (2,16530,0,168,2000,2); -- Xiphos (168 / 2000)
INSERT INTO `guild_item_points` VALUES (2,16624,0,188,2000,2); -- Xiphos +1 (188 / 2000)
INSERT INTO `guild_item_points` VALUES (2,16448,0,39,1280,3); -- Hatchet -> Bronze Dagger (39/1280)
INSERT INTO `guild_item_points` VALUES (2,16768,0,86,1600,4); -- Bronze Zaghnal (86 / 1600)
INSERT INTO `guild_item_points` VALUES (2,16778,0,93,1600,4); -- Bronze Zaghnal +1 (93 / 1600)
INSERT INTO `guild_item_points` VALUES (2,16465,0,41,1360,5); -- Faceguard -> Bronze Knife (41/1360)
INSERT INTO `guild_item_points` VALUES (2,16491,0,48,1360,5); -- Faceguard +1 -> Bronze Knife +1 (48/1360)
INSERT INTO `guild_item_points` VALUES (2,17034,0,47,1360,6); -- Bronze Mace (47 / 1360)
INSERT INTO `guild_item_points` VALUES (2,17086,0,57,1360,6); -- Bronze Mace +1 (57 / 1360)
INSERT INTO `guild_item_points` VALUES (2,16640,0,79,1520,7); -- Bronze Axe (79 / 1520)
INSERT INTO `guild_item_points` VALUES (2,16646,0,86,1520,7); -- Bronze Axe +1 (86 / 1520)
INSERT INTO `guild_item_points` VALUES (2,16492,0,47,1280,3); -- Bronze Dagger +1 - Amateur Pattern D

-- Blacksmithing / Recruit
INSERT INTO `guild_item_points` VALUES (2,12816,1,358,2880,0); -- Scale Cuisses (358 / 2880)
INSERT INTO `guild_item_points` VALUES (2,12863,1,410,2880,0); -- Solid Cuisses (410 / 2880)
INSERT INTO `guild_item_points` VALUES (2,12944,1,217,2400,1); -- Scale Greaves (217 / 2400)
INSERT INTO `guild_item_points` VALUES (2,13024,1,269,2400,1); -- Solid Greaves (269 / 2400)
INSERT INTO `guild_item_points` VALUES (2,12299,1,189,2320,2); -- Aspis (189 / 2320)
INSERT INTO `guild_item_points` VALUES (2,12325,1,233,2320,2); -- Aspis +1 (233 / 2320)
INSERT INTO `guild_item_points` VALUES (2,17042,1,85,1840,3); -- Bronze Hammer (85 / 1840)
INSERT INTO `guild_item_points` VALUES (2,17144,1,100,1840,3); -- Bronze Hammer +1 (100 / 1840)
INSERT INTO `guild_item_points` VALUES (2,17059,1,25,1520,4); -- Dagger -> Bronze Rod (25/1520)
INSERT INTO `guild_item_points` VALUES (2,17111,1,25,1520,4); -- Dagger +1 -> Bronze Rod +1 (25/1520)
INSERT INTO `guild_item_points` VALUES (2,12560,1,446,3200,5); -- Scale Mail (446 / 3200)
INSERT INTO `guild_item_points` VALUES (2,12661,1,498,3200,5); -- Solid Mail (498 / 3200)
INSERT INTO `guild_item_points` VALUES (2,12688,1,238,2480,6); -- Scale Finger Gauntlets (238 / 2480)
INSERT INTO `guild_item_points` VALUES (2,12768,1,290,2480,6); -- Solid Finger Gauntlets (290 / 2480)
INSERT INTO `guild_item_points` VALUES (2,12576,1,64,1680,7); -- Bronze Harness (64 / 1680)
INSERT INTO `guild_item_points` VALUES (2,12607,1,64,1680,7); -- Bronze Harness +1 (64 / 1680)

-- Blacksmithing / Initiate
INSERT INTO `guild_item_points` VALUES (2,17035,2,808,4160,0); -- Mace (808 / 4160)
INSERT INTO `guild_item_points` VALUES (2,17145,2,980,4160,0); -- Mace +1 (980 / 4160)
INSERT INTO `guild_item_points` VALUES (2,13871,2,3024,6160,1); -- Iron Visor (3024 / 6160)
INSERT INTO `guild_item_points` VALUES (2,13872,2,3078,6160,1); -- Iron Visor +1 (3078 / 6160)
INSERT INTO `guild_item_points` VALUES (2,16466,2,485,3440,2); -- Knife (485 / 3440)
INSERT INTO `guild_item_points` VALUES (2,16614,2,578,3440,2); -- Knife +1 (578 / 3440)
INSERT INTO `guild_item_points` VALUES (2,16552,2,905,4320,3); -- Scimitar (905 / 4320)
INSERT INTO `guild_item_points` VALUES (2,16625,2,998,4320,3); -- Scimitar +1 (998 / 4320)
INSERT INTO `guild_item_points` VALUES (2,16406,2,1440,5040,4); -- Baghnakhs (1440 / 5040)
INSERT INTO `guild_item_points` VALUES (2,16444,2,1740,5040,4); -- Baghnakhs +1 (1740 / 5040)
INSERT INTO `guild_item_points` VALUES (2,16566,2,1536,5200,5); -- Longsword (1536 / 5200)
INSERT INTO `guild_item_points` VALUES (2,16628,2,1689,5200,5); -- Longsword +1 (1689 / 5200)
INSERT INTO `guild_item_points` VALUES (2,16704,2,168,2400,6); -- Butterfly Axe (168 / 2400)
INSERT INTO `guild_item_points` VALUES (2,16716,2,183,2400,6); -- Butterfly Axe +1 (183 / 2400)
INSERT INTO `guild_item_points` VALUES (2,16392,2,873,4240,7); -- Metal Knuckles (873 / 4240)
INSERT INTO `guild_item_points` VALUES (2,16437,2,873,4240,7); -- Metal Knuckles +1 (873 / 4240)

-- Blacksmithing / Novice
INSERT INTO `guild_item_points` VALUES (2,12300,3,1720,5360,0); -- Targe: 680/4000 -> 1720/5360
INSERT INTO `guild_item_points` VALUES (2,12335,3,2120,5360,0); -- Targe +1: 1000/4000 -> 2120/5360
INSERT INTO `guild_item_points` VALUES (2,16524,3,2128,5680,1); -- Fleuret (2128 / 5680)
INSERT INTO `guild_item_points` VALUES (2,16803,3,3648,5680,1); -- Fleuret +1 (3648 / 5680)
INSERT INTO `guild_item_points` VALUES (2,16513,3,2146,5680,2); -- Tuck (2146 / 5680)
INSERT INTO `guild_item_points` VALUES (2,16617,3,2432,5680,2); -- Tuck +1 (2432 / 5680)
INSERT INTO `guild_item_points` VALUES (2,16900,3,300,3040,3); -- Wakizashi (300 / 3040)
INSERT INTO `guild_item_points` VALUES (2,16918,3,302,3040,3); -- Wakizashi +1 (302 / 3040)
INSERT INTO `guild_item_points` VALUES (2,17060,3,442,3440,4); -- Rod (442 / 3440)
INSERT INTO `guild_item_points` VALUES (2,17146,3,702,3440,4); -- Rod +1 (702 / 3440)
INSERT INTO `guild_item_points` VALUES (2,13783,3,4644,6720,5); -- Iron Scale Mail (4644 / 6720)
INSERT INTO `guild_item_points` VALUES (2,13784,3,5184,6720,5); -- Iron Scale Mail +1 (5184 / 6720)
INSERT INTO `guild_item_points` VALUES (2,17036,3,2256,5760,6); -- Mythril Mace (2256 / 5760)
INSERT INTO `guild_item_points` VALUES (2,17147,3,2736,5760,6); -- Mythril Mace +1 (2736 / 5760)
INSERT INTO `guild_item_points` VALUES (2,16705,3,910,4400,7); -- Greataxe (910 / 4400)
INSERT INTO `guild_item_points` VALUES (2,16717,3,991,4400,7); -- Greataxe +1 (991 / 4400)

-- Blacksmithing / Apprentice
INSERT INTO `guild_item_points` VALUES (2,16919,4,933,4560,0); -- Shinobi-Gatana (933 / 4560)
INSERT INTO `guild_item_points` VALUES (2,16920,4,942,4560,0); -- Shinobi-Gatana +1 (942 / 4560)
INSERT INTO `guild_item_points` VALUES (2,16775,4,6900,7040,1); -- Mythril Scythe (6900 / 7040)
INSERT INTO `guild_item_points` VALUES (2,16782,4,6900,7040,1); -- Mythril Scythe +1 (6900 / 7040)
INSERT INTO `guild_item_points` VALUES (2,16553,4,4850,6720,2); -- Tulwar (4850 / 6720)
INSERT INTO `guild_item_points` VALUES (2,16636,4,5330,6720,2); -- Tulwar +1 (5330 / 6720)
INSERT INTO `guild_item_points` VALUES (2,16475,4,2484,5920,3); -- Mythril Kukri (2484 / 5920)
INSERT INTO `guild_item_points` VALUES (2,16750,4,2944,5920,3); -- Mythril Kukri +1 (2944 / 5920)
INSERT INTO `guild_item_points` VALUES (2,16706,4,5152,6800,4); -- Heavy Axe (5152 / 6800)
INSERT INTO `guild_item_points` VALUES (2,16718,4,5612,6800,4); -- Heavy Axe +1 (5612 / 6800)
INSERT INTO `guild_item_points` VALUES (2,16644,4,5400,6880,5); -- Mythril Axe (5400 / 6880)
INSERT INTO `guild_item_points` VALUES (2,16665,4,5940,6880,5); -- Mythril Axe +1 (5940 / 6880)
INSERT INTO `guild_item_points` VALUES (2,16567,4,7750,7200,6); -- Knight's Sword (7750 / 7200)
INSERT INTO `guild_item_points` VALUES (2,16800,4,8525,7200,6); -- Knight's Sword +1 (8525 / 7200)
INSERT INTO `guild_item_points` VALUES (2,16584,4,5250,6800,7); -- Mythril Claymore (5250 / 6800)
INSERT INTO `guild_item_points` VALUES (2,16639,4,5275,6800,7); -- Fine Claymore (5275 / 6800)

-- Blacksmithing / Journeyman
INSERT INTO `guild_item_points` VALUES (2,16413,5,4320,6640,0); -- Darksteel Claws (4320 / 6640)
INSERT INTO `guild_item_points` VALUES (2,16697,5,5220,6640,0); -- Darksteel Claws +1 (5220 / 6640)
INSERT INTO `guild_item_points` VALUES (2,12544,5,5460,6880,1); -- Breastplate (5460 / 6880)
INSERT INTO `guild_item_points` VALUES (2,13724,5,6060,6880,1); -- Breastplate +1 (6060 / 6880)
INSERT INTO `guild_item_points` VALUES (2,16590,5,6758,7040,2); -- Greatsword (6758 / 7040)
INSERT INTO `guild_item_points` VALUES (2,16932,5,7040,7040,2); -- Greatsword +1: 7562/7040 -> 7040/7040
INSERT INTO `guild_item_points` VALUES (2,12416,5,3540,6400,3); -- Sallet (3540 / 6400)
INSERT INTO `guild_item_points` VALUES (2,13831,5,4140,6400,3); -- Sallet +1 (4140 / 6400)
INSERT INTO `guild_item_points` VALUES (2,16960,5,667,4160,4); -- Uchigatana (667 / 4160)
INSERT INTO `guild_item_points` VALUES (2,16978,5,667,4160,4); -- Uchigatana +1: 728/4160 -> 667/4160
INSERT INTO `guild_item_points` VALUES (2,17265,5,1866,5600,5); -- Tanegashima (1866 / 5600)
INSERT INTO `guild_item_points` VALUES (2,17266,5,1875,5600,5); -- Tanegashima +1 (1875 / 5600)
INSERT INTO `guild_item_points` VALUES (2,16519,5,7200,7200,6); -- Schlaeger: 8600/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (2,16813,5,7200,7200,6); -- Schlaeger +1: 9675/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (2,16545,5,3344,6320,7); -- Broadsword (3344 / 6320)
INSERT INTO `guild_item_points` VALUES (2,16634,5,3572,6320,7); -- Broadsword +1 (3572 / 6320)

-- Blacksmithing / Craftsman
INSERT INTO `guild_item_points` VALUES (2,12715,6,3300,6320,0); -- Kote (3300 / 6320)
INSERT INTO `guild_item_points` VALUES (2,13996,6,3300,6320,0); -- Kote +1 (3300 / 6320)
INSERT INTO `guild_item_points` VALUES (2,12459,6,3604,6480,1); -- Zunari Kabuto (3604 / 6480)
INSERT INTO `guild_item_points` VALUES (2,13865,6,3604,6480,1); -- Zunari Kabuto +1 (3604 / 6480)
INSERT INTO `guild_item_points` VALUES (2,16902,6,2310,5920,2); -- Sakurafubuki (2310 / 5920)
INSERT INTO `guild_item_points` VALUES (2,16922,6,2442,5920,2); -- Sakurafubuki +1 (2442 / 5920)
INSERT INTO `guild_item_points` VALUES (2,13111,6,2722,6160,3); -- Nodowa (2722 / 6160)
INSERT INTO `guild_item_points` VALUES (2,13124,6,3547,6160,3); -- Nodowa +1 (3547 / 6160)
INSERT INTO `guild_item_points` VALUES (2,12683,6,5170,6800,4); -- Darksteel Mufflers (5170 / 6800)
INSERT INTO `guild_item_points` VALUES (2,13976,6,6270,6800,4); -- Darksteel Mufflers +1 (6270 / 6800)
INSERT INTO `guild_item_points` VALUES (2,16476,6,5940,6960,5); -- Darksteel Kukri (5940 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16763,6,6960,6960,5); -- Darksteel Kukri +1: 7040/6960 -> 6960/6960
INSERT INTO `guild_item_points` VALUES (2,16915,6,2325,5920,6); -- Hien (2325 / 5920)
INSERT INTO `guild_item_points` VALUES (2,16916,6,2402,5920,6); -- Hien +1 (2402 / 5920)
INSERT INTO `guild_item_points` VALUES (2,16796,6,6976,7120,7); -- Mythril Zaghnal (6976 / 7120)
INSERT INTO `guild_item_points` VALUES (2,16797,6,7120,7120,7); -- Mythril Zaghnal +1: 7616/7120 -> 7120/7120

-- Blacksmithing / Artisan
INSERT INTO `guild_item_points` VALUES (2,16577,7,7440,7440,0); -- Bastard Sword: 12150/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (2,16828,7,7440,7440,0); -- Bastard Sword +1: 13257/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (2,16789,7,7440,7440,1); -- Darksteel Scythe: 12535/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (2,16790,7,12650,7440,1); -- Darksteel Scythe +1 (12650 / 7440)
INSERT INTO `guild_item_points` VALUES (2,16759,7,5670,6960,2); -- Darksteel Kris (5670 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16760,7,6720,6960,2); -- Darksteel Kris +1 (6720 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16967,7,3740,6480,3); -- Mikazuki (3740 / 6480)
INSERT INTO `guild_item_points` VALUES (2,16989,7,3808,6480,3); -- Mikazuki +1 (3808 / 6480)
INSERT INTO `guild_item_points` VALUES (2,12452,7,7020,7120,4); -- Darksteel Cap (7020 / 7120)
INSERT INTO `guild_item_points` VALUES (2,13863,7,7020,7120,4); -- Darksteel Cap +1 (7020 / 7120)
INSERT INTO `guild_item_points` VALUES (2,12839,7,7280,7280,5); -- Darksteel Subligar: 8580/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (2,14234,7,9880,7280,5); -- Darksteel Subligar +1 (9880 / 7280)
INSERT INTO `guild_item_points` VALUES (2,13812,7,7280,7280,6); -- Holy Breastplate: 9000 -> 7280
INSERT INTO `guild_item_points` VALUES (2,13813,7,7280,7280,6); -- Divine Breastplate: 9500 -> 7280
INSERT INTO `guild_item_points` VALUES (2,16526,7,7280,7280,7); -- Schwert: 9100/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (2,17635,7,7280,7280,7); -- Schwert +1: 9262/7280 -> 7280/7280

-- Blacksmithing / Adept
INSERT INTO `guild_item_points` VALUES (2,12684,8,6345,7040,0); -- Thick Mufflers (6345 / 7040)
INSERT INTO `guild_item_points` VALUES (2,14012,8,6480,7040,0); -- Thick Mufflers +1 (6480 / 7040)
INSERT INTO `guild_item_points` VALUES (2,12547,8,7440,7440,1); -- Darksteel Cuirass: 11830/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (2,13756,8,13130,7440,1); -- Darksteel Cuirass +1 (13130 / 7440)
INSERT INTO `guild_item_points` VALUES (2,17046,8,5880,6960,2); -- Darksteel Maul (5880 / 6960)
INSERT INTO `guild_item_points` VALUES (2,17432,8,6492,6960,2); -- Darksteel Maul +1 (6492 / 6960)
INSERT INTO `guild_item_points` VALUES (2,12931,8,5720,6960,3); -- Darksteel Sabatons (5720 / 6960)
INSERT INTO `guild_item_points` VALUES (2,14105,8,7020,6960,3); -- Darksteel Sabatons +1 (7020 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16658,8,7200,7200,4); -- Darksteel Tabar: 8287/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (2,16683,8,8925,7200,4); -- Darksteel Tabar +1 (8925 / 7200)
INSERT INTO `guild_item_points` VALUES (2,16950,8,7520,7520,5); -- Flanged Mace -> Mythril Heart (7520/7520)
INSERT INTO `guild_item_points` VALUES (2,16951,8,7520,7520,5); -- Flanged Mace +1 -> Mythril Heart +1 (7520/7520)
INSERT INTO `guild_item_points` VALUES (2,16596,8,7520,7520,6); -- Flamberge: 14850/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (2,16941,8,7520,7520,6); -- Flamberge +1: 14987/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (2,12803,8,6500,7400,7); -- Darksteel Cuisses: max 7040 -> 7400
INSERT INTO `guild_item_points` VALUES (2,14229,8,7150,7040,7); -- Darksteel Cuisses +1 (7150 / 7040)

-- Blacksmithing / Veteran
INSERT INTO `guild_item_points` VALUES (2,12309,9,6440,7040,0); -- Ritter Shield (6440 / 7040)
INSERT INTO `guild_item_points` VALUES (2,12358,9,7040,21120,0); -- Ritter Shield +1: 7840/7040 -> 7040/21120
INSERT INTO `guild_item_points` VALUES (2,17038,9,11925,7440,1); -- Buzdygan (11925 / 7440)
INSERT INTO `guild_item_points` VALUES (2,17460,9,13250,7440,1); -- Buzdygan +1 (13250 / 7440)
INSERT INTO `guild_item_points` VALUES (2,16452,9,4637,6720,2); -- Misericorde (4637 / 6720)
INSERT INTO `guild_item_points` VALUES (2,17620,9,5962,6720,2); -- Misericorde +1 (5962 / 6720)
INSERT INTO `guild_item_points` VALUES (2,16547,9,7280,7280,3); -- Anelace: 8820/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (2,17657,9,8820,7280,3); -- Anelace +1: 10220/7280 -> 8820/7280 (wiki)
INSERT INTO `guild_item_points` VALUES (2,17252,9,8082,7200,4); -- Culverin: max 7280 -> 7200
INSERT INTO `guild_item_points` VALUES (2,18147,9,9407,7200,4); -- Culverin +1: max 7280 -> 7200 (points cap to max)
INSERT INTO `guild_item_points` VALUES (2,16653,9,5565,6960,5); -- Nadziak (5565 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16685,9,6890,6960,5); -- Nadziak +1 (6890 / 6960)
INSERT INTO `guild_item_points` VALUES (2,16659,9,7440,7440,6); -- Tabarzin (7440 / 7440)
INSERT INTO `guild_item_points` VALUES (2,17935,9,7440,7440,6); -- Tabarzin +1 (7440 / 7440)
INSERT INTO `guild_item_points` VALUES (2,16470,9,2890,6240,7); -- Gully (2890 / 6240)
INSERT INTO `guild_item_points` VALUES (2,17621,9,3000,6240,7); -- Gully +1: 4590/6240 -> 3000/6240 (wiki)

-- Goldsmithing / Amateur
INSERT INTO `guild_item_points` VALUES (3,12449,0,327,2640,0); -- Brass Cap (327 / 2640)
INSERT INTO `guild_item_points` VALUES (3,12528,0,388,2640,0); -- Brass Cap +1 (388 / 2640)
INSERT INTO `guild_item_points` VALUES (3,16551,0,194,2080,1); -- Sapara (194 / 2080)
INSERT INTO `guild_item_points` VALUES (3,16801,0,214,2080,1); -- Sapara +1 (214 / 2080)
INSERT INTO `guild_item_points` VALUES (3,12496,0,39,1280,2); -- Copper Hairpin (39 / 1280)
INSERT INTO `guild_item_points` VALUES (3,12526,0,79,1280,2); -- Copper Hairpin +1 (79 / 1280)
INSERT INTO `guild_item_points` VALUES (3,12496,0,39,1280,3); -- Copper Hairpin (39 / 1280)
INSERT INTO `guild_item_points` VALUES (3,12526,0,79,1280,3); -- Copper Hairpin +1 (79 / 1280)
INSERT INTO `guild_item_points` VALUES (3,16551,0,194,2080,4); -- Sapara (194 / 2080)
INSERT INTO `guild_item_points` VALUES (3,16801,0,214,2080,4); -- Sapara +1 (214 / 2080)
INSERT INTO `guild_item_points` VALUES (3,13454,0,19,1200,5); -- Copper Ring (19 / 1200)
INSERT INTO `guild_item_points` VALUES (3,13492,0,21,1200,5); -- Copper Ring +1: 27/1200 -> 21/1200
INSERT INTO `guild_item_points` VALUES (3,12449,0,327,2640,6); -- Brass Cap (327 / 2640)
INSERT INTO `guild_item_points` VALUES (3,12528,0,388,2640,6); -- Brass Cap +1 (388 / 2640)
INSERT INTO `guild_item_points` VALUES (3,13454,0,19,1200,7); -- Copper Ring (19 / 1200)
INSERT INTO `guild_item_points` VALUES (3,13492,0,21,1200,7); -- Copper Ring +1: 27/1200 -> 21/1200

-- Goldsmithing / Recruit
INSERT INTO `guild_item_points` VALUES (3,12497,1,259,2560,0); -- Brass Hairpin (259 / 2560)
INSERT INTO `guild_item_points` VALUES (3,12529,1,264,2560,0); -- Brass Hairpin +1 (264 / 2560)
INSERT INTO `guild_item_points` VALUES (3,16407,1,338,2800,1); -- Brass Baghnakhs (338 / 2800)
INSERT INTO `guild_item_points` VALUES (3,16441,1,338,2800,1); -- Brass Baghnakhs +1 (338 / 2800)
INSERT INTO `guild_item_points` VALUES (3,16449,1,186,2240,2); -- Brass Dagger (186 / 2240)
INSERT INTO `guild_item_points` VALUES (3,16740,1,221,2240,2); -- Brass Dagger +1 (221 / 2240)
INSERT INTO `guild_item_points` VALUES (3,16769,1,565,3520,3); -- Brass Zaghnal: 140/2080 -> 565/3520
INSERT INTO `guild_item_points` VALUES (3,16772,1,565,3520,3); -- Brass Zaghnal +1: 181/3520 -> 565/3520
INSERT INTO `guild_item_points` VALUES (3,16391,1,180,2240,4); -- Brass Knuckles (180 / 2240)
INSERT INTO `guild_item_points` VALUES (3,16689,1,227,2240,4); -- Brass Knuckles +1: 222/2240 -> 227/2240
INSERT INTO `guild_item_points` VALUES (3,13465,1,50,1600,5); -- Brass Leggings -> Brass Ring (50/1600)
INSERT INTO `guild_item_points` VALUES (3,13493,1,70,1600,5); -- Brass Leggings +1 -> Brass Ring +1 (70/1600)
INSERT INTO `guild_item_points` VALUES (3,12577,1,497,3360,6); -- Brass Harness (497 / 3360)
INSERT INTO `guild_item_points` VALUES (3,12664,1,558,3360,6); -- Brass Harness +1 (558 / 3360)
INSERT INTO `guild_item_points` VALUES (3,16641,1,312,2720,7); -- Brass Axe (312 / 2720)
INSERT INTO `guild_item_points` VALUES (3,16661,1,343,2720,7); -- Brass Axe +1 (343 / 2720)

-- Goldsmithing / Initiate
INSERT INTO `guild_item_points` VALUES (3,12473,2,414,3200,0); -- Poet's Circlet (414 / 3200)
INSERT INTO `guild_item_points` VALUES (3,12530,2,495,3200,0); -- Sage's Circlet (495 / 3200)
INSERT INTO `guild_item_points` VALUES (3,12433,2,800,4160,1); -- Brass Mask (800 / 4160)
INSERT INTO `guild_item_points` VALUES (3,12532,2,832,4160,1); -- Brass Mask +1 (832 / 4160)
INSERT INTO `guild_item_points` VALUES (3,17081,2,138,2240,2); -- Brass Rod (138 / 2240)
INSERT INTO `guild_item_points` VALUES (3,17148,2,219,2240,2); -- Brass Rod +1 (219 / 2240)
INSERT INTO `guild_item_points` VALUES (3,12495,2,345,3040,3); -- Silver Hairpin (345 / 3040)
INSERT INTO `guild_item_points` VALUES (3,12531,2,364,3040,3); -- Silver Hairpin +1 (364 / 3040)
INSERT INTO `guild_item_points` VALUES (3,17043,2,463,3360,4); -- Brass Hammer (463 / 3360)
INSERT INTO `guild_item_points` VALUES (3,17149,2,544,3360,4); -- Brass Hammer +1 (544 / 3360)
INSERT INTO `guild_item_points` VALUES (3,13196,2,798,4160,5); -- Silver Belt: 357/3040 -> 798/4160
INSERT INTO `guild_item_points` VALUES (3,13223,2,840,4160,5); -- Silver Belt +1: 441/4160 -> 840/4160
INSERT INTO `guild_item_points` VALUES (3,12689,2,736,4000,6); -- Brass Finger Gauntlets: 432/3280 -> 736/4000
INSERT INTO `guild_item_points` VALUES (3,12771,2,768,4000,6); -- Brass Finger Gauntlets +1: 544/3280 -> 768/4000
INSERT INTO `guild_item_points` VALUES (3,13327,2,250,2720,7); -- Silver Earring (250 / 2720)
INSERT INTO `guild_item_points` VALUES (3,13370,2,350,2720,7); -- Silver Earring +1 (350 / 2720)

-- Goldsmithing / Novice
INSERT INTO `guild_item_points` VALUES (3,13083,3,810,4240,0); -- Chain Choker (810 / 4240)
INSERT INTO `guild_item_points` VALUES (3,13066,3,1110,4240,0); -- Red Choker (1110 / 4240)
INSERT INTO `guild_item_points` VALUES (3,12817,3,768,4160,1); -- Brass Cuisses: 672/4000 -> 768/4160
INSERT INTO `guild_item_points` VALUES (3,12893,3,800,4160,1); -- Brass Cuisses +1: 752/4160 -> 800/4160
INSERT INTO `guild_item_points` VALUES (3,13209,3,1020,4560,2); -- Chain Belt (1020 / 4560)
INSERT INTO `guild_item_points` VALUES (3,13213,3,1340,4560,2); -- Chain Belt +1: 1320/4560 -> 1340/4560
INSERT INTO `guild_item_points` VALUES (3,12425,3,2850,6080,3); -- Silver Mask (2850 / 6080)
INSERT INTO `guild_item_points` VALUES (3,12533,3,3350,6080,3); -- Silver Mask +1 (3350 / 6080)
INSERT INTO `guild_item_points` VALUES (3,17686,3,669,4000,4); -- Spark Bilbo (669 / 4000)
INSERT INTO `guild_item_points` VALUES (3,17687,3,706,4000,4); -- Spark Bilbo +1 (706 / 4000)
INSERT INTO `guild_item_points` VALUES (3,13082,3,1020,4560,5); -- Chain Gorget (1020 / 4560)
INSERT INTO `guild_item_points` VALUES (3,13059,3,1320,4560,5); -- Fine Gorget (1320 / 4560)
INSERT INTO `guild_item_points` VALUES (3,12681,3,2350,5840,6); -- Silver Mittens (2350 / 5840)
INSERT INTO `guild_item_points` VALUES (3,12772,3,2850,5840,6); -- Silver Mittens +1 (2850 / 5840)
INSERT INTO `guild_item_points` VALUES (3,18076,3,240,2880,7); -- Spark Spear (240 / 2880)
INSERT INTO `guild_item_points` VALUES (3,18077,3,390,2880,7); -- Spark Spear +1 (390 / 2880)

-- Goldsmithing / Apprentice
INSERT INTO `guild_item_points` VALUES (3,12426,4,4275,6640,0); -- Banded Helm (4275 / 6640)
INSERT INTO `guild_item_points` VALUES (3,13832,4,5025,6640,0); -- Banded Helm +1 (5025 / 6640)
INSERT INTO `guild_item_points` VALUES (3,12301,4,3117,6240,1); -- Buckler: max 6090 -> 6240
INSERT INTO `guild_item_points` VALUES (3,12327,4,3842,6090,1); -- Buckler +1 (3842 / 6090)
INSERT INTO `guild_item_points` VALUES (3,16456,4,1976,5600,2); -- Mythril Baselard (1976 / 5600)
INSERT INTO `guild_item_points` VALUES (3,16752,4,2028,5600,2); -- Fine Baselard (2028 / 5600)
INSERT INTO `guild_item_points` VALUES (3,13446,4,750,4240,3); -- Mythril Ring (750 / 4240)
INSERT INTO `guild_item_points` VALUES (3,13519,4,750,4240,3); -- Mythril Ring +1: 1050/4240 -> 750/4240
INSERT INTO `guild_item_points` VALUES (3,12553,4,4400,6640,4); -- Silver Mail (4400 / 6640)
INSERT INTO `guild_item_points` VALUES (3,12666,4,4900,6640,4); -- Silver Mail +1 (4900 / 6640)
INSERT INTO `guild_item_points` VALUES (3,12938,4,3225,6320,5); -- Sollerets (3225 / 6320)
INSERT INTO `guild_item_points` VALUES (3,13047,4,3975,6320,5); -- Sollerets +1 (3975 / 6320)
INSERT INTO `guild_item_points` VALUES (3,13979,4,992,4640,6); -- Silver Bangles (992 / 4640)
INSERT INTO `guild_item_points` VALUES (3,13980,4,1054,4640,6); -- Silver Bangles +1 (1054 / 4640)
INSERT INTO `guild_item_points` VALUES (3,13328,4,750,4240,7); -- Mythril Earring (750 / 4240)
INSERT INTO `guild_item_points` VALUES (3,13371,4,1050,4240,7); -- Mythril Earring +1 (1050 / 4240)

-- Goldsmithing / Journeyman
INSERT INTO `guild_item_points` VALUES (3,13445,5,1750,5520,0); -- Gold Ring (1750 / 5520)
INSERT INTO `guild_item_points` VALUES (3,13520,5,2450,5520,0); -- Gold Ring +1 (2450 / 5520)
INSERT INTO `guild_item_points` VALUES (3,17988,5,6037,6960,1); -- Spark Kris (6037 / 6960)
INSERT INTO `guild_item_points` VALUES (3,17989,5,6912,6960,1); -- Spark Kris +1 (6912 / 6960)
INSERT INTO `guild_item_points` VALUES (3,13084,5,2805,6160,2); -- Mythril Gorget (2805 / 6160)
INSERT INTO `guild_item_points` VALUES (3,13067,5,3630,6160,2); -- Mythril Gorget +1 (3630 / 6160)
INSERT INTO `guild_item_points` VALUES (3,14725,5,5250,6800,3); -- Hydro Baghnakhs -> Melody Earring (5250/6800)
INSERT INTO `guild_item_points` VALUES (3,14726,5,6000,6800,3); -- Hydro Baghnakhs +1 -> Melody Earring +1 (6000/6800)
INSERT INTO `guild_item_points` VALUES (3,12307,5,3168,6320,4); -- Heater Shield (3168 / 6320)
INSERT INTO `guild_item_points` VALUES (3,12328,5,3828,6320,4); -- Heater Shield +1 (3828 / 6320)
INSERT INTO `guild_item_points` VALUES (3,13315,5,1750,5520,5); -- Gold Earring (1750 / 5520)
INSERT INTO `guild_item_points` VALUES (3,13372,5,2450,5520,5); -- Gold Earring +1 (2450 / 5520)
INSERT INTO `guild_item_points` VALUES (3,16518,5,3100,6240,6); -- Mythril Degen (3100 / 6240)
INSERT INTO `guild_item_points` VALUES (3,16815,5,3150,6240,6); -- Mythril Degen +1 (3150 / 6240)
INSERT INTO `guild_item_points` VALUES (3,17281,5,1260,5040,7); -- Wingedge (1260 / 5040)
INSERT INTO `guild_item_points` VALUES (3,17288,5,1560,5040,7); -- Wingedge +1 (1560 / 5040)

-- Goldsmithing / Craftsman
INSERT INTO `guild_item_points` VALUES (3,12801,6,3547,6400,0); -- Mythril Cuisses (3547 / 6400)
INSERT INTO `guild_item_points` VALUES (3,14211,6,3630,6400,0); -- Mythril Cuisses +1 (3630 / 6400)
INSERT INTO `guild_item_points` VALUES (3,13983,6,3870,6560,1); -- Gold Bangles (3870 / 6560)
INSERT INTO `guild_item_points` VALUES (3,13984,6,4470,6560,1); -- Gold Bangles +1 (4470 / 6560)
INSERT INTO `guild_item_points` VALUES (3,12929,6,3630,6480,2); -- Mythril Leggings (3630 / 6480)
INSERT INTO `guild_item_points` VALUES (3,14086,6,4455,6480,2); -- Mythril Leggings +1 (4455 / 6480)
INSERT INTO `guild_item_points` VALUES (3,13447,6,6200,6960,3); -- Platinum Ring (6200 / 6960)
INSERT INTO `guild_item_points` VALUES (3,13498,6,6960,6960,3); -- Platinum Ring +1: 8800/6960 -> 6960/6960
INSERT INTO `guild_item_points` VALUES (3,12673,6,3960,6560,4); -- Mythril Gauntlets (3960 / 6560)
INSERT INTO `guild_item_points` VALUES (3,13958,6,4785,6560,4); -- Mythril Gauntlets +1 (4785 / 6560)
INSERT INTO `guild_item_points` VALUES (3,12545,6,7507,7120,5); -- Mythril Breastplate (7507 / 7120)
INSERT INTO `guild_item_points` VALUES (3,13737,6,8332,7120,5); -- Mythril Breastplate +1 (8332 / 7120)
INSERT INTO `guild_item_points` VALUES (3,16514,6,3037,6240,6); -- Mailbreaker (3037 / 6240)
INSERT INTO `guild_item_points` VALUES (3,16618,6,3150,6240,6); -- Mailbreaker +1 (3150 / 6240)
INSERT INTO `guild_item_points` VALUES (3,12801,6,3547,6400,7); -- Mythril Cuisses (3547 / 6400)
INSERT INTO `guild_item_points` VALUES (3,14211,6,3630,6400,7); -- Mythril Cuisses +1 (3630 / 6400)

-- Goldsmithing / Artisan
INSERT INTO `guild_item_points` VALUES (3,16421,7,6370,7040,0); -- Gold Patas (6370 / 7040)
INSERT INTO `guild_item_points` VALUES (3,17489,7,6492,7040,0); -- Gold Patas +1 (6492 / 7040)
INSERT INTO `guild_item_points` VALUES (3,16395,7,5637,6880,1); -- Diamond Knuckles (5637 / 6880)
INSERT INTO `guild_item_points` VALUES (3,17480,7,5775,6880,1); -- Diamond Knuckles +1 (5775 / 6880)
INSERT INTO `guild_item_points` VALUES (3,16569,7,14640,7520,2); -- Gold Sword (14640 / 7520)
INSERT INTO `guild_item_points` VALUES (3,17641,7,7520,7520,2); -- Gold Sword +1: 14792/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (3,16962,7,3250,6320,3); -- Ashura (3250 / 6320)
INSERT INTO `guild_item_points` VALUES (3,16979,7,3300,6320,3); -- Ashura +1 (3300 / 6320)
INSERT INTO `guild_item_points` VALUES (3,17285,7,3990,6560,4); -- Moonring Blade (3990 / 6560)
INSERT INTO `guild_item_points` VALUES (3,17279,7,4095,6560,4); -- Moonring Blade +1 (4095 / 6560)
INSERT INTO `guild_item_points` VALUES (3,12930,7,4950,6800,5); -- Gold Sabatons (4950 / 6800)
INSERT INTO `guild_item_points` VALUES (3,14087,7,6750,6800,5); -- Gilt Sabatons: 6075 -> 6750
INSERT INTO `guild_item_points` VALUES (3,12303,7,4080,6640,6); -- Gold Buckler (4080 / 6640)
INSERT INTO `guild_item_points` VALUES (3,12353,7,4207,6640,6); -- Gilt Buckler (4207 / 6640)
INSERT INTO `guild_item_points` VALUES (3,12802,7,3937,6560,7); -- Gold Cuisses (3937 / 6560)
INSERT INTO `guild_item_points` VALUES (3,14212,7,4050,6560,7); -- Gilt Cuisses (4050 / 6560)

-- Goldsmithing / Adept
INSERT INTO `guild_item_points` VALUES (3,16972,8,7200,7200,0); -- Kazaridachi: 7950/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (3,17805,8,7200,7200,0); -- Kazaridachi +1: 7950/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (3,12310,8,5640,6960,1); -- Diamond Shield (5640 / 6960)
INSERT INTO `guild_item_points` VALUES (3,12355,8,6815,6960,1); -- Diamond Shield +1 (6815 / 6960)
INSERT INTO `guild_item_points` VALUES (3,16842,8,5460,6880,2); -- Golden Spear (5460 / 6880)
INSERT INTO `guild_item_points` VALUES (3,16875,8,6435,6880,2); -- Golden Spear +1 (6435 / 6880)
INSERT INTO `guild_item_points` VALUES (3,13985,8,5697,6960,3); -- Platinum Bangles (5697 / 6960)
INSERT INTO `guild_item_points` VALUES (3,13986,8,7022,6960,3); -- Platinum Bangles +1 (7022 / 6960)
INSERT INTO `guild_item_points` VALUES (3,17039,8,7200,7200,4); -- Platinum Mace: 8342/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (3,17431,8,7200,7200,4); -- Platinum Mace +1: 8697/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (3,16527,8,7360,7360,5); -- Epee: 10920/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (3,16619,8,7360,7360,5); -- Epee +1: 11895/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (3,13087,8,3780,6560,6); -- Jeweled Collar (3780 / 6560)
INSERT INTO `guild_item_points` VALUES (3,13130,8,4060,6560,6); -- Jeweled Collar +1 (4060 / 6560)
INSERT INTO `guild_item_points` VALUES (3,16541,8,7520,7520,7); -- Jagdplaute: 13545/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (3,17636,8,7520,7520,7); -- Jagdplaute +1: 13702/7520 -> 7520/7520

-- Goldsmithing / Veteran
INSERT INTO `guild_item_points` VALUES (3,16520,9,7600,7600,0); -- Verdun: 17340/7600 -> 7600/7600
INSERT INTO `guild_item_points` VALUES (3,17656,9,7600,7600,0); -- Verdun +1: 17977/7600 -> 7600/7600
INSERT INTO `guild_item_points` VALUES (3,16453,9,22200,7680,1); -- Orichalcum Dagger (22200 / 7680)
INSERT INTO `guild_item_points` VALUES (3,17992,9,22800,7680,1); -- Triton's Dagger (22800 / 7680)
INSERT INTO `guild_item_points` VALUES (3,13185,9,1800,5680,2); -- Muscle Belt (1800 / 5680)
INSERT INTO `guild_item_points` VALUES (3,13279,9,2925,5680,2); -- Muscle Belt +1 (2925 / 5680)
INSERT INTO `guild_item_points` VALUES (3,13097,9,7680,7680,3); -- Brisingamen: 21105/7680 -> 7680/7680
INSERT INTO `guild_item_points` VALUES (3,13162,9,7680,7680,3); -- Brisingamen +1: 22680/7680 -> 7680/7680
INSERT INTO `guild_item_points` VALUES (3,13466,9,7760,7760,4); -- Orichalcum Ring: 29750 -> 7760
INSERT INTO `guild_item_points` VALUES (3,14616,9,7760,7760,4); -- Triton Ring: 31450 -> 7760
INSERT INTO `guild_item_points` VALUES (3,12387,9,7860,7680,5); -- Koenig Shield: 22312 -> 7860
INSERT INTO `guild_item_points` VALUES (3,12388,9,7680,7680,5); -- Kaiser Shield: 23587 -> 7680
INSERT INTO `guild_item_points` VALUES (3,33,9,24500,7760,6); -- Millionaire Desk (24500 / 7760)
INSERT INTO `guild_item_points` VALUES (3,13329,9,7760,7760,7); -- Orichalcum Earring: 29750 -> 7760
INSERT INTO `guild_item_points` VALUES (3,13434,9,31450,7760,7); -- Triton Earring (31450 / 7760)

-- Clothcraft / Amateur
INSERT INTO `guild_item_points` VALUES (4,12720,0,303,2560,0); -- Gloves (303 / 2560)
INSERT INTO `guild_item_points` VALUES (4,12773,0,373,2560,0); -- Gloves +1 (373 / 2560)
INSERT INTO `guild_item_points` VALUES (4,12848,0,211,2160,1); -- Brais (211 / 2160)
INSERT INTO `guild_item_points` VALUES (4,12896,0,282,2160,1); -- Brais +1 (282 / 2160)
INSERT INTO `guild_item_points` VALUES (4,13583,0,85,1600,2); -- Cape (85 / 1600)
INSERT INTO `guild_item_points` VALUES (4,13605,0,111,1600,2); -- Cape +1 (111 / 1600)
INSERT INTO `guild_item_points` VALUES (4,12976,0,282,2480,3); -- Gaiters (282 / 2480)
INSERT INTO `guild_item_points` VALUES (4,13030,0,352,2480,3); -- Gaiters +1 (352 / 2480)
INSERT INTO `guild_item_points` VALUES (4,12592,0,549,3360,4); -- Doublet: max 1760 -> 3360
INSERT INTO `guild_item_points` VALUES (4,12591,0,549,1760,4); -- Doublet +1 (549 / 1760)
INSERT INTO `guild_item_points` VALUES (4,13583,0,85,1600,5); -- Cape (85 / 1600)
INSERT INTO `guild_item_points` VALUES (4,13605,0,111,1600,5); -- Cape +1 (111 / 1600)
INSERT INTO `guild_item_points` VALUES (4,12464,0,176,2000,6); -- Headgear: max 1520 -> 2000
INSERT INTO `guild_item_points` VALUES (4,12471,0,183,1520,6); -- Headgear +1 (183 / 1520)
INSERT INTO `guild_item_points` VALUES (4,14290,0,110,1680,7); -- Vagabond's Hose (110 / 1680)
INSERT INTO `guild_item_points` VALUES (4,14291,0,118,1680,7); -- Nomad's Hose (118 / 1680)

-- Clothcraft / Recruit
INSERT INTO `guild_item_points` VALUES (4,12608,1,280,2640,0); -- Tunic (280 / 2640)
INSERT INTO `guild_item_points` VALUES (4,12616,1,312,2640,0); -- Tunic +1 (312 / 2640)
INSERT INTO `guild_item_points` VALUES (4,12593,1,858,4160,1); -- Cotton Doublet (858 / 4160)
INSERT INTO `guild_item_points` VALUES (4,12669,1,2518,4160,1); -- Cotton Doublet +1 (2518 / 4160)
INSERT INTO `guild_item_points` VALUES (4,12584,1,249,2480,2); -- Kenpogi (249 / 2480)
INSERT INTO `guild_item_points` VALUES (4,12668,1,280,2480,2); -- Kenpogi +1 (280 / 2480)
INSERT INTO `guild_item_points` VALUES (4,12600,1,60,1680,3); -- Kyahan -> Robe (60/1680)
INSERT INTO `guild_item_points` VALUES (4,12615,1,60,1680,3); -- Kyahan +1 -> Robe +1 (60/1680)
INSERT INTO `guild_item_points` VALUES (4,12712,1,137,2080,4); -- Tekko (137 / 2080)
INSERT INTO `guild_item_points` VALUES (4,12774,1,168,2080,4); -- Tekko +1 (168 / 2080)
INSERT INTO `guild_item_points` VALUES (4,12728,1,33,1520,5); -- Slacks -> Cuffs (33/1520)
INSERT INTO `guild_item_points` VALUES (4,12744,1,41,1520,5); -- Slacks +1 -> Cuffs +1 (41/1520)
INSERT INTO `guild_item_points` VALUES (4,13584,1,506,3360,6); -- Cotton Cape (506 / 3360)
INSERT INTO `guild_item_points` VALUES (4,13601,1,660,3360,6); -- Cotton Cape +1 (660 / 3360)
INSERT INTO `guild_item_points` VALUES (4,13806,1,118,2000,7); -- Vagabond's Tunica (118 / 2000)
INSERT INTO `guild_item_points` VALUES (4,13807,1,126,2000,7); -- Nomad's Tunica (126 / 2000)

-- Clothcraft / Initiate
INSERT INTO `guild_item_points` VALUES (4,12713,2,675,3920,0); -- Cotton Tekko (675 / 3920)
INSERT INTO `guild_item_points` VALUES (4,12777,2,829,3920,0); -- Cotton Tekko +1 (829 / 3920)
INSERT INTO `guild_item_points` VALUES (4,12969,2,629,3760,1); -- Cotton Kyahan (629 / 3760)
INSERT INTO `guild_item_points` VALUES (4,13033,2,783,3760,1); -- Cotton Kyahan +1 (783 / 3760)
INSERT INTO `guild_item_points` VALUES (4,12585,2,460,3360,2); -- Cotton Dogi (460 / 3360)
INSERT INTO `guild_item_points` VALUES (4,12624,2,476,3360,2); -- Cotton Dogi +1 (476 / 3360)
INSERT INTO `guild_item_points` VALUES (4,12457,2,814,4160,3); -- Cotton Hachimaki (814 / 4160)
INSERT INTO `guild_item_points` VALUES (4,12537,2,967,4160,3); -- Cotton Hachimaki +1 (967 / 4160)
INSERT INTO `guild_item_points` VALUES (4,12594,2,2500,5920,4); -- Gambison (2500 / 5920)
INSERT INTO `guild_item_points` VALUES (4,12625,2,2550,5920,4); -- Gambison +1 (2550 / 5920)
INSERT INTO `guild_item_points` VALUES (4,12729,2,349,3040,5); -- Linen Cuffs (349 / 3040)
INSERT INTO `guild_item_points` VALUES (4,12778,2,430,3040,5); -- Linen Cuffs +1 (430 / 3040)
INSERT INTO `guild_item_points` VALUES (4,13204,2,99,2080,6); -- Heko Obi (99 / 2080)
INSERT INTO `guild_item_points` VALUES (4,13190,2,131,2080,6); -- Heko Obi +1 (131 / 2080)
INSERT INTO `guild_item_points` VALUES (4,12601,2,617,3760,7); -- Linen Robe (617 / 3760)
INSERT INTO `guild_item_points` VALUES (4,12626,2,617,3760,7); -- Linen Robe +1 (617 / 3760)

-- Clothcraft / Novice
INSERT INTO `guild_item_points` VALUES (4,12970,3,1836,5520,0); -- Soil Kyahan (1836 / 5520)
INSERT INTO `guild_item_points` VALUES (4,13035,3,1872,5520,0); -- Soil Kyahan +1 (1872 / 5520)
INSERT INTO `guild_item_points` VALUES (4,14423,3,3210,6240,1); -- Mist Tunic: 3120 -> 3210
INSERT INTO `guild_item_points` VALUES (4,14855,3,1395,5040,2); -- Mist Mitts (1395 / 5040)
INSERT INTO `guild_item_points` VALUES (4,12610,3,1748,5440,3); -- Cloak (1748 / 5440)
INSERT INTO `guild_item_points` VALUES (4,12670,3,1794,5440,3); -- Cloak +1 (1794 / 5440)
INSERT INTO `guild_item_points` VALUES (4,12714,3,1584,5280,4); -- Soil Tekko (1584 / 5280)
INSERT INTO `guild_item_points` VALUES (4,12781,3,1944,5280,4); -- Soil Tekko +1 (1944 / 5280)
INSERT INTO `guild_item_points` VALUES (4,12842,3,2304,5840,5); -- Soil Sitabaki (2304 / 5840)
INSERT INTO `guild_item_points` VALUES (4,12905,3,2664,5840,5); -- Soil Sitabaki +1 (2664 / 5840)
INSERT INTO `guild_item_points` VALUES (4,14324,3,2460,5920,6); -- Mist Slacks (2460 / 5920)
INSERT INTO `guild_item_points` VALUES (4,12458,3,1116,4720,7); -- Soil Hachimaki (1116 / 4720)
INSERT INTO `guild_item_points` VALUES (4,12539,3,1152,4720,7); -- Soil Hachimaki +1 (1152 / 4720)

-- Clothcraft / Apprentice
INSERT INTO `guild_item_points` VALUES (4,12723,4,3440,6400,0); -- Wool Bracers (3440 / 6400)
INSERT INTO `guild_item_points` VALUES (4,12783,4,4240,6400,0); -- Wool Bracers +1 (4240 / 6400)
INSERT INTO `guild_item_points` VALUES (4,12979,4,3200,6320,1); -- Wool Socks (3200 / 6320)
INSERT INTO `guild_item_points` VALUES (4,13036,4,4000,6320,1); -- Wool Socks +1 (4000 / 6320)
INSERT INTO `guild_item_points` VALUES (4,12858,4,2108,5760,2); -- Wool Slops (2108 / 5760)
INSERT INTO `guild_item_points` VALUES (4,12906,4,2448,5760,2); -- Wool Slops +1 (2448 / 5760)
INSERT INTO `guild_item_points` VALUES (4,12467,4,4160,6560,3); -- Wool Cap: 1155/4880 -> 4160/6560
INSERT INTO `guild_item_points` VALUES (4,12541,4,4960,6560,3); -- Wool Cap +1: 1251/6560 -> 4960/6560
INSERT INTO `guild_item_points` VALUES (4,12602,4,2584,6000,4); -- Wool Robe (2584 / 6000)
INSERT INTO `guild_item_points` VALUES (4,12627,4,2584,6000,4); -- Wool Robe +1 (2584 / 6000)
INSERT INTO `guild_item_points` VALUES (4,13085,4,180,2800,5); -- Hemp Gorget (180 / 2800)
INSERT INTO `guild_item_points` VALUES (4,13068,4,320,2800,5); -- Hemp Gorget +1 (320 / 2800)
INSERT INTO `guild_item_points` VALUES (4,12851,4,4800,6720,6); -- Wool Hose (4800 / 6720)
INSERT INTO `guild_item_points` VALUES (4,12907,4,4880,6720,6); -- Wool Hose +1 (4880 / 6720)
INSERT INTO `guild_item_points` VALUES (4,12730,4,1462,5200,7); -- Wool Cuffs (1462 / 5200)
INSERT INTO `guild_item_points` VALUES (4,12782,4,1802,5200,7); -- Wool Cuffs +1 (1802 / 5200)

-- Clothcraft / Journeyman
INSERT INTO `guild_item_points` VALUES (4,12739,5,2720,6080,0); -- Black Mitts: 2550/6000 -> 2720/6080
INSERT INTO `guild_item_points` VALUES (4,12794,5,2805,6080,0); -- Mage's Mitts: 2720/6000 -> 2805/6080
INSERT INTO `guild_item_points` VALUES (4,12603,5,4256,6640,1); -- Velvet Robe (4256 / 6640)
INSERT INTO `guild_item_points` VALUES (4,13726,5,4816,6640,1); -- Mage's Robe (4816 / 6640)
INSERT INTO `guild_item_points` VALUES (4,13568,5,250,3200,2); -- Scarlet Ribbon (250 / 3200)
INSERT INTO `guild_item_points` VALUES (4,13833,5,350,3200,2); -- Noble's Ribbon (350 / 3200)
INSERT INTO `guild_item_points` VALUES (4,13586,5,2178,5840,3); -- Red Cape (2178 / 5840)
INSERT INTO `guild_item_points` VALUES (4,13611,5,2838,5840,3); -- Red Cape +1 (2838 / 5840)
INSERT INTO `guild_item_points` VALUES (4,12865,5,1150,4880,4); -- Black Slacks (1150 / 4880)
INSERT INTO `guild_item_points` VALUES (4,12917,5,1342,4880,4); -- Mage's Slacks (1342 / 4880)
INSERT INTO `guild_item_points` VALUES (4,13577,5,1386,5200,5); -- Black Cape (1386 / 5200)
INSERT INTO `guild_item_points` VALUES (4,13610,5,1806,5200,5); -- Black Cape +1 (1806 / 5200)
INSERT INTO `guild_item_points` VALUES (4,13750,5,2508,6000,6); -- Linen Doublet (2508 / 6000)
INSERT INTO `guild_item_points` VALUES (4,13751,5,2552,6000,6); -- Linen Doublet +1 (2552 / 6000)
INSERT INTO `guild_item_points` VALUES (4,13205,5,613,4080,7); -- Silver Obi (613 / 4080)
INSERT INTO `guild_item_points` VALUES (4,13224,5,824,4080,7); -- Silver Obi +1 (824 / 4080)

-- Clothcraft / Craftsman
INSERT INTO `guild_item_points` VALUES (4,12604,6,7030,7120,0); -- Silk Coat (7030 / 7120)
INSERT INTO `guild_item_points` VALUES (4,12652,6,7030,7120,0); -- Silk Coat +1 (7030 / 7120)
INSERT INTO `guild_item_points` VALUES (4,12503,6,2280,5920,1); -- Silk Headband (2280 / 5920)
INSERT INTO `guild_item_points` VALUES (4,13851,6,2375,5920,1); -- Silk Headband +1 (2375 / 5920)
INSERT INTO `guild_item_points` VALUES (4,12867,6,5100,6800,2); -- White Slacks (5100 / 6800)
INSERT INTO `guild_item_points` VALUES (4,12926,6,5950,6800,2); -- White Slacks +1 (5950 / 6800)
INSERT INTO `guild_item_points` VALUES (4,13752,6,4992,6800,3); -- Wool Doublet (4992 / 6800)
INSERT INTO `guild_item_points` VALUES (4,13753,6,5632,6800,3); -- Wool Doublet +1 (5632 / 6800)
INSERT INTO `guild_item_points` VALUES (4,13590,6,2025,5760,4); -- Green Ribbon (2025 / 5760)
INSERT INTO `guild_item_points` VALUES (4,13854,6,2137,5760,4); -- Green Ribbon +1 (2137 / 5760)
INSERT INTO `guild_item_points` VALUES (4,12611,6,7200,7200,5); -- White Cloak (7200 / 7200)
INSERT INTO `guild_item_points` VALUES (4,12651,6,7650,7200,5); -- White Cloak +1 (7650 / 7200)
INSERT INTO `guild_item_points` VALUES (4,12860,6,5735,6960,6); -- Silk Slops (5735 / 6960)
INSERT INTO `guild_item_points` VALUES (4,12927,6,6660,6960,6); -- Silk Slops +1 (6660 / 6960)
INSERT INTO `guild_item_points` VALUES (4,12731,6,2408,6000,7); -- Velvet Cuffs (2408 / 6000)
INSERT INTO `guild_item_points` VALUES (4,12793,6,2968,6000,7); -- Mage's Cuffs (2968 / 6000)

-- Clothcraft / Artisan
INSERT INTO `guild_item_points` VALUES (4,12468,7,3055,6320,0); -- Green Beret (3055 / 6320)
INSERT INTO `guild_item_points` VALUES (4,13866,7,3250,6320,0); -- Green Beret +1 (3250 / 6320)
INSERT INTO `guild_item_points` VALUES (4,12612,7,6375,7040,1); -- Silk Cloak (6375 / 7040)
INSERT INTO `guild_item_points` VALUES (4,13777,7,6500,7040,1); -- Silk Cloak +1 (6500 / 7040)
INSERT INTO `guild_item_points` VALUES (4,12972,7,3382,6400,2); -- Shinobi Kyahan (3382 / 6400)
INSERT INTO `guild_item_points` VALUES (4,14082,7,4207,6400,2); -- Shinobi Kyahan +1 (4207 / 6400)
INSERT INTO `guild_item_points` VALUES (4,12716,7,3630,6480,3); -- Shinobi Tekko: max 6400 -> 6480
INSERT INTO `guild_item_points` VALUES (4,13955,7,4455,6400,3); -- Shinobi Tekko +1 (4455 / 6400)
INSERT INTO `guild_item_points` VALUES (4,13579,7,3217,6320,4); -- Jester's Cape (3217 / 6320)
INSERT INTO `guild_item_points` VALUES (4,13620,7,4192,6320,4); -- Jester's Cape +1 (4192 / 6320)
INSERT INTO `guild_item_points` VALUES (4,12740,7,4830,6800,5); -- Silk Mitts (4830 / 6800)
INSERT INTO `guild_item_points` VALUES (4,14000,7,5980,6800,5); -- Silk Mitts +1 (5980 / 6800)
INSERT INTO `guild_item_points` VALUES (4,12844,7,3465,6400,6); -- Shinobi Hakama (3465 / 6400)
INSERT INTO `guild_item_points` VALUES (4,12925,7,3547,6400,6); -- Shinobi Hakama +1 (3547 / 6400)
INSERT INTO `guild_item_points` VALUES (4,12716,7,3630,6480,7); -- Shinobi Tekko: max 6400 -> 6480
INSERT INTO `guild_item_points` VALUES (4,13955,7,4455,6480,7); -- Shinobi Tekko +1 (4455 / 6480)

-- Clothcraft / Adept
INSERT INTO `guild_item_points` VALUES (4,14023,8,3225,6400,0); -- Arhat's Tekko (3225 / 6400)
INSERT INTO `guild_item_points` VALUES (4,14028,8,3762,6400,0); -- Arhat's Tekko +1 (3762 / 6400)
INSERT INTO `guild_item_points` VALUES (4,13208,8,3840,6560,1); -- Rainbow Obi (3840 / 6560)
INSERT INTO `guild_item_points` VALUES (4,13235,8,5040,6560,1); -- Prism Obi: 3840 -> 5040
INSERT INTO `guild_item_points` VALUES (4,12861,8,7200,7200,2); -- Noble's Slacks: 7750 -> 7200
INSERT INTO `guild_item_points` VALUES (4,14239,8,7200,7200,2); -- Aristocrat's Slacks: 9000 -> 7200
INSERT INTO `guild_item_points` VALUES (4,12504,8,5300,6880,3); -- Rainbow Headband (5300 / 6880)
INSERT INTO `guild_item_points` VALUES (4,13858,8,5962,6880,3); -- Rainbow Headband +1 (5962 / 6880)
INSERT INTO `guild_item_points` VALUES (4,12733,8,5590,6880,4); -- Noble's Mitts (5590 / 6880)
INSERT INTO `guild_item_points` VALUES (4,13999,8,6880,6880,4); -- Aristocrat's Mitts (6880 / 6880)
INSERT INTO `guild_item_points` VALUES (4,14129,8,3762,6560,5); -- Arhat's Sune-Ate (3762 / 6560)
INSERT INTO `guild_item_points` VALUES (4,14136,8,4300,6560,5); -- Arhat's Sune-Ate +1 (4300 / 6560)
INSERT INTO `guild_item_points` VALUES (4,14253,8,4300,6640,6); -- Arhat's Hakama (4300 / 6640)
INSERT INTO `guild_item_points` VALUES (4,14256,8,4837,6640,6); -- Arhat's Hakama +1 (4837 / 6640)
INSERT INTO `guild_item_points` VALUES (4,13881,8,3225,6400,7); -- Arhat's Jinpachi (3225 / 6400)
INSERT INTO `guild_item_points` VALUES (4,13886,8,3762,6400,7); -- Arhat's Jinpachi +1 (3762 / 6400)

-- Clothcraft / Veteran
INSERT INTO `guild_item_points` VALUES (4,14819,9,7520,7520,0); -- Rasetsu Tekko: 15000/7520 -> 7520/7520
INSERT INTO `guild_item_points` VALUES (4,14820,9,16250,7520,0); -- Rasetsu Tekko +1 (16250 / 7520)
INSERT INTO `guild_item_points` VALUES (4,14299,9,12375,7440,1); -- Rasetsu Hakama (12375 / 7440)
INSERT INTO `guild_item_points` VALUES (4,14300,9,13625,7440,1); -- Rasetsu Hakama +1 (13625 / 7440)
INSERT INTO `guild_item_points` VALUES (4,13212,9,3600,6480,2); -- Tarutaru Sash (3600 / 6480)
INSERT INTO `guild_item_points` VALUES (4,13188,9,4200,6480,2); -- Tarutaru Sash +1 (4200 / 6480)
INSERT INTO `guild_item_points` VALUES (4,14301,9,3750,6560,3); -- Errant Slops (3750 / 6560)
INSERT INTO `guild_item_points` VALUES (4,14302,9,3750,6560,3); -- Mahatma Slops: 5000 -> 3750
INSERT INTO `guild_item_points` VALUES (4,13929,9,4500,6720,4); -- Errant Hat (4500 / 6720)
INSERT INTO `guild_item_points` VALUES (4,13930,9,4500,6720,4); -- Mahatma Hat: 5750 -> 4500
INSERT INTO `guild_item_points` VALUES (4,14178,9,7440,7440,5); -- Rasetsu Sune-Ate: 12000/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (4,14179,9,13250,7440,5); -- Rasetsu Sune-Ate +1 (13250 / 7440)
INSERT INTO `guild_item_points` VALUES (4,14078,9,6875,7120,6); -- Errant Cuffs (6875 / 7120)
INSERT INTO `guild_item_points` VALUES (4,14079,9,6875,7120,6); -- Mahatma Cuffs: 8125 -> 6875
INSERT INTO `guild_item_points` VALUES (4,13925,9,7520,7520,7); -- Rasetsu Jinpachi: 13750 -> 7520
INSERT INTO `guild_item_points` VALUES (4,13926,9,15000,7520,7); -- Rasetsu Jinpachi (15000 / 7520)

-- Leathercraft / Amateur
INSERT INTO `guild_item_points` VALUES (5,12568,0,168,2000,0); -- Leather Vest: 92/1600 -> 168/2000
INSERT INTO `guild_item_points` VALUES (5,12599,0,244,2000,0); -- Leather Vest +1: 153/2000 -> 244/2000
INSERT INTO `guild_item_points` VALUES (5,12696,0,90,1600,1); -- Leather Gloves (90 / 1600)
INSERT INTO `guild_item_points` VALUES (5,12784,0,110,1600,1); -- Leather Gloves +1 (110 / 1600)
INSERT INTO `guild_item_points` VALUES (5,14068,0,63,1440,2); -- Vagabond's Gloves (63 / 1440)
INSERT INTO `guild_item_points` VALUES (5,14069,0,71,1440,2); -- Nomad's Gloves (71 / 1440)
INSERT INTO `guild_item_points` VALUES (5,12952,0,84,1520,3); -- Leather Highboots (84 / 1520)
INSERT INTO `guild_item_points` VALUES (5,12971,0,104,1520,3); -- Leather Highboots +1 (104 / 1520)
INSERT INTO `guild_item_points` VALUES (5,12440,0,110,1680,4); -- Leather Bandana: 52/1360 -> 110/1680
INSERT INTO `guild_item_points` VALUES (5,12542,0,120,1360,4); -- Leather Bandana +1 (120 / 1360)
INSERT INTO `guild_item_points` VALUES (5,13594,0,44,1360,5); -- Leather Trousers -> Rabbit Mantle (44/1360)
INSERT INTO `guild_item_points` VALUES (5,13599,0,56,1360,5); -- Leather Trousers +1 -> Rabbit Mantle +1 (56/1360)
INSERT INTO `guild_item_points` VALUES (5,14169,0,63,1440,6); -- Vagabond's Boots (63 / 1440)
INSERT INTO `guild_item_points` VALUES (5,14170,0,71,1440,6); -- Nomad's Boots (71 / 1440)
INSERT INTO `guild_item_points` VALUES (5,16385,0,24,1200,7); -- Cesti (24 / 1200)
INSERT INTO `guild_item_points` VALUES (5,16690,0,32,1200,7); -- Cesti +1 (32 / 1200)

-- Leathercraft / Recruit
INSERT INTO `guild_item_points` VALUES (5,12992,1,121,2000,0); -- Solea (121 / 2000)
INSERT INTO `guild_item_points` VALUES (5,13037,1,152,2000,0); -- Solea +1 (152 / 2000)
INSERT INTO `guild_item_points` VALUES (5,12441,1,177,2240,1); -- Lizard Helm: max 2090 -> 2240
INSERT INTO `guild_item_points` VALUES (5,12480,1,177,2090,1); -- Lizard Helm +1 (177 / 2090)
INSERT INTO `guild_item_points` VALUES (5,13192,1,85,1840,2); -- Leather Belt (85 / 1840)
INSERT INTO `guild_item_points` VALUES (5,13210,1,111,1840,2); -- Leather Belt +1 (111 / 1840)
INSERT INTO `guild_item_points` VALUES (5,16386,1,252,2560,3); -- Lizard Cesti (252 / 2560)
INSERT INTO `guild_item_points` VALUES (5,16398,1,333,2560,3); -- Burning Cesti (333 / 2560)
INSERT INTO `guild_item_points` VALUES (5,13592,1,81,1740,4); -- Lizard Mantle: max 1760 -> 1740
INSERT INTO `guild_item_points` VALUES (5,13608,1,95,1760,4); -- Lizard Mantle +1 (95 / 1760)
INSERT INTO `guild_item_points` VALUES (5,14171,1,180,2240,5); -- Fisherman's Boots (180 / 2240)
INSERT INTO `guild_item_points` VALUES (5,14172,1,519,2240,5); -- Angler's Boots (519 / 2240)
INSERT INTO `guild_item_points` VALUES (5,12569,1,245,2480,6); -- Lizard Jerkin (245 / 2480)
INSERT INTO `guild_item_points` VALUES (5,13697,1,259,2480,6); -- Fine Jerkin (259 / 2480)
INSERT INTO `guild_item_points` VALUES (5,14070,1,360,2880,7); -- Fisherman's Gloves (360 / 2880)
INSERT INTO `guild_item_points` VALUES (5,14071,1,986,2880,7); -- Angler's Gloves (986 / 2880)

-- Leathercraft / Initiate
INSERT INTO `guild_item_points` VALUES (5,12442,2,1102,4640,0); -- Studded Bandana (1102 / 4640)
INSERT INTO `guild_item_points` VALUES (5,13824,2,1140,4640,0); -- Strong Bandana (1140 / 4640)
INSERT INTO `guild_item_points` VALUES (5,12698,2,1710,5360,1); -- Studded Gloves: max 5363 -> 5360
INSERT INTO `guild_item_points` VALUES (5,12786,2,2090,5360,1); -- Studded Gloves +1 (2090 / 5360)
INSERT INTO `guild_item_points` VALUES (5,14072,2,519,3520,2); -- Chocobo Gloves (519 / 3520)
INSERT INTO `guild_item_points` VALUES (5,14073,2,570,3520,2); -- Rider's Gloves (570 / 3520)
INSERT INTO `guild_item_points` VALUES (5,13588,2,552,3600,3); -- Dhalmel Mantle (552 / 3600)
INSERT INTO `guild_item_points` VALUES (5,13600,2,706,3600,3); -- Dhalmel Mantle +1 (706 / 3600)
INSERT INTO `guild_item_points` VALUES (5,13194,2,330,2960,4); -- Warrior's Belt (330 / 2960)
INSERT INTO `guild_item_points` VALUES (5,13240,2,400,2960,4); -- Warrior's Belt +1 (400 / 2960)
INSERT INTO `guild_item_points` VALUES (5,14173,2,519,3520,5); -- Chocobo Boots (519 / 3520)
INSERT INTO `guild_item_points` VALUES (5,14174,2,579,3520,5); -- Rider's Boots: 570 -> 579
INSERT INTO `guild_item_points` VALUES (5,12993,2,748,4000,6); -- Sandals (748 / 4000)
INSERT INTO `guild_item_points` VALUES (5,13048,2,939,4000,6); -- Mages' Sandals (939 / 4000)
INSERT INTO `guild_item_points` VALUES (5,13469,2,250,2720,7); -- Leather Ring (250 / 2720)
INSERT INTO `guild_item_points` VALUES (5,13499,2,350,2720,7); -- Leather Ring +1 (350 / 2720)

-- Leathercraft / Novice
INSERT INTO `guild_item_points` VALUES (5,15312,3,1305,4960,0); -- Mist Pumps (1305 / 4960)
INSERT INTO `guild_item_points` VALUES (5,13089,3,608,3840,1); -- Wolf Gorget (608 / 3840)
INSERT INTO `guild_item_points` VALUES (5,13070,3,684,3840,1); -- Wolf Gorget +1 (684 / 3840)
INSERT INTO `guild_item_points` VALUES (5,13571,3,1224,4880,2); -- Wolf Mantle (1224 / 4880)
INSERT INTO `guild_item_points` VALUES (5,13609,3,1564,4880,2); -- Wolf Mantle +1 (1564 / 4880)
INSERT INTO `guild_item_points` VALUES (5,13081,3,66,2160,3); -- Field Boots -> Leather Gorget (66/2160)
INSERT INTO `guild_item_points` VALUES (5,13069,3,86,2160,3); -- Worker Boots -> Leather Gorget +1 (86/2160)
INSERT INTO `guild_item_points` VALUES (5,12994,3,1104,4720,4); -- Shoes (1104 / 4720)
INSERT INTO `guild_item_points` VALUES (5,13040,3,1196,4720,4); -- Shoes +1 (1196 / 4720)
INSERT INTO `guild_item_points` VALUES (5,13195,3,506,3600,5); -- Magic Belt (506 / 3600)
INSERT INTO `guild_item_points` VALUES (5,13219,3,660,3600,5); -- Magic Belt +1 (660 / 3600)
INSERT INTO `guild_item_points` VALUES (5,12699,3,1624,5280,6); -- Cuir Gloves (1624 / 5280)
INSERT INTO `guild_item_points` VALUES (5,12787,3,1680,5280,6); -- Cuir Gloves +1 (1680 / 5280)
INSERT INTO `guild_item_points` VALUES (5,12570,3,2280,5840,7); -- Studded Vest (2280 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13707,3,2318,5840,7); -- Studded Vest +1 (2318 / 5840)

-- Leathercraft / Apprentice
INSERT INTO `guild_item_points` VALUES (5,13271,4,3250,6320,0); -- Corsette (3250 / 6320)
INSERT INTO `guild_item_points` VALUES (5,13272,4,3750,6320,0); -- Corsette +1 (3750 / 6320)
INSERT INTO `guild_item_points` VALUES (5,13570,4,900,4480,1); -- Ram Mantle (900 / 4480)
INSERT INTO `guild_item_points` VALUES (5,13575,4,1000,4480,1); -- Ram Mantle +1 (1000 / 4480)
INSERT INTO `guild_item_points` VALUES (5,12955,4,1736,5440,2); -- Cuir Highboots (1736 / 5440)
INSERT INTO `guild_item_points` VALUES (5,13041,4,1792,5440,2); -- Cuir Highboots +1 (1792 / 5440)
INSERT INTO `guild_item_points` VALUES (5,12571,4,1960,5600,3); -- Cuir Bouilli (1960 / 5600)
INSERT INTO `guild_item_points` VALUES (5,13709,4,2072,5600,3); -- Cuir Bouilli +1 (2072 / 5600)
INSERT INTO `guild_item_points` VALUES (5,13200,4,1680,5360,4); -- Waistbelt (1680 / 5360)
INSERT INTO `guild_item_points` VALUES (5,13214,4,1740,5360,4); -- Waistbelt +1 (1740 / 5360)
INSERT INTO `guild_item_points` VALUES (5,12827,4,1680,5360,5); -- Cuir Trousers: 1008/4640 -> 1680/5360
INSERT INTO `guild_item_points` VALUES (5,12911,4,1792,5360,5); -- Cuir Trousers +1: 1232/5360 -> 1792/5360
INSERT INTO `guild_item_points` VALUES (5,13810,4,1297,5040,6); -- Chocobo Jack Coat (1297 / 5040)
INSERT INTO `guild_item_points` VALUES (5,13811,4,1349,5040,6); -- Rider's Jack Coat (1349 / 5040)
INSERT INTO `guild_item_points` VALUES (5,13203,4,506,3760,7); -- Barbarian's Belt (506 / 3760)
INSERT INTO `guild_item_points` VALUES (5,13225,4,660,3760,7); -- Brave Belt (660 / 3760)

-- Leathercraft / Journeyman
INSERT INTO `guild_item_points` VALUES (5,12444,5,2240,5840,0); -- Raptor Helm (2240 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13835,5,2400,5840,0); -- Dino Helm (2400 / 5840)
INSERT INTO `guild_item_points` VALUES (5,12700,5,3600,6400,1); -- Raptor Gloves (3600 / 6400)
INSERT INTO `guild_item_points` VALUES (5,12795,5,3760,6400,1); -- Dino Gloves (3760 / 6400)
INSERT INTO `guild_item_points` VALUES (5,16388,5,1140,4880,2); -- Himantes (1140 / 4880)
INSERT INTO `guild_item_points` VALUES (5,16699,5,1200,4880,2); -- Himantes +1: 1720/4880 -> 1200/4880
INSERT INTO `guild_item_points` VALUES (5,12956,5,3360,6320,3); -- Raptor Ledelsens (3360 / 6320)
INSERT INTO `guild_item_points` VALUES (5,13049,5,4160,6320,3); -- Dino Ledelsens (4160 / 6320)
INSERT INTO `guild_item_points` VALUES (5,13593,5,1280,5040,4); -- Raptor Mantle (1280 / 5040)
INSERT INTO `guild_item_points` VALUES (5,13612,5,1440,5040,4); -- Dino Mantle (1440 / 5040)
INSERT INTO `guild_item_points` VALUES (5,12828,5,5200,6800,5); -- Raptor Trousers: 2160/5760 -> 5200/6800
INSERT INTO `guild_item_points` VALUES (5,12919,5,5360,6800,5); -- Dino Trousers: 2320/5760 -> 5360/6800
INSERT INTO `guild_item_points` VALUES (5,14166,5,1000,4720,6); -- Moccasins -> Desert Boots (1000/4720)
INSERT INTO `guild_item_points` VALUES (5,14167,5,2000,4720,6); -- Moccasins +1 -> Desert Boots +1 (2000/4720)
INSERT INTO `guild_item_points` VALUES (5,12294,5,1280,5040,7); -- Leather Shield (1280 / 5040)
INSERT INTO `guild_item_points` VALUES (5,12329,5,1360,5040,7); -- Leather Shield +1 (1360 / 5040)

-- Leathercraft / Craftsman
INSERT INTO `guild_item_points` VALUES (5,13698,6,2687,6080,0); -- Beak Helm (2687 / 6080)
INSERT INTO `guild_item_points` VALUES (5,13701,6,2795,6080,0); -- Beak Helm +1 (2795 / 6080)
INSERT INTO `guild_item_points` VALUES (5,13700,6,3440,6400,1); -- Beak Gloves: 3600 -> 3440
INSERT INTO `guild_item_points` VALUES (5,13960,6,3547,6400,1); -- Beak Gloves +1: 3760/6400 -> 3547/6400
INSERT INTO `guild_item_points` VALUES (5,13597,6,1612,5440,2); -- Beak Mantle (1612 / 5440)
INSERT INTO `guild_item_points` VALUES (5,13621,6,1720,5440,2); -- Beak Mantle +1 (1720 / 5440)
INSERT INTO `guild_item_points` VALUES (5,12980,6,3300,6320,3); -- Battle Boots: 2860/6160 -> 3300/6320
INSERT INTO `guild_item_points` VALUES (5,14104,6,3410,6320,3); -- Battle Boots +1: 3190/6320 -> 3410/6320
INSERT INTO `guild_item_points` VALUES (5,12829,6,3225,6320,4); -- Beak Trousers (3225 / 6320)
INSERT INTO `guild_item_points` VALUES (5,14213,6,3332,6320,4); -- Beak Trousers +1: 3225/6320 -> 3332/6320
INSERT INTO `guild_item_points` VALUES (5,13702,6,4515,6720,5); -- Beak Ledelsens (4515 / 6720)
INSERT INTO `guild_item_points` VALUES (5,14088,6,4622,6720,5); -- Beak Ledelsens +1 (4622 / 6720)
INSERT INTO `guild_item_points` VALUES (5,13699,6,2150,5840,6); -- Beak Jerkin (2150 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13739,6,2257,5840,6); -- Beak Jerkin +1 (2257 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13546,6,770,4400,7); -- Hard Leather Ring (770 / 4400)
INSERT INTO `guild_item_points` VALUES (5,13547,6,880,4400,7); -- Tiger Ring (880 / 4400)

-- Leathercraft / Artisan
INSERT INTO `guild_item_points` VALUES (5,12996,7,4485,6720,0); -- Silk Pumps (4485 / 6720)
INSERT INTO `guild_item_points` VALUES (5,14115,7,5635,6720,0); -- Silk Pumps +1 (5635 / 6720)
INSERT INTO `guild_item_points` VALUES (5,12702,7,1912,5680,1); -- Tiger Gloves (1912 / 5680)
INSERT INTO `guild_item_points` VALUES (5,13992,7,2040,5680,1); -- Feral Gloves (2040 / 5680)
INSERT INTO `guild_item_points` VALUES (5,16389,7,1980,5760,2); -- Coeurl Cesti (1980 / 5760)
INSERT INTO `guild_item_points` VALUES (5,17473,7,2070,5760,2); -- Torama Cesti (2070 / 5760)
INSERT INTO `guild_item_points` VALUES (5,13589,7,1250,5120,3); -- Tiger Mantle (1250 / 5120)
INSERT INTO `guild_item_points` VALUES (5,13602,7,1375,5120,3); -- Feral Mantle (1375 / 5120)
INSERT INTO `guild_item_points` VALUES (5,12852,7,3680,6480,4); -- Battle Hose (3680 / 6480)
INSERT INTO `guild_item_points` VALUES (5,14237,7,3795,6480,4); -- Battle Hose +1 (3795 / 6480)
INSERT INTO `guild_item_points` VALUES (5,12830,7,2040,5760,5); -- Tiger Trousers (2040 / 5760)
INSERT INTO `guild_item_points` VALUES (5,14232,7,2160,5760,5); -- Feral Trousers (2160 / 5760)
INSERT INTO `guild_item_points` VALUES (5,13641,7,2200,5840,6); -- Black Mantle (2200 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13642,7,3300,5840,6); -- Black Mantle +1 (3300 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13198,7,2178,5840,7); -- Swordbelt (2178 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13232,7,2838,5840,7); -- Swordbelt +1 (2838 / 5840)

-- Leathercraft / Adept
INSERT INTO `guild_item_points` VALUES (5,13705,8,4560,6720,0); -- Ogre Jerkin (4560 / 6720)
INSERT INTO `guild_item_points` VALUES (5,14366,8,5760,6720,0); -- Ogre Jerkin +1 (5760 / 6720)
INSERT INTO `guild_item_points` VALUES (5,13704,8,4200,6640,1); -- Ogre Mask (4200 / 6640)
INSERT INTO `guild_item_points` VALUES (5,13907,8,5400,6640,1); -- Ogre Mask +1 (5400 / 6640)
INSERT INTO `guild_item_points` VALUES (5,13595,8,2100,5840,2); -- Coeurl Mantle (2100 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13603,8,2800,5840,2); -- Torama Mantle (2800 / 5840)
INSERT INTO `guild_item_points` VALUES (5,13197,8,4785,6800,3); -- Koenigs Belt (4785 / 6800)
INSERT INTO `guild_item_points` VALUES (5,13239,8,4785,6800,3); -- Kaiser Belt: 6235 -> 4785
INSERT INTO `guild_item_points` VALUES (5,13708,8,5040,6800,4); -- Ogre Ledelsens (5040 / 6800)
INSERT INTO `guild_item_points` VALUES (5,14159,8,5040,6800,4); -- Ogre Ledelsens +1: 6240/6800 -> 5040/6800
INSERT INTO `guild_item_points` VALUES (5,12447,8,3500,6480,5); -- Coeurl Mask (3500 / 6480)
INSERT INTO `guild_item_points` VALUES (5,13862,8,4200,6480,5); -- Torama Mask (4200 / 6480)
INSERT INTO `guild_item_points` VALUES (5,13706,8,3600,6480,6); -- Ogre Gloves (3600 / 6480)
INSERT INTO `guild_item_points` VALUES (5,14057,8,4800,6480,6); -- Ogre Gloves +1 (4800 / 6480)
INSERT INTO `guild_item_points` VALUES (5,12880,8,4800,6800,7); -- Ogre Trousers (4800 / 6800)
INSERT INTO `guild_item_points` VALUES (5,14279,8,6000,6800,7); -- Ogre Trousers +1 (6000 / 6800)

-- Leathercraft / Veteran
INSERT INTO `guild_item_points` VALUES (5,15307,9,6492,7040,0); -- Bison Gamashes (6492 / 7040)
INSERT INTO `guild_item_points` VALUES (5,15308,9,7717,7040,0); -- Brave's Gamashes (7717 / 7040)
INSERT INTO `guild_item_points` VALUES (5,14319,9,6247,7040,1); -- Bison Kecks (6247 / 7040)
INSERT INTO `guild_item_points` VALUES (5,14320,9,7472,7040,1); -- Brave's Kecks (7472 / 7040)
INSERT INTO `guild_item_points` VALUES (5,14372,9,4800,6800,2); -- Cardinal Vest (4800 / 6800)
INSERT INTO `guild_item_points` VALUES (5,14373,9,6000,6800,2); -- Bachelor Vest (6000 / 6800)
INSERT INTO `guild_item_points` VALUES (5,14850,9,4042,6640,3); -- Bison Wristbands (4042 / 6640)
INSERT INTO `guild_item_points` VALUES (5,14851,9,4020,6640,3); -- Brave's Wristbands: 5267 -> 4020
INSERT INTO `guild_item_points` VALUES (5,13918,9,1080,5040,4); -- Tiger Mask (1080 / 5040)
INSERT INTO `guild_item_points` VALUES (5,13919,9,1080,5040,4); -- Feral Mask: 2280 -> 1080
INSERT INTO `guild_item_points` VALUES (5,14317,9,6737,7120,5); -- Barone Cosciales (6737 / 7120)
INSERT INTO `guild_item_points` VALUES (5,14318,9,7962,7120,5); -- Conte Cosciales (7962 / 7120)
INSERT INTO `guild_item_points` VALUES (5,13918,9,1080,5040,6); -- Tiger Mask (1080 / 5040)
INSERT INTO `guild_item_points` VALUES (5,13919,9,1080,5040,6); -- Feral Mask: 2280 -> 1080
INSERT INTO `guild_item_points` VALUES (5,14182,9,2500,6080,7); -- Errant Pigaches (2500 / 6080)
INSERT INTO `guild_item_points` VALUES (5,14183,9,3750,6080,7); -- Mahatma Pigaches (3750 / 6080)

-- Bonecraft / Amateur
INSERT INTO `guild_item_points` VALUES (6,12505,0,112,1680,0); -- Bone Hairpin (112 / 1680)
INSERT INTO `guild_item_points` VALUES (6,13825,0,187,1680,0); -- Bone Hairpin +1 (187 / 1680)
INSERT INTO `guild_item_points` VALUES (6,13442,0,151,1920,1); -- Shell Ring (151 / 1920)
INSERT INTO `guild_item_points` VALUES (6,13494,0,212,1920,1); -- Shell Ring +1 (212 / 1920)
INSERT INTO `guild_item_points` VALUES (6,12505,0,112,1680,2); -- Bone Hairpin (112 / 1680)
INSERT INTO `guild_item_points` VALUES (6,13825,0,187,1680,2); -- Bone Hairpin +1 (187 / 1680)
INSERT INTO `guild_item_points` VALUES (6,13313,0,151,1920,3); -- Shell Earring (151 / 1920)
INSERT INTO `guild_item_points` VALUES (6,13314,0,212,1920,3); -- Shell Earring +1 (212 / 1920)
INSERT INTO `guild_item_points` VALUES (6,13442,0,151,1920,4); -- Shell Ring (151 / 1920)
INSERT INTO `guild_item_points` VALUES (6,13494,0,212,1920,4); -- Shell Ring +1 (212 / 1920)
INSERT INTO `guild_item_points` VALUES (6,16405,0,29,1280,5); -- Cat Baghnakhs (29 / 1280)
INSERT INTO `guild_item_points` VALUES (6,17476,0,35,1280,5); -- Cat Baghnakhs +1 (35 / 1280)
INSERT INTO `guild_item_points` VALUES (6,16405,0,29,1280,6); -- Cat Baghnakhs (29 / 1280)
INSERT INTO `guild_item_points` VALUES (6,17476,0,35,1280,6); -- Cat Baghnakhs +1 (35 / 1280)
INSERT INTO `guild_item_points` VALUES (6,13313,0,151,1920,7); -- Shell Earring (151 / 1920)
INSERT INTO `guild_item_points` VALUES (6,13314,0,212,1920,7); -- Shell Earring +1 (212 / 1920)

-- Bonecraft / Recruit
INSERT INTO `guild_item_points` VALUES (6,12710,1,544,3440,0); -- Bone Mittens (544 / 3440)
INSERT INTO `guild_item_points` VALUES (6,12788,1,664,3440,0); -- Bone Mittens +1 (664 / 3440)
INSERT INTO `guild_item_points` VALUES (6,12454,1,652,3760,1); -- Bone Mask (652 / 3760)
INSERT INTO `guild_item_points` VALUES (6,13826,1,773,3760,1); -- Bone Mask +1 (773 / 3760)
INSERT INTO `guild_item_points` VALUES (6,13076,1,636,3680,2); -- Fang Necklace: 141/2080 -> 636/3680
INSERT INTO `guild_item_points` VALUES (6,13061,1,872,3680,2); -- Spike Necklace: 235/2080 -> 872/3680
INSERT INTO `guild_item_points` VALUES (6,12454,1,652,3760,3); -- Bone Mask (652 / 3760)
INSERT INTO `guild_item_points` VALUES (6,13826,1,773,3760,3); -- Bone Mask +1 (773 / 3760)
INSERT INTO `guild_item_points` VALUES (6,13076,1,636,3680,4); -- Fang Necklace: 141/2080 -> 636/3680
INSERT INTO `guild_item_points` VALUES (6,13061,1,872,3680,4); -- Spike Necklace: 235/2080 -> 872/3680
INSERT INTO `guild_item_points` VALUES (6,13441,1,302,2720,5); -- Bone Ring (302 / 2720)
INSERT INTO `guild_item_points` VALUES (6,13500,1,423,2720,5); -- Bone Ring +1 (423 / 2720)
INSERT INTO `guild_item_points` VALUES (6,12710,1,544,3440,6); -- Bone Mittens (544 / 3440)
INSERT INTO `guild_item_points` VALUES (6,12788,1,664,3440,6); -- Bone Mittens +1 (664 / 3440)
INSERT INTO `guild_item_points` VALUES (6,13321,1,302,2720,7); -- Bone Earring (302 / 2720)
INSERT INTO `guild_item_points` VALUES (6,13362,1,423,2720,7); -- Bone Earring +1 (423 / 2720)

-- Bonecraft / Initiate
INSERT INTO `guild_item_points` VALUES (6,12582,2,362,3040,0); -- Bone Harness (362 / 3040)
INSERT INTO `guild_item_points` VALUES (6,13716,2,374,3040,0); -- Bone Harness +1 (374 / 3040)
INSERT INTO `guild_item_points` VALUES (6,12507,2,950,4400,1); -- Horn Hairpin (950 / 4400)
INSERT INTO `guild_item_points` VALUES (6,13828,2,988,4400,1); -- Horn Hairpin +1 (988 / 4400)
INSERT INTO `guild_item_points` VALUES (6,12966,2,495,3440,2); -- Bone Leggings (495 / 3440)
INSERT INTO `guild_item_points` VALUES (6,13042,2,616,3440,2); -- Bone Leggings +1 (616 / 3440)
INSERT INTO `guild_item_points` VALUES (6,17351,2,860,4240,3); -- Gemshorn (860 / 4240)
INSERT INTO `guild_item_points` VALUES (6,17370,2,1032,4240,3); -- Gemshorn +1 (1032 / 4240)
INSERT INTO `guild_item_points` VALUES (6,16649,2,362,3040,4); -- Bone Pick (362 / 3040)
INSERT INTO `guild_item_points` VALUES (6,16668,2,374,3040,4); -- Bone Pick +1 (374 / 3040)
INSERT INTO `guild_item_points` VALUES (6,12834,2,362,3040,5); -- Bone Subligar (362 / 3040)
INSERT INTO `guild_item_points` VALUES (6,12912,2,374,3040,5); -- Bone Subligar +1 (374 / 3040)
INSERT INTO `guild_item_points` VALUES (6,12711,2,282,2800,6); -- Beetle Mittens (282 / 2800)
INSERT INTO `guild_item_points` VALUES (6,12789,2,306,2800,6); -- Beetle Mittens +1 (306 / 2800)
INSERT INTO `guild_item_points` VALUES (6,16642,2,933,4400,7); -- Bone Axe: 205/2560 -> 933/4400
INSERT INTO `guild_item_points` VALUES (6,16666,2,1026,4400,7); -- Bone Axe +1: 317/4400 -> 1026/4400

-- Bonecraft / Novice
INSERT INTO `guild_item_points` VALUES (6,13459,3,1200,4800,0); -- Horn Ring (1200 / 4800)
INSERT INTO `guild_item_points` VALUES (6,13502,3,1680,4800,0); -- Horn Ring +1 (1680 / 4800)
INSERT INTO `guild_item_points` VALUES (6,17026,3,768,4160,1); -- Bone Cudgel (768 / 4160)
INSERT INTO `guild_item_points` VALUES (6,17033,3,1088,4160,1); -- Bone Cudgel +1 (1088 / 4160)
INSERT INTO `guild_item_points` VALUES (6,12967,3,966,4480,2); -- Beetle Leggings (966 / 4480)
INSERT INTO `guild_item_points` VALUES (6,13043,3,1202,4480,2); -- Beetle Leggings +1 (1202 / 4480)
INSERT INTO `guild_item_points` VALUES (6,12583,3,471,3520,3); -- Beetle Harness (471 / 3520)
INSERT INTO `guild_item_points` VALUES (6,13717,3,495,3520,3); -- Beetle Harness +1 (495 / 3520)
INSERT INTO `guild_item_points` VALUES (6,12835,3,471,3520,4); -- Beetle Subligar (471 / 3520)
INSERT INTO `guild_item_points` VALUES (6,12913,3,495,3520,4); -- Beetle Subligar +1 (495 / 3520)
INSERT INTO `guild_item_points` VALUES (6,12414,3,1290,4960,5); -- Turtle Shield: 615/3840 -> 1290/4960
INSERT INTO `guild_item_points` VALUES (6,12413,3,1590,4960,5); -- Turtle Shield +1: 735/3840 -> 1590/4960
INSERT INTO `guild_item_points` VALUES (6,15315,3,3797,6480,6); -- Shade Leggings (3797 / 6480)
INSERT INTO `guild_item_points` VALUES (6,15319,3,3989,6480,6); -- Shade Leggings +1 (3989 / 6480)
INSERT INTO `guild_item_points` VALUES (6,13090,3,778,4160,7); -- Beetle Gorget: 448/3440 -> 778/4160
INSERT INTO `guild_item_points` VALUES (6,13062,3,1013,4160,7); -- Green Gorget: 542/3440 -> 1013/4160

-- Bonecraft / Apprentice
INSERT INTO `guild_item_points` VALUES (6,17352,4,780,4320,0); -- Horn (780 / 4320)
INSERT INTO `guild_item_points` VALUES (6,17371,4,840,4320,0); -- Horn +1 (840 / 4320)
INSERT INTO `guild_item_points` VALUES (6,12837,4,1540,5280,1); -- Carapace Subligar (1540 / 5280)
INSERT INTO `guild_item_points` VALUES (6,12914,4,1610,5280,1); -- Carapace Subligar +1 (1610 / 5280)
INSERT INTO `guild_item_points` VALUES (6,13461,4,1812,5520,2); -- Carapace Ring (1812 / 5520)
INSERT INTO `guild_item_points` VALUES (6,13503,4,2537,5520,2); -- Carapace Ring +1 (2537 / 5520)
INSERT INTO `guild_item_points` VALUES (6,13715,4,1470,5200,3); -- Carapace Leggings (1470 / 5200)
INSERT INTO `guild_item_points` VALUES (6,13044,4,1540,5200,3); -- Carapace Leggings +1 (1540 / 5200)
INSERT INTO `guild_item_points` VALUES (6,13713,4,1050,4720,4); -- Carapace Mittens (1050 / 4720)
INSERT INTO `guild_item_points` VALUES (6,12790,4,1120,4720,4); -- Carapace Mittens +1 (1120 / 4720)
INSERT INTO `guild_item_points` VALUES (6,13711,4,1050,4720,5); -- Carapace Mask (1050 / 4720)
INSERT INTO `guild_item_points` VALUES (6,13829,4,1120,4720,5); -- Carapace Mask +1 (1120 / 4720)
INSERT INTO `guild_item_points` VALUES (6,13091,4,2310,5840,6); -- Carapace Gorget (2310 / 5840)
INSERT INTO `guild_item_points` VALUES (6,13063,4,3010,5840,6); -- Blue Gorget (3010 / 5840)
INSERT INTO `guild_item_points` VALUES (6,17610,4,750,4240,7); -- Bone Knife (750 / 4240)
INSERT INTO `guild_item_points` VALUES (6,17611,4,825,4240,7); -- Bone Knife +1 (825 / 4240)

-- Bonecraft / Journeyman
INSERT INTO `guild_item_points` VALUES (6,16794,5,825,4480,0); -- Bone Scythe (825 / 4480)
INSERT INTO `guild_item_points` VALUES (6,16795,5,907,4480,0); -- Bone Scythe +1 (907 / 4480)
INSERT INTO `guild_item_points` VALUES (6,13199,5,26,2400,1); -- Scorpion Ring -> Blood Stone (26/2400)
INSERT INTO `guild_item_points` VALUES (6,13226,5,26,2400,1); -- Scorpion Ring +1 -> Blood Stone +1 (26/2400)
INSERT INTO `guild_item_points` VALUES (6,17257,5,2000,5680,2); -- Bandit's Gun (2000 / 5680)
INSERT INTO `guild_item_points` VALUES (6,17258,5,2100,5680,2); -- Bandit's Gun +1 (2100 / 5680)
INSERT INTO `guild_item_points` VALUES (6,13324,5,1750,5520,3); -- Tortoise Earring (1750 / 5520)
INSERT INTO `guild_item_points` VALUES (6,13363,5,2450,5520,3); -- Tortoise Earring +1 (2450 / 5520)
INSERT INTO `guild_item_points` VALUES (6,12506,5,750,4320,4); -- Shell Hairpin (750 / 4320)
INSERT INTO `guild_item_points` VALUES (6,13836,5,850,4320,4); -- Shell Hairpin +1 (850 / 4320)
INSERT INTO `guild_item_points` VALUES (6,13981,5,3332,6320,5); -- Turtle Bangles (3332 / 6320)
INSERT INTO `guild_item_points` VALUES (6,13982,5,4107,6320,5); -- Turtle Bangles +1 (4107 / 6320)
INSERT INTO `guild_item_points` VALUES (6,17612,5,1025,4720,6); -- Beetle Knife (1025 / 4720)
INSERT INTO `guild_item_points` VALUES (6,17613,5,1127,4720,6); -- Beetle Knife +1 (1127 / 4720)
INSERT INTO `guild_item_points` VALUES (6,17062,5,1122,4880,7); -- Bone Rod (1122 / 4880)
INSERT INTO `guild_item_points` VALUES (6,17410,5,1782,4880,7); -- Bone Rod +1 (1782 / 4880)

-- Bonecraft / Craftsman
INSERT INTO `guild_item_points` VALUES (6,17361,6,1845,5600,0); -- Crumhorn (1845 / 5600)
INSERT INTO `guild_item_points` VALUES (6,17377,6,1947,5600,0); -- Crumhorn +1 (1947 / 5600)
-- Remove Crumhorn +2 (not a valid turn-in item)
INSERT INTO `guild_item_points` VALUES (6,12838,6,1575,5360,1); -- Scorpion Subligar (1575 / 5360)
INSERT INTO `guild_item_points` VALUES (6,14208,6,1680,5360,1); -- Scorpion Subligar +1 (1680 / 5360)
INSERT INTO `guild_item_points` VALUES (6,17259,6,4320,6640,2); -- Pirate's Gun (4320 / 6640)
INSERT INTO `guild_item_points` VALUES (6,17260,6,4352,6640,2); -- Pirate's Gun +1 (4352 / 6640)
INSERT INTO `guild_item_points` VALUES (6,12963,6,1575,5360,3); -- Scorpion Leggings (1575 / 5360)
INSERT INTO `guild_item_points` VALUES (6,14083,6,1680,5360,3); -- Scorpion Leggings +1 (1680 / 5360)
INSERT INTO `guild_item_points` VALUES (6,12707,6,1050,4800,4); -- Scorpion Mittens (1050 / 4800)
INSERT INTO `guild_item_points` VALUES (6,13956,6,1155,4800,4); -- Scorpion Mittens +1 (1155 / 4800)
INSERT INTO `guild_item_points` VALUES (6,12451,6,1050,4800,5); -- Scorpion Mask (1050 / 4800)
INSERT INTO `guild_item_points` VALUES (6,12482,6,1155,4800,5); -- Scorpion Mask +1: 1150/4800 -> 1155/4800
INSERT INTO `guild_item_points` VALUES (6,16420,6,1230,5040,6); -- Bone Patas (1230 / 5040)
INSERT INTO `guild_item_points` VALUES (6,17477,6,1332,5040,6); -- Bone Patas +1 (1332 / 5040)
INSERT INTO `guild_item_points` VALUES (6,13325,6,2500,6000,7); -- Fang Earring (2500 / 6000)
INSERT INTO `guild_item_points` VALUES (6,13369,6,3500,6000,7); -- Spike Earring (3500 / 6000)

-- Bonecraft / Artisan
INSERT INTO `guild_item_points` VALUES (6,12453,7,2992,6240,0); -- Coral Cap (2992 / 6240)
INSERT INTO `guild_item_points` VALUES (6,13864,7,3150,6240,0); -- Merman's Cap (3150 / 6240)
INSERT INTO `guild_item_points` VALUES (6,13108,7,1560,5440,1); -- Coral Gorget (1560 / 5440)
INSERT INTO `guild_item_points` VALUES (6,13123,7,1690,5440,1); -- Merman's Gorget (1690 / 5440)
INSERT INTO `guild_item_points` VALUES (6,12819,7,4375,6640,2); -- Coral Cuisses (4375 / 6640)
INSERT INTO `guild_item_points` VALUES (6,14230,7,4500,6640,2); -- Coral Cuisses +1 (4500 / 6640)
INSERT INTO `guild_item_points` VALUES (6,12435,7,3000,6240,3); -- Coral Visor (3000 / 6240)
INSERT INTO `guild_item_points` VALUES (6,13859,7,3120,6240,3); -- Coral Visor +1 (3120 / 6240)
INSERT INTO `guild_item_points` VALUES (6,12709,7,6412,7040,4); -- Coral Mittens (6412 / 7040)
INSERT INTO `guild_item_points` VALUES (6,13995,7,6412,7040,4); -- Merman's Mittens: 7837 -> 6412
INSERT INTO `guild_item_points` VALUES (6,12508,7,3262,6400,5); -- Coral Hairpin (3262 / 6400)
INSERT INTO `guild_item_points` VALUES (6,13850,7,3375,6400,5); -- Merman's Hairpin (3375 / 6400)
INSERT INTO `guild_item_points` VALUES (6,16422,7,3625,6480,6); -- Tigerfangs (3625 / 6480)
INSERT INTO `guild_item_points` VALUES (6,17490,7,3625,6480,6); -- Feral Fangs: 3770 -> 3625
INSERT INTO `guild_item_points` VALUES (6,16525,7,3840,6560,7); -- Hornet Fleuret (3840 / 6560)
INSERT INTO `guild_item_points` VALUES (6,17634,7,3960,6560,7); -- Hornet Fleuret +1 (3960 / 6560)

-- Bonecraft / Adept
INSERT INTO `guild_item_points` VALUES (6,12436,8,7200,7200,0); -- Dragon Mask: 7840/7200 -> 7200/7200
INSERT INTO `guild_item_points` VALUES (6,13860,8,8120,7200,0); -- Dragon Mask +1 (8120 / 7200)
INSERT INTO `guild_item_points` VALUES (6,13987,8,3600,6480,1); -- Coral Bangles (3600 / 6480)
INSERT INTO `guild_item_points` VALUES (6,13988,8,4162,6480,1); -- Merman's Bangles (4162 / 6480)
INSERT INTO `guild_item_points` VALUES (6,12820,8,7280,7280,2); -- Dragon Cuisses: 9487/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (6,14231,8,7280,7280,2); -- Dragon Cuisses +1: 9762/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (6,12948,8,6090,6960,3); -- Dragon Greaves (6090 / 6960)
INSERT INTO `guild_item_points` VALUES (6,14107,8,7200,6960,3); -- Dragon Greaves +1 (7200 / 6960)
INSERT INTO `guild_item_points` VALUES (6,12692,8,6900,7120,4); -- Dragon Finger Gauntlets (6900 / 7120)
INSERT INTO `guild_item_points` VALUES (6,13991,8,7200,7120,4); -- Dragon Finger Gauntlets +1 (7200 / 7120)
INSERT INTO `guild_item_points` VALUES (6,13312,8,3750,6560,5); -- Coral Earring (3750 / 6560)
INSERT INTO `guild_item_points` VALUES (6,13406,8,5250,6560,5); -- Merman's Earring (5250 / 6560)
INSERT INTO `guild_item_points` VALUES (6,16548,8,7600,7600,6); -- Coral Sword: 16280 -> 7600
INSERT INTO `guild_item_points` VALUES (6,16620,8,7600,7600,6); -- Merman's Sword: 16280 -> 7600
INSERT INTO `guild_item_points` VALUES (6,12308,8,5400,6880,7); -- Darksteel Shield (5400 / 6880)
INSERT INTO `guild_item_points` VALUES (6,12346,8,6525,6880,7); -- Darksteel Shield +1 (6525 / 6880)

-- Bonecraft / Veteran
INSERT INTO `guild_item_points` VALUES (6,12693,9,2000,5840,0); -- Gavial Finger Gauntlets (2000 / 5840)
INSERT INTO `guild_item_points` VALUES (6,14829,9,2625,5840,0); -- Gavial Finger Gauntlets +1 (2625 / 5840)
INSERT INTO `guild_item_points` VALUES (6,12751,9,5940,6960,1); -- Scorpion Gauntlets (5940 / 6960)
INSERT INTO `guild_item_points` VALUES (6,12717,9,7040,6960,1); -- Scorpion Gauntlets +1 (7040 / 6960)
INSERT INTO `guild_item_points` VALUES (6,14008,9,5850,6960,2); -- Carapace Gauntlets (5850 / 6960)
INSERT INTO `guild_item_points` VALUES (6,14009,9,6825,6960,2); -- Carapace Gauntlets +1 (6825 / 6960)
INSERT INTO `guild_item_points` VALUES (6,13846,9,6049,7040,3); -- Scorpion Helm: 6490 -> 6049
INSERT INTO `guild_item_points` VALUES (6,12461,9,7590,7040,3); -- Scorpion Helm +1 (7590 / 7040)
INSERT INTO `guild_item_points` VALUES (6,13878,9,6337,7040,4); -- Carapace Helm (6337 / 7040)
INSERT INTO `guild_item_points` VALUES (6,13879,9,7040,7040,4); -- Carapace Helm +1: 7312/7040 -> 7040/7040
INSERT INTO `guild_item_points` VALUES (6,13789,9,13455,7520,5); -- Carapace Breastplate (13455 / 7520)
INSERT INTO `guild_item_points` VALUES (6,13790,9,14430,7520,5); -- Carapace Breastplate +1 (14430 / 7520)
INSERT INTO `guild_item_points` VALUES (6,12621,9,13860,7520,6); -- Scorpion Breastplate (13860 / 7520)
INSERT INTO `guild_item_points` VALUES (6,12589,9,14960,7520,6); -- Scorpion Breastplate +1 (14960 / 7520)
INSERT INTO `guild_item_points` VALUES (6,13922,9,3570,6480,7); -- Demon Helm (3570 / 6480)
INSERT INTO `guild_item_points` VALUES (6,13923,9,4845,6480,7); -- Demon Helm +1 (4845 / 6480)

-- Alchemy / Amateur
INSERT INTO `guild_item_points` VALUES (7,4166,0,250,2320,0); -- Deodorizer: 80/1520 -> 250/2320
INSERT INTO `guild_item_points` VALUES (7,13683,0,210,2160,1); -- Water Tank (210 / 2160)
INSERT INTO `guild_item_points` VALUES (7,4148,0,79,1520,2); -- Antidote (79 / 1520)
INSERT INTO `guild_item_points` VALUES (7,16600,0,67,1440,3); -- Tsurara -> Wax Sword (67/1440)
INSERT INTO `guild_item_points` VALUES (7,913,0,30,1280,4); -- Beeswax (30 / 1280)
INSERT INTO `guild_item_points` VALUES (7,4162,0,150,1920,5); -- Silencing Potion (150 / 1920)
INSERT INTO `guild_item_points` VALUES (7,4166,0,250,2320,6); -- Deodorizer: 80/1520 -> 250/2320
INSERT INTO `guild_item_points` VALUES (7,4148,0,79,1520,7); -- Antidote (79 / 1520)
INSERT INTO `guild_item_points` VALUES (7,16610,0,75,1440,3); -- Wax Sword +1 - Amateur Pattern D

-- Alchemy / Recruit
INSERT INTO `guild_item_points` VALUES (7,16429,1,825,4080,0); -- Silence Baghnakhs (825 / 4080)
INSERT INTO `guild_item_points` VALUES (7,16438,1,825,4080,0); -- Silence Baghnakhs +1 (825 / 4080)
INSERT INTO `guild_item_points` VALUES (7,4157,1,100,1920,1); -- Poison Potion (100 / 1920)
INSERT INTO `guild_item_points` VALUES (7,16495,1,406,3040,2); -- Silence Dagger (406 / 3040)
INSERT INTO `guild_item_points` VALUES (7,16508,1,406,3040,2); -- Silence Dagger +1 (406 / 3040)
INSERT INTO `guild_item_points` VALUES (7,914,1,300,2720,3); -- Mercury (300 / 2720)
INSERT INTO `guild_item_points` VALUES (7,16572,1,705,3840,4); -- Bee Spatha (705 / 3840)
INSERT INTO `guild_item_points` VALUES (7,16611,1,775,3840,4); -- Bee Spatha +1 (775 / 3840)
INSERT INTO `guild_item_points` VALUES (7,4167,1,21,1520,5); -- Bittern -> Cracker (21/1520)
INSERT INTO `guild_item_points` VALUES (7,4151,1,200,2320,6); -- Echo Drops (200 / 2320)
INSERT INTO `guild_item_points` VALUES (7,16495,1,406,3040,7); -- Silence Dagger (406 / 3040)
INSERT INTO `guild_item_points` VALUES (7,16508,1,406,3040,7); -- Silence Dagger +1 (406 / 3040)

-- Alchemy / Initiate
INSERT INTO `guild_item_points` VALUES (7,16496,2,959,4400,0); -- Poison Dagger (959 / 4400)
INSERT INTO `guild_item_points` VALUES (7,16741,2,1142,4400,0); -- Poison Dagger +1 (1142 / 4400)
INSERT INTO `guild_item_points` VALUES (7,16906,2,894,4320,1); -- Mokuto (894 / 4320)
INSERT INTO `guild_item_points` VALUES (7,16925,2,902,4320,1); -- Mokuto +1 (902 / 4320)
INSERT INTO `guild_item_points` VALUES (7,16472,2,1226,4800,2); -- Poison Knife (1226 / 4800)
INSERT INTO `guild_item_points` VALUES (7,16742,2,1453,4800,2); -- Poison Knife +1 (1453 / 4800)
INSERT INTO `guild_item_points` VALUES (7,4168,2,25,1760,3); -- Silent Oil -> Twinkle Shower (25/1760)
INSERT INTO `guild_item_points` VALUES (7,16906,2,894,4320,4); -- Mokuto (894 / 4320)
INSERT INTO `guild_item_points` VALUES (7,16925,2,902,4320,4); -- Mokuto +1 (902 / 4320)
INSERT INTO `guild_item_points` VALUES (7,16458,2,1107,4640,5); -- Poison Baselard: 330/2933 -> 1107/4640
INSERT INTO `guild_item_points` VALUES (7,16743,2,1312,4640,5); -- Python Baselard: 457/2933 -> 1312/4640
INSERT INTO `guild_item_points` VALUES (7,4150,2,519,3520,6); -- Eye Drops (519 / 3520)
INSERT INTO `guild_item_points` VALUES (7,16496,2,959,4400,7); -- Poison Dagger (959 / 4400)
INSERT INTO `guild_item_points` VALUES (7,16741,2,1142,4400,7); -- Poison Dagger +1 (1142 / 4400)

-- Alchemy / Novice
INSERT INTO `guild_item_points` VALUES (7,16410,3,2112,5680,0); -- Poison Baghnakhs: 638/3920 -> 2112/5680
INSERT INTO `guild_item_points` VALUES (7,16692,3,748,3920,0); -- Poison Baghnakhs +1 (748 / 3920)
INSERT INTO `guild_item_points` VALUES (7,16417,3,2400,5840,1); -- Poison Claws (2400 / 5840)
INSERT INTO `guild_item_points` VALUES (7,16439,3,2400,5840,1); -- Poison Claws +1 (2400 / 5840)
INSERT INTO `guild_item_points` VALUES (7,16454,3,100,2320,2); -- Blind Dagger (100 / 2320)
INSERT INTO `guild_item_points` VALUES (7,16493,3,120,2320,2); -- Blind Dagger +1 (120 / 2320)
INSERT INTO `guild_item_points` VALUES (7,16471,3,135,2480,3); -- Blind Knife (135 / 2480)
INSERT INTO `guild_item_points` VALUES (7,16490,3,161,2480,3); -- Blind Knife +1 (161 / 2480)
INSERT INTO `guild_item_points` VALUES (7,16907,3,1200,4800,4); -- Busuto (1200 / 4800)
INSERT INTO `guild_item_points` VALUES (7,16927,3,1230,4800,4); -- Busuto +1 (1230 / 4800)
INSERT INTO `guild_item_points` VALUES (7,16387,3,992,4560,5); -- Poison Cesti (992 / 4560)
INSERT INTO `guild_item_points` VALUES (7,16700,3,1312,4560,5); -- Poison Cesti +1 (1312 / 4560)
INSERT INTO `guild_item_points` VALUES (7,16594,3,3488,6400,6); -- Inferno Sword (3488 / 6400)
INSERT INTO `guild_item_points` VALUES (7,16928,3,3488,6400,6); -- Hellfire Sword (3488 / 6400)
INSERT INTO `guild_item_points` VALUES (7,16478,3,1620,5280,7); -- Poison Kukri (1620 / 5280)
INSERT INTO `guild_item_points` VALUES (7,16489,3,1620,5280,7); -- Poison Kukri +1 (1620 / 5280)

-- Alchemy / Apprentice
INSERT INTO `guild_item_points` VALUES (7,16543,4,1320,5040,0); -- Fire Sword (1320 / 5040)
INSERT INTO `guild_item_points` VALUES (7,16621,4,1320,5040,0); -- Flame Sword (1320 / 5040)
INSERT INTO `guild_item_points` VALUES (7,16501,4,2480,5920,1); -- Acid Knife (2480 / 5920)
INSERT INTO `guild_item_points` VALUES (7,17608,4,2880,5920,1); -- Corrosive Knife (2880 / 5920)
INSERT INTO `guild_item_points` VALUES (7,16905,4,1240,4960,2); -- Bokuto (1240 / 4960)
INSERT INTO `guild_item_points` VALUES (7,16926,4,1426,4960,2); -- Bokuto +1 (1426 / 4960)
INSERT INTO `guild_item_points` VALUES (7,17605,4,1717,5440,3); -- Acid Dagger (1717 / 5440)
INSERT INTO `guild_item_points` VALUES (7,17606,4,2003,5440,3); -- Corrosive Dagger (2003 / 5440)
INSERT INTO `guild_item_points` VALUES (7,16403,4,2464,5920,4); -- Poison Katars (2464 / 5920)
INSERT INTO `guild_item_points` VALUES (7,16693,4,3024,5920,4); -- Poison Katars +1 (3024 / 5920)
INSERT INTO `guild_item_points` VALUES (7,16588,4,979,4640,5); -- Flame Claymore (979 / 4640)
INSERT INTO `guild_item_points` VALUES (7,16929,4,979,4640,5); -- Burning Claymore (979 / 4640)
INSERT INTO `guild_item_points` VALUES (7,13684,4,210,2880,6); -- Potion Tank (210 / 2880)
INSERT INTO `guild_item_points` VALUES (7,16709,4,349,3360,7); -- Inferno Axe (349 / 3360)
INSERT INTO `guild_item_points` VALUES (7,16713,4,380,3360,7); -- Hellfire Axe (380 / 3360)

-- Alchemy / Journeyman
INSERT INTO `guild_item_points` VALUES (7,16908,5,1200,4960,0); -- Yoto (1200 / 4960)
INSERT INTO `guild_item_points` VALUES (7,17768,5,1350,4960,0); -- Yoto +1 (1350 / 4960)
INSERT INTO `guild_item_points` VALUES (7,16523,5,5600,6880,1); -- Holy Degen (5600 / 6880)
INSERT INTO `guild_item_points` VALUES (7,16817,5,6300,6880,1); -- Holy Degen +1 (6300 / 6880)
INSERT INTO `guild_item_points` VALUES (7,16430,5,2976,6240,2); -- Acid Claws (2976 / 6240)
INSERT INTO `guild_item_points` VALUES (7,17487,5,3596,6240,2); -- Corrosive Claws (3596 / 6240)
INSERT INTO `guild_item_points` VALUES (7,17041,5,3102,6240,3); -- Holy Mace: max 6090 -> 6240
INSERT INTO `guild_item_points` VALUES (7,17411,5,3762,6090,3); -- Holy Mace +1 (3762 / 6090)
INSERT INTO `guild_item_points` VALUES (7,16581,5,4300,6640,4); -- Holy Sword (4300 / 6640)
INSERT INTO `guild_item_points` VALUES (7,16816,5,4800,6640,4); -- Holy Sword +1 (4800 / 6640)
INSERT INTO `guild_item_points` VALUES (7,16973,5,2300,5840,5); -- Homura (2300 / 5840)
INSERT INTO `guild_item_points` VALUES (7,16986,5,2392,5840,5); -- Homura +1 (2392 / 5840)
INSERT INTO `guild_item_points` VALUES (7,16973,5,2300,5840,6); -- Homura (2300 / 5840)
INSERT INTO `guild_item_points` VALUES (7,16986,5,2392,5840,6); -- Homura +1 (2392 / 5840)
INSERT INTO `guild_item_points` VALUES (7,13682,5,210,3040,7); -- Ether Tank (210 / 3040)

-- Alchemy / Craftsman
INSERT INTO `guild_item_points` VALUES (7,16479,6,2944,6240,0); -- Acid Kukri (2944 / 6240)
INSERT INTO `guild_item_points` VALUES (7,16494,6,2944,6240,0); -- Corrosive Kukri: 3404 -> 2944
INSERT INTO `guild_item_points` VALUES (7,16539,6,7280,7280,1); -- Cermet Sword: 9460/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (7,16825,6,7280,7280,1); -- Cermet Sword +1: 10560/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (7,16414,6,5280,6880,2); -- Cermet Claws (5280 / 6880)
INSERT INTO `guild_item_points` VALUES (7,17488,6,6380,6880,2); -- Cermet Claws +1 (6380 / 6880)
INSERT INTO `guild_item_points` VALUES (7,16554,6,7360,7360,3); -- Hanger: 10185/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (7,17642,6,7360,7360,3); -- Hanger +1: 11235/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (7,16549,6,4928,6800,4); -- Divine Sword (4928 / 6800)
INSERT INTO `guild_item_points` VALUES (7,16826,6,5488,6800,4); -- Divine Sword +1 (5488 / 6800)
INSERT INTO `guild_item_points` VALUES (7,16459,6,3720,6480,5); -- Acid Baselard (3720 / 6480)
INSERT INTO `guild_item_points` VALUES (7,17607,6,4320,6480,5); -- Corrosive Baselard (4320 / 6480)
INSERT INTO `guild_item_points` VALUES (7,16568,6,7360,7360,6); -- Saber: 8200/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (7,16612,6,7360,7360,6); -- Saber +1: 11275/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (7,16469,6,5850,6960,7); -- Cermet Knife: max 6933 -> 6960
INSERT INTO `guild_item_points` VALUES (7,17609,6,6960,6960,7); -- Cermet Knife +1: 6975/6960 -> 6960/6960

-- Alchemy / Artisan
INSERT INTO `guild_item_points` VALUES (7,16477,7,7280,7280,0); -- Cermet Kukri: 8910/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (7,17603,7,7280,7280,0); -- Cermet Kukri +1: 9075/7280 -> 7280/7280
INSERT INTO `guild_item_points` VALUES (7,16401,7,6710,7040,1); -- Jamadhars (6710 / 7040)
INSERT INTO `guild_item_points` VALUES (7,17482,7,6862,7040,1); -- Jamadhars +1 (6862 / 7040)
INSERT INTO `guild_item_points` VALUES (7,16418,7,5040,6800,2); -- Venom Claws (5040 / 6800)
INSERT INTO `guild_item_points` VALUES (7,16425,7,5040,6800,2); -- Venom Claws +1 (5040 / 6800)
INSERT INTO `guild_item_points` VALUES (7,16505,7,7120,7120,3); -- Venom Kukri: 7290/7120 -> 7120/7120
INSERT INTO `guild_item_points` VALUES (7,17604,7,7290,7290,3); -- Venom Kukri +1: 7425/7120 -> 7290/7290
INSERT INTO `guild_item_points` VALUES (7,16560,7,7440,7440,4); -- Cutlass: 12250/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (7,17639,7,7440,7440,4); -- Cutlass +1: 12372/7440 -> 7440/7440
INSERT INTO `guild_item_points` VALUES (7,16507,7,6370,7040,5); -- Venom Baselard (6370 / 7040)
INSERT INTO `guild_item_points` VALUES (7,16510,7,6370,7040,5); -- Venom Baselard +1 (6370 / 7040)
INSERT INTO `guild_item_points` VALUES (7,12379,7,700,4400,6); -- Stun Knife -> Holy Shield (700/4400)
INSERT INTO `guild_item_points` VALUES (7,12380,7,805,4400,6); -- Stun Knife +1 -> Divine Shield (770/4400)
INSERT INTO `guild_item_points` VALUES (7,17080,7,3192,6320,7); -- Holy Maul (3192 / 6320)
INSERT INTO `guild_item_points` VALUES (7,17114,7,3752,6320,7); -- Holy Maul +1 (3752 / 6320)

-- Alchemy / Adept
INSERT INTO `guild_item_points` VALUES (7,16499,8,5670,6960,0); -- Venom Kris (5670 / 6960)
INSERT INTO `guild_item_points` VALUES (7,16761,8,6195,6960,0); -- Venom Kris +1 (6195 / 6960)
INSERT INTO `guild_item_points` VALUES (7,16609,8,7440,7440,1); -- Bloody Sword: 12375 -> 7440
INSERT INTO `guild_item_points` VALUES (7,17646,8,13062,7440,1); -- Carnage Sword (13062 / 7440)
INSERT INTO `guild_item_points` VALUES (7,16431,8,6480,7040,2); -- Stun Claws (6480 / 7040)
INSERT INTO `guild_item_points` VALUES (7,17486,8,6615,7040,2); -- Stun Claws +1 (6615 / 7040)
INSERT INTO `guild_item_points` VALUES (7,16506,8,7360,7360,3); -- Stun Kukri: 9585/7360 -> 7360/7360
INSERT INTO `guild_item_points` VALUES (7,17614,8,9762,7360,3); -- Stun Kukri +1 (9762 / 7360)
INSERT INTO `guild_item_points` VALUES (7,16860,8,3150,6320,4); -- Holy Lance (3150 / 6320)
INSERT INTO `guild_item_points` VALUES (7,16880,8,4275,6320,4); -- Holy Lance +1 (4275 / 6320)
INSERT INTO `guild_item_points` VALUES (7,16528,8,7200,7200,5); -- Bloody Rapier: 7600 -> 7200
INSERT INTO `guild_item_points` VALUES (7,16824,8,7200,7200,5); -- Carnage Rapier: 8550 -> 7200
INSERT INTO `guild_item_points` VALUES (7,16432,8,7370,7120,6); -- Stun Jamadhars (7370 / 7120)
INSERT INTO `guild_item_points` VALUES (7,17484,8,7537,7120,6); -- Stun Jamadhars +1 (7537 / 7120)
INSERT INTO `guild_item_points` VALUES (7,17085,8,3060,6320,7); -- Holy Wand (3060 / 6320)
INSERT INTO `guild_item_points` VALUES (7,17434,8,3240,6320,7); -- Holy Wand +1 (3240 / 6320)

-- Alchemy / Veteran
INSERT INTO `guild_item_points` VALUES (7,4209,9,900,4800,0); -- Mind Potion (900 / 4800)
INSERT INTO `guild_item_points` VALUES (7,4211,9,750,4640,1); -- Charisma Potion (750 / 4640)
INSERT INTO `guild_item_points` VALUES (7,4201,9,900,4800,2); -- Dexterity Potion (900 / 4800)
INSERT INTO `guild_item_points` VALUES (7,4207,9,840,4800,3); -- Intelligence Potion (840 / 4800)
INSERT INTO `guild_item_points` VALUES (7,4203,9,750,4640,4); -- Vitality Potion (750 / 4640)
INSERT INTO `guild_item_points` VALUES (7,4205,9,810,4720,5); -- Agility Potion (810 / 4720)
INSERT INTO `guild_item_points` VALUES (7,12305,9,5565,6960,6); -- Ice Shield (5565 / 6960)
INSERT INTO `guild_item_points` VALUES (7,12357,9,6890,6960,6); -- Ice Shield +1 (6890 / 6960)
INSERT INTO `guild_item_points` VALUES (7,4199,9,900,4800,7); -- Strength Potion (900 / 4800)

-- Cooking / Amateur
INSERT INTO `guild_item_points` VALUES (8,17016,0,3,1120,0); -- Pet Food Alpha: 4/3360 -> 3/1120
INSERT INTO `guild_item_points` VALUES (8,4415,0,31,1280,1); -- Roasted Corn: 46/4080 -> 31/1280
INSERT INTO `guild_item_points` VALUES (8,4334,0,37,1280,1); -- Grilled Corn: 55/4080 -> 37/1280
INSERT INTO `guild_item_points` VALUES (8,4455,0,50,1360,2); -- Orange Juice -> Pebble Soup (50/1360)
INSERT INTO `guild_item_points` VALUES (8,4535,0,100,1600,3); -- Boiled Crayfish: 150/5760 -> 100/1600
INSERT INTO `guild_item_points` VALUES (8,4338,0,120,1600,3); -- Steamed Crayfish: 180/5760 -> 120/1600
INSERT INTO `guild_item_points` VALUES (8,4455,0,50,1360,4); -- Orange Juice -> Pebble Soup (50/1360)
INSERT INTO `guild_item_points` VALUES (8,4355,0,278,2400,5); -- Salmon Sub: 417/8880 -> 278/2400
INSERT INTO `guild_item_points` VALUES (8,4266,0,288,2400,5); -- Fulm-long Salmon Sub: 432/8880 -> 288/2400
INSERT INTO `guild_item_points` VALUES (8,4355,0,278,2400,6); -- Salmon Sub: 417/8880 -> 278/2400
INSERT INTO `guild_item_points` VALUES (8,4266,0,288,2400,6); -- Fulm-long Salmon Sub: 432/8880 -> 288/2400
INSERT INTO `guild_item_points` VALUES (8,4415,0,31,1280,7); -- Roasted Corn: 46/4080 -> 31/1280
INSERT INTO `guild_item_points` VALUES (8,4334,0,37,1280,7); -- Grilled Corn: 55/4080 -> 37/1280
INSERT INTO `guild_item_points` VALUES (8,4592,0,55,1360,2); -- Wisdom Soup - Amateur Pattern C
INSERT INTO `guild_item_points` VALUES (8,4592,0,55,1360,4); -- Wisdom Soup - Amateur Pattern E

-- Cooking / Recruit
INSERT INTO `guild_item_points` VALUES (8,4437,1,180,2240,0); -- Roast Mutton: 270/7680 -> 180/2240
INSERT INTO `guild_item_points` VALUES (8,4335,1,200,2240,0); -- Juicy Mutton: 300/7680 -> 200/2240
INSERT INTO `guild_item_points` VALUES (8,4416,1,280,2640,1); -- Pea Soup: 420/9360 -> 280/2640
INSERT INTO `guild_item_points` VALUES (8,4327,1,361,2640,1); -- Emerald Soup: 541/9360 -> 361/2640
INSERT INTO `guild_item_points` VALUES (8,4437,1,180,2240,2); -- Roast Mutton: 270/7680 -> 180/2240
INSERT INTO `guild_item_points` VALUES (8,4335,1,200,2240,2); -- Juicy Mutton: 300/7680 -> 200/2240
INSERT INTO `guild_item_points` VALUES (8,4408,1,35,1600,3); -- Tortilla: 52/5040 -> 35/1600
INSERT INTO `guild_item_points` VALUES (8,5181,1,52,1600,3); -- Tortilla Buena: 78/5040 -> 52/1600
INSERT INTO `guild_item_points` VALUES (8,4416,1,280,2640,4); -- Pea Soup: 420/9360 -> 280/2640
INSERT INTO `guild_item_points` VALUES (8,4327,1,361,2640,4); -- Emerald Soup: 541/9360 -> 361/2640
INSERT INTO `guild_item_points` VALUES (8,4537,1,130,2000,5); -- Roast Carp: 195/6960 -> 130/2000
INSERT INTO `guild_item_points` VALUES (8,4586,1,160,2000,5); -- Broiled Carp: 240/6960 -> 160/2000
INSERT INTO `guild_item_points` VALUES (8,4537,1,130,2000,6); -- Roast Carp: 195/6960 -> 130/2000
INSERT INTO `guild_item_points` VALUES (8,4586,1,160,2000,6); -- Broiled Carp: 240/6960 -> 160/2000
INSERT INTO `guild_item_points` VALUES (8,4408,1,35,1600,7); -- Tortilla: 52/5040 -> 35/1600
INSERT INTO `guild_item_points` VALUES (8,5181,1,52,1600,7); -- Tortilla Buena: 78/5040 -> 52/1600

-- Cooking / Initiate
INSERT INTO `guild_item_points` VALUES (8,4380,2,55,1920,0); -- Smoked Salmon: 82/6000 -> 55/1920
INSERT INTO `guild_item_points` VALUES (8,4438,2,360,3040,1); -- Dhalmel Steak: 540/10800 -> 360/3040
INSERT INTO `guild_item_points` VALUES (8,4519,2,390,3040,1); -- Wild Steak: 585/10800 -> 390/3040
INSERT INTO `guild_item_points` VALUES (8,4492,2,150,2320,2); -- Puls: 225/7920 -> 150/2320
INSERT INTO `guild_item_points` VALUES (8,4533,2,150,2320,2); -- Delicious Puls: 450/7920 -> 150/2320
INSERT INTO `guild_item_points` VALUES (8,4406,2,110,2160,3); -- Baked Apple: 165/7200 -> 110/2160
INSERT INTO `guild_item_points` VALUES (8,4336,2,130,2160,3); -- Sweet Baked Apple: 195/7200 -> 130/2160
INSERT INTO `guild_item_points` VALUES (8,4560,2,251,2720,4); -- Vegetable Soup: 376/9360 -> 251/2720
INSERT INTO `guild_item_points` VALUES (8,4323,2,443,2720,4); -- Vegetable Broth: 664/9360 -> 443/2720
INSERT INTO `guild_item_points` VALUES (8,4376,2,30,1760,5); -- Meat Jerky: 45/5520 -> 30/1760
INSERT INTO `guild_item_points` VALUES (8,4518,2,42,1760,5); -- Sheep Jerky: 63/5520 -> 42/1760
INSERT INTO `guild_item_points` VALUES (8,4456,2,450,3360,6); -- Boiled Crab: 675/11760 -> 450/3360
INSERT INTO `guild_item_points` VALUES (8,4342,2,550,3360,6); -- Steamed Crab: 825/11760 -> 550/3360
INSERT INTO `guild_item_points` VALUES (8,4436,2,80,2000,7); -- Baked Popoto: 120/6720 -> 80/2000
INSERT INTO `guild_item_points` VALUES (8,4282,2,85,2000,7); -- Pipin' Hot Popoto: 127/2240 -> 85/2000

-- Cooking / Novice
INSERT INTO `guild_item_points` VALUES (8,4419,3,1000,4560,0); -- Mushroom Soup: 1500/15600 -> 1000/4560
INSERT INTO `guild_item_points` VALUES (8,4333,3,1160,4560,0); -- Witch Soup: 1740/15600 -> 1160/4560
INSERT INTO `guild_item_points` VALUES (8,4555,3,372,3280,1); -- Windurst Salad: 558/11280 -> 372/3280
INSERT INTO `guild_item_points` VALUES (8,4321,3,409,3280,1); -- Timbre Timbers Salad: 613/11280 -> 409/3280
INSERT INTO `guild_item_points` VALUES (8,4510,3,6,1920,2); -- Acorn Cookie: 9/5760 -> 6/1920
INSERT INTO `guild_item_points` VALUES (8,4577,3,7,1920,2); -- Wild Cookie: 10/5760 -> 7/1920
INSERT INTO `guild_item_points` VALUES (8,4499,3,25,2000,3); -- Iron Bread: 37/6240 -> 25/2000
INSERT INTO `guild_item_points` VALUES (8,4573,3,76,2000,3); -- Steel Bread: 114/6240 -> 76/2000
INSERT INTO `guild_item_points` VALUES (8,4459,3,300,3040,4); -- Nebimonite Bake: 450/10320 -> 300/3040
INSERT INTO `guild_item_points` VALUES (8,4267,3,450,3040,4); -- Buttered Nebimonite: 675/10320 -> 450/3040
INSERT INTO `guild_item_points` VALUES (8,4364,3,30,2000,5); -- Black Bread: 45/6240 -> 30/2000
INSERT INTO `guild_item_points` VALUES (8,4591,3,40,2000,5); -- Pumpernickel: 60/6240 -> 40/2000
INSERT INTO `guild_item_points` VALUES (8,5196,3,168,2560,6); -- Buffalo Jerky: 252/8640 -> 168/2560
INSERT INTO `guild_item_points` VALUES (8,5207,3,378,2560,6); -- Bison Jerky: 567/8640 -> 378/2560
INSERT INTO `guild_item_points` VALUES (8,4404,3,150,2560,7); -- Roast Trout: 225/8400 -> 150/2560
INSERT INTO `guild_item_points` VALUES (8,4587,3,165,2560,7); -- Broiled Trout: 247/8400 -> 165/2560

-- Cooking / Apprentice
INSERT INTO `guild_item_points` VALUES (8,4420,4,294,3200,0); -- Tomato Soup: 441/10800 -> 294/3200
INSERT INTO `guild_item_points` VALUES (8,4341,4,894,3200,0); -- Sunset Soup: 1341/10800 -> 894/3200
INSERT INTO `guild_item_points` VALUES (8,4413,4,80,2480,1); -- Apple Pie: 120/7680 -> 80/2480
INSERT INTO `guild_item_points` VALUES (8,4320,4,88,2480,1); -- Apple Pie +1: 132/7680 -> 88/2480
INSERT INTO `guild_item_points` VALUES (8,4413,4,80,2480,2); -- Apple Pie: 120/7680 -> 80/2480
INSERT INTO `guild_item_points` VALUES (8,4320,4,88,2480,2); -- Apple Pie +1: 132/7680 -> 88/2480
INSERT INTO `guild_item_points` VALUES (8,4398,4,180,2800,3); -- Fish Mithkabob: 270/9360 -> 180/2800
INSERT INTO `guild_item_points` VALUES (8,4575,4,204,2800,3); -- Fish Chiefkabob: 306/9360 -> 204/2800
INSERT INTO `guild_item_points` VALUES (8,4490,4,120,2560,4); -- Pickled Herring: 180/8400 -> 120/2560
INSERT INTO `guild_item_points` VALUES (8,5183,4,180,2560,4); -- Viking Herring: 270/8400 -> 180/2560
INSERT INTO `guild_item_points` VALUES (8,4490,4,120,2560,5); -- Pickled Herring: 180/8400 -> 120/2560
INSERT INTO `guild_item_points` VALUES (8,5183,4,180,2560,5); -- Viking Herring: 270/8400 -> 180/2560
INSERT INTO `guild_item_points` VALUES (8,4397,4,4,2160,6); -- Cinna-cookie: 6/6480 -> 4/2160
INSERT INTO `guild_item_points` VALUES (8,4520,4,5,2160,6); -- Coin Cookie: 7/6480 -> 5/2160
INSERT INTO `guild_item_points` VALUES (8,4420,4,294,3200,7); -- Goulash -> Tomato Soup (294/3200)
INSERT INTO `guild_item_points` VALUES (8,4341,4,894,3200,7); -- Goulash +1 -> Sunset Soup (894/3200)

-- Cooking / Journeyman
INSERT INTO `guild_item_points` VALUES (8,4572,5,165,2960,0); -- Beaugreen Saute: 247/9600 -> 165/2960
INSERT INTO `guild_item_points` VALUES (8,4293,5,577,2960,0); -- Monastic Saute: 865/9600 -> 577/2960
INSERT INTO `guild_item_points` VALUES (8,4563,5,256,3200,1); -- Pamama Tart: 384/10560 -> 256/3200
INSERT INTO `guild_item_points` VALUES (8,4287,5,612,3200,1); -- Opo-opo Tart: 918/10560 -> 612/3200
INSERT INTO `guild_item_points` VALUES (8,5168,5,123,2800,2); -- Bataquiche: 184/8880 -> 123/2800
INSERT INTO `guild_item_points` VALUES (8,5169,5,184,2800,2); -- Bataquiche +1: 276/8880 -> 184/2800
INSERT INTO `guild_item_points` VALUES (8,4417,5,300,3360,3); -- Egg Soup: 450/11040 -> 300/3360
INSERT INTO `guild_item_points` VALUES (8,4521,5,350,3360,3); -- Humpty Soup: 525/11040 -> 350/3360
INSERT INTO `guild_item_points` VALUES (8,5598,5,400,3600,4); -- Sis Kebabi: 600/12000 -> 400/3600
INSERT INTO `guild_item_points` VALUES (8,5599,5,500,3600,4); -- Sis Kebabi +1: 750/12000 -> 500/3600
INSERT INTO `guild_item_points` VALUES (8,4457,5,500,3840,5); -- Eel Kabob: 750/12960 -> 500/3840
INSERT INTO `guild_item_points` VALUES (8,4588,5,550,3840,5); -- Broiled Eel: 825/12960 -> 550/3840
INSERT INTO `guild_item_points` VALUES (8,5598,5,400,3600,6); -- Sis Kebabi: 600/12000 -> 400/3600
INSERT INTO `guild_item_points` VALUES (8,5599,5,500,3600,6); -- Sis Kebabi +1: 750/12000 -> 500/3600
INSERT INTO `guild_item_points` VALUES (8,4391,5,6,2320,7); -- Bretzel: 9/7200 -> 6/2320
INSERT INTO `guild_item_points` VALUES (8,5182,5,9,2320,7); -- Salty Bretzel: 13/7200 -> 9/2320

-- Cooking / Craftsman
INSERT INTO `guild_item_points` VALUES (8,4546,6,350,3600,0); -- Raisin Bread: 525/12000 -> 350/3600
INSERT INTO `guild_item_points` VALUES (8,4494,6,198,3200,1); -- Squid Sushi -> San d'Orian Tea (198/3200)
INSERT INTO `guild_item_points` VALUES (8,4524,6,240,3200,1); -- Squid Sushi +1 -> Royal Tea (240/3200)
INSERT INTO `guild_item_points` VALUES (8,5572,6,415,3760,2); -- Irmik Helvasi: 622/12480 -> 415/3760
INSERT INTO `guild_item_points` VALUES (8,5573,6,441,3760,2); -- Irmik Helvasi +1: 661/12480 -> 441/3760
INSERT INTO `guild_item_points` VALUES (8,4559,6,356,3600,3); -- Herb Quus: 534/12000 -> 356/3600
INSERT INTO `guild_item_points` VALUES (8,4294,6,586,3600,3); -- Medicinal Quus: 879/12000 -> 586/3600
INSERT INTO `guild_item_points` VALUES (8,4433,6,519,4000,4); -- Dhalmel Stew: 778/13440 -> 519/4000
INSERT INTO `guild_item_points` VALUES (8,4589,6,570,4000,4); -- Wild Stew: 855/13440 -> 570/4000
INSERT INTO `guild_item_points` VALUES (8,4487,6,104,2880,5); -- Colored Egg: 156/9120 -> 104/2880
INSERT INTO `guild_item_points` VALUES (8,4595,6,230,2880,5); -- Party Egg: 345/9120 -> 230/2880
INSERT INTO `guild_item_points` VALUES (8,4506,6,405,3760,6); -- Mutton Tortilla: 607/12480 -> 405/3760
INSERT INTO `guild_item_points` VALUES (8,4348,6,587,3760,6); -- Mutton Enchilada: 880/12480 -> 587/3760
INSERT INTO `guild_item_points` VALUES (8,5600,6,600,4160,7); -- Balik Sis: 900/13920 -> 600/4160
INSERT INTO `guild_item_points` VALUES (8,5601,6,650,4160,7); -- Balik Sis +1: 975/13920 -> 650/4160

-- Cooking / Artisan
INSERT INTO `guild_item_points` VALUES (8,4547,7,462,4000,0); -- Boiled Cockatrice: 693/13200 -> 462/4000
INSERT INTO `guild_item_points` VALUES (8,4552,7,425,3920,1); -- Herb Crawler Eggs: 637/12960 -> 425/3920
INSERT INTO `guild_item_points` VALUES (8,4583,7,255,3520,2); -- Salmon Meuniere: 382/11280 -> 255/3520
INSERT INTO `guild_item_points` VALUES (8,4347,7,510,3520,2); -- Salmon Meuniere +1: 382/11280 -> 510/3520
INSERT INTO `guild_item_points` VALUES (8,4439,7,175,3280,3); -- Whitefish Stew -> Navarin (175/3280)
INSERT INTO `guild_item_points` VALUES (8,4411,7,120,3120,4); -- Chocomilk -> Dhalmel Pie (120/3120)
INSERT INTO `guild_item_points` VALUES (8,4322,7,160,3120,4); -- Choco-delight -> Dhalmel Pie +1 (160/3120)
INSERT INTO `guild_item_points` VALUES (8,4507,7,320,3680,5); -- Rarab Meatball: 480/12000 -> 320/3680
INSERT INTO `guild_item_points` VALUES (8,4349,7,540,3680,5); -- Bunny Ball: 810/12000 -> 540/3680
INSERT INTO `guild_item_points` VALUES (8,4554,7,1404,5280,6); -- Shallops Tropicale: 2106/17520 -> 1404/5280
INSERT INTO `guild_item_points` VALUES (8,4418,7,1200,5040,7); -- Turtle Soup: 1800/16800 -> 1200/5040
INSERT INTO `guild_item_points` VALUES (8,4337,7,1400,5040,7); -- Stamina Soup: 2100/16800 -> 1400/5040
INSERT INTO `guild_item_points` VALUES (8,4284,7,525,3280,3); -- Tender Navarin - Artisan Pattern D

-- Cooking / Adept
INSERT INTO `guild_item_points` VALUES (8,4544,8,1120,5040,0); -- Karni Yarik -> Mushroom Stew (1120/5040)
INSERT INTO `guild_item_points` VALUES (8,4344,8,1680,5040,0); -- Karni Yarik +1 -> Witch Stew (1680/5040)
INSERT INTO `guild_item_points` VALUES (8,4561,8,1320,5280,1); -- Seafood Stew: 1980/17280 -> 1320/5280
INSERT INTO `guild_item_points` VALUES (8,4564,8,1836,5680,2); -- Pepperoni -> Royal Omelette (1836/5680)
INSERT INTO `guild_item_points` VALUES (8,4550,8,1472,5360,3); -- Bream Risotto: 2208/17760 -> 1472/5360
INSERT INTO `guild_item_points` VALUES (8,4268,8,1792,5360,3); -- Sea Spray Risotto: 2688/17760 -> 1792/5360
INSERT INTO `guild_item_points` VALUES (8,4582,8,305,3760,4); -- Bass Meuniere: 457/12240 -> 305/3760
INSERT INTO `guild_item_points` VALUES (8,4346,8,610,3760,4); -- Bass Meuniere +1: 915/12240 -> 610/3760
INSERT INTO `guild_item_points` VALUES (8,4557,8,522,4160,5); -- Steamed Catfish: 783/13920 -> 522/4160
INSERT INTO `guild_item_points` VALUES (8,4548,8,616,4320,6); -- Coeurl Saute: 924/14400 -> 616/4320
INSERT INTO `guild_item_points` VALUES (8,4295,8,966,4320,6); -- Royal Saute: 1449/4800 -> 966/4320
INSERT INTO `guild_item_points` VALUES (8,4452,8,1150,5040,7); -- Shark Fin Soup: 1725/16800 -> 1150/5040
INSERT INTO `guild_item_points` VALUES (8,4285,8,1400,5040,7); -- Ocean Soup: 2100/16800 -> 1400/5040
INSERT INTO `guild_item_points` VALUES (8,4331,8,2516,5680,2); -- Imperial Omelette - Adept Pattern C

-- Cooking / Veteran
INSERT INTO `guild_item_points` VALUES (8,4297,9,730,4640,0); -- Urchin Sushi -> Black Curry (730/4640)
-- Remove Urchin Sushi +1
INSERT INTO `guild_item_points` VALUES (8,4271,9,140,3440,1); -- Rice Dumpling: 210/10800 -> 140/3440
INSERT INTO `guild_item_points` VALUES (8,4279,9,4375,6720,2); -- Dorado Sushi -> Tavnazian Salad (4375/6720)
INSERT INTO `guild_item_points` VALUES (8,5185,9,6475,6720,2); -- Dorado Sushi +1 -> Leremieu Salad (6475/6720)
INSERT INTO `guild_item_points` VALUES (8,4353,9,1818,5680,3); -- Sea Bass Croute: 2727/18480 -> 1818/5680
INSERT INTO `guild_item_points` VALUES (8,4584,9,1597,5520,4); -- Flounder Meuniere: 2395/18000 -> 1597/5520
INSERT INTO `guild_item_points` VALUES (8,4345,9,2130,5520,4); -- Flounder Meuniere +1: 3195/18000 -> 2130/5520
INSERT INTO `guild_item_points` VALUES (8,4542,9,2220,5920,5); -- Brain Stew: 3330/19200 -> 2220/5920
INSERT INTO `guild_item_points` VALUES (8,5180,9,3330,5920,5); -- Sophic Stew: 4995/19200 -> 3330/5920
INSERT INTO `guild_item_points` VALUES (8,4270,9,98,3360,6); -- Sweet Rice Cake: 147/10320 -> 98/3360
INSERT INTO `guild_item_points` VALUES (8,4551,9,900,4800,7); -- Salmon Croute: 1350/16080 -> 900/4800
