local BaseAlgorithm = import(".BaseAlgorithm")
local PdkAlgorithm = {}
PdkAlgorithm.DAN_ZHANG = 1
PdkAlgorithm.DUI_ZI = 2
PdkAlgorithm.LIAN_DUI = 3
PdkAlgorithm.SAN_DAI = 4
PdkAlgorithm.FEI_JI = 5
PdkAlgorithm.SI_DAI = 6
PdkAlgorithm.SHUN_ZI = 7
PdkAlgorithm.SI_ZHA = 8

local teShuZha = {114,214,314}

function PdkAlgorithm.sort(cards)
    table.sort(cards, PdkAlgorithm.sortByValue_)
    return cards
end

function PdkAlgorithm.hasHeiSan(cards)
    for i,v in ipairs(cards) do
        if v == 403 then
            return true
        end
    end
    return false
end

function PdkAlgorithm.getDanGeCardsList_(cards)
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    local danGeList = {}
    for i=1,4 do
        local cards = {}
        for k,v in pairs(sameValueList) do
            if v[i] then
                cards[#cards+1] = v[i]
            end
        end
        danGeList[#danGeList+1] = cards
    end
    return danGeList
end

function PdkAlgorithm.getSameValue_(list1, list2)
    local isHaveSame = false
    for k,v in pairs(list1) do
        for j,k in pairs(list2) do
            if v == k then
                isHaveSame = true
                return isHaveSame
            end
        end
    end
    return isHaveSame
end

function PdkAlgorithm.getCardListByCount_(cards, count, isOnly)
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    local tempList = {}
    for k,v in pairs(sameValueList) do
        if #v == count then
            local cards = {}
            for i=1,count do
                cards[#cards+1] = v[i]
            end
            tempList[#tempList+1] = cards
        end
    end
    if not isOnly then
        for k,v in pairs(sameValueList) do
            if #v > count then
                local cards = {}
                for i=1,count do
                    cards[#cards+1] = v[i]
                end
                tempList[#tempList+1] = cards
            end
        end
    end
    table.sort(tempList, PdkAlgorithm.sortTableByValue_)
    return tempList
end


function PdkAlgorithm.getDanZhangList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 1)
    local biggerList = {}
    for i,v in ipairs(list) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    table.sort(biggerList, PdkAlgorithm.tiShiSortTableByValue_)
    return biggerList
end

function PdkAlgorithm.getDuiZiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 2)
    local biggerList = {}
    for i,v in ipairs(list) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    table.sort(biggerList, PdkAlgorithm.tiShiSortTableByValue_)
    return biggerList
end

function PdkAlgorithm.getLianDuiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 2)
    local lianDuiList = PdkAlgorithm.checkHasLianDui_(result, list)
    local biggerList = {}
    for i,v in ipairs(lianDuiList) do
        local obj = PdkAlgorithm.getCardType(v, config)
        print(json.encode(obj))
        if result and obj.length == result.length and obj.value > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function PdkAlgorithm.getSanDaiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 3)
    local biggerList = {}
    for i,v in pairs(list) do
        local obj = PdkAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function PdkAlgorithm.getFeiJiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local feiJiList = PdkAlgorithm.checkHasFeiJiList_(clone(cards))
    if feiJiList == nil then
        return {}
    end
    local biggerList = {}
    for i,v in ipairs(feiJiList) do
        local obj = PdkAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function PdkAlgorithm.getSiDaiList_(result, cards, config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 4)
    local biggerList = {}
    for i,v in ipairs(list) do
        local obj = PdkAlgorithm.getCardType(v, config)
        print(json.encode(obj))
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function PdkAlgorithm.getShunZiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local danGeList = PdkAlgorithm.getDanGeCardsList_(clone(cards))
    local biggerList = {}
    for k,v in pairs(danGeList) do
        local list = {}
        if #v >= result.length then
            list = PdkAlgorithm.checkHasShunZi_(result.length, v, true)
        end
        for k,v in pairs(list) do
            local obj = PdkAlgorithm.getCardType(v, config)
            if obj.value > result.value then
                if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                    biggerList[#biggerList+1] = v
                else
                    biggerList[#biggerList+1] = v
                end
            end
        end
    end
    return biggerList
end

function PdkAlgorithm.checkHasShunZi_(length, cards, isChaiFen)
    table.sort(cards, PdkAlgorithm.sortByValue_)
    local list = PdkAlgorithm.checkCardsHasShunZi_(clone(cards), length, isChaiFen)
    return list
end

function PdkAlgorithm.getSiZhaList_(result, cards, config)
    local list = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local biggerList = {}
    for i,v in ipairs(list) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            biggerList[#biggerList+1] = v
        end
    end
    return biggerList
end

local cardTypeTable = {}
cardTypeTable[PdkAlgorithm.DAN_ZHANG] = PdkAlgorithm.getDanZhangList_
cardTypeTable[PdkAlgorithm.DUI_ZI] = PdkAlgorithm.getDuiZiList_
cardTypeTable[PdkAlgorithm.LIAN_DUI] = PdkAlgorithm.getLianDuiList_
cardTypeTable[PdkAlgorithm.SAN_DAI] = PdkAlgorithm.getSanDaiList_
cardTypeTable[PdkAlgorithm.FEI_JI] = PdkAlgorithm.getFeiJiList_
cardTypeTable[PdkAlgorithm.SI_DAI] = PdkAlgorithm.getSiDaiList_
cardTypeTable[PdkAlgorithm.SHUN_ZI] = PdkAlgorithm.getShunZiList_
cardTypeTable[PdkAlgorithm.SI_ZHA] = PdkAlgorithm.getSiZhaList_

function PdkAlgorithm.sortByValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) > BaseAlgorithm.getValue(b)
    end
end

function PdkAlgorithm.sortTableByValue_(a,b)
    if BaseAlgorithm.getValue(a[1]) == BaseAlgorithm.getValue(b[1]) then
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    else
        return BaseAlgorithm.getValue(a[1]) > BaseAlgorithm.getValue(b[1])
    end
end

function PdkAlgorithm.tiShiSortTableByValue_(a,b)
    if BaseAlgorithm.getValue(a[1]) == BaseAlgorithm.getValue(b[1]) then
        return BaseAlgorithm.getSuit(a[1]) < BaseAlgorithm.getSuit(b[1])
    else
        return BaseAlgorithm.getValue(a[1]) < BaseAlgorithm.getValue(b[1])
    end
end

function PdkAlgorithm.getSameValueCards_(cards)
    local sameList = {}
    for i,v in ipairs(cards) do
        local value = BaseAlgorithm.getValue(v)
        if sameList[value] == nil then
            sameList[value] = {}
        end
        sameList[value][#sameList[value]+1] = v
    end
    return sameList
end

function PdkAlgorithm.tishi(cards, handCards, config)
    local result = PdkAlgorithm.getCardType(cards, config)
    local biggerList = {}
    local cardList = {}
    local zhaDanList = {}
    local zhaDanValue = result.value
    if result.cardType ~= PdkAlgorithm.SI_ZHA then
        cardList = PdkAlgorithm.getCardsByCardType_(result, handCards, config)
        zhaDanValue = 0
        for i,v in ipairs(cardList) do
            table.insertto(biggerList, {v})
        end
    end
    local obj = {}
    obj.cardType = PdkAlgorithm.SI_ZHA
    obj.value = zhaDanValue
    zhaDanList = PdkAlgorithm.getCardsByCardType_(obj, handCards, config)
    if config and config.denySplitBomb == 1 then
        for i,v in ipairs(zhaDanList) do
            table.insertto(biggerList, {v})
        end
    else
        for i,v in ipairs(biggerList) do
            for j,c in ipairs(zhaDanList) do
                if BaseAlgorithm.getValue(v[1]) ==  BaseAlgorithm.getValue(c[1]) then
                    table.removebyvalue(biggerList,v)
                    break
                end
            end
        end
        for i,v in ipairs(zhaDanList) do
            table.insertto(biggerList, {v})
        end
    end
    if cards and #cards ~= 0 then
        table.sort(biggerList, PdkAlgorithm.sortBiggerList_)
    end
    return biggerList
end

function PdkAlgorithm.sortBiggerList_(a, b)
    local result1 = PdkAlgorithm.getCardType(a)
    local result2 = PdkAlgorithm.getCardType(b)
    if result1.cardType == result2.cardType then
        return result1.value < result2.value
    else
        return result1.cardType  < result2.cardType 
    end
end

function PdkAlgorithm.cardInCards_(card, cards)
    for k,v in pairs(cards) do
        if v == card then return true end
    end
    return false
end

function PdkAlgorithm.getCardsByCardType_(result, handCards, config)
    local cardList = {}
    if result.cardType == 0 then
        for i,v in ipairs(cardTypeTable) do
            local list = v(result, clone(handCards), config)
            table.insertto(cardList, list)
        end
    else
        cardList = cardTypeTable[result.cardType](result, handCards, config) 
    end
    return cardList
end

function PdkAlgorithm.isBigger(cards1, cards2, config)
    local result1 = PdkAlgorithm.getCardType(cards1, config)
    local result2 = PdkAlgorithm.getCardType(cards2, config)
    if result1.cardType == 0 then return false end
    if result2.cardType == 0 then return true end
    if result1.cardType == result2.cardType then
        if result1.cardType == PdkAlgorithm.SHUN_ZI or result1.cardType == PdkAlgorithm.FEI_JI then
            if result1.length ~= result1.length then
                return false
            end 
        elseif result1.cardType == PdkAlgorithm.SAN_DAI then
            if #cards1 == 3 and #cards2 == 3 then 
                return true
            elseif #cards1 == 5 and #cards1 == 5 then
                return true
            else
                return false
            end
        end
        return result1.value > result2.value
    elseif result1.cardType ~= result2.cardType then
        if result1.cardType == PdkAlgorithm.SI_ZHA then
            return true
        else
            return false
        end
    end
end

function PdkAlgorithm.getCardType(cards, config)
    local result
    if #cards >=5 then
    result = PdkAlgorithm.lengthBigerThenFive_(clone(cards))
    elseif #cards <5 then
    result = PdkAlgorithm.lengthNotBiggerThenFive_(clone(cards), config)
    end
    return result
end

function PdkAlgorithm.lengthBigerThenFive_(cards)
    local result = PdkAlgorithm.isSiDai_(clone(cards))
    if result.value == 0 then
        result = PdkAlgorithm.isFeiJi_(clone(cards))
    end
    if result.value == 0 then
        result = PdkAlgorithm.isShunZi_(clone(cards))
    end
    if result.value == 0 then
        result = PdkAlgorithm.isSanDai_(clone(cards))
    end
    if result.value == 0 then
        result = PdkAlgorithm.isLianDui_(clone(cards))
    end
    return result
end

function PdkAlgorithm.lengthNotBiggerThenFive_(cards, config)
    local result = PdkAlgorithm.isDanZhang_(clone(cards))
    if result.value == 0 then
        result = PdkAlgorithm.isDuiZi_(clone(cards))
    end
    if result.value == 0 then
        result = PdkAlgorithm.isLianDui_(clone(cards))
    end
    if result.value == 0 then
        result = PdkAlgorithm.isZhaDan_(clone(cards), config)
    end
    if result.value == 0 then
        result = PdkAlgorithm.isSanDai_(clone(cards))
    end
    return result
end

function PdkAlgorithm.isDanZhang_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    if #cards ~= 1 then return obj end
    obj.cardType = PdkAlgorithm.DAN_ZHANG
    obj.value = BaseAlgorithm.getValue(cards[1])
    return obj
end

function PdkAlgorithm.isDuiZi_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    if #cards ~= 2 then return obj end
    if PdkAlgorithm.checkIsDuiZi_(cards) then
        obj.cardType = PdkAlgorithm.DUI_ZI
        obj.value = BaseAlgorithm.getValue(cards[1])
    end
    return obj
end

function PdkAlgorithm.checkIsDuiZi_(cards)
    if #cards == 2 then
        if BaseAlgorithm.getValue(cards[1]) == BaseAlgorithm.getValue(cards[2]) then
            return true
        end
    end
    return false
end

function PdkAlgorithm.isLianDui_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    local isLianDui, value, length = PdkAlgorithm.checkIsLianDui_(cards)
    if isLianDui then
        obj.cardType = PdkAlgorithm.LIAN_DUI
        obj.value = value
        obj.length = length
    end
    return obj
end

function PdkAlgorithm.checkIsLianDui_(cards)
    if #cards>2 and math.mod(#cards, 2) == 0 then
        table.sort(cards, PdkAlgorithm.sortByValue_)
        for i=1,#cards,2 do
            if cards[i+2] and 
                BaseAlgorithm.getValue(cards[i]) ~= BaseAlgorithm.getValue(cards[i+2])+1 then
                return false, 0
            end
        end
    else
        return false, 0
    end
    return true, BaseAlgorithm.getValue(cards[1]), #cards/2
end

function PdkAlgorithm.isSanDai_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isSanDai, value = PdkAlgorithm.checkIsSanDai_(cards)
    if isSanDai then
        obj.cardType = PdkAlgorithm.SAN_DAI
        obj.value = value
    end
    return obj
end

function PdkAlgorithm.checkHasSanDai_(cards)
    -- local isSanDai, value = PdkAlgorithm.checkIsSanDai_(cards)
    if #cards ~= 5 then return {} end
    local erList = PdkAlgorithm.getCardListByCount_(clone(cards), 2, true)
    local sanList = PdkAlgorithm.getCardListByCount_(clone(cards), 3)
    if #erList == 0 or #sanList == 0 then
        return {}
    end
    local sanValue = BaseAlgorithm.getValue(sanList[1][1])
    local erValue = BaseAlgorithm.getValue(erList[1][1])
    if math.abs(sanValue - erValue) == 1 then
        return cards
    end
    return {}
end

function PdkAlgorithm.checkIsSanDai_(cards)
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    for k,v in pairs(sameValueList) do
        if #v == 3 then
            return true, BaseAlgorithm.getValue(v[1])
        end
    end
    return false, 0
end

function PdkAlgorithm.isFeiJi_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isFeiji, value, length = PdkAlgorithm.checkIsFeiJi_(cards)
    if isFeiji then
        obj.cardType = PdkAlgorithm.FEI_JI
        obj.value = value
        obj.length = length
    end
    return obj
end

function PdkAlgorithm.checkHasFeiJi_(cards)
    if #cards < 6 then return {} end
    local sanZhangList = PdkAlgorithm.getCardListByCount_(clone(cards), 3)
    if #sanZhangList < 2 then
        return {}
    end
    table.sort(sanZhangList, PdkAlgorithm.sortTableByValue_)
    local count = 1
    local sIndex = 1
    local feiJiCount = 0
    local feiJiList = {}
    for i=1,#sanZhangList do
        if sanZhangList[i+1] then
            local a = sanZhangList[i][1]
            local b = sanZhangList[i+1][1]
            if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b)+1 then
                count = count + 1
            else
                if count >= 2 then
                feiJiCount = feiJiCount + 1
                sIndex = i - count + 1
                local list = {}
                for i=sIndex,count + sIndex - 1 do
                    for j,v in ipairs(sanZhangList[i]) do
                        list[#list+1] = v
                    end
                end
                feiJiList[#feiJiList+1] = list
            end
                count = 1
            end
        end
    end
    if sIndex == 1 and feiJiCount == 0 and count >=2 then
        sIndex = #sanZhangList - count
        local list = {}
        for i=sIndex+1,sIndex + count do
            for j,v in ipairs(sanZhangList[i]) do
                list[#list+1] = v
            end
        end
        feiJiList[#feiJiList+1] = list
    elseif sIndex ~= 1 and feiJiCount == 0 and count >=2 then
        local list = {}
        for i=sIndex+1,sIndex + count do
            for j,v in ipairs(sanZhangList[i]) do
                list[#list+1] = v
            end
        end
        feiJiList[#feiJiList+1] = list
    end
    return feiJiList
end

function PdkAlgorithm.checkIsFeiJi_(cards)
    if #cards < 6 then return false, 0 end
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    local sanZhangList = {}
    for k,v in pairs(sameValueList) do
        if #v == 3 then
            sanZhangList[#sanZhangList+1] = v
        end
    end
    if #sanZhangList < 2 then
        return false, 0
    end
    table.sort(sanZhangList, PdkAlgorithm.sortTableByValue_)
    if #sanZhangList == 2 then
        local isFeiji, value, length = PdkAlgorithm.erSanZhang_(sanZhangList)
        if isFeiji then
            return isFeiji, value, length
        end
    else
        local isFeiji, value, length = PdkAlgorithm.sanSanZhang_(sanZhangList)
        if isFeiji then
            return isFeiji, value, length
        end
    end
    return false, 0
end

function PdkAlgorithm.erSanZhang_(sanZhangList)
    for i=1,#sanZhangList do
        if sanZhangList[i+1] then
            local a = sanZhangList[i][1]
            local b = sanZhangList[i+1][1]
            if BaseAlgorithm.getValue(a) ~= BaseAlgorithm.getValue(b)+1 then
                return false, 0
            end
        end
    end
    local tempTable = sanZhangList[1]
    local value = BaseAlgorithm.getValue(tempTable[1])
    local length = #sanZhangList
    return true, value, length 
end

function PdkAlgorithm.sanSanZhang_(sanZhangList)
    local count = 1
    for i,v in ipairs(sanZhangList) do
        if sanZhangList[i+1] then
            local a = sanZhangList[i][1]
            local b = sanZhangList[i+1][1]
            if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b)+1 then
                local tempTable = sanZhangList[i]
                count = count + 1
                local value = BaseAlgorithm.getValue(tempTable[1])
                return true, value, count
            end
        end
    end
end

function PdkAlgorithm.isSiDai_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isSiDai, value = PdkAlgorithm.checkIsSiDai_(cards)
    if isSiDai then
        obj.cardType = PdkAlgorithm.SI_DAI
        obj.value = value 
    end
    return obj
end

function PdkAlgorithm.checkIsSiDai_(cards)
    if #cards ~= 7 then return false, 0 end 
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    for k,v in pairs(sameValueList) do
        if #v == 4 then
            return true, BaseAlgorithm.getValue(v[1])
        end
    end
    return false, 0
end

function PdkAlgorithm.isShunZi_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 
    obj.suit = 0
    obj.length = 0
    local isShunZi, value = PdkAlgorithm.checkIsShunZi_(cards)
    if isShunZi then
        obj.cardType = PdkAlgorithm.SHUN_ZI
        obj.value = value 
        obj.length = #cards
    end
    return obj
end

function PdkAlgorithm.checkIsShunZi_(cards)
    if #cards < 5 then return false, 0 end
    table.sort(cards, PdkAlgorithm.sortByValue_)
    for i=1,#cards do
        if cards[i+1] then
            if BaseAlgorithm.getValue(cards[i]) ~= BaseAlgorithm.getValue(cards[i+1]+1) then
                return false, 0
            end
        end
    end
    return true, BaseAlgorithm.getValue(cards[#cards])
end

function PdkAlgorithm.isZhaDan_(cards, config)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 
    obj.suit = 0
    obj.length = 0
    local isZhaDan, value = PdkAlgorithm.checkIsZhaDan_(cards, config)
    if isZhaDan then
        obj.cardType = PdkAlgorithm.SI_ZHA
        obj.value = value 
    end
    return obj
end

function PdkAlgorithm.checkIsZhaDan_(cards, config)
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    for i,v in pairs(sameValueList) do
        if config and config.threeABomb == 1 then
            if #v == 3 and BaseAlgorithm.getValue(cards[1]) == 14 then
                return true, 14
            elseif #v == 4 then
                return true, BaseAlgorithm.getValue(cards[1])
            end
        else
            if #v == 4 then
                return true, BaseAlgorithm.getValue(cards[1])
            end
        end
    end
    return false, 0
end

function PdkAlgorithm.checkCardsHasShunZi_(cards, length, isChaiFen)
    print(json.encode(cards))
    local shunZiCount = 0
    local count = 1
    local sIndex = 1
    local shunZiList = {}
    for i=1,#cards - 1 do
        if BaseAlgorithm.getValue(cards[i]) == BaseAlgorithm.getValue(cards[i+1]) + 1 then 
            count = count + 1
        else
            if count >= length then
                shunZiCount = shunZiCount + 1
                sIndex = i - count + 1
                local list = {}
                for i=sIndex,count + sIndex - 1 do
                    list[#list+1] = cards[i]
                end
                if isChaiFen then
                    shunZiList = PdkAlgorithm.chaifenShunzi_(list, length)
                else
                    shunZiList = {list}
                end
            end
            count = 1
        end
    end
    if sIndex == 1 and shunZiCount == 0 and count >=length then
        sIndex = #cards - count
        local list = {}
        for i=sIndex+1,sIndex + count do
            list[#list+1] = cards[i]
        end
        if isChaiFen then
            shunZiList = PdkAlgorithm.chaifenShunzi_(list, length)
        else
            shunZiList = {list}
        end
    elseif sIndex ~= 1 and shunZiCount == 0 and count >=length then
        local list = {}
        for i=sIndex+1,sIndex + count do
            list[#list+1] = tempCards[i]
        end
        if isChaiFen then
            shunZiList = PdkAlgorithm.chaifenShunzi_(list, length)
        else
            shunZiList = {list}
        end
    end
    return shunZiList
end

function PdkAlgorithm.chaifenShunzi_(cards, length)
    local tempList = {}
    local sIndex = 0
    local eIndex = 0
    for i=1,#cards - length + 1 do
        sIndex = sIndex + 1
        local list = {}
        for i=sIndex,sIndex + length -1 do
            list[#list+1] = cards[i]
        end
        tempList[#tempList+1] = list
    end
    return tempList
end

function PdkAlgorithm.checkHasLianDui_(result, duiZiList)
    -- if result.length > #duiZiList then return false end
    table.sort(duiZiList, PdkAlgorithm.sortTableByValue_)
    local lianDuiList = {}
    for i=1,#duiZiList do
        local cards = {}
        for j=i,i+result.length-1 do
            if duiZiList[j] then
                cards[#cards+1] = duiZiList[j][1]
                cards[#cards+1] = duiZiList[j][2]
            end
        end
        local isLianDui, value, length = PdkAlgorithm.checkIsLianDui_(cards)
        if isLianDui then
            lianDuiList[#lianDuiList+1] = cards
        end
    end
    return lianDuiList
end

function PdkAlgorithm.checkHasFeiJiList_(cards)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 3)
    table.sort(list, PdkAlgorithm.sortTableByValue_)
    local cards = {}
    for i=1,#list do
        if list[i] then
            cards[#cards+1] = list[i][1]
            cards[#cards+1] = list[i][2]
            cards[#cards+1] = list[i][3]
        end
    end
    local feiJiList = PdkAlgorithm.checkHasFeiJi_(cards)
    return feiJiList
end

function PdkAlgorithm.checkHasSiZha_(cards, config)
    local list = PdkAlgorithm.getCardListByCount_(cards, 4)
    if config and config.threeABomb == 1 then
        local list3Poker = PdkAlgorithm.getCardListByCount_(cards, 3)
        for i,v in ipairs(list3Poker) do
            if BaseAlgorithm.getValue(v[1]) == 14 then
                list[#list+1] = v
                break
            end
        end
    end
    return list
end

function PdkAlgorithm.checkZhaDanSameValue_(cards, list)
    for i,v in ipairs(list) do
        if PdkAlgorithm.getSameValue_(cards, v) then
            return true
        end
    end
    return false
end

function PdkAlgorithm.checkPaiXing(cards, config)
    local list = {}
    local list1 = PdkAlgorithm.checkCardsHasLianDui_(clone(cards), config)
    local list2 = PdkAlgorithm.fileterShunZi_(clone(cards), config)
    local list3 = PdkAlgorithm.checkHasFeiJi_(clone(cards))
    local list4 = PdkAlgorithm.checkHasSanDai_(clone(cards))
    if #list3 > 0 then
        if #list3[1] >= #list1 or #list3[1] >= #list2 or #list3[1] >= #list4 then
            return list3[1]
        end
    end
    if #list4 > 0 and (#list4 >= #list1 or #list4 >= #list2) then
        return list4
    end
    if #list1 > 0 and #list1 >= #list2 then
        return list1
    end
    return list2
end

function PdkAlgorithm.checkCardsHasLianDui_(cards, config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 2)
    local lianDuiList = PdkAlgorithm.fileterLianDui_(list, clone(cards),config)
    if #lianDuiList>0 then
        return lianDuiList
    end
    return {}
end

function PdkAlgorithm.fileterShunZi_(cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local danGeList = PdkAlgorithm.getDanGeCardsList_(clone(cards))
    local shunZiList = {}
    for k,v in pairs(danGeList) do
        local list = {}
        if #v >= 5 then
            list = PdkAlgorithm.checkHasShunZi_(5, v, false)
        end
        for k,v in pairs(list) do
            if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                return v
            else
                return list[1]
            end
        end
    end
    return shunZiList
end

function PdkAlgorithm.fileterLianDui_(list, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local lianDuiList = {}
    local count = 1
    local isHasLiandui = false
    local index = 0
    for i=1, #list-1 do
        if BaseAlgorithm.getValue(list[i][1]) == BaseAlgorithm.getValue(list[i+1][1])+1 then
            count = count + 1
            isHasLiandui = true
            index = i
        else
            if count >= 2 then
                isHasLiandui = false
                index = i - count + 1
                local liandui = {}
                for j=index,index+count-1 do
                    liandui[#liandui+1] = list[j][1]
                    liandui[#liandui+1] = list[j][2]  
                end
                lianDuiList[#lianDuiList+1] = liandui
            end
            count = 1
        end
    end
    if isHasLiandui and count >= 2 then
        local startIndex = index - count + 1
        local liandui = {}
        for i=startIndex+1, startIndex+count do
            liandui[#liandui+1] = list[i][1]
            liandui[#liandui+1] = list[i][2]  
        end
        lianDuiList[#lianDuiList+1] = liandui
    end
    for i,v in ipairs(lianDuiList) do
        if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
            return v
        else
            return lianDuiList[1]
        end
    end
    return {}
end

return PdkAlgorithm 
