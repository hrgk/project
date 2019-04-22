local BaseLocalUserData = import(".BaseLocalUserData")
local HZMJLocalData = class("HZMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_HZ_JU_SHU"
local ZHUA_NIAO = "XT_HZ_ZHUA_NIAO"
local WAN_FA = "XT_HZ_WAN_FA"
local REN_SHU = "XT_HZ_REN_SHU"
local ZHONG_NIAO = "XT_HZ_ZHONG_NIAO"
local ZHI_FU = "XT_HZ_ZHI_FU"
local NIAO_SCORE = "XT_HZ_NIAO_SCORE"
local ADD_NIAO = "XT_HZ_ADD_NIAO"
local PAI_TYPE = "XT_HZ_PAI_TYPE"
local QIANG_GANG_GZ = "XT_HZ_QIANG_GANG_GZ"
local QYM = "XT_HZ_QYM"
local SFN = "XT_HZ_SFN"
function HZMJLocalData:ctor()
    HZMJLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getNiao() == "" then
        self:setNiao(1)
    end
    if  self:getZhongNiao() == "" then
        self:setZhongNiao(0)
    end
    if  self:getWanFa() == "" or self:getWanFa() == "1" or self:getWanFa() == "0" then
        local obj = {}
        obj.qgh = 1
        obj.wdw = 1
        obj.yh = 1
        obj.hqxd = 0
        obj.qxd = 0
        obj.qys = 0
        obj.qqr = 0
        obj.shqxd = 0
        obj.pph = 0
        self:setWanFa(json.encode(obj))
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getNF() == "" then
        self:setNF(1)
    end
    if  self:getAddNiao() == "" then
        self:setAddNiao(1)
    end
    if  self:getpaiType() == "" then
        self:setpaiType(1)
    end
    if  self:getqggz() == "" then
        self:setqggz(2)
    end
    if  self:getQYM() == "" then
        self:setQYM(1)
    end
    if  self:getSFN() == "" then
        self:setSFN(1)
    end
end

function HZMJLocalData:setSFN(num)
    self:setUserLocalData(SFN, num)
end

function HZMJLocalData:getSFN()
    return self:getUserLocalData(SFN)
end

function HZMJLocalData:setQYM(num)
    self:setUserLocalData(QYM, num)
end

function HZMJLocalData:getQYM()
    return self:getUserLocalData(QYM)
end

function HZMJLocalData:setqggz(num)
    self:setUserLocalData(QIANG_GANG_GZ, num)
end

function HZMJLocalData:getqggz()
    return self:getUserLocalData(QIANG_GANG_GZ)
end

function HZMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function HZMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end


function HZMJLocalData:setAddNiao(num)
    self:setUserLocalData(ADD_NIAO, num)
end

function HZMJLocalData:getAddNiao()
    return self:getUserLocalData(ADD_NIAO)
end

function HZMJLocalData:setNF(num)
    self:setUserLocalData(NIAO_SCORE, num)
end

function HZMJLocalData:getNF()
    return self:getUserLocalData(NIAO_SCORE)
end

function HZMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function HZMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function HZMJLocalData:setZhongNiao(num)
    self:setUserLocalData(ZHONG_NIAO, num)
end

function HZMJLocalData:getZhongNiao()
    return self:getUserLocalData(ZHONG_NIAO)
end

function HZMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function HZMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function HZMJLocalData:setNiao(num)
    self:setUserLocalData(ZHUA_NIAO, num)
end

function HZMJLocalData:getNiao()
    return self:getUserLocalData(ZHUA_NIAO)
end

function HZMJLocalData:setWanFa(num)
    self:setUserLocalData(WAN_FA, num)
end

function HZMJLocalData:getWanFa()
    return self:getUserLocalData(WAN_FA)
end

function HZMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function HZMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

return HZMJLocalData 
