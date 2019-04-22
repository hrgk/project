local BaseAlgorithm = import(".BaseAlgorithm")
local ShuangKouCardType = {}

ShuangKouCardType.DAN_ZHANG = 1			-- 单张
ShuangKouCardType.DUI_ZI = 2			-- 对子
ShuangKouCardType.SAN_ZHANG = 3			-- 三张
ShuangKouCardType.SHUN_ZI = 4			-- 顺子
ShuangKouCardType.LIAN_DUI = 5			-- 连对
ShuangKouCardType.LIAN_SAN_ZHANG = 6 	-- 连三张
ShuangKouCardType.ZHA_DAN = 7			-- 炸弹
ShuangKouCardType.LIAN_ZHA_DAN = 8		-- 连炸
ShuangKouCardType.SAN_WANG_ZHA = 9		-- 三王炸
ShuangKouCardType.TIAN_WANG_ZHA = 10	-- 天王炸

function ShuangKouCardType.sortByValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) < BaseAlgorithm.getValue(b)
    end
end

function ShuangKouCardType.checkIsWang(cardValue)
	local xiaoWanValue = 518
	local daWanValue = 520
	if cardValue == daWanValue or cardValue == xiaoWanValue then
		return true
	end
	return false
end

function ShuangKouCardType.filterBianPai(handCards, bianPai)
	local result = {}
	local laiZi = {}

	for k, v in pairs(handCards) do
		if ShuangKouCardType.checkIsChangeCard(v, bianPai) then
			table.insert(laiZi, v)
		else
			table.insert(result, v)
		end
	end
	return result, laiZi
end

function ShuangKouCardType.checkIsChangeCard(cardValue,bianPai)
	if not bianPai then
		return false
	end
	local xiaoWanValue = 518
	local daWanValue = 520
	if bianPai == 0 then
		return false
	elseif bianPai == 1 and cardValue == daWanValue then
		return true
	elseif bianPai == 2 and (cardValue == daWanValue or cardValue == xiaoWanValue) then
		return true
	end
end

function ShuangKouCardType.getCardData(cardsInfo,bianPai)
	local cards = clone(cardsInfo)
    local resInfo = {}
    local changeInfo = {}
    for i = 1,#cards do
        local cardValue = cards[i]
        if cardValue > 0 then
            if ShuangKouCardType.checkIsChangeCard(cardValue,bianPai) then
                table.insert(changeInfo,cardValue)
            else
                local someCard = {}
                local someCardCount = 1
                someCard[someCardCount] = cards[i]
                for j = i + 1,#cards do
                    local findVale = cards[j]
                    if findVale > 0 and BaseAlgorithm.getValue(findVale) == BaseAlgorithm.getValue(cardValue) then
                        someCardCount = someCardCount + 1
                        someCard[someCardCount] = findVale
                        cards[j] = 0
                    else
                        break
                    end
				end
				resInfo[someCardCount] = resInfo[someCardCount] or {}
                table.insert(resInfo[someCardCount],someCard)
            end
        end
    end
    return resInfo,changeInfo
end

function ShuangKouCardType.getCardDataByValue(cardsInfo,bianPai)
	local cards = clone(cardsInfo)
    local resInfo = {}
	local changeInfo = {}
	local maxCout = 0
    for i = 1,#cards do
		local cardValue = cards[i]
		if ShuangKouCardType.checkIsChangeCard(cardValue,bianPai) then
			table.insert(changeInfo,cardValue)
		else			
			local aimVlaue = BaseAlgorithm.getValue(cardValue)
			resInfo[aimVlaue] = resInfo[aimVlaue] or {}
			table.insert(resInfo[aimVlaue],cardValue)
			local count = #resInfo[aimVlaue]
			if maxCout < count then
				maxCout = count
			end
		end
	end
    return resInfo,changeInfo,maxCout
end

