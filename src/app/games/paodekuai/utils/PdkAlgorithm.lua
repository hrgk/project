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

function PdkAlgorithm.sortOutPokers(cards,config)
    local result = PdkAlgorithm.getCardType(clone(cards),config)
    if result.cardType == PdkAlgorithm.SAN_DAI then
        local cards = PdkAlgorithm.sortSanDai(clone(cards), result)
        return cards
    elseif result.cardType == PdkAlgorithm.FEI_JI then
        local cards = PdkAlgorithm.sortFeiJi(clone(cards), result)
        return cards
    elseif result.cardType == PdkAlgorithm.SI_DAI then
        local cards = PdkAlgorithm.sortSiDai(clone(cards), result)
        return cards
    else
        return PdkAlgorithm.sort(cards)
    end
    return cards
end

function  PdkAlgorithm.sortSanDai(cards, result)
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

function  PdkAlgorithm.sortSiDai(cards, result)
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

function  PdkAlgorithm.sortFeiJi(cards, result)
    local length = result.length
    local value = result.value
    local list = {}
    for i = 1, length do
        list[i] = value - (i-1)
    end
    local list1 = {}
    local list2 = {0}
    table.sort(cards, PdkAlgorithm.sortBySmallValue_)
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

function PdkAlgorithm.getDanGeCardsList_(cards,config)
    local sameValueList = PdkAlgorithm.getSameValueCards_(cards)
    local danGeList = {}
    for i=1,4 do
        local cards = {}
        for k,v in pairs(sameValueList) do
            local siZhares = PdkAlgorithm.checkHasSiZha_(v, config)
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

--连对
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

function PdkAlgorithm.getDanZhangBiggerList_(result, cards, config)
    local dzList = PdkAlgorithm.getCardListByCount_(clone(cards), 1, true)
    local dzBiggers = {}
    for i,v in ipairs(dzList) do
        if BaseAlgorithm.getValue(v[1]) > result.value then
            dzBiggers[#dzBiggers+1] = v
        end
    end
    table.sort(dzBiggers, PdkAlgorithm.tiShiSortTableByValue_)
    return dzBiggers
end

function PdkAlgorithm.getDuiZiBiggerList_(result, cards, config, count)
    local duiZiList = PdkAlgorithm.getCardListByCount_(clone(cards), 2, true)
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
    table.sort(duiZiBiggers, PdkAlgorithm.tiShiSortTableByValue_)
    return duiZiBiggers
end

function PdkAlgorithm.getSanZhangBiggerList_(result, cards, config, count)
    local sanZhangList = PdkAlgorithm.getCardListByCount_(clone(cards), 3, true)
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
    table.sort(sanZhangBiggers, PdkAlgorithm.tiShiSortTableByValue_)
    return sanZhangBiggers
end


function PdkAlgorithm.getDanZhangList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config, count)
    local dzBiggers = PdkAlgorithm.getDanZhangBiggerList_(result, clone(cards), config, 1)
    local biggerList = {}
    for i,v in ipairs(dzBiggers) do
        biggerList[#biggerList+1] = v
    end
    if result.value ~= 0 or result.length ~= 0 or result.suit ~= 0 or result.cardType ~= 0 then 
        if #biggerList <= 1 then
            local duiZiBiggers = PdkAlgorithm.getDuiZiBiggerList_(result, clone(cards), config, 1)
            local sanZhangBiggers = PdkAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 1)
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

