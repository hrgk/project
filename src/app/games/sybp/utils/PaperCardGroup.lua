local BaseAlgorithm = import(".BaseAlgorithm")
local PaoHuZiAlgorithm = import(".PaoHuZiAlgorithm")
local PaperCardGroup = {}
local search_cards = {101, 101, 107, 107, 201, 201, 207, 207} -- 有胡息的牌的搜索顺序和次数


function PaperCardGroup.getSameCardsList_(cards)
	local sameValueList = {}
	for i,v in ipairs(cards) do
		if sameValueList[v] == nil then
			sameValueList[v] = {}
		end
		table.insert(sameValueList[v], v)
		
	end
	return sameValueList
end

function PaperCardGroup.filterSameValueList_(list)
	local tempCards = {}
	local kanList = {}
	for k,v in pairs(list) do
		if #v >= 2 then
			table.insert(kanList, v)
		else
			for k,card in pairs(v) do
				table.insert(tempCards, card)
			end
		end
	end
	return kanList, tempCards
end

function PaperCardGroup.isSort(cards)
	if #cards == 1 then --单张
		return 99
	end

	if #cards == 2 then 
		if cards[1] == cards[2] then --对子
			return 99
		end
		if cards[1]%100 - cards[2]%100 == -1 or cards[1]%100 - cards[2]%100 == 1 then --存在连牌
			return 99
		end
		-- if cards[1]%100 == cards[2]%100 then 
		-- 	return 99
		-- end
		return 1
	end

	if #cards == 3 then
		if cards[1] == cards[2] and cards[3] == cards[2] then --3个相同的
			return 99 
		elseif cards[2] - cards[1] == 1 and cards[3] - cards[2] == 1 then --顺子
			return 99
		elseif cards[1]%100 == 1 and cards[2]%100 == 2 and cards[3]%100 == 3 then  -- 1 2 3
			return 99
		elseif cards[1]%100 == 2 and cards[2]%100 == 7 and cards[3]%100 == 10 then  -- 2 7 10
			return 99
		elseif cards[2] - cards[1] == 1 or cards[3] - cards[2] == 1 then --存在连牌
			return 99
		-- elseif cards[2] == cards[1] and  cards[2] ~= cards[3] then --存在连牌
		-- 	print("XXXXXX")
		-- 	if cards[1] < cards[3] then
		-- 		return 99
		-- 	else
		-- 		return 1
		-- 	end
		-- elseif cards[2] == cards[3] and cards[2] ~= cards[1] then --存在连牌
		-- 	print("XXXXXX111")
		-- 	if cards[1] < cards[2] then
		-- 		return 99
		-- 	else
		-- 		return 1
		-- 	end
	elseif (cards[2] == cards[1] and cards[2] < 200) or (cards[2] == cards[3] and cards[2] < 200) or (cards[1] == cards[3] and cards[1] < 200) then --两张一样且为小字
			return 99
		end
		return 1
	end

	return 99
end

function PaperCardGroup.checkSome(cards,value,index)
	for i = 1,#cards do
		if value == cards[i] and i ~= index then
			return true
		end
	end
	return false
end

function PaperCardGroup.getKanNum(cards)
	local kanNum = 0
	for key,value in pairs(cards) do
		if value[1] > 0 then
			kanNum = kanNum + 1
		end
	end 
	return kanNum
end

