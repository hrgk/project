local BaseAlgorithm = import(".BaseAlgorithm")
local PaoHuZiAlgorithm = {}

local _ipairs, _pairs = ipairs, pairs

-- 计算提牌的胡息
function PaoHuZiAlgorithm.calcHuXiTi(cards)
	if not BaseAlgorithm.isFour(cards) then
		return 0
	end

	local s = BaseAlgorithm.getSuit(cards[1])
	if s == SUIT_BIG then
		return HX_TI_DA
	end
	return HX_TI_XIAO
end

-- 计算跑牌的胡息
function PaoHuZiAlgorithm.calcHuXiPao(cards)
	if not BaseAlgorithm.isFour(cards) then
		return 0
	end
	local s = BaseAlgorithm.getSuit(cards[1])
	if s == SUIT_BIG then
		return HX_PAO_DA
	end
	return HX_PAO_XIAO
end

-- 计算偎牌的胡息
function PaoHuZiAlgorithm.calcHuXiWei(cards)
	if not BaseAlgorithm.isThree(cards) then
		return 0
	end
	local s = BaseAlgorithm.getSuit(cards[1])
	if s == SUIT_BIG then
		return HX_WEI_DA
	end
	return HX_WEI_XIAO
end

-- 计算碰牌的胡息
function PaoHuZiAlgorithm.calcHuXiPeng(cards)
	if not BaseAlgorithm.isThree(cards) then
		return 0
	end
	local s = BaseAlgorithm.getSuit(cards[1])
	if s == SUIT_BIG then
		return HX_PENG_DA
	end
	return HX_PENG_XIAO
end

-- 计算顺子的胡息
function PaoHuZiAlgorithm.calcHuXiShun(cards)
	if not BaseAlgorithm.isShun(cards) then
		return 0
	end
	table.sort(cards, BaseAlgorithm.cardSortCompare)
	local s, v = BaseAlgorithm.getSuit(cards[1]), BaseAlgorithm.getValue(cards[1])
	if v == 3 then
		if s == SUIT_BIG then 
			return HX_123_DA 
		end
		return HX_123_XIAO
	end
	
	return 0
end

-- 计算2710的胡息
function PaoHuZiAlgorithm.calcHuXi2710(cards)
	if not BaseAlgorithm.is2710(cards) then
		return 0
	end
	table.sort(cards, BaseAlgorithm.cardSortCompare)
	local s, v = BaseAlgorithm.getSuit(cards[1]), BaseAlgorithm.getValue(cards[1])
	if v == 10 then
		if s == SUIT_BIG then
			return HX_2710_DA
		end
		return HX_2710_XIAO
	end
	
	return 0
end

local calcHuXiFunctions = {}
calcHuXiFunctions[CTYPE_TI] = PaoHuZiAlgorithm.calcHuXiTi
calcHuXiFunctions[CTYPE_PAO] = PaoHuZiAlgorithm.calcHuXiPao
calcHuXiFunctions[CTYPE_WEI] = PaoHuZiAlgorithm.calcHuXiWei
calcHuXiFunctions[CTYPE_CHOU_WEI] = PaoHuZiAlgorithm.calcHuXiWei
calcHuXiFunctions[CTYPE_PENG] = PaoHuZiAlgorithm.calcHuXiPeng
calcHuXiFunctions[CTYPE_SHUN] = PaoHuZiAlgorithm.calcHuXiShun
calcHuXiFunctions[CTYPE_2710] = PaoHuZiAlgorithm.calcHuXi2710

-- 根据牌型和牌计算胡息
function PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(ctype, cards)
	if not cards or #cards <= 2 then
		return 0
	end

	local func = calcHuXiFunctions[ctype]
	if not func then
		return 0
	end
	return func(cards)
end

-- 计算三张牌的胡息
function PaoHuZiAlgorithm.calcThreeHuXi(cards)
	local ctype = BaseAlgorithm.getCtypeOfThree(cards)
	if ctype > 0 then
		return	PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(ctype, cards)
	end

	return 0
end

