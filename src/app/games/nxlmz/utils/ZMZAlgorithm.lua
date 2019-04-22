local BaseAlgorithm = import(".BaseAlgorithm")
local ZMZAlgorithm = {}

ZMZAlgorithm.DAN_ZHANG = 1
ZMZAlgorithm.DUI_ZI = 2
ZMZAlgorithm.LIAN_DUI = 3
ZMZAlgorithm.SAN_DAI = 4
ZMZAlgorithm.SAN_DAI_DAN = 5
ZMZAlgorithm.SAN_DAI_DUI = 6
ZMZAlgorithm.FEI_JI = 7
ZMZAlgorithm.FEI_JI_DAN = 8
ZMZAlgorithm.FEI_JI_DUI = 9
ZMZAlgorithm.SI_DAI = 10
ZMZAlgorithm.SI_DAI_DAN = 11
ZMZAlgorithm.SI_DAI_DUI = 12
ZMZAlgorithm.SHUN_ZI = 13
ZMZAlgorithm.SI_ZHA = 14
ZMZAlgorithm.NEED_CAN_CHANGE = 99

function ZMZAlgorithm.sortOutPokers(cards,config)
    local result = ZMZAlgorithm.getCardType(clone(cards),config)
    if result.cardType == ZMZAlgorithm.SAN_DAI_DAN or result.cardType == ZMZAlgorithm.SAN_DAI_DUI then
        local cards = ZMZAlgorithm.sortSanDai(clone(cards), result)
        return cards
    elseif result.cardType == ZMZAlgorithm.FEI_JI_DAN or result.cardType == ZMZAlgorithm.FEI_JI_DUI then
        local cards = ZMZAlgorithm.sortFeiJi(clone(cards), result)
        return cards
    elseif result.cardType == ZMZAlgorithm.SI_DAI_DAN or result.cardType == ZMZAlgorithm.SI_DAI_DUI then
        local cards = ZMZAlgorithm.sortSiDai(clone(cards), result)
        return cards
    else
        return ZMZAlgorithm.sort(cards)
    end
    return cards
end