function PaperCardGroup.getAimSortList(cards)
	local aim = {1,2,3}
	--123
	for j = 1,2 do
		local index = 100 * j
		if cards[index+aim[1]] and cards[index+aim[2]] and cards[index+aim[3]] then
			if #cards[index+aim[1]] == 1 and #cards[index+aim[2]] == 1 and #cards[index+aim[3]] == 1 then
				if cards[index+aim[2]][1] > 0 and cards[index+aim[3]][1] > 0 and cards[index+aim[2]][1] > 0 and cards[index+aim[1]][1] > 0 then
					cards[index+aim[1]][2],cards[index+aim[1]][3] = index+aim[2],index+aim[3]
					cards[index+aim[2]][1],cards[index+aim[3]][1] = 0,0
				end
			end
		end
	end
	--2710
	aim = {2,7,10}
	for j = 1,2 do
		local index = 100 * j
		if cards[index+aim[1]] and cards[index+aim[2]] and cards[index+aim[3]] then
			if #cards[index+aim[1]] == 1 and #cards[index+aim[2]] == 1 and #cards[index+aim[3]] == 1 then
				if cards[index+aim[2]][1] > 0 and cards[index+aim[3]][1] > 0 and cards[index+aim[2]][1] > 0 and cards[index+aim[1]][1] > 0 then
					cards[index+aim[1]][2],cards[index+aim[1]][3] = index+aim[2],index+aim[3]
					cards[index+aim[2]][1],cards[index+aim[3]][1] = 0,0
				end
			end
		end
	end
	aim = {1,3,7,10}
	--半边天
	for j = 1,2 do
		local index = 100 * j
		local vlaue2 = index + 2
		if cards[vlaue2] and #cards[vlaue2] == 2 and cards[vlaue2][1] > 0 then
			local isBan = true
			for i = 1, 4 do
				local aimValue = index + aim[i]
				if cards[aimValue] and #cards[aimValue] == 1 and cards[aimValue][1] > 0 then
				else
					isBan = false
				end
			end
			if isBan then
				cards[index+1][2] = index+2
				cards[index+1][3] = index+3
				cards[index+2][2] = index+7
				cards[index+2][3] = index+10
				cards[index+3][1] = 0
				cards[index+7][1] = 0
				cards[index+10][1] = 0
			end
		end
		
	end

	--顺子
	for k,v in pairs(cards) do
		if v[1] > 0 then
			if #v == 1 then
				local value = k
				if cards[value+1] and cards[value+2] then
					if #cards[value+1] == 1 and #cards[value+2] == 1 and cards[value+1][1] > 0 and cards[value+2][1] > 0 then
						v[2] = value+1
						v[3] = value+2
						cards[value+1][1],cards[value+2][1] = 0,0
					end
				end
			end
		end
	end
	--dxx xxd
	for k,v in pairs(cards) do
		if v[1] > 0 then
			local finCard = cards[k+100]
			if finCard and #finCard + #v == 3 and finCard[1] > 0 then
				local len = #v
				for i = 1, #finCard do
					v[len+i] = finCard[i]
				end
				finCard[1] = 0
			end
		end
	end
	--相近的
	for k,v in pairs(cards) do
		if v[1] > 0 and #v == 1 then
			local finCard = cards[k+1]
			if finCard and #finCard == 1 and #v == 1 and finCard[1] > 0 then
				local len = #v
				for i = 1, #finCard do
					v[len+i] = finCard[i]
				end
				finCard[1] = 0
			end
		end
	end
	local kanNum = PaperCardGroup.getKanNum(cards)
	local needLen = kanNum - 9
	--优先放-1 然后+1
	local findConf = {{1,2,3,4},{6,7,8,9,10},{5}}
	local deff = {100,-100,-1,-101,1,101}
	if needLen > 0 then
		--坎数过大合并
		for fIndex = 1, 3 do
			for i = 1,#findConf[fIndex] do
				if needLen <= 0 then
					break
				end
				for j = 1,2 do
					local index = 100 * j + findConf[fIndex][i]
					if cards[index] and #cards[index] == 1 and cards[index][1] > 0 and needLen > 0 then
						for k = 1, #deff do
							local aimIndex = index + deff[k]
							if cards[aimIndex] and cards[index][1] > 0 and cards[aimIndex][1] > 0 and needLen > 0 then
								if #cards[index] == 1 then
									if k == 1 or k == 2 then
										if #cards[aimIndex] == 1 then
											cards[index][2] = aimIndex
											cards[aimIndex][1] = 0
											needLen = needLen - 1
										end
									else
										if #cards[aimIndex] == 2 and cards[aimIndex][1] == cards[aimIndex][2] then
											cards[aimIndex][3] = index
											cards[index][1] = 0
											needLen = needLen - 1
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local function myCmp(a,b)
		return a > b
	end
	local aimArr = {}
	for i = 1,10 do
		for j = 2,1,-1 do
			local index = 100 * j + i
			if cards[index] and cards[index][1] and  cards[index][1] > 0 then

				local type = PaperCardGroup.isSort(cards[index])
				if type == 1 then
					table.sort(cards[index],myCmp)
				end
				table.insert(aimArr,clone(cards[index]))
			end
		end
	end
	return aimArr
