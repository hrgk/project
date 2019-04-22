local unpack = unpack or table.unpack
local BaseAlgorithm = import(".BaseAlgorithm")

local ZZAlgorithm = {}

local _ipairs, _pairs = ipairs, pairs

-- 是否能吃胡
function ZZAlgorithm.canChiHu(cards, addCards, allowSevenPairs)
    local cards = clone(cards)
    if cards == BaseAlgorithm.NAI_ZI then  -- 红中不允许吃胡
        return false, {}
    end
    table.insert(cards, addCards)
    local hzCount = BaseAlgorithm.calcValueCount_(cards, BaseAlgorithm.NAI_ZI)
    if allowSevenPairs and ZZAlgorithm.isSevenPairs_(cards, BaseAlgorithm.NAI_ZI) then
        return true, {}
    end
    return ZZAlgorithm.canHu_(cards)
end

-- 是否能自摸胡
function ZZAlgorithm.canZiMoHu(cards, allowSevenPairs, isFirstHand)
    local cards = clone(cards)
    local hzCount = BaseAlgorithm.calcValueCount_(cards, BaseAlgorithm.NAI_ZI)
    if isFirstHand and 14 == #cards and 4 == hzCount then  -- 红中起手胡牌
        return true
    end
    if allowSevenPairs and ZZAlgorithm.isSevenPairs_(cards, BaseAlgorithm.NAI_ZI) then
        return true
    end
    return ZZAlgorithm.canHu_(cards)
end

-- 统计整组牌张数量
function ZZAlgorithm.getCountListByValue_(list)
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
function ZZAlgorithm.searchPairs_(list)
    local countList = ZZAlgorithm.getCountListByValue_(list)
    local result = {}
    for card,count in _pairs(countList) do
        if count >= 2 then
            table.insert(result, card)
        end
    end
    return result
end

-- 计算刻子列表, 以及必须被满足的牌列表
function ZZAlgorithm.checkValueIsValidWithNaiZi_(list, stepData, index, hzCount)
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
function ZZAlgorithm.checkValueMatchRuleWithNaiZiCount_(list, index, stepData, hzCount, isBack)
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

    local flag, newList, newHzCount, newHzChangeValue = ZZAlgorithm.checkValueIsValidWithNaiZi_(list, stepData, index, hzCount)

    stepData[index][5] = newHzChangeValue
    if flag then  -- 检查规则符合，往前一步
        return ZZAlgorithm.checkValueMatchRuleWithNaiZiCount_(newList, index + 1, stepData, newHzCount)
    end
    if index > 1 then  -- 后退
        for i = index, #stepData do  -- 清理之前的搜索数据
            stepData[i] = nil
        end
        local oldHZCount, oldList = stepData[index - 1][3], stepData[index - 1][4]
        return ZZAlgorithm.checkValueMatchRuleWithNaiZiCount_(oldList, index - 1, stepData, oldHZCount, true)
    end

    if 1 == index then  -- 回到起点
        return false, hzCount, stepData
    end

    return false, hzCount, stepData
end

-- 判断牌值的分组是否符合麻将的顺子、刻子的规则
function ZZAlgorithm.isGroupMatchRule_(list)
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
    
    local keZiList, mustList = ZZAlgorithm.calcKeZiListAndMustList_(list)
    
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
function ZZAlgorithm.canHuByJiang_(cards, card)
    local cards = clone(cards)
    table.removebyvalue(cards, card, false)  -- 移除两张将牌
    table.removebyvalue(cards, card, false)
    local huPath = {}
    local group = BaseAlgorithm.groupBySuit(cards)
    for suit, list in _pairs(group) do
        if #list % 3 ~= 0 then
            return false, {}
        end
        local flag, unitHuPath = ZZAlgorithm.isGroupMatchRule_(clone(list))

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
function ZZAlgorithm.canHuWithoutNaiZi_(cards)
    local pairList = ZZAlgorithm.searchPairs_(cards)
    for _,card in _ipairs(pairList) do
        local flag, path = ZZAlgorithm.canHuByJiang_(cards, card)
        if flag then  -- 只要找到一种胡法就返回
            return true, path
        end
    end

    return false, path
end

