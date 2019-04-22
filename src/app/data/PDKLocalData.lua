local BaseLocalUserData = import(".BaseLocalUserData")
local PDKLocalData = class("PDKLocalData", BaseLocalUserData)
local JU_SHU = "XT_PDK_JU_SHU"
local REN_SHU = "XT_PDK_REN_SHU"
local HOU_ZI = "XT_PDK_HOU_ZI"
local PAI_ZHANG = "XT_PDK_PAI_ZHANG"
local CARD_NUM = "XT_PDK_CARD_NUM"
local DI_FEN = "XT_PDK_DI_FEN"
local SI_DAI = "XT_PDK_SI_DAI"
local ZHI_FU = "XT_PDK_ZHI_FU"
local WEI_PAI_SAN_DAI_YI = "XT_PDK_WEI_PAI_SAN_DAI_YI"
local QIANG_GUANG = "XT_PDK_QIANG_GUANG"
local CHU_TYPE = "XT_PDK_CHU_TYPE"
local BAO_DAN = "XT_PDK_BAO_DAN"
local A3BAO = "XT_PDK_A3BAO"
local SW3 = "XT_PDK_SW3"
local FZB_INDEX = "XT_PDK_FZB_INDEX"
local ZDBKC = "XT_PDK_ZDBKC"
function PDKLocalData:ctor()
    PDKLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getRenShu() == "" then
        self:setRenShu(1)
    end
    if  self:getHouZi() == "" then
        self:setHouZi(0)
    end
    if  self:getPaiZhang() == "" then
        self:setPaiZhang(1)
    end
    if  self:getDiFen() == "" then
        self:setDiFen(1)
    end
    if  self:getCardNum() == "" then
        self:setCardNum(0)
    end
    if  self:getSiDai() == "" then
        self:setSiDai(1)
    end
    if  self:getZhiFu() == "" then
        self:setZhiFu(1)
    end
    if  self:getSanDaiYi() == "" then
        self:setSanDaiYi(0)
    end
    if  self:getQiangGuan() == "" then
        self:setQiangGuan(0)
    end
    if  self:getChuType() == "" then
        self:setChuType(1)
    end
    if  self:getBaoDan() == "" then
        self:setBaoDan(0)
    end
    if  self:getA3boom() == "" then
        self:setA3boom(0)
    end
    if  self:getSW3() == "" then
        self:setSW3(0)
    end
    if  self:getFZBINDEX() == "" then
        self:setFZBINDEX(1)
    end
    if  self:getZDBKC() == "" then
        self:setZDBKC(1)
    end
end

function PDKLocalData:getFZBINDEX()
    return self:getUserLocalData(FZB_INDEX)
end

function PDKLocalData:setFZBINDEX(num)
    self:setUserLocalData(FZB_INDEX, num)
end

function PDKLocalData:getSW3()
    return self:getUserLocalData(SW3)
end

function PDKLocalData:setSW3(num)
    self:setUserLocalData(SW3, num)
end

function PDKLocalData:setA3boom(num)
    self:setUserLocalData(A3BAO, num)
end

function PDKLocalData:getA3boom()
    return self:getUserLocalData(A3BAO)
end

function PDKLocalData:setBaoDan(num)
    self:setUserLocalData(BAO_DAN, num)
end

function PDKLocalData:getBaoDan()
    return self:getUserLocalData(BAO_DAN)
end

function PDKLocalData:setChuType(num)
    self:setUserLocalData(CHU_TYPE, num)
end

function PDKLocalData:getChuType()
    return self:getUserLocalData(CHU_TYPE)
end

function PDKLocalData:setQiangGuan(num)
    self:setUserLocalData(QIANG_GUANG, num)
end

function PDKLocalData:getQiangGuan()
    return self:getUserLocalData(QIANG_GUANG) 
end

function PDKLocalData:setSanDaiYi(num)
    self:setUserLocalData(WEI_PAI_SAN_DAI_YI, num)
end

function PDKLocalData:getSanDaiYi()
    return self:getUserLocalData(WEI_PAI_SAN_DAI_YI)
end

function PDKLocalData:setZhiFu(num)
    self:setUserLocalData(ZHI_FU, num)
end

function PDKLocalData:getZhiFu()
    return self:getUserLocalData(ZHI_FU)
end

function PDKLocalData:setSiDai(num)
    self:setUserLocalData(SI_DAI, num)
end

function PDKLocalData:getSiDai()
    return self:getUserLocalData(SI_DAI)
end

function PDKLocalData:setCardNum(num)
    self:setUserLocalData(CARD_NUM, num)
end

function PDKLocalData:getCardNum()
    return self:getUserLocalData(CARD_NUM)
end

function PDKLocalData:setDiFen(num)
    self:setUserLocalData(DI_FEN, num)
end

function PDKLocalData:getDiFen()
    return self:getUserLocalData(DI_FEN)
end

function PDKLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function PDKLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function PDKLocalData:setRenShu(num)
    self:setUserLocalData(REN_SHU, num)
end

function PDKLocalData:getRenShu()
    return self:getUserLocalData(REN_SHU)
end

function PDKLocalData:setPaiZhang(num)
    self:setUserLocalData(PAI_ZHANG, num)
end

function PDKLocalData:getPaiZhang()
    return self:getUserLocalData(PAI_ZHANG)
end

function PDKLocalData:setHouZi(num)
    self:setUserLocalData(HOU_ZI, num)
end

function PDKLocalData:getHouZi()
    return self:getUserLocalData(HOU_ZI)
end

function PDKLocalData:setZDBKC(num)
    self:setUserLocalData(ZDBKC, num)
end

function PDKLocalData:getZDBKC()
    return self:getUserLocalData(ZDBKC)
end

return PDKLocalData 
