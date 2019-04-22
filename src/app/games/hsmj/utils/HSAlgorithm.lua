local unpack = unpack or table.unpack
local BaseAlgorithm = import(".BaseAlgorithm")

local HSAlgorithm = {}

local _ipairs, _pairs = ipairs, pairs

-- 是否能吃胡
function HSAlgorithm.canChiHu(cards, addCards)
    local cards = clone(cards)
    table.insert(cards, addCards)
    if HSAlgorithm.isSevenPairs_(cards) then
        return true, {}
    end
    return HSAlgorithm.canHu_(cards)
end

-- 是否能自摸胡
function HSAlgorithm.canZiMoHu(cards, isFirstHand)
    local cards = clone(cards)
    if HSAlgorithm.isSevenPairs_(cards) then
        return true
    end
    return HSAlgorithm.canHu_(cards)
end

-- 统计整组牌张数量
function HSAlgorithm.getCountListByValue_(list)
    local countList = {}
    table.walk(list, function (value, key)
        if not countList[value] then
            countList[value] = 1
        else
            countList[value] = countList[value] + 1
        end
    end)
    return countList
end

-- 搜索可组成对子的牌的列表
function HSAlgorithm.searchPairs_(list)
    local countList = HSAlgorithm.getCountListByValue_(list)
    local result = {}
    for card,count in _pairs(countList) do
        if count >= 2 then
            table.insert(result, card)
        end
    end
    return result
end

-- 计算刻子列表, 以及必须被满足的牌列表
function HSAlgorithm.checkValueIsValidWithNaiZi_(list, stepData, index, hzCount)
    local calcList = clone(list)
    local v = list[1]
    local hzChangeList = {}
    if not stepData[index][1] then
        stepData[index][1] = true
        if false ~= table.indexof(list, v + 1) and false ~= table.indexof(list, v + 2) then
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v + 1, false)
            table.removebyvalue(list, v + 2, false)
            return true, list, hzCount, hzChangeList
        end

        local usedHz = 0
        if false == table.indexof(list, v + 1) and hzCount > usedHz then  -- 使用一次红中
            usedHz = usedHz + 1
            table.insert(hzChangeList, v+ 1)
        end

        if false == table.indexof(list, v + 2) and hzCount > usedHz then  -- 使用一次红中
            usedHz = usedHz + 1
            if v + 2 <= 9 then
                table.insert(hzChangeList, v + 2)
            else
                table.insert(hzChangeList, v - 1)
            end
        end

        if usedHz > 0 and hzCount >= usedHz then  -- 使用红中步进成功
            hzCount = hzCount - usedHz
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v + 1, false)
            table.removebyvalue(list, v + 2, false)
            return true, list, hzCount, hzChangeList
        else
            hzChangeList = {}
        end
    end

    if not stepData[index][2] then
        stepData[index][2] = true
        local count = BaseAlgorithm.calcValueCount_(list, v)
        if 3 <= count then
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v, false)
            return true, list, hzCount, hzChangeList
        end
        if hzCount > 0 and hzCount >= 3 - count then
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v, false)
            table.removebyvalue(list, v, false)
            hzCount = hzCount - (3 - count)
            gailun.utils.extends(hzChangeList, gailun.utils.multiUnitList({v}, 3 - count))
            return true, list, hzCount, hzChangeList
        end
    end
    return false, calcList, hzCount, hzChangeList
end

--[[
检测某花色是否符合游戏规则（带红中检测）
从最左边的牌往右依次来检测，当成顺或成刻时，此路通
当即不成顺又不成刻时，此路不通
当此路通时，往下循环，到达终点时则是成功
当此路不通时，往上回退一步，如果上一步已经检测了顺和刻，则再回退一步，
直到可以选择下一步或者回到了起点。
]]
function HSAlgorithm.checkValueMatchRuleWithNaiZiCount_(list, index, stepData, hzCount, isBack)
    table.sort(list)
    if 0 == #list then  -- 到达终点
        return true, hzCount, stepData
    end

    if not stepData[index] then
        stepData[index] = {false, false, 0, {}}  -- 顺子是否已检测，刻子是否已检测，红中数量，牌值列表
    end
    if not isBack then
        stepData[index][3] = hzCount  -- 记录红中数量
        stepData[index][4] = clone(list)  -- 记录此时的牌值列表
    end

    local flag, newList, newHzCount, newHzChangeValue = HSAlgorithm.checkValueIsValidWithNaiZi_(list, stepData, index, hzCount)

    stepData[index][5] = newHzChangeValue
    if flag then  -- 检查规则符合，往前一步
        return HSAlgorithm.checkValueMatchRuleWithNaiZiCount_(newList, index + 1, stepData, newHzCount)
    end
    if index > 1 then  -- 后退
        for i = index, #stepData do  -- 清理之前的搜索数据
            stepData[i] = nil
        end
        local oldHZCount, oldList = stepData[index - 1][3], stepData[index - 1][4]
        return HSAlgorithm.checkValueMatchRuleWithNaiZiCount_(oldList, index - 1, stepData, oldHZCount, true)
    end

    if 1 == index then  -- 回到起点
        return false, hzCount, stepData
    end

    return false, hzCount, stepData