-- 计算桌面胡息, cards变量结构为
-- {{牌型, 牔1...牌N}, ...}
function PaoHuZiAlgorithm.calcTableHuXi(cards)
	local table_hu_xi = 0
	if not cards or type(cards) ~= 'table' then
		return table_hu_xi
	end
	for k, v in _pairs(cards) do
		if #v > 2 then
			local tmp_cards = clone(v)
			table.remove(tmp_cards, 1)
			table_hu_xi = table_hu_xi +	PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(v[1], tmp_cards)
		end
	end
	return table_hu_xi
end

-- 计算总胡息
-- 参数说明：胡牌路径，当前所胡牌，桌面牌，是否是自摸
function PaoHuZiAlgorithm.calcHuXi(hu_method)
	local hu_xi = 0 -- 总胡息
	if not hu_method or type(hu_method) ~= 'table' then
		return hu_xi
	end

	local table_cards, hu_path, hu_hand = unpack(hu_method)
	hu_xi = hu_xi + PaoHuZiAlgorithm.calcTableHuXi(table_cards)

	for i = 1, #hu_path do
		local v = hu_path[i]
		if BaseAlgorithm.isFour(v) then
			hu_xi = hu_xi +	PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(CTYPE_TI, v)
		elseif #v > 2 then
			local tmp_cards = clone(v)
			hu_xi = hu_xi +	PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(BaseAlgorithm.getCtypeOfThree(tmp_cards), tmp_cards)
		end
	end

	hu_xi = hu_xi + PaoHuZiAlgorithm.calcTableHuXi({hu_hand})
	return hu_xi
end

-- 找到胡牌的起始牌
function PaoHuZiAlgorithm.getHuPaiStartCard(stat)
	for k, v in _pairs(stat) do
		if v > 0 then
			return k
		end
	end

	return false
end

-- 查看一个统计表中是否还有牌
function PaoHuZiAlgorithm.isEmptyStat(stat)
	for k, v in _pairs(stat) do
		if v > 0 then
			return false
		end
	end

	return true
end

-- 检查能否碰牌
function PaoHuZiAlgorithm.canPeng(cards, curr_card)
	local stat = BaseAlgorithm.statCards(cards)
	if not stat[curr_card] or stat[curr_card] ~= 2 then
		return false
	end

	return true
end

-- 根据要吃的牌来产生可吃牌的组合, 不包含要自身
function PaoHuZiAlgorithm.makeCombination(card)
	local v = BaseAlgorithm.getValue(card)
	if v == 1 then
		return {{card + 1, card + 2}, }
	end

	if v == 2 then
		return {{card + 1, card + 2}, {card - 1, card + 1}}
	end

	if v == 9 then
		return {{card - 2, card - 1}, {card - 1, card + 1}}
	end

	if v == 10 then
		return {{card - 2, card - 1}, }
	end

	return {{card - 2, card - 1}, {card - 1, card + 1}, {card + 1, card + 2}}
end

-- 产生吃牌组合，包含自身
function PaoHuZiAlgorithm.makeBiPaiCombination(card)
	local ret = PaoHuZiAlgorithm.makeCombination(card)
	for i = 1, #ret do
		table.insert(ret[i], 1, card)
	end
	return ret
end

-- 二七十比牌搜索
function PaoHuZiAlgorithm.searchBiPai2710(stat, curr_card, ret)
	if not stat[curr_card] or stat[curr_card] < 1 then
		return
	end
	local v = BaseAlgorithm.getValue(curr_card)
	local s = BaseAlgorithm.getSuit(curr_card)
	local range_list = {2, 7, 10}
	if false == table.indexof(range_list, v) then
		return
	end
	table.removebyvalue(range_list, v)

	for k, item in _pairs(range_list) do
		local c = BaseAlgorithm.makeCard(s, item)
		if stat[c] < 1 or stat[c] > 2 then
			return
		end
	end

	table.insert(ret, {curr_card, BaseAlgorithm.makeCard(s, range_list[1]), BaseAlgorithm.makeCard(s, range_list[2])})
end

