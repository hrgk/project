local BaseLocalUserData = import(".BaseLocalUserData")
local D13LocalData = class("D13LocalData", BaseLocalUserData)
local MYKEY = "D13_RULE"

function D13LocalData:ctor()
    D13LocalData.super.ctor(self)
end

function D13LocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function D13LocalData:getRuleInfo()
    local guiZe = {
        ["jushu"] = 1,
        ["zhifu"] = 1,
        ["ms"] = 1,
        ["jf"] = 1,
        ["fs"] = 1,
        ["tspx"] = 1,
        ["rs"] = 1,
        ["mp"] = 0,
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
    end
    if not guiZe.tspx then
        guiZe.tspx = 1
    end
    if not guiZe.rs then
        guiZe.rs = 1
    end
    if not guiZe.mp then
        guiZe.mp = 1
    end
    return guiZe
end

return D13LocalData 
