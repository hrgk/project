local BaseLocalUserData = import(".BaseLocalUserData")
local SYBPLocalData = class("SYBPLocalData", BaseLocalUserData)
local MYKEY = "SYBP_RULE"

function SYBPLocalData:ctor()
    SYBPLocalData.super.ctor(self)
end

function SYBPLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function SYBPLocalData:getRuleInfo()
    local guiZe = {
        ["zhifu"] = 1,
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
    end
    return guiZe
end

return SYBPLocalData 
