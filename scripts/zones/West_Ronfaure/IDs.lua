-----------------------------------
-- Area: West_Ronfaure
-----------------------------------
zones = zones or {}

zones[xi.zone.WEST_RONFAURE] =
{
    text =
    {
        ITEM_CANNOT_BE_OBTAINED       = 20,   -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED                 = 23,   -- Obtained: <item>.
        GIL_OBTAINED                  = 24,   -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 26,   -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 27,   -- Lost key item: <keyitem>.
        FELLOW_MESSAGE_OFFSET         = 50,   -- I'm ready. I suppose.
        CONQUEST_BASE                 = 639,  -- Tallying conquest results...
        FISHING_MESSAGE_OFFSET        = 798,  -- You can't fish here.
        DIG_THROW_AWAY                = 811,  -- You dig up <item>, but your inventory is full. You regretfully throw the <item> away.
        FIND_NOTHING                  = 813,  -- You dig and you dig, but find nothing.
        RAMAUFONT_DIALOG              = 868,  -- Nothing to report.
        ORCISH_SCOUTS                 = 869,  -- Orcish scouts lurk in the shadows. Consider yourself warned!
        ADALEFONT_DIALOG              = 870,  -- If you sense danger, just flee into the city. I'll not endanger myself on your account!
        LAILLERA_DIALOG               = 871,  -- I mustn't chat while on duty. Sorry.
        PICKPOCKET_GACHEMAGE          = 872,  -- A pickpocket? Now that you mention it, I did see a woman flee the city. She ran west.
        PICKPOCKET_ADALEFONT          = 873,  -- What, someone picked your pocket? And you call yourself an adventurer!
        PICKPOCKET_COLMAIE            = 874,  -- A pickpocket? Hmm... Can't say I've seen anyone like that around here.
        PICKPOCKET_LAILLERA           = 875,  -- A pickpocket, you say? I don't think anybody came through here.
        AAVELEON_HEALED               = 877,  -- My wounds are healed, thanks to you!
        PICKPOCKET_AAVELEON           = 903,  -- A pickpocket, out here? Phew, my wallet is safe.
        PALCOMONDAU_REPORT            = 915,  -- Scout reporting! All is quiet on the road to Ghelsba!
        PALCOMONDAU_ENROUTE           = 916,  -- Let me be! I must patrol the road to Ghelsba.
        PALCOMONDAU_RETURN            = 917,  -- I bring word of Ghelsba to the Westgate. Out of my way!
        ZOVRIACE_REPORT               = 918,  -- Scout reporting! All is quiet on the roads to La Theine!
        ZOVRIACE_ENROUTE              = 919,  -- I must scour the roads to La Theine for signs of the enemy. Let me pass!
        ZOVRIACE_RETURN               = 920,  -- Let me be! I return to Southgate with word on La Theine.
        PICKPOCKET_PALCOMONDAU        = 921,  -- A pickpocket? No, I haven't seen anyone matching that description. I've only seen Aaveleon, and a rather brusque woman.
        PICKPOCKET_ZOVRIACE           = 922,  -- A pickpocket, out here? Can't say I've seen anyone like that. I'll keep my eyes peeled.
        DIADONOUR_DIALOG              = 923,  -- Our people often fall prey to roving Orcs nearby. Take care out there!
        LAETTE_DIALOG                 = 928,  -- This watchtower was built to strengthen Ranperre Gate. You can look around, but stay out of our way.
        CHATARRE_DIALOG               = 929,  -- Ghelsba and its Orcish camps lie at the foot of mountains yonder. We must be vigilant! They could attack at any time.
        DISMAYED_CUSTOMER             = 946,  -- You find some worthless scraps of paper.
        CONQUEST                      = 1068, -- You've earned conquest points!
        SOMETHING_IS_AMISS            = 1430, -- Something is amiss.
        GARRISON_BASE                 = 1460, -- Hm? What is this? %? How do I know this is not some [San d'Orian/Bastokan/Windurstian] trick?
        TIME_ELAPSED                  = 1587, -- Time elapsed: <number> [hour/hours] (Vana'diel time) <number> [minute/minutes] and <number> [second/seconds] (Earth time)
        PLAYER_OBTAINS_ITEM           = 1594, -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM         = 1595, -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM      = 1596, -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP          = 1597, -- You already possess that temporary item.
        NO_COMBINATION                = 1602, -- You were unable to enter a combination.
        REGIME_REGISTERED             = 2389, -- New training regime registered!
    },
    mob =
    {
        FUNGUS_BEETLE      = GetFirstID('Fungus_Beetle'),
        JAGGEDY_EARED_JACK = GetFirstID('Jaggedy-Eared_Jack'),
        MARAUDER_DVOGZOG   = GetFirstID('Marauder_Dvogzog'),
    },
    npc =
    {
        SIGNPOST_OFFSET = GetFirstID('Signpost'),
        OVERSEER_BASE   = GetFirstID('Doladepaiton_RK'),
    },
}

return zones[xi.zone.WEST_RONFAURE]
