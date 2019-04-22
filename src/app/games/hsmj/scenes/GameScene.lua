local BaseAlgorithm = require("app.games.hsmj.utils.BaseAlgorithm")
local Nodes = import("..data.uidata.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")
local BaseScene = import("app.scenes.BaseScene")
local GameScene = class("GameScene", BaseScene)
local SiRenDingWei = import("app.views.SiRenDingWei")
local SanRenDingWei = import("app.views.SanRenDingWei")
local DismissRoomView = import("app.views.game.DismissRoomView")
local WenZiYuYin = import("app.views.WenZiYuYin")
local SelectedView = import("app.views.SelectedView")

-- require ("app.games.hsmj.utils.test")


local BIRD_SPACE_SECONDS = 2

function GameScene:getGameSceneNodes()
    return Nodes
end

function GameScene:setSceneName()
    self.name = "HSMJ3D"
end

function GameScene:ctor()
    dataCenter:tryConnectSocket()
    GameScene.super.ctor(self)
    gailun.uihelper.render(self, self:getGameSceneNodes().layers)
    self.gameOverData_ = nil
    self.playerIPList_ = {}
    local node = display.newNode():addTo(self)
    TaskQueue.clear()
    TaskQueue.init(node)
    local path1 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "1.aac"
    local path2 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "2.aac"
    local path3 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "3.aac"
    local path4 = cc.FileUtils:getInstance():getWritablePath() .. "/" .. "4.aac"
    os.remove(path1)
    os.remove(path2)
    os.remove(path3)
    os.remove(path4)
    self.isSendQuickChat_ = false
    self:initRoundOverBtn_()
    self.isMenuOpen_ = false
    self.isPlaying_ = false
    self:setSceneName()
    dump(self.name,"self.nameself.name")
    print("self.nameself.name",display.getRunningScene().name,setData:getMJHMTYPE())
end

function GameScene:onEnterTransitionFinish()
    self:checkSocketConnected_()
    self:schedule(handler(self, self.checkSocketConnected_), 2)
    display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    display.addSpriteFrames("textures/game_face.plist", "textures/game_face.png")
    display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")
    -- display.addSpriteFrames("textures/majiang.plist", "textures/majiang.png")
    display.addSpriteFrames("res/images/majiang/majiang.plist", "res/images/majiang/majiang.png")

    self:onBgLoaded_()
    self:onAllLoaded_()
    local GameSceneTest = require("app.games.hsmj.scenes.GameSceneTest")
    GameSceneTest.test(self)
    self:bindEvent()


end

function GameScene:onCleanup()
    collectgarbage("collect")
end

function GameScene:checkSocketConnected_()
    if not CHECK_NETWORK then
        return
    end
    if not dataCenter:isSocketReady() then
        dataCenter:tryConnectSocket()
    end
end

function GameScene:onBgLoaded_(texture)
    gailun.uihelper.render(self, self:getGameSceneNodes().bg, self.layerBG_)
    -- display.newSprite(texture):addTo(self.layerBG_):pos(display.cx, display.cy)
    -- self.spriteTable_ = display.newSprite(texture):addTo(self.layerTable_):pos(display.cx, display.cy)
end

function GameScene:onAllLoaded_()
    self.tableController_ = app:createConcreteController("TableController"):addTo(self.layerTable_)
    gailun.uihelper.render(self, self:getGameSceneNodes().menuLayerTree, self.layerMenu_)
    self:onEnter_()
end

function GameScene:onEnter_()
    gailun.uihelper.setTouchHandler(self.layerBG_, handler(self, self.onBgClicked_))
    gailun.uihelper.setTouchHandler(self.bgSprite_, handler(self, self.onBgClicked_))

    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.HS_MJ_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.HS_MJ_GAME_OVER, handler(self, self.onGameOver_)},
        {COMMANDS.HS_MJ_GAME_START, handler(self, self.onGameStart_)},
        {COMMANDS.LOGIN, handler(self, self.onLoginReturn_)},
        {COMMANDS.HS_MJ_ENTER_ROOM, handler(self, self.onMJEnterRoom_)},
        {COMMANDS.HS_MJ_READY, handler(self, self.onReady_)},
        {COMMANDS.HS_MJ_LEAVE_ROOM, handler(self, self.onLeaveRoom_)},
        {COMMANDS.HS_MJ_PLAYER_ENTER_ROOM, handler(self, self.onPlayerEnterRoom_)},
        {COMMANDS.HS_MJ_REQUEST_DISMISS, handler(self, self.onDismissInRequest_)},
        {COMMANDS.HS_MJ_ROOM_INFO, handler(self, self.onRoomInfo_)},
        {COMMANDS.CHANGE_SERVER, handler(self, self.onChangeServer_)},
        {COMMANDS.HS_MJ_DEBUG_CONFIG_CARD, handler(self, self.onConfigCard_)},
        {COMMANDS.HS_MJ_NOTIFY_LOCATION, handler(self, self.onNotifyLocation_)},
        {COMMANDS.HS_MJ_REQUEST_LOCATION, handler(self, self.onRequestLocation_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)

    local cls = self.tableController_:getTable().class
    local handlers = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onTableStateChanged_)},
    }
    gailun.EventUtils.create(self, self.tableController_:getTable(), self, handlers)

    self:onEnterTransitionFinish_()
    dataCenter:setConnectGameSceneCallBack(handler(self, self.onSocketConnected_))
