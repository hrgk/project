local unpack = unpack or table.unpack
local BaseAlgorithm = {}

local _ipairs, _pairs = ipairs, pairs

--[[ 麻将牌的定义：
花色为 1、2、3、4、5 对应 万索筒风杂
当花色为【万索筒】时，1-9 分别对应牌中的 1-9
当花色为【风】时，1，3，5，7 分别对应 东、南、西、北
当花色为【杂】时，1、3、5 分别对应 红中 发财 白板
十位代表花色，个位数代表牌值
]]
BaseAlgorithm.SUIT_WAN = 1
BaseAlgorithm.SUIT_SUO = 2
BaseAlgorithm.SUIT_TONG = 3
BaseAlgorithm.SUIT_FENG = 4
BaseAlgorithm.SUIT_ZA = 5

--[[
顺子：三张花色相同且牌值连续的牌
对子：两张一样的牌
刻子：三张一样的牌
]]
BaseAlgorithm.TYPE_DUI_ZI = 1
BaseAlgorithm.TYPE_SHUN_ZI = 2
BaseAlgorithm.TYPE_KE_ZI = 3

-- 转转麻将
BaseAlgorithm.ZZ_MA_JIANG = 1
-- 长沙麻将
BaseAlgorithm.CS_MA_JIANG = 2

-- 全部合法的麻将牌
local ALL_CARDS = {
    11, 12, 13, 14, 15, 16, 17, 18, 19,
    21, 22, 23, 24, 25, 26, 27, 28, 29,
    31, 32, 33, 34, 35, 36, 37, 38, 39,
    41, 43, 45, 47,
    51, 53, 55,
}

local BIRD_VALUES1 = {1, 5, 9}
local BIRD_VALUES2 = {2, 6}
local BIRD_VALUES3 = {3, 7}
local BIRD_VALUES4 = {4, 8}

local BIRD_SAN_REN_VALUES1 = {1,4,7}
local BIRD_SAN_REN_VALUES2 = {2,5,8}
local BIRD_SAN_REN_VALUES3 = {3,6,9}
local BIRD_SAN_REN_VALUES4 = {}

local BIRD_SAN_ER_VALUES1 = {1,3,5,7,9}
local BIRD_SAN_ER_VALUES2 = {2,4,6,8}
local BIRD_SAN_ER_VALUES3 = {}
local BIRD_SAN_ER_VALUES4 = {}

local BIRD_VALUES_GD_BIG = {5, 6, 7, 8, 9}
local BIRD_VALUES_GD_159 = {1, 5, 9}

BaseAlgorithm.NAI_ZI = 51

-- 取牌值
function BaseAlgorithm.getValue(card)
    return (card or 0) % 10
end

-- 取花色
function BaseAlgorithm.getSuit(card)
    return math.floor((card or 0) / 10)
end

function BaseAlgorithm.isCard(card)
    if not card or type(card) ~= "number" then
        return false
    end
    if card <= 10 or card >= 60 then
        return false
    end
    return table.indexof(ALL_CARDS, card) ~= false
end

function BaseAlgorithm.getIndex(card, startIndex, playerCount)
    if card and card >= 40 then
        return 1
    end

    local value = BaseAlgorithm.getValue(card)
    local index = (value + startIndex - 1) % playerCount
    if index == 0 then
        index = playerCount
    end

    return index
end

