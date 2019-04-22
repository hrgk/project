local SetView = import("app.views.hall.SetViewNew")
local UserInfoView = import("app.views.UserInfoView")
local GameInputView = import("app.views.GameInputView")
local WanFaView = import("app.views.game.WanFaView")
local TopView = import("app.views.TopView")
local ChaGuanData = import("app.data.ChaGuanData")
local logger = require("app.utils.Logger")

local BaseScene = class("BaseScene", function()
    return display.newScene("BaseScene")
end)

if display.width / display.height >= 1.92 then
    display.fixLeft = display.left + 50
    display.fixRight = display.right - 50
else
    display.fixLeft = display.left
    display.fixRight = display.right
end

function BaseScene:ctor()
    self:initView_()
    self:initClickView_()
end

function BaseScene:initClickView_()
    self.clickView = TopView.new()
    self:addChild(self.clickView, 99999999)
end

function BaseScene:setClickViewVisible_(isShow)
    self.clickView:setVisible(isShow)
end

function BaseScene:changeAddr(mainIndex, tagValue)
    setData:setAddress(mainIndex .. ":" .. tagValue)
    createRoomData:setOpenGameList({})

    if self.setAddress then
        self:setAddress()
    end
end

function BaseScene:checkAddr()
    local inf = dataCenter:getLocationInfo()
    if inf[1] == "181" and inf[2] == "91" then
        return 
    end
    
    local url = string.format("https://apis.map.qq.com/ws/geocoder/v1/?location=%s,%s&key=YUMBZ-ZLUWI-DLMGN-5WYKA-PLAKO-44B4J&get_poi=1",inf[2],inf[1])
    local http = require "loader.http"
    http.get(
        url,
        function (event)
            local info = json.decode(event)
            if info.status ~= 0 then
                return
            end
            if info.result.address_component == "湖南省" then
                self:changeAddr(ADDRESS_HN, ADDRESS_CS)
                return
            elseif info.result.address_component == "浙江省" then
                self:changeAddr(ADDRESS_ZJ, ADDRESS_JH)
                return
            elseif info.result.address_component == "宁夏回族自治区" then
                self:changeAddr(ADDRESS_NX, ADDRESS_YC)
                return
            elseif info.result.address_component == "黑龙江省" then
                self:changeAddr(ADDRESS_HLZ)
                return
            end
        end,
        function ()
        end
    )
end

function BaseScene:initView_()
    self.buttonHandlerList_ = {}
    self:loaderCsb()
    self:initElement_()
    self:updatePos_()
end

function BaseScene:updatePos_()
    if self.csbNode_ == nil then
        return
    end

    self.csbNode_:setPositionX(math.max(display.cx - DESIGN_WIDTH / 2, 0))
end

