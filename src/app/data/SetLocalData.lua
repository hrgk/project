local BaseLocalUserData = import(".BaseLocalUserData")
local SetLocalData = class("SetLocalData", BaseLocalUserData)

local MUSIC = "MUSIC"
local SOUND = "SOUND"
local CDPHZ_BG_INDEX = "CDPHZ_BG_INDEX"
local PDK_BG_INDEX = "PDK_BG_INDEX"
local CDPHZ_TPTS = "CDPHZ_TPTS"
local CDPHZ_HXTS = "CDPHZ_HXTS"
local CDPHZ_CARD_TYPE = "CDPHZ_CARD_TYPE"
local CDPHZ_LAYOU_TYPE = "CDPHZ_LAYOU_TYPE"   -- layout
local ADDRESS = "ADDRESS"
local JZBQ = "JZBQ"
local PDK_PM_YYPE = "PDK_PM_YYPE"
local MUSIC_IS_CLOSED = "MUSIC_IS_CLOSED"
local SOUND_IS_CLOSED = "SOUND_IS_CLOSED"
local HSMJ_HM_TYPE = "HSMJ_HM_TYPE"
local MJ_BG_INDEX = "MJ_BG_INDEX"
local MJ_PAI_TYPE = "MJ_PAI_TYPE"
local FIRST_LAUNCH_CHECK = "FIRST_LAUNCH_CHECK"
local CDPHZ_CARD_SIZE = "CDPHZ_CARD_SIZE"
local HHQMT_CARD_TYPE = "HHQMT_CARD_TYPE"
local CDPHZ_WATER_TX = "CDPHZ_WATER_TX"

function SetLocalData:ctor()
    SetLocalData.super.ctor(self)
    if  self:getMusicState() == "" then
        self:setMusicState(1)
    end
    if  self:getSoundState() == "" then
        self:setSoundState(1)
    end
    if  self:getCDPHZCardType() == "" then
        self:setCDPHZCardType(2)
    end
    if  self:getCDPHZHXTS() == "" then
        self:setCDPHZHXTS(1)
    end
    if  self:getCDPHZTPTS() == "" then
        self:setCDPHZTPTS(1)
    end 
    if  self:getPDKPMTYPE() == "" then
        self:setPDKPMTYPE(1)
    end 

    if  self:getMusicIsCLose() == "" then
        self:setMusicIsCLose(0)
    end 

    if  self:getSoundIsCLose() == "" then
        self:setSoundIsCLose(0)
    end 

    if  self:getMJHMTYPE() == "" then
        self:setMJHMTYPE(2)
    end
    if  self:getMJPAITYPE() == "" then
        self:setMJPAITYPE(1)
    end
end

function SetLocalData:getCDPHZWaterTX()
    local nowIndex = self:getUserLocalData(CDPHZ_WATER_TX) or 0
    nowIndex = nowIndex == "" and 0 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setCDPHZWaterTX(index)
    self:setUserLocalData(CDPHZ_WATER_TX, index)
end

function SetLocalData:getCDPHZCardSize()
    local nowIndex = self:getUserLocalData(CDPHZ_CARD_SIZE) or 0
    nowIndex = nowIndex == "" and 2 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setCDPHZCardSize(index)
    self:setUserLocalData(CDPHZ_CARD_SIZE, index)
end

function SetLocalData:getMusicIsCLose()
    return self:getUserLocalData(MUSIC_IS_CLOSED)
end

function SetLocalData:setMusicIsCLose(res)
    self:setUserLocalData(MUSIC_IS_CLOSED, res)
end

function SetLocalData:getSoundIsCLose()
    return self:getUserLocalData(SOUND_IS_CLOSED)
end

function SetLocalData:setSoundIsCLose(res)
    self:setUserLocalData(SOUND_IS_CLOSED, res)
end

function SetLocalData:getPDKPMTYPE()
    return self:getUserLocalData(PDK_PM_YYPE)
end

function SetLocalData:setPDKPMTYPE(res)
    self:setUserLocalData(PDK_PM_YYPE, res)
end

function SetLocalData:getJZBQ()
    local need = self:getUserLocalData(JZBQ) or 0
    need = need == "" and 0 or need
    need = tonumber(need) == 1
    return need
end