function ZZAlgorithm.canHuWithPairsAndJiang(cards, naiZiCount, removeJiang, naiZi)
    naiZi = naiZi or BaseAlgorithm.NAI_ZI

    local pairList = BaseAlgorithm.searchPairs_(cards)
    for _, jiang in _ipairs(pairList) do
        local flag, huPath = ZZAlgorithm.canHuWithNaiZiAndJiang_(cards, jiang, naiZiCount, removeJiang, naiZi)
        if flag then
            return true, huPath
        end
    end

    for _, jiang in _ipairs(cards) do
        local flag, huPath = ZZAlgorithm.canHuWithNaiZiAndJiang_(cards, jiang, naiZiCount - 1, removeJiang - 1, naiZi)
        if flag then
            return true, huPath
        end
    end

    return false, {}
end

-- 一个癞子判断胡牌
--[[
手里有将，则先尝试用将牌组合，判断能否胡
如果没有将，则直接尝试红中补将
]]
function ZZAlgorithm.canHuWithOneNaiZi_(cards, naiZi)
    naiZi = naiZi or BaseAlgorithm.NAI_ZI
    table.removebyvalue(cards, naiZi, true)  -- 删除全部癞子牌

    return ZZAlgorithm.canHuWithPairsAndJiang(cards, 1, 2, naiZi)
end

-- 两个癞子判断能否胡牌
--[[
2个红中：
一对作将 -> 不补，直接按现有方式处理
补两张  -> 
先找将牌，有的话先遍历一下，看能不能直接用手中的将胡牌
如果不行，再直接遍历全部手牌拼将，看能不能胡
]]
function ZZAlgorithm.canHuWithTwoNaiZi_(cards, naiZi)
    table.removebyvalue(cards, BaseAlgorithm.NAI_ZI, true)  -- 删除全部癞子牌

    return ZZAlgorithm.canHuWithPairsAndJiang(cards, 2, 2, naiZi)
end

-- 三个癞子判断能否胡牌
--[[
3个红中：
3张+0补
直接按现有算法处理

一对将+1补
红中作将，其它的牌按1补的方式来处理

三张全补
手牌有将，则先遍历将牌
手牌无将，则先补一将，三张牌必须全部补下去
]]
function ZZAlgorithm.canHuWithThreeNaiZi_(cards, naiZi)
    table.removebyvalue(cards, naiZi, true)  -- 删除全部癞子牌
    local flag, path = ZZAlgorithm.canHuWithoutNaiZi_(cards)
    if flag then  -- 只要找到一种胡法就返回
        return true, path
    end

    local flag, path = ZZAlgorithm.canHuWithNaiZiAndJiang_(cards, naiZi, 1, 0)
    if flag then
        return true
    end

    return ZZAlgorithm.canHuWithPairsAndJiang(cards, 3, 2, naiZi)
end

-- 四个癞子判断能否胡牌
--[[
4个红中：
3张+1补
红中不能做将，直接按1个红中的情况处理

一对将+2补
红中作将，剩下的两张按2个红中补两张的方式来处理

四张全补
红中不能作将（但可以补将），四张牌必须全部补下去
]]
function ZZAlgorithm.canHuWithFourNaiZi_(cards)
    table.removebyvalue(cards, BaseAlgorithm.NAI_ZI, true)  -- 删除全部癞子牌
    local flag, path = ZZAlgorithm.canHuWithOneNaiZi_(cards)
    if flag then
        return true, path
    end

    local flag, path = ZZAlgorithm.canHuWithNaiZiAndJiang_(cards, BaseAlgorithm.NAI_ZI, 2, 0)
    if flag then  -- 一对红中做将 + 2补
        return true, path
    end

    return ZZAlgorithm.canHuWithPairsAndJiang(cards, 4, 2, naiZi)
end

function ZZAlgorithm.getHuPath(suit, stepData, naiZi)
    stepData = clone(stepData)
    local huPath = {}
    local userCards = {}

    for _, step in _ipairs(gailun.utils.reverse(stepData)) do
        for _, alreadyUserCard in _ipairs(userCards) do
            if table.indexof(step[4], alreadyUserCard) then
                table.removebyvalue(step[4], alreadyUserCard)
            end
        end

        gailun.utils.extends(userCards, step[4])

        local cards = gailun.utils.map(step[4], function (value)
            return suit * 10 + value
        end)

        local hzCards = gailun.utils.map(step[5], function (value)
            return suit * 10 + value
        end)
        local unitCards = clone(cards)
        gailun.utils.extends(unitCards, hzCards)
        table.sort(unitCards)

        for _, value in _ipairs(step[5]) do
            local index = table.indexof(unitCards, suit * 10 + value)
            unitCards[index] = naiZi
        end

        table.insert(huPath, unitCards)
    end

    return huPath
end