function PdkAlgorithm.getDuiZiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local duiZiBiggers = PdkAlgorithm.getDuiZiBiggerList_(result, clone(cards), config, 2)
    local biggerList = {}
    for i,v in ipairs(duiZiBiggers) do
        biggerList[#biggerList+1] = v
    end
    if result.value ~= 0 or result.length ~= 0 or result.suit ~= 0 or result.cardType ~= 0 then
        local sanZhangBiggers = PdkAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 2)
        for i,v in ipairs(sanZhangBiggers) do
            biggerList[#biggerList+1] = v
        end
    end
    return biggerList
end

function PdkAlgorithm.getLianDuiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local isOnly = false
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then
        isOnly = true
    end
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 2, isOnly)
    local threeList = PdkAlgorithm.getCardListByCount_(clone(cards), 3, false)
    local lianDuiList = PdkAlgorithm.checkHasLianDui_(result, list)
    local biggerList = {}
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then --表示新的一轮自己出牌
        for i,v in ipairs(lianDuiList) do
            biggerList[#biggerList+1] = v
        end
    else
        for i,v in ipairs(lianDuiList) do
            local obj = PdkAlgorithm.getCardType(v, config)
            if result and obj.length == result.length and obj.value > result.value then
                if config and config.denySplitBomb == 0 and not PdkAlgorithm.checkZhaDanSameValue_(v, siZhaList) then
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

function PdkAlgorithm.getSanDaiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local sanZhangBiggers = PdkAlgorithm.getSanZhangBiggerList_(result, clone(cards), config, 3)
    local biggerList = {}
    for i,v in ipairs(sanZhangBiggers) do
        biggerList[#biggerList+1] = v
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

function PdkAlgorithm.getSiDaiList_(result, cards, config)
    local list = PdkAlgorithm.getCardListByCount_(clone(cards), 4)
    local biggerList = {}
    for i,v in ipairs(list) do
        local obj = PdkAlgorithm.getCardType(v, config)
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

function PdkAlgorithm.getShunZiList_(result, cards, config)
    local siZhaList = PdkAlgorithm.checkHasSiZha_(clone(cards), config)
    local danGeList = PdkAlgorithm.getDanGeCardsList_(clone(cards),config)
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
                    list = PdkAlgorithm.checkHasShunZi_(i, v, true)
                    for k,v in pairs(list) do
                        local obj = PdkAlgorithm.getCardType(v, config)
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
                list = PdkAlgorithm.checkHasShunZi_(result.length, v, true)
            end
            for k,v in pairs(list) do
                local obj = PdkAlgorithm.getCardType(v, config)
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

function PdkAlgorithm.sortBySmallValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) < BaseAlgorithm.getValue(b)
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

function PdkAlgorithm.checkNeedHe3(result,handCards,config)
    if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
        if config.playerCount == 3 and display.getRunningScene().tableController_:getFinishRound() == 1 then
            if #handCards == config.cardCount and table.indexof(handCards, 403) then
                return 403
            end
        end
    end
    return nil
end

function PdkAlgorithm.tishi(cards, handCards, config,isBaoDan)
    local result = PdkAlgorithm.getCardType(cards, config)
    local biggerList = {}
    local cardList = {}
    local zhaDanList = {}
    local zhaDanValue = result.value
    local danInfo =  PdkAlgorithm.getDanZhangBiggerList_({cardType = 0,length = 0, suit = 0, value = 0},clone(handCards), config, 1)
    local zdInfo = PdkAlgorithm.checkHasSiZha_(clone(handCards), config)
    local szInfo = PdkAlgorithm.getCardListByCount_(clone(handCards), 3, true)
    local zdValues = {}
    for i = 1,#zdInfo do
        zdValues[i] = zdInfo[i][1]%100
    end
    local szValues = {}
    for i = 1,#szInfo do
        szValues[i] = szInfo[i][1]%100
    end
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
    local need3 = PdkAlgorithm.checkNeedHe3(result,handCards,config)
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
                local result = PdkAlgorithm.getCardType(v, config)
                if result.cardType == PdkAlgorithm.SI_ZHA and (config.siDaiEr == 1 or config.siDaiSan == 1)then
                    result.cardType = PdkAlgorithm.SI_DAI
                end
                local needNum = PdkAlgorithm.getNeedCardNum(result.cardType,result.length,config)
                if needNum > 0 then
                    local addCard = PdkAlgorithm.getCardByNum(needNum,danInfo,handCards,result,zdValues,szValues,need3)
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
        for i,v in ipairs(biggerList) do
            local result = PdkAlgorithm.getCardType(v, config)
            if result.cardType == PdkAlgorithm.SI_ZHA and (config.siDaiEr == 1 or config.siDaiSan == 1) then
                result.cardType = PdkAlgorithm.SI_DAI
            end
            local needNum = PdkAlgorithm.getNeedCardNum(result.cardType,result.length,config)
            if needNum > 0 then
                local addCard = PdkAlgorithm.getCardByNum(needNum,danInfo,handCards,result,zdValues,szValues,false)
                local vLen = #v
                for j = 1,#addCard do
                    v[vLen+j] = addCard[j]
                end
            end
        end
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
    biggerList = PdkAlgorithm.removeSome(biggerList)
    if need3 then
        local aimValue = {}
        for i,v in ipairs(biggerList) do
            if table.indexof(v, need3) then
                table.insert(aimValue,clone(v))
            end
        end
        biggerList = aimValue
    end
    return biggerList
end

function PdkAlgorithm.removeSome(other)
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

function PdkAlgorithm.getCardByNum(needNum,danInfo,handCards,cardInfo,zdValues,szValues,needValue)
    if cardInfo.cardType == PdkAlgorithm.FEI_JI then
        cardInfo.value = cardInfo.value - cardInfo.length + 1
    end
    local count = needNum
    local addCard = {}
    local compareCard = {}
    if needValue and needValue%100 ~= cardInfo.value%100 then
        if #danInfo == 0 or (#danInfo > 0 and danInfo[1][1] ~= needValue) then
            local cardValue = needValue%100 
            for i = 4,1,-1 do
                local aimValue = 100*i + cardValue
                if table.indexof(handCards, aimValue) then
                    table.insert(addCard,aimValue)
                    compareCard[1] = cardValue
                    if #addCard == needNum then
                        break
                    end
                end
            end
        end
    end
    needNum = needNum - #addCard 
    if needNum > 0 then
        local index = #addCard
        if needNum <= #danInfo then
            for i = 1,#danInfo do
                index = index + 1
                addCard[index] = danInfo[i][1]
                if i == needNum then
                    break
                end
            end
        else
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
            local num = #handCards - #szValues*3
            if num < needNum then   
                for i = #handCards,1,-1 do
                    if table.indexof(compareCard, handCards[i]%100) == false then
                        index = index + 1
                        addCard[index] = handCards[i]
                        if index == needNum then
                            break
                        end
                    end
                end
            else
                for i = #handCards,1,-1 do
                    if table.indexof(compareCard, handCards[i]%100) == false and table.indexof(szValues, handCards[i]%100) == false then
                        index = index + 1
                        addCard[index] = handCards[i]
                        if index == needNum then
                            break
                        end
                    end
                end
            end
          
        end
    end
    return addCard
end

function PdkAlgorithm.getNeedCardNum(type,lenth,config)
    local cellCount = config.tail3With1 == 1 and 1 or 2
    if type == PdkAlgorithm.SAN_DAI then
        return cellCount
    elseif type == PdkAlgorithm.FEI_JI then
        return cellCount*lenth
    elseif type == PdkAlgorithm.SI_DAI then
        if config.siDaiEr == 1 then
            return 2
        end
        if config.siDaiSan == 1 then
            return 3
        end
    end
    return 0
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
            if result.value == 0 and result.length == 0 and result.suit == 0 and result.cardType == 0 then 
                if i ~=  PdkAlgorithm.SI_ZHA then
                    if config.siDaiSan == 1 or config.siDaiEr == 1 then
                        local list = v(result, clone(handCards), config)
                        table.insertto(cardList, list)
                    elseif i ~= PdkAlgorithm.SI_DAI then
                        local list = v(result, clone(handCards), config)
                        table.insertto(cardList, list)
                    end
                end
            else
                local list = v(result, clone(handCards), config)
                table.insertto(cardList, list)
            end
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
    result = PdkAlgorithm.lengthBigerThenFive_(clone(cards),config)
    elseif #cards < 5 then
    result = PdkAlgorithm.lengthNotBiggerThenFive_(clone(cards), config)
    end
    return result
end

function PdkAlgorithm.lengthBigerThenFive_(cards,config)
    local result = PdkAlgorithm.isSiDai_(clone(cards),config)
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
    -- dump(sanZhangList)
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

function PdkAlgorithm.isSiDai_(cards,config)
    local obj = {}
    obj.cardType = 0
    obj.value = 0 --BaseAlgorithm.getValue(cards[1])
    obj.suit = 0
    obj.length = 0
    local isSiDai, value = PdkAlgorithm.checkIsSiDai_(cards,config)
    if isSiDai then
        obj.cardType = PdkAlgorithm.SI_DAI
        obj.value = value 
    end
    return obj
end

function PdkAlgorithm.checkIsSiDai_(cards,config)
    if config.siDaiEr == 1 then
        if #cards ~= 6 then return false, 0 end 
    end
    if config.siDaiSan == 1 then
        if #cards ~= 7 then return false, 0 end 
    end
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
            if #v == 3 then
                if config.cardCount == 16 and BaseAlgorithm.getValue(v[1]) == 14 then
                    return true, 14
                elseif config.cardCount == 15 and BaseAlgorithm.getValue(v[1]) == 13 then
                    return true, 13
                end
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
                local isLianDui, value, length = PdkAlgorithm.checkIsLianDui_(cards)
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
            local isLianDui, value, length = PdkAlgorithm.checkIsLianDui_(cards)
            if isLianDui then
                lianDuiList[#lianDuiList+1] = cards
            end
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
            if (config.cardCount == 16 and BaseAlgorithm.getValue(v[1]) == 14) or (config.cardCount == 15 and BaseAlgorithm.getValue(v[1]) == 13) then
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
    local danGeList = PdkAlgorithm.getDanGeCardsList_(clone(cards),config)
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
