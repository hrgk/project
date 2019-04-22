local BaseLocalUserData = import(".BaseLocalUserData")
local ClubScoreRuleData = class("ClubScoreRuleData",BaseLocalUserData)
function ClubScoreRuleData:ctor()
    ClubScoreRuleData.super.ctor(self)
    self.rule = nil
end

function ClubScoreRuleData:setNowRule(rule)
    self.rule = rule
end

function ClubScoreRuleData:getNowRule()
    return self.rule
end

return ClubScoreRuleData