local BaseAlgorithm = {
    KING = 301 -- 王牌
}

-- 所有合法的字牌
local ALL_CARDS = {
    101, 102, 103, 104, 105, 106, 107, 108, 109, 110, -- 小字
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, -- 大字
}

-- 获得所有字牌
function BaseAlgorithm.getAllCards()
    return clone(ALL_CARDS)
end

-- 制造一张字牌牌
function BaseAlgorithm.makeCard(s, v)
    return s * 100 + v
end

-- 获得一张牌的花色
function BaseAlgorithm.getSuit(c)
    return math.floor(c / 100)
end

-- 获得一张牌值的大小
function BaseAlgorithm.getValue(c)
    if c % 10  == 0  then
        return 10
    else
        return  c % 10
    end
end

-- 获得一只牌的颜色
function BaseAlgorithm.getColor(c)
    if table.indexof({2, 7, 10}, BaseAlgorithm.getValue(c)) ~= false then
        return COLOR_RED
    end
    return COLOR_BLACK
end

-- 判断是否是字牌牌
function BaseAlgorithm.isCard(c)
    return table.indexof(ALL_CARDS, c) ~= false
end

function BaseAlgorithm.getBigOrSmallCard(card)
    local suit = BaseAlgorithm.getSuit(card)
    local value = BaseAlgorithm.getValue(card)
    if suit == 1 then
        if value < 10 then
            return tonumber("20" .. value)
        else
            return tonumber("2" .. value)
        end
    else
        if value < 10 then
            return tonumber("10" .. value)
        else
            return tonumber("1" .. value)
        end
    end
end

function BaseAlgorithm.isAllCards(list)
    for _, c in ipairs(list) do
        if not BaseAlgorithm.isCard(c) then
            return false
        end
    end
    return true
end

-- 排序比较函数，大牌在前
function BaseAlgorithm.cardSortCompare(c1, c2)
    local s1, s2 = BaseAlgorithm.getSuit(c1), BaseAlgorithm.getSuit(c2)
    local v1, v2 = BaseAlgorithm.getValue(c1), BaseAlgorithm.getValue(c2)
    if v1 == v2 then
        return s1 > s2
    end
    return v1 > v2
end

-- 排序比较函数2，大牌在后, 从小到大
function BaseAlgorithm.sortCardFuncSmallToBig(c1, c2)
    local s1, s2 = BaseAlgorithm.getSuit(c1), BaseAlgorithm.getSuit(c2)
    local v1, v2 = BaseAlgorithm.getValue(c1), BaseAlgorithm.getValue(c2)
    if v1 == v2 then
        return s1 > s2
    end
    return v1 < v2
end

function BaseAlgorithm.sortSmallToBig(cards)
    table.sort(cards, BaseAlgorithm.sortCardFuncSmallToBig)
end

-- 获得相反的花色
function BaseAlgorithm.getOppositeSuit(s)
    if s == SUIT_BIG then
        return SUIT_SMALL
    end
    return SUIT_BIG
end

-- 获得胡番的文字名称
function BaseAlgorithm.getHuString(hu_method)
    local ret = HU_METHOD_STRING[hu_method]
    if not ret then
        return HU_METHOD_STRING[0]
    end
    return ret
end

-- 获得三张一组的牌型
function BaseAlgorithm.getCtypeOfThree(cards)
    if not cards or type(cards) ~= 'table' or #cards ~= 3 then
        return 0
    end
    if not BaseAlgorithm.isCard(cards[1]) or not BaseAlgorithm.isCard(cards[2]) or not BaseAlgorithm.isCard(cards[3]) then
        return 0
    end

    local cards = clone(cards)
    table.sort(cards, BaseAlgorithm.cardSortCompare)
    if cards[1] == cards[2] and cards[2] == cards[3] then
        return CTYPE_WEI
    end
    local c1, c2, c3 = BaseAlgorithm.getSuit(cards[1]), BaseAlgorithm.getSuit(cards[2]), BaseAlgorithm.getSuit(cards[3])
    local v1, v2, v3 = BaseAlgorithm.getValue(cards[1]), BaseAlgorithm.getValue(cards[2]), BaseAlgorithm.getValue(cards[3])
    if v1 == v2 + 1 and v2 == v3 + 1 and c1 == c2 and c2 == c3 then -- 大或者小的顺
        return CTYPE_SHUN
    end
    if v1 == 10 and v2 == 7 and v3 == 2 and c1 == c2 and c2 == c3 then -- 2710的顺
        return CTYPE_2710
    end
    if v1 == v2 and v2 == v3 then
        return CTYPE_DA_XIAO_DA
    end

    return 0
end

function BaseAlgorithm.isDaXiaoDa(cards)
    return BaseAlgorithm.getCtypeOfThree(cards) == CTYPE_DA_XIAO_DA
end

function BaseAlgorithm.is2710(cards)
    return BaseAlgorithm.getCtypeOfThree(cards) == CTYPE_2710
end

