local RulesTest = class("RulesTest", nil)
local BaseAlgorithm = import(".BaseAlgorithm")
local DtzAlgorithm = import(".DtzAlgorithm")
local DtzCardType = import(".DtzCardType")

local function assertEqualTable(a, b)
    assert(#a == #b)
    for i,v in ipairs(a) do
        assert(v == b[i])
    end
end

function RulesTest:ctor()
    self:testGetCardsType_()
    self:testIsBigger_()
    self:testTiShi_()
    self:testChaiZha_()
end

function RulesTest:testChaiZha_()
    local handCards = {104,204,304,404, 105,105,105, 414,414,414,414, 
        109,109,409,409,309,309,209,209, 106, 207, 107 ,308, 409,209,110,310,311}
    assert(DtzAlgorithm.isChaiZha({209, 209}, handCards))
    assert(DtzAlgorithm.isChaiZha({414}, handCards))
    assert(DtzAlgorithm.isChaiZha({104}, handCards))
    assert(not DtzAlgorithm.isChaiZha({104,204,304,404}, handCards))
    assert(not DtzAlgorithm.isChaiZha({105,105,105}, handCards))
    assert(DtzAlgorithm.isChaiZha({209}, handCards))

    local cards = {305,305,405,405,106,206,406,406,107,207,307,407,407,108,208,208,
        209,309,210,210,111,211,311,411,411,411,312,412,213,213,213,313,413,214,314,314,216,416,416}
    assert(not DtzAlgorithm.isChaiZha({108,208,208,209,309}, cards))
end

function RulesTest:testTiShi_()
    local handCards = {113,113,313,114,114,414}
    -- print(json.encode(handCards))
    local result = DtzAlgorithm.tishi({206,206}, handCards)
    assertEqualTable(result[1], {113,113})
    assertEqualTable(result[2], {114,114})

    local handCards = {207, 107, 207, 308, 308,208}
    -- print(json.encode(handCards))
    local result = DtzAlgorithm.tishi({306,206,206}, handCards)
    assertEqualTable(result[1], {107,207,207})
    assertEqualTable(result[2], {208,308,308})

    local handCards = {414,116,409,314,306,316,409,412,310,112,416,413,108,412,406,206,110,412,207,411,407,
        405,207,109,106,413,308,213,310,207,316,109,409,114,416,208,211,305,410,408,212}
    BaseAlgorithm.sort(handCards)
    -- print(json.encode(handCards))
    local result = DtzAlgorithm.tishi({}, handCards)
    -- dump(result)
    assertEqualTable(result[1], {407})
    assertEqualTable(result[2], {305,405})
    assertEqualTable(result[3], {109,109})
    assertEqualTable(result[4], {211,411})
    assertEqualTable(result[5], {112,212})
    assertEqualTable(result[6], {213,413,413})
    assertEqualTable(result[7], {114,314,414})
    assertEqualTable(result[8], {106,206,306,406})
    assertEqualTable(result[9], {108,208,308,408})
    assertEqualTable(result[10], {110,310,310,410})
    assertEqualTable(result[11], {116,316,316,416,416})
    assertEqualTable(result[12], {207,207,207})
    assertEqualTable(result[13], {409,409,409})
    assertEqualTable(result[14], {412,412,412})

    local cards1 = {303}  -- 测试单牌的提示
    local handCards = {104,204,304,404, 105,105,105, 414,414,414,414, 
        109,109,409,409,309,309,209,209, 106, 207, 107 ,308, 409,209,110,310,311}
    local result = DtzAlgorithm.tishi(cards1, handCards)
    -- {{106},{308},{311},{104,204,304,404},{105,105,105},{109,109,409,409,309,309,209,209},{414,414,414,414},{107},{209},{110}}
    assert(#result == 10)
    assert(result[1][1] == 106)
    assert(result[2][1] == 308)
    assert(result[3][1] == 311)
    assertEqualTable(result[4], {104,204,304,404})
    assertEqualTable(result[5], {105,105,105})
    assertEqualTable(result[6], {409,409,309,309,209,209,109,109})
    assertEqualTable(result[7], {414,414,414,414})
    assert(result[8][1] == 107 or result[8][1] == 207)
    assert(result[9][1] == 209 or result[9][1] == 409)
    assert(result[10][1] == 110 or result[10][1] == 310)

    local cards = {108,208}  -- 测试对子的提示
    local handCards = {106, 206, 306, 105, 205, 207, 107, 308, 409, 209, 214, 314, 520, 520, 311, 411, 211, 110, 310, 210}
    local result = DtzAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {209,409})
    assertEqualTable(result[2], {214,314})
    assertEqualTable(result[3], {520,520})
    assertEqualTable(result[4], {110,210})
    assertEqualTable(result[5], {211,311})

    local cards = {108,208,208}  -- 测试3带的提示
    local handCards = {106, 206, 306, 207, 107, 307, 311, 411, 211, 110, 310, 210, 108, 203, 303}
    local result = DtzAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {110,210,310,108,203})
    assertEqualTable(result[2], {211,311,411,108,203})

    local cards = {107,208,208,207}  -- 测试连对的提示
    local handCards = {103,103,103,104,104,204,206,206,212,212,308,408,409,209,210,110,109,109,109,214,214}
    local result = DtzAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {308,408,209,409})
    assertEqualTable(result[2], {209,409,110,210})
    assertEqualTable(result[3], {103,103,103})
    assertEqualTable(result[4], {109,109,109})

    local cards = {107,208,107,208,207,108}  -- 测试飞机的提示
    local handCards = {103,103,103,104,104,212,212,112,308,408,208,409,209,109,210,110,410,414,214,214,105,306}
    local result = DtzAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {208,308,408,109,209,409,105,306,104,104})
    assertEqualTable(result[2], {109,209,409,110,210,410,105,306,104,104})
    assertEqualTable(result[3], {103,103,103})

    -- 无牌时的提示
    local handCards = {103,103,103,104,104,212,212,112,308,408,208,409,209,109,210,110,410,414,214,214,105,306}
    local result = DtzAlgorithm.tishi(nil, handCards)
    assertEqualTable(result[1], {105})
    assertEqualTable(result[2], {306})
    assertEqualTable(result[3], {104,104})
    assertEqualTable(result[4], {208,308,408})
    assertEqualTable(result[5], {109,209,409})
    assertEqualTable(result[6], {110,210,410})
    assertEqualTable(result[7], {112,212,212})
    assertEqualTable(result[8], {214,214,414})
    assertEqualTable(result[9], {103,103,103})

    -- 炸弹的提示
    local handCards = {105,205,405,106,306,306,406,107,307,108,208,208,308,209,309,409,409,110,110,210,310,310,
                        111,411,212,312,412,213,213,313,413,114,214,214,314,414,116,216,216,316,416}
    local result = DtzAlgorithm.tishi({207,307,407,407}, handCards)
    assertEqualTable(result[1], {108,208,208,308})
    assertEqualTable(result[2], {209,309,409,409})
    assertEqualTable(result[3], {213,213,313,413})
    assertEqualTable(result[4], {110,110,210,310,310})
    assertEqualTable(result[5], {114,214,214,314,414})
    assertEqualTable(result[6], {116,216,216,316,416})

    local handCards = {205,405,206,206,306,207,108,208,308,308,408,309,309,409,409,111,111,411,212,312,312,412,
                        114,214,314,314,414,414,116,216,316}
    local result = DtzAlgorithm.tishi({106,106,206,306,406,406}, handCards)
    assertEqualTable(result[1], {114,214,314,314,414,414})

    local handCards = {306,306,406,107,209,309,409,110,410,111,113,213,114,214}
    local result = DtzAlgorithm.tishi({}, handCards)
    assertEqualTable(result[1], {107})
    assertEqualTable(result[2], {111})
    assertEqualTable(result[3], {110,410})
    assertEqualTable(result[4], {113,213})
    assertEqualTable(result[5], {114,214})
    assertEqualTable(result[6], {306,306,406})
    assertEqualTable(result[7], {209,309,409})