function BaseScene:bindSocketListeners()
    print("BaseScene:bindSocketListeners",COMMANDS.SHUANGKOU_ENTER_ROOM)
    print("BaseScene:bindSocketListeners",COMMANDS.DAO13_ENTER_ROOM)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.LOGIN, handler(self, self.onLoginReturn_)},
        {COMMANDS.MJ_ENTER_ROOM, handler(self, self.onMJEnterRoom_)},
        {COMMANDS.HZMJ_ENTER_ROOM, handler(self, self.onHZMJEnterRoom_)},
        {COMMANDS.CHANGE_SERVER, handler(self, self.onChangeServer_)},
        {COMMANDS.CS_MJ_ENTER_ROOM, handler(self, self.onCSMJEnterRoom_)},
        {COMMANDS.PDK_ENTER_ROOM, handler(self, self.onPdkEnterRoom_)},
        {COMMANDS.NIUNIU_ENTER_ROOM, handler(self, self.onNiuNiuEnterRoom_)},
        {COMMANDS.DTZ_ENTER_ROOM, handler(self, self.onDtzEnterRoom_)},
        {COMMANDS.SHUANGKOU_ENTER_ROOM, handler(self, self.onShuangKouEnterRoom_)},
        {COMMANDS.CDPHZ_ENTER_ROOM, handler(self, self.onPhEnterRoom_)},
        {COMMANDS.DAO13_ENTER_ROOM, handler(self, self.onDao13EnterRoom_)},
        {COMMANDS.YZCHZ_ENTER_ROOM, handler(self, self.onRZCPhEnterRoom_)},
        {COMMANDS.HS_MJ_ENTER_ROOM, handler(self, self.onHSMJEnterRoom_)},
        {COMMANDS.MMMJ_ENTER_ROOM, handler(self, self.onMMMJEnterRoom_)},
        {COMMANDS.FHHZMJ_ENTER_ROOM, handler(self, self.onFHHZMJEnterRoom_)},
        {COMMANDS.ZMZ_ENTER_ROOM, handler(self, self.onZMZEnterRoom_)},
        {COMMANDS.HHQMT_ENTER_ROOM, handler(self, self.onHHQMTEnterRoom_)},
        {COMMANDS.SYBP_ENTER_ROOM, handler(self, self.onSYBPEnterRoom_)},
        {COMMANDS.LDFPF_ENTER_ROOM, handler(self, self.onLDFPFEnterRoom_)},
        {COMMANDS.ENTER_ROOM, handler(self, self.onEnterRoom_)},
        {COMMANDS.ALL_BROADCAST, handler(self, self.onAllBroadcast_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers, true)
end

function BaseScene:onAllBroadcast_(event)
    print("============onAllBroadcast_===============")
    if event.data.type == 2 then
        app:showTips("有玩家申请加入社区")
    elseif event.data.type == 7 then

    elseif event.data.type == 9 then
        local msg = event.data.data.clubName .."社区馆长给您赠送了".. event.data.data.dou .."金豆"
        msg = msg .. "您目前的金豆为".. event.data.data.nowDou
        app:alert(msg)
    end
end

function BaseScene:bindEvent()
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.GET_CLUB_INFO, handler(self, self.onGetClubInfoHandler_))
    :addEventListener(httpMessage.GET_CLUBS, handler(self, self.onHttpMessageHandler))
    :addEventListener(httpMessage.CHECK_ROOM, handler(self, self.onCheckRoom))
    :addEventListener(httpMessage.GET_DETAILS_RESULT, handler(self, self.onGetDetailsResult))

    self:performWithDelay(function ()
        self:checkThing()
    end, 0.5)
end

function BaseScene:checkThing()
    self:checkDetailsResult()
end

function BaseScene:checkRoom()
    local roomID = dataCenter:getRoomID()
    if roomID > 0 then
        httpMessage.requestClubHttp({roomID = roomID}, httpMessage.CHECK_ROOM)
    end
end

function BaseScene:checkDetailsResult()
    local recordID = gameLocalData:getGameRecordID()
    if recordID ~= "" then
        httpMessage.requestClubHttp({recordId = recordID}, httpMessage.GET_DETAILS_RESULT)
    end
end

