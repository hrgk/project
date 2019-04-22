local BaseAlgorithm = import(".BaseAlgorithm")
local D13Algorithm = {}
D13Algorithm.SAN_PAI = 1
D13Algorithm.DUI_YI = 2
D13Algorithm.DUI_ER = 3
D13Algorithm.SAN_TIAO = 4
D13Algorithm.SHUN_ZI = 5
D13Algorithm.TONG_HUA = 6
D13Algorithm.HU_LU = 7
D13Algorithm.TIE_ZHI = 8
D13Algorithm.TONG_HUA_SHUN = 9

function D13Algorithm.sortByValue_(a,b)
    if BaseAlgorithm.getValue(a) == BaseAlgorithm.getValue(b) then
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    else
        return BaseAlgorithm.getValue(a) > BaseAlgorithm.getValue(b)
    end
end

function D13Algorithm.sortBySuit_(a,b)
    if BaseAlgorithm.getSuit(a) == BaseAlgorithm.getSuit(b) then
        return BaseAlgorithm.getValue(a) > BaseAlgorithm.getValue(b)
    else
        return BaseAlgorithm.getSuit(a) > BaseAlgorithm.getSuit(b)
    end
end

function D13Algorithm.getSortCards(cardsInfo,type)
    local cards = clone(cardsInfo)
    if type == 1 then
        table.sort(cards, D13Algorithm.sortByValue_)
    elseif type == 2 then
        table.sort(cards, D13Algorithm.sortBySuit_)
    end
    return cards
end

function D13Algorithm.cheackIsLaiZi(card)
    return BaseAlgorithm.getSuit(card) == 5
end

function D13Algorithm.getCardData(cardsInfo)
    local cards = clone(cardsInfo)
    table.sort(cards, D13Algorithm.sortByValue_)
    local resInfo = {{},{},{},{},{}}
    local kingInfo = {}
    for i = 1,#cards do
        local cardValue = cards[i]
        if cardValue > 0 then
            if D13Algorithm.cheackIsLaiZi(cardValue) then
                table.insert(kingInfo,cardValue)
            else
                local someCard = {}
                local someCardCount = 1
                someCard[someCardCount] = cards[i]
                for j = i + 1,#cards do
                    local findVale = cards[j]
                    if findVale > 0 and BaseAlgorithm.getValue(findVale) == BaseAlgorithm.getValue(cardValue) then
                        someCardCount = someCardCount + 1
                        someCard[someCardCount] = findVale
                        cards[j] = 0
                    else
                        break
                    end
                end
                table.insert(resInfo[someCardCount],someCard)
            end
        end
    end
    return resInfo,kingInfo
end