end

function GameScene:onGameStart_()
    self.buttonStart_:hide()
end

function GameScene:onSocketClosed_()
    self.isDisconnected_ = true
    local seatID = dataCenter:getHostPlayer():getSeatID()
    if self.tableController_ == nil then return end
    self:setHostPlayerState(true)
    for k,v in pairs(self.tableController_:getSeats()) do
        if seatID == v:getSeatID() then
            v:setOffline(true)
        else
            v:setOffline(false)
        end
    end
end

function GameScene:onSocketConnected_()
    self:setHostPlayerState(false)
    if self.isDisconnected_ then
        self.isDisconnected_ = false
        -- self:onReconnectClicked_()
        return true
    else
        return false
    end
end

function GameScene:setHostPlayerState(offline)
    if self.tableController_ then
        self.tableController_:setHostPlayerState(offline)
    end
end

function GameScene:onConfigCard_(event)
     dump(event.data, "GameScene:onConfigCard_")
end

function GameScene:onReconnectClicked_(event)
    dataCenter:setConnectGameSceneCallBack(nil)
    app:enterLoginScene()
end

function GameScene:onChangeServer_(event)
    local host = event.data.host
    local port = event.data.port
    dataCenter:setHostAndPort(host, port)
    dataCenter:setChangeServer(true)
    dataCenter:setRoomID(0)
end

function GameScene:onEnterRoom_(event)
    print("--------------------onEnterRoom")
    if event.data.code ~= 0 then
        dataCenter:setRoomID(0)
        app:enterHallScene()
        return
    end 
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    self.tableController_:getTable():setTid(roomID)
end

function GameScene:onEnterTransitionFinish_()
    dataCenter:startKeepOnline()
    self:showOnStateIdle_()
    self.buttonStart_:onButtonClicked(handler(self, self.onStartClicked_))
    self.buttonStart_:hide()
    self.buttonReconnect_:onButtonClicked(handler(self, self.onReconnectClicked_))
    self.buttonInvite_:onButtonClicked(handler(self, self.onInviteClicked_))
    self.buttonVoice_:setView(self.buttonVoiceView_)
    self.buttonHuaYu_:onButtonClicked(handler(self, self.onHuaYuClicked_))
    -- self.buttonToWechat_:onButtonClicked(handler(self, self.onToWechatClicked_))
    -- self.buttonVoice_:hide()
    self.buttonOK_:onButtonClicked(handler(self, self.onButtonOKClicked_))
    self.canSort_ = true
    self.buttonCardConfig_:hide()
    if DEBUG > 0 then
    end
    -- app:createGrid(self)
    gameAudio.playMusic("sounds/majiang/game_bgm.mp3")
    -- gameAudio.stopMusic()
    dataCenter:resumeSocketMessage()
    dataCenter:setAutoEnterRoom(false)
    self.tableController_:listeningAvatarClicked(handler(self, self.onAvatarClicked_))
    self:bindReturnKeypad_()
end

function GameScene:onStartClicked_()
    self.buttonStart_:hide()
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_READY)
end

function GameScene:onWanFa_(event)
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_HSMJ,date)
end

function GameScene:onMenuClicked_(event)
    self.isMenuOpen_ = not self.isMenuOpen_
    return self.isPlaying_,self.isMenuOpen_
end

function GameScene:onHuaYuClicked_(event)
    if self.yuYinView_ == nil then
        self.yuYinView_ = WenZiYuYin.new(self.isSendQuickChat_):addTo(self.layerWindows_)
    end
    self.yuYinView_:show()
    self.yuYinView_:tanChuang(100)
end

function GameScene:onDingWeiClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_REQUEST_LOCATION)
end

function GameScene:onQuitRoomClicked_(event)
    local msg = "亲，确定要退出房间么？"
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
             dataCenter:sendOverSocket(COMMANDS.HS_MJ_LEAVE_ROOM)
        end
    end
    app:confirm(msg, callback)
end

function GameScene:onVoiceClicked_(event)
    app:createView("game.VoiceRecordView"):addTo(self.layerWindows_)
end

function GameScene:onSettingClicked_(event)
    app:createView("hall.SettingView"):addTo(self.layerWindows_)
end

function GameScene:onToWechatClicked_(event)
    local params = {
        packageName = "com.tencent.mm",
        enterName = "wechat"
    }
    gailun.native.enterApp(params)