-- 大小配比牌搜索
function PaoHuZiAlgorithm.searchBiPaiDaXiaoPei(stat, curr_card, ret)
	if not stat[curr_card] or stat[curr_card] < 1 then
		return
	end
	local v = BaseAlgorithm.getValue(curr_card)
	local small_card, big_card = BaseAlgorithm.makeCard(SUIT_SMALL, v), BaseAlgorithm.makeCard(SUIT_BIG, v)

	if false == table.indexof({0, 1, 2}, stat[small_card]) then -- 吃牌不能拆坎
		return
	end
	if false == table.indexof({0, 1, 2}, stat[big_card]) then -- 吃牌不能拆坎
		return
	end

	if 3 > stat[small_card] + stat[big_card] then -- 牌数不够搭
		return
	end

	local oppositeCard = BaseAlgorithm.makeCard(BaseAlgorithm.getOppositeSuit(BaseAlgorithm.getSuit(curr_card)), v)
	if stat[curr_card] == 2 then
		table.insert(ret, {curr_card, curr_card, oppositeCard})
	end	
	if stat[oppositeCard] == 2 then
		table.insert(ret, {curr_card, oppositeCard, oppositeCard})
	end
end

-- 顺子比牌搜索
function PaoHuZiAlgorithm.searchBiPaiShun(stat, curr_card, ret)
	if not stat[curr_card] or stat[curr_card] < 1 then
		return
	end
	local range_tuple = PaoHuZiAlgorithm.makeBiPaiCombination(curr_card) -- 产生可比的组合
	for i = 1, #range_tuple do
		local item = range_tuple[i]
		local flag = true
		for k, c in _pairs(item) do
			if false == table.indexof({1, 2}, stat[c]) then
				flag = false
				break
			end
		end

		if flag then
			table.insert(ret, item)
		end
	end
end

-- 计算某张牌的可能的组合，只计算手上的牌，
-- 用于比牌或者胡牌判断时
function PaoHuZiAlgorithm.calcMatchCombination(stat, curr_card)
	local ret = {}
	PaoHuZiAlgorithm.searchBiPai2710(stat, curr_card, ret)
	PaoHuZiAlgorithm.searchBiPaiShun(stat, curr_card, ret)
	PaoHuZiAlgorithm.searchBiPaiDaXiaoPei(stat, curr_card, ret)
	return ret
end

-- 搜索比牌
function PaoHuZiAlgorithm.searchBiPai(stat, curr_card, chi_data, chiList)
	if stat[curr_card] == 0 then
		table.insert(chiList, chi_data)
		return
	end

	local ret = PaoHuZiAlgorithm.calcMatchCombination(stat, curr_card)

	if #ret <= 0 then -- 否定此比牌方式，有牌无法比出
		return
	end

	for i = 1, #ret do
		local tmp_stat = clone(stat)
		local tmp_chi_data = clone(chi_data)
		table.insert(tmp_chi_data, ret[i])
		for j = 1, #ret[i] do
			tmp_stat[ret[i][j]] = tmp_stat[ret[i][j]] - 1
		end
		if tmp_stat[curr_card] > 0 then
			PaoHuZiAlgorithm.searchBiPai(tmp_stat, curr_card, tmp_chi_data, chiList)
		elseif tmp_stat[curr_card] == 0 then
			table.insert(chiList, tmp_chi_data) -- 比牌达到要求，添加进队列
		end
	end
end

-- 搜索二七十的吃牌组合
function PaoHuZiAlgorithm.searchChi2710(stat, curr_card, ret)
	local v = BaseAlgorithm.getValue(curr_card)
	local s = BaseAlgorithm.getSuit(curr_card)
	local range_list = {2, 7, 10}
	if false == table.indexof(range_list, v) then
		return
	end
	table.removebyvalue(range_list, v)

	for k, item in _pairs(range_list) do
		if false == table.indexof({1, 2}, stat[BaseAlgorithm.makeCard(s, item)]) then
			return
		end
	end

	table.insert(ret, {BaseAlgorithm.makeCard(s, range_list[1]), BaseAlgorithm.makeCard(s, range_list[2])})
end

