local BaseLocalUserData = import(".BaseLocalUserData")
local NXLocalData = class("NXLocalData", BaseLocalUserData)
local JU_SHU = "NX_ZMZ_JU_SHU"
local REN_SHU = "NX_ZMZ_REN_SHU"
local ZHI_FU = "NX_ZMZ_ZHI_FU"
local FZB_INDEX = "NX_ZMZ_FZB_INDEX"
local CARD_NUM = "NX_ZMZ_CARD_NUM"
local SAD1 = "NX_ZMZ_SAD1"
local BIZHA = "NX_ZMZ_BIZHA"
local XIAN_SHOU = "NX_XIAN_SHOU"
local SI_DAI = "NX_SI_DAI"
local DAN2 = "NX_DAN_CHU2"
function NXLocalData:ctor()
    NXLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getFZBINDEX() == "" then
        self:setFZBINDEX(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getCardNum() == "" then
        self:setCardNum(1)
    end
    if  self:get3ad1() == "" then
        self:set3ad1(1)
    end
    if  self:getBiZha() == "" then
        self:setBiZha(1)
    end
    if  self:getDan2() == "" then
        self:setDan2(1)
    end
    if  self:getXianShou() == "" then
        self:setXianShou(1)
    end
    if  self:get4dai() == "" then
        self:set4dai(1)
    end
end

function NXLocalData:setDan2(num)
    self:setUserLocalData(DAN2, num)
end

function NXLocalData:getDan2()
    return self:getUserLocalData(DAN2)
end

function NXLocalData:setXianShou(num)
    self:setUserLocalData(XIAN_SHOU, num)
end

function NXLocalData:getXianShou()
    return self:getUserLocalData(XIAN_SHOU)
end

function NXLocalData:set4dai(num)
    self:setUserLocalData(SI_DAI, num)
end

function NXLocalData:get4dai()
    return self:getUserLocalData(SI_DAI)
end

function NXLocalData:set3ad1(num)
    self:setUserLocalData(SAD1, num)
end

function NXLocalData:get3ad1()
    return self:getUserLocalData(SAD1)
end

function NXLocalData:setBiZha(num)
    self:setUserLocalData(BIZHA, num)
end

function NXLocalData:getBiZha()
    return self:getUserLocalData(BIZHA)
end

function NXLocalData:setCardNum(num)
    self:setUserLocalData(CARD_NUM, num)
end

function NXLocalData:getCardNum()
    return self:getUserLocalData(CARD_NUM)
end

function NXLocalData:getFZBINDEX()
    return self:getUserLocalData(FZB_INDEX)
end

function NXLocalData:setFZBINDEX(num)
    self:setUserLocalData(FZB_INDEX, num)
end

function NXLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function NXLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function NXLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function NXLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function NXLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function NXLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end


return NXLocalData 
