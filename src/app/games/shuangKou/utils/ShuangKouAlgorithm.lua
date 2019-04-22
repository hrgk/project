local BaseAlgorithm = import(".BaseAlgorithm")
local ShuangKouCardType = import(".ShuangKouCardType")
local ShuangKouTiShi = import(".ShuangKouTiShi")
local ShuangKouAlgorithm = {}

function ShuangKouAlgorithm.rank(rankType, cards)
    if rankType == 1 then
        cards = ShuangKouAlgorithm.rankCommon(cards)
    elseif rankType == 2 then
        cards = ShuangKouAlgorithm.rankRevert(cards)
    else
        cards = ShuangKouAlgorithm.rankCommon(cards)
    end

    local tempCards1, tempCards2 = {}, {}
    for k, v in ipairs(cards) do
        if k > 27 then
            table.insert(tempCards1, v)
        else
            table.insert(tempCards2, v)
        end
    end

    return tempCards1, tempCards2
end

function ShuangKouAlgorithm.getAllPropaganda(cards, handCards, config)
    local result = {}
    local propagandaList = {
        {{4, 4, 4}},
        {{5, 5}, {4, 4, 5}, {4, 4, 4, 4}},
        {{5, 6}, {4, 5, 5}, {4, 4, 4, 5}, {4, 4, 6}, {4, 4, 4, 4, 4}},
        {{5, 7}, {6, 6}, {4, 4, 7}, {5, 5, 5}, {4, 4, 5, 5}, {4, 4, 4, 6}, {4, 4, 4, 4, 4, 4}},
    }

    for _, card in pairs(cards) do
        table.removebyvalue(handCards, card, false)
    end
    
    local handCards, laiZi = ShuangKouCardType.filterBianPai(handCards, config.bianPai)
    local laiZiCount = #laiZi

    local list = gailun.utils.getList(BaseAlgorithm.getValueMap(handCards))
    table.sort(list, function (a, b)
        return #a < #b
    end)

    for ratio, propaganda in pairs(propagandaList) do
        for _, combinations in pairs(propaganda) do
            local isOk = ShuangKouAlgorithm.checkBombCount(ratio, cards, list, combinations, laiZiCount)
            if isOk then
                if result[ratio] == nil then
                    result[ratio] = {}
                end
                table.insert(result[ratio], combinations)
            end
        end
    end

    return result
end

function ShuangKouAlgorithm.checkBombCount(ratio, cards, handCards, combination, laiZiCount)
    local count = #cards
    laiZiCount = laiZiCount or 0
    combination = clone(combination)
    handCards = clone(handCards)
    table.sort(combination)
    local index = 0
    for k = #combination, 1, -1 do
        local v = combination[k]
        if (ratio >= 4 and count >= v) or (count == v) then
            index = k
            break
        end
    end

    if index == 0 then
        return false
    end

    table.remove(combination, index)
    
    -- print(laiZiCount, "asdfasdfasdf")

    for i = #combination, 1, -1 do
        local needCount = combination[i]
        local isOk = false
        for handsI = #handCards, 1, -1 do
            local nowCards = handCards[handsI]
            local lackCount = #nowCards - needCount
            -- print(#nowCards, needCount, laiZiCount)
            -- dump(handCards)
            if lackCount >= 0 then
                isOk = true
                handCards[handsI] = gailun.utils.intercept(nowCards, #nowCards - needCount)
                if #handCards[handsI] == 0 then
                    table.remove(handCards, handsI)
                end
                break
            elseif laiZiCount + lackCount >= 0 then
                isOk = true
                table.remove(handCards, handsI)
                laiZiCount = laiZiCount + lackCount
                break
            end
        end

        if not isOk then
            return false
        end
    end

    return true
end

function ShuangKouAlgorithm.checkCombination(cardsList, combinations)
    combinations = clone(combinations)
    table.sort(combinations)

    for _, cards in pairs(cardsList) do
        if #combinations == 0 then
            return true
        end

        if #cards >= combinations[1] then
            table.remove(combinations, 1)
        end
    end

    if #combinations == 0 then
        return true
    end

    return false
end

function ShuangKouAlgorithm.rankRevert(cards)
    local pinkCards = ShuangKouAlgorithm.getPinkCards(cards)
    local cardsMap = BaseAlgorithm.invert(pinkCards)

    local result = clone(cards)
    table.sort(result, function (lh, rh)
        local lhValue = BaseAlgorithm.getValue(lh)
        local rhValue = BaseAlgorithm.getValue(rh)
        if lhValue == rhValue then
            if (not cardsMap[lh]) == (not cardsMap[rh]) then
                return BaseAlgorithm.getSuit(lh) > BaseAlgorithm.getSuit(rh)
            end

            return not cardsMap[lh]
        end

        return lhValue > rhValue
    end)

    return result
end

-- 根据牌型大小排序
function ShuangKouAlgorithm.rankCardsValue(cards)
    local tishi = ShuangKouAlgorithm.tishi({}, cards)
    local result = {}

    for _, tablet in ipairs(tishi) do
        for _, card in ipairs(tablet) do
            table.insert(result, card)
        end
    end

    return result
end

function ShuangKouAlgorithm.rankCommon(cards)
    local tempCards = clone(cards)

    local pinkCards = ShuangKouAlgorithm.getPinkCards(cards)
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

function ShuangKouAlgorithm.sort(type, cards)
    BaseAlgorithm.sort(cards)
    return cards
end

-- 检测所出的牌是否是拆了更大的炸弹牌
function ShuangKouAlgorithm.isChaiZha(cards, handCards)
    return false
end

function ShuangKouAlgorithm.isZha(cards, bianPai)
    return (ShuangKouCardType.getType(cards, bianPai) or 0) >= ShuangKouCardType.ZHA_DAN
end

function ShuangKouAlgorithm.sortOutPokers(cards)
    local cards = clone(cards)
    BaseAlgorithm.sort(cards)
    local cardType, typeData = ShuangKouCardType.getType(cards)
    if not cardType or (cardType ~= ShuangKouCardType.SAN_DAI and cardType ~= ShuangKouCardType.FEI_JI) then
        return cards, {}
    end
    local leftValues = {}
    if ShuangKouCardType.SAN_DAI == cardType then
        table.insert(leftValues, typeData[1])
    elseif ShuangKouCardType.FEI_JI == cardType then
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

function ShuangKouAlgorithm.isBigger(cards1, cards2, config)
    local type1, data1 = ShuangKouCardType.getType(cards1,config.bianPai)
    if type1 ~= nil and #cards2 == 0 then
        return true
    end
    local type2, data2 = ShuangKouCardType.getType(cards2,config.bianPai)

    return ShuangKouCardType.isBiggerCardType(type1, data1, type2, data2)
end

function ShuangKouAlgorithm.getCardType(cards, config)
    dump(config,"configconfig")
    return ShuangKouCardType.getType(cards,config.bianPai)
end

--所有的炸弹都变色
function ShuangKouAlgorithm.getPinkCards(handCards)
    local result = {}
    local resInfo,changeInfo,maxCout = ShuangKouCardType.getCardDataByValue(handCards,0)
	for key,value in pairs(resInfo) do
		if #value > 3 then
            for i = 1,#value do
                table.insert(result, value[i])
            end
		end 
	end
    return result
end

function ShuangKouAlgorithm.tishi(cards, handCards, config)
    return ShuangKouTiShi.getTiShi(cards, handCards, config)
end

return ShuangKouAlgorithm 
