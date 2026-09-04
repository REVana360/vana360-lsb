-----------------------------------
-- Area: East_Ronfaure
-----------------------------------
zones = zones or {}

zones[xi.zone.EAST_RONFAURE] =
{
    text =
    {
        HOMEPOINT_SET            = 2,    -- Home point set!
        ITEM_CANNOT_BE_OBTAINED  = 20,   -- You cannot obtain the <item>. Come back after sorting your inventory.
        ITEM_OBTAINED            = 23,   -- Obtained: <item>.
        GIL_OBTAINED             = 24,   -- Obtained <number> gil.
        KEYITEM_OBTAINED         = 26,   -- Obtained key item: <keyitem>.
        NOTHING_OUT_OF_ORDINARY  = 37,   -- There is nothing out of the ordinary here.
        FELLOW_MESSAGE_OFFSET    = 50,   -- I'm ready. I suppose.
        CONQUEST_BASE            = 639,  -- Tallying conquest results...
        FISHING_MESSAGE_OFFSET   = 798,  -- You can't fish here.
        DIG_THROW_AWAY           = 811,  -- You dig up <item>, but your inventory is full. You regretfully throw the <item> away.
        FIND_NOTHING             = 813,  -- You dig and you dig, but find nothing.
        NOTHING_HAPPENS          = 868,  -- Nothing happens...
        RAYOCHINDOT_DIALOG       = 942,  -- If you are outmatched, run to the city as quickly as you can.
        CROTEILLARD_DIALOG       = 943,  -- Sorry, no chatting while I'm on duty.
        ANDELAIN_DIALOG          = 944,  -- My name is Andelain. As part of my devotions, I come here each day to pray.
        MAY_ONLY_EAT             = 945,  -- During this time, I may eat only three <item> a day for nourishment. No more, no less. And no other food may I eat.
        THANKS_TO_GODDESS        = 946,  -- Thanks be to the Goddess in her benevolence!
        CANNOT_ACCEPT_ALMS       = 947,  -- I am currently undergoing devotions, and as such, am not allowed to take alms from those on the road. I am sorry, but I cannot accept this.
        GATES_OF_PARADISE_OPEN   = 948,  -- May the Gates of Paradise open to all...
        APPRECIATE_OFFER_DECLINE = 949,  -- I appreciate your offer, but I only need one <item>. Thank you for your kindness.
        THE_WATER_SPARKLES       = 967,  -- The water sparkles in the light.
        CHEVAL_RIVER_WATER       = 968,  -- You fill your waterskin with water from the river. You now have <item>.
        BLESSED_WATERSKIN        = 987,  -- To get water, "trade" the waterskin you hold with the river.
        LOGGING_IS_POSSIBLE_HERE = 1018, -- Logging is possible here if you have <item>.
        PLAYER_OBTAINS_ITEM      = 1029, -- <name> obtains <item>!
        UNABLE_TO_OBTAIN_ITEM    = 1030, -- You were unable to obtain the item.
        PLAYER_OBTAINS_TEMP_ITEM = 1031, -- <name> obtains the temporary item: <item>!
        ALREADY_POSSESS_TEMP     = 1032, -- You already possess that temporary item.
        NO_COMBINATION           = 1037, -- You were unable to enter a combination.
        REGIME_REGISTERED        = 1812, -- New training regime registered!
        NOT_ENOUGH_TABS          = 2076, -- You do not have enough tabs.
        YOU_RECOVERED_MOG_TABLET = 2087, -- You've recovered one of the long-lost mog tablets! You should share the news of your discovery with the Explorer Moogle in Ru'Lude Gardens.
    },

    mob =
    {
        BIGMOUTH_BILLY = GetFirstID('Bigmouth_Billy'),
        SWAMFISK       = GetTableOfIDs('Swamfisk'), -- 2 NMs
    },

    npc =
    {
        LOGGING = GetTableOfIDs('Logging_Point'),
    },
}

return zones[xi.zone.EAST_RONFAURE]