end

function GameScene:onButtonOKClicked_(event)
    self.buttonOK_:hide()
    self.tableController_:clearAfterRoundOver_()
    TaskQueue.continue()

    local pokerTable = self.tableController_:getTable()
    pokerTable:clearRoundOverShowPai()
end

function GameScene:bindReturnKeypad_()
    if "android" ~= device.platform then
        return
    end
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:onReturnClicked_()
        end
    end)
end

function GameScene:onReturnClicked_()
    -- 这个方法不存在  建一个  防止报错
end

function GameScene:onExitTransitionStart()
    dataCenter:pauseSocketMessage()
    gameAudio.stopMusic()
end

function GameScene:onExit()
    gailun.EventUtils.clear(self)
    transition.stopTarget(self)

    dataCenter:setConnectGameSceneCallBack(nil)
end

function GameScene:onRoomInfo_(event)
    dataCenter:setOwner(event.data.creator)
    self.tableController_:doRoomInfo(event.data)
    gameLocalData:setGameRecordID(event.data.config.recordID)
    local juShu = event.data.wanChengJuShu or 0
    if event.data.status > 0 or (juShu > 0 and juShu < self.tableController_:getTable():getTotalRound()) then
        self:onStatePlaying_()
    else
        self:showOnStateIdle_()
    end
    if event.data.config.rules.autoReady == 1 then
        dataCenter:sendOverSocket(COMMANDS.HS_MJ_READY)
    end
    self.tableController_:changeUserPosByRule_()
end

function GameScene:onPlayAction_(event)
    self.tableController_:onPlayAction(event)
    if event.data.code ~= 0 then
        return
    end
end

function GameScene:showDissmissResult_(params)
    local isDissmiss = params.result == true
    local agrees = {}
    local disagrees = {}
    local function formatNickName_(list, result)
        if not list or #list < 1 then
            return
        end
        for i,v in ipairs(list) do
            local p = self.tableController_:getPlayerBySeatID(v)
            if p then
                table.insert(result, string.format("【%s】", p:getNickName()))
            end
        end
    end
    formatNickName_(params.yesSeatIDs, agrees)
    formatNickName_(params.noSeatIDs, disagrees)
    local tips = "经玩家%s同意，房间解散成功。"
    if isDissmiss then
        tips = string.format(tips, table.concat(agrees, ","))
    else
        tips = "玩家%s拒绝解散房间，房间解散失败。"
        tips = string.format(tips, table.concat(disagrees, ","))
    end
    app:alert(tips)
    self:getTable():setDismiss(isDissmiss)
    if isDissmiss then
        if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
            self.roundOverView_:setIsGameOver(true)
        end
    end
end

function GameScene:onDismissInRequest_(event)
    if event.data.result ~= nil then
        self:showDissmissResult_(event.data)
        if self.disMissView_ then
            self.disMissView_:removeSelf()
            self.disMissView_ = nil
        end
        return
    end
    if self.disMissView_ == nil then
        self.disMissView_ = DismissRoomView.new():addTo(self.layerWindows_)
        self.disMissView_:tanChuang()
    end
    local names = {}
    local myIsAgree = false
    local myIsRefuse = false
    for i,v in ipairs(event.data.yesSeatIDs) do
        local player = self.tableController_:getPlayerBySeatID(v)
        if player:getUid() == selfData:getUid() then
            myIsAgree = true
        end
        table.insert(names, player:getNickName())
    end
    local noNames = {}
    for i,v in ipairs(event.data.noSeatIDs) do
        local player = self.tableController_:getPlayerBySeatID(v)
        if player:isHost() then
            myIsRefuse = true
        end
        table.insert(noNames, player:getNickName())
    end
    self.disMissView_:setUserNames(names, noNames, myIsAgree, myIsRefuse)
    self.disMissView_:startTime(event.data.remainTime)
end

function GameScene:onChatClicked_(event)
    app:createView("game.ChatView"):addTo(self.layerWindows_)
end

function GameScene:onInviteClicked_(event)
    local data = self.tableController_:getTable():getConfigData()
    data.fen = 1
    local str = "%s,快来玩吧！"
    local roomId = self:getTable():getTid()
    local playerCount = self:getTable():getCurrPlayerCount()
    local round = self:getTable():getTotalRound()
    local queRenMsg = ""
    if data.ruleDetails.totalSeat == 4 then
        if playerCount == 1 then
            queRenMsg = "一缺三"
        elseif playerCount == 2 then
            queRenMsg = "二缺二"
        elseif playerCount == 3 then
            queRenMsg = "三缺一"
        end
    else
        if playerCount == 1 then
            queRenMsg = "一缺二"
        elseif playerCount == 2 then
            queRenMsg = "二缺一"
        end
    end

    local gamename = "宁夏划水"
    local title = gamename .. " 房间号【" .. roomId .. "】" .. queRenMsg
    local descriptionString = self.tableController_:makeShareRuleString(",")
    print(descriptionString,title)
    local description = round .."局," .. (descriptionString or "") .. "速度来玩！"

    local function callback()
    end
    display.getRunningScene():shareWeiXin(title, description, 0,callback)