function BaseScene:onGetDetailsResult(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == -3 then
            -- 清理recordId
            -- gameLocalData:setGameRecordID("")
            return
        elseif data.status == 1 then
            self:showGameOver(data.data)
        end
    end
end

function BaseScene:checkRoom()                                           
    local roomID = dataCenter:getRoomID()                                

    local selfRoomID = selfData:getNowRoomID()

    if roomID > 0 and selfRoomID == roomID then                                                   
        httpMessage.requestClubHttp({roomID = roomID}, httpMessage.CHECK_ROOM)
    end                                                              
end

function BaseScene:showGameOver(data)
    local gameOverViewMap = {
        [GAME_BCNIUNIU] = {
            view = require "app.games.niuniu.views.game.GameOverView",
            isMask = true
        },
        [GAME_MJCHANGSHA] = {
            view = require "app.games.csmj.views.game.GameOverView",
        }
    }

    local gameType = data.game_type
    local gameOverInfo = gameOverViewMap[gameType]
    if gameOverInfo == nil then
        gameLocalData:setGameRecordID("")
        return
    end

    local gameFinishData = json.decode(data.game_finish_data)

    for i = 1, 10 do
        if data["uid" .. i] ~= 0 then
            gameFinishData.seats[i].avatar = data["avatar" .. i]
            gameFinishData.seats[i].uid = data["uid" .. i]
            gameFinishData.seats[i].nickName = data["name" .. i]
        end
    end

    local gameOverView = gameOverInfo.view.new(gameFinishData, function ()
    end):addTo(self)
    if gameOverInfo.isMask then
        gameOverView:tanChuang(150)
    end

    app:showTips("系统检测到您上次游戏未正常退出，现在显示上次对局结算结果!")
end

function BaseScene:onCheckRoom(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status ~= 1 then
            app:alert("当前房间已解散!", function ()
                app:enterScene("DaTingScene", nil)
            end)
        end
    end
end

function BaseScene:getLockScore()
    local data = display.getRunningScene():getTable():getConfigData()
    local config = data
    local lockScore = 0
    if data then
        if data.config then
            config = data.config
        end
        if config and config.matchType and config.matchType == 1 and config.matchConfig and config.matchConfig.score then
            lockScore = config.matchConfig.score
        end
    end
    return lockScore
end

function BaseScene:onHttpMessageHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setClubList(data.data)
            app:enterScene("ChaGuanListScene", {data.data})
        end
    end
end

function BaseScene:onGetClubInfoHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:enterScene("ClubScene", {data})
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function BaseScene:onEnterTransitionFinish()
    self:bindSocketListeners()
    self:bindEvent()
end

function BaseScene:onLoginReturn_(event)
    dump(event.data)
    print("========onLoginReturn_========",display.getRunningScene().name)
    if event.data.code ~= 0 then
        app:enterLoginScene()
        return
    end
    print(dataCenter:getRoomID(),"=======dataCenter:getRoomID()===========")
    if dataCenter:getRoomID() > 0 then
        dataCenter:sendEnterRoom(dataCenter:getRoomID())
    end
end
local times = 0
function BaseScene:onEnterRoom_(event)
    app:clearLoading()
    if event.data.isReview then
        return
    end
    times = times + 1
    if 0 == event.data.code then
        app:clearLoading()
        return true

    elseif FLAGS.TABLE_NOT_EXIST == event.data.code then  -- 房间不存在
        if dataCenter:isMyRoom() then
            dataCenter:setRoomID(0)
            dataCenter:setOwner(0)
            selfData:setNowRoomID(0)
        end
        app:alert("您输入的房间不存在或已解散！", function ()
            app:enterHallScene()
        end)
        
        return
    elseif FLAGS.IN_OTHER_ROOM == event.data.code then  -- 已经在其它房间   
        app:alert("您已经在其它的房间内！")
        return
    elseif FLAGS.TABLE_FULL == event.data.code then  -- 人数已满
        app:alert("此房间人数已满，请重新输入其它房间号！")
        return
    elseif 4 == event.data.code then  -- 被踢
        app:alert("请稍后再申请加入。")
        return
    elseif 5 == event.data.code then
        app:alert("抱歉，此房间禁止同IP一起游戏！")
        return
    elseif event.data.code == - 18 then
        app:alert("非社区成员不能进入房间")
        return
    elseif event.data.code == - 19 then
        app:alert("积分不够，请联系馆主")
        return
    elseif event.data.code == -22 then
        app:confirm("钻石不足，请充值", function (isOK)
            if not isOK then
                return
            end
            display.getRunningScene():shopHandler_()
        end)
        return
    elseif event.data.code == -32 then
        app:confirm("元宝不足，请充值", function (isOK)
            if not isOK then
                return
            end
            display.getRunningScene():shopHandler_()
        end)
        return
    elseif event.data.code == -23 then
        app:alert("您当前房间[" .. event.data.roomID .. "]已开始游戏，不能进入新房间", function ()
            dataCenter:sendEnterRoom(event.data.roomID)
        end)
        return
    elseif event.data.code == -24 then
        app:alert("账号异常,请联系俱乐部管理员", function ()
        end)
        return
    elseif 0 ~= event.data.code  then
        app:alert("未知错误：" .. checkint(event.data.code))
        return
    end
    return true
end
function BaseScene:onLeaveRoom_(event)

    if not event.data then
        return
    end
    local uid = event.data.uid
    if uid ~= selfData:getUid() then
        self.tableController_:doLeaveRoom(event.data)
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
    if -8 == event.data.code then 
        dataCenter:setAutoEnterRoom(false)
        dataCenter:setRoomID(0)
        app:enterHallScene()
        return
    end
    self:enterQianScene()
end

function BaseScene:enterQianScene()
    if self.tableController_ and self.tableController_:getTable():getClubID() > 0 then
        app:showLoading("正在返回亲友圈")
        local params = {}
        params.clubID = self.tableController_:getTable():getClubID()
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
    else
        app:enterHallScene()
    end
    gailun.EventUtils.clear(self)
end

function BaseScene:onChangeServer_(event)
    local host = event.data.host
    local port = event.data.port
    dataCenter:setHostAndPort(host, port)
    dataCenter:closeSocket()
    dataCenter:tryConnectSocket()
end

function BaseScene:onSYBPEnterRoom_(event)
    print("· HallScene:onSYBPEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    print("===========display.getRunningScene().name=============",display.getRunningScene().name)
    if display.getRunningScene().name == "SYBP" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_SYBP)
end


function BaseScene:onLDFPFEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "LDFPF" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_LDFPF,event.data.totalSeats)
end

function BaseScene:onHHQMTEnterRoom_(event)
    print("· HallScene:onHHQMTEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    print("===========display.getRunningScene().name=============",display.getRunningScene().name)
    if display.getRunningScene().name == "HHQMT" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_HHQMT)
end

function BaseScene:onRZCPhEnterRoom_(event)
    print("· HallScene:onPhEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    print("===========display.getRunningScene().name=============",display.getRunningScene().name)
    if display.getRunningScene().name == "YZCHZ" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_YZCHZ)
end

function BaseScene:onPhEnterRoom_(event)
    print("· HallScene:onPhEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    print("===========display.getRunningScene().name=============",display.getRunningScene().name)
    if display.getRunningScene().name == "CDPHZ" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_CDPHZ)
end

function BaseScene:onHZMJEnterRoom_(event)
    print("· HallScene:onMJEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "GAME_MJHONGZHONG2D" or display.getRunningScene().name == "GAME_MJHONGZHONG3D" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_MJHONGZHONG)
end

function BaseScene:onMJEnterRoom_(event)
    print("· HallScene:onMJEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "GAME_MJZHUANZHUAN2D" or display.getRunningScene().name == "GAME_MJZHUANZHUAN3D" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_MJZHUANZHUAN)
end

function BaseScene:onXTMJEnterRoom_(event)
    print("· HallScene:onXTMJEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "XIANGTANAMJ" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_MJXIANGTAN)
end

function BaseScene:onFHHZMJEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "GAME_FHHZMJ3D" or  display.getRunningScene().name == "GAME_FHHZMJ2D" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_FHHZMJ)
end

--onZMZEnterRoom_
function BaseScene:onZMZEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "NXZMZ" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_FHLMZ)
end

function BaseScene:onHSMJEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "HSMJ2D" or  display.getRunningScene().name == "HSMJ3D" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_HSMJ)
end

function BaseScene:onMMMJEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "MMMJ" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_MMMJ)
end