function ZZAlgorithm.canHuWithNaiZiAndJiang_(cards, jiang, naiZiCount, removeJiangCount, naiZi)
    naiZi = naiZi or BaseAlgorithm.NAI_ZI

    local cards = clone(cards)
    for i = 1, removeJiangCount do  -- 删除将牌
        table.removebyvalue(cards, jiang, false)
    end

    local huPath = {}
    local group = BaseAlgorithm.groupBySuit(cards)  -- 4张牌都要拼下去的情况
    for suit, list in _pairs(group) do
        local flag, naiZiCountTemp, stepData = ZZAlgorithm.checkValueMatchRuleWithNaiZiCount_(list, 1, {}, naiZiCount)
        if not flag then
            return false
        else
            gailun.utils.extends(huPath, ZZAlgorithm.getHuPath(suit, stepData, naiZi))
        end
        naiZiCount = naiZiCountTemp
    end

    table.insert(huPath, gailun.utils.multiUnitList({jiang}, removeJiangCount))
    for k, value in _ipairs(huPath) do
        if #value == 1 then
            table.insert(huPath[k], naiZi)
        end
    end

    return true, huPath
end

-- 判断胡牌的总循环
function ZZAlgorithm.canHu_(cards, naiZi)
    naiZi = naiZi or BaseAlgorithm.NAI_ZI

    hzCount = BaseAlgorithm.calcValueCount_(cards, naiZi)
    if #cards % 3 ~= 2 then  -- 不成牌组的数量
        return false, {}
    end
    local cards = clone(cards)
    if hzCount <= 0 then
        return ZZAlgorithm.canHuWithoutNaiZi_(cards, naiZi)
    end
    if 1 == hzCount then
        return ZZAlgorithm.canHuWithOneNaiZi_(cards, naiZi)
    end
    if 2 == hzCount then
        return ZZAlgorithm.canHuWithTwoNaiZi_(cards, naiZi)
    end
    if 3 == hzCount then
        return ZZAlgorithm.canHuWithThreeNaiZi_(cards, naiZi)
    end
    if 4 == hzCount then
        return ZZAlgorithm.canHuWithFourNaiZi_(cards, naiZi)
    end
    return false, {}
end

function ZZAlgorithm.searchChi(handCards, card)
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

function ZZAlgorithm.calcKeZiListAndMustList_(cards)
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

function ZZAlgorithm.isSevenPairs_(cards, naiZi)
    -- """判断是否7小对"""
    if not cards or #cards ~= 14 then
        return False, {}
    end

    cards = clone(cards)
    local naiZiCount = table.removebyvalue(cards, naiZi, true)
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

    if singlesLen == naiZiCount then
        for card, count in _pairs(countList) do
            if count % 2 == 0 then
                for i = 1, count do
                    table.insert(singlesPath, card)
                end
            end
        end
        return true, singlesPath
    end

    if naiZiCount - 2 == singlesLen then
        table.insert(singlesPath, naiZi)
        for card, count in _pairs(countList) do
            if count % 2 == 0 then
                for i = 1, count do
                    table.insert(singlesPath, card)
                end
            end
        end
        return true, singlesPath
    end

    return false, {}
end

function ZZAlgorithm.getRemainCards(handCards, qiPaiCards, waiCards)
    local allCards = gailun.utils.invert(BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3}))
    for k, v in _pairs(allCards) do
        allCards[k] = 4
    end

    allCards[51] = 4

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

function ZZAlgorithm.getTingPai(remainCards, cards, allowSevenPairs)
    remainCards = remainCards or ZZAlgorithm.getRemainCards({}, {}, {})
	local result = {}
    for card, count in _pairs(remainCards) do
        local isHu, path = ZZAlgorithm.canChiHu(cards, card, allowSevenPairs)
		if isHu then
			result[card] = count
		end
	end

	return result
end

function ZZAlgorithm.isTingPai(cards, allowSevenPairs)
    local remainCards = BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3})
    for _, card in _pairs(remainCards) do
        local isHu, path = ZZAlgorithm.canChiHu(cards, card, allowSevenPairs)
		if isHu then
			return true
		end
	end

	return false
end

function ZZAlgorithm.getTingOperate(cards, allowSevenPairs)
    local result = {}
    for _, card in _pairs(cards) do
        local handCards = clone(cards)
        table.removebyvalue(handCards, card)
        local isTing = ZZAlgorithm.isTingPai(handCards, allowSevenPairs)
		if isTing then
			table.insert(result, card)
		end
    end
    
    return result
end

return ZZAlgorithm