end

function GameScene:showOnStateIdle_()
    self:showInvite_()
    self.tableController_:getProgreesView():showOnStateIdle_()
    self.buttonOK_:hide()
    self:showVoiceChat_()
end

function  GameScene:isShowSortButton(bool)
    self.isShowSortButton_ = bool
end

function GameScene:showVoiceChat_()
    if not CHANNEL_CONFIGS.CHAT then
        self.buttonVoice_:hide()
        return
    end
    self.buttonVoice_:show()
end

function GameScene:showInvite_()
    if not CHANNEL_CONFIGS.SHARE then
        self.buttonInvite_:hide()
        -- self.buttonToWechat_:hide()
        return
    end
    self.buttonInvite_:show()
end

function GameScene:showIPTips_()
    local params = {}
    for i=1,3 do
        local p = self.tableController_:getPlayerBySeatID(i)
        table.insert(params, p:getShowParams() or {})
    end
    local list = {}
    local hostIP = self:getHostPlayer():getIP()
    for k,v in pairs(params) do
        if v.IP and string.len(v.IP) > 0 and v.IP ~= hostIP and string.len(hostIP) > 0 then
            if not list[v.IP] then
                list[v.IP] = {string.format("%s", v.nickName)}
            else
                table.insert(list[v.IP], string.format("%s", v.nickName))
            end
        end
    end
    local showList = {}
    for _,v in pairs(list) do
        if #v > 1 then
            table.insert(showList, string.format("玩家:%s为同一IP地址", table.concat(v, ',')))
        end
    end
    if table.nums(showList) > 0 then
        self:performWithDelay(function ()
            self:clearLayerWindows()
            app:createConcreteView("game.IPTipsView", showList):addTo(self.layerWindows_)
        end, 1)
    end
end

function GameScene:clearLayerWindows()
    if self.tmpButtonOK_ ~= nil then
        return printError("can't clear layer window")
    end
    self.layerWindows_:removeAllChildren()
    self.birdView_ = nil
    self.dingWeiView_ = nil
    self.yuYinView_ = nil
end