end

function PaperCardGroup.clacKanList(cards)
	local sameValueList = PaperCardGroup.getSameCardsList_(clone(cards))
	local kanList = PaperCardGroup.getAimSortList(sameValueList)
	return kanList
end

function PaperCardGroup.addZaPaiToKan_(cards, kanList)
	for i=1, #cards, 3 do
		local kan = {}
		table.insert(kan, cards[i])
		if cards[i+1] then
			table.insert(kan, cards[i+1])
		end
		if cards[i+2] then
			table.insert(kan, cards[i+2])
		end
		BaseAlgorithm.sortSmallToBig(kan)
		table.insert(kanList, kan)
	end
end

function PaperCardGroup.searchDaXiaoZiKan_(cards, kanList)
	local tempCards = clone(cards)
	for i,v in ipairs(tempCards) do
		PaperCardGroup.searchDaXiaoZi_(v, cards,kanList)
	end
end

function PaperCardGroup.searchDaXiaoZi_(card, cards, kanList)
	local suit = BaseAlgorithm.getSuit(card)
	local value = BaseAlgorithm.getValue(card)
	local tempCard = BaseAlgorithm.getBigOrSmallCard(card)
	if table.indexof(cards, tempCard)  then
		local kan = {card, tempCard}
		BaseAlgorithm.sortSmallToBig(kan)
		table.insert(kanList, kan)
		table.removebyvalue(cards, card)
		table.removebyvalue(cards, tempCard)
	end
end


function PaperCardGroup.searchShunZiKan_(cards, kanList)
	local tempCards = clone(cards)
	for i,v in ipairs(tempCards) do
		PaperCardGroup.getShunZi_(v, cards,kanList)
	end
end

function PaperCardGroup.getShunZi_(card, cards,kanList)
	local suit = BaseAlgorithm.getSuit(card)
	local value = BaseAlgorithm.getValue(card)
	local shunZi  = {}
	if value == 10 then
		local card1 = card - 1
		local card2 = card - 2
		if table.indexof(cards, card1)  and table.indexof(cards, card2)  then
			local kan = {}
			table.insert(kan, card2)
			table.insert(kan, card1)
			table.insert(kan, card)
			BaseAlgorithm.sortSmallToBig(kan)
			table.insert(kanList, kan)
			table.removebyvalue(cards, card)
			table.removebyvalue(cards, card1)
			table.removebyvalue(cards, card2)
		end
	else
		local card1 = card - 1
		local card2 = card + 1
		if table.indexof(cards, card1)  and table.indexof(cards, card2)  then
			local kan = {}
			table.insert(kan, card2)
			table.insert(kan, card1)
			table.insert(kan, card)
			table.insert(kanList, kan)
			BaseAlgorithm.sortSmallToBig(kan)
			table.removebyvalue(cards, card)
			table.removebyvalue(cards, card1)
			table.removebyvalue(cards, card2)
		end
	end
end

function PaperCardGroup.searchHuXiKan_(tempCards, kanList)
	if table.indexof(tempCards, 102)
		and table.indexof(tempCards, 107)  
		and table.indexof(tempCards, 110)  then
		local kan = {}
		table.insert(kan, 102)
		table.insert(kan, 107)
		table.insert(kan, 110)
		table.insert(kanList, kan)
		table.removebyvalue(tempCards, 102)
		table.removebyvalue(tempCards, 107)
		table.removebyvalue(tempCards, 110)
	end
	if table.indexof(tempCards, 202) 
		and table.indexof(tempCards, 207) 
		and table.indexof(tempCards, 210) then
		local kan = {}
		table.insert(kan, 202)
		table.insert(kan, 207)
		table.insert(kan, 210)
		table.insert(kanList, kan)
		table.removebyvalue(tempCards, 202)
		table.removebyvalue(tempCards, 207)
		table.removebyvalue(tempCards, 210)
	end
	if table.indexof(tempCards, 101) 
		and table.indexof(tempCards, 102) 
		and table.indexof(tempCards, 103)  then
		local kan = {}
		table.insert(kan, 101)
		table.insert(kan, 102)
		table.insert(kan, 103)
		table.insert(kanList, kan)
		table.removebyvalue(tempCards, 101)
		table.removebyvalue(tempCards, 102)
		table.removebyvalue(tempCards, 103)
	end
	if table.indexof(tempCards, 201) 
		and table.indexof(tempCards, 202) 
		and table.indexof(tempCards, 203) then
		local kan = {}
		table.insert(kan, 201)
		table.insert(kan, 202)
		table.insert(kan, 203)
		table.insert(kanList, kan)
		table.removebyvalue(tempCards, 201)
		table.removebyvalue(tempCards, 202)
		table.removebyvalue(tempCards, 203)
	end