--[[
	signNum = 连子单位数量,必须满足
	minNum = 连子单位最长度, 可超

	1 5, 表示顺子
	2 3, 表示三连对
]]
function ShuangKouCardType.checkLian(aimType,cardsInfo,bianPai,signNum,minNum)
	signNum = signNum or 1
	minNum = minNum or 1
	local cards = clone(cardsInfo)
	local cardsLen = #cards
	if cardsLen < signNum*minNum or cardsLen%signNum ~= 0 then
		return false
	end
	table.sort(cards, ShuangKouCardType.sortByValue_)
	local resInfo,changeInfo,maxCout = ShuangKouCardType.getCardDataByValue(cards,bianPai)
	if aimType == ShuangKouCardType.LIAN_ZHA_DAN then
		signNum = maxCout
	end
	local needCount = 0
	local cmpValue = nil
	local min = nil
	local max = nil
	for key,value in pairs(resInfo) do
		if key > 14 or #value > signNum then
			return false
		end 
		if cmpValue then
			needCount = needCount + signNum*(key-cmpValue-1)
		else
			min = key
		end
		cmpValue = key
		needCount = needCount + (signNum - #value)
		max = key
	end
	if needCount == #changeInfo then
		if aimType == ShuangKouCardType.LIAN_ZHA_DAN then
			return aimType,{cardsLen/signNum,min,maxCout}
		else
			return aimType,{cardsLen/signNum,min}
		end
	elseif needCount <= #changeInfo then
		local reCout = #changeInfo - needCount
		local count = reCout
		for i = 1,count do
			if max < 14 and reCout > 0 then
				max = max + 1
				reCout = reCout - signNum
			else
				break
			end
		end
		count = reCout
		for i = 1,count do
			if min > 3 and reCout > 0 then
				min = min - 1
				reCout = reCout - signNum
			else
				break
			end
		end
		if reCout == 0 then
			if aimType == ShuangKouCardType.LIAN_ZHA_DAN then
				return aimType,{cardsLen/signNum,min,maxCout}
			else
				return aimType,{cardsLen/signNum,min}
			end
		end
	end
	return false
end

function ShuangKouCardType.checkWangZha_(aimType,cards,num)
	if #cards == num then
		for i = 1,num do
			if not ShuangKouCardType.checkIsWang(cards[i]) then
				return false
			end
		end
		return aimType
	end
	return false
end

------------------------------------------------------------
function ShuangKouCardType.checkDanZhang_(cards,bianPai)-- 单张
	if #cards == 1 then
		return ShuangKouCardType.DAN_ZHANG,{BaseAlgorithm.getValue(cards[1])}
	end
	return false
end

function ShuangKouCardType.checkSunZi_(cards,bianPai)-- 顺子
	return ShuangKouCardType.checkLian(ShuangKouCardType.SHUN_ZI,cards,bianPai,1,5)
end

function ShuangKouCardType.checkDuiZi_(cards,bianPai)-- 对子
	if #cards ~= 2 then
		return false
	end
	table.sort(cards, ShuangKouCardType.sortByValue_)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(cards,bianPai)
	if resInfo[1] and #resInfo[1] > 1 then
		return false
	end
	if resInfo[2] and #resInfo[2] == 1 then
		return ShuangKouCardType.DUI_ZI,{BaseAlgorithm.getValue(resInfo[2][1][1])}
	end
	if resInfo[1] and #resInfo[1] == 1 and #changeInfo == 1 then
		return ShuangKouCardType.DUI_ZI,{BaseAlgorithm.getValue(resInfo[1][1][1])}
	end
	return false
end

function ShuangKouCardType.checkLianDui_(cards,bianPai)-- 连对
	return ShuangKouCardType.checkLian(ShuangKouCardType.LIAN_DUI,cards,bianPai,2,3)
end

function ShuangKouCardType.checkSanZhang_(cards,bianPai)-- 三张
	if #cards ~= 3 then
		return false
	end
	table.sort(cards, ShuangKouCardType.sortByValue_)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(cards,bianPai)
	if resInfo[1] and #resInfo[1] == 1 and #changeInfo == 2 then
		return ShuangKouCardType.SAN_ZHANG,{BaseAlgorithm.getValue(resInfo[1][1][1])}
	end
	if resInfo[2] and #resInfo[2] == 1 and #changeInfo == 1 then
		return ShuangKouCardType.SAN_ZHANG,{BaseAlgorithm.getValue(resInfo[2][1][1])}
	end
	if resInfo[3] and #resInfo[3] == 1 then
		return ShuangKouCardType.SAN_ZHANG,{BaseAlgorithm.getValue(resInfo[3][1][1])}
	end
	return false
end

function ShuangKouCardType.checkLianSanZhang_(cards,bianPai)-- 连三张
	return ShuangKouCardType.checkLian(ShuangKouCardType.LIAN_SAN_ZHANG,cards,bianPai,3,3)
end

function ShuangKouCardType.checkZhaDan_(cards,bianPai)-- 炸弹
	if #cards < 4 then
		return false
	end
	table.sort(cards, ShuangKouCardType.sortByValue_)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(cards,bianPai)
	for i = 1,8 do
		if resInfo[i] and resInfo[i][1] and #resInfo[i][1] + #changeInfo == #cards then
			return ShuangKouCardType.ZHA_DAN ,{#cards,BaseAlgorithm.getValue(resInfo[i][1][1])}
		end
	end
	return false
end

function ShuangKouCardType.checkLianZhaDan_(cards,bianPai)-- 连炸
	if #cards < 12 then
		return false
	end
	return ShuangKouCardType.checkLian(ShuangKouCardType.LIAN_ZHA_DAN,cards,bianPai,nil,nil,true)
end

function ShuangKouCardType.checkSanWangZha_(cards)-- 三王炸
	return ShuangKouCardType.checkWangZha_(ShuangKouCardType.SAN_WANG_ZHA,cards,3)
end

function ShuangKouCardType.checkTianWangZha_(cards)-- 天王炸
	return ShuangKouCardType.checkWangZha_(ShuangKouCardType.TIAN_WANG_ZHA,cards,4)
end

function ShuangKouCardType.getType(cards,bianPai)
	if not cards or type(cards) ~= "table" or #cards == 0 then
		return nil, nil
	end
	local len = #cards
	local funcList = {
		ShuangKouCardType.checkDanZhang_,
		ShuangKouCardType.checkDuiZi_,
		ShuangKouCardType.checkSanWangZha_,
		ShuangKouCardType.checkTianWangZha_,
		ShuangKouCardType.checkSunZi_,
		ShuangKouCardType.checkSanZhang_,
		ShuangKouCardType.checkLianDui_,
		ShuangKouCardType.checkLianSanZhang_,
		ShuangKouCardType.checkZhaDan_,
		ShuangKouCardType.checkLianZhaDan_,
	}
	for _,f in ipairs(funcList) do
		local tmpType, tmpData = f(cards,bianPai)
		if tmpType then
			return tmpType, tmpData
		end
	end
	return nil, nil
end

function ShuangKouCardType.isBiggerCardType(type1, data1, type2, data2)
	local function getCmpValue(type,data)
		if type == ShuangKouCardType.ZHA_DAN then
			return data[1]
		end
		if type == ShuangKouCardType.LIAN_ZHA_DAN then
			return data[1]+data[3]
		end
	end
    if not type1 or not type2 then
        return false
	end
	if type1 == type2 then
		if type1 >= ShuangKouCardType.SHUN_ZI and type1 <= ShuangKouCardType.LIAN_SAN_ZHANG then
			if data1[1] ~= data2[1] then
				return false
			end
		end
		if type1 == ShuangKouCardType.LIAN_ZHA_DAN then
			if data1[1] ~= data2[1] or data1[3] ~= data2[3] then 
				return data1[1]+data1[3] > data2[1]+data2[3]
			end
		end
		for i = 1,#data1 do
			if data1[i] > data2[i] then
				return true
			end
		end
	elseif type2 < ShuangKouCardType.ZHA_DAN and type1 >= ShuangKouCardType.ZHA_DAN then
		return true
	else
		print(type1, type2)
		dump(data2)
		if type1>=ShuangKouCardType.ZHA_DAN and type2>=ShuangKouCardType.ZHA_DAN and type1<=ShuangKouCardType.LIAN_ZHA_DAN and type2<=ShuangKouCardType.LIAN_ZHA_DAN then
			if getCmpValue(type1,data1) > getCmpValue(type1,data1) then
				return true
			end
		end
		if type1 == ShuangKouCardType.LIAN_ZHA_DAN and (type2 == ShuangKouCardType.SAN_WANG_ZHA or type2 == ShuangKouCardType.TIAN_WANG_ZHA) then
			return true
		end
		if type1 == ShuangKouCardType.LIAN_ZHA_DAN and type2 == ShuangKouCardType.SAN_WANG_ZHA then
			return true
		end
		if type1 == ShuangKouCardType.ZHA_DAN and type2 == ShuangKouCardType.SAN_WANG_ZHA and data1[1] > 5 then
			return true
		end
		if type1 == ShuangKouCardType.ZHA_DAN and type2 == ShuangKouCardType.TIAN_WANG_ZHA and data1[1] > 6 then
			return true
		end
		if type2 == ShuangKouCardType.ZHA_DAN and type1 == ShuangKouCardType.SAN_WANG_ZHA and data2[1] <= 5 then
			return true
		end
		if type2 == ShuangKouCardType.ZHA_DAN and type1 == ShuangKouCardType.TIAN_WANG_ZHA and data2[1] <= 6 then
			return true
		end
	end
	return false
end

function ShuangKouCardType.sortByCardType(list, reverse)
	local reverse = reverse or false
	local function comp(a, b)
		local type1, data1 = ShuangKouCardType.getType(a)
		local type2, data2 = ShuangKouCardType.getType(b)
		return ShuangKouCardType.isBiggerCardType(type1, data1, type2, data2)
	end
	table.sort(list, comp)
	if reverse then
		BaseAlgorithm.reverseList(list)
	end
end

return ShuangKouCardType
