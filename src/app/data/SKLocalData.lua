local BaseLocalUserData = import(".BaseLocalUserData")
local SKLocalData = class("SKLocalData", BaseLocalUserData)
local MYKEY = "SK_RULE"
local SK_SORT = "SK_SORT"

function SKLocalData:ctor()
    SKLocalData.super.ctor(self)
end

function SKLocalData:setRuleInfo(info)
    self:setUserLocalData(MYKEY, info)
end

function SKLocalData:getRuleInfo()
    local guiZe = {
        ["jushu"] = 1,
        ["zhifu"] = 1,
        ["mp"] = 1,
        ["jg"] = 2,
        ["sk"] = 1,
    }
    local info = self:getUserLocalData(MYKEY)
    if info and info ~= "" then
        guiZe = json.decode(info)
    end
    return guiZe
end

function SKLocalData:getSort()
    local info = self:getUserLocalData(SK_SORT)
    if info == nil or info == "" then
        return 1
    end

    return tonumber(info)
end

function SKLocalData:setSort(sort)
    self:setUserLocalData(SK_SORT, sort)
end

return SKLocalData 