end

function PaperCardGroup.sortSameValueKanByValue_(list)
	local function comp(a,b)
		local suitA = BaseAlgorithm.getSuit(a[1])
		local valueA = BaseAlgorithm.getValue(a[1])
		local suitB = BaseAlgorithm.getSuit(b[1])
		local valueB = BaseAlgorithm.getValue(b[1])
		if valueA == valueB then
			return suitA < suitB
		else
			return valueA < valueB
		end
	end
	table.sort(list, comp)
end

-- 根据指定的牌来搜索有胡息的顺子
function PaperCardGroup.searchYouHuXiShunByCard(card, stat)
	local cvalue = BaseAlgorithm.getValue(card)
	if cvalue ~= 1 and cvalue ~= 7 then
		return nil
	end

	local c1, c2, c3 = 0, 0, 0
	if card == 201 or card == 101 then
		c1, c2, c3 = card, card + 1, card + 2
	else
		c1, c2, c3 = card - 5, card, card + 3
	end
	
	if stat[c1] > 0 and stat[c2] > 0 and stat[c3] > 0 then
		return {c1, c2, c3}
	end

	return nil
end
-- 搜索手里的有胡息的组
function PaperCardGroup.searchYouHuXiGroup(kan_list, stat, cards)	
	for k, card in pairs(search_cards) do
		local tmp = PaperCardGroup.searchYouHuXiShunByCard(card, stat)
		if tmp then
			table.insert(kan_list, tmp)
			for k,c in pairs(tmp) do
				stat[c] = stat[c] - 1
				table.removebyvalue(cards, c)
			end
		end
	end
end

-- 清空空坎
function PaperCardGroup.removeEmptyItem(list)
	for k,v in pairs(list) do
		if not v or #v < 1 then
			table.remove(list, k)
			return PaperCardGroup.removeEmptyItem(list)
		end
	end
end

-- 拆相同值的牌
function PaperCardGroup.groupDaXiaoDa(stat, kan_list)
	for i = 210, 201, -1 do
		local b_num, s_num = stat[i], stat[i - 100]
		local tmp = {}
		for j = 1, b_num do
			table.insert(tmp, i)
		end
		for j = 1, s_num do
			table.insert(tmp, i - 100)
		end
		if #tmp > 0 then
			table.insert(kan_list, tmp)
		end
	end
	return kan_list
end

-- 拆单牌
function PaperCardGroup.chaiDanPai(list)
	for i = 1, #list - 1 do
		if #list[i] == 1 and #list[i + 1] == 1 then
			table.insert(list[i], list[i + 1][1])
			list[i + 1] = {}
			if i + 2 <= #list and #list[i + 2] == 1 then
				table.insert(list[i], list[i + 2][1])
				list[i + 2] = {}
			end
		elseif #list[i] == 1 and #list[i + 1] == 2 then
			table.insert(list[i], list[i + 1][1])
			table.insert(list[i], list[i + 1][2])
			list[i + 1] = {}
		elseif #list[i] == 2 and #list[i + 1] == 1 then
			table.insert(list[i], list[i + 1][1])
			list[i + 1] = {}
		end
	end
	PaperCardGroup.removeEmptyItem(list)
	return list
end

-- 组合单牌至最后一坎
function PaperCardGroup.groupDanPai(list)
	local single = {}
	for k,v in pairs(list) do
		if v and #v == 1 and #single < 4 then
			table.insert(single, v[1])
			list[k] = {}
		end
	end
	PaperCardGroup.removeEmptyItem(list)
	if #single > 0 then
		table.insert(list, single)
	end
	return list