function BaseAlgorithm.isBird1(card, startIndex, playerCount)
    if playerCount == 4 then
        return false ~= table.indexof(BIRD_VALUES1, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 3 then
        return false ~= table.indexof(BIRD_SAN_REN_VALUES1, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 2 then
        return false ~= table.indexof(BIRD_SAN_ER_VALUES1, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    end
end

function BaseAlgorithm.isBird2(card, startIndex, playerCount)
    if playerCount == 4 then
        return false ~= table.indexof(BIRD_VALUES2, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 3 then
        return false ~= table.indexof(BIRD_SAN_REN_VALUES2, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 2 then
        return false ~= table.indexof(BIRD_SAN_ER_VALUES1, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    end
end

function BaseAlgorithm.isBird3(card, startIndex, playerCount)
    if playerCount == 4 then
        return false ~= table.indexof(BIRD_VALUES3, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 3 then
        return false ~= table.indexof(BIRD_SAN_REN_VALUES3, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    elseif playerCount == 2 then
        return false ~= table.indexof(BIRD_SAN_ER_VALUES1, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    end
end

function BaseAlgorithm.isBird4(card, startIndex, playerCount)
    if playerCount == 4 then
        return false ~= table.indexof(BIRD_VALUES4, BaseAlgorithm.getIndex(card, startIndex, playerCount))
    -- else
    --     return false ~= table.indexof(BIRD_SAN_REN_VALUES4, BaseAlgorithm.getValue(card))
    end
end

function BaseAlgorithm.isGDBigBird(card)
    return false ~= table.indexof(BIRD_VALUES_GD_BIG, BaseAlgorithm.getValue(card))
end

function BaseAlgorithm.isGD159Bird(card)
    return false ~= table.indexof(BIRD_VALUES_GD_159, BaseAlgorithm.getValue(card))
end

function BaseAlgorithm.isBird(card, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex, zhuangIndex,zhuangType,playerCount)
    local fn = {}
    jiePaoIndex = jiePaoIndex or {}
    jiePaoIndex[1] = jiePaoIndex[1] or 1
    fangPaoIndex = fangPaoIndex or 1
    local birdShunXuUnit = {}
    for j = 1, playerCount do
        local index = (j) % playerCount
        if index == 0 then
            index = playerCount
        end
        table.insert(birdShunXuUnit, BaseAlgorithm["isBird" .. index])
    end
    local startSeatID = zhuangIndex or 1
    local birdShunXu = birdShunXuUnit
    if isTongPao then
        if zhuangType == 0 then
            startSeatID = fangPaoIndex
        else
            startSeatID = zhuangIndex or 1
        end
        table.insert(fn, {birdShunXu[fangPaoIndex], fangPaoIndex})
        if isSortBird then
            for i=1, #jiePaoIndex do
                table.insert(fn, {birdShunXu[jiePaoIndex[i]], jiePaoIndex[i]})
            end
        end
    else
        if zhuangType == 0 then
            startSeatID = jiePaoIndex[1]
        else
            startSeatID = zhuangIndex or 1
        end
        if isSortBird then
            if isZiMo then
                for i = jiePaoIndex[1], playerCount do
                    table.insert(fn, {birdShunXu[i], i})
                end

                for i = 1, jiePaoIndex[1] - 1 do
                    table.insert(fn, {birdShunXu[i], i})
                end
            else
                table.insert(fn, {birdShunXu[jiePaoIndex[1]], jiePaoIndex[1]})
                table.insert(fn, {birdShunXu[fangPaoIndex], fangPaoIndex})
            end
        else
            birdShunXuUnit = {}
            table.insert(birdShunXuUnit, BaseAlgorithm.isGD159Bird)
            table.insert(fn, {birdShunXuUnit[1], jiePaoIndex[1]})
        end
    end
    if isSortBird then
        for i=1, #fn do
            if fn[i] then
                if fn[i][1](card, startSeatID, playerCount) then
                    return true, birdShunXu, startSeatID
                end
            end
        end
    else
        for i=1, #fn do
            if fn[i] then
                if fn[i][1](card) then
                    return true, birdShunXu, startSeatID
                end
            end
        end
    end
    return false, birdShunXu, startSeatID
end

function BaseAlgorithm.isNaiZi(card)
    return BaseAlgorithm.NAI_ZI == card
end

function BaseAlgorithm.getZhongNiaoParams(data)
    data = checktable(data)
    local isZiMo = false
    local isSortBird = data.isSortBird == 1
    local isTongPao = data.isTongPao
    local jiePaoIndex = {}
    local fangPaoIndex = 1
    local huInfo = checktable(data.huInfo)
    for i=1, #huInfo do
        isZiMo = huInfo[i].isZiMo
        table.insert(jiePaoIndex, checknumber(huInfo[i].seatID))
        fangPaoIndex = checknumber(huInfo[i].preSeatID)
    end
    return isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex
end

function BaseAlgorithm.sort(cards, Laizi)
    local withLaizi = Laizi or false
    local function comp(v1, v2)
        if v1 == v2 then
            return v1 < v2
        end
        return v1 < v2
    end

    local function compwithLaizi(v1, v2)
        if v1 == v2 then
            return v1 < v2
        end
        if v1 == BaseAlgorithm.NAI_ZI then
            print("·BaseAlgorithm.NAI_ZI··")
            return true
        elseif v2 == BaseAlgorithm.NAI_ZI then
            print("·BaseAlgorithm.NAI_ZI·22·")
            return false
        end
       
        return v1 < v2
    end
    if withLaizi then
        table.sort(cards, compwithLaizi)
    else
        table.sort(cards, comp)
    end
end

function BaseAlgorithm.makeCard(suit, value)
    return suit * 10 + value
end

-- 将麻将分组，分组里面的牌只有牌值，没有花色
function BaseAlgorithm.groupBySuit(cards)
    local group = {}
    table.walk(cards, function (card, key)
        local suit = BaseAlgorithm.getSuit(card)
        local value = BaseAlgorithm.getValue(card)
        if not group[suit] then
            group[suit] = {value}
        else
            table.insert(group[suit], value)
        end
    end)
    return group
end

-- 判断牌值是否全部由顺子构成，注意这里不能直接传牌过来，只能传牌值，不能带花色
-- 所有会改变原参数的值的方法，都应该在开始的时候直接复制table
function BaseAlgorithm.isValueShunZi_(list)
    local list = clone(list)
    local path = {}
    local count = #list
    for i = 1, count, 3 do
        local v = list[1]
        if  1 == table.removebyvalue(list, v, false) and
            1 == table.removebyvalue(list, v + 1, false) and
            1 == table.removebyvalue(list, v + 2, false) then
                gailun.utils.extends(path, {v, v + 1, v + 2})
        else
            return false, path
        end
    end

    return true, path
end

-- 判断牌值是否刻子，注意这里不能直接传牌过来，只能传牌值，不能带花色
function BaseAlgorithm.isValueKeZi_(list)
    if #list % 3 ~= 0 then
        return false, {}
    end

    local result = {}
    for i = 1, #list, 3 do
        if list[i] == list[i + 1] and list[i + 1] == list[i + 2] then
            table.insert(result, {list[i], list[i + 1], list[i + 2]})
        else
            return false, {}
        end
    end

    return true, result
end

-- 计算给定值在列表中出现的次数
function BaseAlgorithm.calcValueCount_(list, value)
    local count = 0
    for _,v in _ipairs(list) do
        if v == value then
            count = count + 1
        end
    end
    return count
end

-- 查找指定的牌中所出现的花色列表
function BaseAlgorithm.calcSuits_(cards)
    local suits = {}
    for _,v in _ipairs(cards) do
        suits[BaseAlgorithm.getSuit(v)] = 1
    end
    return table.keys(suits)
end

-- 返回给定花色（万索筒内）的所有牌
function BaseAlgorithm.makeWSTCardsBySuits_(suits)
    local result = {}
    for _,v in _ipairs(suits) do
        if v == BaseAlgorithm.SUIT_WAN or v == BaseAlgorithm.SUIT_SUO or v == BaseAlgorithm.SUIT_TONG then
            for i = 1, 9 do
                table.insert(result, BaseAlgorithm.makeCard(v, i))
            end
        end
    end
    return result
end

function BaseAlgorithm.getCountListByValue(cards)
    local countMap = {}
    for _, v in _ipairs(cards) do
        if not countMap[v] then
            countMap[v] = 0
        end
        countMap[v] = countMap[v] + 1
    end

    return countMap
end

function BaseAlgorithm.searchPairs_(cards)
    local countMap = BaseAlgorithm.getCountListByValue(cards)
    local resultList = {}
    for card, count in _pairs(countMap) do
        if count >= 2 then
            table.insert(resultList, card)
        end
    end

    table.sort(resultList)
    return resultList
end


return BaseAlgorithm