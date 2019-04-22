local RulesTest = class("RulesTest", nil)
local BaseAlgorithm = import(".BaseAlgorithm")
local ShuangKouAlgorithm = import(".ShuangKouAlgorithm")
local ShuangKouCardType = import(".ShuangKouCardType")

local function assertEqualTable(a, b)
    assert(#a == #b)
    table.sort(a)
    table.sort(b)
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
    assert(ShuangKouAlgorithm.isChaiZha({209, 209}, handCards))
    assert(ShuangKouAlgorithm.isChaiZha({414}, handCards))
    assert(ShuangKouAlgorithm.isChaiZha({104}, handCards))
    assert(not ShuangKouAlgorithm.isChaiZha({104,204,304,404}, handCards))
    assert(not ShuangKouAlgorithm.isChaiZha({105,105,105}, handCards))
    assert(ShuangKouAlgorithm.isChaiZha({209}, handCards))

    local cards = {305,305,405,405,106,206,406,406,107,207,307,407,407,108,208,208,
        209,309,210,210,111,211,311,411,411,411,312,412,213,213,213,313,413,214,314,314,216,416,416}
    assert(not ShuangKouAlgorithm.isChaiZha({108,208,208,209,309}, cards))
end

function RulesTest:testTiShi_()
    local handCards = {113,113,313,114,114,414}
    -- print(json.encode(handCards))
    local result = ShuangKouAlgorithm.tishi({206,206}, handCards)
    assertEqualTable(result[1], {113,113})
    assertEqualTable(result[2], {114,114})

    local handCards = {207, 107, 207, 308, 308,208}
    -- print(json.encode(handCards))
    local result = ShuangKouAlgorithm.tishi({306,206,206}, handCards)
    assertEqualTable(result[1], {107,207,207})
    assertEqualTable(result[2], {208,308,308})

    local handCards = {105, 106, 107, 108, 109, 110, 111}
    local result = ShuangKouAlgorithm.tishi({103 ,204,205, 206, 207}, handCards)
    assertEqualTable(result[1], {105, 106, 107, 108, 109})
    assertEqualTable(result[2], {106, 107, 108, 109, 110})
    assertEqualTable(result[3], {107, 108, 109, 110, 111})

    local handCards = {103, 104, 204, 305, 105, 106, 106, 206, 107, 107, 207, 207, 307, 307}
    BaseAlgorithm.sort(handCards)
    local result = ShuangKouAlgorithm.tishi({}, handCards)

    assertEqualTable(result[1], {103})
    assertEqualTable(result[2], {104,204})


    local cards1 = {303}  -- 测试单牌的提示
    local handCards = {104,204,304,404, 105,105,105, 414,414,414,414, 
        109,109,409,409,309,309,209,209, 106, 207, 107 ,308,110,310,311}
    local result = ShuangKouAlgorithm.tishi(cards1, handCards)
    -- {{106},{308},{311},{104,204,304,404},{105,105,105},{109,109,409,409,309,309,209,209},{414,414,414,414},{107},{209},{110}}
    assert(#result == 9)
    assert(result[1][1] == 106)
    assert(result[2][1] == 308)
    assert(result[3][1] == 311)
    assertEqualTable(result[4], {104,204,304,404})
    assertEqualTable(result[5], {414,414,414,414})
    assertEqualTable(result[6], {409,409,309,309,209,209,109,109})
    assert(result[7][1] == 105)
    assert(result[8][1] == 207 or result[8][1] == 107)
    assert(result[9][1] == 310 or result[9][1] == 110)

    local cards = {108,208}  -- 测试对子的提示
    local handCards = {106, 206, 306, 105, 205, 207, 107, 308, 409, 209, 214, 314, 520, 520, 311, 411, 211, 110, 310, 210}
    local result = ShuangKouAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {209,409})
    assertEqualTable(result[2], {214,314})
    assertEqualTable(result[3], {520,520})
    assertEqualTable(result[4], {110,210})
    assertEqualTable(result[5], {211,311})

    local cards = {108,208,208}  -- 测试3带的提示
    local handCards = {106, 206, 306, 207, 107, 307, 311, 411, 211, 110, 310, 210, 108, 203, 303}
    local result = ShuangKouAlgorithm.tishi(cards, handCards)
    assertEqualTable(result[1], {110,210,310})
    assertEqualTable(result[2], {211,311,411})

    local cards = {107,208,208,207, 306, 306}  -- 测试连对的提示
    local handCards = {103,103,103,104,104,204,206,206,212,212,308,408,409,209,210,110,109,214,214}
    local result = ShuangKouAlgorithm.tishi(cards, handCards)
    dump(result)
    assertEqualTable(result[1], {308,408,109,209, 110, 210})

    -- 无牌时的提示
    local handCards = {103,103,103,104,104,212,212,112,308,408,208,409,209,109,210,110,410,414,214,214,105,306}
    local result = ShuangKouAlgorithm.tishi(nil, handCards)
    dump(result)
    assertEqualTable(result[1], {105})
    assertEqualTable(result[2], {306})
    assertEqualTable(result[3], {104,104})
    assertEqualTable(result[4], {103,103,103})
    assertEqualTable(result[5], {208,308,408})
    assertEqualTable(result[6], {109,209,409})
    assertEqualTable(result[7], {110,210,410})
    assertEqualTable(result[8], {112,212,212})
    assertEqualTable(result[9], {214,214,414})
    -- assertEqualTable(result[9], {103,103,103})

    -- 炸弹的提示
    local handCards = {105,205,405,106,306,306,406,107,307,108,208,208,308,209,309,409,409,110,110,210,310,310,
                        111,411,212,312,412,213,213,313,413,114,214,214,314,414,116,216,216,316,416}
    local result = ShuangKouAlgorithm.tishi({207,307,407,407}, handCards)
    assertEqualTable(result[1], {108,208,208,308})
    assertEqualTable(result[2], {209,309,409,409})
    assertEqualTable(result[3], {213,213,313,413})
    assertEqualTable(result[4], {110,110,210,310,310})
    assertEqualTable(result[5], {114,214,214,314,414})
    assertEqualTable(result[6], {116,216,216,316,416})

    local handCards = {205,405,206,206,306,207,108,208,308,308,408,309,309,409,409,111,111,411,212,312,312,412,
                        114,214,314,314,414,414,116,216,316}
    local result = ShuangKouAlgorithm.tishi({106,106,206,306,406,406}, handCards)
    assertEqualTable(result[1], {114,214,314,314,414,414})

    local handCards = {306,306,406,107,209,309,409,110,410,111,113,213,114,214}
    local result = ShuangKouAlgorithm.tishi({}, handCards)
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
    assert(ShuangKouAlgorithm.isBigger({520}, {518}))
    assert(ShuangKouAlgorithm.isBigger({518}, {516}))
    assert(ShuangKouAlgorithm.isBigger({520}, {516}))
    assert(ShuangKouAlgorithm.isBigger({410}, {409}))

    -- 对子
    assert(ShuangKouAlgorithm.isBigger({520,520}, {518,518}))
    assert(ShuangKouAlgorithm.isBigger({308,408}, {306,206}))
    assert(not ShuangKouAlgorithm.isBigger({520,520}, {516}))
    assert(not ShuangKouAlgorithm.isBigger({410,310}, {409,409,409}))

    assert(not ShuangKouAlgorithm.isBigger({520,520}, {518}))
    assert(not ShuangKouAlgorithm.isBigger({518}, {520, 520}))

    -- 连对
    assert(ShuangKouAlgorithm.isBigger({310,210,109,409, 308, 208}, {309,109,408,308, 207, 307}))
    assert(not ShuangKouAlgorithm.isBigger({309,109,408,308}, {309,109,408,308}))
    assert(not ShuangKouAlgorithm.isBigger({520,520,518,518}, {309,109,408,308}))
    assert(not ShuangKouAlgorithm.isBigger({308,308,307,307,306,306}, {309,109,408,308}))
    assert(not ShuangKouAlgorithm.isBigger({309,109,408,308}, {518}))

    -- 三带
    assert(ShuangKouAlgorithm.isBigger({310,210,310}, {109,409,309}))
    assert(not ShuangKouAlgorithm.isBigger({310,210,310}, {310,210,310}))

    -- -- 飞机
    -- assert(ShuangKouAlgorithm.isBigger({208,308,408,109,209,409,105,306,104,104},{107,208,107,208,207,108}))
    -- local a = {208,208,108,109,209,309,110,210,310,211,311,411,212,213,214}
    -- local b = {107,107,207,208,208,108,109,209,309,110,210,310}
    -- local c = {107,107,207,208,208,108,109,209,309}
    -- assert(ShuangKouAlgorithm.isBigger(a, b))
    -- assert(ShuangKouAlgorithm.isBigger(a, c))
    -- assert(ShuangKouAlgorithm.isBigger({208,308,408,109,209,409,105,306,104,104},{107,208,107,208,207,108}))
    -- assert(ShuangKouAlgorithm.isBigger({212,312,412,113,213,313,114,214,314},{105,205,305,106,306,406,408,310}))

    -- 炸弹
    assert(ShuangKouAlgorithm.isBigger({310,210,310,110}, {109,409,309,209}))
    assert(ShuangKouAlgorithm.isBigger({109,409,309,209,109}, {310,210,310,110}))
    assert(ShuangKouAlgorithm.isBigger({310,210,310,110}, {310,210,310}))
    assert(ShuangKouAlgorithm.isBigger({310,210,310,110}, {110,210,310}))
    assert(not ShuangKouAlgorithm.isBigger({106,306,306,406}, {207,307,407,407}))
    assert(ShuangKouAlgorithm.isBigger({110,110,210,310,310}, {213,213,313,413}))
    assert(not ShuangKouAlgorithm.isBigger({106,306,306,406}, {205,305,405,405,105,105}))

    -- 筒子
    -- assert(ShuangKouAlgorithm.isBigger({310,310,310}, {210,210,210}))
    -- assert(ShuangKouAlgorithm.isBigger({110,110,110}, {209,209,209}))
    -- assert(ShuangKouAlgorithm.isBigger({310,310,310}, {210,210,210,410}))

    -- 地炸
    -- assert(ShuangKouAlgorithm.isBigger({110,110,410,410,310,310,210,210}, {414,414,414}))
    -- assert(ShuangKouAlgorithm.isBigger({110,110,410,410,310,310,210,210}, {209,209,109,109,309,309,409,409}))

    -- 喜炸
    -- assert(ShuangKouAlgorithm.isBigger({310,310,310,310}, {410,410,410}))
    -- assert(ShuangKouAlgorithm.isBigger({310,310,310,310}, {210,210,210,210}))
    -- assert(ShuangKouAlgorithm.isBigger({310,310,310,310}, {209,209,109,109,309,309,409,409}))
end

function RulesTest:testGetCardsType_()
    local cards = {}  -- 无牌
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == nil and d == nil)

    local cards = {102} -- 单张
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.DAN_ZHANG and d[1] == 2)
    
    local cards = {102,202}  -- 对子
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.DUI_ZI and d[1] == 2)

    local cards = {105,305,104,204,103,403}  -- 连对
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.LIAN_DUI and d[1] == 6 and d[2] == 3)

    local cards = {105, 205, 306, 104, 205}  -- 三带
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == nil and d == nil)

    local cards = {105, 205, 205}  -- 三带
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.SAN_DAI and d[1] == 5 and d[2] == 0)

    local cards = {105, 205, 306, 405, 305, 307, 408}  -- 啥也不是
    local t, d = ShuangKouCardType.getType(cards)
    assert(not t and not d)

    local cards = {203,204,205,206,207,208}  -- 顺子
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.SHUN_ZI and d[1] == 6 and d[2] == 3)

    local cards = {203,204,205,206,207}  -- 顺子
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.SHUN_ZI and d[1] == 5 and d[2] == 3)


    local cards = {105,205,305,405}  -- 四炸
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.ZHA_DAN and d[1] == 4 and d[2] == 5)

    local cards = {105,205,305,405,105,205}  -- 六炸
    local t, d = ShuangKouCardType.getType(cards)
    assert(t == ShuangKouCardType.ZHA_DAN and d[1] == 6 and d[2] == 5)

    -- local cards = {205,205,205}  -- 筒子
    -- local t, d = ShuangKouCardType.getType(cards)
    -- assert(t == ShuangKouCardType.TONG_ZI and d[1] == 5 and d[2] == 2)

    -- local cards = {314,314,314}  -- 筒子
    -- local t, d = ShuangKouCardType.getType(cards)
    -- assert(t == ShuangKouCardType.TONG_ZI and d[1] == 14 and d[2] == 3)

    -- local cards = {109,109,409,409,309,309,209,209}  -- 地炸
    -- local t, d = ShuangKouCardType.getType(cards)
    -- assert(t == ShuangKouCardType.DI_ZHA and d[1] == 9)

    -- local cards = {108,108,108,108}  -- 喜炸
    -- local t, d = ShuangKouCardType.getType(cards)
    -- assert(t == ShuangKouCardType.XI_ZHA and d[1] == 8 and d[2] == 1)
end

return RulesTest