function GameScene:onNotifyLocation_(event)
    if not event.data then
        return
    end 
    if event.data.code == 0 then
        local params = {}
        for i,v in ipairs(self.tableController_.seats_) do
            local obj = {}
            obj.ip = v:getIP()
            obj.uid = v:getUid()
            obj.name = v:getNickName()
            obj.avatar = v:getAvatarName()
            table.insert(params, obj)
        end
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        if self:getTable():getRuleDetails().totalSeat == 2 then
            self.buttonStart_:show()
        elseif 4 == self:getTable():getRuleDetails().totalSeat then
            self.dingWeiView_ = SiRenDingWei.new(params,event.data.distances,true,GAME_HSMJ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        elseif 3 == self:getTable():getRuleDetails().totalSeat then
            self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,true,GAME_HSMJ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        end
    end
end

function GameScene:isMyTable()
    return self.tableController_:isMyTable()
end

function GameScene:onRequestLocation_(event)
    if event.data then
        event.data.iskaiju = false
    end
    if event.data.code == 0 then
        local params = {}
        for i,v in ipairs(self.tableController_.seats_) do
            local obj = {}
            obj.ip = v:getIP()
            obj.uid = v:getUid()
            obj.name = v:getNickName()
            obj.avatar = v:getAvatarName()
            table.insert(params, obj)
        end
        if self.dingWeiView_ and self.dingWeiView_.isOpen then
            self.dingWeiView_:removeSelf()
            self.dingWeiView_ = nil
        end
        if self:getTable():getRuleDetails().totalSeat == 2 then
            self.buttonStart_:show()
        elseif 4 == self:getTable():getRuleDetails().totalSeat then
            self.dingWeiView_ = SiRenDingWei.new(params,event.data.distances,false,GAME_HSMJ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        elseif 3 == self:getTable():getRuleDetails().totalSeat then
            self.dingWeiView_ = SanRenDingWei.new(params,event.data.distances,false,GAME_HSMJ):addTo(self.layerWindows_)
            self.dingWeiView_:tanChuang(150)
        end
    end
end

function GameScene:showLocationTips_(data)
    if not data then
        print("showLocationTips_ error no data!")
        return
    end
    local iskaiju = data.iskaiju
    local hostSeatID = self.tableController_.hostSeatID_
    local params = {}
    local distances = {}
    -- for i = 1, 6 do
    --     data.distances[i] = i
    -- end
    for i = hostSeatID, 4 do
        local p = self.tableController_:getPlayerBySeatID(i)
        table.insert(params, p:getShowParams() or {})
    end
    for i = 1, hostSeatID - 1  do
        local p = self.tableController_:getPlayerBySeatID(i)
        table.insert(params, p:getShowParams() or {})
    end

    local adjustDistances = {
        {(data.distances[1]), (data.distances[2]), (data.distances[3]), (data.distances[4]), (data.distances[5]), (data.distances[6]),},
        {(data.distances[4]), (data.distances[5]), (data.distances[1]), (data.distances[6]), (data.distances[2]), (data.distances[3]),},
        {(data.distances[6]), (data.distances[2]), (data.distances[4]), (data.distances[3]), (data.distances[5]), (data.distances[1]),},
        {(data.distances[3]), (data.distances[5]), (data.distances[6]), (data.distances[1]), (data.distances[2]), (data.distances[4]),},
    }

    local t = checktable(adjustDistances[hostSeatID])

    for i = 1, #t do
        table.insert(distances, t[i] or -1)
    end

    for i = 1, 4 do
        distances[i] = distances[1]  or -1
    end

    self.layerWindows_:removeAllChildren()
    app:createConcreteView("game.LocationTipsView", params, distances,iskaiju):addTo(self.layerWindows_, 0, 888)
end

function GameScene:onStateIdle_(event)
    self.isPlaying_ = false
    self:showOnStateIdle_()
end

function GameScene:showOnStatePlaying_()
    self.tableController_:getProgreesView():showOnStatePlaying_()
    self.buttonInvite_:hide()
    self.buttonOK_:hide()
    self:showVoiceChat_()
end

function GameScene:onStatePlaying_(event)
    self.isPlaying_ = true
    self:showOnStatePlaying_()
end

function GameScene:onTableStateChanged_(event)
    local state = event.to
    printInfo("GameScene:onTableStateChanged_(event)" .. state)
    if state == "playing" then
        self:onStatePlaying_(event)
    elseif state == "idle" then
        self:onStateIdle_(event)
    elseif state == "checkout" then
        -- self:onStateCheckout_(event)
    else
        printInfo("Unknown Table State Of: " .. state)
    end
end

function GameScene:onDismissClicked_(event)
    local msg = ""
    if CHANNEL_CONFIGS.DIAMOND then       
        msg = "解散房间不扣钻石，是否确定解散？"
    else
        msg = "即将解散房间，是否确定解散？"
    end
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
             dataCenter:sendOverSocket(COMMANDS.HS_MJ_OWNER_DISMISS)
        end
    end
    app:confirm(msg, callback)
end

function GameScene:onAvatarClicked_(params)
    if params.isInvite then
        self:onInviteClicked_()
        return
    end
    self:clearLayerWindows()
    local view = app:createView("PlayerInfoView", params):addTo(self.layerWindows_)
    view:tanChuang(100)
    view:showInGameScenes()
end

function GameScene:onLeaveRoom_(event)
    if not event.data then
        return
    end
    self.layerWindows_:removeChildByTag(888)
    local uid = event.data.uid
    if uid ~= selfData:getUid() then
        self.tableController_:doLeaveRoom(uid)
        self:closeDingWeiView()
        return
    end
    if 1 == event.data.code then  -- 这是房间解散
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        --app:alert("房间已解散，谢谢！", function ()
        app:enterHallScene()
        --end)
        return
    end
    if 3 == event.data.code then  -- 这是房间结束解散
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        return
    end
    if 2 == event.data.code then  -- 被踢出
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        app:alert("您已被房主踢出此房间，请选择其它房间进行游戏！", function ()
            app:enterHallScene()
        end)
        return
    end
    dataCenter:setRoomID(0)
    if self:getTable():getClubID() > 0 then
        local params = {}
        params.clubID = self:getTable():getClubID()
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        return 
    end
    app:enterHallScene()
end

function GameScene:doReady_(data)
    if not data then
        return
    end

    if data.seatID == self.tableController_:getHostPlayer():getSeatID() then
        self:clearLayerWindows()
    end
    local isReady = data.isPrepare
    self.tableController_:onPlayerReady(data.seatID, isReady)
end

function GameScene:onReady_(event)
    TaskQueue.add(handler(self, self.doReady_), 0, 0, event.data)
    local p = self.tableController_:getPlayerBySeatID(event.data.seatID)
    if p:getUid() == selfData:getUid() then
        TaskQueue.continue()
    end
end

function GameScene:clearRoundResult_()
    if not self.roundResultView_ then
        return
    end
    if tolua.isnull(self.roundResultView_) then
        self.roundResultView_ = nil
        return
    end
    self.roundResultView_:removeFromParent()
    self.roundResultView_ = nil
end


local function getScore(params)
    local showList = {
        {'ziMo', "自摸%s"},
        {'jiePao', "接炮%s"},
        {'qiangGangHu', "抢杠胡%s"},
        {'fangPao', "放炮%s"},
        {'zhuangXian', "庄闲%s"},
    }
    
    local ret = 0
    for _,v in ipairs(showList) do
        local k, str = unpack(v)
        if params[k] ~= nil then
            ret = ret + params[k]
        end
    end
    return ret
end

function GameScene:doRoundOver_(data)
    if self:getTable():getRuleDetails().totalSeat == 2 then
        for i = 3,4 do
            if data.seats[i] then
                self.tableController_:setPlayerCard(i, clone(data.seats[i].handCards))
            end
        end
        for i = 3,4 do
            data.seats[i] = nil
        end
    end
    local birds = self:getTable():getBirds()
    local delay = BIRD_SPACE_SECONDS
    if birds and #birds > 0 then  -- 鸟牌展示时间
        delay = delay + #birds * 0.2 + 2
    end
    local buttonSeatID = self:getTable():getDealerSeatID()
    data.hostSeatID = self.tableController_:getHostSeatID()

    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.waiPai = p:getWaiPai()
        v.isZhuang = p:getSeatID() == buttonSeatID
        v.avatar = p:getAvatarName()
        -- p:setScore(v.totalScore)
        v.nickName = p:getNickName()
        if v.huType and (v.huType == MJ_ACTIONS.CHI_HU or v.huType == MJ_ACTIONS.QIANG_GANG_HU) then
            v.huCard = self:getTable():getLastCard()
        end
    end
    if data.isHuangZhuang == 0 and data.ifinishType == 0 then
        self.tableController_:doHuPai(data)
    end
    self:performWithDelay(function ()
        self.tableController_:doRoundOver(data)
    end, 0.01)
    local paramsData = data
    paramsData.ruleString = ""--self.tableController_:makeRuleString(' ')
    paramsData.finishTime = os.date("%Y-%m-%d %H:%M:%S")
    paramsData.oneBrid = self.tableController_:isOneBrid()
    self.inShowRoundResult_ = true
    self:performWithDelay(function ()
        self:showJieSuanSelectView(true)
        local isGameOver = not data.hasNextRound
        self:showOverBtn_(isGameOver)
        local currBirds = self:getTable():getBirds()
        paramsData.tableController_ = self.tableController_
     
        self.gameResultView_ = app:createConcreteView("game.gameResultView", paramsData, currBirds, isGameOver):addTo(self.layerWindows_)
        self.gameResultView_:setCloseHandler(handler(self, self.onRoundOverClose_))
        self.roundOverView_ = self.gameResultView_ 
    end, 0.01)
   
end

function GameScene:onRoundOverClose_()
    self.gameResultView_ = nil
    self.inShowRoundResult_ = false
    self.tableController_:clearAfterRoundOver_()
    TaskQueue.continue()
    self:showGameOver_()
end


function GameScene:onTmpButtonOKClicked_(event)
    TaskQueue.continue()
    self:clearTmpButtonOK_()
end

function GameScene:clearTmpButtonOK_()
     if self.tmpButtonOK_ then
        self.tmpButtonOK_:removeFromParent()
        self.tmpButtonOK_ = nil
    end
end

-- 一局结束
function GameScene:onRoundOver_(event)
    TaskQueue.add(handler(self, self.doRoundReview_), 0, 0, clone(event.data))
    TaskQueue.add(handler(self, self.doRoundOver_), 1, -1, event.data)
end

function GameScene:showOverBtn_(visible)
    self.resultBtn_:setVisible(visible)
    self.againBtn_:setVisible(not visible)
end

function GameScene:nextRound()
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_READY)
    self:onRoundOverClose_()
    self.jieSuanSelect_:setVisible(false)
end

function GameScene:onButtonClick_(item, eventType)
    if eventType == 2 or eventType == 3 then
        item:setScale(1)
        if eventType == 2 then
            if item:getName() == "jiesan" then
                self:sendDismissRoomCMD(true)
            elseif item:getName() == "again" then
                self:nextRound()
                self.resultBtn_:hide()
                self.againBtn_:hide()
                self.jieSanBtn_:hide()
            elseif item:getName() == "result" then
                TaskQueue.continue()
                self.resultBtn_:hide()
                self.againBtn_:hide()
                self.jieSanBtn_:hide()
                self:showJieSuanSelectView(false)
                if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
                    self.roundOverView_:removeSelf()
                    self.roundOverView_ = nil
                end
            end
        end
    elseif eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        item:setScale(0.9)
    end
end

function GameScene:doRoundReview_(data)
    local da = {}
    da.scoreInfo = {}
    da.code = 0
    for _,v in pairs(checktable(data.seats)) do
        da.scoreInfo[_] = da.scoreInfo[_] or {}
        da.scoreInfo[_].totalScore = v.totalScore
        da.scoreInfo[_].updateScore = getScore(v.scoreFrom)
        da.scoreInfo[_].seatID = v.seatID
        da.scoreInfo[_].currScore = v.totalScore
    end
    self.tableController_:doUpdateScore(da)
    self.isInRoundReView_ = true
end

function GameScene:searchSeatIDByMaxKey_(data, key)
    local list = {}
    local max = 0

    for _,v in pairs(checktable(data)) do
        if v[key] then
            max = math.max(v[key], max)
        end
    end
    for _,v in pairs(checktable(data)) do
        if max == v[key] then
            table.insert(list, v.seatID)
        end
    end
    return list
end

-- 整局游戏结束
function GameScene:onGameOver_(event)
    selfData:setNowRoomID(0)
    for key,value in ipairs(event.data.match) do
        event.data.seats[value.seatID].matchScore = value.matchScore
    end
    if self.roundOverView_ and not tolua.isnull(self.roundOverView_) then
        self:showOverBtn_(true)
    end
    TaskQueue.add(handler(self, self.doGameOver_), 0, 0, event.data)
    if TaskQueue.getTaskLength() == 1 then
        TaskQueue.continue()
    end
end

function GameScene:doGameOver_(data)
    local daYingJiaSeats = self:searchSeatIDByMaxKey_(data.seats, "totalScore")
    local zuiJiaPaoShouSeats = self:searchSeatIDByMaxKey_(data.seats, "dianPaoCount")
    local huPaiWangSeats = self:searchSeatIDByMaxKey_(data.seats, "winCount")
    data.hostSeatID = self:getHostPlayer():getSeatID()
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        v.uid = p:getUid()
        v.nickName = p:getNickName()
        v.avatar = p:getAvatarName()
        v.isFangZhu = (v.uid == self:getTable():getOwner())
        v.isDaYingJia = (v.totalScore > 0) and table.indexof(daYingJiaSeats, v.seatID) ~= false
        v.isZuiJiaPaoShou = v.dianPaoCount > 0 and table.indexof(zuiJiaPaoShouSeats, v.seatID) ~= false
        v.ishuPaiWang = v.winCount and v.winCount > 0 and table.indexof(huPaiWangSeats, v.seatID) ~= false
    end
    self.gameOverData_ = data
    self.gameOverData_.ruleString = self.tableController_:makeRuleString(' ')
    self.gameOverData_.finishTime = os.date("%Y-%m-%d %H:%M:%S")

    if not self.tableController_:getTable():isPlaying() then
        self:onRoundOverClose_()
        return
    end
    
    if self.inShowRoundResult_ then
        if self.gameResultView_ then
            self:showOverBtn_(true)
        end
        return
    end
end

function GameScene:showGameOver_()
    if not self.gameOverData_ then
        return
    end
    if self.gameOverView_ ~= nil then
        return
    end
    local data = self.gameOverData_
    self.tableController_:doGameOver(data)
    self.gameOverView_ = app:createConcreteView("game.GameOverView", data):addTo(self.layerWindows_)
    self.gameOverData_ = nil
end

function GameScene:startEnterHall_()
    app:enterHallScene()
end

function GameScene:onAboutClicked_(event)
    if not self.windowAbout_ then
        self.windowAbout_ = app:createView("windows.AboutWindow"):addTo(self):hide()
    else
        self.windowAbout_:hide()
    end
    self.windowAbout_:fadeJumpIn()
end

function GameScene:onHelpClicked_(event)
    if not self.windowHelp_ then
        self.windowHelp_ = app:createView("windows.HelpWindow"):addTo(self):hide()
    else
        self.windowHelp_:hide()
    end
    self.windowHelp_:fadeJumpIn()
end

function GameScene:onLoginReturn_(event)
    if event.data.code ~= 0 then
        app:enterLoginScene()
        return
    end
    app:clearLoading()
    if dataCenter:getRoomID() > 0 then
        dataCenter:sendEnterRoom(dataCenter:getRoomID())
    else
        app:enterHallScene()
    end
end

function GameScene:onMJEnterRoom_(event)
    if (display.getRunningScene().name == "HSMJ2D" and setData:getMJHMTYPE()+0  == 2) or (display.getRunningScene().name == "HSMJ3D" and setData:getMJHMTYPE()+0  == 1) then
        dataCenter:pauseSocketMessage()
        local roomID = event.data.roomID
        dataCenter:setRoomID(roomID)
        gailun.EventUtils.clear(self)
        app:enterGameScene(GAME_HSMJ)
        return 
    end
    if not self:onEnterRoom_(event) then
        return
    end
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
end

function GameScene:onPlayerEnterRoom_(event)
    if not event.data then
        return
    end
    self.tableController_:doPlayerSitDown(event.data)
    -- self:showIPTips_()
    -- local data = {distances={10888,278282,88484}}
    -- self:showLocationTips_(data)
end

function GameScene:showPerspectiveChange_()
    dataCenter:closeSocket()
    dataCenter:tryConnectSocket()
end

function GameScene:showMJPTypeChange_()
    dataCenter:closeSocket()
    dataCenter:tryConnectSocket()
end

-- 此功能暂缓开发
function GameScene:onWaitBigBlindsClicked_(event)
    local selected = event.target:isButtonSelected()
end

function GameScene:onConfigClicked_(event)
    display.getRunningScene():showGameSheZhi(true,GAME_HSMJ)
end

function GameScene:sendDismissRoomCMD(isAgree)
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_REQUEST_DISMISS, {agree = isAgree})
end

