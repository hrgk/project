local BaseLocalUserData = import(".BaseLocalUserData")
local CSMJLocalData = class("CSMJLocalData", BaseLocalUserData)
local JU_SHU = "XT_CM_JU_SHU"
local ZHUA_NIAO = "XT_CM_ZHUA_NIAO"
local DAI_ZHUANG = "XT_CM_DAI_ZHUANG"
local ZHA_NIAO = "XT_CM_ZHA_NIAO"
local ZHONG_NIAO = "XT_CM_ZHONG_NIAO"
local KAI_GANG = "XT_CM_KAI_GANG"
local REN_SHU = "XT_CM_REN_SHU"
local QI_SHOU_HU = "QI_SHOU_HU"
local QI_MIDDLE_HU = "QI_MIDDLE_HU"
local beginHuList = {"danSeYiZhiHua", "jiangYiZhiHua", "yiZhiNiao", "liuLiuShun", "sanTong", "jieJieGao", "qiShouSiZhang", "banBanHu", "queYiSe",}
local middleHuList = {"zhongTuSiZhang", "zhongTuLiuLiuShun",}
local NIAO_FEN = "XT_CM_NIAO_FEN"
local NIAO_BEI = "XT_CM_NIAO_BEI"
local ZHUANG_TYPE = "XT_CM_ZHUANG_TYPE"
local ZHI_FU = "XT_CM_ZHI_FU"
local PF = "XT_CM_PF"
local PAI_TYPE = "XT_CM_PAI_TYPE"
local QISHOU_NIAO = "XT_CM_QISHOU_NIAO"
function CSMJLocalData:ctor()
    CSMJLocalData.super.ctor(self)
    if  self:getPF() == "" then
        self:setPF(1)
    end
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getZhuangType() == "" then
        self:setZhuangType(1)
    end
    if  self:getZhaNiao() == "" then
        self:setZhaNiao(1)
    end
    if  self:getGang() == "" then
        self:setGang(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getNiaoFen() == "" then
        self:setNiaoFen(1)
    end
    if  self:getNiaoBei() == "" then
        self:setNiaoBei(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getpaiType() == "" then
        self:setpaiType(1)
    end
    if  self:getZhongNiao() == "" then
        self:setZhongNiao(1)
    end
    if  self:getQiShouNiao() == "" then
        self:setQiShouNiao(0)
    end
    if  self:getQiShouHu() == "" then
        local str = ""
        for i,v in ipairs(beginHuList) do
            str = str .. v ..","
        end
        self:setQiShouHu(str)
    end
    if  self:getMiddleHu() == "" then
        local str = ""
        for i,v in ipairs(middleHuList) do
            str = str .. v ..","
        end
        self:setMiddleHu(str)
    end
end

function CSMJLocalData:setQiShouNiao(num)
    self:setUserLocalData(QISHOU_NIAO, num)
end

function CSMJLocalData:getQiShouNiao()
    return self:getUserLocalData(QISHOU_NIAO)
end

function CSMJLocalData:setZhongNiao(num)
    self:setUserLocalData(ZHONG_NIAO, num)
end

function CSMJLocalData:getZhongNiao()
    return self:getUserLocalData(ZHONG_NIAO)
end

function CSMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function CSMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end

function CSMJLocalData:setPF(num)
    self:setUserLocalData(PF, num)
end

function CSMJLocalData:getPF()
    return self:getUserLocalData(PF)
end

function CSMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function CSMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function CSMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function CSMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function CSMJLocalData:setNiaoFen(num)
    self:setUserLocalData(NIAO_FEN, num)
end

function CSMJLocalData:getNiaoFen()
    return self:getUserLocalData(NIAO_FEN)
end

function CSMJLocalData:setNiaoBei(num)
    self:setUserLocalData(NIAO_BEI, num)
end

function CSMJLocalData:getNiaoBei()
    return self:getUserLocalData(NIAO_BEI)
end

function CSMJLocalData:setZhaNiao(num)
    self:setUserLocalData(ZHA_NIAO, num)
end

function CSMJLocalData:getZhaNiao()
    return self:getUserLocalData(ZHA_NIAO)
end

function CSMJLocalData:setGang(num)
    self:setUserLocalData(KAI_GANG, num)
end

function CSMJLocalData:getGang()
    return self:getUserLocalData(KAI_GANG)
end

function CSMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function CSMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function CSMJLocalData:setZhuangType(num)
    self:setUserLocalData(ZHUANG_TYPE, num)
end

function CSMJLocalData:getZhuangType()
    return self:getUserLocalData(ZHUANG_TYPE)
end

function CSMJLocalData:setQiShouHu(num)
    self:setUserLocalData(QI_SHOU_HU, num)
end

function CSMJLocalData:getQiShouHu()
    return self:getUserLocalData(QI_SHOU_HU)
end

function CSMJLocalData:setMiddleHu(num)
    self:setUserLocalData(QI_MIDDLE_HU, num)
end

function CSMJLocalData:getMiddleHu()
    return self:getUserLocalData(QI_MIDDLE_HU)
end

return CSMJLocalData 