end

-- 判断牌值的分组是否符合麻将的顺子、刻子的规则
function HSAlgorithm.isGroupMatchRule_(list)
    local huPath = {}
    table.sort(list)
    if 0 == #list then
        return true, huPath
    end

    local isKeZi, _ = BaseAlgorithm.isValueKeZi_(list)
    local isShunZi, _ = BaseAlgorithm.isValueShunZi_(list)
    if isKeZi or isShunZi then
        table.insert(huPath, list)
        return true, huPath
    end
    
    local keZiList, mustList = HSAlgorithm.calcKeZiListAndMustList_(list)
    
    if 0 == #mustList then  -- 没有牌需要被顺子
        return true, huPath
    end

    for _, card in _ipairs(keZiList) do
        table.insert(huPath, gailun.utils.multiUnitList({card}, 3))
    end

    if 0 == #keZiList then -- 没有刻子，则全部都必须是顺子
        local flag, shunZiPath = BaseAlgorithm.isValueShunZi_(list)
        table.insert(huPath, shunZiPath)
        return flag, huPath
    end

    table.sort(mustList)
    local isShunZi, shunZiPath = BaseAlgorithm.isValueShunZi_(mustList)
    if isShunZi then  -- 待满足的牌已经成顺子
        table.insert(huPath, shunZiPath)
        return true, huPath
    end

    table.sort(keZiList)
    for _, v in _ipairs(keZiList) do  -- 依次填入刻子来检查是否符合要求
        local tmpValues = clone(mustList)
        table.insert(tmpValues, v)
        table.insert(tmpValues, v)
        table.insert(tmpValues, v)
        table.sort(tmpValues)
        local isShunZi, shunZiPath = BaseAlgorithm.isValueShunZi_(tmpValues)
        if isShunZi then
            gailun.utils.extends(huPath, shunZiPath)
            return true, huPath
        end
    end

    return false, {}
end

-- 判断能否以此为将牌胡牌
function HSAlgorithm.canHuByJiang_(cards, card)
    local cards = clone(cards)
    table.removebyvalue(cards, card, false)  -- 移除两张将牌
    table.removebyvalue(cards, card, false)
    local huPath = {}
    local group = BaseAlgorithm.groupBySuit(cards)
    for suit, list in _pairs(group) do
        if #list % 3 ~= 0 then
            return false, {}
        end
        local flag, unitHuPath = HSAlgorithm.isGroupMatchRule_(clone(list))

        if not flag then
            return false, {}
        end
        for _, path in _pairs(unitHuPath) do
            local unitPath = gailun.utils.map(path, function (value)
                return suit * 10 + value
            end)

            table.insert(huPath, unitPath)
        end

    end

    table.insert(huPath, {card, card})
    return true, huPath
end

-- 不带癞子判断胡牌
function HSAlgorithm.canHuWithoutNaiZi_(cards)
    local pairList = HSAlgorithm.searchPairs_(cards)
    for _,card in _ipairs(pairList) do
        local flag, path = HSAlgorithm.canHuByJiang_(cards, card)
        if flag then  -- 只要找到一种胡法就返回
            return true, path
        end
    end
    return false, path
end

-- 判断胡牌的总循环
function HSAlgorithm.canHu_(cards)
    if #cards % 3 ~= 2 then  -- 不成牌组的数量
        return false, {}
    end
    local cards = clone(cards)
    return HSAlgorithm.canHuWithoutNaiZi_(cards)
end

function HSAlgorithm.searchChi(handCards, card)
    local chiList = {}
    local cardNext1Exist = table.indexof(handCards, card + 1)
    local cardNext2Exist = table.indexof(handCards, card + 2)
    local cardBefore1Exist = table.indexof(handCards, card - 1)
    local cardBefore2Exist = table.indexof(handCards, card - 2)
    if cardNext1Exist and cardNext2Exist then
        table.insert( chiList, {card, card + 1, card + 2})
    end
    if cardNext1Exist and cardBefore1Exist then
        table.insert( chiList, {card - 1, card, card + 1})
    end
    if cardBefore1Exist and cardBefore2Exist then
        table.insert( chiList, {card - 2, card - 1, card})
    end

    return chiList