function BaseAlgorithm.isShun(cards)
    return BaseAlgorithm.getCtypeOfThree(cards) == CTYPE_SHUN
end

-- 是否三张同值牌
function BaseAlgorithm.isThree(cards)
    if not cards or type(cards) ~= 'table' or #cards ~= 3 then
        return false
    end
    if not BaseAlgorithm.isAllCards(cards) then
        return false
    end
    return cards[1] == cards[2] and cards[2] == cards[3]
end

-- 是否四张同值牌
function BaseAlgorithm.isFour(cards)
    if not cards or type(cards) ~= 'table' or #cards ~= 4 then
        return false
    end
    if not BaseAlgorithm.isAllCards(cards) then
        return false
    end
    return cards[1] == cards[2] and cards[2] == cards[3] and cards[3] == cards[4]
end

local SUITS = {"x", "d"}

-- 获得大牌图片名称
function BaseAlgorithm.getBigCardName(card)
    if card == 0 then
        return "dp_bm.png"
    end
    local v = BaseAlgorithm.getValue(card)
    local s = BaseAlgorithm.getSuit(card) 
    return "dp_" .. SUITS[s] .. v .. '.png'
end

-- 获得小牌图片名称
function BaseAlgorithm.getMiddleCardName(card)
    if card == 0 then
        return "zp_bm.png"
    end
    local v = BaseAlgorithm.getValue(card)
    local s = BaseAlgorithm.getSuit(card)
    return "zp_" .. SUITS[s] .. v .. '.png'
end

-- 获得小牌图片名称
function BaseAlgorithm.getSmallCardName(card)
    if card == 0 then
        return "xp_bm.png"
    end
    local v = BaseAlgorithm.getValue(card)
    local s = BaseAlgorithm.getSuit(card)
    return "xp_" .. SUITS[s] .. v .. '.png'
end

-- 获得纸牌的sprite名称
function BaseAlgorithm.getCardName(card, cardSize)
    if 1 == cardSize then
        return BaseAlgorithm.getBigCardName(card)
    elseif 2 == cardSize then
        return BaseAlgorithm.getMiddleCardName(card)
    end
    return BaseAlgorithm.getSmallCardName(card)
end

-- 统计牌张数
function BaseAlgorithm.statCards(cards)
    local ret = {}
    for i = 101, 110 do
        ret[i] = 0 
        ret[i +100] = 0 
    end 
    for k, card in pairs(cards) do
        ret[card] = ret[card] + 1
    end
    return ret
end

-- 取出坎中的数据
function BaseAlgorithm.searchKan(stat, cards, hu_path)
    for k, v in pairs(stat) do
        if v == 3 then
            stat[k] = 0
            table.removebyvalue(cards, k)
            table.removebyvalue(cards, k)
            table.removebyvalue(cards, k)
            table.insert(hu_path, {k, k, k})
        end
    end
end

-- 搜索手上的起手提
function BaseAlgorithm.searchTi(stat, cards, hu_path)
    for k, v in pairs(stat) do
        if v == 4 then
            stat[k] = 0
            table.removebyvalue(cards, k)
            table.removebyvalue(cards, k)
            table.removebyvalue(cards, k)
            table.removebyvalue(cards, k)
            table.insert(hu_path, {k, k, k, k})
        end
    end
end

-- 计算任意三角形的面积
function BaseAlgorithm.calcTriangleArea(a, b, c)
    local p = (a + b + c) / 2
    local x = (a + b + c) * (a + b - c) * (a + c -b) * (b + c -a)
    local area = 1 / 4 * math.sqrt(x)
    return area
end

-- 计算直角三角形的面积
function BaseAlgorithm.calcRightTriangleArea(a, b)
    return a * b / 2
end

-- 创建重复的来回的缩放效果
function BaseAlgorithm.createPingPongLight(seconds, value1, value2)
    local actionScaleTo = cc.ScaleTo:create(seconds, value1) -- 旋转
    local actionScaleBack = cc.ScaleTo:create(seconds, value2) -- actionRotateTo:reverse() -- 反向
    local sequence = transition.sequence({ -- 按顺序来执行
        actionScaleTo,
        actionScaleBack,
    })
    return cc.RepeatForever:create(sequence) -- 一直重复
end

-- 计算两点之间的距离
function BaseAlgorithm.calcDistance(pointA, pointB)
    local a = pointB[1] - pointA[1]
    local b = pointB[2] - pointA[2]
    return math.abs(math.sqrt(math.pow(a, 2) + math.pow(b, 2)))
end