function BaseScene:onCSMJEnterRoom_(event)
    print("· HallScene:onCSMJEnterRoom_(event)··")
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "CSMJ2D" or display.getRunningScene().name == "CSMJ3D" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_MJCHANGSHA)
end

function BaseScene:onPdkEnterRoom_(event)
    dump({"=========onPdkEnterRoom_=========="})
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "PAODEKUAI" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_PAODEKUAI)
end

function BaseScene:onZpjEnterRoom_(event)
    dump({"=========onZpjEnterRoom_=========="})
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "ZHUPOJIU" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_ZHUPOJIU)
end

function BaseScene:onDtzEnterRoom_(event)
    dump({"=========onDtzEnterRoom_=========="})
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "DA_TONG_ZI" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_DA_TONG_ZI)
end

function BaseScene:onShuangKouEnterRoom_(event)
    dump({"=========onShuangKouEnterRoom_=========="})
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "SHUANGKOU" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_SHUANGKOU)
end

function BaseScene:onDao13EnterRoom_(event)
    dump({"=========onDao13EnterRoom_=========="})
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "DAO13" then
        return 
    end
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_13DAO)
end

function BaseScene:onNiuNiuEnterRoom_(event)
    if not self:onEnterRoom_(event) then
        return
    end
    if display.getRunningScene().name == "NIUNIU" then
        return 
    end
    print("============onNiuNiuEnterRoom_===============")
    dataCenter:pauseSocketMessage()
    local roomID = event.data.roomID
    dataCenter:setRoomID(roomID)
    gailun.EventUtils.clear(self)
    app:enterGameScene(GAME_BCNIUNIU)
