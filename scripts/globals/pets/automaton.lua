-----------------------------------
-- PET: Automaton
-- July 2009-era automaton behavior restored from official-era references.
-- TODO: Add Support for +Automaton Level
-- TODO: Add Support for MLvl
-- Retail captures show that +Automaton levels do not raise STR/DEX/VIT/AGI/INT/MND/CHR, but do raise HP/MP. This is currently not supported.
-----------------------------------
xi = xi or {}
xi.pets = xi.pets or {}
xi.pets.automaton = {}

-- Pre-2015 frame HP values. Source: https://wiki.ffo.jp/html/33858.html
xi.pets.automaton.frameStats =
{
    [xi.automaton.frame.HARLEQUIN] =
    {
        [ 1] = { maxHP =   36, maxMP =   10, STR =   8, DEX =   7, VIT =   8, AGI =   7, INT =   7, MND =   8, CHR =   8 },
        [ 2] = { maxHP =   52, maxMP =   12, STR =   8, DEX =   7, VIT =   8, AGI =   7, INT =   7, MND =   8, CHR =   8 },
        [ 3] = { maxHP =   69, maxMP =   16, STR =   9, DEX =   8, VIT =   9, AGI =   8, INT =   8, MND =   9, CHR =   9 },
        [ 4] = { maxHP =   85, maxMP =   18, STR =  11, DEX =  10, VIT =  10, AGI =   9, INT =   9, MND =  10, CHR =  11 },
        [ 5] = { maxHP =  101, maxMP =   22, STR =  11, DEX =  10, VIT =  11, AGI =  10, INT =   9, MND =  10, CHR =  11 },
        [ 6] = { maxHP =  117, maxMP =   24, STR =  12, DEX =  11, VIT =  12, AGI =  11, INT =  10, MND =  12, CHR =  12 },
        [ 7] = { maxHP =  133, maxMP =   28, STR =  14, DEX =  12, VIT =  13, AGI =  12, INT =  11, MND =  12, CHR =  13 },
        [ 8] = { maxHP =  150, maxMP =   30, STR =  14, DEX =  12, VIT =  14, AGI =  12, INT =  11, MND =  13, CHR =  14 },
        [ 9] = { maxHP =  166, maxMP =   34, STR =  15, DEX =  13, VIT =  15, AGI =  13, INT =  13, MND =  14, CHR =  15 },
        [10] = { maxHP =  182, maxMP =   36, STR =  17, DEX =  15, VIT =  16, AGI =  14, INT =  13, MND =  15, CHR =  16 },
        [11] = { maxHP =  200, maxMP =   40, STR =  18, DEX =  16, VIT =  17, AGI =  16, INT =  15, MND =  16, CHR =  17 },
        [12] = { maxHP =  219, maxMP =   42, STR =  18, DEX =  16, VIT =  17, AGI =  16, INT =  15, MND =  16, CHR =  17 },
        [13] = { maxHP =  238, maxMP =   46, STR =  19, DEX =  17, VIT =  18, AGI =  17, INT =  16, MND =  17, CHR =  19 },
        [14] = { maxHP =  257, maxMP =   48, STR =  20, DEX =  18, VIT =  19, AGI =  18, INT =  17, MND =  18, CHR =  20 },
        [15] = { maxHP =  275, maxMP =   52, STR =  21, DEX =  18, VIT =  20, AGI =  18, INT =  17, MND =  19, CHR =  20 },
        [16] = { maxHP =  294, maxMP =   54, STR =  22, DEX =  20, VIT =  21, AGI =  19, INT =  18, MND =  20, CHR =  22 },
        [17] = { maxHP =  313, maxMP =   58, STR =  23, DEX =  21, VIT =  22, AGI =  20, INT =  19, MND =  21, CHR =  22 },
        [18] = { maxHP =  332, maxMP =   60, STR =  24, DEX =  21, VIT =  23, AGI =  21, INT =  19, MND =  21, CHR =  23 },
        [19] = { maxHP =  350, maxMP =   64, STR =  25, DEX =  22, VIT =  24, AGI =  22, INT =  21, MND =  22, CHR =  24 },
        [20] = { maxHP =  369, maxMP =   66, STR =  26, DEX =  23, VIT =  25, AGI =  23, INT =  21, MND =  23, CHR =  25 },
        [21] = { maxHP =  387, maxMP =   70, STR =  28, DEX =  25, VIT =  26, AGI =  24, INT =  23, MND =  25, CHR =  27 },
        [22] = { maxHP =  406, maxMP =   72, STR =  28, DEX =  25, VIT =  26, AGI =  24, INT =  23, MND =  25, CHR =  27 },
        [23] = { maxHP =  425, maxMP =   76, STR =  29, DEX =  26, VIT =  27, AGI =  25, INT =  24, MND =  26, CHR =  28 },
        [24] = { maxHP =  444, maxMP =   78, STR =  30, DEX =  27, VIT =  28, AGI =  26, INT =  25, MND =  27, CHR =  29 },
        [25] = { maxHP =  462, maxMP =   82, STR =  31, DEX =  27, VIT =  29, AGI =  27, INT =  25, MND =  27, CHR =  30 },
        [26] = { maxHP =  481, maxMP =   84, STR =  32, DEX =  28, VIT =  30, AGI =  28, INT =  26, MND =  29, CHR =  31 },
        [27] = { maxHP =  499, maxMP =   88, STR =  33, DEX =  30, VIT =  31, AGI =  29, INT =  27, MND =  29, CHR =  32 },
        [28] = { maxHP =  518, maxMP =   90, STR =  34, DEX =  30, VIT =  32, AGI =  29, INT =  27, MND =  30, CHR =  32 },
        [29] = { maxHP =  537, maxMP =   94, STR =  35, DEX =  31, VIT =  33, AGI =  30, INT =  29, MND =  31, CHR =  33 },
        [30] = { maxHP =  556, maxMP =   96, STR =  36, DEX =  32, VIT =  34, AGI =  31, INT =  29, MND =  32, CHR =  35 },
        [31] = { maxHP =  575, maxMP =  100, STR =  37, DEX =  33, VIT =  35, AGI =  33, INT =  31, MND =  33, CHR =  36 },
        [32] = { maxHP =  595, maxMP =  102, STR =  37, DEX =  33, VIT =  35, AGI =  33, INT =  31, MND =  33, CHR =  36 },
        [33] = { maxHP =  614, maxMP =  106, STR =  39, DEX =  35, VIT =  36, AGI =  34, INT =  32, MND =  34, CHR =  37 },
        [34] = { maxHP =  633, maxMP =  108, STR =  40, DEX =  36, VIT =  37, AGI =  35, INT =  33, MND =  35, CHR =  38 },
        [35] = { maxHP =  652, maxMP =  112, STR =  40, DEX =  36, VIT =  38, AGI =  35, INT =  33, MND =  36, CHR =  39 },
        [36] = { maxHP =  672, maxMP =  114, STR =  42, DEX =  37, VIT =  39, AGI =  36, INT =  34, MND =  37, CHR =  40 },
        [37] = { maxHP =  691, maxMP =  118, STR =  43, DEX =  38, VIT =  40, AGI =  37, INT =  35, MND =  38, CHR =  41 },
        [38] = { maxHP =  711, maxMP =  120, STR =  43, DEX =  38, VIT =  41, AGI =  38, INT =  35, MND =  38, CHR =  41 },
        [39] = { maxHP =  730, maxMP =  124, STR =  45, DEX =  40, VIT =  42, AGI =  39, INT =  37, MND =  39, CHR =  43 },
        [40] = { maxHP =  750, maxMP =  126, STR =  46, DEX =  41, VIT =  43, AGI =  40, INT =  37, MND =  40, CHR =  44 },
        [41] = { maxHP =  769, maxMP =  130, STR =  47, DEX =  42, VIT =  44, AGI =  41, INT =  39, MND =  42, CHR =  45 },
        [42] = { maxHP =  788, maxMP =  132, STR =  47, DEX =  42, VIT =  44, AGI =  41, INT =  39, MND =  42, CHR =  45 },
        [43] = { maxHP =  807, maxMP =  136, STR =  48, DEX =  43, VIT =  45, AGI =  42, INT =  40, MND =  43, CHR =  46 },
        [44] = { maxHP =  827, maxMP =  138, STR =  50, DEX =  45, VIT =  46, AGI =  43, INT =  41, MND =  44, CHR =  48 },
        [45] = { maxHP =  846, maxMP =  142, STR =  50, DEX =  45, VIT =  47, AGI =  44, INT =  41, MND =  44, CHR =  48 },
        [46] = { maxHP =  866, maxMP =  144, STR =  52, DEX =  46, VIT =  48, AGI =  45, INT =  42, MND =  45, CHR =  49 },
        [47] = { maxHP =  885, maxMP =  148, STR =  53, DEX =  47, VIT =  49, AGI =  46, INT =  43, MND =  46, CHR =  50 },
        [48] = { maxHP =  905, maxMP =  150, STR =  53, DEX =  47, VIT =  50, AGI =  46, INT =  43, MND =  47, CHR =  51 },
        [49] = { maxHP =  924, maxMP =  154, STR =  54, DEX =  48, VIT =  51, AGI =  47, INT =  45, MND =  48, CHR =  52 },
        [50] = { maxHP =  943, maxMP =  156, STR =  56, DEX =  50, VIT =  52, AGI =  48, INT =  45, MND =  49, CHR =  53 },
        [51] = { maxHP =  965, maxMP =  160, STR =  57, DEX =  51, VIT =  53, AGI =  50, INT =  47, MND =  50, CHR =  54 },
        [52] = { maxHP =  987, maxMP =  162, STR =  57, DEX =  51, VIT =  53, AGI =  50, INT =  47, MND =  50, CHR =  54 },
        [53] = { maxHP = 1009, maxMP =  166, STR =  58, DEX =  52, VIT =  54, AGI =  51, INT =  48, MND =  51, CHR =  56 },
        [54] = { maxHP = 1031, maxMP =  168, STR =  59, DEX =  53, VIT =  55, AGI =  52, INT =  49, MND =  52, CHR =  57 },
        [55] = { maxHP = 1053, maxMP =  172, STR =  60, DEX =  53, VIT =  56, AGI =  52, INT =  49, MND =  53, CHR =  57 },
        [56] = { maxHP = 1075, maxMP =  174, STR =  61, DEX =  55, VIT =  57, AGI =  53, INT =  50, MND =  54, CHR =  59 },
        [57] = { maxHP = 1096, maxMP =  178, STR =  62, DEX =  56, VIT =  58, AGI =  54, INT =  51, MND =  55, CHR =  59 },
        [58] = { maxHP = 1118, maxMP =  180, STR =  63, DEX =  56, VIT =  59, AGI =  55, INT =  51, MND =  55, CHR =  60 },
        [59] = { maxHP = 1140, maxMP =  184, STR =  64, DEX =  57, VIT =  60, AGI =  56, INT =  53, MND =  56, CHR =  61 },
        [60] = { maxHP = 1162, maxMP =  186, STR =  65, DEX =  58, VIT =  61, AGI =  57, INT =  53, MND =  57, CHR =  62 },
        [61] = { maxHP = 1172, maxMP =  190, STR =  65, DEX =  58, VIT =  61, AGI =  57, INT =  53, MND =  57, CHR =  62 },
        [62] = { maxHP = 1182, maxMP =  194, STR =  66, DEX =  60, VIT =  62, AGI =  58, INT =  55, MND =  59, CHR =  64 },
        [63] = { maxHP = 1192, maxMP =  198, STR =  67, DEX =  61, VIT =  63, AGI =  59, INT =  56, MND =  60, CHR =  64 },
        [64] = { maxHP = 1202, maxMP =  202, STR =  67, DEX =  61, VIT =  63, AGI =  59, INT =  56, MND =  60, CHR =  65 },
        [65] = { maxHP = 1211, maxMP =  206, STR =  69, DEX =  62, VIT =  64, AGI =  61, INT =  57, MND =  61, CHR =  66 },
        [66] = { maxHP = 1221, maxMP =  210, STR =  69, DEX =  63, VIT =  65, AGI =  62, INT =  58, MND =  62, CHR =  67 },
        [67] = { maxHP = 1231, maxMP =  214, STR =  69, DEX =  63, VIT =  65, AGI =  62, INT =  59, MND =  62, CHR =  67 },
        [68] = { maxHP = 1241, maxMP =  218, STR =  71, DEX =  65, VIT =  67, AGI =  63, INT =  60, MND =  63, CHR =  68 },
        [69] = { maxHP = 1251, maxMP =  222, STR =  71, DEX =  66, VIT =  67, AGI =  64, INT =  61, MND =  64, CHR =  69 },
        [70] = { maxHP = 1261, maxMP =  226, STR =  73, DEX =  67, VIT =  69, AGI =  66, INT =  62, MND =  66, CHR =  70 },
        [71] = { maxHP = 1271, maxMP =  230, STR =  73, DEX =  67, VIT =  69, AGI =  66, INT =  62, MND =  66, CHR =  70 },
        [72] = { maxHP = 1280, maxMP =  234, STR =  73, DEX =  68, VIT =  70, AGI =  67, INT =  63, MND =  67, CHR =  71 },
        [73] = { maxHP = 1290, maxMP =  238, STR =  75, DEX =  70, VIT =  71, AGI =  68, INT =  65, MND =  68, CHR =  73 },
        [74] = { maxHP = 1300, maxMP =  242, STR =  75, DEX =  70, VIT =  71, AGI =  68, INT =  65, MND =  68, CHR =  73 },
        [75] = { maxHP = 1310, maxMP =  246, STR =  76, DEX =  71, VIT =  72, AGI =  69, INT =  66, MND =  69, CHR =  74 },
        [76] = { maxHP = 1320, maxMP =  250, STR =  76, DEX =  71, VIT =  72, AGI =  69, INT =  66, MND =  69, CHR =  74 },
        [77] = { maxHP = 1331, maxMP =  254, STR =  77, DEX =  72, VIT =  74, AGI =  71, INT =  68, MND =  71, CHR =  75 },
        [78] = { maxHP = 1340, maxMP =  258, STR =  78, DEX =  73, VIT =  75, AGI =  72, INT =  69, MND =  72, CHR =  76 },
        [79] = { maxHP = 1351, maxMP =  262, STR =  80, DEX =  75, VIT =  76, AGI =  73, INT =  70, MND =  73, CHR =  78 },
        [80] = { maxHP = 1361, maxMP =  266, STR =  80, DEX =  75, VIT =  76, AGI =  73, INT =  70, MND =  73, CHR =  78 },
        [81] = { maxHP = 1371, maxMP =  270, STR =  81, DEX =  76, VIT =  77, AGI =  74, INT =  71, MND =  74, CHR =  79 },
        [82] = { maxHP = 1381, maxMP =  274, STR =  82, DEX =  77, VIT =  79, AGI =  76, INT =  73, MND =  76, CHR =  80 },
        [83] = { maxHP = 1391, maxMP =  278, STR =  83, DEX =  78, VIT =  80, AGI =  77, INT =  74, MND =  77, CHR =  81 },
        [84] = { maxHP = 1402, maxMP =  282, STR =  85, DEX =  80, VIT =  81, AGI =  78, INT =  75, MND =  78, CHR =  83 },
        [85] = { maxHP = 1412, maxMP =  286, STR =  85, DEX =  80, VIT =  81, AGI =  78, INT =  75, MND =  78, CHR =  83 },
        [86] = { maxHP = 1421, maxMP =  290, STR =  86, DEX =  81, VIT =  82, AGI =  79, INT =  76, MND =  79, CHR =  84 },
        [87] = { maxHP = 1432, maxMP =  294, STR =  87, DEX =  82, VIT =  84, AGI =  81, INT =  78, MND =  81, CHR =  85 },
        [88] = { maxHP = 1442, maxMP =  300, STR =  88, DEX =  83, VIT =  85, AGI =  82, INT =  79, MND =  82, CHR =  86 },
        [89] = { maxHP = 1453, maxMP =  304, STR =  88, DEX =  83, VIT =  85, AGI =  82, INT =  79, MND =  82, CHR =  86 },
        [90] = { maxHP = 1462, maxMP =  308, STR =  90, DEX =  85, VIT =  86, AGI =  83, INT =  80, MND =  83, CHR =  88 },
        [91] = { maxHP = 1472, maxMP =  312, STR =  91, DEX =  86, VIT =  87, AGI =  84, INT =  81, MND =  84, CHR =  89 },
        [92] = { maxHP = 1483, maxMP =  316, STR =  92, DEX =  87, VIT =  89, AGI =  86, INT =  83, MND =  86, CHR =  90 },
        [93] = { maxHP = 1493, maxMP =  320, STR =  93, DEX =  88, VIT =  90, AGI =  87, INT =  84, MND =  87, CHR =  91 },
        [94] = { maxHP = 1503, maxMP =  324, STR =  93, DEX =  88, VIT =  90, AGI =  87, INT =  84, MND =  87, CHR =  91 },
        [95] = { maxHP = 1513, maxMP =  328, STR =  95, DEX =  90, VIT =  91, AGI =  88, INT =  85, MND =  88, CHR =  93 },
        [96] = { maxHP = 1523, maxMP =  332, STR =  96, DEX =  91, VIT =  92, AGI =  89, INT =  86, MND =  89, CHR =  94 },
        [97] = { maxHP = 1534, maxMP =  336, STR =  97, DEX =  92, VIT =  94, AGI =  91, INT =  88, MND =  91, CHR =  95 },
        [98] = { maxHP = 1543, maxMP =  340, STR =  97, DEX =  92, VIT =  94, AGI =  91, INT =  88, MND =  91, CHR =  95 },
        [99] = { maxHP = 1554, maxMP =  344, STR =  98, DEX =  93, VIT =  95, AGI =  92, INT =  89, MND =  92, CHR =  96 },
    },

    [xi.automaton.frame.VALOREDGE] =
    {
        [ 1] = { maxHP =   45, maxMP =    0, STR =   8, DEX =   7, VIT =   9, AGI =   6, INT =   6, MND =   8, CHR =   8 },
        [ 2] = { maxHP =   66, maxMP =    0, STR =   9, DEX =   8, VIT =  10, AGI =   7, INT =   7, MND =   9, CHR =   9 },
        [ 3] = { maxHP =   86, maxMP =    0, STR =  10, DEX =   9, VIT =  11, AGI =   8, INT =   7, MND =  10, CHR =  10 },
        [ 4] = { maxHP =  107, maxMP =    0, STR =  11, DEX =  10, VIT =  12, AGI =   8, INT =   8, MND =  10, CHR =  11 },
        [ 5] = { maxHP =  127, maxMP =    0, STR =  12, DEX =  11, VIT =  13, AGI =   9, INT =   8, MND =  11, CHR =  12 },
        [ 6] = { maxHP =  148, maxMP =    0, STR =  14, DEX =  11, VIT =  14, AGI =  10, INT =   9, MND =  12, CHR =  12 },
        [ 7] = { maxHP =  167, maxMP =    0, STR =  15, DEX =  12, VIT =  15, AGI =  11, INT =   9, MND =  13, CHR =  13 },
        [ 8] = { maxHP =  188, maxMP =    0, STR =  16, DEX =  13, VIT =  16, AGI =  11, INT =  10, MND =  13, CHR =  14 },
        [ 9] = { maxHP =  208, maxMP =    0, STR =  17, DEX =  14, VIT =  17, AGI =  12, INT =  10, MND =  14, CHR =  15 },
        [10] = { maxHP =  229, maxMP =    0, STR =  18, DEX =  15, VIT =  18, AGI =  13, INT =  11, MND =  15, CHR =  16 },
        [11] = { maxHP =  253, maxMP =    0, STR =  20, DEX =  16, VIT =  19, AGI =  14, INT =  12, MND =  16, CHR =  17 },
        [12] = { maxHP =  276, maxMP =    0, STR =  20, DEX =  16, VIT =  20, AGI =  14, INT =  12, MND =  16, CHR =  17 },
        [13] = { maxHP =  300, maxMP =    0, STR =  21, DEX =  17, VIT =  21, AGI =  15, INT =  13, MND =  18, CHR =  18 },
        [14] = { maxHP =  324, maxMP =    0, STR =  22, DEX =  18, VIT =  22, AGI =  16, INT =  14, MND =  19, CHR =  19 },
        [15] = { maxHP =  347, maxMP =    0, STR =  23, DEX =  19, VIT =  23, AGI =  16, INT =  14, MND =  19, CHR =  20 },
        [16] = { maxHP =  370, maxMP =    0, STR =  24, DEX =  20, VIT =  24, AGI =  18, INT =  15, MND =  20, CHR =  21 },
        [17] = { maxHP =  395, maxMP =    0, STR =  26, DEX =  21, VIT =  25, AGI =  18, INT =  16, MND =  21, CHR =  22 },
        [18] = { maxHP =  418, maxMP =    0, STR =  26, DEX =  21, VIT =  26, AGI =  18, INT =  16, MND =  22, CHR =  23 },
        [19] = { maxHP =  441, maxMP =    0, STR =  28, DEX =  22, VIT =  27, AGI =  20, INT =  17, MND =  23, CHR =  24 },
        [20] = { maxHP =  464, maxMP =    0, STR =  29, DEX =  23, VIT =  28, AGI =  20, INT =  18, MND =  24, CHR =  25 },
        [21] = { maxHP =  489, maxMP =    0, STR =  30, DEX =  25, VIT =  30, AGI =  22, INT =  19, MND =  25, CHR =  26 },
        [22] = { maxHP =  512, maxMP =    0, STR =  30, DEX =  25, VIT =  30, AGI =  22, INT =  19, MND =  25, CHR =  26 },
        [23] = { maxHP =  535, maxMP =    0, STR =  32, DEX =  26, VIT =  31, AGI =  22, INT =  20, MND =  26, CHR =  27 },
        [24] = { maxHP =  559, maxMP =    0, STR =  33, DEX =  27, VIT =  33, AGI =  24, INT =  21, MND =  27, CHR =  28 },
        [25] = { maxHP =  583, maxMP =    0, STR =  34, DEX =  27, VIT =  33, AGI =  24, INT =  21, MND =  28, CHR =  29 },
        [26] = { maxHP =  606, maxMP =    0, STR =  35, DEX =  29, VIT =  34, AGI =  25, INT =  22, MND =  29, CHR =  30 },
        [27] = { maxHP =  630, maxMP =    0, STR =  36, DEX =  29, VIT =  36, AGI =  26, INT =  23, MND =  30, CHR =  31 },
        [28] = { maxHP =  653, maxMP =    0, STR =  37, DEX =  30, VIT =  36, AGI =  26, INT =  23, MND =  30, CHR =  32 },
        [29] = { maxHP =  677, maxMP =    0, STR =  38, DEX =  31, VIT =  37, AGI =  27, INT =  24, MND =  32, CHR =  33 },
        [30] = { maxHP =  700, maxMP =    0, STR =  39, DEX =  32, VIT =  39, AGI =  28, INT =  25, MND =  33, CHR =  34 },
        [31] = { maxHP =  725, maxMP =    0, STR =  41, DEX =  33, VIT =  40, AGI =  29, INT =  26, MND =  34, CHR =  35 },
        [32] = { maxHP =  750, maxMP =    0, STR =  41, DEX =  33, VIT =  40, AGI =  29, INT =  26, MND =  34, CHR =  35 },
        [33] = { maxHP =  774, maxMP =    0, STR =  42, DEX =  34, VIT =  42, AGI =  30, INT =  27, MND =  35, CHR =  36 },
        [34] = { maxHP =  799, maxMP =    0, STR =  43, DEX =  35, VIT =  43, AGI =  31, INT =  28, MND =  36, CHR =  37 },
        [35] = { maxHP =  824, maxMP =    0, STR =  44, DEX =  36, VIT =  43, AGI =  31, INT =  28, MND =  37, CHR =  38 },
        [36] = { maxHP =  849, maxMP =    0, STR =  45, DEX =  37, VIT =  45, AGI =  33, INT =  29, MND =  38, CHR =  39 },
        [37] = { maxHP =  874, maxMP =    0, STR =  47, DEX =  38, VIT =  46, AGI =  33, INT =  30, MND =  39, CHR =  40 },
        [38] = { maxHP =  899, maxMP =    0, STR =  47, DEX =  38, VIT =  46, AGI =  33, INT =  30, MND =  39, CHR =  41 },
        [39] = { maxHP =  924, maxMP =    0, STR =  49, DEX =  39, VIT =  48, AGI =  35, INT =  31, MND =  40, CHR =  42 },
        [40] = { maxHP =  948, maxMP =    0, STR =  50, DEX =  40, VIT =  49, AGI =  35, INT =  31, MND =  41, CHR =  43 },
        [41] = { maxHP =  973, maxMP =    0, STR =  51, DEX =  42, VIT =  50, AGI =  37, INT =  33, MND =  43, CHR =  44 },
        [42] = { maxHP =  999, maxMP =    0, STR =  51, DEX =  42, VIT =  51, AGI =  37, INT =  33, MND =  43, CHR =  44 },
        [43] = { maxHP = 1023, maxMP =    0, STR =  53, DEX =  43, VIT =  52, AGI =  37, INT =  33, MND =  44, CHR =  45 },
        [44] = { maxHP = 1048, maxMP =    0, STR =  54, DEX =  44, VIT =  53, AGI =  39, INT =  34, MND =  45, CHR =  46 },
        [45] = { maxHP = 1073, maxMP =    0, STR =  55, DEX =  44, VIT =  54, AGI =  39, INT =  35, MND =  46, CHR =  47 },
        [46] = { maxHP = 1098, maxMP =    0, STR =  56, DEX =  46, VIT =  55, AGI =  40, INT =  36, MND =  47, CHR =  48 },
        [47] = { maxHP = 1123, maxMP =    0, STR =  57, DEX =  46, VIT =  56, AGI =  41, INT =  36, MND =  47, CHR =  49 },
        [48] = { maxHP = 1147, maxMP =    0, STR =  58, DEX =  47, VIT =  57, AGI =  41, INT =  36, MND =  48, CHR =  50 },
        [49] = { maxHP = 1172, maxMP =    0, STR =  59, DEX =  48, VIT =  58, AGI =  42, INT =  38, MND =  49, CHR =  51 },
        [50] = { maxHP = 1197, maxMP =    0, STR =  60, DEX =  49, VIT =  59, AGI =  43, INT =  38, MND =  50, CHR =  52 },
        [51] = { maxHP = 1226, maxMP =    0, STR =  62, DEX =  50, VIT =  60, AGI =  44, INT =  39, MND =  51, CHR =  53 },
        [52] = { maxHP = 1253, maxMP =    0, STR =  62, DEX =  50, VIT =  61, AGI =  44, INT =  39, MND =  51, CHR =  53 },
        [53] = { maxHP = 1281, maxMP =    0, STR =  63, DEX =  51, VIT =  62, AGI =  45, INT =  40, MND =  53, CHR =  54 },
        [54] = { maxHP = 1309, maxMP =    0, STR =  64, DEX =  52, VIT =  63, AGI =  46, INT =  41, MND =  54, CHR =  55 },
        [55] = { maxHP = 1337, maxMP =    0, STR =  65, DEX =  53, VIT =  64, AGI =  46, INT =  41, MND =  54, CHR =  56 },
        [56] = { maxHP = 1365, maxMP =    0, STR =  66, DEX =  54, VIT =  65, AGI =  48, INT =  42, MND =  55, CHR =  57 },
        [57] = { maxHP = 1394, maxMP =    0, STR =  68, DEX =  65, VIT =  66, AGI =  48, INT =  43, MND =  56, CHR =  58 },
        [58] = { maxHP = 1421, maxMP =    0, STR =  68, DEX =  55, VIT =  67, AGI =  48, INT =  43, MND =  57, CHR =  59 },
        [59] = { maxHP = 1449, maxMP =    0, STR =  70, DEX =  56, VIT =  68, AGI =  50, INT =  44, MND =  58, CHR =  60 },
        [60] = { maxHP = 1477, maxMP =    0, STR =  71, DEX =  57, VIT =  69, AGI =  50, INT =  45, MND =  59, CHR =  61 },
        [61] = { maxHP = 1489, maxMP =    0, STR =  71, DEX =  57, VIT =  69, AGI =  50, INT =  45, MND =  59, CHR =  61 },
        [62] = { maxHP = 1502, maxMP =    0, STR =  71, DEX =  59, VIT =  70, AGI =  52, INT =  46, MND =  60, CHR =  62 },
        [63] = { maxHP = 1514, maxMP =    0, STR =  72, DEX =  60, VIT =  71, AGI =  53, INT =  47, MND =  61, CHR =  63 },
        [64] = { maxHP = 1527, maxMP =    0, STR =  72, DEX =  60, VIT =  71, AGI =  53, INT =  48, MND =  62, CHR =  63 },
        [65] = { maxHP = 1539, maxMP =    0, STR =  74, DEX =  61, VIT =  72, AGI =  54, INT =  49, MND =  62, CHR =  64 },
        [66] = { maxHP = 1551, maxMP =    0, STR =  74, DEX =  62, VIT =  73, AGI =  55, INT =  50, MND =  63, CHR =  65 },
        [67] = { maxHP = 1564, maxMP =    0, STR =  74, DEX =  62, VIT =  73, AGI =  56, INT =  51, MND =  64, CHR =  65 },
        [68] = { maxHP = 1576, maxMP =    0, STR =  75, DEX =  63, VIT =  74, AGI =  57, INT =  52, MND =  65, CHR =  67 },
        [69] = { maxHP = 1589, maxMP =    0, STR =  76, DEX =  64, VIT =  74, AGI =  58, INT =  53, MND =  66, CHR =  67 },
        [70] = { maxHP = 1601, maxMP =    0, STR =  77, DEX =  66, VIT =  76, AGI =  59, INT =  54, MND =  67, CHR =  69 },
        [71] = { maxHP = 1613, maxMP =    0, STR =  77, DEX =  66, VIT =  76, AGI =  59, INT =  54, MND =  67, CHR =  69 },
        [72] = { maxHP = 1626, maxMP =    0, STR =  77, DEX =  67, VIT =  76, AGI =  60, INT =  56, MND =  68, CHR =  70 },
        [73] = { maxHP = 1639, maxMP =    0, STR =  78, DEX =  68, VIT =  77, AGI =  62, INT =  57, MND =  69, CHR =  71 },
        [74] = { maxHP = 1651, maxMP =    0, STR =  78, DEX =  68, VIT =  77, AGI =  62, INT =  58, MND =  70, CHR =  71 },
        [75] = { maxHP = 1663, maxMP =    0, STR =  80, DEX =  69, VIT =  78, AGI =  63, INT =  59, MND =  71, CHR =  72 },
        [76] = { maxHP = 1676, maxMP =    0, STR =  80, DEX =  69, VIT =  78, AGI =  63, INT =  59, MND =  71, CHR =  72 },
        [77] = { maxHP = 1689, maxMP =    0, STR =  81, DEX =  71, VIT =  80, AGI =  65, INT =  60, MND =  72, CHR =  74 },
        [78] = { maxHP = 1702, maxMP =    0, STR =  82, DEX =  72, VIT =  81, AGI =  66, INT =  61, MND =  73, CHR =  75 },
        [79] = { maxHP = 1715, maxMP =    0, STR =  83, DEX =  73, VIT =  82, AGI =  67, INT =  63, MND =  75, CHR =  76 },
        [80] = { maxHP = 1727, maxMP =    0, STR =  83, DEX =  73, VIT =  82, AGI =  67, INT =  63, MND =  75, CHR =  76 },
        [81] = { maxHP = 1740, maxMP =    0, STR =  83, DEX =  73, VIT =  82, AGI =  67, INT =  63, MND =  75, CHR =  76 },
        [82] = { maxHP = 1753, maxMP =    0, STR =  86, DEX =  76, VIT =  85, AGI =  70, INT =  65, MND =  77, CHR =  79 },
        [83] = { maxHP = 1767, maxMP =    0, STR =  87, DEX =  77, VIT =  86, AGI =  70, INT =  65, MND =  77, CHR =  79 },
        [84] = { maxHP = 1778, maxMP =    0, STR =  88, DEX =  78, VIT =  87, AGI =  72, INT =  68, MND =  80, CHR =  81 },
        [85] = { maxHP = 1791, maxMP =    0, STR =  88, DEX =  78, VIT =  87, AGI =  72, INT =  68, MND =  80, CHR =  81 },
        [86] = { maxHP = 1804, maxMP =    0, STR =  90, DEX =  79, VIT =  88, AGI =  73, INT =  69, MND =  81, CHR =  82 },
        [87] = { maxHP = 1817, maxMP =    0, STR =  91, DEX =  81, VIT =  90, AGI =  75, INT =  70, MND =  82, CHR =  84 },
        [88] = { maxHP = 1830, maxMP =    0, STR =  92, DEX =  82, VIT =  91, AGI =  76, INT =  71, MND =  83, CHR =  85 },
        [89] = { maxHP = 1843, maxMP =    0, STR =  92, DEX =  82, VIT =  91, AGI =  76, INT =  71, MND =  83, CHR =  85 },
        [90] = { maxHP = 1855, maxMP =    0, STR =  93, DEX =  83, VIT =  92, AGI =  77, INT =  73, MND =  85, CHR =  86 },
        [91] = { maxHP = 1867, maxMP =    0, STR =  95, DEX =  84, VIT =  93, AGI =  78, INT =  74, MND =  86, CHR =  87 },
        [92] = { maxHP = 1881, maxMP =    0, STR =  96, DEX =  86, VIT =  95, AGI =  80, INT =  75, MND =  87, CHR =  89 },
        [93] = { maxHP = 1894, maxMP =    0, STR =  97, DEX =  87, VIT =  96, AGI =  81, INT =  76, MND =  88, CHR =  90 },
        [94] = { maxHP = 1906, maxMP =    0, STR =  97, DEX =  87, VIT =  96, AGI =  81, INT =  76, MND =  88, CHR =  90 },
        [95] = { maxHP = 1919, maxMP =    0, STR =  98, DEX =  88, VIT =  97, AGI =  82, INT =  78, MND =  90, CHR =  91 },
        [96] = { maxHP = 1932, maxMP =    0, STR = 100, DEX =  89, VIT =  98, AGI =  83, INT =  79, MND =  91, CHR =  92 },
        [97] = { maxHP = 1945, maxMP =    0, STR = 101, DEX =  91, VIT = 100, AGI =  85, INT =  80, MND =  92, CHR =  94 },
        [98] = { maxHP = 1958, maxMP =    0, STR = 101, DEX =  91, VIT = 100, AGI =  85, INT =  80, MND =  92, CHR =  94 },
        [99] = { maxHP = 1971, maxMP =    0, STR = 102, DEX =  92, VIT = 101, AGI =  86, INT =  81, MND =  93, CHR =  95 },
    },

    [xi.automaton.frame.SHARPSHOT] =
    {
        [ 1] = { maxHP =   28, maxMP =    0, STR =   7, DEX =   7, VIT =   8, AGI =  10, INT =   8, MND =   7, CHR =   6 },
        [ 2] = { maxHP =   41, maxMP =    0, STR =   8, DEX =   8, VIT =   9, AGI =  11, INT =   9, MND =   8, CHR =   7 },
        [ 3] = { maxHP =   53, maxMP =    0, STR =   9, DEX =   9, VIT =  10, AGI =  12, INT =   9, MND =   8, CHR =   8 },
        [ 4] = { maxHP =   67, maxMP =    0, STR =  10, DEX =  10, VIT =  10, AGI =  13, INT =  10, MND =   9, CHR =   8 },
        [ 5] = { maxHP =   79, maxMP =    0, STR =  11, DEX =  11, VIT =  11, AGI =  14, INT =  11, MND =  10, CHR =   9 },
        [ 6] = { maxHP =   92, maxMP =    0, STR =  11, DEX =  12, VIT =  12, AGI =  15, INT =  11, MND =  10, CHR =  10 },
        [ 7] = { maxHP =  105, maxMP =    0, STR =  12, DEX =  13, VIT =  13, AGI =  16, INT =  12, MND =  11, CHR =  11 },
        [ 8] = { maxHP =  118, maxMP =    0, STR =  13, DEX =  14, VIT =  13, AGI =  17, INT =  13, MND =  12, CHR =  11 },
        [ 9] = { maxHP =  130, maxMP =    0, STR =  14, DEX =  15, VIT =  14, AGI =  18, INT =  13, MND =  12, CHR =  12 },
        [10] = { maxHP =  143, maxMP =    0, STR =  15, DEX =  16, VIT =  15, AGI =  19, INT =  14, MND =  13, CHR =  13 },
        [11] = { maxHP =  157, maxMP =    0, STR =  16, DEX =  17, VIT =  17, AGI =  20, INT =  15, MND =  15, CHR =  14 },
        [12] = { maxHP =  172, maxMP =    0, STR =  16, DEX =  17, VIT =  17, AGI =  21, INT =  15, MND =  15, CHR =  14 },
        [13] = { maxHP =  187, maxMP =    0, STR =  17, DEX =  18, VIT =  18, AGI =  22, INT =  17, MND =  18, CHR =  16 },
        [14] = { maxHP =  202, maxMP =    0, STR =  18, DEX =  19, VIT =  19, AGI =  23, INT =  17, MND =  17, CHR =  16 },
        [15] = { maxHP =  217, maxMP =    0, STR =  19, DEX =  20, VIT =  19, AGI =  24, INT =  18, MND =  17, CHR =  17 },
        [16] = { maxHP =  232, maxMP =    0, STR =  20, DEX =  21, VIT =  21, AGI =  25, INT =  19, MND =  18, CHR =  18 },
        [17] = { maxHP =  246, maxMP =    0, STR =  21, DEX =  22, VIT =  22, AGI =  27, INT =  20, MND =  19, CHR =  19 },
        [18] = { maxHP =  261, maxMP =    0, STR =  21, DEX =  22, VIT =  22, AGI =  27, INT =  20, MND =  19, CHR =  19 },
        [19] = { maxHP =  276, maxMP =    0, STR =  22, DEX =  24, VIT =  23, AGI =  29, INT =  21, MND =  20, CHR =  20 },
        [20] = { maxHP =  291, maxMP =    0, STR =  23, DEX =  25, VIT =  24, AGI =  30, INT =  22, MND =  21, CHR =  21 },
        [21] = { maxHP =  305, maxMP =    0, STR =  25, DEX =  26, VIT =  26, AGI =  31, INT =  24, MND =  23, CHR =  22 },
        [22] = { maxHP =  321, maxMP =    0, STR =  25, DEX =  26, VIT =  26, AGI =  32, INT =  24, MND =  23, CHR =  22 },
        [23] = { maxHP =  335, maxMP =    0, STR =  26, DEX =  27, VIT =  27, AGI =  33, INT =  25, MND =  24, CHR =  23 },
        [24] = { maxHP =  350, maxMP =    0, STR =  27, DEX =  29, VIT =  28, AGI =  34, INT =  26, MND =  25, CHR =  24 },
        [25] = { maxHP =  365, maxMP =    0, STR =  27, DEX =  29, VIT =  28, AGI =  35, INT =  26, MND =  25, CHR =  25 },
        [26] = { maxHP =  380, maxMP =    0, STR =  29, DEX =  30, VIT =  30, AGI =  36, INT =  27, MND =  26, CHR =  26 },
        [27] = { maxHP =  394, maxMP =    0, STR =  29, DEX =  31, VIT =  31, AGI =  37, INT =  28, MND =  27, CHR =  26 },
        [28] = { maxHP =  409, maxMP =    0, STR =  30, DEX =  32, VIT =  31, AGI =  38, INT =  29, MND =  27, CHR =  27 },
        [29] = { maxHP =  424, maxMP =    0, STR =  31, DEX =  33, VIT =  32, AGI =  39, INT =  29, MND =  28, CHR =  28 },
        [30] = { maxHP =  439, maxMP =    0, STR =  32, DEX =  34, VIT =  33, AGI =  41, INT =  31, MND =  29, CHR =  29 },
        [31] = { maxHP =  453, maxMP =    0, STR =  33, DEX =  35, VIT =  35, AGI =  42, INT =  32, MND =  31, CHR =  30 },
        [32] = { maxHP =  468, maxMP =    0, STR =  33, DEX =  35, VIT =  35, AGI =  42, INT =  32, MND =  31, CHR =  30 },
        [33] = { maxHP =  483, maxMP =    0, STR =  34, DEX =  37, VIT =  36, AGI =  44, INT =  33, MND =  32, CHR =  31 },
        [34] = { maxHP =  498, maxMP =    0, STR =  35, DEX =  38, VIT =  37, AGI =  45, INT =  34, MND =  33, CHR =  32 },
        [35] = { maxHP =  513, maxMP =    0, STR =  36, DEX =  38, VIT =  37, AGI =  46, INT =  34, MND =  33, CHR =  32 },
        [36] = { maxHP =  528, maxMP =    0, STR =  37, DEX =  39, VIT =  39, AGI =  47, INT =  36, MND =  34, CHR =  33 },
        [37] = { maxHP =  542, maxMP =    0, STR =  38, DEX =  41, VIT =  40, AGI =  48, INT =  36, MND =  35, CHR =  34 },
        [38] = { maxHP =  557, maxMP =    0, STR =  38, DEX =  41, VIT =  40, AGI =  49, INT =  37, MND =  35, CHR =  35 },
        [39] = { maxHP =  572, maxMP =    0, STR =  39, DEX =  42, VIT =  41, AGI =  50, INT =  38, MND =  36, CHR =  35 },
        [40] = { maxHP =  587, maxMP =    0, STR =  40, DEX =  43, VIT =  42, AGI =  51, INT =  39, MND =  37, CHR =  36 },
        [41] = { maxHP =  602, maxMP =    0, STR =  42, DEX =  45, VIT =  44, AGI =  53, INT =  40, MND =  39, CHR =  38 },
        [42] = { maxHP =  617, maxMP =    0, STR =  42, DEX =  45, VIT =  44, AGI =  53, INT =  40, MND =  39, CHR =  38 },
        [43] = { maxHP =  631, maxMP =    0, STR =  43, DEX =  46, VIT =  45, AGI =  54, INT =  41, MND =  40, CHR =  39 },
        [44] = { maxHP =  646, maxMP =    0, STR =  44, DEX =  47, VIT =  46, AGI =  56, INT =  42, MND =  41, CHR =  39 },
        [45] = { maxHP =  661, maxMP =    0, STR =  44, DEX =  47, VIT =  46, AGI =  56, INT =  43, MND =  41, CHR =  40 },
        [46] = { maxHP =  676, maxMP =    0, STR =  46, DEX =  49, VIT =  48, AGI =  58, INT =  44, MND =  42, CHR =  41 },
        [47] = { maxHP =  690, maxMP =    0, STR =  46, DEX =  50, VIT =  49, AGI =  59, INT =  45, MND =  43, CHR =  42 },
        [48] = { maxHP =  705, maxMP =    0, STR =  47, DEX =  50, VIT =  49, AGI =  60, INT =  45, MND =  43, CHR =  42 },
        [49] = { maxHP =  720, maxMP =    0, STR =  48, DEX =  51, VIT =  50, AGI =  61, INT =  46, MND =  44, CHR =  43 },
        [50] = { maxHP =  735, maxMP =    0, STR =  49, DEX =  53, VIT =  51, AGI =  62, INT =  47, MND =  45, CHR =  44 },
        [51] = { maxHP =  752, maxMP =    0, STR =  50, DEX =  54, VIT =  53, AGI =  63, INT =  48, MND =  47, CHR =  45 },
        [52] = { maxHP =  769, maxMP =    0, STR =  50, DEX =  54, VIT =  53, AGI =  64, INT =  48, MND =  47, CHR =  45 },
        [53] = { maxHP =  786, maxMP =    0, STR =  51, DEX =  55, VIT =  54, AGI =  65, INT =  50, MND =  48, CHR =  47 },
        [54] = { maxHP =  803, maxMP =    0, STR =  52, DEX =  56, VIT =  55, AGI =  66, INT =  50, MND =  49, CHR =  47 },
        [55] = { maxHP =  820, maxMP =    0, STR =  53, DEX =  57, VIT =  55, AGI =  67, INT =  51, MND =  49, CHR =  48 },
        [56] = { maxHP =  837, maxMP =    0, STR =  54, DEX =  58, VIT =  57, AGI =  68, INT =  52, MND =  50, CHR =  49 },
        [57] = { maxHP =  854, maxMP =    0, STR =  55, DEX =  59, VIT =  58, AGI =  70, INT =  53, MND =  51, CHR =  50 },
        [58] = { maxHP =  871, maxMP =    0, STR =  55, DEX =  59, VIT =  58, AGI =  70, INT =  53, MND =  51, CHR =  50 },
        [59] = { maxHP =  888, maxMP =    0, STR =  56, DEX =  61, VIT =  59, AGI =  72, INT =  54, MND =  52, CHR =  51 },
        [60] = { maxHP =  905, maxMP =    0, STR =  57, DEX =  62, VIT =  60, AGI =  73, INT =  55, MND =  53, CHR =  52 },
        [61] = { maxHP =  913, maxMP =    0, STR =  57, DEX =  62, VIT =  60, AGI =  73, INT =  55, MND =  53, CHR =  52 },
        [62] = { maxHP =  921, maxMP =    0, STR =  59, DEX =  63, VIT =  62, AGI =  73, INT =  57, MND =  55, CHR =  53 },
        [63] = { maxHP =  930, maxMP =    0, STR =  60, DEX =  64, VIT =  63, AGI =  74, INT =  58, MND =  56, CHR =  54 },
        [64] = { maxHP =  938, maxMP =    0, STR =  60, DEX =  64, VIT =  63, AGI =  74, INT =  58, MND =  56, CHR =  55 },
        [65] = { maxHP =  946, maxMP =    0, STR =  61, DEX =  65, VIT =  64, AGI =  75, INT =  59, MND =  57, CHR =  56 },
        [66] = { maxHP =  954, maxMP =    0, STR =  62, DEX =  66, VIT =  65, AGI =  76, INT =  60, MND =  58, CHR =  57 },
        [67] = { maxHP =  963, maxMP =    0, STR =  62, DEX =  66, VIT =  65, AGI =  76, INT =  60, MND =  59, CHR =  57 },
        [68] = { maxHP =  970, maxMP =    0, STR =  63, DEX =  68, VIT =  66, AGI =  77, INT =  62, MND =  60, CHR =  58 },
        [69] = { maxHP =  979, maxMP =    0, STR =  64, DEX =  69, VIT =  67, AGI =  77, INT =  63, MND =  61, CHR =  60 },
        [70] = { maxHP =  987, maxMP =    0, STR =  66, DEX =  70, VIT =  69, AGI =  78, INT =  64, MND =  62, CHR =  61 },
        [71] = { maxHP =  995, maxMP =    0, STR =  66, DEX =  70, VIT =  69, AGI =  78, INT =  64, MND =  62, CHR =  61 },
        [72] = { maxHP = 1003, maxMP =    0, STR =  67, DEX =  71, VIT =  70, AGI =  79, INT =  65, MND =  64, CHR =  62 },
        [73] = { maxHP = 1012, maxMP =    0, STR =  68, DEX =  72, VIT =  71, AGI =  80, INT =  67, MND =  65, CHR =  63 },
        [74] = { maxHP = 1020, maxMP =    0, STR =  68, DEX =  72, VIT =  71, AGI =  80, INT =  67, MND =  65, CHR =  64 },
        [75] = { maxHP = 1028, maxMP =    0, STR =  69, DEX =  73, VIT =  72, AGI =  81, INT =  68, MND =  65, CHR =  65 },
        [76] = { maxHP = 1037, maxMP =    0, STR =  69, DEX =  73, VIT =  72, AGI =  81, INT =  68, MND =  66, CHR =  65 },
        [77] = { maxHP = 1045, maxMP =    0, STR =  71, DEX =  75, VIT =  74, AGI =  82, INT =  69, MND =  68, CHR =  66 },
        [78] = { maxHP = 1054, maxMP =    0, STR =  72, DEX =  76, VIT =  75, AGI =  83, INT =  70, MND =  69, CHR =  67 },
        [79] = { maxHP = 1063, maxMP =    0, STR =  73, DEX =  77, VIT =  76, AGI =  85, INT =  72, MND =  70, CHR =  69 },
        [80] = { maxHP = 1071, maxMP =    0, STR =  73, DEX =  77, VIT =  76, AGI =  85, INT =  72, MND =  70, CHR =  69 },
        [81] = { maxHP = 1080, maxMP =    0, STR =  74, DEX =  78, VIT =  77, AGI =  86, INT =  73, MND =  71, CHR =  70 },
        [82] = { maxHP = 1089, maxMP =    0, STR =  76, DEX =  80, VIT =  79, AGI =  87, INT =  74, MND =  73, CHR =  71 },
        [83] = { maxHP = 1096, maxMP =    0, STR =  77, DEX =  81, VIT =  80, AGI =  88, INT =  75, MND =  74, CHR =  72 },
        [84] = { maxHP = 1106, maxMP =    0, STR =  78, DEX =  82, VIT =  81, AGI =  90, INT =  77, MND =  75, CHR =  74 },
        [85] = { maxHP = 1115, maxMP =    0, STR =  78, DEX =  82, VIT =  81, AGI =  90, INT =  77, MND =  75, CHR =  74 },
        [86] = { maxHP = 1122, maxMP =    0, STR =  79, DEX =  83, VIT =  82, AGI =  81, INT =  78, MND =  76, CHR =  75 },
        [87] = { maxHP = 1131, maxMP =    0, STR =  81, DEX =  85, VIT =  84, AGI =  92, INT =  79, MND =  78, CHR =  76 },
        [88] = { maxHP = 1140, maxMP =    0, STR =  82, DEX =  86, VIT =  85, AGI =  93, INT =  80, MND =  79, CHR =  77 },
        [89] = { maxHP = 1149, maxMP =    0, STR =  82, DEX =  86, VIT =  85, AGI =  93, INT =  80, MND =  79, CHR =  77 },
        [90] = { maxHP = 1157, maxMP =    0, STR =  83, DEX =  87, VIT =  86, AGI =  95, INT =  82, MND =  80, CHR =  79 },
        [91] = { maxHP = 1166, maxMP =    0, STR =  84, DEX =  88, VIT =  87, AGI =  96, INT =  83, MND =  81, CHR =  80 },
        [92] = { maxHP = 1175, maxMP =    0, STR =  86, DEX =  90, VIT =  89, AGI =  97, INT =  84, MND =  83, CHR =  81 },
        [93] = { maxHP = 1183, maxMP =    0, STR =  87, DEX =  91, VIT =  90, AGI =  98, INT =  85, MND =  84, CHR =  82 },
        [94] = { maxHP = 1192, maxMP =    0, STR =  87, DEX =  91, VIT =  90, AGI =  98, INT =  85, MND =  84, CHR =  82 },
        [95] = { maxHP = 1201, maxMP =    0, STR =  88, DEX =  92, VIT =  91, AGI = 100, INT =  87, MND =  85, CHR =  84 },
        [96] = { maxHP = 1209, maxMP =    0, STR =  89, DEX =  93, VIT =  92, AGI = 101, INT =  88, MND =  86, CHR =  85 },
        [97] = { maxHP = 1218, maxMP =    0, STR =  91, DEX =  95, VIT =  94, AGI = 102, INT =  89, MND =  88, CHR =  86 },
        [98] = { maxHP = 1227, maxMP =    0, STR =  91, DEX =  95, VIT =  94, AGI = 102, INT =  89, MND =  88, CHR =  86 },
        [99] = { maxHP = 1234, maxMP =    0, STR =  92, DEX =  96, VIT =  95, AGI = 103, INT =  90, MND =  89, CHR =  87 },
    },

    [xi.automaton.frame.STORMWAKER] =
    {
        [ 1] = { maxHP =   24, maxMP =   38, STR =   7, DEX =   6, VIT =   7, AGI =   8, INT =   9, MND =  10, CHR =   8 },
        [ 2] = { maxHP =   34, maxMP =   49, STR =   8, DEX =   7, VIT =   8, AGI =   9, INT =  10, MND =  11, CHR =   9 },
        [ 3] = { maxHP =   45, maxMP =   60, STR =   9, DEX =   8, VIT =   9, AGI =  10, INT =  11, MND =  12, CHR =  10 },
        [ 4] = { maxHP =   55, maxMP =   71, STR =   9, DEX =   8, VIT =   9, AGI =  10, INT =  11, MND =  13, CHR =  11 },
        [ 5] = { maxHP =   66, maxMP =   82, STR =  10, DEX =   9, VIT =  10, AGI =  11, INT =  12, MND =  14, CHR =  12 },
        [ 6] = { maxHP =   77, maxMP =   92, STR =  11, DEX =  10, VIT =  11, AGI =  12, INT =  13, MND =  14, CHR =  12 },
        [ 7] = { maxHP =   87, maxMP =  103, STR =  12, DEX =  11, VIT =  12, AGI =  13, INT =  14, MND =  15, CHR =  13 },
        [ 8] = { maxHP =   97, maxMP =  114, STR =  12, DEX =  11, VIT =  12, AGI =  13, INT =  14, MND =  16, CHR =  14 },
        [ 9] = { maxHP =  109, maxMP =  125, STR =  13, DEX =  12, VIT =  13, AGI =  14, INT =  15, MND =  17, CHR =  15 },
        [10] = { maxHP =  119, maxMP =  136, STR =  14, DEX =  13, VIT =  14, AGI =  15, INT =  16, MND =  18, CHR =  16 },
        [11] = { maxHP =  132, maxMP =  148, STR =  15, DEX =  15, VIT =  15, AGI =  16, INT =  17, MND =  19, CHR =  17 },
        [12] = { maxHP =  144, maxMP =  159, STR =  15, DEX =  15, VIT =  15, AGI =  16, INT =  17, MND =  20, CHR =  17 },
        [13] = { maxHP =  157, maxMP =  171, STR =  16, DEX =  16, VIT =  16, AGI =  17, INT =  19, MND =  21, CHR =  19 },
        [14] = { maxHP =  169, maxMP =  182, STR =  17, DEX =  17, VIT =  17, AGI =  18, INT =  19, MND =  22, CHR =  20 },
        [15] = { maxHP =  182, maxMP =  194, STR =  17, DEX =  17, VIT =  17, AGI =  19, INT =  20, MND =  23, CHR =  20 },
        [16] = { maxHP =  193, maxMP =  205, STR =  18, DEX =  18, VIT =  18, AGI =  20, INT =  21, MND =  24, CHR =  22 },
        [17] = { maxHP =  206, maxMP =  217, STR =  20, DEX =  19, VIT =  20, AGI =  21, INT =  22, MND =  25, CHR =  22 },
        [18] = { maxHP =  218, maxMP =  228, STR =  20, DEX =  19, VIT =  20, AGI =  21, INT =  23, MND =  26, CHR =  23 },
        [19] = { maxHP =  231, maxMP =  240, STR =  21, DEX =  21, VIT =  21, AGI =  22, INT =  24, MND =  27, CHR =  24 },
        [20] = { maxHP =  243, maxMP =  250, STR =  22, DEX =  21, VIT =  22, AGI =  23, INT =  25, MND =  28, CHR =  25 },
        [21] = { maxHP =  256, maxMP =  262, STR =  23, DEX =  23, VIT =  23, AGI =  25, INT =  26, MND =  29, CHR =  27 },
        [22] = { maxHP =  268, maxMP =  273, STR =  23, DEX =  23, VIT =  23, AGI =  25, INT =  26, MND =  30, CHR =  27 },
        [23] = { maxHP =  281, maxMP =  285, STR =  24, DEX =  24, VIT =  24, AGI =  26, INT =  28, MND =  31, CHR =  28 },
        [24] = { maxHP =  293, maxMP =  296, STR =  25, DEX =  25, VIT =  25, AGI =  27, INT =  28, MND =  32, CHR =  29 },
        [25] = { maxHP =  306, maxMP =  308, STR =  26, DEX =  25, VIT =  26, AGI =  27, INT =  29, MND =  33, CHR =  30 },
        [26] = { maxHP =  318, maxMP =  319, STR =  27, DEX =  26, VIT =  27, AGI =  29, INT =  30, MND =  34, CHR =  31 },
        [27] = { maxHP =  331, maxMP =  331, STR =  28, DEX =  27, VIT =  28, AGI =  29, INT =  31, MND =  35, CHR =  32 },
        [28] = { maxHP =  342, maxMP =  342, STR =  28, DEX =  27, VIT =  28, AGI =  30, INT =  32, MND =  36, CHR =  32 },
        [29] = { maxHP =  356, maxMP =  354, STR =  29, DEX =  29, VIT =  29, AGI =  31, INT =  33, MND =  37, CHR =  33 },
        [30] = { maxHP =  367, maxMP =  364, STR =  30, DEX =  29, VIT =  30, AGI =  32, INT =  34, MND =  38, CHR =  35 },
        [31] = { maxHP =  380, maxMP =  376, STR =  31, DEX =  31, VIT =  31, AGI =  33, INT =  35, MND =  39, CHR =  36 },
        [32] = { maxHP =  392, maxMP =  387, STR =  31, DEX =  31, VIT =  31, AGI =  33, INT =  35, MND =  40, CHR =  36 },
        [33] = { maxHP =  405, maxMP =  399, STR =  33, DEX =  32, VIT =  33, AGI =  34, INT =  37, MND =  41, CHR =  37 },
        [34] = { maxHP =  418, maxMP =  410, STR =  34, DEX =  33, VIT =  34, AGI =  35, INT =  37, MND =  42, CHR =  38 },
        [35] = { maxHP =  430, maxMP =  422, STR =  34, DEX =  33, VIT =  34, AGI =  36, INT =  38, MND =  43, CHR =  39 },
        [36] = { maxHP =  442, maxMP =  433, STR =  35, DEX =  34, VIT =  35, AGI =  37, INT =  39, MND =  44, CHR =  40 },
        [37] = { maxHP =  455, maxMP =  445, STR =  36, DEX =  35, VIT =  36, AGI =  38, INT =  40, MND =  45, CHR =  41 },
        [38] = { maxHP =  467, maxMP =  456, STR =  36, DEX =  35, VIT =  36, AGI =  38, INT =  41, MND =  46, CHR =  41 },
        [39] = { maxHP =  480, maxMP =  468, STR =  37, DEX =  37, VIT =  37, AGI =  39, INT =  42, MND =  47, CHR =  43 },
        [40] = { maxHP =  491, maxMP =  478, STR =  38, DEX =  37, VIT =  38, AGI =  40, INT =  43, MND =  48, CHR =  44 },
        [41] = { maxHP =  505, maxMP =  490, STR =  40, DEX =  39, VIT =  40, AGI =  42, INT =  44, MND =  49, CHR =  45 },
        [42] = { maxHP =  516, maxMP =  501, STR =  40, DEX =  39, VIT =  40, AGI =  42, INT =  44, MND =  50, CHR =  45 },
        [43] = { maxHP =  529, maxMP =  513, STR =  41, DEX =  40, VIT =  41, AGI =  43, INT =  46, MND =  51, CHR =  46 },
        [44] = { maxHP =  541, maxMP =  524, STR =  42, DEX =  41, VIT =  42, AGI =  44, INT =  46, MND =  52, CHR =  48 },
        [45] = { maxHP =  554, maxMP =  536, STR =  42, DEX =  41, VIT =  42, AGI =  44, INT =  47, MND =  53, CHR =  48 },
        [46] = { maxHP =  566, maxMP =  547, STR =  43, DEX =  42, VIT =  43, AGI =  46, INT =  48, MND =  54, CHR =  49 },
        [47] = { maxHP =  579, maxMP =  559, STR =  44, DEX =  43, VIT =  44, AGI =  46, INT =  49, MND =  55, CHR =  50 },
        [48] = { maxHP =  591, maxMP =  570, STR =  44, DEX =  43, VIT =  44, AGI =  47, INT =  50, MND =  56, CHR =  51 },
        [49] = { maxHP =  604, maxMP =  582, STR =  46, DEX =  45, VIT =  46, AGI =  48, INT =  51, MND =  57, CHR =  52 },
        [50] = { maxHP =  616, maxMP =  592, STR =  47, DEX =  45, VIT =  47, AGI =  49, INT =  52, MND =  58, CHR =  53 },
        [51] = { maxHP =  630, maxMP =  604, STR =  48, DEX =  47, VIT =  48, AGI =  50, INT =  53, MND =  59, CHR =  54 },
        [52] = { maxHP =  645, maxMP =  615, STR =  48, DEX =  47, VIT =  48, AGI =  50, INT =  53, MND =  60, CHR =  54 },
        [53] = { maxHP =  659, maxMP =  627, STR =  49, DEX =  48, VIT =  49, AGI =  51, INT =  55, MND =  61, CHR =  56 },
        [54] = { maxHP =  673, maxMP =  638, STR =  50, DEX =  49, VIT =  50, AGI =  52, INT =  55, MND =  62, CHR =  57 },
        [55] = { maxHP =  687, maxMP =  650, STR =  50, DEX =  49, VIT =  50, AGI =  53, INT =  56, MND =  63, CHR =  57 },
        [56] = { maxHP =  702, maxMP =  661, STR =  51, DEX =  50, VIT =  51, AGI =  54, INT =  57, MND =  64, CHR =  59 },
        [57] = { maxHP =  716, maxMP =  673, STR =  53, DEX =  51, VIT =  53, AGI =  55, INT =  58, MND =  65, CHR =  59 },
        [58] = { maxHP =  731, maxMP =  684, STR =  53, DEX =  51, VIT =  53, AGI =  55, INT =  59, MND =  66, CHR =  60 },
        [59] = { maxHP =  745, maxMP =  696, STR =  54, DEX =  53, VIT =  54, AGI =  56, INT =  60, MND =  67, CHR =  61 },
        [60] = { maxHP =  759, maxMP =  706, STR =  55, DEX =  53, VIT =  55, AGI =  57, INT =  61, MND =  68, CHR =  62 },
        [61] = { maxHP =  767, maxMP =  718, STR =  55, DEX =  53, VIT =  55, AGI =  57, INT =  61, MND =  68, CHR =  62 },
        [62] = { maxHP =  773, maxMP =  730, STR =  56, DEX =  55, VIT =  56, AGI =  59, INT =  62, MND =  69, CHR =  64 },
        [63] = { maxHP =  781, maxMP =  742, STR =  57, DEX =  56, VIT =  57, AGI =  60, INT =  63, MND =  69, CHR =  64 },
        [64] = { maxHP =  787, maxMP =  754, STR =  58, DEX =  56, VIT =  58, AGI =  60, INT =  63, MND =  69, CHR =  65 },
        [65] = { maxHP =  794, maxMP =  766, STR =  59, DEX =  57, VIT =  59, AGI =  61, INT =  64, MND =  71, CHR =  66 },
        [66] = { maxHP =  801, maxMP =  778, STR =  60, DEX =  58, VIT =  60, AGI =  62, INT =  65, MND =  71, CHR =  67 },
        [67] = { maxHP =  808, maxMP =  790, STR =  60, DEX =  59, VIT =  60, AGI =  62, INT =  65, MND =  71, CHR =  67 },
        [68] = { maxHP =  814, maxMP =  802, STR =  61, DEX =  60, VIT =  61, AGI =  63, INT =  66, MND =  72, CHR =  68 },
        [69] = { maxHP =  822, maxMP =  814, STR =  63, DEX =  61, VIT =  63, AGI =  64, INT =  67, MND =  73, CHR =  69 },
        [70] = { maxHP =  828, maxMP =  826, STR =  64, DEX =  62, VIT =  64, AGI =  66, INT =  68, MND =  74, CHR =  70 },
        [71] = { maxHP =  836, maxMP =  838, STR =  64, DEX =  62, VIT =  64, AGI =  66, INT =  68, MND =  74, CHR =  70 },
        [72] = { maxHP =  842, maxMP =  850, STR =  65, DEX =  63, VIT =  65, AGI =  67, INT =  69, MND =  75, CHR =  71 },
        [73] = { maxHP =  850, maxMP =  862, STR =  66, DEX =  65, VIT =  66, AGI =  68, INT =  70, MND =  76, CHR =  73 },
        [74] = { maxHP =  856, maxMP =  874, STR =  67, DEX =  65, VIT =  67, AGI =  68, INT =  70, MND =  76, CHR =  73 },
        [75] = { maxHP =  863, maxMP =  886, STR =  68, DEX =  66, VIT =  68, AGI =  69, INT =  72, MND =  77, CHR =  74 },
        [76] = { maxHP =  870, maxMP =  898, STR =  68, DEX =  66, VIT =  68, AGI =  69, INT =  72, MND =  77, CHR =  74 },
        [77] = { maxHP =  877, maxMP =  910, STR =  69, DEX =  68, VIT =  69, AGI =  71, INT =  73, MND =  78, CHR =  75 },
        [78] = { maxHP =  885, maxMP =  923, STR =  70, DEX =  69, VIT =  70, AGI =  72, INT =  74, MND =  79, CHR =  76 },
        [79] = { maxHP =  892, maxMP =  936, STR =  72, DEX =  70, VIT =  72, AGI =  73, INT =  75, MND =  81, CHR =  78 },
        [80] = { maxHP =  899, maxMP =  949, STR =  72, DEX =  70, VIT =  72, AGI =  73, INT =  75, MND =  81, CHR =  78 },
        [81] = { maxHP =  908, maxMP =  961, STR =  73, DEX =  71, VIT =  73, AGI =  74, INT =  77, MND =  82, CHR =  79 },
        [82] = { maxHP =  914, maxMP =  974, STR =  74, DEX =  73, VIT =  74, AGI =  76, INT =  78, MND =  83, CHR =  80 },
        [83] = { maxHP =  921, maxMP =  986, STR =  75, DEX =  74, VIT =  75, AGI =  77, INT =  79, MND =  84, CHR =  81 },
        [84] = { maxHP =  930, maxMP =  999, STR =  77, DEX =  75, VIT =  77, AGI =  78, INT =  80, MND =  86, CHR =  83 },
        [85] = { maxHP =  937, maxMP = 1011, STR =  77, DEX =  75, VIT =  77, AGI =  78, INT =  80, MND =  86, CHR =  83 },
        [86] = { maxHP =  942, maxMP = 1024, STR =  78, DEX =  76, VIT =  78, AGI =  79, INT =  82, MND =  87, CHR =  84 },
        [87] = { maxHP =  952, maxMP = 1036, STR =  79, DEX =  78, VIT =  79, AGI =  81, INT =  83, MND =  88, CHR =  85 },
        [88] = { maxHP =  959, maxMP = 1051, STR =  80, DEX =  79, VIT =  80, AGI =  82, INT =  84, MND =  89, CHR =  86 },
        [89] = { maxHP =  966, maxMP = 1063, STR =  80, DEX =  79, VIT =  80, AGI =  82, INT =  84, MND =  89, CHR =  86 },
        [90] = { maxHP =  974, maxMP = 1076, STR =  82, DEX =  80, VIT =  82, AGI =  83, INT =  85, MND =  91, CHR =  88 },
        [91] = { maxHP =  981, maxMP = 1088, STR =  83, DEX =  81, VIT =  83, AGI =  84, INT =  87, MND =  92, CHR =  89 },
        [92] = { maxHP =  988, maxMP = 1101, STR =  84, DEX =  83, VIT =  84, AGI =  86, INT =  88, MND =  93, CHR =  90 },
        [93] = { maxHP =  996, maxMP = 1113, STR =  85, DEX =  84, VIT =  85, AGI =  87, INT =  89, MND =  94, CHR =  91 },
        [94] = { maxHP = 1003, maxMP = 1126, STR =  85, DEX =  84, VIT =  85, AGI =  87, INT =  89, MND =  94, CHR =  91 },
        [95] = { maxHP = 1010, maxMP = 1138, STR =  87, DEX =  85, VIT =  87, AGI =  88, INT =  90, MND =  96, CHR =  93 },
        [96] = { maxHP = 1018, maxMP = 1152, STR =  88, DEX =  86, VIT =  88, AGI =  89, INT =  92, MND =  97, CHR =  94 },
        [97] = { maxHP = 1025, maxMP = 1164, STR =  89, DEX =  88, VIT =  89, AGI =  91, INT =  93, MND =  98, CHR =  95 },
        [98] = { maxHP = 1032, maxMP = 1177, STR =  89, DEX =  88, VIT =  89, AGI =  91, INT =  93, MND =  98, CHR =  95 },
        [99] = { maxHP = 1040, maxMP = 1189, STR =  90, DEX =  89, VIT =  90, AGI =  92, INT =  94, MND =  99, CHR =  96 },
    },
}

