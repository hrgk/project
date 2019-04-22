local BaseAlgorithm = import(".BaseAlgorithm")
local ZZAlgorithm = import(".ZZAlgorithm")

local CSAlgorithm = {}

local _ipairs, _pairs = ipairs, pairs

local ACTION_TYPE = {
    CHU = 1,
    CHI = 2,
    PENG = 3,
    GONG_GANG = 4,
    AN_GANG = 5,
    MING_GANG = 6,
    BU = 7,
    GUO = 8,
    HU = 9,
    ZI_MO = 10,
    ZHUA_NIAO = 11,
    QIANG_GANG_HU = 12,
    GONG_BU = 13,
    AN_BU = 14,
    MING_BU = 15,
}

local specialJiangValues = {2, 5, 8}

function CSAlgorithm.isSevenPairs(zhuoCards, cards)
    local flag, path = ZZAlgorithm.isSevenPairs_(cards, 0)
    if flag then
        return true, path
    end

    return false, {}
end

function CSAlgorithm.isJiangJiangHu(zhuoCards, cards)
    local jiangValueMap = gailun.utils.invert(specialJiangValues)
    for _, zhuoCardsCeil in _ipairs(zhuoCards) do
        for i = 1, #zhuoCardsCeil.cards, 1 do
            if not jiangValueMap[BaseAlgorithm.getValue(zhuoCardsCeil.cards[i])] then
                return false, {}
            end
        end
    end

    for _, card in _ipairs(cards) do
        if not jiangValueMap[BaseAlgorithm.getValue(card)] then
            return false, {}
        end
    end

    return true, {cards}
end

function CSAlgorithm.isQingYiSe(zhuoCards, cards)
    local suit = nil
    for _, zhuoCardsCeil in _ipairs(zhuoCards) do
        for i = 1, #zhuoCardsCeil.cards, 1 do
            local nowSuit = BaseAlgorithm.getSuit(zhuoCardsCeil.cards[i])
            if suit ~= nil and nowSuit ~= suit then
                return false, {}
            end

            suit = nowSuit
        end
    end

    for _, card in _ipairs(cards) do
        local nowSuit = BaseAlgorithm.getSuit(card)
        if suit ~= nil and nowSuit ~= suit then
            return false, {}
        end
        suit = nowSuit
    end

    local isHu, path = ZZAlgorithm.canHu_(cards, 0)

    return isHu, path
end

function CSAlgorithm.isQuanQiuRen(zhuoCards, cards)
    if #cards == 2 and cards[1] == cards[2] then
        return true, {cards}
    end

    return false, {}
end

function CSAlgorithm.isPengPengHu(zhuoCards, cards)
    local map = gailun.utils.invert({
        ACTION_TYPE.PENG,
        ACTION_TYPE.AN_BU,
        ACTION_TYPE.AN_GANG,
        ACTION_TYPE.GONG_BU,
        ACTION_TYPE.GONG_GANG,
        ACTION_TYPE.MING_GANG,
        ACTION_TYPE.MING_GANG,
    })

    for _, zhuoCardsCeil in _ipairs(zhuoCards) do
        if not map[zhuoCardsCeil.action] then
            return false, {}
        end
    end

    local countMap = BaseAlgorithm.getCountListByValue(cards)
    local twoCardsCount = 0
    for card, count in _pairs(countMap) do
        if count == 2 then
            if twoCardsCount > 1 then
                return false, {}
            end
            twoCardsCount = twoCardsCount + 1
        elseif count == 1 then
            return false, {}
        end
    end

    return ZZAlgorithm.canHu_(cards, 0)
end

function CSAlgorithm.canHu_(zhuoCards, cards)
    if #cards % 3 ~= 2 then
        return false, {}
    end
    cards = clone(cards)

    local isHu, huPath = CSAlgorithm.isJiangJiangHu(zhuoCards, cards)
    if isHu then
        return true, huPath
    end

    local isHu, huPath = CSAlgorithm.isQingYiSe(zhuoCards, cards)
    if isHu then
        return true, huPath
    end

    local isHu, huPath = CSAlgorithm.isQuanQiuRen(zhuoCards, cards)
    if isHu then
        return true, huPath
    end

    local isHu, huPath = CSAlgorithm.isSevenPairs(zhuoCards, cards)
    if isHu then
        return true, huPath
    end

    local isHu, huPath = CSAlgorithm.isPengPengHu(zhuoCards, cards)
    if isHu then
        return true, huPath
    end

    return CSAlgorithm.canHuSpecialJiang(cards, specialJiangValues)
end

function CSAlgorithm.canHuSpecialJiang(cards, jiangValues)
    local jiangValueMap = gailun.utils.invert(jiangValues)
    local pairList = ZZAlgorithm.searchPairs_(cards)
    for _,card in _ipairs(pairList) do
        local value = BaseAlgorithm.getValue(card)
        if jiangValueMap[value] then
            local flag, path = ZZAlgorithm.canHuByJiang_(cards, card)
            if flag then  -- 只要找到一种胡法就返回
                return true, path
            end
        end
    end

    return false, path
end

function CSAlgorithm.getRemainCards(handCards, qiPaiCards, waiCards)
    local allCards = gailun.utils.invert(BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3}))
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
	-- local result = {}
	-- for card, count in _pairs(allCards) do
	-- 	for i = 1, count, 1 do
	-- 		table.insert(result, card)
	-- 	end
	-- end

	-- return result
end

function CSAlgorithm.getTingPai(remainCards, zhuoCards, cards)
    local result = {}
    local huResultIndex = 0
    for card, count in _pairs(remainCards) do
        local handCards = clone(cards)
        table.insert(handCards, card)
		local isHu, path = CSAlgorithm.canHu_(zhuoCards, handCards)
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
	return result
end

function CSAlgorithm.isTingPai(zhuoCards, cards)
    local remainCards = BaseAlgorithm.makeWSTCardsBySuits_({1, 2, 3})
    local result = {}
    for _, card in _pairs(remainCards) do
        local handCards = clone(cards)
        table.insert(handCards, card)
		local isHu, path = CSAlgorithm.canHu_(zhuoCards, handCards)
		if isHu then
			return true
		end
	end

	return false
end

function CSAlgorithm.getTingOperate(zhuoCards, cards)
    local result = {}
    for _, card in _pairs(cards) do
        local handCards = clone(cards)
        table.removebyvalue(handCards, card)
		local isTing = CSAlgorithm.isTingPai(zhuoCards, handCards)
		if isTing then
			table.insert(result, card)
		end
    end
    
    return result
end

return CSAlgorithm