end

function BaseScene:onEnter()
end

function BaseScene:onExit()
    gailun.EventUtils.clear(self)
end

function BaseScene:loaderCsb()

end

function BaseScene:initElement_()
    if self.csbNode_ == nil then return end
    local scaleY = display.height  / DESIGN_HEIGHT
    local scaleX = display.width / DESIGN_WIDTH
    local itemScale, backScale
    if scaleX > scaleY then
        itemScale = scaleY
        backScale = scaleX
    else
        itemScale = scaleX
        backScale = scaleY
    end
    for k,v in pairs(self.csbNode_:getChildren()) do
        local x, y = v:getPosition()
        local vInfo = string.split(v:getName(), "_")
        local itemName 
        if vInfo[2] then
            itemName =  vInfo[2] .. "_"
            --print(itemName,"  itemName----------------------------------")
            self[itemName] = v
        end
        local itemType = vInfo[1]
        if itemType == "btn" then
            v.currScale = itemScale
            v:setScale(itemScale)
            self.buttonScale_ = v:getScale()
            local funcName = vInfo[2].."Handler_"
            if self[funcName] then
                self:buttonRegister(v, handler(self, self[funcName]))
            end
            if vInfo[3] == "ns" then
                v.sound = "ns"
                v.offScale = 1
            else
                v.offScale = 0.9
            end 
        elseif itemType ~= "back" then
            v:setScale(itemScale)
        end
        v:setPositionX(x * itemScale)
    end
end

function BaseScene:buttonRegister(target, func)
    target:addTouchEventListener(handler(self, self.onTouchHandler_))
    self.buttonHandlerList_[target:getName()] = func
end

function BaseScene:onTouchHandler_(sender, eventType)
    local  button = sender
    if  eventType == 0 then
        button:scale(self.buttonScale_ * button.offScale)
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        button:scale(button.currScale)
        if self.buttonHandlerList_[button:getName()] then
            print("========button.isClick=========",button.isClick)
            if button.isClick then return end
            if button.isClick ~= true then
                button.isClick = true
                self.buttonHandlerList_[button:getName()](sender)
            end
            button:performWithDelay(function()
                button.isClick = false
            end, 0.1)
        end
    elseif eventType == 3 then
        button:scale(self.buttonScale_)
    end
end

