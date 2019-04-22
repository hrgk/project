local unpack = unpack or table.unpack

local BaseAlgorithm = {
    KING = 520,
}

--所有合法的扑克
local ALL_CARDS = {
    103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, -- 方块
    203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, -- 梅花
    303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 316,  -- 红心
    403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 416,  -- 黑桃
    520  --王牌
}
local KING = 530 --王牌

-- 获得所有扑克
function BaseAlgorithm.getPokers()
    return clone(ALL_CARDS)
end

-- 获得王
function BaseAlgorithm.getKing()
    return KING
end

--制造一张扑克牌
function BaseAlgorithm.makeCard(s, v)
    return s * 100 + v
end

--获得一张牌的花色
function BaseAlgorithm.getSuit(c)
    if c and c > 0 then
        return math.round(c / 100)
    end
    return 0
end

--获得一张牌值的大小
function BaseAlgorithm.getValue(c)
    if c and c > 0 then
        return  c % 100
    end
    return 0
end

function BaseAlgorithm.getCardsFromList(cardsList)
    local cardsMap = {}
    for _, cards in ipairs(cardsList) do
        local cardsMapTemp = {}
        for k, card in ipairs(cards) do
            if cardsMapTemp[card] == nil then
                cardsMapTemp[card] = 0
            end

            cardsMapTemp[card] = cardsMapTemp[card] + 1
        end

        for card, count in pairs(cardsMapTemp) do
            if cardsMap[card] == nil or cardsMap[card] < cardsMapTemp[card] then
                cardsMap[card] = cardsMapTemp[card]
            end
        end
    end

    local result = {}
    for card, count in pairs(cardsMap) do
        for i = 1, count, 1 do
            table.insert(result, card)
        end
    end

    return result
end

--测试是否是扑克牌
function BaseAlgorithm.isCard(c)
    for i = 1, #ALL_CARDS do
        if c == ALL_CARDS[i] then
            return true
        end
    end
    return false
end

-- 提取牌值
function BaseAlgorithm.abstractValues(cards)
    local result = {}
    for _, card in pairs(cards) do
        result[#result+1] = BaseAlgorithm.getValue(card)
    end
    return result
end

-- 提取花色
function BaseAlgorithm.abstractSuits(cards)
    local result = {}
    for _, card in pairs(cards) do
        result[#result+1] = BaseAlgorithm.getSuit(card)
    end
    return result
end

--所给的牌是不是合法的扑克牌
function BaseAlgorithm.isAllPokers(cards)
    if not cards or type(cards) ~= "table" then
        return false
    end
    for _, c in pairs(cards) do
        if not BaseAlgorithm.isCard(c) then
            return false
        end
    end
    return true
end

return BaseAlgorithm