end

-- 组合连对来拆牌
function PaperCardGroup.groupXPair(list)
	for i = 1, #list - 1, 2 do -- 将连对组合在一起
		if #list[i] == 2 
			and #list[i + 1] == 2 
			and list[i][1] == list[i][2] 
			and list[i + 1][1] == list[i + 1][2] 
			and list[i][1] - list[i + 1][1] == 1 then

			table.insert(list[i], list[i + 1][1])
			table.insert(list[i], list[i + 1][2])
			list[i+1] = {}
		end
	end
	PaperCardGroup.removeEmptyItem(list)
	return list
end

-- 没办法了将任意两张牌组合在一起
function PaperCardGroup.groupTwoCardsGroup(list)
	local curr_num = #list
	for i = #list, 2, -1 do
		local otherTarget, otherK = nil, 0
		if #list[i] == 1 or #list[i] == 2 then
			for j = i - 1, 1, -1 do
				if j < #list and #list[j] < 3 then
					otherTarget = list[j]
					otherK = j
					break
				end
			end
		end

		if otherTarget and otherK then
			for k,v in pairs(otherTarget) do
				table.insert(list[i], v)
			end
			list[otherK] = {}
			curr_num = curr_num - 1
		end

		if curr_num <= 7 then
			break
		end
	end
	PaperCardGroup.removeEmptyItem(list)
	return list
end

-- 搜索手牌的拆牌方式 forceGroup  是否强制分类
function PaperCardGroup.chaiPai(cards, natureGroup)
	local cards = clone(cards)
	local stat = BaseAlgorithm.statCards(cards)
	local kan_list = {} -- 起手提或坎
	BaseAlgorithm.searchTi(stat, cards, kan_list)
	BaseAlgorithm.searchKan(stat, cards, kan_list)
	for k, item in pairs(kan_list) do
		for k, c in pairs(item) do
			table.removebyvalue(cards, c)
		end
	end
	PaperCardGroup.searchYouHuXiGroup(kan_list, stat, cards)
	local  kannum = math.ceil(#cards/3)
	local list = PaperCardGroup.groupDaXiaoDa(stat, kan_list)
	list = PaperCardGroup.groupXPair(list)

	if natureGroup then
		return list
	end
	if kannum - 1 < #list and #list <= kannum then
			return list
	end

	list = PaperCardGroup.chaiDanPai(list)
	if kannum - 1 < #list and #list <= kannum then
			return list
	end

	list = PaperCardGroup.groupDanPai(list)
	return PaperCardGroup.groupTwoCardsGroup(list)
end

-- 拆单牌
function PaperCardGroup.groupRouverKan(stat, kan_list)		
	local tmp = {}
	for i = 210, 201, -1 do
		local b_num, s_num = stat[i], stat[i - 100]
		for j = 1, b_num do
			table.insert(tmp, i)
			if #tmp == 3 then
				table.insert(kan_list, tmp)
				tmp = {}
			end
		end
		for j = 1, s_num do
			table.insert(tmp, i - 100)
			if #tmp == 3 then
				table.insert(kan_list, tmp)
				tmp = {}
			end
		end
	end
	if #tmp > 0 then
		table.insert(kan_list, tmp)
		tmp = {}
	end
	return kan_list
end

-- 搜索手牌的拆牌方式 forceGroup  是否强制分类
function PaperCardGroup.roundOverChaiPai(cards)
	local cards = clone(cards)
	local stat = BaseAlgorithm.statCards(cards)
	local kan_list = {} -- 起手提或坎
	BaseAlgorithm.searchTi(stat, cards, kan_list)
	BaseAlgorithm.searchKan(stat, cards, kan_list)
	for k, item in pairs(kan_list) do
		for k, c in pairs(item) do
			table.removebyvalue(cards, c)
		end
	end
	PaperCardGroup.searchYouHuXiGroup(kan_list, stat, cards)
	local list = PaperCardGroup.groupRouverKan(stat, kan_list)
	return list
	
end

return PaperCardGroup
