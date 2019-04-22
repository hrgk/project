local BaseLocalUserData = import(".BaseLocalUserData")
local MMMJLocalData = class("MMMJLocalData", BaseLocalUserData)
local JU_SHU = "MMMJ_JU_SHU"
local ZHUA_NIAO = "MMMJ_ZHUA_NIAO"
local DAI_ZHUANG = "MMMJ_DAI_ZHUANG"
local ZHA_NIAO = "MMMJ_ZHA_NIAO"
local ZHONG_NIAO = "MMMJ_ZHONG_NIAO"
local KAI_GANG = "MMMJ_KAI_GANG"
local REN_SHU = "MMMJ_REN_SHU"
local QI_SHOU_HU = "MMMJ_QI_SHOU_HU"
local QI_MIDDLE_HU = "MMMJ_QI_MIDDLE_HU"
local beginHuList = {"danSeYiZhiHua", "jiangYiZhiHua", "yiZhiNiao", "liuLiuShun", "sanTong", "jieJieGao", "qiShouSiZhang", "banBanHu", "queYiSe",}
local middleHuList = {}
local NIAO_FEN = "MMMJ_NIAO_FEN"
local NIAO_BEI = "MMMJ_NIAO_BEI"
local ZHUANG_TYPE = "MMMJ_ZHUANG_TYPE"
local ZHI_FU = "MMMJ_ZHI_FU"
local DOU_QI = "MMMJ_DOU_QI"
local BBH_ROUND_OVER = "MMMJ_BBH_ROUND_OVER"
local PF = "MMMJ_PF"
local PAI_TYPE = "MMMJ_PAI_TYPE"
local BAO_PEI = "MMMJ_BAO_PEI"
local QIANG_ZHI_HU = "MMMJ_QIANG_ZHI_HU"

function MMMJLocalData:ctor()
    MMMJLocalData.super.ctor(self)
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

function MMMJLocalData:setZhongNiao(num)
    self:setUserLocalData(ZHONG_NIAO, num)
end

function MMMJLocalData:getZhongNiao()
    return self:getUserLocalData(ZHONG_NIAO)
end

function MMMJLocalData:setpaiType(num)
    self:setUserLocalData(PAI_TYPE, num)
end

function MMMJLocalData:getpaiType()
    return self:getUserLocalData(PAI_TYPE)
end

function MMMJLocalData:setPF(num)
    self:setUserLocalData(PF, num)
end

function MMMJLocalData:getPF()
    return self:getUserLocalData(PF)
end

function MMMJLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function MMMJLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function MMMJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function MMMJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function MMMJLocalData:setNiaoFen(num)
    self:setUserLocalData(NIAO_FEN, num)
end

function MMMJLocalData:getNiaoFen()
    return self:getUserLocalData(NIAO_FEN)
end

function MMMJLocalData:setNiaoBei(num)
    self:setUserLocalData(NIAO_BEI, num)
end

function MMMJLocalData:getNiaoBei()
    return self:getUserLocalData(NIAO_BEI)
end

function MMMJLocalData:setZhaNiao(num)
    self:setUserLocalData(ZHA_NIAO, num)
end

function MMMJLocalData:getZhaNiao()
    return self:getUserLocalData(ZHA_NIAO)
end

function MMMJLocalData:setGang(num)
    self:setUserLocalData(KAI_GANG, num)
end

function MMMJLocalData:getGang()
    return self:getUserLocalData(KAI_GANG)
end

function MMMJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function MMMJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function MMMJLocalData:setZhuangType(num)
    self:setUserLocalData(ZHUANG_TYPE, num)
end

function MMMJLocalData:getZhuangType()
    return self:getUserLocalData(ZHUANG_TYPE)
end

function MMMJLocalData:setQiShouHu(num)
    self:setUserLocalData(QI_SHOU_HU, num)
end

function MMMJLocalData:getQiShouHu()
    return self:getUserLocalData(QI_SHOU_HU)
end

function MMMJLocalData:setMiddleHu(num)
    self:setUserLocalData(QI_MIDDLE_HU, num)
end

function MMMJLocalData:getMiddleHu()
    return self:getUserLocalData(QI_MIDDLE_HU)
end

function MMMJLocalData:setBBHRoundOver(num)
    self:setUserLocalData(BBH_ROUND_OVER, num)
end

function MMMJLocalData:getBBHRoundOver()
    return self:getUserLocalData(BBH_ROUND_OVER)
end

function MMMJLocalData:setDouQi(num)
    self:setUserLocalData(DOU_QI, num)
end

function MMMJLocalData:getDouQi()
    return self:getUserLocalData(DOU_QI)
end

function MMMJLocalData:setQiangZhiHu(num)
    self:setUserLocalData(QIANG_ZHI_HU, num)
end

function MMMJLocalData:getQiangZhiHu()
    return self:getUserLocalData(QIANG_ZHI_HU)
end

function MMMJLocalData:setBaoPei(num)
    self:setUserLocalData(BAO_PEI, num)
end

function MMMJLocalData:getBaoPei()
    return self:getUserLocalData(BAO_PEI)
end

return MMMJLocalData 
