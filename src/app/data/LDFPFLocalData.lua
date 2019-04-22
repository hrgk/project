local BaseLocalUserData = import(".BaseLocalUserData")
local LDFPFLocalData = class("LDFPFLocalData", BaseLocalUserData)
local MYKEY = "LDFPF_RULE"

function LDFPFLocalData:ctor()
    LDFPFLocalData.super.ctor(self)
end

function LDFPFLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function LDFPFLocalData:getRuleInfo()
    local guiZe = {
        ["zhifu"] = 1,
        ["renshu"] = 1,
        ["huxi"] = 1,
        ["piaohu"] = 0,
        ["qihu"] = 1,
        ["daniao"] = 0,
        ["fanbei"] = 0,
        ["daniao_text"] = 10,
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
    end
    return guiZe
end

return LDFPFLocalData 