-- 搜索大小搭的吃牌组合
function PaoHuZiAlgorithm.searchChiDaXiaoDa(stat, curr_card, ret)
	local v = BaseAlgorithm.getValue(curr_card)
	local small_card, big_card = BaseAlgorithm.makeCard(SUIT_SMALL, v), BaseAlgorithm.makeCard(SUIT_BIG, v)

	if false == table.indexof({0, 1, 2}, stat[small_card]) then -- 吃牌不能拆坎
		return
	end
	if false == table.indexof({0, 1, 2}, stat[big_card]) then -- 吃牌不能拆坎
		return
	end

	if 2 > stat[small_card] + stat[big_card] then -- 牌数不够吃
		return
	end

	if stat[big_card] > 0 and stat[small_card] > 0 then
		table.insert(ret, {big_card, small_card})
	end

	local oppositeSuit = BaseAlgorithm.getOppositeSuit(BaseAlgorithm.getSuit(curr_card))
	if stat[BaseAlgorithm.makeCard(oppositeSuit, v)] == 2 then
		table.insert(ret, {BaseAlgorithm.makeCard(oppositeSuit, v), BaseAlgorithm.makeCard(oppositeSuit, v)})
	end
end

-- 搜索顺子的吃牌组合
function PaoHuZiAlgorithm.searchChiShun(stat, curr_card, ret)
	local range_tuple = PaoHuZiAlgorithm.makeCombination(curr_card) -- 产生可吃的组合

	for i = 1, #range_tuple do
		local item = range_tuple[i]
		local flag = true
		for k, c in _pairs(item) do
			if false == table.indexof({1, 2}, stat[c]) then
				flag = false
				break
			end
		end

		if flag then
			table.insert(ret, item)
		end
	end
end

