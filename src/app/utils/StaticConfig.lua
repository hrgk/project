local StaticConfig = {}

StaticConfig.configPath_ = DATA_PATH .. "config.txt"
StaticConfig.config_ = {}

function StaticConfig:get(key)
    if not self.config_ then
        return
    end
    return self.config_[key]
end

function StaticConfig:loadConfig()
    if not io.exists(self.configPath_) then
        return false
    end

    local data = io.readfile(self.configPath_)
    local result = json.decode(data)
    if not result or not result.timestamp then
        return false
    end
    self.config_ = result
    return true
end

function StaticConfig:checkConfigUpdate(startCb)
    if not self:loadConfig() then
        return self:downloadConfigData_(startCb)
    end

    local function onSuccess(data)
        local result = json.decode(data)
        dump(result)
        if not result or not result.timestamp then
            return self:downloadConfigData_(startCb)
        end
        if result.timestamp and result.timestamp == self.config_.timestamp then
            if startCb then
                startCb()
            end
            return
        end
        return self:downloadConfigData_(startCb)
    end

    local function onFailed(data)
        printInfo("gailun.HTTP.get SYSTEM_CHECK_URL  failed")
        if startCb then startCb() end
    end
        print("======SYSTEM_CHECK_URL======",SYSTEM_CHECK_URL)

    gailun.HTTP.get(SYSTEM_CHECK_URL, onSuccess, onFailed, 3)
end

function StaticConfig:downloadConfigData_(startCb)
    local function onSuccess(data)
        local result = json.decode(data)
        if not result or not result.timestamp then
            printInfo("gailun.HTTP.get [GAME_CONFIG_URL]  no result data")
            if startCb then startCb() end
            return
        end

        io.writefile(self.configPath_, data)
        self.config_ = result
        if startCb then startCb() end
    end

    local function onFailed(event)
        printInfo("gailun.HTTP.get([GAME_CONFIG_URL]  failed")
        if startCb then startCb() end
    end
    print("======SYSTEM_CONFIG_URL======",SYSTEM_CONFIG_URL)
    gailun.HTTP.get(SYSTEM_CONFIG_URL, onSuccess, onFailed, 6)
end

return StaticConfig
