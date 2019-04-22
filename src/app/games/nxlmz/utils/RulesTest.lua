local RulesTest = class("RulesTest", nil)
local BaseAlgorithm = import(".BaseAlgorithm")
local ZMZAlgorithm = import(".ZMZAlgorithm")

function RulesTest:ctor()
    -- self:huise_()
    self:testTiShi_()
    -- self:testIsBigger_()
end

function RulesTest:huise_()
    local cards1 = {306}
    local handerCards = {104,204,304,404, 106, 107 ,308, 409,209,110,310,311}
    ZMZAlgorithm.getHuiSeCards_(cards1, handerCards)
end

function RulesTest:testTiShi_()
    local cards1 = {404,304,303,103}
    local handerCards = {307,207,306,106,305,205,105}
    dump(ZMZAlgorithm.tishi(cards1, handerCards))

    -- local cards1 = {308, 208}
    -- local handerCards = {104, 104, 107 ,309,409,209,110,310,311}
    -- ZMZAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308, 208, 108}
    -- local handerCards = {104, 104, 107 ,308, 209,409,109,309,110,210,410,311}
    -- ZMZAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308, 208, 108,408}
    -- local handerCards = {104, 104, 107 ,308, 409,209,109,309,110,310,210,410,311}
    -- ZMZAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308}
    -- local handerCards = {104, 104, 107 ,308, 409,209,109,309,110,310,210,410,311}
    -- ZMZAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {105,206,307,408,209}
    -- local handerCards = {105, 106, 107 ,308, 409,205,210,410,310,411}
    -- ZMZAlgorithm.tishi(cards1, handerCards)
end

function RulesTest:testIsBigger_()
    local cards1 = {105}
    local cards2 = {104}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205}
    local cards2 = {104,204}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305}
    local cards2 = {104,204,304}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,306,406}
    local cards2 = {104,204,305,405}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,106,206,306}
    local cards2 = {104,204,304,103,203,303}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,206,307,408,209,310}
    local cards2 = {104,205,306,407,408,409}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304,404}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,305,405}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304,103,203,303}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {105,206,307,408,209,310}
    assert(ZMZAlgorithm.isBigger_(cards1, cards2))
end

function RulesTest:getCardsType_()
    local cards1 = {102}
    local cards2 = {102,202}
    local cards3 = {105,305,104,204}
    local cards4 = {105, 205, 306, 104, 205}
    local cards5 = {105, 205, 306, 104, 205,106, 206, 307, 108, 209}
    local cards6 = {105, 205, 306, 405, 305, 307,408}
    local cards7 = {203,204,205,206,207,208}
    local cards8 = {104,204,304,404}
    ZMZAlgorithm.getCardType(cards1)
    ZMZAlgorithm.getCardType(cards2)
    ZMZAlgorithm.getCardType(cards3)
    ZMZAlgorithm.getCardType(cards4)
    ZMZAlgorithm.getCardType(cards5)
    ZMZAlgorithm.getCardType(cards6)
    ZMZAlgorithm.getCardType(cards7)
    ZMZAlgorithm.getCardType(cards8)
end

return RulesTest
