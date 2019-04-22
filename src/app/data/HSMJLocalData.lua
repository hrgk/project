local BaseLocalUserData = import(".BaseLocalUserData")
local HSMJLocalData = class("HSMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_HS_JU_SHU"
local REN_SHU = "XT_HS_REN_SHU"
local HU_PAI = "XT_HS_HU_PAI"
local ZHI_FU = "XT_HS_ZHI_FU"
local PAI_TYPE = "XT_HS_PAI_TYPE"
local XIA_YU = "XT_HS_XIA_YU"
local FENG_PAI = "XT_HS_FENG_PAI"
local AUTO_READY = "XT_HS_AUTO_READY"
local SKC = "XT_HS_SKC"
local HZTF = "XT_HS_HZTF"
local YP3X = "XT_HS_YP3X"
local PPH = "XT_HS_PPH"
local GZXJ = "XT_HS_GZXJ"
local HZXJ = "XT_HS_HZXJ"
local BH = "XT_HS_BH"

function HSMJLocalData:ctor()
    HSMJLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getHuPai() == "" then
        self:setHuPai(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getpaiType() == "" then
        self:setpaiType(1)
    end
    if  self:getXYNuM() == "" then
        self:setXYNuM(0)
    end
    if  self:getFP() == "" then
        self:setFP(1)
    end
    if  self:getAutoReady() == "" then
        self:setAutoReady(1)
    end
    if  self:getSKC() == "" then
        self:setSKC(0)
    end
    if  self:getHZTF() == "" then
        self:setHZTF(1)
    end
    if  self:getYP3X() == "" then
        self:setYP3X(0)
    end
    if  self:getPPH() == "" then
        self:setPPH(0)
    end
    if  self:getGZXJ() == "" then
        self:setGZXJ(0)
    end
    if  self:getHZXJ() == "" then
        self:setHZXJ(0)
    end
    if  self:getBH() == "" then
        self:setBH(0)
    end
end

function HSMJLocalData:setBH(num)
    self:setUserLocalData(BH, num)
end

function HSMJLocalData:getBH()
    return self:getUserLocalData(BH)
end

function HSMJLocalData:setHZXJ(num)
    self:setUserLocalData(HZXJ, num)
end

function HSMJLocalData:getHZXJ()
    return self:getUserLocalData(HZXJ)
end

function HSMJLocalData:setGZXJ(num)
    self:setUserLocalData(GZXJ, num)
end

function HSMJLocalData:getGZXJ()
    return self:getUserLocalData(GZXJ)
end

function HSMJLocalData:setPPH(num)
    self:setUserLocalData(PPH, num)
end

function HSMJLocalData:getPPH()
    return self:getUserLocalData(PPH)
end

function HSMJLocalData:setYP3X(num)
    self:setUserLocalData(YP3X, num)
end

function HSMJLocalData:getYP3X()
    return self:getUserLocalData(YP3X)
end

function HSMJLocalData:setHZTF(num)
    self:setUserLocalData(HZTF, num)
end

function HSMJLocalData:getHZTF()
    return self:getUserLocalData(HZTF)
end

function HSMJLocalData:setSKC(num)
    self:setUserLocalData(SKC, num)
end

function HSMJLocalData:getSKC()
    return self:getUserLocalData(SKC)
end

function HSMJLocalData:setAutoReady(num)
    self:setUserLocalData(AUTO_READY, num)
end

function HSMJLocalData:getAutoReady()
    return self:getUserLocalData(AUTO_READY)
end

function HSMJLocalData:setFP(num)
    self:setUserLocalData(FENG_PAI, num)
end

function HSMJLocalData:getFP()
    return self:getUserLocalData(FENG_PAI)
end

function HSMJLocalData:setXYNuM(num)
    self:setUserLocalData(XIA_YU, num)
end

function HSMJLocalData:getXYNuM()
    return self:getUserLocalData(XIA_YU)
end

function HSMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function HSMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end

function HSMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function HSMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function HSMJLocalData:setHuPai(num)
    self:setUserLocalData(HU_PAI, num)
end

function HSMJLocalData:getHuPai()
    return self:getUserLocalData(HU_PAI)
end

function HSMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function HSMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function HSMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function HSMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

return HSMJLocalData 
