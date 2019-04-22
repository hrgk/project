local BaseLocalUserData = import(".BaseLocalUserData")
local YXPHLocalData = class("YXPHLocalData ", BaseLocalUserData)
local JU_SHU = "XT_ZPJ_JU_SHU"
local ZHONG_ZHUANG1 = "PENG_HU_ZHONG_ZHUANG1"
local ZHONG_ZHUANG2 = "PENG_HU_ZHONG_ZHUANG2"
local ZHONG_ZHUANG3 = "PENG_HU_ZHONG_ZHUANG3"


function YXPHLocalData:ctor()
    YXPHLocalData.super.ctor(self)
    if  self:getJuShu() == "" then
        self:setJuShu(1)
    end
    if  self:getZhongZhuangJiZhi1() == "" then
        self:setZhongZhuangJiZhi1(1)
    end
    if  self:getZhongZhuangJiZhi2() == "" then
        self:setZhongZhuangJiZhi2(1)
    end
    if  self:getZhongZhuangJiZhi3() == "" then
        self:setZhongZhuangJiZhi3(1)
    end
end

function YXPHLocalData:setJuShu(num)
    self:setUserLocalData(JU_SHU, num)
end

function YXPHLocalData:getJuShu()
    return self:getUserLocalData(JU_SHU)
end

function YXPHLocalData:setZhongZhuangJiZhi1(num)
    self:setUserLocalData(ZHONG_ZHUANG1, num)
end

function YXPHLocalData:getZhongZhuangJiZhi1()
    return self:getUserLocalData(ZHONG_ZHUANG1)
end

function YXPHLocalData:setZhongZhuangJiZhi2(num)
    self:setUserLocalData(ZHONG_ZHUANG2, num)
end

function YXPHLocalData:getZhongZhuangJiZhi2()
    return self:getUserLocalData(ZHONG_ZHUANG2)
end

function YXPHLocalData:setZhongZhuangJiZhi3(num)
    self:setUserLocalData(ZHONG_ZHUANG3, num)
end

function YXPHLocalData:getZhongZhuangJiZhi3()
    return self:getUserLocalData(ZHONG_ZHUANG3)
end

return YXPHLocalData  
