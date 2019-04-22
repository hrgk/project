local BaseAlgorithm = import(".BaseAlgorithm")
local DtzCardType = import(".DtzCardType")
local DtzTiShi = {}

--[[
提示规则
按输入的牌型来决定返回的提示列表
提示算法不拆炸弹|筒子|地炸|喜炸

无牌:单张|对子|三带|炸弹|筒子|地炸|喜炸
单牌:单张|炸弹|筒子|地炸|喜炸|其它牌中的单张
对子:对子|炸弹|筒子|地炸|喜炸|其它牌中的对子
连对:连对|炸弹|筒子|地炸|喜炸
三带:三带(附带单张牌或对子,没有就不带)|炸弹|筒子|地炸|喜炸
飞机:飞机|炸弹|筒子|地炸|喜炸
炸弹:炸弹|筒子|地炸|喜炸
筒子:筒子|地炸|喜炸
地炸:地炸|喜炸
喜炸:喜炸

返回: 按所输入的牌型返回对应的提示列表
如: DtzTiShi.getTiShi({108}, {106,209,209,209,109,310,314,520,104,204,304,404}, nil)
返回如下: {{310}, {314}, {520}, {104,204,304,404}, {209,209,209}}
]]
function DtzTiShi.getTiShi(cards, handCards, config)
    local cardType, typeData = DtzCardType.getType(cards, config)
    local tempCards = clone(handCards)
    local list = DtzTiShi.fetchBombsBySourceType_(cardType, typeData, tempCards, config)
    if cardType == DtzCardType.DAN_ZHANG then
    	return DtzTiShi.tiShiWithDanZhang_(list, tempCards, typeData, config)
    elseif cardType == DtzCardType.DUI_ZI then
    	return DtzTiShi.tiShiWithDuiZi_(list, tempCards, typeData, config)
    elseif cardType == DtzCardType.LIAN_DUI then
    	return DtzTiShi.tiShiWithLianDui_(list, tempCards, typeData, config)
    elseif cardType == DtzCardType.SAN_DAI then
    	return DtzTiShi.tiShiWithSanDai_(list, tempCards, typeData, config)
    elseif cardType == DtzCardType.FEI_JI then
    	return DtzTiShi.tiShiWithFeiJi_(list, tempCards, typeData, config)
    elseif cardType and cardType >= DtzCardType.ZHA_DAN then
    	return list
    else
    	return DtzTiShi.tiShiWithNoCards_(list, tempCards, config)
    end
end

function DtzTiShi.deepList_(list, stepLength)
	local stepLength = stepLength or 1
	local result = {}
	for i=1,#list,stepLength do
		if 1 == stepLength then
			table.insert(result, {list[i]})
		else
			local tmp = {}
			for j=0,stepLength-1 do
				table.insert(tmp, list[i+j])
			end
			if #tmp > 0 then
				table.insert(result, tmp)
			end
		end
	end
	return result
end

