local BaseAlgorithm = import(".BaseAlgorithm")
local DtzCardType = {}

DtzCardType.DAN_ZHANG = 1	-- 单张
DtzCardType.DUI_ZI = 2		-- 对子
DtzCardType.LIAN_DUI = 3	-- 连对
DtzCardType.SAN_DAI = 4		-- 三带
DtzCardType.FEI_JI = 5		-- 飞机
DtzCardType.ZHA_DAN = 6		-- 炸弹
DtzCardType.TONG_ZI = 7		-- 筒子
DtzCardType.DI_ZHA = 8		-- 地炸
DtzCardType.XI_ZHA = 9		-- 喜炸

function DtzCardType.checkDiZha_(cards)  -- 判断是否地炸
	if 8 ~= #cards then
		return nil, nil
	end
	local values = BaseAlgorithm.abstractValues(cards)
	local suits = BaseAlgorithm.abstractSuits(cards)
	for _,v in ipairs(values) do
		if v ~= values[1] then
			return nil, nil
		end
	end
	table.sort(suits)
	if 1 == suits[1] and 1 == suits[2] 
		and 2 == suits[3] and 2 == suits[4] 
		and 3 == suits[5] and 3 == suits[6] 
		and 4 == suits[7] and 4 == suits[8] then
		return DtzCardType.DI_ZHA, {values[1]}
	end
	return nil, nil
end

