local BaseLocalUserData = import(".BaseLocalUserData")
local DTZLocalData = class("DTZLocalData", BaseLocalUserData)
local JU_SHU = "DTZ_JU_SHU"
local REN_SHU = "DTZ_REN_SHU"
local PAI_ZHANG = "DTZ_PAI_ZHANG"
local JIANG_LI = "DTZ_JIANG_LI"
local SHOW_REMAIN_CARD = "DTZ_SHOW_REMAIN_CARD"
local RANDOM_FIRST = "DTZ_RANDOM_FIRST"
local MUST_DENNY = "DTZ_MUST_DENNY"
local ZHI_FU = "DTZ_ZZ_ZHI_FU"
local TAIL_3_WITH_CARD = "DTZ_TAIL_3_WITH_CARD"
function DTZLocalData:ctor()
    DTZLocalData.super.ctor(self)
    if self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if self:getPaiZhang() == "" then
        self:setPaiZhang(1)
    end
    if self:getJiangLi() == "" then
        self:setJiangLi(1)
    end
    if self:getRandomFirst() == "" then
        self:setRandomFirst(1)
    end
    if self:getShowRemainCard() == "" then
        self:setShowRemainCard(1)
    end
    if self:getMustDenny() == "" then
        self:setMustDenny(1)
    end
    if self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if self:getTail3WithCard() == "" then
        self:setTail3WithCard(2)
    end
end

function DTZLocalData:setTail3WithCard(num)
    self:setUserLocalData(TAIL_3_WITH_CARD, num)
end

function DTZLocalData:getTail3WithCard()
    return self:getUserLocalData(TAIL_3_WITH_CARD)
end

function DTZLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function DTZLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function DTZLocalData:setMustDenny(num)
    return self:setUserLocalData(MUST_DENNY, num)
end

function DTZLocalData:getMustDenny()
    return self:getUserLocalData(MUST_DENNY)
end

function DTZLocalData:getShowRemainCard()
    return self:getUserLocalData(SHOW_REMAIN_CARD)
end

function DTZLocalData:setShowRemainCard(num)
    self:setUserLocalData(SHOW_REMAIN_CARD, num)
end

function DTZLocalData:getRandomFirst()
    return self:getUserLocalData(RANDOM_FIRST)
end

function DTZLocalData:setRandomFirst(num)
    self:setUserLocalData(RANDOM_FIRST, num)
end

function DTZLocalData:getJiangLi()
    return self:getUserLocalData(JIANG_LI)
end

function DTZLocalData:setJiangLi(num)
    return self:setUserLocalData(JIANG_LI, num)
end

function DTZLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function DTZLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function DTZLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function DTZLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function DTZLocalData:setPaiZhang(num)
    self:setUserLocalData(PAI_ZHANG, num)
end

function DTZLocalData:getPaiZhang()
    return self:getUserLocalData(PAI_ZHANG)
end

return DTZLocalData 