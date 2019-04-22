local BaseLocalUserData = import(".BaseLocalUserData")
local NiuNiuLocalData = class("NiuNiuLocalData", BaseLocalUserData)
local JU_SHU = "XT_NIUNIU_JU_SHU"
local REN_SHU = "XT_NIUNIU_REN_SHU"
local XIA_ZHU = "XT_NIUNIU_XIA_ZHU"
local ZUO_ZHUANG = "XT_NIUNIU_ZUO_ZHUANG"
local ZHUANG_BEI_SHU = "XT_NIUNIU_ZHUANG_BEI_SHU"
local TE_SHU = "XT_NIUNIU_TE_SHU"
local TUI_ZHU = "XT_TUI_ZHU"
local ZHI_FU = "XT_NIUNIU_ZHI_FU"
function NiuNiuLocalData:ctor()
    NiuNiuLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getXiaZhu() == "" then
        self:setXiaZhu(1)
    end
    if  self:getZuoZhuang() == "" then
        self:setZuoZhuang(1)
    end
    if  self:getTeShu() == "" then
        self:setTeShu(1)
    end
    if  self:getBeiShu() == "" then
        self:setBeiShu(1)
    end
    if  self:getTuiZhu() == "" then
        self:setTuiZhu(1)
    end
    if self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
end

function NiuNiuLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function NiuNiuLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function NiuNiuLocalData:setTuiZhu(num)
    self:setUserLocalData(TUI_ZHU, num)
end

function NiuNiuLocalData:getTuiZhu()
    return self:getUserLocalData(TUI_ZHU)
end

function NiuNiuLocalData:setBeiShu(num)
    self:setUserLocalData(ZHUANG_BEI_SHU, num)
end

function NiuNiuLocalData:getBeiShu()
    return self:getUserLocalData(ZHUANG_BEI_SHU)
end

function NiuNiuLocalData:setTeShu(num)
    self:setUserLocalData(TE_SHU, num)
end

function NiuNiuLocalData:getTeShu()
    return self:getUserLocalData(TE_SHU)
end

function NiuNiuLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function NiuNiuLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function NiuNiuLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function NiuNiuLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function NiuNiuLocalData:setXiaZhu(num)
    self:setUserLocalData(XIA_ZHU, num)
end

function NiuNiuLocalData:getXiaZhu()
    return self:getUserLocalData(XIA_ZHU)
end

function NiuNiuLocalData:setZuoZhuang(num)
    self:setUserLocalData(ZUO_ZHUANG, num)
end

function NiuNiuLocalData:getZuoZhuang()
    return self:getUserLocalData(ZUO_ZHUANG)
end

return NiuNiuLocalData 