end

function RulesTest:testIsBigger_()
    -- 单张
    assert(DtzAlgorithm.isBigger({520}, {518}))
    assert(DtzAlgorithm.isBigger({518}, {516}))
    assert(DtzAlgorithm.isBigger({520}, {516}))
    assert(DtzAlgorithm.isBigger({410}, {409}))

    -- 对子
    assert(DtzAlgorithm.isBigger({520,520}, {518,518}))
    assert(DtzAlgorithm.isBigger({308,408}, {306,206}))
    assert(not DtzAlgorithm.isBigger({520,520}, {516}))
    assert(not DtzAlgorithm.isBigger({410,310}, {409,409,409}))

    -- 连对
    assert(DtzAlgorithm.isBigger({310,210,109,409}, {309,109,408,308}))
    assert(not DtzAlgorithm.isBigger({309,109,408,308}, {309,109,408,308}))
    assert(not DtzAlgorithm.isBigger({520,520,518,518}, {309,109,408,308}))
    assert(not DtzAlgorithm.isBigger({308,308,307,307,306,306}, {309,109,408,308}))
    assert(not DtzAlgorithm.isBigger({309,109,408,308}, {518}))

    -- 三带
    assert(DtzAlgorithm.isBigger({310,210,310,409}, {303,109,409,309,208}))
    assert(DtzAlgorithm.isBigger({310,210,310}, {303,109,409,309,209}))
    assert(not DtzAlgorithm.isBigger({310,210,310}, {303,109,310,210,310}))
    assert(not DtzAlgorithm.isBigger({310,210,310,107}, {303,109,210,310}))

    -- 飞机
    assert(DtzAlgorithm.isBigger({208,308,408,109,209,409,105,306,104,104},{107,208,107,208,207,108}))
    local a = {208,208,108,109,209,309,110,210,310,211,311,411,212,213,214}
    local b = {107,107,207,208,208,108,109,209,309,110,210,310}
    local c = {107,107,207,208,208,108,109,209,309}
    assert(DtzAlgorithm.isBigger(a, b))
    assert(DtzAlgorithm.isBigger(a, c))
    assert(DtzAlgorithm.isBigger({208,308,408,109,209,409,105,306,104,104},{107,208,107,208,207,108}))
    assert(DtzAlgorithm.isBigger({212,312,412,113,213,313,114,214,314},{105,205,305,106,306,406,408,310}))

    -- 炸弹
    assert(DtzAlgorithm.isBigger({310,210,310,110}, {109,409,309,209}))
    assert(DtzAlgorithm.isBigger({109,409,309,209,109}, {310,210,310,110}))
    assert(DtzAlgorithm.isBigger({310,210,310,110}, {303,109,310,210,310}))
    assert(DtzAlgorithm.isBigger({310,210,310,110}, {303,110,210,310}))
    assert(not DtzAlgorithm.isBigger({106,306,306,406}, {207,307,407,407}))
    assert(DtzAlgorithm.isBigger({110,110,210,310,310}, {213,213,313,413}))
    assert(not DtzAlgorithm.isBigger({106,306,306,406}, {205,305,405,405,105,105}))

    -- 筒子
    assert(DtzAlgorithm.isBigger({310,310,310}, {210,210,210}))
    assert(DtzAlgorithm.isBigger({110,110,110}, {209,209,209}))
    assert(DtzAlgorithm.isBigger({310,310,310}, {210,210,210,410}))

    -- 地炸
    assert(DtzAlgorithm.isBigger({110,110,410,410,310,310,210,210}, {414,414,414}))
    assert(DtzAlgorithm.isBigger({110,110,410,410,310,310,210,210}, {209,209,109,109,309,309,409,409}))

    -- 喜炸
    assert(DtzAlgorithm.isBigger({310,310,310,310}, {410,410,410}))
    assert(DtzAlgorithm.isBigger({310,310,310,310}, {210,210,210,210}))
    assert(DtzAlgorithm.isBigger({310,310,310,310}, {209,209,109,109,309,309,409,409}))
