local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local DataCenter = class("DataCenter", gailun.JWModelBase)
if VS_LUA_DEBUG_OPEN == 0 then
    local loader = require("loader.loader")
    local http = require("loader.http")
end 
local TaskQueue = require("app.controllers.TaskQueue")

DataCenter.eventName = {
    DOWNLOAD_FINISH = "DOWNLOAD_FINISH"
}

-- 定义事件
DataCenter.EVENT_DATA_CHANGED = "EVENT_DATA_CHANGED"  -- 当某项值改变的时候就发起的事件
DataCenter.EVENT_NETWORK_CHANGED = "EVENT_NETWORK_CHANGED"
DataCenter.EVENT_MESSAGE = "EVENT_MESSAGE"
DataCenter.NET_DELAY_FOUND = "NET_DELAY_FOUND"  -- 网络延时秒数时间值事件
DataCenter.HTTP_MESSAGE = "HTTP_MESSAGE"
DataCenter.HTTP_MESSAGE = "HTTP_MESSAGE"
-- 定义属性
DataCenter.schema = clone(cc.mvc.ModelBase.schema)
DataCenter.schema["roomID"] = {"number", 0}  -- 所要进入的房间ID
DataCenter.schema["owner"] = {"number", 0}  -- 房间ID的所有者
DataCenter.schema["host"] = {"string", ""}  -- 游戏服域名或IP
DataCenter.schema["port"] = {"number", 0}  -- 游戏服端口
DataCenter.schema["autoEnterRoom"] = {"boolean", false}  -- 是否自动进房间