-- Pre-Abyssea head skill-cap deltas. Source: https://wiki.ffo.jp/html/32037.html
xi.pets.automaton.skillCaps =
{
    -- Base frame ranks, an unlisted skill means no skill unless combined with a head that grants it.
    frames =
    {
        [xi.automaton.frame.HARLEQUIN] =
        {
            [xi.skill.AUTOMATON_MELEE ] = xi.skillRank.B_MINUS,
            [xi.skill.AUTOMATON_RANGED] = xi.skillRank.B_MINUS,
            [xi.skill.AUTOMATON_MAGIC ] = xi.skillRank.B_MINUS,
        },

        [xi.automaton.frame.VALOREDGE] =
        {
            [xi.skill.AUTOMATON_MELEE] = xi.skillRank.B_PLUS,
        },

        [xi.automaton.frame.SHARPSHOT] =
        {
            [xi.skill.AUTOMATON_MELEE ] = xi.skillRank.C_PLUS,
            [xi.skill.AUTOMATON_RANGED] = xi.skillRank.B_PLUS,
        },

        [xi.automaton.frame.STORMWAKER] =
        {
            [xi.skill.AUTOMATON_MELEE] = xi.skillRank.C_PLUS,
            [xi.skill.AUTOMATON_MAGIC] = xi.skillRank.B_PLUS,
        },
    },

    -- Head Bonuses. For skill rank ENUMs, lower is better. Example : xi.skillRank.B_PLUS(3) -2 = xi.skillRank.A_PLUS(1)
    -- If this bonus is applied to a frame that does not have that skill innately, becomes xi.skillRank.F.
    heads =
    {
        [xi.automaton.head.VALOREDGE] =
        {
            [xi.skill.AUTOMATON_MELEE] = -1,
        },

        [xi.automaton.head.SHARPSHOT] =
        {
            [xi.skill.AUTOMATON_RANGED] = -1,
        },

        [xi.automaton.head.STORMWAKER] =
        {
            [xi.skill.AUTOMATON_MAGIC] = -1,
        },

        [xi.automaton.head.SOULSOOTHER] =
        {
            [xi.skill.AUTOMATON_MAGIC] = -2,
        },

        [xi.automaton.head.SPIRITREAVER] =
        {
            [xi.skill.AUTOMATON_MAGIC] = -2,
        },
    },
}

