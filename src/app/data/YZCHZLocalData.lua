local BaseLocalUserData = import(".BaseLocalUserData")
local YZCHZLocalData = class("YZCHZLocalData", BaseLocalUserData)
local MYKEY = "YZCHZ_RULE"

function YZCHZLocalData:ctor()
    YZCHZLocalData.super.ctor(self)
end

function YZCHZLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function YZCHZLocalData:getRuleInfo()
    local guiZe = {
        ["jushu"] = 1,
        ["wf"] = 1,
        ["rs"] = 1,
        ["zhifu"] = 1,
        ["xh"] = 1,
        ["wNum"] = 1,
        ["sx"] = 0,
        ["fd"] = 0,
        ["hzzh"] = 0,
        
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
    end
    guiZe.rs = 1
    guiZe.wNum = 1
    guiZe.zhifu = guiZe.zhifu or 1
    return guiZe
end

return YZCHZLocalData 
