local BaseLocalUserData = import(".BaseLocalUserData")
local NiuNiuLocalData = class("NiuNiuLocalData", BaseLocalUserData)
local JU_SHU = "MP_NIUNIU_JU_SHU"
local REN_SHU = "MP_NIUNIU_REN_SHU"
local XIA_ZHU = "MP_NIUNIU_XIA_ZHU"
local ZUO_ZHUANG = "MP_NIUNIU_ZUO_ZHUANG"
local ZHUANG_BEI_SHU = "MP_NIUNIU_ZHUANG_BEI_SHU"
local TE_SHU = "MP_NIUNIU_TE_SHU"
local TUI_ZHU = "MP_TUI_ZHU"
local JOKER = "MP_NIUNIU_JOKER"
local ZHI_FU = "MP_NIUNIU_ZHI_FU"
local FAN_BEI_TYPE = "MP_NIUNIU_FAN_BEI_TYPE"
local JZCP = "MP_NIUNIU_JZCP"
local JZJR = "MP_NIUNIU_JZJR"
local PX = "MP_NIUNIU_PX"

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
    if  self:getTeShu() == "" or self:getTeShu() == "1" or self:getTeShu() == "0" then
        local obj = {}
        obj["shunZiNiu"] = 1
        obj["wuHuaNiu"] = 1
        obj["tongHuaNiu"] = 1
        obj["huLuNiu"] = 1
        obj["zhaDanNiu"] = 1
        obj["wuXiaoNiu"] = 1
        obj["tongHuaShun"] = 1
        self:setTeShu(json.encode(obj))
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
    if self:getFanBeiType() == "" then
        self:setFanBeiType(1)
    end
    if self:getJZCP() == "" then
        self:setJZCP(1)
    end
    if self:getJZJR() == "" then
        self:setJZJR(1)
    end
    if self:getPX() == "" then
        self:setPX(1)
    end
end

function NiuNiuLocalData:setPX(num)
    self:setUserLocalData(PX, num)
end

function NiuNiuLocalData:getPX()
    return self:getUserLocalData(PX)
end

function NiuNiuLocalData:setJZJR(num)
    self:setUserLocalData(JZJR, num)
end

function NiuNiuLocalData:getJZJR()
    return self:getUserLocalData(JZJR)
end

function NiuNiuLocalData:setJZCP(num)
    self:setUserLocalData(JZCP, num)
end

function NiuNiuLocalData:getJZCP()
    return self:getUserLocalData(JZCP)
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

function NiuNiuLocalData:setTeShu(str)
    self:setUserLocalData(TE_SHU, str)
end

function NiuNiuLocalData:getTeShu()
    return self:getUserLocalData(TE_SHU)
end

function NiuNiuLocalData:setJoker(num)
    self:setUserLocalData(JOKER, num)
end

function NiuNiuLocalData:getJoker()
    return self:getUserLocalData(JOKER)
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

function NiuNiuLocalData:setFanBeiType(num)
    self:setUserLocalData(FAN_BEI_TYPE, num)
end

function NiuNiuLocalData:getFanBeiType()
    return self:getUserLocalData(FAN_BEI_TYPE)
end

return NiuNiuLocalData 