function DtzTiShi.tiShiWithDanZhang_(bombs, handCards, typeData, config)
	local valueList = BaseAlgorithm.abstractValues(handCards)
	local danList = {}
	local duoList = {}
	for _,card in pairs(handCards) do
		local v = BaseAlgorithm.getValue(card)
		if v > typeData[1] then
			if 1 == BaseAlgorithm.count(valueList, v) then
				table.insert(danList, card)
			else
				if not duoList[v] then
					duoList[v] = {card}
				else
					table.insert(duoList[v], card)
				end
			end
		end
	end
	local chaiList = {}
	for _,chooseList in pairs(duoList) do
		local num = math.random(1, #chooseList)
		local card = chooseList[num]
		table.insert(chaiList, card)
	end
	BaseAlgorithm.sort(danList)
	BaseAlgorithm.sort(chaiList)
	local result = DtzTiShi.deepList_(danList)
	table.insertto(result, bombs)
	table.insertto(result, DtzTiShi.deepList_(chaiList))
	return result
end

function DtzTiShi.tiShiWithDuiZi_(bombs, handCards, typeData, config)
	BaseAlgorithm.sort(handCards)
	local valueList = BaseAlgorithm.abstractValues(handCards)
	local danList = {}
	local duoList = {}
	for _,card in pairs(handCards) do
		local v = BaseAlgorithm.getValue(card)
		if v > typeData[1] then
			local count = BaseAlgorithm.count(valueList, v)
			if 2 == count then
				table.insert(danList, card)
			elseif 3 == count then
				if not duoList[v] then
					duoList[v] = {card}
				elseif 1 == #duoList[v] then
					table.insert(duoList[v], card)
				end
			end
		end
	end
	BaseAlgorithm.sort(danList)
	duoList = table.values(duoList)
	DtzCardType.sortByCardType(duoList, true, config)
	local result = DtzTiShi.deepList_(danList, 2)
	table.insertto(result, bombs)
	table.insertto(result, duoList)
	return result
end

-- 对数组值进行分组
-- 如: 使用{3,4,5}, 2来调用, 则返回 {3,4}, {4,5}这两组值
-- 对: {3,4,5,6,7}, 3来调用, 则返回 {3,4,5},{4,5,6},{5,6,7}
function DtzTiShi.groupArray_(array, cellSize)
	local result = {}
	for i,v in ipairs(array) do
		local tmp = BaseAlgorithm.copy(array, i, cellSize)
		if #tmp == cellSize then
			table.insert(result, tmp)
		end
	end
	return result
end

function DtzTiShi.tiShiWithLianDui_(bombs, handCards, typeData, config)
	BaseAlgorithm.sort(handCards)
	local valueList = BaseAlgorithm.abstractValues(handCards)
	local duiList = {}
	for _,card in pairs(handCards) do
		local v = BaseAlgorithm.getValue(card)
		if v > typeData[2] then
			local count = BaseAlgorithm.count(valueList, v)
			if 2 <= count then
				if not duiList[v] then
					duiList[v] = {card}
				elseif 1 == #duiList[v] then
					table.insert(duiList[v], card)
				end
			end
		end
	end
	local vList = table.keys(duiList)
	table.sort(vList)
	local vList = BaseAlgorithm.splitListByStraightValue(vList)

	local result = {}
	for _,v in ipairs(vList) do
		if v and #v * 2 >= typeData[1] then
			local tmp = DtzTiShi.groupArray_(v, typeData[1] / 2)
			for _,v2 in ipairs(tmp) do
				local data = {}
				for _,v3 in ipairs(v2) do
					table.insertto(data, duiList[v3])
				end
				if #data > 0 then
					table.insert(result, data)
				end
			end
		end
	end

	table.insertto(result, bombs)
	return result
end

function DtzTiShi.tiShiWithSanDai_(bombs, handCards, typeData, config)
	BaseAlgorithm.sort(handCards)
	local valueList = BaseAlgorithm.abstractValues(handCards)
	local duoList = {}
	local danList, duiList = {}, {}
	for _,card in pairs(handCards) do
		local v = BaseAlgorithm.getValue(card)
		local count = BaseAlgorithm.count(valueList, v)
		if 3 == count then
			if v > typeData[1] then
				if not duoList[v] then
					duoList[v] = {card}
				elseif 3 > #duoList[v] then
					table.insert(duoList[v], card)
				end
			end
		elseif 1 == count then
			table.insert(danList, card)
		elseif 2 == count then
			table.insert(duiList, card)
		end
	end
	local result = {}
	table.insertto(danList, duiList)
	for _,v in pairs(duoList) do
		local data = {}
		for i = 1, config.tail3WithCard, 1 do
			table.insert(data, danList[i])
		end
		table.insertto(v, data)
	end
	duoList = table.values(duoList)
	DtzCardType.sortByCardType(duoList, true, config)
	table.insertto(result, duoList)
	table.insertto(result, bombs)
	return result
end

function DtzTiShi.appendChiBang_(feiJiList, danList, duiList, typeData, config)
	table.insertto(danList, duiList)
	local chiBangList = {}
	for i=1,typeData[1] * config.tail3WithCard do
		table.insertto(chiBangList, {danList[i]})
	end
	for _,v in pairs(feiJiList) do
		table.insertto(v, chiBangList)
	end
end

function DtzTiShi.statDanDuiSan_(handCards, minValue)
	local danList, duiList, threeList = {}, {}, {}
	local valueList = BaseAlgorithm.abstractValues(handCards)
	for _,card in pairs(handCards) do
		local v = BaseAlgorithm.getValue(card)
		local count = BaseAlgorithm.count(valueList, v)
		if 3 == count then
			if v > minValue then
				if not threeList[v] then
					threeList[v] = {card}
				else
					table.insert(threeList[v], card)
				end
			end
		elseif 1 == count then
			table.insert(danList, card)
		elseif 2 == count then
			table.insert(duiList, card)
		end
	end
	BaseAlgorithm.sort(duiList)
	return danList, duiList, threeList
end

function DtzTiShi.tiShiWithFeiJi_(bombs, handCards, typeData, config)
	BaseAlgorithm.sort(handCards)
	local danList, duiList, threeList = DtzTiShi.statDanDuiSan_(handCards, typeData[2])
	local vList = table.keys(threeList)
	table.sort(vList)
	local vList = BaseAlgorithm.splitListByStraightValue(vList)

	local result = {}
	for _,v in ipairs(vList) do
		if v and #v >= typeData[1] then
			local tmp = DtzTiShi.groupArray_(v, typeData[1])
			for _,v2 in ipairs(tmp) do
				local data = {}
				for _,v3 in ipairs(v2) do
					table.insertto(data, threeList[v3])
				end
				if #data > 0 then
					table.insert(result, data)
				end
			end
		end
	end

	DtzTiShi.appendChiBang_(result, danList, duiList, typeData, config)
	table.insertto(result, bombs)
	return result
end

-- 无牌:单张|对子|三带|炸弹|筒子|地炸|喜炸
function DtzTiShi.tiShiWithNoCards_(bombs, handCards, config)
	local result = {}
	local danList, duiList, threeList = DtzTiShi.statDanDuiSan_(handCards, 0)
	table.insertto(result, DtzTiShi.deepList_(danList, 1))
	table.insertto(result, DtzTiShi.deepList_(duiList, 2))
	threeList = table.values(threeList)
	DtzCardType.sortByCardType(threeList, true, config)
	table.insertto(result, threeList)
	table.insertto(result, bombs)
	return result
end

-- 在给定的牌堆中找出数量大于等于指定数量的牌列表
-- 输入的牌堆必须先排序并满足从小到大排列
function DtzTiShi.findSameCardsByBaseCount_(cards, count, needUnique, isEqual)
	local result = {}
	for i=#cards,1,-1 do
		local v = cards[i]
		if isEqual then
			if count == BaseAlgorithm.count(cards, v) then
				table.insert(result, v)
			end
		else
			if BaseAlgorithm.count(cards, v) >= count then
				table.insert(result, v)
			end
		end
	end
	if needUnique then
		return table.unique(result)
	else
		return result
	end
end

function DtzTiShi.fetchXiZha_(cardType, typeData, handCards)
	local result = {}
	local fourList = DtzTiShi.findSameCardsByBaseCount_(handCards, 4, true)
	for _,v in pairs(fourList) do
		local tmpData = {BaseAlgorithm.getValue(v), BaseAlgorithm.getSuit(v)}
		if DtzCardType.isBiggerCardType(DtzCardType.XI_ZHA, tmpData, cardType, typeData) then
			table.insert(result, {v, v, v, v})
			table.removebyvalue(handCards, v, true)
		end
	end
	return result
end

function DtzTiShi.fetchDiZha_(cardType, typeData, handCards)
	local result = {}
	local list = DtzTiShi.findSameCardsByBaseCount_(handCards, 2, true)
	local valueList = BaseAlgorithm.abstractValues(list)
	for _,v in pairs(valueList) do
		if BaseAlgorithm.count(handCards, BaseAlgorithm.makeCard(4, v)) >= 2 
			and BaseAlgorithm.count(handCards, BaseAlgorithm.makeCard(3, v)) >= 2 
			and BaseAlgorithm.count(handCards, BaseAlgorithm.makeCard(2, v)) >= 2 
			and BaseAlgorithm.count(handCards, BaseAlgorithm.makeCard(1, v)) >= 2 then
			if DtzCardType.isBiggerCardType(DtzCardType.DI_ZHA, {v}, cardType, typeData) then
				local data = {
					BaseAlgorithm.makeCard(4, v), BaseAlgorithm.makeCard(4, v),
					BaseAlgorithm.makeCard(3, v), BaseAlgorithm.makeCard(3, v),
					BaseAlgorithm.makeCard(2, v), BaseAlgorithm.makeCard(2, v),
					BaseAlgorithm.makeCard(1, v), BaseAlgorithm.makeCard(1, v),
				}
				table.insert(result, data)
				for _,rmCard in ipairs(data) do
					table.removebyvalue(handCards, rmCard, false)
				end
			end
		end
	end
	return result
end

function DtzTiShi.fetchTongZi_(cardType, typeData, handCards)
	local result = {}
	local list = DtzTiShi.findSameCardsByBaseCount_(handCards, 3, true)
	for _,v in pairs(list) do
		local tmpData = {BaseAlgorithm.getValue(v), BaseAlgorithm.getSuit(v)}
		if DtzCardType.isBiggerCardType(DtzCardType.TONG_ZI, tmpData, cardType, typeData) then
			table.insert(result, {v, v, v})
			table.removebyvalue(handCards, v, true)
		end
	end
	return result
end

function DtzTiShi.fetchCardsByValue_(handCards, cardValue)
	local result = {}
	for _,card in pairs(handCards) do
		if BaseAlgorithm.getValue(card) == cardValue then
			table.insert(result, card)
		end
	end
	return result
end

function DtzTiShi.fetchZhaDan_(cardType, typeData, handCards)
	local result = {}
	local valueList = BaseAlgorithm.abstractValues(handCards)
	local uniqueList = table.unique(valueList)
	for _,v in pairs(uniqueList) do
		local count = BaseAlgorithm.count(valueList, v)
		if count >= 4 then
			if DtzCardType.isBiggerCardType(DtzCardType.ZHA_DAN, {count, v}, cardType, typeData) then
				local zhaDan = DtzTiShi.fetchCardsByValue_(handCards, v)
				table.insert(result, zhaDan)
				for _,rmCard in pairs(zhaDan) do
					table.removebyvalue(handCards, rmCard, false)
				end
			end
		end
	end
	return result
end

function DtzTiShi.fetchBombsBySourceType_(cardType, typeData, handCards, config)
	table.sort(handCards)
	local cardType = cardType or 0
	local typeData = checktable(typeData)
	local bombs = DtzTiShi.fetchXiZha_(cardType, typeData, handCards)
	if cardType <= DtzCardType.DI_ZHA then
		table.insertto(bombs, DtzTiShi.fetchDiZha_(cardType, typeData, handCards))
	end
	if cardType <= DtzCardType.TONG_ZI then
		table.insertto(bombs, DtzTiShi.fetchTongZi_(cardType, typeData, handCards))
	end
	if cardType <= DtzCardType.ZHA_DAN then
		table.insertto(bombs, DtzTiShi.fetchZhaDan_(cardType, typeData, handCards))
	end
	DtzCardType.sortByCardType(bombs, true, config)
	return bombs
end

return DtzTiShi
