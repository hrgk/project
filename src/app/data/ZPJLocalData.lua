local BaseLocalUserData = import(".BaseLocalUserData")
local ZPJLocalData = class("ZPJLocalData ", BaseLocalUserData)
local JU_SHU = "XT_ZPJ_JU_SHU"
local REN_SHU = "XT_ZPJ_REN_SHU"
local XIA_ZHU = "XT_ZPJ_XIA_ZHU"
local ZUO_ZHUANG = "XT_ZPJ_ZUO_ZHUANG"
function ZPJLocalData :ctor()
    ZPJLocalData .super.ctor(self)
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
end

function ZPJLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function ZPJLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function ZPJLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function ZPJLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function ZPJLocalData:setXiaZhu(num)
    self:setUserLocalData(XIA_ZHU, num)
end

function ZPJLocalData:getXiaZhu()
    return self:getUserLocalData(XIA_ZHU)
end

function ZPJLocalData:setZuoZhuang(num)
    self:setUserLocalData(ZUO_ZHUANG, num)
end

function ZPJLocalData:getZuoZhuang()
    return self:getUserLocalData(ZUO_ZHUANG)
end

return ZPJLocalData  