function  ZMZAlgorithm.sortSanDai(cards, result)
    local list1 = {}
    local list2 = {0}
    for i,v in ipairs(cards) do
        if result.value == BaseAlgorithm.getValue(v) then
            list1[#list1+1] = v
        else
            list2[#list2+1] = v
        end
    end
    table.insertto(list1, list2)
    return list1
end

function  ZMZAlgorithm.sortSiDai(cards, result)
    local list1 = {}
    local list2 = {0}
    for i,v in ipairs(cards) do
        if result.value == BaseAlgorithm.getValue(v) then
            list1[#list1+1] = v
        else
            list2[#list2+1] = v
        end
    end
    table.insertto(list1, list2)
    return list1
end

function  ZMZAlgorithm.sortFeiJi(cards, result)
    local length = result.length
    local value = result.value
    local list = {}
    for i = 1, length do
        list[i] = value - (i-1)
    end
    local list1 = {}
    local list2 = {0}
    table.sort(cards, ZMZAlgorithm.sortBySmallValue_)
    for i,v in ipairs(cards) do
        if table.indexof(list, BaseAlgorithm.getValue(v)) == false then
            list2[#list2+1] = v
        else
            list1[#list1+1] = v
        end
    end
    table.insertto(list1, list2)
    return list1
end


function ZMZAlgorithm.sort(cards)
    table.sort(cards, ZMZAlgorithm.sortByValue_)
    return cards
end

function ZMZAlgorithm.hasHeiSan(cards)
    for i,v in ipairs(cards) do
        if v == 403 then
            return true
        end
    end
    return false
end

function ZMZAlgorithm.getDanGeCardsList_(cards,config)
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    local danGeList = {}
    for i=1,4 do
        local cards = {}
        for k,v in pairs(sameValueList) do
            local siZhares = ZMZAlgorithm.checkHasSiZha_(v, config)
            if #siZhares == 0 then
                if v[i] then
                    cards[#cards+1] = v[i]
                end
            end
        end
        if #cards >= 5 then
            danGeList[#danGeList+1] = cards
        end
    end
    return danGeList
end

function ZMZAlgorithm.getSameValue_(list1, list2)
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

function ZMZAlgorithm.getDuiCardList(cards,needCard)
    local hs = {3,4,2,1}
    local needCardSuitInfo = {}
    if needCard then
        local cardValue = needCard%100 
        for i = 1,4 do
            local aimValue = 100*hs[i] + cardValue
            if table.indexof(cards, aimValue) then
                table.insert(needCardSuitInfo,aimValue)
            end
        end
    end

    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    local duiList = {}
    local caiDuiList = {}
    local count = 2
    for k,v in pairs(sameValueList) do
        if #v == count then
            local cards = {}
            for i=1,count do
                cards[#cards+1] = v[i]
            end
            duiList[#duiList+1] = cards
            caiDuiList[#caiDuiList+1] = cards
        end
    end
    table.sort(duiList, ZMZAlgorithm.tiShiSortTableByValue_)
    if not isOnly then
        for k,v in pairs(sameValueList) do
            if #v > 2 and #v ~= 4 and BaseAlgorithm.getValue(v[1]) ~= 14 then
                local cards = {}
                for i=1,count do
                    cards[#cards+1] = v[i]
                end
                if needCard and needCard%100 == BaseAlgorithm.getValue(v[1]) then
                else
                    caiDuiList[#caiDuiList+1] = cards
                end
            end
        end
    end
    table.sort(caiDuiList, ZMZAlgorithm.tiShiSortTableByValue_)
    if #needCardSuitInfo == 3 then
        local cards = {needCardSuitInfo[1],needCardSuitInfo[2]}
        table.insert(duiList,1,cards)
        table.insert(caiDuiList,1,cards)
    end 
    return duiList,caiDuiList
end

--连对
function ZMZAlgorithm.getCardListByCount_(cards, count, isOnly)
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
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
    table.sort(tempList, ZMZAlgorithm.sortTableByValue_)
    return tempList
end

function ZMZAlgorithm.getDanZhangBiggerList_(result, cards, config)
    local dzList = ZMZAlgorithm.getCardListByCount_(clone(cards), 1, true)
    local dzBiggers = {}
    for i,v in ipairs(dzList) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            dzBiggers[#dzBiggers+1] = v
        end
    end
    table.sort(dzBiggers, ZMZAlgorithm.tiShiSortTableByValue_)
    return dzBiggers
end

function ZMZAlgorithm.getDuiZiBiggerList_(result, cards, config, count)
    local duiZiList = ZMZAlgorithm.getCardListByCount_(clone(cards), 2, true)
    local duiZiBiggers = {}
    for i,v in ipairs(duiZiList) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            if config and config.denySplitBomb == 0  then
                if count == 1 then
                    duiZiBiggers[#duiZiBiggers+1] = {v[1]}
                else
                    duiZiBiggers[#duiZiBiggers+1] = v
                end
            else
                if count == 1 then
                    duiZiBiggers[#duiZiBiggers+1] = {v[1]}
                else
                    duiZiBiggers[#duiZiBiggers+1] = v
                end
            end
        end
    end
    table.sort(duiZiBiggers, ZMZAlgorithm.tiShiSortTableByValue_)
    return duiZiBiggers
end

function ZMZAlgorithm.getSanZhangBiggerList_(result, cards, config, count)
    local sanZhangList = ZMZAlgorithm.getCardListByCount_(clone(cards), 3, true)
    local sanZhangBiggers = {}
    for i,v in ipairs(sanZhangList) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            if config and config.denySplitBomb == 0 then
                if count == 2 then
                    sanZhangBiggers[#sanZhangBiggers+1] = {v[1], v[2]}
                elseif count == 1 then
                    sanZhangBiggers[#sanZhangBiggers+1] = {v[1]}
                else
                    sanZhangBiggers[#sanZhangBiggers+1] = v
                end
            else
                if count == 2 then
                    sanZhangBiggers[#sanZhangBiggers+1] = {v[1], v[2]}
                elseif count == 1 then
                    sanZhangBiggers[#sanZhangBiggers+1] = {v[1]}
                else
                    sanZhangBiggers[#sanZhangBiggers+1] = v
                end
            end
        end
    end
    table.sort(sanZhangBiggers, ZMZAlgorithm.tiShiSortTableByValue_)
    return sanZhangBiggers
end


function ZMZAlgorithm.getDanZhangList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config, count)
    local dzBiggers = ZMZAlgorithm.getDanZhangBiggerList_(result, clone(cards), config, 1)
    local biggerList = {}
    for i,v in ipairs(dzBiggers) do
        biggerList[#biggerList+1] = v
    end
    if result.value ~= 0 or result.length ~= 0 or result.suit ~= 0 or result.cardType ~= 0 then 
        if #biggerList <= 1 then
            local duiZiBiggers = ZMZAlgorithm.getDuiZiBiggerList_(result, clone(cards), config, 1)
            local sanZhangBiggers = ZMZAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 1)
            if #biggerList <= 1 then
                for i,v in ipairs(duiZiBiggers) do
                    biggerList[#biggerList+1] = v
                    if #biggerList == 2 then
                        break
                    end
                end
            end
            if #biggerList <= 1 then       
                for i,v in ipairs(sanZhangBiggers) do
                    biggerList[#biggerList+1] = v
                    if #biggerList == 2 then
                        break
                    end
                end
            end
        end
    end
    return biggerList
end

function ZMZAlgorithm.getDuiZiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local duiZiBiggers = ZMZAlgorithm.getDuiZiBiggerList_(result, clone(cards), config, 2)
    local biggerList = {}
    for i,v in ipairs(duiZiBiggers) do
        biggerList[#biggerList+1] = v
    end
    if result.value ~= 0 or result.length ~= 0 or result.suit ~= 0 or result.cardType ~= 0 then
        local sanZhangBiggers = ZMZAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 2)
        for i,v in ipairs(sanZhangBiggers) do
            biggerList[#biggerList+1] = v
        end
    end
    return biggerList
end

function ZMZAlgorithm.getLianDuiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local isOnly = false
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then
        isOnly = true
    end
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 2, isOnly)
    local threeList = ZMZAlgorithm.getCardListByCount_(clone(cards), 3, false)
    local lianDuiList = ZMZAlgorithm.checkHasLianDui_(result, list)
    local biggerList = {}
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then --表示新的一轮自己出牌
        for i,v in ipairs(lianDuiList) do
            biggerList[#biggerList+1] = v
        end
    else
        for i,v in ipairs(lianDuiList) do
            local obj = ZMZAlgorithm.getCardType(v, config)
            if result and obj.length == result.length and obj.value > result.value then
                if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                    table.insert(biggerList,1,v)
                else
                    table.insert(biggerList,1,v)
                end
            end
        end
        local function myCmp(a,b)
            return a[1]%100 < b[1]%100
        end
        local tempList = {}
        for i,v in ipairs(threeList) do
            for k,cards in ipairs(biggerList) do
                if table.indexof(cards, v[1]) ~= false then
                    table.insert(tempList,cards)
                    table.removebyvalue(biggerList,cards)
                    break
                end
            end
        end
        table.sort(biggerList,myCmp)
        table.sort(tempList,myCmp)
        table.insertto(biggerList, tempList)
    end
    return biggerList
end

function ZMZAlgorithm.getSanList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local sanZhangBiggers = ZMZAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 3)
    local biggerList = {}
    for i,v in ipairs(sanZhangBiggers) do
        biggerList[#biggerList+1] = v
    end
    return biggerList
end


function ZMZAlgorithm.getSanDaiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local sanZhangBiggers = ZMZAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 3)
    local biggerList = {}
    for i,v in ipairs(sanZhangBiggers) do
        biggerList[#biggerList+1] = v
    end
    return biggerList
end

function ZMZAlgorithm.getSanDaiYiDuiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local sanZhangBiggers = ZMZAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 3)
    -- local duiZiList = 
    local biggerList = {}
    for i,v in ipairs(sanZhangBiggers) do
        biggerList[#biggerList+1] = v
    end
    return biggerList
end

function ZMZAlgorithm.getFeiJiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local feiJiList = ZMZAlgorithm.checkHasFeiJiList_(clone(cards))
    if feiJiList == nil then
        return {}
    end
    local biggerList = {}
    for i,v in ipairs(feiJiList) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                table.insert(biggerList,1,v)
            else
                table.insert(biggerList,1,v)
            end
        end
    end
    local function myCmp(a,b)
        return a[1]%100 < b[1]%100
    end
    table.sort(biggerList,myCmp)
    return biggerList
end

function ZMZAlgorithm.getFeiJiDanList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local feiJiList = ZMZAlgorithm.checkHasFeiJiList_(clone(cards))
    if feiJiList == nil then
        return {}
    end
    local biggerList = {}
    for i,v in ipairs(feiJiList) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                table.insert(biggerList,1,v)
            else
                table.insert(biggerList,1,v)
            end
        end
    end
    local function myCmp(a,b)
        return a[1]%100 < b[1]%100
    end
    table.sort(biggerList,myCmp)
    return biggerList
end

function ZMZAlgorithm.getFeiJiDuiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local feiJiList = ZMZAlgorithm.checkHasFeiJiList_(clone(cards))
    if feiJiList == nil then
        return {}
    end
    local biggerList = {}
    for i,v in ipairs(feiJiList) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                table.insert(biggerList,1,v)
            else
                table.insert(biggerList,1,v)
            end
        end
    end
    local function myCmp(a,b)
        return a[1]%100 < b[1]%100
    end
    table.sort(biggerList,myCmp)
    return biggerList
end

function ZMZAlgorithm.getSiDai_(result, cards, config)
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 4)
    local biggerList = {}
    for i,v in ipairs(list) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function ZMZAlgorithm.getSiDaiYiList_(result, cards, config)
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 4)
    local biggerList = {}
    for i,v in ipairs(list) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function ZMZAlgorithm.getSiDaiErList_(result, cards, config)
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 4)
    local biggerList = {}
    for i,v in ipairs(list) do
        local obj = ZMZAlgorithm.getCardType(v, config)
        if obj.value > result.value then
            if config and config.denySplitBomb == 0 then
                biggerList[#biggerList+1] = v
            else
                biggerList[#biggerList+1] = v
            end
        end
    end
    return biggerList
end

function ZMZAlgorithm.getShunZiList_(result, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local danGeList = ZMZAlgorithm.getDanGeCardsList_(clone(cards),config)
    local biggerList = {} 
    local function myCmp(a,b)
        return a < b
    end   
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then --表示新的一轮自己出牌
        local aimList = {}
        for k,v in pairs(danGeList) do
            local list = {}
            if #v >= result.length then
                for i = result.length,#v do
                    list = ZMZAlgorithm.checkHasShunZi_(i, v, true)
                    for k,v in pairs(list) do
                        local obj = ZMZAlgorithm.getCardType(v, config)
                        if obj.value > result.value then
                            if #v > #aimList then
                                aimList = v
                            end
                        end
                    end
                end
            end
        end
        if #aimList > 4 then
            biggerList[#biggerList+1] = aimList
        end
    else
        for k,v in pairs(danGeList) do
            local list = {}
            if #v >= result.length then
                list = ZMZAlgorithm.checkHasShunZi_(result.length, v, true)
            end
            for k,v in pairs(list) do
                local obj = ZMZAlgorithm.getCardType(v, config)
                if obj.value > result.value then
                    table.insert(biggerList,1,v)
                end
            end
        end
        local function myCmp(a,b)
            return a[1]%100 < b[1]%100
        end
        table.sort(biggerList,myCmp)
    end
   
    return biggerList
end

function ZMZAlgorithm.checkHasShunZi_(length, cards, isChaiFen)
    table.sort(cards, ZMZAlgorithm.sortByValue_)
    local list = ZMZAlgorithm.checkCardsHasShunZi_(clone(cards), length, isChaiFen)
    return list
end

function ZMZAlgorithm.getSiZhaList_(result, cards, config)
    local list = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local biggerList = {}
    for i,v in ipairs(list) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            biggerList[#biggerList+1] = v
        end
    end
    return biggerList
end

local cardTypeTable = {}

cardTypeTable[ZMZAlgorithm.DAN_ZHANG] = ZMZAlgorithm.getDanZhangList_
cardTypeTable[ZMZAlgorithm.DUI_ZI] = ZMZAlgorithm.getDuiZiList_
cardTypeTable[ZMZAlgorithm.LIAN_DUI] = ZMZAlgorithm.getLianDuiList_
cardTypeTable[ZMZAlgorithm.SAN_DAI] = ZMZAlgorithm.getSanList_
cardTypeTable[ZMZAlgorithm.SAN_DAI_DAN] = ZMZAlgorithm.getSanDaiList_
cardTypeTable[ZMZAlgorithm.SAN_DAI_DUI] = ZMZAlgorithm.getSanDaiYiDuiList_
cardTypeTable[ZMZAlgorithm.FEI_JI] = ZMZAlgorithm.getFeiJiList_
cardTypeTable[ZMZAlgorithm.FEI_JI_DAN] = ZMZAlgorithm.getFeiJiDanList_
cardTypeTable[ZMZAlgorithm.FEI_JI_DUI] = ZMZAlgorithm.getFeiJiDuiList_
cardTypeTable[ZMZAlgorithm.SI_DAI] = ZMZAlgorithm.getSiDai_
cardTypeTable[ZMZAlgorithm.SI_DAI_DAN] = ZMZAlgorithm.getSiDaiYiList_
cardTypeTable[ZMZAlgorithm.SI_DAI_DUI] = ZMZAlgorithm.getSiDaiErList_
cardTypeTable[ZMZAlgorithm.SHUN_ZI] = ZMZAlgorithm.getShunZiList_
cardTypeTable[ZMZAlgorithm.SI_ZHA] = ZMZAlgorithm.getSiZhaList_

function ZMZAlgorithm.sortByValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) > BaseAlgorithm.getValue(b)
    end
end

function ZMZAlgorithm.sortBySmallValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) < BaseAlgorithm.getValue(b)
    end
end

function ZMZAlgorithm.sortTableByValue_(a,b)
    if BaseAlgorithm.getValue(a[1]) == BaseAlgorithm.getValue(b[1]) then
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    else
        return BaseAlgorithm.getValue(a[1]) > BaseAlgorithm.getValue(b[1])
    end
end

function ZMZAlgorithm.tiShiSortTableByValue_(a,b)
    if BaseAlgorithm.getValue(a[1]) == BaseAlgorithm.getValue(b[1]) then
        return BaseAlgorithm.getSuit(a[1]) < BaseAlgorithm.getSuit(b[1])
    else
        return BaseAlgorithm.getValue(a[1]) < BaseAlgorithm.getValue(b[1])
    end
end

function ZMZAlgorithm.getSameValueCards_(cards)
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

function ZMZAlgorithm.checkNeedHe3(result,handCards,config)
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
        if #handCards == config.cardCount and table.indexof(handCards, 303) then
            return 303
        end
    end
    return nil
end

function ZMZAlgorithm.tishi(cards, handCards, config,isBaoDan)
    local result = ZMZAlgorithm.getCardType(cards, config)
    local biggerList = {}
    local cardList = {}
    local zhaDanList = {}
    local zhaDanValue = result.value
    local danInfo =  ZMZAlgorithm.getDanZhangBiggerList_({cardType = 0,length = 0, suit = 0, value = 0},clone(handCards), config, 1)
    local need3 = ZMZAlgorithm.checkNeedHe3(result,handCards,config)
    local zdInfo = ZMZAlgorithm.checkHasSiZha_(clone(handCards), config)
    local szInfo = ZMZAlgorithm.getCardListByCount_(clone(handCards), 3, true)
    local duiInfo,caiDuiInfo = ZMZAlgorithm.getDuiCardList(clone(handCards),need3)
    local zdValues = {}
    for i = 1,#zdInfo do
        zdValues[i] = zdInfo[i][1]%100
    end
    local szValues = {}
    for i = 1,#szInfo do
        szValues[i] = szInfo[i][1]%100
    end
    if result.cardType ~= ZMZAlgorithm.SI_ZHA then
        cardList = ZMZAlgorithm.getCardsByCardType_(result, handCards, config)
        zhaDanValue = 0
        for i,v in ipairs(cardList) do
            table.insertto(biggerList, {v})
        end
    end
    local obj = {}
    obj.cardType = ZMZAlgorithm.SI_ZHA
    obj.value = zhaDanValue
    zhaDanList = ZMZAlgorithm.getCardsByCardType_(obj, handCards, config)
    dump(result,"resultresultresultresult")
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
        local oneAndTwo = {{},{}}
        local other = {}
        for i,v in ipairs(biggerList) do
            if #v == 1 or #v == 2 then
                table.insert(oneAndTwo[#v],clone(v))
            else
                local tempIndex = clone(v)
                local function myCmp1(a,b)
                    return table.indexof(tempIndex, a) > table.indexof(tempIndex, b)
                end
                table.sort(v,myCmp1)
                local findResult = ZMZAlgorithm.getCardType(v, config)
                if findResult.cardType == ZMZAlgorithm.SI_ZHA then
                    findResult.cardType = ZMZAlgorithm.SI_DAI
                end
                local needNum = ZMZAlgorithm.getNeedCardNum(findResult.cardType,findResult.length,config)
                if needNum > 0 then
                    local addCard = ZMZAlgorithm.getCardByNum(needNum,danInfo,handCards,findResult,zdValues,szValues,need3,duiInfo,caiDuiInfo)
                    local vLen = #v
                    for j = 1,#addCard do
                        v[vLen+j] = addCard[j]
                    end
                end
                table.insert(other,clone(v))
            end
        end
        if isBaoDan then
            local function myCmp1(a,b)
                return a[1]%100 > b[1]%100
            end
            table.sort(oneAndTwo[1],myCmp1)
            oneAndTwo[1] = {oneAndTwo[1][1]}
        end
        local function myCmp(a,b)
            if #a == #b then
                return a[1]%100 < b[1]%100
            else
                return #a > #b
            end
        end
        table.sort(other, myCmp)
        local otherLen = #other
        for i = 2,1,-1 do
            for j = 1,#oneAndTwo[i] do
                table.insert(other,oneAndTwo[i][j])
            end
        end
        biggerList = other
    else
        dump(biggerList,"biggerListbiggerList")
        local temp = {}
        for i,v in ipairs(biggerList) do
            local findResult = ZMZAlgorithm.getCardType(v, config)
            if findResult.cardType == ZMZAlgorithm.SI_ZHA then
                findResult.cardType = ZMZAlgorithm.SI_DAI
            end
            local needNum = ZMZAlgorithm.getNeedCardNum(findResult.cardType,findResult.length,config)
            table.insert(temp,v)
            if result.cardType == ZMZAlgorithm.SAN_DAI or result.cardType == ZMZAlgorithm.SI_DAI or result.cardType == ZMZAlgorithm.FEI_JI then
                needNum = 0
            end
            if needNum > 0 then
                local addCard = ZMZAlgorithm.getCardByNum(needNum,danInfo,handCards,findResult,zdValues,szValues,false,duiInfo,caiDuiInfo,result.cardType)
                if #addCard > 0 then
                    local vLen = #v
                    for j = 1,#addCard do
                        v[vLen+j] = addCard[j]
                    end
                    table.insert(temp,v)
                end
            end
        end
        biggerList = temp
    end
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
       
    else
        local temp = {}
        for i,v in ipairs(biggerList) do
            local needInsert = true
            for j = 1,#v do
                local aimIndex = table.indexof(zdValues, v[j]%100)
                if aimIndex then
                    needInsert = false
                end
            end
            if needInsert then
                table.insert(temp,clone(v))
            end
        end
        if #temp > 0 then
            biggerList = temp
        else
            local temp = clone(biggerList)
            for i,v in ipairs(temp) do
                for j = 1,#v do
                    local aimIndex = table.indexof(zdValues, v[j]%100)
                    if aimIndex ~= false then
                        table.sort(zhaDanList[aimIndex])
                        table.insert(biggerList,i,clone(zhaDanList[aimIndex]))
                        zdValues[aimIndex] = 0
                    end
                end
            end
        end
       
    end
    
    for i,v in ipairs(zdValues) do
        if v > 0 then
            table.insert(biggerList,clone(zhaDanList[i]))
        end
    end
    biggerList = ZMZAlgorithm.removeSome(biggerList)
    dump(biggerList,"biggerListbiggerListbiggerList")
    if need3 then
        local aimValue = {}
        for i,v in ipairs(biggerList) do
            if table.indexof(v, need3) then
                table.insert(aimValue,clone(v))
            end
        end
        biggerList = aimValue
    end
    dump(biggerList,"biggerListbiggerListbiggerList1111111111")
    return biggerList
end

function ZMZAlgorithm.removeSome(other)
    local someElemtIndex = {}
    for i = 1,#other do
        if not table.indexof(someElemtIndex, i) then
            for j = i + 1 ,#other do
                if #other[i] == #other[j] then
                    local len = #other[i] 
                    local isOk = true
                    for k = 1,len do
                        if other[i][k] ~= other[j][k] then
                            isOk = false
                            break
                        end
                    end
                    if isOk then
                        table.insert(someElemtIndex,j)
                    end
                end
            end
        end
    end
    local otherT = {}
    for i = 1,#other do
        if not table.indexof(someElemtIndex, i) then
            table.insert(otherT, clone(other[i]))
        end
    end
    return otherT
end

function ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,needNum,danListHaveNeed)
    if danListHaveNeed then
        return false
    end
    local addCard = {}
    if #duiInfo >= needNum then
        local index = 0
        for i = 1,#duiInfo do
            if table.indexof(compareCard, duiInfo[i][1]%100) == false then
                index = index + 1
                table.insertto(addCard,duiInfo[i])
                if index == needNum then
                    return true,addCard
                end
            end
        end
    end
    addCard = {} 
    if #caiDuiInfo >= needNum then
        local index = 0
        for i = 1,#caiDuiInfo do
            if table.indexof(compareCard, caiDuiInfo[i][1]%100) == false then
                index = index + 1
                table.insertto(addCard,caiDuiInfo[i])
                if index == needNum then
                    return true,addCard
                end
            end
        end
    end
    return false
end

function ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,needNum)
    local addCard = {}
    if #danInfo >= needNum then
        for i = 1,needNum do
            table.insertto(addCard,danInfo[i])
        end
        return true,addCard
    else
        for i = 1,#danInfo do
            table.insertto(addCard,danInfo[i])
        end
    end
    local temp = clone(addCard)
    needNum = needNum - #addCard
    if #duiInfo >= needNum then
        local index = 0
        for i = 1,#duiInfo do
            if table.indexof(compareCard, duiInfo[i][1]%100) == false then
                index = index + 1
                table.insert(addCard,duiInfo[i][1])
                if index == needNum then
                    return true,addCard
                end
            end
        end
    end
    addCard = temp
    if #caiDuiInfo >= needNum then
        local index = 0
        for i = 1,#caiDuiInfo do
            if table.indexof(compareCard, caiDuiInfo[i][1]%100) == false then
                index = index + 1
                able.insert(addCard,caiDuiInfo[i][1])
                if index == needNum then
                    return true,addCard
                end
            end
        end
    end
    return false
end

function ZMZAlgorithm.getCardByNum(needNum,danInfo,handCards,cardInfo,zdValues,szValues,needValue,duiInfo,caiDuiInfo,outType)
    if cardInfo.cardType == ZMZAlgorithm.FEI_JI or cardInfo.cardType == ZMZAlgorithm.FEI_JI_DAN or cardInfo.cardType == ZMZAlgorithm.FEI_JI_DUI then
        cardInfo.value = cardInfo.value - cardInfo.length + 1
    end
    local count = needNum
    local compareCard = {}
    local addCard = {}
    local cpCardLen = #compareCard
    if cardInfo.length == 0 then
        compareCard[cpCardLen + 1] = cardInfo.value
    else
        for i = 0,cardInfo.length -1 do
            compareCard[cpCardLen+i+1] = cardInfo.value + i
        end
    end
    cpCardLen = #compareCard
    for i = 1,#zdValues do
        compareCard[cpCardLen+1] = zdValues[i]
    end
    local danListHaveNeed = false
    if needValue and danInfo and danInfo[1] and danInfo[1][1] == needValue then
        danListHaveNeed = true
    end
    local res,info
    if cardInfo.cardType == ZMZAlgorithm.SAN_DAI then
        if outType and outType == ZMZAlgorithm.SAN_DAI_DUI then
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,1,danListHaveNeed)
            if res then
                return info
            end
        elseif outType and outType == ZMZAlgorithm.SAN_DAI_DAN then
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,1)
            if res then
                return info
            end
        else
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,1,danListHaveNeed)
            if res then
                return info
            end
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,1)
            if res then
                return info
            end
        end
    elseif cardInfo.cardType == ZMZAlgorithm.SI_DAI then
        if outType and outType == ZMZAlgorithm.SI_DAI_DUI then
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,2,danListHaveNeed)
            if res then
                return info
            end
        elseif outType and outType == ZMZAlgorithm.SI_DAI_DAN then
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,2)
            if res then
                return info
            end
        else    
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,2,danListHaveNeed)
            if res then
                return info
            end
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,2)
            if res then
                return info
            end
        end
      
    elseif cardInfo.cardType == ZMZAlgorithm.FEI_JI then
        if outType and outType == ZMZAlgorithm.FEI_JI_DUI then
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,cardInfo.length,danListHaveNeed)
            if res then
                return info
            end
        elseif outType and outType == ZMZAlgorithm.FEI_JI_DAN then
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,cardInfo.length)
            if res then
                return info
            end
        else
            res,info = ZMZAlgorithm.getCardDui(compareCard,duiInfo,caiDuiInfo,cardInfo.length,danListHaveNeed)
            if res then
                return info
            end
            res,info = ZMZAlgorithm.getCardDan(compareCard,danInfo,duiInfo,caiDuiInfo,cardInfo.length)
            if res then
                return info
            end
        end
        
    end
    return addCard
end

function ZMZAlgorithm.getNeedCardNum(type,lenth,config)
    if type == ZMZAlgorithm.SAN_DAI or type == ZMZAlgorithm.SI_DAI or type == ZMZAlgorithm.FEI_JI then
        return ZMZAlgorithm.NEED_CAN_CHANGE
    end

    return 0
end

function ZMZAlgorithm.sortBiggerList_(a, b)
    local result1 = ZMZAlgorithm.getCardType(a)
    local result2 = ZMZAlgorithm.getCardType(b)
    if result1.cardType == result2.cardType then
        return result1.value < result2.value
    else
        return result1.cardType  < result2.cardType 
    end
end

function ZMZAlgorithm.cardInCards_(card, cards)
    for k,v in pairs(cards) do
        if v == card then return true end
    end
    return false
end

function ZMZAlgorithm.getCardsByCardType_(result, handCards, config)
    local cardList = {}

    if result.cardType == 0 then
        for i,v in ipairs(cardTypeTable) do
            if i ~= ZMZAlgorithm.SAN_DAI_DAN and i ~= ZMZAlgorithm.FEI_JI_DAN and i ~= ZMZAlgorithm.SI_DAI_DAN then
                if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
                    if i ~=  ZMZAlgorithm.SI_ZHA then
                        local list = v(result, clone(handCards), config)
                        table.insertto(cardList, list)
                    end
                else
                    local list = v(result, clone(handCards), config)
                    table.insertto(cardList, list)
                end
            end
        end
    else
        cardList = cardTypeTable[result.cardType](result, handCards, config) 
    end
    return cardList
end

function ZMZAlgorithm.isBigger(cards1, cards2, config)
    local result1 = ZMZAlgorithm.getCardType(cards1, config)
    local result2 = ZMZAlgorithm.getCardType(cards2, config)
    if result1.cardType == 0 then return false end
    if result1.cardType < 0 or result2.cardType < 0 then return false end
    if result2.cardType == 0 then return true end
    if result1.cardType == result2.cardType then
        if result1.cardType == ZMZAlgorithm.SHUN_ZI then
            if result1.length ~= result2.length then
                return false
            end 
        elseif result1.cardType == ZMZAlgorithm.FEI_JI_DAN or result1.cardType == ZMZAlgorithm.FEI_JI_DUI or result1.cardType == ZMZAlgorithm.FEI_JI then
            if result1.length ~= result2.length or #cards1 ~= #cards2 then
                return false
            end 
        elseif result1.cardType == ZMZAlgorithm.SAN_DAI_DAN or result1.cardType == ZMZAlgorithm.SAN_DAI_DUI or result1.cardType == ZMZAlgorithm.SAN_DAI
            or result1.cardType == ZMZAlgorithm.SI_DAI or result1.cardType == ZMZAlgorithm.SI_DAI_DAN or result1.cardType == ZMZAlgorithm.SI_DAI_DUI then
            if #cards1 ~= #cards2 then 
                return false
            end
        end
        return result1.value > result2.value
    elseif result1.cardType ~= result2.cardType then
        if result1.cardType == ZMZAlgorithm.SI_ZHA then
            return true
        else
            return false
        end
    end
end

function ZMZAlgorithm.getCardType(cards, config)
    local result
    if #cards >=5 then
    result = ZMZAlgorithm.lengthBigerThenFive_(clone(cards),config)
    elseif #cards < 5 then
    result = ZMZAlgorithm.lengthNotBiggerThenFive_(clone(cards), config)
    end
    return result
end

function ZMZAlgorithm.lengthBigerThenFive_(cards,config)
    local result = ZMZAlgorithm.isSiDai_(clone(cards),config)
    if result.value == 0 then
        result = ZMZAlgorithm.isFeiJi_(clone(cards))
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isShunZi_(clone(cards))
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isSanDai_(clone(cards))
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isLianDui_(clone(cards))
    end
    return result
end

function ZMZAlgorithm.lengthNotBiggerThenFive_(cards, config)
    local result = ZMZAlgorithm.isDanZhang_(clone(cards))
    if result.value == 0 then
        result = ZMZAlgorithm.isDuiZi_(clone(cards))
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isLianDui_(clone(cards))
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isZhaDan_(clone(cards), config)
    end
    if result.value == 0 then
        result = ZMZAlgorithm.isSanDai_(clone(cards))
    end
    return result
end

function ZMZAlgorithm.isDanZhang_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    if #cards ~= 1 then return obj end
    obj.cardType = ZMZAlgorithm.DAN_ZHANG
    obj.value = BaseAlgorithm.getValue(cards[1])
    return obj
end

function ZMZAlgorithm.isDuiZi_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    if #cards ~= 2 then return obj end
    if ZMZAlgorithm.checkIsDuiZi_(cards) then
        obj.cardType = ZMZAlgorithm.DUI_ZI
        obj.value = BaseAlgorithm.getValue(cards[1])
    end
    return obj
end

function ZMZAlgorithm.checkIsDuiZi_(cards)
    if #cards == 2 then
        if BaseAlgorithm.getValue(cards[1]) == BaseAlgorithm.getValue(cards[2]) then
            return true
        end
    end
    return false
end

function ZMZAlgorithm.isLianDui_(cards)
    local obj = {}
    obj.suit = 0
    obj.cardType = 0
    obj.value = 0
    obj.length = 0
    local isLianDui, value, length = ZMZAlgorithm.checkIsLianDui_(cards)
    if isLianDui then
        obj.cardType = ZMZAlgorithm.LIAN_DUI
        obj.value = value
        obj.length = length
    end
    return obj
end

function ZMZAlgorithm.checkIsLianDui_(cards)
    if #cards>2 and math.mod(#cards, 2) == 0 then
        table.sort(cards, ZMZAlgorithm.sortByValue_)
        for i=1,#cards,2 do
            if cards[i+2] and 
                (BaseAlgorithm.getValue(cards[i]) ~= BaseAlgorithm.getValue(cards[i+2])+1 
                or BaseAlgorithm.getValue(cards[i]) ~= BaseAlgorithm.getValue(cards[i+1]))
                then
                return false, 0
            end
        end
    else
        return false, 0
    end
    return true, BaseAlgorithm.getValue(cards[1]), #cards/2
end

function ZMZAlgorithm.isSanDai_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isSanDai,value,type = ZMZAlgorithm.checkIsSanDai_(cards)
    if isSanDai then
        obj.cardType = type
        obj.value = value
    end
    return obj
end

function ZMZAlgorithm.checkHasSanDai_(cards)
    if #cards ~= 5 then return {} end
    local erList = ZMZAlgorithm.getCardListByCount_(clone(cards), 2, true)
    local sanList = ZMZAlgorithm.getCardListByCount_(clone(cards), 3)
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

function ZMZAlgorithm.checkIsSanDai_(cards)
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    local count3 = 0
    local count1 = 0
    local count2 = 0 
    local aimValue = 0
    for k,v in pairs(sameValueList) do
        if #v == 3 then
            count3 = count3 + 1
            aimValue = BaseAlgorithm.getValue(v[1])
        elseif #v == 2 then
            count2 = count2 + 1
        elseif #v == 1 then
            count1 = count1 + 1
        end
    end
    if count3 > 0 and count1 > 0 and count3*3+count1 == #cards then
        return true,aimValue,ZMZAlgorithm.SAN_DAI_DAN
    elseif count3 > 0 and count2 > 0 and count3*3+count2*2 == #cards then
        return true,aimValue,ZMZAlgorithm.SAN_DAI_DUI
    elseif count3*3 == #cards then
        return true,aimValue,ZMZAlgorithm.SAN_DAI
    end
    return false, 0
end

function ZMZAlgorithm.isFeiJi_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isFeiji, value, length, type = ZMZAlgorithm.checkIsFeiJi_(cards)
    if isFeiji then
        obj.cardType = type
        obj.value = value
        obj.length = length
    end
    return obj
end

function ZMZAlgorithm.checkHasFeiJi_(cards)
    if #cards < 6 then return {} end
    local sanZhangList = ZMZAlgorithm.getCardListByCount_(clone(cards), 3)
    if #sanZhangList < 2 then
        return {}
    end
    table.sort(sanZhangList, ZMZAlgorithm.sortTableByValue_)
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

function ZMZAlgorithm.checkIsFeiJi_(cards)
    if #cards < 6 then return false, 0 end
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    local sanZhangList = {}
    local count1 = 0
    local count2 = 0 
    for k,v in pairs(sameValueList) do
        if #v == 3 then
            sanZhangList[#sanZhangList+1] = v
        elseif #v == 2 then
            count2 = count2 + 1
        elseif #v == 1 then
            count1 = count1 + 1
        end
    end
    if #sanZhangList < 2 then
        return false, 0
    end
    table.sort(sanZhangList, ZMZAlgorithm.sortTableByValue_)
    -- dump(sanZhangList)
    if #sanZhangList == 2 then
        local isFeiji, value, length = ZMZAlgorithm.erSanZhang_(sanZhangList)
        if isFeiji then
            if count1 == 2 and 6 + count1*1 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI_DAN
            elseif count2 == 2 and 6 + count2*2 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI_DUI
            elseif 6 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI
            end
        end
    else
        local isFeiji, value, length = ZMZAlgorithm.sanSanZhang_(sanZhangList)
        if isFeiji then
            if count1 == 3 and 9 + count1*1 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI_DAN
            elseif count2 == 3 and 9 + count2*2 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI_DUI
            elseif 9 == #cards then
                return isFeiji, value, length, ZMZAlgorithm.FEI_JI
            end
        end
    end
    return false, 0
end

function ZMZAlgorithm.erSanZhang_(sanZhangList)
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

function ZMZAlgorithm.sanSanZhang_(sanZhangList)
    local count = 1
    local index = 1
    for i,v in ipairs(sanZhangList) do
        if sanZhangList[i+1] then
            index = i
            local a = sanZhangList[i][1]  
            local b = sanZhangList[i+1][1]
            if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b)+1 then
                count = count + 1
            end
        end
    end
    if count >=2 then
        local value = BaseAlgorithm.getValue(sanZhangList[index][1])
        return true, value, count
    end
end

function ZMZAlgorithm.isSiDai_(cards,config)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 
    obj.suit = 0
    obj.length = 0
    dump(cards,"cardscardscardscardscardscardscards")
    local isSiDai, value, type = ZMZAlgorithm.checkIsSiDai_(cards,config)
    if isSiDai then
        obj.cardType = type
        obj.value = value 
    end
    dump(obj,"objobjobjobjobj")
    return obj
end

function ZMZAlgorithm.checkIsSiDai_(cards,config)
    if #cards ~= 6 and #cards ~= 8 then return false, 0 end 
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    local count4 = 0
    local count1 = 0
    local count2 = 0 
    local aimValue = 0
    for k,v in pairs(sameValueList) do
        if #v == 4 then
            count4 = count4 + 1
            aimValue = BaseAlgorithm.getValue(v[1])
        elseif #v == 1 then
            count1 = count1 + 1
        elseif #v == 2 then
            count2 = count2 + 1
        end
    end
    if count4 == 1 and count1 == 2 and count4*4 + count1 *1 == #cards then
        return true,aimValue,ZMZAlgorithm.SI_DAI_DAN
    elseif count4 == 1 and count2 == 2 and count4*4 + count2 *2 == #cards then
        return true,aimValue,ZMZAlgorithm.SI_DAI_DUI
    elseif count4*4 == #cards then
        return true,aimValue,ZMZAlgorithm.SI_DAI
    end
    return false, 0
end

function ZMZAlgorithm.isShunZi_(cards)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 
    obj.suit = 0
    obj.length = 0
    local isShunZi, value = ZMZAlgorithm.checkIsShunZi_(cards)
    if isShunZi then
        obj.cardType = ZMZAlgorithm.SHUN_ZI
        obj.value = value 
        obj.length = #cards
    end
    return obj
end

function ZMZAlgorithm.checkIsShunZi_(cards)
    if #cards < 5 then return false, 0 end
    table.sort(cards, ZMZAlgorithm.sortByValue_)
    for i=1,#cards do
        if cards[i+1] then
            if BaseAlgorithm.getValue(cards[i]) ~= BaseAlgorithm.getValue(cards[i+1]+1) then
                return false, 0
            end
        end
    end
    return true, BaseAlgorithm.getValue(cards[#cards])
end

function ZMZAlgorithm.isZhaDan_(cards, config)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 
    obj.suit = 0
    obj.length = 0
    local isZhaDan, value = ZMZAlgorithm.checkIsZhaDan_(cards, config)
    if isZhaDan then
        obj.cardType = ZMZAlgorithm.SI_ZHA
        obj.value = value 
    end
    return obj
end

function ZMZAlgorithm.checkIsZhaDan_(cards, config)
    local sameValueList = ZMZAlgorithm.getSameValueCards_(cards)
    for i,v in pairs(sameValueList) do
        if #v == 3 then
            if BaseAlgorithm.getValue(v[1]) == 14 then
                return true, 14
            end
        elseif #v == 4 then
            return true, BaseAlgorithm.getValue(cards[1])
        end
    end
    return false, 0
end

function ZMZAlgorithm.checkCardsHasShunZi_(cards, length, isChaiFen)
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
                    shunZiList = ZMZAlgorithm.chaifenShunzi_(list, length)
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
            shunZiList = ZMZAlgorithm.chaifenShunzi_(list, length)
        else
            shunZiList = {list}
        end
    elseif sIndex ~= 1 and shunZiCount == 0 and count >=length then
        local list = {}
        for i=sIndex+1,sIndex + count do
            list[#list+1] = tempCards[i]
        end
        if isChaiFen then
            shunZiList = ZMZAlgorithm.chaifenShunzi_(list, length)
        else
            shunZiList = {list}
        end
    end
    return shunZiList
end

function ZMZAlgorithm.chaifenShunzi_(cards, length)
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

function ZMZAlgorithm.checkHasLianDui_(result, duiZiList)
    -- if result.length > #duiZiList then return false end
    table.sort(duiZiList, ZMZAlgorithm.sortTableByValue_)
    local lianDuiList = {}
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then --表示新的一轮自己出牌
        for len = #duiZiList,2,-1 do
            for i=1,#duiZiList do
                local cards = {}
                for j=i,i+len-1 do
                    if duiZiList[j] then
                        cards[#cards+1] = duiZiList[j][1]
                        cards[#cards+1] = duiZiList[j][2]
                    end
                end
                local isLianDui, value, length = ZMZAlgorithm.checkIsLianDui_(cards)
                if isLianDui then
                    lianDuiList[#lianDuiList+1] = cards
                end
            end
        end
    else
        for i=1,#duiZiList do
            local cards = {}
            for j=i,i+result.length-1 do
                if duiZiList[j] then
                    cards[#cards+1] = duiZiList[j][1]
                    cards[#cards+1] = duiZiList[j][2]
                end
            end
            local isLianDui, value, length = ZMZAlgorithm.checkIsLianDui_(cards)
            if isLianDui then
                lianDuiList[#lianDuiList+1] = cards
            end
        end
    end
  
   
    return lianDuiList
end

function ZMZAlgorithm.checkHasFeiJiList_(cards)
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 3)
    table.sort(list, ZMZAlgorithm.sortTableByValue_)
    local cards = {}
    for i=1,#list do
        if list[i] then
            cards[#cards+1] = list[i][1]
            cards[#cards+1] = list[i][2]
            cards[#cards+1] = list[i][3]
        end
    end
    local feiJiList = ZMZAlgorithm.checkHasFeiJi_(cards)
    return feiJiList
end

function ZMZAlgorithm.checkHasSiZha_(cards, config)
    local list = ZMZAlgorithm.getCardListByCount_(cards, 4)
    local list3Poker = ZMZAlgorithm.getCardListByCount_(cards, 3)
    for i,v in ipairs(list3Poker) do
        if BaseAlgorithm.getValue(v[1]) == 14 then
            list[#list+1] = v
            break
        end
    end
    if config and config.threeABomb == 1 then
        
    end
    return list
end

function ZMZAlgorithm.checkZhaDanSameValue_(cards, list)
    for i,v in ipairs(list) do
        if ZMZAlgorithm.getSameValue_(cards, v) then
            return true
        end
    end
    return false
end

function ZMZAlgorithm.checkPaiXing(cards, config)
    local list = {}
    local list1 = ZMZAlgorithm.checkCardsHasLianDui_(clone(cards), config)
    local list2 = ZMZAlgorithm.fileterShunZi_(clone(cards), config)
    local list3 = ZMZAlgorithm.checkHasFeiJi_(clone(cards))
    local list4 = ZMZAlgorithm.checkHasSanDai_(clone(cards))
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

function ZMZAlgorithm.checkCardsHasLianDui_(cards, config)
    local list = ZMZAlgorithm.getCardListByCount_(clone(cards), 2)
    local lianDuiList = ZMZAlgorithm.fileterLianDui_(list, clone(cards),config)
    if #lianDuiList>0 then
        return lianDuiList
    end
    return {}
end

function ZMZAlgorithm.fileterShunZi_(cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
    local danGeList = ZMZAlgorithm.getDanGeCardsList_(clone(cards),config)
    local shunZiList = {}
    for k,v in pairs(danGeList) do
        local list = {}
        if #v >= 5 then
            list = ZMZAlgorithm.checkHasShunZi_(5, v, false)
        end
        for k,v in pairs(list) do
            if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
                return v
            else
                return list[1]
            end
        end
    end
    return shunZiList
end

function ZMZAlgorithm.fileterLianDui_(list, cards, config)
    local siZhaList = ZMZAlgorithm.checkHasSiZha_(clone(cards), config)
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
        if config and config.denySplitBomb == 0 and not ZMZAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
            return v
        else
            return lianDuiList[1]
        end
    end
    return {}
end

return ZMZAlgorithm 