end

function HSAlgorithm.calcKeZiListAndMustList_(cards)
    local countMap = BaseAlgorithm.getCountListByValue(cards)
    local keZiList, mustList = {}, {}

    for card, count in _pairs(countMap) do
        if count == 1 then
            table.insert(mustList, card)
        elseif count == 2 then
            table.insert(mustList, card)
            table.insert(mustList, card)
        elseif count == 3 then
            table.insert(keZiList, card)
        elseif count == 4 then
            table.insert(mustList, card)
            table.insert(keZiList, card)
        end
    end

    return keZiList, mustList
end

function HSAlgorithm.isSevenPairs_(cards)
    -- """判断是否7小对"""
    if not cards or #cards ~= 14 then
        return False, {}
    end

    cards = clone(cards)
    local countList = BaseAlgorithm.getCountListByValue(cards)
    local singles = {}
    for card, count in _pairs(countList) do
        if count == 1 or count == 3 then
            table.insert(singles, card)
        end
    end

    local singlesLen = #singles
    if singlesLen <= 0 then
        local result = {}
        for card, count in _pairs(countList) do
            for i = 1, count do
                table.insert(result, card)
            end
        end
        return true, result
    end

    local singlesPath = {}
    for _, card in _ipairs(singles) do
        local alreadyCount = countList[card]
        for i = 1, alreadyCount do
            table.insert(singlesPath, card)
        end

        table.insert(singlesPath, naiZI)
    end

    return false, {}
end

function HSAlgorithm.getRemainCards(handCards, qiPaiCards, waiCards,fengPai)
    local allCards = nil
    if fengPai then
        allCards = gailun.utils.invert(BaseAlgorithm.makeAllCards())
    else
        allCards = gailun.utils.invert(BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3}))
    end
    dump(allCards,"allCardsallCardsallCards")
    for k, v in _pairs(allCards) do
        allCards[k] = 4
    end

	for _, v in _ipairs(handCards) do
		for _, card in _ipairs(v) do
			if allCards[card] ~= nil then
				allCards[card] = allCards[card] - 1
			end
		end
	end

	for _, v in _ipairs(qiPaiCards) do
		for _, card in _ipairs(v) do
			if allCards[card] ~= nil then
				allCards[card] = allCards[card] - 1
			end
		end
	end

	for _, playerWaiPaiList in _ipairs(waiCards) do
		for _, waiPai in _ipairs(playerWaiPaiList) do
			for i = 1, #waiPai.cards, 1 do
				local card = waiPai.cards[i]
				if card == nil then
					break
				end

				if allCards[card] ~= nil then
					allCards[card] = allCards[card] - 1
				end
			end
		end
	end

    return allCards
end

function HSAlgorithm.getTingPai(remainCards,cards,fengPai)
    remainCards = remainCards or HSAlgorithm.getRemainCards({}, {}, {},fengPai)
    local result = {}
    local huResultIndex = 0
    for card, count in _pairs(remainCards) do
        local isHu, path = HSAlgorithm.canChiHu(cards, card)
		if isHu then
            huResultIndex = huResultIndex + 1
            result[huResultIndex] = {
                value = card,
                num = count
            }
		end
	end
    local function cmp(a,b)
        if BaseAlgorithm.getSuit(a.value) ~= BaseAlgorithm.getSuit(b.value) then
            return BaseAlgorithm.getSuit(a.value) > BaseAlgorithm.getSuit(b.value)
        else
            return BaseAlgorithm.getValue(a.value) < BaseAlgorithm.getValue(b.value)
        end
    end
    table.sort(result,cmp)
    dump(result,"resultresultresult")
	return result
end

function HSAlgorithm.isTingPai(cards, fengPai)
    local remainCards = nil
    if fengPai then
        remainCards = BaseAlgorithm.makeAllCards()
    else
        remainCards = BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3})
    end
    for _, card in _pairs(remainCards) do
        local isHu, path = HSAlgorithm.canChiHu(cards, card)
		if isHu then
			return true
		end
	end
	return false
end

function HSAlgorithm.getTingOperate(cards, fengPai)
    local result = {}
    for _, card in _pairs(cards) do
        local handCards = clone(cards)
        table.removebyvalue(handCards, card)
        local isTing = HSAlgorithm.isTingPai(handCards, fengPai)
		if isTing then
			table.insert(result, card)
		end
    end
    
    return result
end

return HSAlgorithm
