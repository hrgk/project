local unpack = unpack or table.unpack
local _pairs, _ipairs = pairs, ipairs

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
local KING = 520 --王牌

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

--测试是否是扑克牌
function BaseAlgorithm.isCard(c)
    for i = 1, #ALL_CARDS do
        if c == ALL_CARDS[i] then
            return true
        end
    end
    return false
end

function BaseAlgorithm.count(list, value)  -- 统计某值在列表中出现的次数
    local count = 0
    for _,v in _ipairs(checktable(list)) do
        if value == v then
            count = count + 1
        end
    end
    return count
end

function BaseAlgorithm.copy(list, startPos, length)
    local result = {}
    local count = 1
    for i,v in _ipairs(list) do
        if i >= startPos and count <= length then
            table.insert(result, v)
            count = count + 1
        end
    end
    return result
end

--[[
将列表按值是否连续来分割
比如有以下列表, {1,2,3,5,6,8,9} -> 运行后返回 {{1,2,3}, {5,6}, {8,9}}
]]
function BaseAlgorithm.splitListByStraightValue(list)
    local result = {}
    local startPos, length = 1, 1
    for i,v in _ipairs(list) do
        if i == #list then
            -- print(startPos, length)
            table.insert(result, BaseAlgorithm.copy(list, startPos, length))
            break
        end
        if v + 1 ~= list[i + 1] then
            -- print(startPos, length)
            table.insert(result, BaseAlgorithm.copy(list, startPos, length))
            startPos = i + 1
            length = 1
        else
            length = length + 1
        end
    end
    return result
end

local test = {1,2,3,5,6,8,9}
local result = BaseAlgorithm.splitListByStraightValue(test)
-- dump(result)
assert(3 == #result)
assert(result[1][1] == 1)
assert(result[1][2] == 2)
assert(result[1][3] == 3)
assert(result[2][1] == 5)
assert(result[2][2] == 6)
assert(result[3][1] == 8)
assert(result[3][2] == 9)

-- 提取牌值
function BaseAlgorithm.abstractValues(cards)
    local result = {}
    for _, card in _pairs(cards) do
        result[#result+1] = BaseAlgorithm.getValue(card)
    end
    return result
end

-- 提取花色
function BaseAlgorithm.abstractSuits(cards)
    local result = {}
    for _, card in _pairs(cards) do
        result[#result+1] = BaseAlgorithm.getSuit(card)
    end
    return result
end

--所给的牌是不是合法的扑克牌
function BaseAlgorithm.isAllPokers(cards)
    if not cards or type(cards) ~= "table" then
        return false
    end
    for _, c in _pairs(cards) do
        if not BaseAlgorithm.isCard(c) then
            return false
        end
    end
    return true
end

-- 按牌从小到大,花色从方片到黑桃排序
function BaseAlgorithm.sort(cards)
    local function sortCard(a, b)
        -- print(a, b, " value: ", BaseAlgorithm.getValue(a), BaseAlgorithm.getValue(b))
        -- print(a, b, "  suit: ", BaseAlgorithm.getSuit(a), BaseAlgorithm.getSuit(b))
        local v1, v2 = BaseAlgorithm.getValue(a), BaseAlgorithm.getValue(b)
        if v1 < v2 then
            return true
        elseif v1 > v2 then
            return false
        end
        return BaseAlgorithm.getSuit(a) < BaseAlgorithm.getSuit(b)
    end
    table.sort(cards, sortCard)
end
local l = {207,110,409}  -- 期望 {207,409,110} 实际 {110,207,409}
BaseAlgorithm.sort(l)
assert(l[1] == 207 and l[2] == 409 and l[3] == 110)

function BaseAlgorithm.reverseList(list)
    for i=1, math.floor(#list / 2) do
        list[i], list[#list - i + 1] = list[#list - i + 1], list[i]
    end
end

-- 根据牌型数值分组
function BaseAlgorithm.getValueMap(cards)
    local result = {}
    for _, card in _ipairs(cards) do
        local value = BaseAlgorithm.getValue(card)
        if result[value] == nil then
            result[value] = {}
        end
        table.insert(result[value], card)
    end

    return result
end

local l = {207, 307,110,409}  -- 期望 {207,409,110} 实际 {110,207,409}
local result = BaseAlgorithm.getValueMap(l)
assert(result[7][1] == 207 and result[7][2] == 307 and result[10][1] == 110 and result[9][1] == 409)

function BaseAlgorithm.invert(cards)
    local result = {}
    for k, card in _ipairs(cards) do
        result[card] = k
    end

    return result
end

return BaseAlgorithm