-- Pre-Abyssea frame damage taken and block state. Sources:
-- https://wiki.ffo.jp/html/19739.html / https://wiki.ffo.jp/html/31705.html
xi.pets.automaton.frameMods =
{
    -----------------------------------
    -- Harlequin
    -----------------------------------
    [xi.automaton.frame.HARLEQUIN] =
    {
        mods =
        {
            { xi.mod.DMG, -625 },
        },
    },

    -----------------------------------
    -- Valoredge
    -----------------------------------
    [xi.automaton.frame.VALOREDGE] =
    {
        mods =
        {
            { xi.mod.DMG, -1250 },
        },
    },

    -----------------------------------
    -- Sharpshot
    -----------------------------------
    [xi.automaton.frame.SHARPSHOT] =
    {
        mods =
        {
            { xi.mod.PIERCE_SDT,  8750 },
            { xi.mod.DMGBREATH,  -1250 },
            { xi.mod.DMGMAGIC,   -1250 },
        },
    },

    -----------------------------------
    -- Stormwaker
    -----------------------------------
    [xi.automaton.frame.STORMWAKER] =
    {
        mods =
        {
            { xi.mod.DMGBREATH, -2500 },
            { xi.mod.DMGMAGIC,  -2500 },
        },
    },
}

local function applyAutomatonFrameMods(mob)
    local frameEquipped = mob:getAutomatonFrame()
    local frameData     = xi.pets.automaton.frameMods[frameEquipped]

    if not frameData then
        return
    end

    for _, mobModData in ipairs(frameData.mobMods or {}) do
        mob:setMobMod(mobModData[1], mobModData[2])
    end

    for _, modData in ipairs(frameData.mods or {}) do
        mob:addMod(modData[1], modData[2])
    end
