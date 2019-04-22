local BaseLocalUserData = import(".BaseLocalUserData")
local ZZMJLocalData = class("ZZMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_ZZ_JU_SHU"
local ZHUA_NIAO = "XT_ZZ_ZHUA_NIAO"
local WAN_FA = "XT_ZZ_WAN_FA"
local REN_SHU = "XT_ZZ_REN_SHU"
local ZHONG_NIAO = "XT_ZZ_ZHONG_NIAO"
local KE_JIE_PAO = "XT_ZZ_KE_JIE_PAO"
local HU_PAI = "XT_ZZ_HU_PAI"
local ZHI_FU = "XT_ZZ_ZHI_FU"
local PAI_TYPE = "XT_ZZ_PAI_TYPE"
local ZHANG_XIAN = "XT_ZZ_ZHANG_XIAN"
local QYM = "XT_ZZ_QYM"
local SFN = "XT_ZZ_SFN"
function ZZMJLocalData:ctor()
    ZZMJLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getNiao() == "" then
        self:setNiao(1)
    end
    if  self:getZhongNiao() == "" then
        self:setZhongNiao(0)
    end
    if  self:getWanFa() == "" then
        self:setWanFa(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getKeJiePao() == "" then
        self:setKeJiePao(0)
    end
    if  self:getHuPai() == "" then
        self:setHuPai(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getZX() == "" then
        self:setZX(0)
    end
    if  self:getpaiType() == "" then
        self:setpaiType(1)
    end
    if  self:getQYM() == "" then
        self:setQYM(1)
    end
    if  self:getSFN() == "" then
        self:setSFN(1)
    end
end

function ZZMJLocalData:setSFN(num)
    self:setUserLocalData(SFN, num)
end

function ZZMJLocalData:getSFN()
    return self:getUserLocalData(SFN)
end

function ZZMJLocalData:setQYM(num)
    self:setUserLocalData(QYM, num)
end

function ZZMJLocalData:getQYM()
    return self:getUserLocalData(QYM)
end

function ZZMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function ZZMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end

function ZZMJLocalData:setZX(num)
    self:setUserLocalData(ZHANG_XIAN, num)
end

function ZZMJLocalData:getZX()
    return self:getUserLocalData(ZHANG_XIAN)
end

function ZZMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function ZZMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function ZZMJLocalData:setHuPai(num)
    self:setUserLocalData(HU_PAI, num)
end

function ZZMJLocalData:getHuPai()
    return self:getUserLocalData(HU_PAI)
end

function ZZMJLocalData:setKeJiePao(num)
    self:setUserLocalData(KE_JIE_PAO, num)
end

function ZZMJLocalData:getKeJiePao()
    return self:getUserLocalData(KE_JIE_PAO)
end

function ZZMJLocalData:setZhongNiao(num)
    self:setUserLocalData(ZHONG_NIAO, num)
end

function ZZMJLocalData:getZhongNiao()
    return self:getUserLocalData(ZHONG_NIAO)
end

function ZZMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function ZZMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function ZZMJLocalData:setNiao(num)
    self:setUserLocalData(ZHUA_NIAO, num)
end

function ZZMJLocalData:getNiao()
    return self:getUserLocalData(ZHUA_NIAO)
end

function ZZMJLocalData:setWanFa(num)
    self:setUserLocalData(WAN_FA, num)
end

function ZZMJLocalData:getWanFa()
    return self:getUserLocalData(WAN_FA)
end

function ZZMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function ZZMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

return ZZMJLocalData 