function GameScene:onBgClicked_(event)
    printf("{%.3f, %.3f, %d, %d}", event.x / display.width, event.y / display.height, event.x, event.y)
    -- self.tableController_:resetPopUpPokers
    if self.yuYinView_ then
        self.yuYinView_:hide()
    end
    self.tableController_:getProgreesView():menuHide_()
    self.isMenuOpen_ = false
end

function GameScene:onExitClicked_(event)
    if not dataCenter:getHostPlayer():canExit() then
        app:alert("您正在游戏中，请先站起后再退出～")
        return
    end
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_QUIT_TABLE)
end

function GameScene:searchEmptySeatID()
    return self.tableController_:searchEmptySeatID()
end

function GameScene:getTable()
    if self.tableController_ then
        return self.tableController_:getTable()
    end
end

function GameScene:getHostPlayer()
    return self.tableController_:getHostPlayer()
end

function GameScene:sendTuiChuCMD()
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_LEAVE_ROOM)
end

function GameScene:sendJieSanCMD()
    dataCenter:sendOverSocket(COMMANDS.HS_MJ_OWNER_DISMISS)
end

function GameScene:showJieSuanSelectView(visible)
    if self.jieSuanSelect_ == nil then
        self.jieSuanSelect_ = SelectedView.new(handler(self, self.jieSuanHandler_)):addTo(self.layerTop_,99):pos(display.left+350,display.bottom + 50)
    end
    self.jieSuanSelect_:setDefaults(1)
    self.jieSuanSelect_:setVisible(visible)
