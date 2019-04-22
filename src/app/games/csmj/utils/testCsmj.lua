import(".test")
local CSAlgorithm = import(".CSAlgorithm")

local ACTION_TYPE = {
    CHU = 1,
    CHI = 2,
    PENG = 3,
    GONG_GANG = 4,
    AN_GANG = 5,
    MING_GANG = 6,
    BU = 7,
    GUO = 8,
    HU = 9,
    ZI_MO = 10,
    ZHUA_NIAO = 11,
    QIANG_GANG_HU = 12,
    GONG_BU = 13,
    AN_BU = 14,
    MING_BU = 15,
}

-- 碰碰胡
assert(CSAlgorithm.canHu_({{action = ACTION_TYPE.PENG, cards = {26, 26, 26}}}, {14,14,14,13,13,13,12,12,12,29,29}))

-- assert(not CSAlgorithm.canHu_({{ACTION_TYPE.PENG, 26, 26, 26}}, {22,23,24,13,13,13,12,12,12,29,29}))

-- 清一色
assert(CSAlgorithm.canHu_({}, {12,13,14,14,14,14,13,13,13,12,13,14,19,19}))

-- 将将胡
assert(CSAlgorithm.canHu_({}, {22,22,25,12,15,18,18,15,12,12,28,38,32,35}))

-- 全求人
assert(CSAlgorithm.canHu_({}, {11, 11}))

-- 普通胡
assert(CSAlgorithm.canHu_({}, {16,16,16,14,14,14,13,13,13,12,12,12,28,28}))

assert(not CSAlgorithm.canHu_({}, {14,14, 22, 22, 23, 23, 24, 24}))

-- local handCards = {16,16,16,14,14,13,13,13,12,12,12,28,28}
-- local remainCards = CSAlgorithm.getRemainCards({{16,16,16,14,14,13,13,13,12,12,12,28,28}}, {}, {})

-- dump(CSAlgorithm.getTingPai(remainCards, {}, handCards), "shit")

-- local handCards = {16,16,16,14,22, 14,13,13,13,12,12,12,28,28}
-- dump(CSAlgorithm.getTingOperate({}, handCards), "shit")
