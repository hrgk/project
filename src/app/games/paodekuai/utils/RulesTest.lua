local RulesTest = class("RulesTest", nil)
local BaseAlgorithm = import(".BaseAlgorithm")
local PdkAlgorithm = import(".PdkAlgorithm")

function RulesTest:ctor()
    -- self:huise_()
    self:testTiShi_()
    -- self:testIsBigger_()
end

function RulesTest:huise_()
    local cards1 = {306}
    local handerCards = {104,204,304,404, 106, 107 ,308, 409,209,110,310,311}
    PdkAlgorithm.getHuiSeCards_(cards1, handerCards)
end

function RulesTest:testTiShi_()
    local cards1 = {404,304,303,103}
    local handerCards = {307,207,306,106,305,205,105}
    dump(PdkAlgorithm.tishi(cards1, handerCards))

    -- local cards1 = {308, 208}
    -- local handerCards = {104, 104, 107 ,309,409,209,110,310,311}
    -- PdkAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308, 208, 108}
    -- local handerCards = {104, 104, 107 ,308, 209,409,109,309,110,210,410,311}
    -- PdkAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308, 208, 108,408}
    -- local handerCards = {104, 104, 107 ,308, 409,209,109,309,110,310,210,410,311}
    -- PdkAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {308}
    -- local handerCards = {104, 104, 107 ,308, 409,209,109,309,110,310,210,410,311}
    -- PdkAlgorithm.tishi(cards1, handerCards)

    -- local cards1 = {105,206,307,408,209}
    -- local handerCards = {105, 106, 107 ,308, 409,205,210,410,310,411}
    -- PdkAlgorithm.tishi(cards1, handerCards)
end

function RulesTest:testIsBigger_()
    local cards1 = {105}
    local cards2 = {104}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205}
    local cards2 = {104,204}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305}
    local cards2 = {104,204,304}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,306,406}
    local cards2 = {104,204,305,405}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,106,206,306}
    local cards2 = {104,204,304,103,203,303}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,206,307,408,209,310}
    local cards2 = {104,205,306,407,408,409}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304,404}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,305,405}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {104,204,304,103,203,303}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))

    local cards1 = {105,205,305,405}
    local cards2 = {105,206,307,408,209,310}
    assert(PdkAlgorithm.isBigger_(cards1, cards2))
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
    PdkAlgorithm.getCardType(cards1)
    PdkAlgorithm.getCardType(cards2)
    PdkAlgorithm.getCardType(cards3)
    PdkAlgorithm.getCardType(cards4)
    PdkAlgorithm.getCardType(cards5)
    PdkAlgorithm.getCardType(cards6)
    PdkAlgorithm.getCardType(cards7)
    PdkAlgorithm.getCardType(cards8)
end

return RulesTest