end

function RulesTest:testGetCardsType_()
    local cards = {}  -- 无牌
    local t, d = DtzCardType.getType(cards)
    assert(t == nil and d == nil)

    local cards = {102} -- 单张
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.DAN_ZHANG and d[1] == 2)
    
    local cards = {102,202}  -- 对子
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.DUI_ZI and d[1] == 2)

    local cards = {105,305,104,204,103,403}  -- 连对
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.LIAN_DUI and d[1] == 6 and d[2] == 3)

    local cards = {105, 205, 306, 104, 205}  -- 三带
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.SAN_DAI and d[1] == 5 and d[2] == 2)

    local cards = {105, 205, 306, 104, 205, 106, 206, 307, 108, 209}  -- 飞机
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.FEI_JI and d[1] == 2 and d[2] == 5 and d[3] == 4)

    local cards = {105, 205, 306, 405, 305, 307, 408}  -- 啥也不是
    local t, d = DtzCardType.getType(cards)
    assert(not t and not d)

    local cards = {203,204,205,206,207,208}  -- 啥也不是
    local t, d = DtzCardType.getType(cards)
    assert(not t and not d)

    local cards = {105,205,305,405}  -- 四炸
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.ZHA_DAN and d[1] == 4 and d[2] == 5)

    local cards = {105,205,305,405,105,205}  -- 六炸
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.ZHA_DAN and d[1] == 6 and d[2] == 5)

    local cards = {205,205,205}  -- 筒子
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.TONG_ZI and d[1] == 5 and d[2] == 2)

    local cards = {314,314,314}  -- 筒子
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.TONG_ZI and d[1] == 14 and d[2] == 3)

    local cards = {109,109,409,409,309,309,209,209}  -- 地炸
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.DI_ZHA and d[1] == 9)

    local cards = {108,108,108,108}  -- 喜炸
    local t, d = DtzCardType.getType(cards)
    assert(t == DtzCardType.XI_ZHA and d[1] == 8 and d[2] == 1)
end

return RulesTest