end

function GameScene:jieSuanHandler_(index)
    if index == 1 then
        if self.gameResultView_ then
            self.gameResultView_:show()
        elseif self.gameResultView_ then
            self.gameResultView_:show()
        else
            TaskQueue.continue()
        end
    else
        if self.gameResultView_ then
            self.gameResultView_:hide()
        elseif self.gameOverView_ then
            self.gameOverView_:hide()
        end
    end
end

function GameScene:initRoundOverBtn_()  --jxfj
    -- self.jieSanBtn_ = ccui.Button:create("res/images/setNew/jxfj.png", "res/images/setNew/jxfj.png")
    -- self.jieSanBtn_:setAnchorPoint(0.5,0.5)
    -- self.jieSanBtn_:setSwallowTouches(false)  
    -- self.jieSanBtn_:setPosition(display.cx, display.bottom + 50)  
    -- self.layerTop_:addChild(self.jieSanBtn_)
    -- self.jieSanBtn_:setName("jiesan")
    -- self.jieSanBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.againBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/playAgain.png", "res/images/paohuzi/roundOver/playAgain.png")
    self.againBtn_:setAnchorPoint(0.5,0.5)
    self.againBtn_:setSwallowTouches(false)
    self.againBtn_:setPosition(display.right - 350, display.bottom + 50)    
    self.layerTop_:addChild(self.againBtn_)
    self.againBtn_:setName("again")
    self.againBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_ = ccui.Button:create("res/images/paohuzi/roundOver/lookRezult.png", "res/images/paohuzi/roundOver/lookRezult.png")
    self.resultBtn_:setAnchorPoint(0.5,0.5)
    self.resultBtn_:setSwallowTouches(false)  
    self.resultBtn_:setPosition(display.right - 350, display.bottom + 50)  
    self.layerTop_:addChild(self.resultBtn_)
    self.resultBtn_:setName("result")
    self.resultBtn_:addTouchEventListener(handler(self, self.onButtonClick_))

    self.resultBtn_:hide()
    self.againBtn_:hide()
end

function GameScene:onButtonClick_(item, eventType)
    if eventType == 2 or eventType == 3 then
        item:setScale(1)
        if eventType == 2 then
            if item:getName() == "again" then
                self:nextRound()
                self.resultBtn_:hide()
                self.againBtn_:hide()
            elseif item:getName() == "result" then
                TaskQueue.continue()
                self.resultBtn_:hide()
                self.againBtn_:hide()
                self:showJieSuanSelectView(false)
                if self.roundOverView_ then
                    self.roundOverView_:removeSelf()
                    self.roundOverView_ = nil
                end
            end
        end
    elseif eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        item:setScale(0.9)
    end
end

function GameScene:showOverBtn_(visible)
    self.resultBtn_:setVisible(visible)
    self.againBtn_:setVisible(not visible)
end

return GameScene
