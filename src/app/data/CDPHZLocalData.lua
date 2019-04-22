local BaseLocalUserData = import(".BaseLocalUserData")
local CDPHZLocalData = class("CDPHZLocalData", BaseLocalUserData)
local MYKEY = "CDPHZ_RULE"

function CDPHZLocalData:ctor()
    CDPHZLocalData.super.ctor(self)
end

function CDPHZLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function CDPHZLocalData:getRuleInfo()
    local guiZe = {
        ["3twk"] = 0,
        ["47h"] = 0,
        ["ct"] = 1,
        ["dty"] = 0,
        ["dzh"] = 0,
        ["fd"] = 1,
        ["hhx"] = 0,
        ["jhh"] = 0,
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

return CDPHZLocalData 
