local BaseLocalUserData = import(".BaseLocalUserData")
local HHQMTLocalData = class("HHQMTLocalData", BaseLocalUserData)
local MYKEY = "HHQMT_RULE"

function HHQMTLocalData:ctor()
    HHQMTLocalData.super.ctor(self)
end

function HHQMTLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function HHQMTLocalData:getRuleInfo()
    local guiZe = {
        ["ct"] = 1,
        ["dty"] = 1,
        ["dzh"] = 0,
        ["fd"] = 1,
        ["jushu"] = 1,
        ["wf"] = 1,
        ["rs"] = 1,
        ["zhifu"] = 1,
        ["quPai"] = 0,
        ["twoPlayerBaseXi"] = 0,
        ["qiShouTi"] = 0,
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
        if guiZe.quPai == nil then
            guiZe.quPai = 0
        end
        if guiZe.twoPlayerBaseXi == nil then
            guiZe.twoPlayerBaseXi = 0
        end
        if guiZe.qiShouTi == nil then
            guiZe.qiShouTi = 0
        end
    end
    guiZe.rs = guiZe.rs or 1
    guiZe.zhifu = guiZe.zhifu or 1
    return guiZe
end

return HHQMTLocalData 
