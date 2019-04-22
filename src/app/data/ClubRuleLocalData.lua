local BaseLocalUserData = import(".BaseLocalUserData")
local ClubRuleLocalData = class("ClubRuleLocalData", BaseLocalUserData)
local TABLE_COUNT = "CLUB_RULE_TABLE_COUNT"
local DA_SHANG_FEI = "CLUB_RULE_DA_SHANG"

function ClubRuleLocalData:ctor()
    ClubRuleLocalData.super.ctor(self)
    if  self:getTableCount() == "" then
        self:setTableCount(1)
    end 
    if  self:getDaShangFei() == "" then
        self:setDaShangFei(0)
    end 
end

function ClubRuleLocalData:setTableCount(res)
    self:setUserLocalData(TABLE_COUNT, res)
end

function ClubRuleLocalData:getTableCount()
    return self:getUserLocalData(TABLE_COUNT)
end

function ClubRuleLocalData:setDaShangFei(res)
    self:setUserLocalData(DA_SHANG_FEI, res)
end

function ClubRuleLocalData:getDaShangFei()
    return self:getUserLocalData(DA_SHANG_FEI)
end

return ClubRuleLocalData 