function DataCenter:ctor(properties)
    dump("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    DataCenter.super.ctor(self, properties)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self:createGetters(DataCenter.schema)

    self.objects_ = {}
    self.scheduleMap = {}
    self:initPlayer()
    self:initSystem()
    self:initNotice()

    self.socket_ = self:createSocket_()
    self.messageQueue_ = gailun.JWQueue.new()
    self.timeOutCount_ = 0
    self.scheduleMap.checkNet = scheduler.scheduleGlobal(handler(self, self.checkNetStat_), 1.1)
    self.scheduleMap.heartBeat = scheduler.scheduleGlobal(handler(self, self.heartBeat), HEART_BEAT_SECONDS)

    self.scheduleMap.checkUpdate = scheduler.scheduleGlobal(handler(self, self.checkUpdate), 3600)
    self.scheduleMap.ticketSchedule = scheduler.scheduleGlobal(handler(self, self.ticket), 0.04)

    self.beforeTime_ = gailun.utils.getTime()
end

function DataCenter:ticket()
    local nowTime = gailun.utils.getTime()
    local interval = nowTime - self.beforeTime_
    self.beforeTime_ = nowTime
    TaskQueue.ticket(nowTime, interval)
end

function DataCenter:IAPInit()
    print("·DataCenter:IAPInit()··")
    if "ios" == device.platform then
        print("ios ")
        local IAP = require("gailun_framework.modules.IAPWrapper")
        local IOSPayment = require("app.utils.IOSPayment")
        local path = device.writablePath
        local IAP_FILE_KEY = "this1Is2IA3PKey4"  -- IOS加密KEY，不能随便改动
        self.IAPWrapper = IAP.new(path, "iap_cache.log", true, IAP_FILE_KEY)
        self.IAPWrapper:loadProducts(IOS_IAP_PRODUCTS)
        IOSPayment.startListening()
    end
end

-- TODO: 清理lua虚拟机变量
function DataCenter:checkUpdate()
    local url = loader.getVersionURL_() .. "?".. gailun.utils.getTime()
    logger.Debug("url====",url)
    if url == nil then
        return
    end
    http.get(
        url,
        function (event)
            event = json.decode(event)
            logger.Debug("event====",event)
            logger.Debug("scriptVersion====",event.scriptVersion)
            if event.scriptVersion > SCRIPT_VERSION_ID then
                -- app:showTips("检测到新版本,版本ID:[" .. event.scriptVersion .. "],当前版本ID:[" .. SCRIPT_VERSION_ID .. "].请重启游戏,获得最新游戏体验!", 2)
                local function callback(bool) 
                    
                end
                app:confirm("检测到新版本,版本ID:[" .. event.scriptVersion .. "],当前版本ID:[" .. SCRIPT_VERSION_ID .. "].请重启游戏,获得最新游戏体验!",callback)

            end
        end,
        function ()
        end
    )
end

function DataCenter:setDisconnectedGameSceneCallBack(fun)
    self.disconnectedGameSceneCall_ = fun
end

function DataCenter:setConnectGameSceneCallBack(fun)
    self.connectedGameSceneCall_ = fun
end

function DataCenter:setIsLaiZi(isLizi)
    self.isLizi_ = isLizi
end

function DataCenter:getIsLaiZi()
    return self.isLizi_
end


function DataCenter:startKeepOnline()
    if self.scheduleMap.keep then
        return
    end
    self:keepOnline_()
    self.scheduleMap.keep = scheduler.scheduleGlobal(handler(self, self.keepOnline_), 5 * 60)
end

function DataCenter:setHostAndPort(host, port)
    assert(host and port > 0, "DataCenter:setHostAndPort fail.")
    self.host_ = host
    self.port_ = port
end

function DataCenter:setChangeServer(bool)
    self.isChangeServer_ = bool
end

function DataCenter:onLocationReturn(ret)
    local result = string.split(ret, ",")
    self.locationInfo_ = result
end

function DataCenter:getLocationInfo()
    if self.locationInfo_ then    
        return self.locationInfo_
    else
        return {"181", "91"}
    end
end

function DataCenter:getChangeServer()
    return self.isChangeServer_
end

function DataCenter:getAppVersionName()
    return "【版本号" .. "." .. VERSION_HOST .. "." .. SCRIPT_VERSION_ID.."】"
end

-- 设置所要进入的房间ID
function DataCenter:setRoomID(roomID)
    assert(roomID >= 0)
    self.roomID_ = roomID
end

function DataCenter:getRoomID()
    return self.roomID_
end

function DataCenter:setOwner(owner)
    assert(owner >= 0)
    self.owner_ = owner
end

function DataCenter:isMyRoom()
    if self.roomID_ <= 0 then
        return false
    end
    if self.owner_ <= 0 then
        return false
    end
    local uid = selfData:getUid()
    if uid <= 0 then
        return false
    end
    if uid ~= self.owner_ then
        return false
    end
    return true
end

function DataCenter:clearHostPlayer()
    
end

function DataCenter:setAutoEnterRoom(flag)
    self.autoEnterRoom_ = flag
end

function DataCenter:isSocketReady()
    if not self.socket_ then
        return false
    end
    if not self.socket_:isConnected() then
        return false
    end
    if self.socket_:getHost() == self.host_ and self.socket_:getPort() == self.port_ then
        return true
    end
    return false
end

function DataCenter:tryConnectSocket()
    if self:isSocketReady() then
        return
    end
    self:connectSocket()
end

function DataCenter:sendEnterRoom(roomID, withYes)
    local attr = json.encode(selfData:getShowParams())
    local x,y = unpack(dataCenter:getLocationInfo())
    local params = {roomID = checkint(roomID),x = x, y = y, data = attr}
    if withYes then
        -- params.limitip = 'yes'
    end
    self:sendOverSocket(COMMANDS.ENTER_ROOM, params)
end

function DataCenter:initPlayer()
    local path = DATA_PATH .. device.directorySeparator
    local file = path .. PLAYER_FILE_NAME
    self.playerStorage = gailun.LocalStorage.new(path, PLAYER_FILE_NAME, true, HOST_PLAYER_KEY)
    self.playerData = self.playerStorage:getAll()  -- 此项是保存玩家的基本信息的，包括用户名，密码这些关键数据

end

function DataCenter:setAllPlayerProperties(params)
    -- for i,v in ipairs(self.allPlayers_) do
    --     v:setProperties(params)
    -- end
end

function DataCenter:initSystem()
    self.system = {}
    self.systemSign = ""
    local content = io.readfile(DATA_PATH .. SYSTEM_FILE_NAME)
    if not content or string.len(content) < 2 then
        return
    end
    self.systemSign = crypt.md5(content)
    self.system = json.decode(content)
end

function DataCenter:clientBroadcast(params, seatID)
    assert(params)
    local key = GAMES_CLIENTBROADCAST[self:getCurGammeType()] or GAMES_CLIENTBROADCAST[GAME_DEFAULT]
    local cmd = COMMANDS[key] or COMMANDS.BROADCAST
    self:sendOverSocket(cmd, {data = params})
end

function DataCenter:initNotice()
    self.noticeQueue_ = gailun.JWQueue.new()
end

function DataCenter:keepOnline_()
    HttpApi.keepOnline(function (data)
        local result = json.decode(data)
        printInfo("DataCenter:keepOnline_" .. checkint(result.status))
    end, function ()
        printInfo("keepOnline_ is fail!")
    end)
end

-- 创建socket类
function DataCenter:createSocket_()
    local socket = gailun.LineSocket.new()
    socket:addEventListener(socket.EVENT_CONNECTED, handler(self, self.onSocketConnected_))
    socket:addEventListener(socket.EVENT_CLOSE, handler(self, self.onSocketClose_))
    socket:addEventListener(socket.EVENT_CLOSED, handler(self, self.onSocketClosed_))
    socket:addEventListener(socket.EVENT_CONNECT_FAILURE, handler(self, self.onSocketConnectFailure_))
    socket:addEventListener(socket.EVENT_MESSAGE, handler(self, self.onSocketMessage_))
    self:startListening_(socket)
    return socket
end

function DataCenter:closeSocket()
    self.socket_:close()
    self:resetHeartBeatTimeOut_()
end

function DataCenter:resetHeartBeatTimeOut_()
    self.timeOutCount_ = 0
end

function DataCenter:resetHeartBeatTimeOut()
    self:resetHeartBeatTimeOut_()
end

function DataCenter:incrHeartBeatTimeOut_()
    self.timeOutCount_ = self.timeOutCount_ + 1
end

function DataCenter:connectSocket()
    if not self.host_ or not self.port_ then
        printError("not self.host_ or not self.port_")
        return
    end
    if self.socket_:isInConnect() then  -- 正在连接中，直接返回
        return
    end
    print("==========connectSocket=============",self.host_ ,self.port_)
    self.socket_:connect(self.host_, self.port_)
end

function DataCenter:heartBeat()
    if not self:isSocketReady() then
        return
    end
    
    local timestamp = gailun.utils.getTime()
    self:incrHeartBeatTimeOut_()
    self:sendOverSocket(COMMANDS.HEART_BEAT, {timestamp = timestamp})
    self:doTimeOut_()
end

function DataCenter:doTimeOut_()
    if self.timeOutCount_ * HEART_BEAT_SECONDS >= 15 then  -- 超过15秒无响应，主动关闭连接
        self:closeSocket()
        if CHECK_NETWORK then
            app:showLoading(message)
            self:connectSocket()
        end
    end
end

function DataCenter:onSocketConnected_(event)
    app:clearLoading()
    if dataCenter:getChangeServer() then
        return     
    end

    local ret = false
    if self.connectedGameSceneCall_ then
        ret = self.connectedGameSceneCall_()
    end

    -- if not ret  then
        self:resetHeartBeatTimeOut_()
        local uid = selfData:getUid()
        local token = selfData:getToken()
        -- if uid == 0 then return end
        self:sendOverSocket(COMMANDS.LOGIN, {uid = uid, key = token, gameId = GAME_ID})
    -- end
end

function DataCenter:sendOverSocket(command, message)
    assert(command ~= nil)
    return self.socket_:send({cmd = command, msg = message})
end

function DataCenter:onSocketConnectFailure_(event)
    self:onLostConnection_("网络连接失败，正在重新连接...")
end

function DataCenter:onSocketClose_(event)
    self:onLostConnection_("网络连接关闭，正在重新连接...")
    if self.disconnectedGameSceneCall_ then
        self.disconnectedGameSceneCall_()
    end
end

function DataCenter:onSocketClosed_(event)
    self:onLostConnection_("网络连接断开，正在重新连接...")
end

function DataCenter:onLostConnection_(message)
    if CHECK_NETWORK then
        app:showLoading(message)
        self:tryConnectSocket()
    end
end

function DataCenter:pauseSocketMessage()
    self.pauseSocketDispatch_ = true
end

function DataCenter:resumeSocketMessage()
    self.pauseSocketDispatch_ = false
    self:dispatchAllMessageInQueue_()
end

function DataCenter:getBool(intValue)
    if intValue == nil then
        return false
    end
    local intValue = checkint(intValue)
    return 1 == intValue
end

function DataCenter:dispatchAllMessageInQueue_()
    for i = 1, 1000 do
        local vars = self.messageQueue_:pop()
        if not vars or #vars < 1 then
            break
        end
        self:dispatchSocketMessage_(vars[1])
    end
end

function DataCenter:onSocketMessage_(event)
    if event.data and event.data.cmd ~= COMMANDS.KEEP_ALIVE then
        self:resetHeartBeatTimeOut_()
        app:clearLoading()
    end

    if (display.getRunningScene().__cname == "GameScene") and (event.data and event.data.cmd ~= COMMANDS.KEEP_ALIVE and event.data.cmd ~= COMMANDS.HEART_BEAT) then
        display.getRunningScene():setHostPlayerState(false)
    end

    if self.pauseSocketDispatch_ then
        self.messageQueue_:push(event)
    else
        self:dispatchSocketMessage_(event)
    end
end

function DataCenter:dispatchSocketMessage_(event)
    self:dispatchCommand(event.data)
end

function DataCenter:dispatchCommand(data)
    local eventName = COMMAND_NAMES[data.cmd]
    if not eventName then
        printInfo("not eventName: ")
        return
    end

    if not self:hasEventListener(eventName) then
        printInfo(string.format('Message has no listener: %s', eventName))
    end
    self:dispatchEvent({name = eventName, data = data.msg})
end

function DataCenter:commandToNames_(handlers, list)
    local ret = {}
    for i,v in ipairs(handlers) do
        local cmd = checkint(v[1])
        local name = list[cmd]
        if not name then
            printInfo(cmd .. ':cmd')
        end
        assert(name, cmd)
        ret[i] = {name, v[2]}
    end
    return ret
end

function DataCenter:s2cCommandToNames(handlers)
    return self:commandToNames_(handlers, COMMAND_NAMES)
end

function DataCenter:startListening_()
    local handlers = self:s2cCommandToNames {
        {COMMANDS.HEART_BEAT, handler(self, self.onReceiveHeartBeat_)},
        {COMMANDS.KEEP_ALIVE, function (event) end},
    }
    for _,v in pairs(handlers) do
        self:addEventListener(v[1], v[2], 'HEART_BEAT')
    end
end

function DataCenter:onReceiveHeartBeat_(event)
    if not event or not event.data then
        return
    end
    local currTime = gailun.utils.getTime()
    self:resetHeartBeatTimeOut_()
    local seconds = currTime - checknumber(event.data.timestamp)
    self:dispatchEvent({name = DataCenter.NET_DELAY_FOUND, seconds = seconds})
end

-- 从有网到无网
-- 或者网络类型发生变化
-- 都要直接关连接，再重连
function DataCenter:checkNetStat_()
    local net = network.getInternetConnectionStatus()
    local available = network.isInternetConnectionAvailable()
    if self.net_ == nil then
        self.net_ = net
        self.netAvailable_ = available
        return
    end

    if self.net_ == net then  -- 网络无变化
        return
    end
    self:dispatchEvent({name = DataCenter.EVENT_NETWORK_CHANGED, available = available, from = self.net_, to = net})
    self.net_ = net
end

function DataCenter:setCurGammeType(gameType)
    self.gameType_ = gameType or GAME_DEFAULT
end

function DataCenter:getCurGammeType()
    return self.gameType_ or GAME_DEFAULT
end

function DataCenter:setCurGammeArea(gameArea)
    self.gameArea_ = gameArea or GAME_AREA_DEFAULT
end

function DataCenter:getCurGammeArea()
    return self.gameArea_ or GAME_AREA_DEFAULT
end

-- 保存基本用户信息
function DataCenter:savePlayerInfo(key, value)
    self.playerStorage:set(key, value)
end

function DataCenter:getDeviceInfo()
    local result = {}
    result.model = dataCenter.playerData.MODEL
    result.imei = dataCenter.playerData.IMEI
    result.imsi = dataCenter.playerData.IMSI
    result.mac = dataCenter.playerData.MAC
    if not result.model then
        result.model = gailun.native.getDeviceModel()
        self:savePlayerInfo('MODEL', result.model)
    end
    if not result.imei then
        result.imei = gailun.native.getIMEI()
        self:savePlayerInfo('IMEI', result.imei)
    end
    if not result.imsi then
        result.imsi = gailun.native.getIMSI()
        self:savePlayerInfo('IMSI', result.imsi)
    end
    if not result.mac then
        result.mac = gailun.native.getMAC()
        self:savePlayerInfo('MAC', result.mac)
    end
    return result
end

function DataCenter:publishHttpFail(api, failReason)
    local failReason = failReason or ""
    app:alert("您的网络异常")
    -- self:publishMessage(api, {isSuccess = false, reason = failReason}, DataCenter.HTTP_MESSAGE)
end

function DataCenter:publishHttpSuccess(api, data)
    if json.decode(data) == nil then
        app:alert("您的网络异常")
        return
    end
    self:publishMessage(api, {isSuccess = true, result = data}, DataCenter.HTTP_MESSAGE)
end

function DataCenter:publishMessage(messageName, messageData, messageType)
    if not messageName or not messageData or not messageType then
        printError("not messageName or not messageData or not messageType")
        return
    end
    if type(messageName) ~= "string" or messageName == "" then
        printError("messageName error")
        return
    end
    if type(messageData) ~= "table" then
        printError("messageData error")
        return
    end
    if type(messageType) ~= "string" or messageType == "" then
        printError("messageType error")
        return
    end
    self:dispatchEvent({name = messageName, data = messageData, type = messageType})
end

function DataCenter.exit()
    for _, v in pairs(self.scheduleMap) do
        scheduler.unscheduleGlobal(v)
    end
end

function DataCenter:download(url, path)
    gailun.HTTP.download(url, path, function (filePath)
        self:dispatchEvent({name = DataCenter.eventName.DOWNLOAD_FINISH, path = path, url = url})
    end)
end

return DataCenter