function DtzCardType.checkZhaDan_(cards)  -- 判断是否炸弹
	if #cards < 4 then
		return nil, nil
	end
	local values = BaseAlgorithm.abstractValues(cards)
	for _,v in ipairs(values) do
		if v ~= values[1] then
			return nil, nil
		end
	end
	return DtzCardType.ZHA_DAN, {#values, values[1]}
end

function DtzCardType.getSanZhangList_(cards)
	local values = BaseAlgorithm.abstractValues(cards)
    local list = {}
    for _,v in ipairs(values) do
        if BaseAlgorithm.count(values, v) >= 3 then
        	table.insert(list, v)
        end
    end
    return table.values(table.unique(list))
end

function DtzCardType.checkFeiJi_(cards, config)
	if #cards < 6 then
		return nil, nil
	end
	local list = DtzCardType.getSanZhangList_(cards)
	table.sort(list)
	local valueList = BaseAlgorithm.splitListByStraightValue(list)
	local maxLengthList
	for i=#valueList,1,-1 do
		local v = valueList[i]
		if v and not maxLengthList then
			maxLengthList = v
		else
			if #v > #maxLengthList then
				maxLengthList = v
			end
		end
	end
	if not maxLengthList or #maxLengthList < 2 then
		return nil, nil
	end
	
	if #cards > #maxLengthList * config.tail3WithCard + #maxLengthList * 3 then
		return nil, nil
	end
	return DtzCardType.FEI_JI, {#maxLengthList, maxLengthList[1], #cards - #maxLengthList * 3}
end

function DtzCardType.checkLianDui_(cards)
	if 0 >= #cards or 0 ~= #cards % 2 then
		return nil, nil
	end
	local values = BaseAlgorithm.abstractValues(cards)
	table.sort(values)
	for i=1, #values do
		if i >= #values then
			break
		end
		if i % 2 == 0 then
			if values[i] + 1 ~= values[i+1] then  -- 偶数位: 下一位加一
				return nil, nil
			end
		else
			if values[i] ~= values[i+1] then  -- 奇数位: 下一位相等
				return nil, nil
			end
		end
	end
	return DtzCardType.LIAN_DUI, {#cards, BaseAlgorithm.getValue(values[1])}
end

function DtzCardType.checkSanDai_(cards, config)
	if #cards < 3 or #cards > 5 then
		return nil, nil
	end

	if #cards > 3 + config.tail3WithCard then
		return nil, nil
	end

	local values = BaseAlgorithm.abstractValues(cards)
	table.sort(values)
	if (values[1] == values[2] and values[2] == values[3]) or
       (values[2] == values[3] and values[3] == values[4]) or
       (values[3] == values[4] and values[4] == values[5]) then
       return DtzCardType.SAN_DAI, {BaseAlgorithm.getValue(values[3]), #values - 3}
    end
    return nil, nil
end

--[[
单张: 1
对子: 2
连对: 4 6 8 10 12 14 16 18 20 ...
三带: 3 4 5
飞机: 6 ...
炸弹: 4 ...
筒子: 3
地炸: 8
喜炸: 4
输入一个列表数据, 返回两项, {牌型, 牌型属性}
]]
function DtzCardType.getType(cards, config)
	if config == nil then
		dump(config)
		printError(config)
	end
	assert(config)
	if not cards or type(cards) ~= "table" or #cards == 0 then
		return nil, nil
	end
	local len = #cards
	if 1 == len then
		return DtzCardType.DAN_ZHANG, {BaseAlgorithm.getValue(cards[1])}
	elseif 2 == len and BaseAlgorithm.getValue(cards[1]) == BaseAlgorithm.getValue(cards[2]) then
		return DtzCardType.DUI_ZI, {BaseAlgorithm.getValue(cards[1])}
	end
	if 3 == len then
		if cards[1] == cards[2] and cards[2] == cards[3]then
			return DtzCardType.TONG_ZI, {BaseAlgorithm.getValue(cards[1]), BaseAlgorithm.getSuit(cards[1])}
		end
	end
	if 4 == len then
		if cards[1] == cards[2] and cards[2] == cards[3] and cards[3] == cards[4] then
			return DtzCardType.XI_ZHA, {BaseAlgorithm.getValue(cards[1]), BaseAlgorithm.getSuit(cards[1])}
		end
	end
	local funcList = {
		DtzCardType.checkZhaDan_,	-- 炸弹判断
		DtzCardType.checkFeiJi_,	-- 飞机判断
		DtzCardType.checkLianDui_,	-- 连对判断
		DtzCardType.checkSanDai_,	-- 三带判断
	}
	if config.cardCount == 3 then
		table.insert(funcList, 1, DtzCardType.checkDiZha_)
	end
	for _,f in ipairs(funcList) do
		local tmpType, tmpData = f(cards, config)
		if tmpType and tmpData then
			return tmpType, tmpData
		end
	end
	return nil, nil
end

function DtzCardType.feiJiJiangJi_(data)  -- 飞机降级算法
	local result = {}
	local length, startValue, chiBang = unpack(data)
	local totalCards = length * 3 + chiBang
	for i = 1, length - 2 do
		local newLength, newStartValue, newChiBang = length - i, startValue + i, chiBang + 3 * i
		if newLength * 2 < newChiBang then
			break
		end
		table.insert(result, {newLength, newStartValue, newChiBang})
	end
	return result
end

local function compareFeiJI_(data1, data2)
	local length1, maxValue1, _ = unpack(data1)
	local length2, maxValue2, _ = unpack(data2)
	if length1 ~= length2 then
		return false
	end
	return maxValue1 > maxValue2
end

function DtzCardType.isBiggerFeiJi_(data1, data2)
	if compareFeiJI_(data1, data2) then
		return true
	end
	local list = DtzCardType.feiJiJiangJi_(data1)
	for _,v in ipairs(list) do
		if compareFeiJI_(v, data2) then
			return true
		end
	end
	return false
end

function DtzCardType.isBiggerCardType(type1, data1, type2, data2)
    if not type1 or not type2 then
        return false
    end
    if type1 == type2 then  -- 牌型相同
    	if type1 == DtzCardType.LIAN_DUI then
    		if data1[1] ~= data2[1] then
    			return false
    		end
    		return data1[2] > data2[2]
    	end
    	if type1 == DtzCardType.FEI_JI then
    		return DtzCardType.isBiggerFeiJi_(data1, data2)
    	end
        for i=1,#data1 do
            if data1[i] > data2[i] then
                return true
            elseif data1[i] < data2[i] then
            	return false
            end
        end
        return false
    end
    if type1 < type2 then
        return false
    end
    return type1 >= DtzCardType.ZHA_DAN
end

function DtzCardType.sortByCardType(list, reverse, config)
	local reverse = reverse or false
	local function comp(a, b)
		local type1, data1 = DtzCardType.getType(a, config)
		local type2, data2 = DtzCardType.getType(b, config)
		return DtzCardType.isBiggerCardType(type1, data1, type2, data2)
	end
	table.sort(list, comp)
	if reverse then
		BaseAlgorithm.reverseList(list)
	end
end

return DtzCardType