-- 寻找可吃的牌, 返回结果为 三层table, 第一层代表一种吃牌路径 {{{牌1, 牌2}, }, ...}
-- 第二层第一项只有两项数据，表示自己要组吃牌的两张牌，后面的项代表吃牌后要比的牌，没有则为空
--[[ 例如：{
		1 = { -- 第一种吃法
				1 = { -- 要组吃的牌
						1 = 102
						2 = 110
				}
				2 = { -- 要比出的牌
						1 = 107
						2 = 102
						3 = 110
				}
		}
		2 = { -- 第二种吃法
				1 = {-- 要组吃的牌
						1 = 102
						2 = 110
				}
				2 = {-- 要比出的牌
						1 = 107
						2 = 106
						3 = 108
				}
		}
]]--
function PaoHuZiAlgorithm.searchChi(cards, curr_card, notWithBiPai)
	local ret, chiList = {}, {}
	local stat = BaseAlgorithm.statCards(cards)
	
	if false == table.indexof({0, 1, 2}, stat[curr_card]) then	-- 吃牌不拆坎
		return chiList
	end

	for k, v in _pairs(stat) do -- 吃牌不拆坎
		if 3 == v then
			stat[k] = 0
		end
	end

	PaoHuZiAlgorithm.searchChi2710(stat, curr_card, ret)
	PaoHuZiAlgorithm.searchChiShun(stat, curr_card, ret)
	PaoHuZiAlgorithm.searchChiDaXiaoDa(stat, curr_card, ret)

	if notWithBiPai then -- 不考虑比牌情况的吃，用于胡牌判断
		return ret
	end

	for i = 1, #ret do
		local tmp_stat = clone(stat)
		tmp_stat[ret[i][1]] = tmp_stat[ret[i][1]] - 1
		tmp_stat[ret[i][2]] = tmp_stat[ret[i][2]] - 1
		PaoHuZiAlgorithm.searchBiPai(tmp_stat, curr_card, {ret[i]}, chiList)
	end
	
	return chiList
end

-- 检查是否可以吃牌
function PaoHuZiAlgorithm.canChi(cards, curr_card)
	local chiList = PaoHuZiAlgorithm.searchChi(cards, curr_card)
	return (chiList and 0 < #chiList)
end

-- 从最小牌来搜索胡牌路径
function PaoHuZiAlgorithm.matchCombinationFromMinCard(stat, path, path_list)
	if PaoHuZiAlgorithm.isEmptyStat(stat) then
		table.insert(path_list, path)
		return path_list
	end

	local start_card = PaoHuZiAlgorithm.getHuPaiStartCard(stat)
	local matchCombination = PaoHuZiAlgorithm.calcMatchCombination(stat, start_card)
	if #matchCombination < 1 then -- 不符合规则，返回
		return path_list
	end

	for k, v in _pairs(matchCombination) do
		local tmp_stat = clone(stat)
		local tmp_path = clone(path)
		table.insert(tmp_path, v)
		for k2, c in _pairs(v) do -- 减去已加入的牌
			tmp_stat[c] = tmp_stat[c] - 1
		end
		if PaoHuZiAlgorithm.isEmptyStat(tmp_stat) then
			table.insert(path_list, tmp_path)
		else
			PaoHuZiAlgorithm.matchCombinationFromMinCard(tmp_stat, tmp_path, path_list)
		end
	end

	return path_list
end

-- 从各种匹配中生成胡法列表
function PaoHuZiAlgorithm.makeHuList(match_list, table_cards, hu_hand)
	if not match_list then
		return {}
	end

	local hu_list = {}
	for k,item in _pairs(match_list) do
		table.insert(hu_list, {table_cards, item, hu_hand})
	end

	return hu_list
end


-- 检查对子能否出现在胡牌中
function PaoHuZiAlgorithm.isDanDiao(table_cards, kan_list)
	if table_cards == nil then return end
	for k, v in _pairs(table_cards) do
		if v[1] == CTYPE_PAO or v[1] == CTYPE_TI then
			return true
		end
	end

	for k, v in _pairs(kan_list) do
		if v and #v == 4 then
			return true
		end
	end

	return false
end

-- 搜索最后以对子胡牌
function PaoHuZiAlgorithm.searchDanDiaoHu(stat, kan_list, table_cards, curr_card)
	if stat[curr_card] ~= 1 then
		return {}
	end
	
	local duiZiOK = PaoHuZiAlgorithm.isDanDiao(table_cards, kan_list) -- 是否检查对子胡牌
	if not duiZiOK then
		return {}
	end

	local tmp_stat = clone(stat)
	tmp_stat[curr_card] = tmp_stat[curr_card] - 1
	local hu_path = clone(kan_list)
	local match_list = PaoHuZiAlgorithm.matchCombinationFromMinCard(tmp_stat, hu_path, {})
	local hu_hand = {CTYPE_PAIR, curr_card, curr_card}
	return PaoHuZiAlgorithm.makeHuList(match_list, table_cards, hu_hand)
end

-- 搜索对子列表
function PaoHuZiAlgorithm.searchPairList(stat)
	local ret = {}
	for k, v in _pairs(stat) do
		if v == 2 then
			table.insert(ret, k)
		end
	end
	return ret
end

-- 去掉一个对子后来匹配组牌策略路径
function PaoHuZiAlgorithm.matchCombinationWithPair(stat, hu_path)
	local dz_list = PaoHuZiAlgorithm.searchPairList(stat)
	local ret = {}
	for k, c in _pairs(dz_list) do -- 一个个尝试是否可以胡牌
		local tmp_stat = clone(stat)
		tmp_stat[c] = 0
		local hu_path2 = clone(hu_path)
		table.insert(hu_path2, {c, c})
		local match_list = PaoHuZiAlgorithm.matchCombinationFromMinCard(tmp_stat, hu_path2, {})
		for k,v in _pairs(match_list) do
			table.insert(ret, v)
		end
	end

	return ret
end

-- 搜索跑胡
function PaoHuZiAlgorithm.searchPaoHu(stat, hu_path, table_cards, curr_card)
	if table_cards == nil then return end
	for i = 1, #table_cards do
		local t = table_cards[i][1] -- 类型
		local v = table_cards[i][2] -- 值
		if (t == CTYPE_PENG or t == CTYPE_WEI or t == CTYPE_CHOU_WEI) and curr_card == v then
			local match_list = PaoHuZiAlgorithm.matchCombinationWithPair(stat, hu_path)
			if #match_list > 0 then
				table_cards[i] = {CTYPE_PAO, v, v, v, v}
				return PaoHuZiAlgorithm.makeHuList(match_list, table_cards, {})
			end
		end
	end

	for i = 1, #hu_path do
		local item = hu_path[i]
		if #item == 3 and item[1] == item[2] and item[2] == item[3] and curr_card == item[1] then
			local tmp_hu_path = clone(hu_path)
			table.remove(tmp_hu_path, i)
			local match_list = PaoHuZiAlgorithm.matchCombinationWithPair(stat, tmp_hu_path, hu_list)
			if #match_list > 0 then
				local hu_hand = {CTYPE_PAO, curr_card, curr_card, curr_card, curr_card}
				return PaoHuZiAlgorithm.makeHuList(match_list, table_cards, hu_hand)
			end
		end
	end

	return {}
end

-- 判断是否是提牌
function PaoHuZiAlgorithm.isTiPai(hu_path, curr_card, bySelf)
	if not bySelf then
		return false
	end

	for i = 1, #hu_path do
		local item = hu_path[i]
		if #item == 3 and item[1] == item[2] and item[2] == item[3] and curr_card == item[1] then
			return true
		end
	end

	return false
end

-- 搜索提胡的胡牌方式
function PaoHuZiAlgorithm.searchTiHu(stat, hu_path, table_cards, curr_card, bySelf)
	if not bySelf then -- 提胡必须是自己摸上来的牌
		return {}
	end

	for i = 1, #hu_path do
		local item = hu_path[i]
		if #item == 3 and item[1] == item[2] and item[2] == item[3] and curr_card == item[1] then
			local tmp_hu_path = clone(hu_path)
			table.remove(tmp_hu_path, i)
			local match_list = PaoHuZiAlgorithm.matchCombinationWithPair(stat, tmp_hu_path)
			if #match_list > 0 then
				local hu_hand = {CTYPE_TI, curr_card, curr_card, curr_card, curr_card}
				return PaoHuZiAlgorithm.makeHuList(match_list, table_cards, hu_hand)
			end
		end
	end

	return {}
end

-- 不考虑胡息的搜索可胡牌的路径
-- 参数说明：手牌，手牌统计，胡牌路径已确定的值，桌牌，当前牌，胡牌列表
function PaoHuZiAlgorithm.searchChiPengWeiHu(cards, stat, hu_path, table_cards, curr_card, bySelf)
	local try_list = PaoHuZiAlgorithm.searchChi(cards, curr_card, true)

	if 2 == stat[curr_card] then -- 以碰或者偎胡牌 插入第一个位置，优先碰
		table.insert(try_list, 1, {curr_card, curr_card})
	end

	for i = 1, #try_list do -- 以吃胡牌
		local tmp_stat = clone(stat)
		local c1, c2 = unpack(try_list[i])
		tmp_stat[c1] = tmp_stat[c1] - 1
		tmp_stat[c2] = tmp_stat[c2] - 1
		local hu_path2 = clone(hu_path)
		local hu_hand = {c1, c2, curr_card}
		local ctype = BaseAlgorithm.getCtypeOfThree(hu_hand)
		if BaseAlgorithm.isThree(hu_hand) then
			if bySelf then
				ctype = CTYPE_WEI
			else
				ctype = CTYPE_PENG
			end
		end
		table.insert(hu_hand, 1, ctype)

		local match_list = {}
		if 2 == (#cards - #try_list[i]) % 3 then -- 还有一个对子
			match_list = PaoHuZiAlgorithm.matchCombinationWithPair(tmp_stat, hu_path2)
		else
			match_list = PaoHuZiAlgorithm.matchCombinationFromMinCard(tmp_stat, hu_path2, {})
		end

		if #match_list > 0 then
			return PaoHuZiAlgorithm.makeHuList(match_list, table_cards, hu_hand)
		end
	end

	return {}
end

-- 搜索胡息够的胡法
function PaoHuZiAlgorithm.searchRealHuList(curr_card, table_cards, bySelf, hu_list)
	local real_hu_list = {}
	if not hu_list or #hu_list < 1 then -- 胡不起
		return real_hu_list
	end
	for k, v in _pairs(hu_list) do
		local hu_xi = PaoHuZiAlgorithm.calcHuXi(v)
		if hu_xi >= HU_XI_MIN then
			table.insert(real_hu_list, {hu_xi, v})
		end
	end

	return real_hu_list
end

function PaoHuZiAlgorithm.setMinHuXi(count)
	HU_XI_MIN = count
end

-- 如果自己的牌符合以下条件就可以胡牌： 
-- ①手中和桌面上共有7方门子，全部由以上几种牌型（对（如果出现跑或提）、坎、碰、偎、臭偎、提、跑、一句话、绞）组成。 
-- ②胡息数>=15 
-- ③只能胡各玩家从墩上摸出来并且明示的牌（可以是自已摸的也可以是别人摸的），任何人打出的牌都不能胡。 
-- 请求参数：当前手牌，当前桌牌，摸上来的一张牌，是否是自己摸的
-- 返回值：
--[[{
	1 = { //不同的胡牌方式
		1 = 24 //此手的胡息
		2 = {} //桌牌
		3 = { //此胡牌的组牌方式
			1 = {
				1 = 207
				2 = 208
			}
			2 = {
				1 = 203
				2 = 204
				3 = 205
			}
			3 = {
				1 = 105
				2 = 103
				3 = 104
			}
			4 = {
				1 = 107
				2 = 102
				3 = 110
			}
		}
		4 = [...] 最后一手成牌的效果，结构与桌牌一致
	}
}
]]
function PaoHuZiAlgorithm.searchHu(hand_cards, table_cards, curr_card, bySelf)
	if not curr_card then
		return {}
	end

	local cards = clone(hand_cards)
	local table_cards = clone(table_cards)
	local stat = BaseAlgorithm.statCards(cards)
	local hu_path = {}
	BaseAlgorithm.searchTi(stat, cards, hu_path) -- 搜索起手提
	BaseAlgorithm.searchKan(stat, cards, hu_path) -- 搜索所有的起手三张

	-- 提胡
	local is_ti = PaoHuZiAlgorithm.isTiPai(hu_path, curr_card, bySelf)
	if is_ti then
		local hu_list = PaoHuZiAlgorithm.searchTiHu(stat, hu_path, table_cards, curr_card, bySelf)
		return PaoHuZiAlgorithm.searchRealHuList(curr_card, table_cards, bySelf, hu_list)
	end

	-- 桌面跑胡 手牌跑胡
	local hu_list = PaoHuZiAlgorithm.searchPaoHu(stat, hu_path, table_cards, curr_card)
	if hu_list and #hu_list > 0 then
		return PaoHuZiAlgorithm.searchRealHuList(curr_card, table_cards, bySelf, hu_list)
	end
	
	local hu_list = PaoHuZiAlgorithm.searchDanDiaoHu(stat, hu_path, table_cards, curr_card)	-- 单吊胡
	local hu_list2 = PaoHuZiAlgorithm.searchChiPengWeiHu(cards, stat, hu_path, table_cards, curr_card, bySelf)
	for k,v in _pairs(hu_list2) do
		table.insert(hu_list, v)
	end
	return PaoHuZiAlgorithm.searchRealHuList(curr_card, table_cards, bySelf, hu_list)
end

-- 检查是否可三提五坎直接天胡
function PaoHuZiAlgorithm.canQiShouTianHu(cards)
	local stat = BaseAlgorithm.statCards(cards)
	local kan_num, ti_num = 0, 0 -- 坎、提的数量
	for k, v in _pairs(stat) do
		if v == 3 then
			kan_num = kan_num + 1
		end
		if v == 4 then
			ti_num = ti_num + 1
			kan_num = kan_num + 1 -- 提可以算坎
		end
	end
	if kan_num >= 5 or ti_num >= 3 then
		return true
	end
	return false
end

-- 检查是否可天胡
function PaoHuZiAlgorithm.canTianHu(cards, curr_card, bySelf)
	if PaoHuZiAlgorithm.canQiShouTianHu(cards) then
		return true
	end

	-- 检查是否可吃牌天胡
	local ret = PaoHuZiAlgorithm.searchHu(cards, {}, curr_card, bySelf)
	return #ret > 0
end

function PaoHuZiAlgorithm.canHu(cards, table_cards, curr_card, bySelf)
	if #cards % 3 == 0 then
		return false
	end

	local ret = PaoHuZiAlgorithm.searchHu(cards, table_cards, curr_card, bySelf)
	return #ret > 0
end

function PaoHuZiAlgorithm.isTingPai(remainCards, cards, table_cards)
	local remainCardsMap = gailun.utils.invert(clone(remainCards))
	local result = {}
	for card, _ in _pairs(remainCardsMap) do
		local isHu = PaoHuZiAlgorithm.canHu(cards, table_cards, card, true)
		if isHu then
			return true
		end
	end
	return false
end

function PaoHuZiAlgorithm.getTingOperate(remainCards, cards, table_cards)
	cards = cards or {}
	remainCards = remainCards or {}
	table_cards = table_cards or {}

	local remainCardsMap = gailun.utils.invert(clone(remainCards))
	local result = {}
	local alreadyCheck = {}
	for _, card in _ipairs(cards) do
		if alreadyCheck[card] == nil then
			local handCards = clone(cards)
			table.removebyvalue(handCards, card)
			local isTing = false
			isTing = PaoHuZiAlgorithm.isTingPai(remainCards, handCards, table_cards)

			alreadyCheck[card] = isTing

			if isTing then
				table.insert(result, card)
			end
		end
    end
    
    return result
end

function PaoHuZiAlgorithm.getTingPai(remainCards, cards, table_cards)
	local remainCardsMap = gailun.utils.invert(clone(remainCards))
	local result = {}
	for card, _ in _pairs(remainCardsMap) do
		local isHu = PaoHuZiAlgorithm.canHu(cards, table_cards, card, true)
		if isHu then
			table.insert(result, card)
		end
	end
	return result
end

--[[ {
	params 1 手牌: { {}, {}, {101}}
	params 2 弃牌: { {}, {}, {101}}
	params 3 外牌: {
		{
			{CTYPE_TI, 101, 101, 101, 101},
			{CTYPE_WEI, 208, 208, 208},
			{CTYPE_PENG, 108, 108, 108}
		},
		{
			{CTYPE_TI, 101, 101, 101, 101},
			{CTYPE_WEI, 208, 208, 208},
			{CTYPE_PENG, 108, 108, 108}
		}
}
]]
function PaoHuZiAlgorithm.getRemainCards(handCards, qiPaiCards, waiCards)
	local allCards = {}
	for i = 1, 2 do
		for k = 1, 10 do
			-- allCards[i * 100 + k] = 4
			table.insert(allCards, i * 100 + k)
		end
	end

	do return allCards end
	-- 不做缺牌过滤

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
			for i = 2, 5 do
				local card = waiPai[i]
				if card == nil then
					break
				end

				if allCards[card] ~= nil then
					allCards[card] = allCards[card] - 1
				end
			end
		end
	end
	local result = {}
	for card, count in _pairs(allCards) do
		for i = 1, count, 1 do
			table.insert(result, card)
		end
	end

	return result
end

function PaoHuZiAlgorithm.getCardNum(cardInfo,curCards,aimCards)
	local allCards = {}
	for i = 1, 2 do
		for k = 1, 10 do
			allCards[i * 100 + k] = 4
		end
	end
	if allCards[curCards] ~= nil then
		allCards[curCards] = allCards[curCards] - 1
	end
	for i = 1,3 do
		local userCard = cardInfo[i]
		local chuPai = userCard.chuCards
		if chuPai then
			for j = 1,#chuPai do
				local card = chuPai[j]
				if allCards[card] ~= nil then
					allCards[card] = allCards[card] - 1
				end
			end
		end
		local handCards = userCard.handCards
		if handCards then
			for j = 1,#handCards do
				local card = handCards[j]
				if allCards[card] ~= nil then
					allCards[card] = allCards[card] - 1
				end
			end
		end
		local zhuoCards = userCard.zhuoCards
		if zhuoCards then
			for j = 1,#zhuoCards do
				local zhuoCard = zhuoCards[j]
				for q = 2,5 do
					local card = zhuoCard[q]
					if card then
						if allCards[card] ~= nil then
							allCards[card] = allCards[card] - 1
						end
					end
				end
			end
		end
	end
	local result = {}
	for card, count in _pairs(allCards) do
		if table.indexof(aimCards,card) ~= false then
			local temp = {
				card = card,
				count = count,
			}
			table.insert(result, temp)
		end
	end
	local function cmp(a,b)
		return a.card < b.card
	end
	table.sort(result,cmp)
	return result
end

return PaoHuZiAlgorithm
