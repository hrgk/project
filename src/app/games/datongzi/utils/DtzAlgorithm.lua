local BaseAlgorithm = import(".BaseAlgorithm")
local DtzCardType = import(".DtzCardType")
local DtzTiShi = import(".DtzTiShi")
local DtzAlgorithm = {}

function DtzAlgorithm.rank(rankType, cards, config)
    if rankType == 1 then
        cards = DtzAlgorithm.rankCommon(cards, config)
    elseif rankType == 2 then
        cards = DtzAlgorithm.rankCardsValue(cards, config)
    else
        cards = DtzAlgorithm.rankCommon(cards, config)
    end

    local tempCards1, tempCards2 = {}, {}
    for k, v in ipairs(cards) do
        if k > 22 then
            table.insert(tempCards1, v)
        else
            table.insert(tempCards2, v)
        end
    end

    return tempCards1, tempCards2
end

-- 根据牌型大小排序
function DtzAlgorithm.rankCardsValue(cards, config)
    local tishi = DtzAlgorithm.tishi({}, cards, config)
    local result = {}

    for _, tablet in ipairs(tishi) do
        for _, card in ipairs(tablet) do
            table.insert(result, card)
        end
    end

    return result
end

function DtzAlgorithm.rankCommon(cards, config)
    local tempCards = clone(cards)

    local pinkCards = DtzAlgorithm.getPinkCards(cards, config)
    local cardsMap = BaseAlgorithm.invert(pinkCards)

    table.sort(tempCards, function (lh, rh)
        local lhValue = BaseAlgorithm.getValue(lh)
        local rhValue = BaseAlgorithm.getValue(rh)
        if lhValue == rhValue then
            if (not cardsMap[lh]) == (not cardsMap[rh]) then
                return BaseAlgorithm.getSuit(lh) < BaseAlgorithm.getSuit(rh)
            end

            return not cardsMap[lh]
        end

        return lhValue < rhValue
    end)

    return tempCards
end

function DtzAlgorithm.sort(type, cards)
    BaseAlgorithm.sort(cards)
    return cards
end

-- 检测所出的牌是否是拆了更大的炸弹牌
function DtzAlgorithm.isChaiZha(cards, handCards, config)
    local tips = DtzTiShi.getTiShi(cards, handCards, config)
    for _,v in pairs(tips) do
        local cardType, cardData = DtzCardType.getType(v, config)
        if cardType == nil then
            dump(v)
        end
        if cardType >= DtzCardType.ZHA_DAN then
            for _,v2 in pairs(cards) do
                if table.indexof(v, v2) ~= false then
                    return true
                end
            end
        end
    end
    return false
end

function DtzAlgorithm.sortOutPokers(cards, config)
    local cards = clone(cards)
    BaseAlgorithm.sort(cards)
    local cardType, typeData = DtzCardType.getType(cards, config)
    if not cardType or (cardType ~= DtzCardType.SAN_DAI and cardType ~= DtzCardType.FEI_JI) then
        return cards, {}
    end
    local leftValues = {}
    if DtzCardType.SAN_DAI == cardType then
        table.insert(leftValues, typeData[1])
    elseif DtzCardType.FEI_JI == cardType then
        for i = typeData[2], typeData[2] + typeData[1] - 1 do
            table.insert(leftValues, i)
        end
    end
    local leftCards, rightCards = {}, {}
    local leftStat = {}
    for _,card in ipairs(cards) do
        local v = BaseAlgorithm.getValue(card)
        if table.indexof(leftValues, v) ~= false then
            if not leftStat[v] then
                leftStat[v] = 1
            else
                leftStat[v] = leftStat[v] + 1
            end
            if leftStat[v] <= 3 then
                table.insert(leftCards, card)
            else
                table.insert(rightCards, card)
            end
        else
            table.insert(rightCards, card)
        end
    end
    return leftCards, rightCards
end

function DtzAlgorithm.isBigger(cards1, cards2, config)
    local type1, data1 = DtzCardType.getType(cards1, config)
    if type1 ~= nil and #cards2 == 0 then
        return true
    end
    local type2, data2 = DtzCardType.getType(cards2, config)
    return DtzCardType.isBiggerCardType(type1, data1, type2, data2)
end

function DtzAlgorithm.getCardType(cards, config)
    return DtzCardType.getType(cards, config)
end

-- 牌中无3，4 所以，比三筒子打的牌都应该变粉色
function DtzAlgorithm.getPinkCards(handCards, config)
    local cardsList = DtzAlgorithm.tishi({103, 103, 103}, handCards, config)
    local cardsCountMap = {}
    for _, cards in ipairs(cardsList) do
        local tempCardsCountMap = {}
        for _, card in ipairs(cards) do
            tempCardsCountMap[card] = (tempCardsCountMap[card] or 0) + 1
        end

        for card, count in pairs(tempCardsCountMap) do
            cardsCountMap[card] = math.max(cardsCountMap[card] or 0, count)
        end
    end

    local result = {}
    for card, count in pairs(cardsCountMap) do
        for i = 1, count do
            table.insert(result, card)
        end
    end

    return result
end

function DtzAlgorithm.tishi(cards, handCards, config)
    return DtzTiShi.getTiShi(cards, handCards, config)
end

return DtzAlgorithm 