end

local function getHeadyArtificeSkill(mob)
    local headEquipped  = mob:getAutomatonHead()
    local maxMP         = mob:getMaxMP()
    local currentTarget = mob:getTarget()

    if headEquipped == xi.automaton.head.VALOREDGE then
        if currentTarget and currentTarget:getMainLvl() - mob:getMainLvl() >= 4 then
            return xi.mobSkill.INVINCIBLE_AUTOMATON
        end
    elseif headEquipped == xi.automaton.head.SHARPSHOT then
        if mob:getAutomatonFrame() == xi.automaton.frame.SHARPSHOT then
            return xi.mobSkill.EES_AUTOMATON
        end
    elseif headEquipped == xi.automaton.head.STORMWAKER then
        if maxMP > 0 then
            return xi.mobSkill.CHAINSPELL_AUTOMATON
        end
    elseif headEquipped == xi.automaton.head.SOULSOOTHER then
        return xi.mobSkill.BENEDICTION_AUTOMATON
    elseif headEquipped == xi.automaton.head.SPIRITREAVER then
        if maxMP > 0 then
            return xi.mobSkill.MANAFONT_AUTOMATON
        end
    end

    return xi.mobSkill.MIGHTY_STRIKES_AUTOMATON
end

-- Fixed 60-second maneuver duration without combat extension. Source: https://wiki.ffo.jp/html/32936.html
xi.pets.automaton.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.CAN_PARRY, 1)
    mob:setSpawnAnimation(xi.spawnAnimation.SPECIAL)
    applyAutomatonFrameMods(mob)

    mob:setLocalVar('MANEUVER_DURATION', 60)

    mob:addListener('AUTOMATON_AI_TICK', 'HEADY_ARTIFICE_USED', function(mobArg)
        if mobArg:getLocalVar('headyArtificeUsed') == 1 then
            if xi.combat.behavior.isEntityBusy(mobArg) then
                return
            end

            mobArg:useMobAbility(getHeadyArtificeSkill(mobArg))
            mobArg:setLocalVar('headyArtificeUsed', 0)
        end
    end)

    local master = mob:getMaster()

    if master then
        -- Automatons spawn with 35 burden in all elements.
        for element = 0, 7 do
            master:addBurden(element, 35)
        end
    end

    -- All Automaton Attachments have their cooldowns applied on spawn.
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.BARRAGE_TURBINE_AUTOMATON, 180)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.DISRUPTOR_AUTOMATON,        60)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.ECONOMIZER_AUTOMATON,       60)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.ERASER_AUTOMATON,           30)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.FLASHBULB_AUTOMATON,        45)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.HEAT_CAPACITOR_AUTOMATON,   90)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.MANA_CONVERTER_AUTOMATON,  180)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.PROVOKE_AUTOMATON,          30)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.REACTIVE_SHIELD_AUTOMATON,  60)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.REGULATOR_AUTOMATON,        60)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.REPLICATOR_AUTOMATON,       60)
    mob:addRecast(xi.recast.ABILITY, xi.mobSkill.SHOCK_ABSORBER_AUTOMATON,  180)
end

xi.pets.automaton.onAdditionalEffectAttack = function(attacker, defender, damage)
    local pTable =
    {
        chance         = 60,
        attackType     = xi.attackType.MAGICAL,
        magicalElement = xi.element.THUNDER,
        basePower      = xi.automaton.calculateVoltGunPotency(attacker, defender),
    }

    return xi.combat.action.executeAddEffectDamage(attacker, defender, pTable)
end

xi.pets.automaton.onMobDeath = function(mob)
    mob:removeListener('MANEUVER_DURATION')
end