-- 判断某个点是否在三角形内
-- 这里采用面积判断法
function BaseAlgorithm.inTriangle(p, triangle)
    local p1, p2, p3 = unpack(triangle)
    local a, b, c = BaseAlgorithm.calcDistance(p1, p2), BaseAlgorithm.calcDistance(p2, p3), BaseAlgorithm.calcDistance(p3, p1)
    local a1, b1, c1 = BaseAlgorithm.calcDistance(p1, p), BaseAlgorithm.calcDistance(p2, p), BaseAlgorithm.calcDistance(p3, p)
    local total_area = BaseAlgorithm.calcTriangleArea(a, b, c)
    local area1 = BaseAlgorithm.calcTriangleArea(c, a1, c1)
    local area2 = BaseAlgorithm.calcTriangleArea(a, b1, a1)
    local area3 = BaseAlgorithm.calcTriangleArea(b, c1, b1)
    return math.abs(total_area - (area1 + area2 + area3)) < 0.1
end

-- 根据给定的宽度，新的矩形对象，以及旋转角度来计算所形成的四个三角形
function BaseAlgorithm.calcTriangleOfRect(rawWidth, rawHeight, rect, angle)
    local length_xiebian = rawWidth

    local ret = {}
    if angle < 0 then
        angle = 90 + angle
        length_xiebian = rawHeight
    end

    local a = length_xiebian * math.cos(math.rad(angle))
    local b = length_xiebian * math.sin(math.rad(angle))
    local c = rect.size.width - a
    local d = rect.size.height - b
    local nx, ny, width, height = rect.origin.x, rect.origin.y, rect.size.width, rect.size.height
    local triangle1 = {{nx + a, ny}, {nx + width, ny + d}, {nx + c, ny + height}}
    local triangle2 = {{nx, ny + b}, {nx + a, ny}, {nx + c, ny + height}}
    table.insert(ret, triangle1)
    table.insert(ret, triangle2)
 
    return ret
end

-- 判断某个坐标点是否在旋转后的矩形区域内
function BaseAlgorithm.inRectWithAngle(rawWidth, rawHeight, x, y, newRect)
    if not newRect:containsPoint(cc.p(x, y)) then
        return false
    end 
    local triangles = BaseAlgorithm.calcTriangleOfRect(rawWidth, rawHeight, newRect, 0)
    for k, triangle in pairs(triangles) do
        if BaseAlgorithm.inTriangle({x, y}, triangle) then
        return true
        end
    end
    return false
end


-- 获取上家座位号
function BaseAlgorithm.getLastSeatID(mySeatID)
    assert(mySeatID > 0 and mySeatID < 4)
    if mySeatID == 1 then
        return 3
    else
        return mySeatID - 1
    end
end

local M_PI = math.pi

function BaseAlgorithm.locationMarsFromEarth_earthLat(latitude,longitude)
    print(latitude)
    print(longitude)
    print(10/3)
    -- if BaseAlgorithm.isInChinaWithlat(latitude,longitude) then
    --     return latitude, longitude
    -- end    

    local a = 6378245.0
    local ee = 0.00669342162296594323
    print(ee)
    local dLat = BaseAlgorithm.transform_earth_from_mars_lat_lat(latitude - 35.0,longitude - 35.0)
    local dLon = BaseAlgorithm.transform_earth_from_mars_lng_lat(latitude - 35.0,longitude - 35.0)
    local radLat = latitude / 180.0 * M_PI
    local magic = math.sin(radLat)
    magic = 1 - ee * magic * magic
    local sqrtMagic = math.sqrt(magic)
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI)
    dLon = (dLon * 180.0) / (a / sqrtMagic * math.cos(radLat) * M_PI)

    local newLatitude = latitude + dLat
    local newLongitude = longitude + dLon

    return newLatitude,newLongitude
end

function BaseAlgorithm.isInChinaWithlat(lat,lon)
    print(lat)
    print(lon)
    if lon < 72.004 or lon > 137.8347 then
        return false
    end
    if lat < 0.8293 or lat > 55.8271 then
        return false
    end
    return YES
end

function BaseAlgorithm.transform_earth_from_mars_lat_lat(y,x) 
    print(x.."------------"..math.abs(x))
    local ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * math.sqrt(math.abs(x))
    ret = ret +(20.0 * math.sin(6.0 * x * M_PI) + 20.0 * math.sin(2.0 * x * M_PI)) * 2.0 / 3.0
    ret = ret +(20.0 * math.sin(y * M_PI) + 40.0 * math.sin(y / 3.0 * M_PI)) * 2.0 / 3.0
    ret = ret +(160.0 * math.sin(y / 12.0 * M_PI) + 3320 * math.sin(y * M_PI / 30.0)) * 2.0 / 3.0
    return ret
end

function BaseAlgorithm.transform_earth_from_mars_lng_lat(y, x)
    local ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * math.sqrt(math.abs(x))
    ret =ret + (20.0 * math.sin(6.0 * x * M_PI) + 20.0 * math.sin(2.0 * x * M_PI)) * 2.0 / 3.0
    ret = ret +(20.0 * math.sin(x * M_PI) + 40.0 * math.sin(x / 3.0 * M_PI)) * 2.0 / 3.0
    ret =ret + (150.0 * math.sin(x / 12.0 * M_PI) + 300.0 * math.sin(x / 30.0 * M_PI)) * 2.0 / 3.0
    return ret
end

return BaseAlgorithm
