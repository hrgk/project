local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local HttpApi = require("app.utils.HttpApi")
local ChannelConfig = class("ChannelConfig")

local failCount_ = 0
local configs_ = {}
local callback_
local timerContainer_ = nil

function ChannelConfig.init(timerContainer)
    assert(timerContainer)
    ChannelConfig.clear()
    timerContainer_ = timerContainer
end

function ChannelConfig.clear()
    if timerContainer_ then
        transition.stopTarget(timerContainer_)
    end
    timerContainer_ = nil
end

function ChannelConfig.loadRemote(callback)
    assert(callback and type(callback == 'function'))
    callback_ = callback
    ChannelConfig.sendPullRequest_()
end

function ChannelConfig.sendPullRequest_()
    HttpApi.getSwitchInfo(ChannelConfig.onPullSuccess_, ChannelConfig.onPullFail_)
end

function ChannelConfig.setConfigs(params)
    if not params or type(params) ~= 'table' then
        return
    end
    for k,v in pairs(params) do
        configs_[string.upper(k)] = ChannelConfig.readFlagBool(v)
    end
    ChannelConfig.resetGlobalParams()
end

function ChannelConfig.readFlagBool(flag)
    if not flag then
        return false
    end
    if type(flag) ~= "string" then
        return flag
    end
    local lower = string.lower(flag)
    if lower ~= 'true' and lower ~= 'false' then
        return flag
    end
    return lower == "true"
end

function ChannelConfig.resetGlobalParams()
    table.merge(CHANNEL_CONFIGS, configs_)
    if configs_.HTTP_ENVIRONMENT then 
        resetEnvironment(configs_.HTTP_ENVIRONMENT)
    end
end

function ChannelConfig.onPullSuccess_(data)
    local result = json.decode(data)
    if not result or 1 ~= result.status then
        return callback_(false)
    end
    ChannelConfig.setConfigs(result.data)
    callback_(true)
end

function ChannelConfig.getDelaySeconds_()
    return math.min(failCount_, 30)
end

function ChannelConfig.onPullFail_()
    failCount_ = failCount_ + 1
    local delaySeconds = ChannelConfig.getDelaySeconds_()
    timerContainer_:performWithDelay(ChannelConfig.sendPullRequest_, delaySeconds)
end

return ChannelConfig