function D13Algorithm.getSome(cards,isSuit)
    local someInfo = {}
    local resInfo = {}
    for i,v in ipairs(cards) do
        local cardValue = BaseAlgorithm.getValue(v)
        if isSuit then
            cardValue = BaseAlgorithm.getSuit(v)
        else
            cardValue = BaseAlgorithm.getValue(v)
        end
        someInfo[cardValue] = someInfo[cardValue] or {}
        if #someInfo[cardValue] == 0 then 
            table.insert(resInfo,someInfo[cardValue])
        end 
        someInfo[cardValue][#someInfo[cardValue]+1] = v
    end
    return resInfo
end

function D13Algorithm.isSP(cards)
    local cmpInfo = {}
    cmpInfo[1] = cards[1]
    return true,cmpInfo
end

function D13Algorithm.isDZ(cards)
    local resInfo = D13Algorithm.getSome(cards)
    if #cards == 3 then
        if #resInfo == 2 and ((#resInfo[1] == 1 and #resInfo[2] == 2) or (#resInfo[1] == 2 and #resInfo[2] == 1)) then
            local cmpInfo = {}
            for i = 1,2 do
                if #resInfo[i] == 1 then
                    cmpInfo[2] = resInfo[i][1]
                elseif #resInfo[i] == 2 then
                    cmpInfo[1] = resInfo[i][1]
                end
            end
            return true,cmpInfo
        end
    elseif #cards == 5 then
        if #resInfo == 4 then
            local cmpInfo = {}
            local num2 = 0
            local num1 = 0
            for i = 1,4 do
                if #resInfo[i] == 2 then
                    num2 = num2 + 1
                    if not cmpInfo[1] then
                        cmpInfo[1] = resInfo[i][1]
                    end
                end
                if #resInfo[i] == 1 then
                    num1 = num1 + 1
                    if not cmpInfo[2] then
                        cmpInfo[2] = resInfo[i][1]
                    end
                end
            end
            if num2 == 1 and num1 == 3 then
                return true,cmpInfo
            end
        end
    end
    return false
end

function D13Algorithm.isLD(cards)
    if #cards ~= 5 then
        return false
    end
    local resInfo = D13Algorithm.getSome(cards)
    if #resInfo == 3 then
        local countBy2 = 0
        local countBy1 = 0
        local cmpInfo = {}
        for i = 1, 3 do
            if #resInfo[i] == 2 then
                countBy2 = countBy2 + 1
                cmpInfo[countBy2] = resInfo[i][1]
            elseif #resInfo[i] == 1 then 
                countBy1 = countBy1 + 1
                cmpInfo[3] = resInfo[i][1]
            end
        end
        if countBy2 == 2 and countBy1 == 1 then
            return true,cmpInfo
        end
    end
    return false
end

function D13Algorithm.isST(cards)
    local resInfo = D13Algorithm.getSome(cards)
    local cmpInfo = {}
    if #cards == 3 and #resInfo == 1 then
        cmpInfo[1] = resInfo[1][1]
        return true,cmpInfo
    end
    if #cards == 5 and #resInfo == 3 then
        local countBy3 = 0
        local countBy1 = 0
        for i = 1,3 do
            if #resInfo[i] == 3 then
                countBy3 = countBy3 + 1
                cmpInfo[countBy3] = resInfo[i][1]
            elseif #resInfo[i] == 1 then  
                countBy1 = countBy1 + 1
                cmpInfo[countBy1+1] = resInfo[i][1]
            end
        end
        if countBy3 == 1 and countBy1 == 2 then
            return true,cmpInfo
        end
    end
    return false
end

function D13Algorithm.isSZ(cards)
    if #cards ~= 5 then
        return false
    end
    for i = 1,4 do
        local cardValue = BaseAlgorithm.getValue(cards[i])
        local cmpCardValue = BaseAlgorithm.getValue(cards[i+1])
        if i == 1 and cardValue == 14 and (cmpCardValue == 13 or cmpCardValue == 5) then
        else
            if math.abs(cardValue - cmpCardValue) ~= 1 then
                return false
            end
        end
    end
    local cmpInfo = clone(cards)
    local aimHS = BaseAlgorithm.getSuit(cards[1])
    cmpInfo[6] = BaseAlgorithm.makeCard(1, aimHS)
    return true,cmpInfo
end

function D13Algorithm.isTH(cards)
    if #cards ~= 5 then
        return false
    end
    local aimHS = BaseAlgorithm.getSuit(cards[1])
    for i = 2,5 do
        if aimHS ~= BaseAlgorithm.getSuit(cards[i]) then
            return false
        end
    end
    local cmpInfo = clone(cards)
    cmpInfo[6] = BaseAlgorithm.makeCard(1, aimHS)
    return true,cmpInfo
end

function D13Algorithm.isHL(cards)
    if #cards ~= 5 then
        return false
    end
    local cmpInfo = {}
    local resInfo = D13Algorithm.getSome(cards)
    if #resInfo == 2 and ((#resInfo[1] == 3 and #resInfo[2] == 2) or (#resInfo[1] == 2 and #resInfo[2] == 3)) then
        for i = 1,2 do
            if #resInfo[i] == 2 then
                cmpInfo[2] = resInfo[i][1]
            elseif #resInfo[i] == 3 then
                cmpInfo[1] = resInfo[i][1]
            end
        end
        return true,cmpInfo
    end
    return false
end

function D13Algorithm.isTZ(cards)
    if #cards ~= 5 then
        return false
    end
    local cmpInfo = {}
    local resInfo = D13Algorithm.getSome(cards)
    if #resInfo == 2 and ((#resInfo[1] == 4 and #resInfo[2] == 1) or (#resInfo[1] == 1 and #resInfo[2] == 4)) then
        for i = 1,2 do
            if #resInfo[i] == 1 then
                cmpInfo[2] = resInfo[i][1]
            elseif #resInfo[i] == 4 then
                cmpInfo[1] = resInfo[i][1]
            end
        end
        return true,cmpInfo
    end
    return false
end

function D13Algorithm.isTHS(cards)
    if #cards ~= 5 then
        return false
    end
    local aimHS = BaseAlgorithm.getSuit(cards[5])
    for i = 1,4 do
        local cardValue = BaseAlgorithm.getValue(cards[i])
        local cmpCardValue = BaseAlgorithm.getValue(cards[i+1])
        if i == 1 and cardValue == 14 and (cmpCardValue == 13 or cmpCardValue == 5) then
            if aimHS ~= BaseAlgorithm.getSuit(cards[i]) then
                return false
            end
        else
            if math.abs(cardValue - cmpCardValue) ~= 1 or aimHS ~= BaseAlgorithm.getSuit(cards[i]) then
                return false
            end
        end
    end

    local cmpInfo = clone(cards)
    cmpInfo[6] = BaseAlgorithm.makeCard(1, aimHS)
    return true,cmpInfo
end

function D13Algorithm.getCardType(cardsInfo)
    local cardTypeTable = {}
    cardTypeTable[D13Algorithm.SAN_PAI] = D13Algorithm.isSP
    cardTypeTable[D13Algorithm.DUI_YI] = D13Algorithm.isDZ
    cardTypeTable[D13Algorithm.DUI_ER] = D13Algorithm.isLD
    cardTypeTable[D13Algorithm.SAN_TIAO] = D13Algorithm.isST
    cardTypeTable[D13Algorithm.SHUN_ZI] = D13Algorithm.isSZ
    cardTypeTable[D13Algorithm.TONG_HUA] = D13Algorithm.isTH
    cardTypeTable[D13Algorithm.HU_LU] = D13Algorithm.isHL
    cardTypeTable[D13Algorithm.TIE_ZHI] = D13Algorithm.isTZ
    cardTypeTable[D13Algorithm.TONG_HUA_SHUN] = D13Algorithm.isTHS

    local getTypeInfo = {}
    getTypeInfo[3] = {D13Algorithm.SAN_TIAO,D13Algorithm.DUI_YI,D13Algorithm.SAN_PAI}
    getTypeInfo[5] = {
        D13Algorithm.TONG_HUA_SHUN,
        D13Algorithm.TIE_ZHI,
        D13Algorithm.HU_LU,
        D13Algorithm.TONG_HUA,
        D13Algorithm.SHUN_ZI,
        D13Algorithm.SAN_TIAO,
        D13Algorithm.DUI_ER, 
        D13Algorithm.DUI_YI,
        D13Algorithm.SAN_PAI
    }
   
    local cards = clone(cardsInfo)
    --dump(cards,"cardsInfocardsInfo")
    table.sort(cards, D13Algorithm.sortByValue_)
    --dump(cards,"cardcardcard")
    local aimGetType = getTypeInfo[#cards]
    --dump(aimGetType,"aimGetType")

    for i = 1,#aimGetType do
        --print("XX",i,aimGetType[i],type(cardTypeTable[aimGetType[i]]))
        local res,cmp = cardTypeTable[aimGetType[i]](clone(cards))
        if res then
            return aimGetType[i],cmp
        end
    end
end

function D13Algorithm.cmpType(type1,type2,cmp1,cmp2)
    if type1 == type2 then
        local len = #cmp1 > #cmp2 and #cmp1 or #cmp2
        for i = 1,len do
            local c1 = BaseAlgorithm.getValue(cmp1[i])
            local c2 = BaseAlgorithm.getValue(cmp2[i])
            if c1 ~= c2 then
                return c1 > c2
            end
        end
        return false
    else
        return type1>type2
    end
end

function D13Algorithm.cheackDaoShui(card1,card2)
    local type1,cmp1 = D13Algorithm.getCardType(card1)
    local type2,cmp2 = D13Algorithm.getCardType(card2)
    if D13Algorithm.cmpType(type1,type2,cmp1,cmp2) then
        return true
    end
    return false
end

function D13Algorithm.isDaoShui(card1,card2,card3)
    local type1,cmp1 = D13Algorithm.getCardType(card1)
    local type2,cmp2 = D13Algorithm.getCardType(card2)
    local type3,cmp3 = D13Algorithm.getCardType(card3)
    if D13Algorithm.cmpType(type1,type2,cmp1,cmp2) then
        return true
    end
    if D13Algorithm.cmpType(type2,type3,cmp2,cmp3) then
        return true
    end
    return false
end

function D13Algorithm.getCardNumInfo(cards)
    local cardInfo = {}
    local info = D13Algorithm.getSome(cards)
    for i = 1,#info do
        local num = #info[i] 
        cardInfo[num] = cardInfo[num] or {}
        table.insert(cardInfo[num],info[i])
    end
    return cardInfo
end

function D13Algorithm.getTypeCard(cardsInfo)
    local cards = clone(cardsInfo)
end

function D13Algorithm.getSomeSuit(cards)
    local resInfo = D13Algorithm.getSome(cards,true)
    local function cmp(a,b) 
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    end
    table.sort(resInfo,cmp)
    return resInfo
end

function D13Algorithm.getMTHS(cards)--获取最大的同花顺
    local someSuitRes = D13Algorithm.getSomeSuit(cards)
    local reuslt = {}
    for _,v in ipairs(someSuitRes) do
        local len = #v
        if len >= 5 then
            for i = 1,len do
                local temp = {}
                temp[1] = v[i]
                for j = i+1,len do
                    if (#temp == 1 and BaseAlgorithm.getValue(temp[#temp]) == 14 and BaseAlgorithm.getValue(v[j]) == 5) or
                        temp[#temp] - v[j]  == 1 then
                        table.insert(temp,v[j])
                        if #temp == 5 then
                            table.insert(reuslt,clone(temp))
                            break
                        end
                    end
                end
            end
        end
    end
    local function cmp(a,b)
        for i = 1,5 do
            if BaseAlgorithm.getValue(a[i]) > BaseAlgorithm.getValue(b[i]) then
                return true
            end
            if BaseAlgorithm.getValue(a[i]) < BaseAlgorithm.getValue(b[i]) then
                return false
            end
        end
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    end
    table.sort(reuslt,cmp)
    if #reuslt > 0 then
        return true,reuslt[1]
    end
    return false
end

function D13Algorithm.getMZZ(cards)--获取最大的折枝
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local result =D13Algorithm.getSomeDataMax(cardInfo,4)
    if #result == 4 then
        D13Algorithm.removeByTable(cards,result)
        cardInfo = D13Algorithm.getCardNumInfo(cards)
        local info = D13Algorithm.getSomeDataMin(cardInfo,1)
        if #info == 1 then
            table.insert(result,info[1])
            return true,result
        end
    end
    return false
end

function D13Algorithm.getSomeDataMin(cardInfo,someNum,noCards)
    local aimCard = {}
    local noCards = noCards or {}
    local minCard = 9999
    for i = 1,5 do
        if cardInfo[i] and someNum <= i then
            local j = #cardInfo[i]
            for j = 1,#cardInfo[i] do
                local nowValue = BaseAlgorithm.getValue(cardInfo[i][j][1])
                if table.indexof(noCards,nowValue) == false and minCard > nowValue then
                    aimCard = {}
                    for k = 1, someNum do
                        aimCard[k] = cardInfo[i][j][k]
                    end
                    minCard = nowValue
                end
            end
        end 
    end
    return aimCard
end

function D13Algorithm.getSomeDataMinAnlyNum(cardInfo,someNum,noCards)
    local aimCard = {}
    local noCards = noCards or {}
    local minCard = 9999
    for i = 1,5 do
        if cardInfo[i] and someNum == i then
            local j = #cardInfo[i]
            for j = 1,#cardInfo[i] do
                local nowValue = BaseAlgorithm.getValue(cardInfo[i][j][1])
                if table.indexof(noCards,nowValue) == false and minCard > nowValue then
                    aimCard = {}
                    for k = 1, someNum do
                        aimCard[k] = cardInfo[i][j][k]
                    end
                    minCard = nowValue
                end
            end
        end 
    end
    return aimCard
end

function D13Algorithm.getSomeDataMinSplit(cardInfo,someNum)
    local aimCard = {}
    local minCard = 9999
    for i = 5,someNum,-1 do
        if cardInfo[i] then
            local j = #cardInfo[i]
            local nowValue = BaseAlgorithm.getValue(cardInfo[i][j][1])
            if nowValue < minCard then
                for k = 1, someNum do
                    aimCard[k] = cardInfo[i][j][k]
                end
                minCard = nowValue
            end
        end 
    end
    return aimCard
end

function D13Algorithm.getSomeDataMax(cardInfo,someNum)
    local aimCard = {}
    local maxCard = 0
    for i = 5,someNum,-1 do
        if cardInfo[i] then
            local j = 1
            local nowValue = BaseAlgorithm.getValue(cardInfo[i][j][1])
            -- print("nowValue",nowValue,maxCard)
            if nowValue > maxCard then
                for k = 1, someNum do
                    aimCard[k] = cardInfo[i][j][k]
                end
                -- dump(aimCard,"aimCardaimCardaimCard")
                maxCard = nowValue
            end
        end 
    end
    return aimCard
end

function D13Algorithm.doGetMHL(cards)
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local result = D13Algorithm.getSomeDataMax(cardInfo,3)
    if #result == 3 then
        D13Algorithm.removeByTable(cards,result)
        cardInfo = D13Algorithm.getCardNumInfo(cards)
        local info = D13Algorithm.getSomeDataMinAnlyNum(cardInfo,2)
        if #info == 2 then
            for i = 1,2 do
                table.insert(result,info[i])
            end
            return true,result
        end
        info = D13Algorithm.getSomeDataMin(cardInfo,2)
        if #info == 2 then
            for i = 1,2 do
                table.insert(result,info[i])
            end
            return true,result
        end
    end
    return false
end

function D13Algorithm.getMHL(cards,index,csNum)--获取最大的葫芦
    if index == 2 and csNum == 2 then
        return false
    end
    local someSuitRes = D13Algorithm.getSomeSuit(cards)
    local suitInfo = {}
    local index = 1
    for i = 1,#someSuitRes do
        if #someSuitRes[i] >= 5 then
            suitInfo[index] = clone(someSuitRes[i])
            index = index + 1
        end
    end
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local getInfo = {}
    for i = 1, #suitInfo do
        local result = D13Algorithm.getCnm(suitInfo[i],5)
        for i = 1,#result do
            local tempCard = clone(cards)
            D13Algorithm.removeByTable(tempCard,result[i])
            local res,cardInfo = D13Algorithm.doGetMHL(tempCard) 
            if res then
                table.insert(getInfo,clone(cardInfo))
            end
        end
    end
    local function cmp(a,b)
        return D13Algorithm.cheackDaoShui(a,b)
    end
    if #getInfo > 0 then
        table.sort(getInfo,cmp)
        return true,getInfo[1]
    end
    return D13Algorithm.doGetMHL(cards) 
end

function D13Algorithm.cheakHave(cardInfo,cardValue)
    for i = 2,4 do
        if cardInfo[i] then
            for j = 1, #cardInfo[i] do
                if table.indexof(cardInfo[i][j],cardValue) then
                    return true
                end
            end
        end
    end
    return false
end

function D13Algorithm.getMTH(cards)--获取最大的同花

    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    dump(cardInfo,"cardInfo")
    local reuslt = {}
    local someSuitRes = D13Algorithm.getSomeSuit(cards)
    dump(someSuitRes,"someSuitRes")
    for _,v in ipairs(someSuitRes) do
        local len = #v
        if len == 5 then
            local temp = {}
            for i = 1,5 do
                table.insert(temp,v[i])
            end
            table.insert(reuslt,clone(temp))
        elseif len > 5 then
            local temp = {}
            local haveInfo = {}
            for i = 1,len do
                if not D13Algorithm.cheakHave(cardInfo,v[i]) then
                    table.insert(temp,v[i])
                else
                    table.insert(haveInfo,1,v[i])  
                end
                if #temp == 5 then
                    break
                end
            end
            if #temp == 5 then
                table.insert(reuslt,clone(temp))
            else
                local idx = 0
                for i = #temp+1, 5 do
                    idx = idx + 1
                    table.insert(temp,haveInfo[idx])
                end
                if #temp == 5 then
                    table.insert(reuslt,clone(temp))
                end
            end
        end
    end
    local function cmp(a,b)
        for i = 1,5 do
            if BaseAlgorithm.getValue(a[i]) > BaseAlgorithm.getValue(b[i]) then
                return true
            end
            if BaseAlgorithm.getValue(a[i]) < BaseAlgorithm.getValue(b[i]) then
                return false
            end
        end
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    end
    table.sort(reuslt,cmp)
    if #reuslt > 0 then
        return true,reuslt[1]
    end
    return false
end

function D13Algorithm.getMSZNoSplit(cards)--获取最大的顺子不拆掉相同牌的
    local len = #cards
    if len >= 5 then
        for i = 1,len do
            local temp = {}
            temp[1] = cards[i]
            for j = i+1,len do
                if (#temp == 1 and BaseAlgorithm.getValue(temp[#temp]) == 14 and BaseAlgorithm.getValue(cards[j]) == 5) or
                    BaseAlgorithm.getValue(temp[#temp]) - BaseAlgorithm.getValue(cards[j]) == 1 and 
                    BaseAlgorithm.getValue(cards[j]) ~= BaseAlgorithm.getValue(cards[j-1]) and BaseAlgorithm.getValue(cards[j]) ~= BaseAlgorithm.getValue(cards[j+1]) then
                    table.insert(temp,cards[j])
                    if #temp == 5 then
                        return true,temp
                    end
                elseif BaseAlgorithm.getValue(temp[#temp]) - BaseAlgorithm.getValue(cards[j]) == 0 then
                    
                else
                    local tempValue = temp[1]
                    temp = {}
                    temp[1] = tempValue
                end
            end
        end
    end
    return false
end

function D13Algorithm.getMSZSplit(cards)--获取最大的顺子拆掉相同牌的
    local len = #cards
    table.sort(cards,D13Algorithm.sortByValue_)
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    if len >= 5 then
        for i = 1,len do
            local temp = {}
            temp[1] = cards[i]
           
            for j = i+1,len do
                if (#temp == 1 and BaseAlgorithm.getValue(temp[#temp]) == 14 and BaseAlgorithm.getValue(cards[j]) == 5) or
                    BaseAlgorithm.getValue(temp[#temp]) - BaseAlgorithm.getValue(cards[j]) == 1 then
                    table.insert(temp,cards[j])
                    if #temp == 5 then
                        return true,temp
                    end
                elseif BaseAlgorithm.getValue(temp[#temp]) - BaseAlgorithm.getValue(cards[j]) == 0 then

                else
                    local tempValue = temp[1]
                    temp = {}
                    temp[1] = tempValue
                end
            end
        end
    end
    return false
end

function D13Algorithm.getMSZ(cards,index,csNum)--获取最大的顺子 
    if csNum == 2 then
        return D13Algorithm.getMSZNoSplit(cards)
    else
        return D13Algorithm.getMSZSplit(cards)
    end
end

function D13Algorithm.getMST(cards)--获取最大的三条
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local result =D13Algorithm.getSomeDataMax(cardInfo,3)
    if #result == 3 then
        D13Algorithm.removeByTable(cards,result)
        local tempCards = clone(cards)
        for i = 1,2 do
            cardInfo = D13Algorithm.getCardNumInfo(tempCards)
            local info = D13Algorithm.getSomeDataMinAnlyNum(cardInfo,1)
            if #info == 1 then
                table.insert(result,info[1])
                D13Algorithm.removeByTable(tempCards,info)
            end
        end
        if #result == 5 then
            return true,result
        end
        tempCards = clone(cards)
        for i = 1,2 do
            cardInfo = D13Algorithm.getCardNumInfo(tempCards)
            local info = D13Algorithm.getSomeDataMin(cardInfo,1)
            if #info == 1 then
                table.insert(result,info[1])
                D13Algorithm.removeByTable(tempCards,info)
            end
        end
        if #result == 5 then
            return true,result
        end
    end
    return false
end

function D13Algorithm.getD2(cards,index,csNum)
    if csNum == 3 and index ~= 3 then
        return false
    end
    if csNum == 2 and index ~= 3 then
        return false
    end
    if index == 3 or index == 2 then
        print("indexindex",index)
        dump(cards,"cardscardscardscardscards")
        return D13Algorithm.getMinD2(cards,index,csNum)
    end
    return false
end

function D13Algorithm.getMD2(cards)--获取最大的两对
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local card2Num = D13Algorithm.getSomeDataMax(cardInfo,2)
    local temp = {}
    if #card2Num == 2 then
        table.insertto(temp, table.values(card2Num), #temp+1)
        D13Algorithm.removeByTable(cards,temp)
        cardInfo = D13Algorithm.getCardNumInfo(cards)
        card2Num = D13Algorithm.getSomeDataMax(cardInfo,2)
        if #card2Num == 2 then
            table.insertto(temp, table.values(card2Num), #temp+1)
            D13Algorithm.removeByTable(cards,temp)
            cardInfo = D13Algorithm.getCardNumInfo(cards)
            local info = D13Algorithm.getSomeDataMin(cardInfo,1)
            if #info == 1 then
                table.insert(temp,info[1])
                return true,temp
            end
        end
    end
    return false
end

function D13Algorithm.getMinD2(cards,index,csNum)--获取最小的两对
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    if index == 3 then
        if cardInfo[2] and #cardInfo[2] == 5 then
            D13Algorithm.removeByTable(cards,cardInfo[2][1])
        end
        dump(cardInfo[2],"cardInfo[2]")
        if cardInfo[2] and #cardInfo[2] == 4 then
            D13Algorithm.removeByTable(cards,cardInfo[2][1])
            dump(cards,":cardscardscardscardscards")
            D13Algorithm.removeByTable(cards,cardInfo[2][2])
            dump(cards,":cardscardscardscardscards")
        end
    end
    if index == 2 then
        if cardInfo[2] and #cardInfo[2] == 3 then
            D13Algorithm.removeByTable(cards,cardInfo[2][1])
        end
    end
    cardInfo = D13Algorithm.getCardNumInfo(cards)
    dump(cardInfo,"cardInfocardInfocardInfo")
    local card2Num = nil
    if csNum == 3 then
        card2Num = D13Algorithm.getSomeDataMinSplit(cardInfo,2)
    else
        if index == 3 then
            card2Num = D13Algorithm.getSomeDataMax(cardInfo,2)
        else
            card2Num = D13Algorithm.getSomeDataMinSplit(cardInfo,2)
        end
    end
    local temp = {}
    if #card2Num == 2 then
        table.insertto(temp, table.values(card2Num), #temp+1)
        D13Algorithm.removeByTable(cards,temp)
        cardInfo = D13Algorithm.getCardNumInfo(cards)
        card2Num = D13Algorithm.getSomeDataMinSplit(cardInfo,2)
        if #card2Num == 2 then
            table.insertto(temp, table.values(card2Num), #temp+1)
            D13Algorithm.removeByTable(cards,temp)
            cardInfo = D13Algorithm.getCardNumInfo(cards)
            table.sort(temp, D13Algorithm.sortByValue_)
            local info = D13Algorithm.getSomeDataMinAnlyNum(cardInfo,1)
            if #info == 1 then
                table.insert(temp,info[1])
                return true,temp
            end
            info = D13Algorithm.getSomeDataMin(cardInfo,1)
            if #info == 1 then
                table.insert(temp,info[1])
                return true,temp
            end
        end
    end
    return false
end

function D13Algorithm.copyData(cards,num,needCout)
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local temp = {}
    if cardInfo[num] and #cardInfo[num] >= needCout then
        for i = 1,needCout do
            for j = 1,num do
                table.insert(temp,cardInfo[num][i][j])
            end
        end
        D13Algorithm.removeByTable(cards,temp)
        for i = 1,#cards do
            table.insert(temp,cards[i])
            if #temp == 5 then
                return true,temp
            end
        end
    end
    return false
end

function D13Algorithm.getMDY(cards,index,csNum)--获取最大的对1
    local cardInfo = D13Algorithm.getCardNumInfo(cards)
    local result =D13Algorithm.getSomeDataMax(cardInfo,2)
    if #result == 2 then
        D13Algorithm.removeByTable(cards,result)
        local someCard = {}
        table.insert(someCard,BaseAlgorithm.getValue(result[1]))
        local temp = clone(cards)
        for i = 1,3 do
            cardInfo = D13Algorithm.getCardNumInfo(cards)
            local info = nil
            info = D13Algorithm.getSomeDataMinAnlyNum(cardInfo,1,someCard)
            if #info == 1 then
                table.insert(result,info[1])
                table.insert(someCard,BaseAlgorithm.getValue(info[1]))
                D13Algorithm.removeByTable(cards,info)
            end
        end
        if #result == 5 then
            return true,result
        end
        for i = 3,#result do
            result[i] = nil
        end
        local cards = clone(temp)
        for i = 1,3 do
            cardInfo = D13Algorithm.getCardNumInfo(cards)
            local info = nil
            info = D13Algorithm.getSomeDataMin(cardInfo,1,someCard)
            if #info == 1 then
                table.insert(result,info[1])
                table.insert(someCard,BaseAlgorithm.getValue(info[1]))
                D13Algorithm.removeByTable(cards,info)
            end
        end
        if #result == 5 then
            return true,result
        end
    end
    return false
end

function D13Algorithm.getMSDP(cards)--获取最大的单牌
    local temp = {}
    for i = 1, 5 do
        temp[i] = cards[i]
    end
    return true,temp
end

function D13Algorithm.addByTable(oriTable,addTable,sortType)
    for i = 1,#addTable do
        table.insert(oriTable, addTable[i])
    end
    return D13Algorithm.getSortCards(oriTable,sortType)
end

function D13Algorithm.removeByTable(oriTable,removeTable)
    for i = 1,#removeTable do
        table.removebyvalue(oriTable, removeTable[i])
    end
    table.sort(oriTable, D13Algorithm.sortByValue_)
end

function D13Algorithm.getDaoInfo(aimLevel,cards,index,needChangeIndex)
    print("aimLevel",aimLevel)
    local getTCardsTable = {}
    getTCardsTable[D13Algorithm.SAN_PAI] = D13Algorithm.getMSDP
    getTCardsTable[D13Algorithm.DUI_YI] = D13Algorithm.getMDY
    getTCardsTable[D13Algorithm.DUI_ER] = D13Algorithm.getD2
    getTCardsTable[D13Algorithm.SAN_TIAO] = D13Algorithm.getMST
    getTCardsTable[D13Algorithm.SHUN_ZI] = D13Algorithm.getMSZ
    getTCardsTable[D13Algorithm.TONG_HUA] = D13Algorithm.getMTH
    getTCardsTable[D13Algorithm.HU_LU] = D13Algorithm.getMHL
    getTCardsTable[D13Algorithm.TIE_ZHI] = D13Algorithm.getMZZ
    getTCardsTable[D13Algorithm.TONG_HUA_SHUN] = D13Algorithm.getMTHS
    local resInfo = {{},{},{}}
    for i = 3,2,-1 do
        for j = aimLevel,1,-1 do
            local needIndex = index
            if needChangeIndex and type(needChangeIndex) == "table" then
                if table.indexof(needChangeIndex,j) == false then
                    needIndex = 1
                end
            end
            local res,card = getTCardsTable[j](clone(cards),i,needIndex)
            if res then
                resInfo[i].card = clone(card)
                resInfo[i].type = j
                D13Algorithm.removeByTable(cards,card)
                break
            end
        end
    end

    local restInfo = D13Algorithm.getSome(cards)
    if restInfo[1] and #restInfo[1] == 2 then
        cards = {restInfo[1][1],restInfo[1][2],restInfo[2][1]}
    elseif restInfo[2] and #restInfo[2] == 2 then
        cards = {restInfo[2][1],restInfo[2][2],restInfo[1][1]}
    end
    resInfo[1].card = cards
    resInfo[1].type = D13Algorithm.getCardType(cards)

    return resInfo
end

function D13Algorithm.findTSRes(reuslt,tSRes)
    local daoSome1 = true
    for i = 1,3 do
        if reuslt[1].card[i] ~= tSRes[1].card[i] then
            daoSome1 = false
            break
        end
    end
    local daoSome2 = true
    for i = 1,5 do
        if reuslt[2].card[i] ~= tSRes[2].card[i] then
            daoSome2 = false
            break
        end
        if reuslt[3].card[i] ~= tSRes[3].card[i] then
            daoSome2 = false
            break
        end
    end
    local daoSome3 = true
    for i = 1,5 do
        if reuslt[2].card[i] ~= tSRes[3].card[i] then
            daoSome3 = false
            break
        end
        if reuslt[3].card[i] ~= tSRes[2].card[i] then
            daoSome3 = false
            break
        end
    end
    if daoSome1 and daoSome2 or daoSome1 and daoSome3 then
        return true
    end
    return false
end

function D13Algorithm.cheackAdd(reuslt,tSRes,origResult)
    local isAdd = true
    for j = 3,1,-1 do
        if D13Algorithm.getCardType(reuslt[j].card) ~= reuslt[j].type or (tSRes and D13Algorithm.findTSRes(reuslt,tSRes)) then
            isAdd = false
        end
    end
    if D13Algorithm.isDaoShui(reuslt[1].card,reuslt[2].card,reuslt[3].card) then
        if reuslt[2].type == 3 and reuslt[3].type == 3 then
            reuslt[2],reuslt[3] = reuslt[3],reuslt[2]
            if D13Algorithm.isDaoShui(reuslt[1].card,reuslt[2].card,reuslt[3].card) then
                isAdd = false
            end
        else
            isAdd = false
        end
    end
    if origResult and isAdd then
        local isSome = true
        for i = 1, 5 do
            if reuslt[3].card[i] ~= origResult[3].card[i] then
                isSome = false
            end
            if reuslt[2].card[i] ~= origResult[2].card[i] then
                isSome = false
            end
            if i <= 3 then
                if reuslt[1].card[i] ~= origResult[1].card[i] then
                    isSome = false
                end
            end
        end
        if isSome then
            isAdd = false
        end
    end 
    return isAdd
end

function D13Algorithm.autoCard(cardsInfo,tsType,count)
    if #cardsInfo ~= 13 then
        return {}
    end
    count = count or 4
    local cards = clone(cardsInfo)
    table.sort(cards, D13Algorithm.sortByValue_)
    local aimLevel = D13Algorithm.TONG_HUA_SHUN
    local autoRes = {}
    local tSRes = D13Algorithm.getTSCard(tsType,cardsInfo)
    for i = 1,count do
        if aimLevel == 1 and #autoRes > 0 then
            break
        end
        local reuslt = D13Algorithm.getDaoInfo(aimLevel,clone(cards),1)
        local isAdd = D13Algorithm.cheackAdd(reuslt,tSRes)
        if isAdd then
            local idnex = #autoRes + 1
            autoRes[idnex] = reuslt
            if reuslt[2].type == D13Algorithm.DUI_ER and reuslt[1].type == D13Algorithm.SAN_PAI then
                local needChangeIndex = {D13Algorithm.DUI_ER}
                local subReuslt = D13Algorithm.getDaoInfo(aimLevel,clone(cards),2,needChangeIndex)
                local subIsAdd = D13Algorithm.cheackAdd(subReuslt,tSRes,reuslt)
                if subIsAdd then
                    if reuslt[2].type == D13Algorithm.DUI_ER and 
                        reuslt[1].type == D13Algorithm.SAN_PAI and reuslt[3].type == D13Algorithm.DUI_ER then
                        autoRes[idnex] = clone(subReuslt)
                    else
                        autoRes[idnex].subReuslt = clone(subReuslt)
                    end
                end
                if subReuslt[2].type == D13Algorithm.DUI_YI and subReuslt[3].type == D13Algorithm.DUI_ER 
                    and subReuslt[1].type == D13Algorithm.DUI_YI then
                    local needChangeIndex = {D13Algorithm.DUI_ER}
                    local subReuslt2 = D13Algorithm.getDaoInfo(aimLevel,clone(cards),3,needChangeIndex)
                    local subIsAdd = D13Algorithm.cheackAdd(subReuslt,tSRes,reuslt)
                    local subIsAdd2 = D13Algorithm.cheackAdd(subReuslt,tSRes,subReuslt)
                    if subIsAdd and subIsAdd2 then
                        local idnex = #autoRes + 1
                        autoRes[idnex] = subReuslt2
                    end
                end
            end
            if (reuslt[3].type == D13Algorithm.HU_LU and reuslt[2].type == D13Algorithm.HU_LU and reuslt[1].type == D13Algorithm.SAN_PAI) 
                or (reuslt[3].type == D13Algorithm.SHUN_ZI) 
                then
                local needChangeIndex = nil
                if reuslt[3].type == D13Algorithm.SHUN_ZI then
                    needChangeIndex = {D13Algorithm.SHUN_ZI}
                end
                local subReuslt = D13Algorithm.getDaoInfo(aimLevel,clone(cards),2,needChangeIndex)
                local subIsAdd = D13Algorithm.cheackAdd(subReuslt,tSRes,reuslt)
                if reuslt[3].type == D13Algorithm.SHUN_ZI then
                    if subIsAdd and subReuslt[3].type == D13Algorithm.SHUN_ZI then
                        local idnex = #autoRes + 1
                        autoRes[idnex] = subReuslt
                    end
                else
                    if subIsAdd then
                        local idnex = #autoRes + 1
                        autoRes[idnex] = subReuslt
                    end
                end
            end
        end
        aimLevel = reuslt[3].type - 1
        if aimLevel < 1 then
            aimLevel = 1
        end
    end
    table.sort(autoRes, D13Algorithm.sortAutoRes)
    local realResult = {}
    if tSRes then
        table.insert(realResult,tSRes)
    end
    for i = 1,#autoRes do
        if autoRes[i].subReuslt then
            if #realResult + 2 <= 6 then
                local temp = clone(autoRes[i].subReuslt)
                autoRes[i].subReuslt = nil
                table.insert(realResult,autoRes[i])
                table.insert(realResult,temp)
            end
        else
            if #realResult + 1 <= 6 then
                table.insert(realResult,autoRes[i])
            end
        end
    end
    return realResult
end

function D13Algorithm.sortAutoRes(a,b)
    local daCount = 0
    for i = 1,3 do
        if D13Algorithm.cheackDaoShui(a[i].card,b[i].card) then
            daCount = daCount + 1
        end
    end
    print("daCount",daCount)
    return daCount >= 2
end

function D13Algorithm.getTSCard(tsType,cardsInfo)
    if tsType > 0 then
        local temp = {{},{},{}}
        temp[1].card = {}
        temp[2].card = {}
        temp[3].card = {}
        for i = 1,13 do
            if i >= 1 and i <= 3 then
                table.insert(temp[1].card,cardsInfo[i])
                temp[1].type = tsType
            end
            table.sort(temp[1].card, D13Algorithm.sortByValue_)
            if i >= 4 and i <= 8 then
                table.insert(temp[2].card,cardsInfo[i])
                temp[2].type = tsType
            end
            table.sort(temp[2].card, D13Algorithm.sortByValue_)
            if i >= 9 and i <= 13 then
                table.insert(temp[3].card,cardsInfo[i])
                temp[3].type = tsType
            end
            table.sort(temp[3].card, D13Algorithm.sortByValue_)
        end
        local type1,cmp1 = D13Algorithm.getCardType(temp[2].card)
        local type2,cmp2 = D13Algorithm.getCardType(temp[3].card)
        if D13Algorithm.cmpType(type1,type2,cmp1,cmp2) then
            temp[2],temp[3] = temp[3],temp[2]
        end
        return temp
    end
end

function D13Algorithm.getAllTypeCard(cards)
    local cardsInfo = clone(cards)
    table.sort(cardsInfo, D13Algorithm.sortByValue_)
    local resInfo = D13Algorithm.getSome(cardsInfo)
    local cardTypeInfo = {{},{},{},{},{},{},{},{},{}}
    for key,value in ipairs(resInfo) do
        if #value == 2 then
            table.insert(cardTypeInfo[D13Algorithm.DUI_YI],clone(value))
        end
        if #value == 3 then
            table.insert(cardTypeInfo[D13Algorithm.SAN_TIAO],clone(value))
        end
        if #value == 4 then
            table.insert(cardTypeInfo[D13Algorithm.TIE_ZHI],clone(value))
        end
    end
    local info = table.keys(cardTypeInfo[D13Algorithm.DUI_YI])
    local res = D13Algorithm.getCnm(info,2,false)
    for i = 1,#res do
        cardTypeInfo[D13Algorithm.DUI_ER][i] = table.values(cardTypeInfo[D13Algorithm.DUI_YI][res[i][1]])
        table.insertto(cardTypeInfo[D13Algorithm.DUI_ER][i], table.values(cardTypeInfo[D13Algorithm.DUI_YI][res[i][2]]), #cardTypeInfo[D13Algorithm.DUI_ER][i]+1)
    end
    if #cardTypeInfo[D13Algorithm.DUI_YI] > 0 and #cardTypeInfo[D13Algorithm.SAN_TIAO] > 0 then
        local index = 0
        for i = 1,#cardTypeInfo[D13Algorithm.DUI_YI] do
            for j = 1,#cardTypeInfo[D13Algorithm.SAN_TIAO] do
                index = index + 1
                cardTypeInfo[D13Algorithm.HU_LU][index] = table.values(cardTypeInfo[D13Algorithm.DUI_YI][i])
                table.insertto(cardTypeInfo[D13Algorithm.HU_LU][index], table.values(cardTypeInfo[D13Algorithm.SAN_TIAO][j]), #cardTypeInfo[D13Algorithm.HU_LU][index]+1)
            end
        end
    end
    cardTypeInfo[D13Algorithm.TONG_HUA],cardTypeInfo[D13Algorithm.TONG_HUA_SHUN] = D13Algorithm.getAllTH(clone(cards))
    cardTypeInfo[D13Algorithm.SHUN_ZI] = D13Algorithm.getAllSZ(clone(cards))
    return cardTypeInfo
end

function D13Algorithm.getAllSZ(cards)
    table.sort(cards, D13Algorithm.sortByValue_)
    local len = #cards
    local result = {}
    if len >= 5 then
        for i = 1,len do
            local temp = {}
            temp[1] = cards[i]
            for j = i+1,len do
                if BaseAlgorithm.getValue(temp[#temp]) - BaseAlgorithm.getValue(cards[j]) == 1 then
                    table.insert(temp,cards[j])
                    if #temp == 4 and BaseAlgorithm.getValue(temp[1]) == 5 and BaseAlgorithm.getValue(cards[1]) == 14 then
                        table.insert(temp,1,cards[1])
                    end
                    if #temp == 5 then
                        table.insert(result,clone(temp))
                        break
                    end
                end
            end
        end
    end
    return result
end

function D13Algorithm.getAllTH(cards)
    local function cmp(a,b)
        for i = 1,5 do
            local aValue = BaseAlgorithm.getValue(a[i])
            local bValue = BaseAlgorithm.getValue(b[i])
            if aValue ~= bValue then
                return aValue > bValue
            end
        end
        return BaseAlgorithm.getSuit(a[1]) > BaseAlgorithm.getSuit(b[1])
    end
    --获取所有同花
    local thInfo = {}
    local thszInfo = {}
    local someSuitRes = D13Algorithm.getSomeSuit(cards)
    for _,v in ipairs(someSuitRes) do
        if #v >= 5 then
            table.sort(v, D13Algorithm.sortByValue_)
            D13Algorithm.getCnm(v,5,true,thInfo,thszInfo)
        end
    end
    table.sort(thInfo,cmp)
    table.sort(thszInfo,cmp)
    return thInfo,thszInfo
end

function D13Algorithm.getCnm(atable,n,needSZ,result,resultSZ)
    if n > #atable then
        return {}
    end
    result = result or {}
    resultSZ = resultSZ or {}
    local len = #atable
    local meta = {}
    local function insertElement()
        local isSZ = true
        local cardValue = nil
        local tmp = {}
        for i=1, len do
            if meta[i] == 1 then
                table.insert(tmp, atable[i])
                if isSZ and needSZ then
                    if cardValue then
                        local nowCardValue = BaseAlgorithm.getValue(atable[i])
                        if (math.abs(cardValue - nowCardValue) == 1) or (cardValue == 14 and nowCardValue == 5) then
                            cardValue = nowCardValue
                        else
                            isSZ = false
                        end
                    else
                        cardValue = BaseAlgorithm.getValue(atable[i])
                    end
                end
                
            end
        end
        if isSZ and needSZ then
            table.insert(resultSZ, tmp)
        else
            table.insert(result, tmp)
        end
    end
    -- init meta data
    for i=1, len do
        if i <= n then
            table.insert(meta, 1)
        else
            table.insert(meta, 0)
        end
    end

    insertElement()

    while true do
        -- 前面连续的0
        local zero_count = 0
        for i=1, len-n do
            if meta[i] == 0 then
                zero_count = zero_count + 1
            else
                break
            end
        end
        -- 前m-n位都是0，说明处理结束
        if zero_count == len-n then
            break
        end

        local idx
        for j=1, len-1 do
            -- 10 交换为 01
            if meta[j]==1 and meta[j+1] == 0 then
                meta[j], meta[j+1] = meta[j+1], meta[j]
                idx = j
                break
            end
        end
        -- 将idx左边所有的1移到最左边
        local k = idx-1
        local count = 0
        while count <= k do
            for i=k, 2, -1 do
                if meta[i] == 1 then
                    meta[i], meta[i-1] = meta[i-1], meta[i]
                end
            end
            count = count + 1
        end

        -- 记录一次组合
        insertElement() 
    end
    return result,resultSZ
end

function D13Algorithm.sortCardByA(cards)
    local valueCards = {14,5,4,3,2}
    local result = {}
    for i = 2,5 do
        dump(cards,"cardscards")
        if BaseAlgorithm.getValue(cards[i]) == valueCards[i] then
            table.insert(result,cards[i])
        end
    end
    local i = 1
    if BaseAlgorithm.getValue(cards[i]) == valueCards[i] then
        table.insert(result,cards[i])
    end
    if #result == 5 then
        return result
    else
        return cards
    end
end

function D13Algorithm.sortCardByCardType(cards)
    local type = D13Algorithm.getCardType(cards)

    if type == D13Algorithm.SAN_PAI or type == D13Algorithm.SHUN_ZI or type == D13Algorithm.TONG_HUA or type == D13Algorithm.TONG_HUA_SHUN then
        table.sort(cards, D13Algorithm.sortByValue_)
    else
        local cardInfo = D13Algorithm.getCardNumInfo(cards)
        local res = nil
        if type == D13Algorithm.TIE_ZHI and cardInfo[4] and cardInfo[1] then
            res = cardInfo[4][1]
            table.sort(res, D13Algorithm.sortByValue_)
            res[5] = cardInfo[1][1][1]
        elseif type == D13Algorithm.HU_LU and cardInfo[3] and cardInfo[2] then
            res = cardInfo[3][1]
            table.sort(res, D13Algorithm.sortByValue_)
            local res1 = cardInfo[2][1]
            table.sort(res1, D13Algorithm.sortByValue_)
            table.insertto(res, res1)
        elseif type == D13Algorithm.SAN_TIAO and cardInfo[3] and cardInfo[1] then
            res = cardInfo[3][1]
            table.sort(res, D13Algorithm.sortByValue_)
            local res1 = {}
            for i = 1,#cardInfo[1] do
                table.insertto(res1, cardInfo[1][i])
            end
            table.sort(res1, D13Algorithm.sortByValue_)
            table.insertto(res, res1)
        elseif type == D13Algorithm.DUI_YI and cardInfo[2] and cardInfo[1] then
            res = cardInfo[2][1]
            table.sort(res, D13Algorithm.sortByValue_)
            local res1 = {}
            for i = 1,#cardInfo[1] do
                table.insertto(res1, cardInfo[1][i])
            end
            table.sort(res1, D13Algorithm.sortByValue_)
            table.insertto(res, res1)
        elseif type == D13Algorithm.DUI_ER and cardInfo[2] and cardInfo[1] then
            res = {}
            for i = 1,#cardInfo[2] do
                table.insertto(res, cardInfo[2][i])
            end
            table.sort(res, D13Algorithm.sortByValue_)
            local res1 = {}
            for i = 1,#cardInfo[1] do
                table.insertto(res1, cardInfo[1][i])
            end
            table.sort(res1, D13Algorithm.sortByValue_)
            table.insertto(res, res1)
        end
        if res and #cards == #res then
            cards = res
        end
    end
    return D13Algorithm.sortCardByA(cards)
end

return D13Algorithm 