function SetLocalData:setJZBQ(res)
    res = res and 1 or 0
    self:setUserLocalData(JZBQ, res)
end

function SetLocalData:setAddress(info)
    self:setUserLocalData(ADDRESS, info)
end

function SetLocalData:getAddress()
    local info = self:getUserLocalData(ADDRESS)
    if SPECIAL_PROJECT then
        return ADDRESS_N
    end
    if info == "" then
        return ADDRESS_HN 
    end
    return info
end

function SetLocalData:setMusicState(num)
    self:setUserLocalData(MUSIC, num)
end

function SetLocalData:getMusicState()
    return self:getUserLocalData(MUSIC)
end

function SetLocalData:setSoundState(num)
    self:setUserLocalData(SOUND, num)
end

function SetLocalData:getSoundState()
    return self:getUserLocalData(SOUND)
end

function SetLocalData:getCDPHZBgIndex()
    local nowIndex = self:getUserLocalData(CDPHZ_BG_INDEX) or 1
    nowIndex = nowIndex == "" and 1 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:getPDKBgIndex()
    local nowIndex = self:getUserLocalData(PDK_BG_INDEX) or 1
    nowIndex = nowIndex == "" and 2 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setCDPHZBgIndex(index)
    self:setUserLocalData(CDPHZ_BG_INDEX, index)
end



function SetLocalData:getCDPHZHXTS()
    local need = self:getUserLocalData(CDPHZ_HXTS) or 0
    need = need == "" and 0 or need
    need = tonumber(need) == 1
    return need
end

function SetLocalData:setPDKBgIndex(index)
    self:setUserLocalData(PDK_BG_INDEX, index)
end

function SetLocalData:setCDPHZHXTS(res)
    res = res and 1 or 0
    self:setUserLocalData(CDPHZ_HXTS, res)
end

function SetLocalData:getCDPHZTPTS()
    local need = self:getUserLocalData(CDPHZ_TPTS) or 1
    need = need == "" and 1 or need
    need = tonumber(need) == 1
    return need
end

function SetLocalData:setCDPHZTPTS(res)
    res = res and 1 or 0
    self:setUserLocalData(CDPHZ_TPTS, res)
end

function SetLocalData:getCDPHZCardType()
    local nowIndex = self:getUserLocalData(CDPHZ_CARD_TYPE) or 2
    nowIndex = nowIndex == "" and 1 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setCDPHZCardType(index)
    self:setUserLocalData(CDPHZ_CARD_TYPE, index)
end

function SetLocalData:getHHQMTCardType()
    local nowIndex = self:getUserLocalData(HHQMT_CARD_TYPE) or 1
    nowIndex = nowIndex == "" and 1 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setHHQMTCardType(index)
    self:setUserLocalData(HHQMT_CARD_TYPE, index)
end

function SetLocalData:getCDPHZCardLayout()
    local nowIndex = self:getUserLocalData(CDPHZ_LAYOU_TYPE) or 1
    nowIndex = nowIndex == "" and 1 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setCDPHZCardLayout(index)
    self:setUserLocalData(CDPHZ_LAYOU_TYPE, index)
end

function SetLocalData:getMJPAITYPE()
    return self:getUserLocalData(MJ_PAI_TYPE)
end

function SetLocalData:setMJPAITYPE(res)
    self:setUserLocalData(MJ_PAI_TYPE, res)
end

function SetLocalData:getMJHMTYPE()
    return self:getUserLocalData(HSMJ_HM_TYPE)
end

function SetLocalData:setMJHMTYPE(res)
    self:setUserLocalData(HSMJ_HM_TYPE, res)
end

function SetLocalData:getFirstLaunchCheck()
    return self:getUserLocalData(FIRST_LAUNCH_CHECK)
end

function SetLocalData:setFirstLaunchCheck()
    self:setUserLocalData(FIRST_LAUNCH_CHECK, "true")
end

function SetLocalData:getMJBgIndex()
    local nowIndex = self:getUserLocalData(MJ_BG_INDEX) or 1
    nowIndex = nowIndex == "" and 1 or nowIndex
    return tonumber(nowIndex)
end

function SetLocalData:setMJBgIndex(index)
    self:setUserLocalData(MJ_BG_INDEX, index)
end

return SetLocalData 
