-----------------------------------
-- Area: Southern_San_dOria
-----------------------------------
zones = zones or {}

zones[xi.zone.SOUTHERN_SAN_DORIA] =
{
    text =
    {
        HOMEPOINT_SET                  = 24,    -- Home point set!
        ITEM_CANNOT_BE_OBTAINED        = 42,    -- You cannot obtain the <item>. Come back after sorting your inventory.
        CANNOT_OBTAIN_THE_ITEM         = 43,    -- You cannot obtain the item. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE     = 44,    -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                  = 45,    -- Obtained: <item>.
        GIL_OBTAINED                   = 46,    -- Obtained <number> gil.
        KEYITEM_OBTAINED               = 48,    -- Obtained key item: <keyitem>.
        KEYITEM_LOST                   = 49,    -- Lost key item: <keyitem>.
        NOT_HAVE_ENOUGH_GIL            = 50,    -- You do not have enough gil.
        YOU_OBTAIN_ITEM                = 51,    -- You obtain % %!
        NOTHING_OUT_OF_ORDINARY        = 59,    -- There is nothing out of the ordinary here.
        MOG_LOCKER_OFFSET              = 212,   -- Your Mog Locker lease is valid until <timestamp>, kupo.
        IMAGE_SUPPORT                  = 248,  -- Your [fishing/woodworking/smithing/goldsmithing/clothcraft/leatherworking/bonecraft/alchemy/cooking] skills went up [a little/ever so slightly/ever so slightly].
        GUILD_TERMINATE_CONTRACT       = 261,  -- You have terminated your trading contract with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild and formed a new one with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild.
        GUILD_NEW_CONTRACT             = 269,  -- You have formed a new trading contract with the [Fishermen's/Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild.
        NO_MORE_GP_ELIGIBLE            = 276,   -- You cannot receive any more guild points by trading us that item.
        GP_OBTAINED                    = 281,  -- Obtained: <number> guild points.
        NOT_HAVE_ENOUGH_GP             = 282,  -- You do not have enough guild points.
        RENOUNCE_CRAFTSMAN             = 290,   -- Your craftsman status at the [Carpenters'/Blacksmiths'/Goldsmiths'/Weavers'/Tanners'/Boneworkers'/Alchemists'/Culinarians'] Guild has been revoked.
        CONQUEST_BASE                  = 402,  -- Tallying conquest results...
        YOU_ACCEPT_THE_MISSION         = 566,  -- You accept the mission.
        ORIGINAL_MISSION_OFFSET        = 577,  -- Bring me one of those axes, and your mission will be a success. No running away now; we've a proud country to defend!
        TRICK_OR_TREAT                 = 725,  -- Trick or treat...
        THANK_YOU_TREAT                = 726,  -- Thank you... And now for your treat...
        HERE_TAKE_THIS                 = 727,  -- Here, take this...
        IF_YOU_WEAR_THIS               = 728,  -- If you put this on and walk around, something...unexpected might happen...
        THANK_YOU                      = 729,  -- Thank you...
        NOKKHI_BAD_COUNT               = 742,  -- What kinda smart-alecky baloney is this!? I told you to bring me the same kinda ammunition in complete sets. And don't forget the flowers, neither.
        NOKKHI_GOOD_TRADE              = 744,  -- And here you go! Come back soon, and bring your friends!
        NOKKHI_BAD_ITEM                = 745,  -- I'm real sorry, but there's nothing I can do with those.
        EGG_HUNT_OFFSET                = 748,  -- Egg-cellent! Here's your prize, kupo! Now if only somebody would bring me a super combo... Oh, egg-scuse me! Forget I said that, kupo!
        YOU_CANNOT_ENTER_DYNAMIS       = 775,   -- You cannot enter any area of Dynamis for <number> [day/days] (Vana'diel time).
        PLAYERS_HAVE_NOT_REACHED_LEVEL = 777,  -- Players who have not reached level <number> are prohibited from entering Dynamis.
        DYNA_NPC_DEFAULT_MESSAGE       = 785,  -- There is an unusual arrangement of branches here.
        NOBODY_ONE_WANTS_TO_PLAY       = 1067,  -- Ah, nobody wants to play games of chance these days.
        VARCHET_BET_LOST               = 1082,  -- You lose your bet of 5 gil.
        VARCHET_KEEP_PROMISE           = 1091,  -- As promised, I shall go and see about those woodchippers. Maybe we can play another game later.
        ROSEL_GREETINGS                = 1092,  -- Greetings!
        FFR_ROSEL                      = 1111,  -- Hrmm... Now, this is interesting! It pays to keep an eye on the competition. Thanks for letting me know!
        EXOROCHE_START                 = 1127,  -- You've some business with me? Sorry, but I'm busy.
        EXOROCHE_PLEASE_TELL           = 1130,  -- Please tell my son that I'll join him as soon as I'm done, so he's to stay right there.
        GO_TO_KING_RANPERRES           = 1178,  -- Go to King Ranperre's Tomb and bring back <item>. How, you ask? Use your head. Now begone!
        TO_GET_TO_KING_RANPERRES       = 1197,  -- To get to King Ranperre's Tomb, head out the Eastgate into East Ronfaure, then make your way south as far as you can go. You should find it before long.
        YOU_FIND_A_WELL                = 1205,  -- You find a well.
        DONT_NEED_MORE_WATER           = 1207,  -- You don't need any more water.
        I_THANK_YOU_ADVENTURER         = 1209,  -- I thank you, kind adventurer. His Majesty, the late king, thanks you, too.
        TAUMILA_DIALOG                 = 1284,  -- I am Taumila, the owner of this establishment. Talk to the lady behind the counter if you wish to make a purchase.
        LUSIANE_SHOP_DIALOG            = 1285,  -- Hello! Let Taumila's handle all your sundry needs!
        OSTALIE_SHOP_DIALOG            = 1286,  -- Welcome, customer. Please have a look.
        HELBORT_DIALOG                 = 1288,  -- Welcome, welcome! Either of my attendants will be happy to help you!
        HELBORT_ORDERS                 = 1300,  -- It's an urgent order, so go as soon as you can. Remember, give the order to the free trader Alexius in Jugner Forest.
        ASH_THADI_ENE_SHOP_DIALOG      = 1307,  -- Welcome to Helbort's Blades!
        EXOROCHE_DIALOG_OFFSET         = 1309,  -- Oh, the gleam! Such brilliance! Blades wrought by the master here are indeed a cut above. I must have one...
        NOTHING_TO_REPORT              = 1325,  -- Nothing to report!
        TRIAL_IS_DIFFICULT             = 1327,  -- The trial is difficult, but those who pass may become true knights. Good luck to you.
        MAKE_EXCELLENT_KNIGHT          = 1328,  -- I heard you did well. I am sure you'll make an excellent knight.
        DO_NOT_FRET                    = 1330,  -- You may not know what to do, but do not fret. You have all the time you need.
        YOUVE_DONE_WELL                = 1331,  -- You've done well. I knew you would from the moment I saw you.
        UNLOCK_PALADIN                 = 1334,  -- You can now become a paladin!
        AMAURA_DIALOG_COMEBACK         = 1341,  -- Come back when ye've got it all. I'll make a draught to cure the wickedest of colds, I will.
        AMAURA_DIALOG_DELIVER          = 1344,  -- Take that medicine over quick as you can now, dearie. Wouldn't want it to go bad.
        FFR_BLENDARE                   = 1418,  -- Wait! If I had magic, maybe I could keep my brother's hands off my sweets...
        RAMINEL_DELIVERY               = 1422,  -- Here's your delivery!
        RAMINEL_DELIVERIES             = 1424,  -- Sorry, I have deliveries to make!
        SHILAH_SHOP_DIALOG             = 1439,  -- Welcome, weary traveler. Make yourself at home!
        VALERIANO_SHOP_DIALOG          = 1457,  -- Oh, a fellow outsider! We are Troupe Valeriano. I am Valeriano, at your service!
        DAHJAL_NOT_BASTOK_CIT          = 1458,  -- Watch this.
        DAHJAL_BASTOK_CIT              = 1459,  -- I worry for Bastok... Our Hume leaders rely too much on technology.
        MOKOP_NOT_SANDY_CIT            = 1460,  -- To be honest, I'm not fond of San d'Orians. Tall and snooty but misers through and through! May their conquests fall flat!
        MOKOP_SANDY_CIT                = 1461,  -- What a huge city-witty! San d'Oria towers above the other nations! How can they possibly competaru?
        CHEH_WINDY_CIT                 = 1462,  -- The food arrround here's not bad, but our Windurstian chefs could do better. If they could only get hold of the same ingrrredients!
        CHEH_NOT_WINDY_CIT             = 1463,  -- Nobody tops my trrricks. Stand back if you value your ears and moustaches!
        NALTA_SANDY_CIT                = 1464,  -- San d'Oria owes its victories to the Elvaan.
        NALTA_NOT_SANDY_CIT            = 1465,  -- Shhh.
        FERDOULEMIONT_SHOP_DIALOG      = 1738,  -- Hello!
        WEST_GATE                      = 1492,  -- You stand before the Westgate. West Ronfaure lies beyond.
        CLETAE_DIALOG                  = 1525,  -- Why, hello. All our skins are guild-approved.
        KUEH_IGUNAHMORI_DIALOG         = 1526,  -- Good day! We have lots in stock today.
        SOBANE_DIALOG                  = 1544,  -- My name is Sobane, and I'm sharpening my knives.
        PAUNELIE_DIALOG                = 1634,  -- I'm sorry, can I help you?
        ITEM_DELIVERY_DIALOG           = 1734,  -- Parcels delivered to rooms anywhere in Vana'diel!
        PAUNELIE_SHOP_DIALOG           = 1737,  -- Like %?
        MACHIELLE_OPEN_DIALOG          = 1740,  -- Might I interest you in produce from Norvallen?
        CORUA_OPEN_DIALOG              = 1741,  -- Ronfaure produce for sale!
        PHAMELISE_OPEN_DIALOG          = 1742,  -- I've got fresh produce from Zulkheim!
        APAIREMANT_OPEN_DIALOG         = 1743,  -- Might you be interested in produce from Gustaberg?
        RAIMBROYS_SHOP_DIALOG          = 1744,  -- Welcome to Raimbroy's Grocery!
        CARAUTIA_SHOP_DIALOG           = 1746,  -- Well, what sort of armor would you like?
        MACHIELLE_CLOSED_DIALOG        = 1747,  -- We want to sell produce from Norvallen, but the entire region is under foreign control!
        CORUA_CLOSED_DIALOG            = 1748,  -- We specialize in Ronfaure produce, but we cannot import from that region without a strong San d'Orian presence there.
        PHAMELISE_CLOSED_DIALOG        = 1749,  -- I'd be making a killing selling produce from Zulkheim, but the region's under foreign control!
        APAIREMANT_CLOSED_DIALOG       = 1750,  -- I'd love to import produce from Gustaberg, but the foreign powers in control there make me feel unsafe!
        POURETTE_OPEN_DIALOG           = 1751,  -- Derfland produce for sale!
        POURETTE_CLOSED_DIALOG         = 1752,  -- Listen, adventurer... I can't import from Derfland until the region knows San d'Orian power!
        CONQUEST                       = 1809,  -- You've earned conquest points!
        FLYER_ACCEPTED                 = 2146,  -- The flyer is accepted.
        FLYER_ALREADY                  = 2147,  -- This person already has a flyer.
        FFR_LOOKS_CURIOUSLY_BASE       = 2148,  -- Blendare looks over curiously for a moment.
        FFR_MAUGIE                     = 2150,  -- A magic shop, eh? Hmm... A little magic could go a long way for making a leisurely retirement! Ho ho ho!
        FFR_ADAUNEL                    = 2152,  -- A magic shop? Maybe I'll check it out one of these days. Could help with my work, even...
        FFR_LEUVERET                   = 2154,  -- A magic shop? That'd be a fine place to peddle my wares. I smell a profit! I'll be up to my gills in gil, I will!
        LUSIANE_THANK                  = 2197,  -- Thank you! My snoring will express gratitude mere words cannot! Here's something for you in return.
        IMPULSE_DRIVE_LEARNED          = 2628,  -- You have learned the weapon skill "Impulse Drive"!
        CLOUD_BAD_COUNT                = 3416, -- Well, don't just stand there like an idiot! I can't do any bundlin' until you fork over a set of 99 tools and <item>! And I ain't doin' no more than seven sets at one time, so don't even try it!
        CLOUD_GOOD_TRADE               = 3420, -- Here, take 'em and scram. And don't say I ain't never did nothin' for you!
        CLOUD_BAD_ITEM                 = 3421, -- What the hell is this junk!? Why don't you try bringin' what I asked for before I shove one of my sandals up your...nose!
        CAPUCINE_SHOP_DIALOG           = 3616, -- Hello! You seem to be working very hard. I'm really thankful! But you needn't rush around so fast. Take your time! I can wait if it makes the job easier for you!
        CHOCOBO_FEEDING_SLEEP          = 4011, -- Your chocobo is sleeping soundly. You cannot feed it now.
        CHOCOBO_FEEDING_RUN_AWAY       = 4012, -- Your chocobo has run away. You cannot feed it now.
        CHOCOBO_FEEDING_STILL_EGG      = 4013, -- You cannot feed a chocobo that has not hatched yet.
        CHOCOBO_FEEDING_ITEM           = 5096, -- #: %
        TUTORIAL_NPC                   = 6796, -- Greetings and well met! Guardian of the Kingdom, Alaune, at your most humble service.
    },
    mob =
    {
    },
    npc =
    {
        HALLOWEEN_SKINS =
        {
            [17719303] = 47, -- Machielle
            [17719304] = 50, -- Corua
            [17719305] = 48, -- Phamelise
            [17719306] = 46, -- Apairemant
            [17719481] = 49, -- Pourette
        },
        ARPETION  = GetFirstID('Arpetion'),
        CAMEREINE = GetFirstID('Camereine'),
        EMOUSSINE = GetFirstID('Emoussine'),
        LUSIANE   = GetFirstID('Lusiane'),
        MEUNEILLE = GetFirstID('Meuneille'),
    },
}

return zones[xi.zone.SOUTHERN_SAN_DORIA]