function BaseScene:initNode(node)
    if node == nil then return end
    for k,v in pairs(node:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        if vInfo[2] then
            itemName = vInfo[2] .. "_"
            self[itemName] = v
        end
        local itemType = vInfo[1]
        if itemType == "btn" or itemType == "checkBox"  then
            v.currScale = 1
            local funcName = vInfo[2].."Handler_"
            if self[funcName] then
                self:buttonRegister(v, handler(self, self[funcName]))
            end
            if vInfo[3] == "ns" then
                v.sound = "ns"
                v.offScale = 1
            else
                v.offScale = 0.9
            end
        end
    end
end

function BaseScene:showGameSheZhi(...)
    local view = SetView.new(...):addTo(self,999)
    view:tanChuang()
end

function BaseScene:showDismissView()
    local view = DismissRoomView.new(true):addTo(self)
    view:tanChuang()
end

function BaseScene:showSiRenDingWei()
    
end

function BaseScene:showSanRenDingWei()
    
end

function BaseScene:showLuYin()
    
end

function BaseScene:getShareCode()
    local uid =  selfData:getUid()
    local time = gailun.utils.getTime()
    local sign = "time=" .. time .. "&uid=" .. uid .."&key=" .. HTTP_SIGN_KEY
    sign = crypto.md5(sign)
    local obj = {}
    obj.uid = tostring(uid)
    obj.time = tostring(time)
    obj.sign = sign
    local jsonString = json.encode(obj)
    local shareCode = crypto.encodeBase64(jsonString)
    return shareCode
end

function BaseScene:shareWeiXin(title, description,inScene, callback,roomid,uid, filePath)
    local url = string.format("http://agent.gou32345.cn/Sharing/RecordSharing?RoomId=%d&Uid=%d", roomid, uid)
    local params = {
        type = "url",
        tagName = "",
        title = title,
        description = description,
        imagePath = "res/res/images/common/ic_launcher.png",
        url = url,
        inScene = inScene,
    }
    dump(params)
    gailun.native.shareWeChat(params, callback)
end

function BaseScene:gameShareWeiXin(title, description, callback,roomid,uid, recordId)
    local url = string.format("http://agent.gou32345.cn/Sharing/RecordSharing?RoomId=%d&Uid=%d", roomid, uid)
    if recordId ~= "" and recordId ~= nil then
        url = url .. "&RecordId=" .. recordId
    end
    print("gameShareWeiXin",title,description,roomID,url)
    local params = {
        type = "url",
        tagName = "",
        title = title .. "房号:" .. roomid,
        description = description,
        imagePath = "res/res/images/common/ic_launcher.png",
        url = url,
        inScene = 0,
    }
    gailun.native.shareWeChat(params, callback)
end

function BaseScene:clubInvitation(title, description, callback, uid, clubId)
    local url = string.format("http://agent.gou32345.cn/Sharing/JoinClub?ClubId=%d&Uid=%d", clubId, uid)
    print("clubInvitation",title, description, uid, clubId,url)
    local params = {
        type = "url",
        tagName = "",
        title = title,
        description = description,
        imagePath = "res/res/images/common/ic_launcher.png",
        url = url,
        inScene = 0,
    }
    gailun.native.shareWeChat(params, callback)
end

function BaseScene:shareOpenWeb(roomid,uid)
    local url = string.format("http://agent.gou32345.cn/Sharing/RecordSharing?RoomId=%d&Uid=%d", roomid, uid)
    print("shareOpenWeb",url)
    device.openURL(url)
end

function BaseScene:shareImage(fxType, title, description,inScene, callback, filePath, isShu)
    local url = StaticConfig:get("shareURL")
    local fangShi = "url"
    if fxType == 2 then
        fangShi = "img"
    end
    local sTempWidth = 128
    local sTempHeight = 72
    local bTempWidth = 1280
    local bTempHeight = 720
    if isShu then
        sTempWidth = 72
        sTempHeight = 128
        bTempWidth = 720
        bTempHeight = 1280
    end
    local params = {
        type = fangShi,
        tagName = "",
        title = title,
        description = description,
        imagePath = (filePath or "res/res/images/common/ic_launcher.png"),
        url = url or BASE_API_URL,
        inScene = inScene,
        smallWidth = sTempWidth,
        smallHeight= sTempHeight,
        bigWidth = bTempWidth,
        bigHeight = bTempHeight
    }
    gailun.native.shareWeChat(params, callback)
end

function BaseScene:initGameInput(callfunc)
    local view = GameInputView.new():addTo(self,999)
    view:tanChuang(150)
    view:setCallback(callfunc)
end

function BaseScene:initPlayerInfoView(data)
    local view = UserInfoView.new(data):addTo(self)
    view:tanChuang(150)
end

function BaseScene:getTid()
    if self.tableController_ then
        return self.tableController_:getTable():getTid()
    end
end

function BaseScene:initWanFa(gameType, data)
    local view = WanFaView.new(gameType, data):addTo(self,998)
    if gameType ~= GAME_13DAO then
        view:tanChuang(0)
    end
end

function BaseScene:clickTable()
    -- local player = self:getHostPlayer()
    -- if player then
    --     player:clickTable()
    -- end
end

function BaseScene:updateDiamonds()
    HttpApi.queryDiamondMessage(handler(self, self.onHttpDiamondReturn_), handler(self, self.onHttpDiamondFail_))
end

function BaseScene:onHttpDiamondReturn_(data)
    
end

function BaseScene:onHttpDiamondFail_()
end

function BaseScene:closeDingWeiView()
    if self.dingWeiView_ then
        self.dingWeiView_:removeSelf()
        self.dingWeiView_ = nil
    end
end

return BaseScene 
