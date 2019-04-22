local BaseLocalUserData = import(".BaseLocalUserData")
local FHHZMJLocalData = class("FHHZMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_FHHZ_JU_SHU"
local REN_SHU = "XT_FHHZ_REN_SHU"
local HU_PAI = "XT_FHHZ_HU_PAI"
local ZHI_FU = "XT_FHHZ_ZHI_FU"
local PAI_TYPE = "XT_FHHZ_PAI_TYPE"
local XIA_YU = "XT_FHHZ_XIA_YU"
local FENG_PAI = "XT_FHHZ_FENG_PAI"
local AUTO_READY = "XT_FHHZ_AUTO_READY"
local QXD = "XT_FHHZ_QXD"
local HQXD = "XT_FHHZ_HQXD"
local SHQXD = "XT_FHHZ_SHQXD"
local SANHQXD = "XT_FHHZ_SANHQXD"
local GSH = "XT_FHHZ_GSH"
local QGH = "XT_FHHZ_QGH"

function FHHZMJLocalData:ctor()
    FHHZMJLocalData.super.ctor(self)
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
    if  self:getQGH() == "" then
        self:setQGH(1)
    end
    if  self:getGSH() == "" then
        self:setGSH(1)
    end
    if  self:getSHQXD() == "" then
        self:setSHQXD(1)
    end
    if  self:getHQXD() == "" then
        self:setHQXD(1)
    end
    if  self:getQXD() == "" then
        self:setQXD(1)
    end
    if  self:getSANHQXD() == "" then
        self:setSANHQXD(1)
    end
end

function FHHZMJLocalData:setSANHQXD(num)
    self:setUserLocalData(SANHQXD, num)
end

function FHHZMJLocalData:getSANHQXD()
    return self:getUserLocalData(SANHQXD)
end

function FHHZMJLocalData:setQGH(num)
    self:setUserLocalData(QGH, num)
end

function FHHZMJLocalData:getQGH()
    return self:getUserLocalData(QGH)
end

function FHHZMJLocalData:setGSH(num)
    self:setUserLocalData(GSH, num)
end

function FHHZMJLocalData:getGSH()
    return self:getUserLocalData(GSH)
end

function FHHZMJLocalData:setSHQXD(num)
    self:setUserLocalData(SHQXD, num)
end

function FHHZMJLocalData:getSHQXD()
    return self:getUserLocalData(SHQXD)
end

function FHHZMJLocalData:setHQXD(num)
    self:setUserLocalData(HQXD, num)
end

function FHHZMJLocalData:getHQXD()
    return self:getUserLocalData(HQXD)
end

function FHHZMJLocalData:setQXD(num)
    self:setUserLocalData(QXD, num)
end

function FHHZMJLocalData:getQXD()
    return self:getUserLocalData(QXD)
end

function FHHZMJLocalData:setAutoReady(num)
    self:setUserLocalData(AUTO_READY, num)
end

function FHHZMJLocalData:getAutoReady()
    return self:getUserLocalData(AUTO_READY)
end

function FHHZMJLocalData:setFP(num)
    self:setUserLocalData(FENG_PAI, num)
end

function FHHZMJLocalData:getFP()
    return self:getUserLocalData(FENG_PAI)
end

function FHHZMJLocalData:setXYNuM(num)
    self:setUserLocalData(XIA_YU, num)
end

function FHHZMJLocalData:getXYNuM()
    return self:getUserLocalData(XIA_YU)
end

function FHHZMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function FHHZMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end

function FHHZMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function FHHZMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function FHHZMJLocalData:setHuPai(num)
    self:setUserLocalData(HU_PAI, num)
end

function FHHZMJLocalData:getHuPai()
    return self:getUserLocalData(HU_PAI)
end

function FHHZMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function FHHZMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function FHHZMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function FHHZMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

return FHHZMJLocalData 
