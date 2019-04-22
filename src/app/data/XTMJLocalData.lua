local BaseLocalUserData = import(".BaseLocalUserData")
local XTMJLocalData = class("XTMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_JU_SHU"
local ZHUA_NIAO = "XT_ZHUA_NIAO"
local DAI_ZHUANG = "XT_DAI_ZHUANG"
local MEN_QING = "XT_MEN_QING"
local PENG_PENG_HU = "XT_PENG_PENG_HU"
function XTMJLocalData:ctor()
    XTMJLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getNiao() == "" then
        self:setNiao(1)
    end
    if  self:getDaiZhuang() == "" then
        self:setDaiZhuang(1)
    end
    if  self:getMenQing() == "" then
        self:setMenQing(1)
    end
    if  self:getPengPengHu() == "" then
        self:setPengPengHu(1)
    end
end

function XTMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function XTMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function XTMJLocalData:setNiao(num)
    self:setUserLocalData(ZHUA_NIAO, num)
end

function XTMJLocalData:getNiao()
    return self:getUserLocalData(ZHUA_NIAO)
end

function XTMJLocalData:setDaiZhuang(num)
    self:setUserLocalData(DAI_ZHUANG, num)
end

function XTMJLocalData:getDaiZhuang()
    return self:getUserLocalData(DAI_ZHUANG)
end

function XTMJLocalData:setMenQing(num)
    self:setUserLocalData(MEN_QING, num)
end

function XTMJLocalData:getMenQing()
    return self:getUserLocalData(MEN_QING)
end

function XTMJLocalData:setPengPengHu(num)
    self:setUserLocalData(PENG_PENG_HU, num)
end

function XTMJLocalData:getPengPengHu()
    return self:getUserLocalData(PENG_PENG_HU)
end

return XTMJLocalData 
