local BaseScene = import("app.scenes.BaseScene")
local ChaGuanData = import("app.data.ChaGuanData")
local PlayerHead = import("app.views.PlayerHead")
local ZhuoZi = import("app.views.chaguan.ZhuoZi")
local YuanZhuo = import("app.views.chaguan.YuanZhuo")
local AddressView = import("app.views.hall.AddressView")
local SetView = import("app.views.chaguan.SetView")

local ChaGuanPlayerInfo = import("app.views.chaguan.ChaGuanPlayerInfo")
local AddMemberView = import("app.views.chaguan.AddMemberView")
local SureAddMemberView = import("app.views.chaguan.SureAddMemberView")
local MessageView = import("app.views.chaguan.message.MessageView")
local ApplyView = import("app.views.chaguan.shenQing.ApplyView")
local TiRenView = import("app.views.chaguan.TiRenView")
local CreateRoomView = import("app.views.hall.CreateRoomView")

local ClubZhanJi = import("app.views.chaguan.ClubZhanJi")
local ShengJiView = import("app.views.chaguan.ShengJiView")
local DuiJuListView = import("app.views.chaguan.DuiJuListView")
local ShengJiXiaoView = import("app.views.chaguan.ShengJiXiaoView")
local RankView = import("app.views.chaguan.rank.RankView")
local BaseScene = import("app.scenes.BaseScene")
local ClubScene = class("ClubScene", BaseScene)

local ClubGameChoice = import("app.views.chaguan.ClubGameChoice")
local MembersView = import("app.views.chaguan.clubMember.MembersView")
local SetMembersView = import("app.views.chaguan.clubMember.SetMembersView")
local FatigueValueView = import("app.views.chaguan.clubMember.FatigueValueView")
local SetMemberInfo = import("app.views.chaguan.clubMember.SetMemberInfo")
local OpeRecordsView = import("app.views.chaguan.clubMember.OpeRecordsView")
local ClubConfirmView = import("app.views.chaguan.ClubConfirmView")
local ZhuanYiView = import("app.views.chaguan.zhuanyi.ZhuanYiView")

local MMMView = import("app.views.chaguan.memManagement.MMMView")
local RecordXQView = import("app.views.chaguan.memManagement.RecordXQView")
local TYPES = gailun.TYPES

local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "layerBG_", filename = "views/club/bg/1.png", x = display.cx, y = display.cy, ap = {0.5, 0.5}},
        {type = TYPES.CUSTOM, visible = false, var = "layerContent_", class = "app.views.chaguan.ClubContent"},
        {type = TYPES.CUSTOM, visible = false, var = "layerLeft_", class = "app.views.chaguan.ClubLeft", x = display.left, y = 0},
        {type = TYPES.CUSTOM, visible = false, var = "layerHallContent_", class = "app.views.chaguan.ClubHallContent"},
        {type = TYPES.CUSTOM, var = "layerRight_", class = "app.views.chaguan.ClubMenuRight", x = display.right, y = display.cy - 38},
        {type = TYPES.CUSTOM, var = "layerTopView_", class = "app.views.chaguan.ClubTop"},
    }
}

function ClubScene:ctor(data)
    gailun.uihelper.render(self, nodes)

    ClubScene.super.ctor(self)

    chatRecordData:clearGameRecord()
    
    clubData:setCreateType("")
    -- self:initTableScroll()
    self.zhuoZiList_ = {}
    self.yuanZhuoList_ = {}
    self.floorList_ = {}
    self.data_ = data.data
    dump(self.data_,"self.data_self.data_self.data_self.data_")
    ChaGuanData.setClubInfo(data.data)
    dataCenter:tryConnectSocket()
    gameData:setClubID(self.data_.clubID)
    self:initTop()
    self:initLeft()
    self:initMenuRight()
    self.layerTopView_:setScore(data.data.dou)
    self.layerRight_:setRolePermission(data.data.permission)
    self:getJoinList(1)
    dataCenter:setRoomID(0)
    -- self:msgInit(data.data)
end

function ClubScene:onGetDetailsResult(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == -3 then
            -- 清理recordId
            gameLocalData:setGameRecordID("")
            return
        end
    end

    ClubScene.super.onGetDetailsResult(self, event)
end

function ClubScene:initZhuanYiView()
    self.zhuanYiView_ = ZhuanYiView.new():addTo(self)
    self.zhuanYiView_:tanChuang(100)
end

function ClubScene:check()
    if ChaGuanData.isMyClub() and selfData:getDiamond() < 1000 then
        -- app:alert("您的钻石不足1000，请及时购买钻石。")
    end
end

function ClubScene:initContent()
    if not self.layerHallContent_:isVisible() then
        return
    end

    ChaGuanData.requestAllSubFloor()
    ChaGuanData.requestAllRoomList()
end

function ClubScene:msgInit(data)
    httpMessage.requestClubHttp({clubID = data.clubID, matchType = self.nowTopTag}, httpMessage.GET_FLOOR)
end

function ClubScene:initTop()
    self.layerTopView_:setCallback(handler(self, self.switchTopTag))
    self.layerTopView_:setSwitchCallback(handler(self, self.switchModelCallback))
    local tag = clubData:getClubTopTag()
    if tag == 1 and not ChaGuanData.isOpenChampion() then
        tag = 0
    end

    local model = clubData:getClubModel()
    self.layerTopView_:initSwitchModel(model)
    ChaGuanData.setSwitchModel(model)
    self:switchFloorView()

    self.layerTopView_:switchTag(tag)
end

-- 0 包厢模式, 1 大厅模式
function ClubScene:switchModelCallback(model)
    ChaGuanData.setSwitchModel(model == 1 and 1 or 0)

    if model == 0 then
        httpMessage.requestClubHttp({clubID = ChaGuanData.getClubInfo().clubID, matchType = self.nowTopTag}, httpMessage.GET_FLOOR)
    elseif model == 1 then
        ChaGuanData.requestAllSubFloor()
        ChaGuanData.requestAllRoomList()
    end

    self:switchFloorView()
end

function ClubScene:switchFloorView()
    if ChaGuanData.getSwitchModel() == 0 then
        self.layerLeft_:setVisible(true)
        self.layerContent_:setVisible(true)
        self.layerHallContent_:setVisible(false)
    elseif ChaGuanData.getSwitchModel() == 1 then
        self.layerLeft_:setVisible(false)
        self.layerContent_:setVisible(false)
        self.layerHallContent_:setVisible(true)
    end
end

function ClubScene:initMenuRight()
    self.layerRight_:setPlayConfigCallback(handler(self, self.openGameChoice))
end

function ClubScene:initLeft()
    local floorData = {}
    local data = ChaGuanData.getClubFloor(self.nowTopTag) or {}
    if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
        for i = 1, 5 do
            floorData[i] = data[i] or {
                game_type = 0,
                id = 0
            }
        end
    else
        floorData = data
    end

    self.layerLeft_:setGameTypeList(floorData)
    self.layerLeft_:setCallback(handler(self, self.switchFloor))
    if #floorData == 0 then
        if self.nowTopTag == 1 then
            app:showTips("当前比赛场未设置玩法")
            self.layerTopView_:switchTag(0)
            return
        else
            local msg = "亲，目前没有设置玩法，请联系管理员或馆主"
            app:showTips(msg)
            -- app:alert(msg, function ()
            --     app:showLoading("正在进入社区")
            --     httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
            -- end)
        end
    end
end

function ClubScene:shopHandler_()
    self.layerTopView_:requestShopConf()
end

function ClubScene:showAddressView()
    local view = AddressView.new():addTo(self,999)
    view:tanChuang(150)
end

function ClubScene:openGameChoice()
    if self:getChildByName("gameChoiceView") ~= nil then
        return
    end

    local data = ChaGuanData.getClubFloor(self.nowTopTag) or {}
    local nowGame = {}
    for _, v in ipairs(data) do
        table.insert(nowGame, v.game_type)
    end

    local gameChoice = ClubGameChoice.new(nowGame, handler(self, self.choiceGameCallback)):addTo(self)
    gameChoice:setName("gameChoiceView")
end

function ClubScene:switchFloor(floor, gameData)
    if not gameData then
        return
    end

    if not self.layerLeft_:isVisible() then
        return
    end

    if gameData.game_type == 0 then
        self:openGameChoice()
    else
        clubData:setClubLeftIndex(floor)
    end

    self.nowGameConfig = gameData
    self.floorIndex = floor
    ChaGuanData.setNowFloorInfo(gameData)
    
    httpMessage.requestClubHttp({
        floor = self.nowGameConfig.id,
    }, httpMessage.GET_SUB_FLOOR)

    self:requestRoomList_()
    return true
end

function ClubScene:cheakHavePlaying(type,subElement)
    local result = nil
    if type == 1 then
        result = ChaGuanData.getRoomInfoByGameType(subElement,self.nowTopTag)
    elseif type == 2 then
        result = ChaGuanData.getRoomInfoBySubFloor(subElement)
    end
    for _, v in ipairs(result) do
        if #v.playerList > 0 then
            return true
        end 
    end
    return false
end

function ClubScene:choiceGameCallback(gameType, isClose)
    local data = ChaGuanData.getClubFloor(self.nowTopTag) or {}

    local clubID = ChaGuanData.getClubInfo().clubID
    clubData:setClubLeftIndex(self.floorIndex)
   
    local game_type = ChaGuanData.getNowFloorInfo().game_type
    if isClose == true then
        if self:cheakHavePlaying(1,game_type) then
            app:showTips("桌子坐人,无法修改")
            return 
        end
        if self.nowGameConfig.game_type == 0 then
            httpMessage.requestClubHttp({
                clubID = clubID,
                gameType = gameType,
                matchType = self.nowTopTag
            }, httpMessage.ADD_FLOOR)
        else
            httpMessage.requestClubHttp({
                clubID = clubID,
                gameType = gameType,
                floor = self.nowGameConfig.id
            }, httpMessage.EDIT_FLOOR)
        end
    else
        if self:cheakHavePlaying(1,game_type) then
            app:showTips("桌子坐人,无法删除")
            return 
        end
        httpMessage.requestClubHttp({
            clubID = clubID,
            gameType = self.nowGameConfig.game_type,
            floor = self.nowGameConfig.id,
        }, httpMessage.DEL_FLOOR)
    end
end

function ClubScene:switchTopTag(tag)
    print("switchTopTag", tag)
    self.nowTopTag = tag
    ChaGuanData.setMatchType(tag)
    self:updateFloor()
    self.layerRight_:switchTop(tag)
    clubData:setClubTopTag(tag)

    ChaGuanData.requestAllSubFloor()
    ChaGuanData.requestAllRoomList()
    return true
end

function ClubScene:onEnterTransitionFinish()
    ClubScene.super.onEnterTransitionFinish(self)
    dataCenter:startKeepOnline()
    dataCenter:resumeSocketMessage()
    if tonumber(self.data_.dismissTime) > 0 then
        -- app:alert("社区正在解散中，请谨慎操作")
        gameData:setClubFloor(1)
        gameData:setClubID(0)
        app:enterHallScene()
        return
    end
    if self.paoView_ == nil then
        self.paoView_  = app:createView("MarqueeView", display.cx+200, 550):addTo(self)
        self.paoView_:run(self.data_.notice)
    end
    self:initClubInfo_()
    self:requestRoomList_()
    -- self:kfHandler_()
    self:getClubUseRank()
    self:updateDiamonds()
    -- self:performWithDelay(function ()
        self:check()
    -- end, 1)
end

function ClubScene:initClubInfo_()
    self:initHead_()
    if gameData:getClubFloor() ~= "1" 
        and gameData:getClubFloor() ~= "2" 
        and gameData:getClubFloor() ~= "3" then
        gameData:setClubFloor(1)
    end    
    local gameConfig = ChaGuanData.getFloorGameConfig(gameData:getClubFloor()) or {}
    self.floorNume = tonumber(gameData:getClubFloor())
    self:floorChange(true)
    gameData:setClubFloor(self.floorNume)
    if not gameConfig.gameType then
        -- self:createRoomHandler_(true)
    end
end

function ClubScene:updateZhuoZiByTid_(tid)
    for k,v in pairs(self.zhuoZiList_) do
        if v:getTid() == tid then
            v:update(ChaGuanData.getRoomInfoByTid(tid))
        end
    end
end

function ClubScene:initGameRuleMsg_()
    local msg = ""
    if ChaGuanData.getGameConfig().gameType == GAME_PAODEKUAI then
        msg = self:paoDeKuaiInfo_()
    elseif ChaGuanData.getGameConfig().gameType == GAME_MJZHUANZHUAN then
        msg = self:zuanzhuanInfo_()
    elseif ChaGuanData.getGameConfig().gameType == GAME_MJCHANGSHA then
        msg = self:csmjInfo_()
    end
end

function ClubScene:paoDeKuaiInfo_()
    local gameConfig = ChaGuanData.getGameConfig()
    local rules = gameConfig.ruleDetails
    local msg = ""
    msg = msg ..rules.playerCount .. "人,"
    msg = msg ..gameConfig.totalRound .. "局,"
    msg = msg ..rules.cardCount .. "张牌,"
    if rules.red10 == 1 then
        msg = msg .."耍猴"
    end
    return msg
end

function ClubScene:zuanzhuanInfo_()
    local gameConfig = ChaGuanData.getGameConfig()
    local rules = gameConfig.ruleDetails
    local msg = ""
    msg = msg ..rules.totalSeat .. "人,"
    msg = msg ..gameConfig.totalRound .. "局,"
    msg = msg .."抓" .. rules.birdCount.."鸟,"
    if rules.birdType == 0 then
        msg = msg .."159鸟,"
    else
        msg = msg .."顺序鸟,"
    end
    if rules.isSevenPairs == 1 then
        msg = msg .."可胡7对,"
    else
        msg = msg .."不可胡7对,"
    end
    return msg
end

function ClubScene:csmjInfo_()
    local gameConfig = ChaGuanData.getGameConfig()
    local rules = gameConfig.ruleDetails
    local msg = ""
    msg = msg ..rules.totalSeat .. "人,"
    msg = msg ..gameConfig.totalRound .. "局,"
    msg = msg .."抓" .. rules.birdCount.."鸟,"
    msg = msg .. "杠后"..rules.afterGangCardsCount .. "张,"
    if rules.birdScoreType == 0 then
        msg = msg .. "中鸟加倍,"
    else
        msg = msg .. "中鸟加分,"
    end
    return msg
end

function ClubScene:niuniuInfo_()
    local gameConfig = ChaGuanData.getGameConfig()
    local rules = gameConfig.ruleDetails
    local msg = ""
    msg = msg ..rules.playerCount .. "人,"
    msg = msg ..gameConfig.totalRound .. "局,"
    if rules.score == 1 then
        msg = msg .. "底分1/2,"
    elseif rules.score == 2 then
       msg = msg .. "底分2/4,"
    elseif rules.score == 3 then
       msg = msg .. "底分3/6,"
    elseif rules.score == 4 then
       msg = msg .. "底分4/8,"
    elseif rules.score == 5 then
       msg = msg .. "底分5/10,"
    end
    if rules.zhuangType == 4 then
        msg = msg .."明牌抢庄"
    elseif rules.zhuangType == 1 then
        msg = msg .."房主庄"
    elseif rules.zhuangType == 2 then
        msg = msg .."拼十分庄"
    elseif rules.zhuangType == 3 then
        msg = msg .."顺序庄"
    end
    return msg
end

function ClubScene:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(selfData:getAvatar())
end

function ClubScene:onAllBroadcast_(event)
    if event.data.type == 2 then
        app:showTips("有玩家申请加入社区")
        ChaGuanData.setRedPoint(true)
        self:getJoinList(1)
    elseif event.data.type == 1 or event.data.type == 6 then
        if event.data.message.clubID ~= ChaGuanData.getClubInfo().clubID then
            return
        end
        
        self:stopAllActions()
        self:performWithDelay(function ()
            if ChaGuanData.getSwitchModel() == 0 and event.data.message.floor ~= tonumber(ChaGuanData.getNowFloorInfo().id) then
                return
            end

            if event.data.message.tid == selfData:getNowRoomID() then
                selfData:setNowRoomID(0)
            end
            ChaGuanData.clearRoomList()
            -- if event.data.message.isOver then
                self:requestRoomList_()

                ChaGuanData.requestAllSubFloor()
                ChaGuanData.requestAllRoomList()
            -- else
            --     ChaGuanData.updateRoomList(event.data.message)
            --     self.layerContent_:updateZhuoZiByTid_(event.data.message.tid)
            -- end
        end, 0.5)
    elseif event.data.type == 5 then
        if not ChaGuanData.isMyClub() then
            self:requestRoomList_()
            local params = {}
            params.clubID = ChaGuanData.getClubInfo().clubID
            httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        end
    elseif event.data.type == 9 then
        if ChaGuanData.getClubInfo().clubID  == event.data.data.clubId then
            local msg = event.data.data.clubId .."的馆长修改您".. event.data.data.dou .."积分"
            msg = msg .. "\n您目前的积分为".. (event.data.data.nowDou)
            app:alert(msg)
            ChaGuanData.getClubInfo().dou = event.data.data.nowDou
            self.layerTopView_:setScore(event.data.data.nowDou)
        end
    end
end

function ClubScene:onEnterForeground(event)
    if event.isBackground then
        return
    end
    self:requestRoomList_()
end

function ClubScene:requestRoomList_()
    -- if ChaGuanData.getNowFloorInfo() == nil then
    --     return
    -- end

    ChaGuanData.requestRoomList()
    -- local params = {}
    -- params.clubID = self.data_.clubID
    -- params.floor = ChaGuanData.getNowFloorInfo().id
    -- httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ROOMS)
end

function ClubScene:bindEvent()
    ClubScene.super.bindEvent(self)
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.GET_FLOOR, handler(self, self.onGetFloorHandler_))
    :addEventListener(httpMessage.ADD_FLOOR, handler(self, self.onAddFloorHandler_))
    :addEventListener(httpMessage.EDIT_FLOOR, handler(self, self.onEditFloorHandler_))
    :addEventListener(httpMessage.DEL_FLOOR, handler(self, self.onDelFloorHandler_))
    :addEventListener(httpMessage.GET_CLUB_ALL_ROOMS, handler(self, self.onGetClubAllRooms_))
    :addEventListener(httpMessage.GET_CLUB_ALL_SUB_FLOOR, handler(self, self.onGetClubAllSubFloor_))
    :addEventListener(httpMessage.SET_CLUB_BLOCK, handler(self, self.onSetClubBlock_))

    :addEventListener(httpMessage.GET_CLUB_INFO, handler(self, self.onGetClubInfoHandler_))
    :addEventListener(httpMessage.GET_CLUBS, handler(self, self.onHttpMessageHandler))
    :addEventListener(httpMessage.GET_REQUEST_JOIN_LIST, handler(self, self.onJoinListHandler))
    :addEventListener(httpMessage.GET_GAME_COUNT_LOGS, handler(self, self.onGameCountLogsHandler))
    :addEventListener(httpMessage.QUERY_CLUB_BLOCK, handler(self, self.onQueryClubBlock))
    :addEventListener(httpMessage.VERIFY_CLUB_USER, handler(self, self.onVerifyClubUser_))
    :addEventListener(httpMessage.SET_GAME_COUNT_LOGS, handler(self, self.onSetGameCountLogs_))
    :addEventListener(httpMessage.CLUB_USER_LIST, handler(self, self.onClubUserList_))
    :addEventListener(httpMessage.ADD_PLAYER_TO_CLUB, handler(self, self.onAddPlayerToClub_))
    :addEventListener(httpMessage.GET_CLUB_ROOMS, handler(self, self.onClubRooms_))
    :addEventListener(httpMessage.GET_USER_INFO, handler(self, self.onGetPlayerInfo_))
    :addEventListener(httpMessage.SET_PLAYER_PERMISSION, handler(self, self.onSetPlayerPermission_))
    :addEventListener(httpMessage.KICK_CLUB_USER, handler(self, self.onKickPlayer_))
    :addEventListener(httpMessage.REMARK_CLUB_USER, handler(self, self.onRemarkPlayer_))
    :addEventListener(httpMessage.COPY_CLUB, handler(self, self.onCopyClub_))
    :addEventListener(httpMessage.EDIT_CLUB_NOTICE, handler(self, self.onEditClubNotice_))
    :addEventListener(httpMessage.EDIT_CLUB_NAME, handler(self, self.onEditClubName_))
    :addEventListener(httpMessage.UPGRADE_CLUB, handler(self, self.onUpgradeClub_))
    :addEventListener(httpMessage.DISMISS_CLUB, handler(self, self.onDismissClub_))
    :addEventListener(httpMessage.SET_CLUB_MODE, handler(self, self.onSetClubMode_))
    :addEventListener(httpMessage.SET_CLUB_AUTO_ROOM, handler(self, self.onSetClubAutoRoom_))
    :addEventListener(httpMessage.GET_CLUB_SCORE_LIST, handler(self, self.onClubScoreList_))
    -- :addEventListener(httpMessage.GET_DETAILS_RESULT, handler(self, self.onClubDetailsResult_))
    :addEventListener(httpMessage.CLUB_CREATE_ROOM, handler(self, self.onClubCreateRoomHandler_))
    :addEventListener(httpMessage.GET_CLUB_CONFIG, handler(self, self.onClubConfigHandler_))
    :addEventListener(httpMessage.GET_CLUB_WINNER_LIST, handler(self, self.onClubWinnerListHandler_))
    :addEventListener(httpMessage.SET_CLUB_WINNER_LIST, handler(self, self.onDaYingJiaClearHandler_))
    :addEventListener(httpMessage.GET_CLUB_OWNER_INFO, handler(self, self.onClubOwnerInfoHandler_))
    :addEventListener(httpMessage.CLUB_QUICK_ROOM, handler(self, self.onClubQuickRoomHandler_))
    :addEventListener(httpMessage.GET_CLUB_SCORE_BY_UID, handler(self, self.onClubScoreByUIDHandler_))
    :addEventListener(httpMessage.TRANSFER_DOU, handler(self, self.onTransferDouZiHandler_))
    :addEventListener(httpMessage.UPGRADE_CITY, handler(self, self.onUpgradeCityHandler_))
    :addEventListener(httpMessage.UPGRADE_LOGS, handler(self, self.onUpgradeLogsHandler_))
    :addEventListener(httpMessage.SET_UPGRADE_REDLOGS, handler(self, self.onSetUpgradeRedLogsHandler_))
    :addEventListener(httpMessage.SET_LOWEST_SCORE, handler(self, self.onSetLowestSocreHandler_))
    :addEventListener(httpMessage.SET_OVERSCORE_REDUCESCORE, handler(self, self.onSetOverScoreHandler_))
    :addEventListener(httpMessage.QUIT_CLUB, handler(self, self.onQuitClubHandler_))
    :addEventListener(httpMessage.CLUB_USER_RANK, handler(self, self.onClubUserRankHandler_))
    :addEventListener(httpMessage.CLUB_TRANSFER, handler(self, self.onTransfer_))
    :addEventListener(httpMessage.CLUB_USER_DETAIL_DOU_LOGS, handler(self, self.onClubUserDetailDouLogs_))
    :addEventListener(httpMessage.CLUB_USER_DOU_LOGS, handler(self, self.onClubUserDouLogs))
    :addEventListener(httpMessage.LIST_CLUB_COMMISSION_LOG, handler(self, self.onClubClubFatigValue))
    :addEventListener(httpMessage.CLUB_INCREASE_DOU, handler(self, self.onIncreaseDou))
    :addEventListener(httpMessage.CLUB_REDUCE_DOU, handler(self, self.onReduceDou))
    :addEventListener(httpMessage.CLUB_DOU_OPER_LOGS, handler(self, self.onQueryDouOperLogs))
    :addEventListener(httpMessage.GET_CLUB_USER_ROOM_INFO, handler(self, self.onGetClubUserRoomInfo_))
    :addEventListener(httpMessage.GET_CLUB_SCORE_LIST_BY_GAME_TYPE_AND_TIME, handler(self, self.onClubScoreListByGameTypeAndTime_))
    :addEventListener(httpMessage.GET_CLUB_GAME_PLAY, handler(self, self.onGetClubGamePlay))

    :addEventListener(httpMessage.TRANSFER_CLUBUSER, handler(self, self.onTransferClubUser_))
    :addEventListener(httpMessage.TAG_CLUBUSER, handler(self, self.onTagClubUser_))
    :addEventListener(httpMessage.GET_CLUB_GAME_LOGS, handler(self, self.onGetClubGameLogs_))
    :addEventListener(httpMessage.GET_CLUB_BASE_INFO, handler(self, self.onGetClubBaseInfo_))
    :addEventListener(httpMessage.GET_CLUB_ROOM_LIST, handler(self, self.onGetClubRoomList_))
    local handlers = {
        {app.BACK_GROUND_EVENT, handler(self, self.onEnterForeground)},
    }
    gailun.EventUtils.create(self, app, self, handlers)
end

function ClubScene:getClubRoomList_(uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ROOM_LIST)
end

function ClubScene:onGetClubRoomList_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    dump(data,"datadatadatadata")
    self.recordXQView_ = RecordXQView.new(data):addTo(self)
    self.recordXQView_:tanChuang(100)
end

function ClubScene:onTransferClubUser_(event)
    local data = json.decode(event.data.result)
    dump(data,"onTransferClubUser_")
    if data == nil then
        return
    end
    if data.status == -18 then
        app:showTips("您现在不是该圈子的管理员,暂时无法转移哟~")
        return 
    end
    if data.status ~= 1 then
        return
    end
  
    app:showTips("转移成功")
end

function ClubScene:onTagClubUser_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    app:showTips("注入成功")
    self:requestClubUserList_()
end

function ClubScene:onGetClubGameLogs_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    data = data.data
    if self.MMMView_ then
        self.MMMView_:showView(5,data)
    end
end

function ClubScene:onGetClubBaseInfo_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    if self.zhuanYiView_ then
        self.zhuanYiView_:update(data.data)
    end
end


function ClubScene:onGetClubGamePlay(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    ChaGuanData.setAllGameType(data.data)
end

function ClubScene:onClubScoreListByGameTypeAndTime_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    if self.MMMView_ then
        self.MMMView_:showView(4,data.data)
    end
end


function ClubScene:onGetClubUserRoomInfo_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end
    if data.status ~= 1 then
        return
    end
    data = json.decode(data.data)
    if self.MMMView_ then
        self.MMMView_:showView(3,data)
    end
end

function ClubScene:initSetMemberInfo(data)
    if self.setMemberInfo_ and not tolua.isnull(self.setMemberInfo_) then
        self.setMemberInfo_:removeSelf()
        self.setMemberInfo_ = nil
    end
    self.setMemberInfo_ = SetMemberInfo.new(data):addTo(self)
    self.setMemberInfo_:tanChuang(100)
end

function ClubScene:requestDouOperLogs(totalScore,totalLimitScore)
    local params = {}
    self.totalScore = totalScore
    self.totalLimitScore = totalLimitScore
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_DOU_OPER_LOGS)
end

function ClubScene:requestClubUserDetailDouLogs_()
    if not ChaGuanData.isOpenChampion() then
        app:showTips("比赛场暂未开放")
        return
    end

    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_USER_DETAIL_DOU_LOGS)
end

function ClubScene:requestClubUserDouLogs_()
    if not ChaGuanData.isOpenChampion() then
        app:showTips("比赛场暂未开放")
        return
    end

    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_USER_DOU_LOGS)
end

--时间戳获取当日0点
function ClubScene:getTodayTimeStamp()
    local dateCurrectTime = os.date("*t")
    local dateTodayTime = os.time({year = dateCurrectTime.year,month = dateCurrectTime.month,day = dateCurrectTime.day,hour =0,min = 0,sec = 0})
    return dateTodayTime
end

function ClubScene:requestClubFatigValue_(fromTime,toTime)
    if not ChaGuanData.isOpenChampion() then
        app:showTips("比赛场暂未开放")
        return
    end
    local dateTodayTime = self:getTodayTimeStamp()
    local params = {}
    params.clubID = self.data_.clubID
    if fromTime and toTime then
        params.fromTime = fromTime
        params.toTime = toTime
    else
        params.fromTime = dateTodayTime
        params.toTime = os.time()
    end
    httpMessage.requestClubHttp(params, httpMessage.LIST_CLUB_COMMISSION_LOG)
end

function ClubScene:onClubUserDetailDouLogs_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initMembersView_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:initMembersView_(data)
    if self.membersView_ and not tolua.isnull(self.membersView_) then
        self.membersView_:updateList(data)
        self.membersView_:show()
        return
    end
    self.membersView_ = MembersView.new(data):addTo(self)
    self.membersView_:tanChuang(100)
end

function ClubScene:onQueryDouOperLogs(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initOpeRecordsView_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end


function ClubScene:initOpeRecordsView_(data)
    if self.opeRecordsView_ and not tolua.isnull(self.opeRecordsView_) then
        self.opeRecordsView_:updateList(data,self.totalScore,self.totalLimitScore)
        self.opeRecordsView_:show()
        return
    end
    self.opeRecordsView_ = OpeRecordsView.new(data,self.totalScore,self.totalLimitScore):addTo(self)
    self.opeRecordsView_:tanChuang(100)
end

function ClubScene:onClubUserDouLogs(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initSetMembersView_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end


function ClubScene:initSetMembersView_(data)
    if self.setMembersView_ and not tolua.isnull(self.setMembersView_) then
        self.setMembersView_:updateList(data)
        self.setMembersView_:show()
        return
    end
    self.setMembersView_ = SetMembersView.new(data):addTo(self)
    self.setMembersView_:tanChuang(100)
end

function ClubScene:onClubClubFatigValue(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initFatigValueView_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:initFatigValueView_(data)
    if self.fatigueValueView_ and not tolua.isnull(self.fatigueValueView_) then
        self.fatigueValueView_:updateList(data)
        self.fatigueValueView_:show()
        return
    end
    self.fatigueValueView_ = FatigueValueView.new(data):addTo(self)
    self.fatigueValueView_:tanChuang(100)
end

function ClubScene:increaseDou(uid,count)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    params.from_uid = uid
    params.count = count
    httpMessage.requestClubHttp(params, httpMessage.CLUB_INCREASE_DOU)
end

function ClubScene:reduceDou(uid,count)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    params.from_uid = uid
    params.count = count
    httpMessage.requestClubHttp(params, httpMessage.CLUB_REDUCE_DOU)
end

function ClubScene:onIncreaseDou(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserDouLogs_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onReduceDou(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserDouLogs_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onClubUserRankHandler_(event)
    -- dump(event.data)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            -- app:enterHallScene()
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onQuitClubHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:enterHallScene()
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onSetOverScoreHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("修改成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onSetLowestSocreHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("修改成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onSetUpgradeRedLogsHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:getUpGradeList()
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onUpgradeLogsHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            -- app:showTips("升级成功！")
            -- self.douzi_:setString(ChaGuanData.getClubInfo().dou)
            -- self.guanLiView_:updateGongXianList(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onUpgradeCityHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("升级成功！")
            -- self.douzi_:setString(ChaGuanData.getClubInfo().dou)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubScoreByUIDHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.playerInfo_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onTransferDouZiHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("赠送成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubQuickRoomHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if #data.data.roomID > 0 then
                dataCenter:sendEnterRoom(data.data.roomID[1])
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubOwnerInfoHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initGuanLi_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onDaYingJiaClearHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.clubZhanJi_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubWinnerListHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.clubZhanJi_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubConfigHandler_(event)
    -- dump(event.data)
    -- if event.data.isSuccess then
    --     local data = json.decode(event.data.result)
    --     if data.status == 1 then
    --         app:showTips("创建成功")
    --     else
    --         app:showTips(CLUB_HTTP_ERR[data.status])
    --     end
    -- end
end

function ClubScene:onClubCreateRoomHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if self.chaGuanView_:isInRoomListView() then
                self.chaGuanView_:requestRoomList()
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:updateFloor()
    local clubID = ChaGuanData.getClubInfo().clubID
    httpMessage.requestClubHttp({clubID = clubID, matchType = self.nowTopTag}, httpMessage.GET_FLOOR)
end

function ClubScene:onAddFloorHandler_(event)
    local data = json.decode(event.data.result)
    if data.status == 1 then
        self:updateFloor()
    else
    end
end

function ClubScene:onEditFloorHandler_(event)
    local data = json.decode(event.data.result)
    if data.status == 1 then
        self:updateFloor()
    else
        print("error")
        dump(data)
    end
end

function ClubScene:onDelFloorHandler_(event)
    local data = json.decode(event.data.result)
    if data.status == 1 then
        self:updateFloor()
    else
        print("error")
        dump(data)
    end
end

function ClubScene:onGetFloorHandler_(event)
    local data = json.decode(event.data.result)
    if data == nil then
        return
    end

    if data.status == 1 then
        data = data.data
        local index = clubData:getClubLeftIndex()
        if index > #data.data then
            index = 1
        end
        self:getAllGameType()
        ChaGuanData.setGameType(data.data)
        ChaGuanData.setClubFloor(data.matchType, data.data)

        self:initLeft()
        self.layerLeft_:updateByIndex(index)
    else
    end
end

function ClubScene:onGetClubInfoHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setClubInfo(data.data)
            local msg = ""

            local gameConfig = ChaGuanData.getFloorGameConfig(gameData:getClubFloor()) or {}
            if gameConfig.gameType == GAME_PAODEKUAI then
                msg = self:paoDeKuaiInfo_()
            elseif gameConfig.gameType == GAME_BCNIUNIU then
                msg = self:niuniuInfo_()
            end
            self:initClubInfo_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end


function ClubScene:initDuiJuList(data, isHuiFang)
    local view = DuiJuListView.new(data,isHuiFang):addTo(self)
    view:tanChuang(150)
    return view
end

-- function ClubScene:onClubDetailsResult_(event)
--     if event.data.isSuccess then
--         local data = json.decode(event.data.result)
--         if data.status == 1 then
--             local gameInfo = json.decode(data.data)
--             local playerTable = dataCenter:getPokerTable(tonumber(gameInfo.gameType))
--             playerTable:setTid(gameInfo.roomInfo.tid)
--             playerTable:setRoundId(gameInfo.roomInfo.roundIndex)
--             gameInfo.isClub = true
--             playerTable:setConfigData(gameInfo.roomInfo.config)
--             self:initGameOver(gameInfo)
--         else
--             app:showTips(CLUB_HTTP_ERR[data.status])
--         end
--     end
-- end

function ClubScene:onClubScoreList_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if self.MMMView_ then
                self.MMMView_:showView(4,data.data)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onSetClubAutoRoom_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data and data.status == 1 then
            self:requestRoomList_()
        else
            app:showTips(CLUB_HTTP_ERR[event.data.status])
            -- app:showTips("钻石不足")
        end
    end
end

function ClubScene:onSetClubMode_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("设置成功")
            local params = {}
            params.clubID = ChaGuanData.getClubInfo().clubID
            params.floor = gameData:getClubFloor()
            httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onDismissClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            gameData:setClubID(0)
            gameData:setClubFloor(0)
            self.floorNume = 0
            app:enterHallScene()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onUpgradeClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.chaGuanView_:requestClubInfo()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onEditClubName_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("改名成功")
            ChaGuanData.getClubInfo().name = data.data.text
            self.nickName_:setString(data.data.text)
            if self.guanLiView_ then
                self.guanLiView_:updateMingZi_(data.data.text)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onEditClubNotice_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("公告发布成功")
            ChaGuanData.getClubInfo().notice = data.data.notice
            self.paoView_:run(data.data.notice)
            --self.msg_:setString()
            if self.guanLiView_ then
                self.guanLiView_:updateGongGao_(data.data.notice)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onCopyClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("复制社区成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onRemarkPlayer_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onKickPlayer_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onTransfer_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.getClubInfo().permission = 99
            if self.playerInfo_ then
                self.playerInfo_:removeSelf()
                self.playerInfo_ = nil
            end
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onSetPlayerPermission_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            -- app:enterScene("ChaGuanListScene", {data.data})
            -- self.chaGuanView_:requestClubUserList()
            if self.playerInfo_ then
                self.playerInfo_:removeSelf()
                self.playerInfo_ = nil
            end
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onGetPlayerInfo_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if data.data.exist == false then
                app:showTips("玩家不存在")
                return
            end
            local function callback(bool, uid)
                if bool then
                    local params = {}
                    params.uid = uid
                    params.clubID = self.data_.clubID
                    httpMessage.requestClubHttp(params, httpMessage.ADD_PLAYER_TO_CLUB)
                end
            end
            SureAddMemberView.new(data.data, callback):addTo(self):tanChuang()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubRooms_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then

            ChaGuanData.setRoomList(data.data)
            if self.layerContent_:isVisible() then
                self.layerContent_:updateView(data.data)
            else
                self.layerHallContent_:updateView(data.data)
            end
        elseif data.status == -9 then
            app:showLoading("正在退出社区")
            httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onGetClubAllRooms_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setRoomList(data.data)
            if self.layerHallContent_:isVisible() then
                self.layerHallContent_:updateView(data.data)
            end
        elseif data.status == -9 then
            app:showLoading("正在退出社区")
            httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onSetClubBlock_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.data.status == 1 then
            app:showTips("操作成功")
            self:queryClubBlock()
        else
            app:showTips("操作失败")
        end
    end
end

function ClubScene:onGetClubAllSubFloor_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setAllSubGameConfig(data.data.data)
        elseif data.status == -9 then
            app:showLoading("正在退出社区")
            httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onAddPlayerToClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onClubUserList_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if self.MMMView_ then
                self.MMMView_:showView(1,data.data)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onSetGameCountLogs_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:getMessageList(0)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:onVerifyClubUser_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:getJoinList(1)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ClubScene:getAllGameType()
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_GAME_PLAY)
end

function ClubScene:getJoinList(type)
    if not (ChaGuanData.getClubInfo().permission == 0 or ChaGuanData.getClubInfo().permission == 1) then
        -- app:showTips("只有群主和管理员可以查看申请列表！")
        return
    end
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.type = type
    httpMessage.requestClubHttp(params, httpMessage.GET_REQUEST_JOIN_LIST)
end

function ClubScene:getMessageList(status)
    if not (ChaGuanData.getClubInfo().permission == 0 or ChaGuanData.getClubInfo().permission == 1) then
        return
    end
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.status = status
    httpMessage.requestClubHttp(params, httpMessage.GET_GAME_COUNT_LOGS)
end

function ClubScene:queryClubBlock()
    if not (ChaGuanData.getClubInfo().permission == 0 or ChaGuanData.getClubInfo().permission == 1) then
        return
    end
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    httpMessage.requestClubHttp(params, httpMessage.QUERY_CLUB_BLOCK)
end

function ClubScene:initApplyView(data)
    -- if self.applyList_ then
    --     self.applyList_:update(data)
    --     self.applyList_:show()
    --     return
    -- end
    -- self.applyList_ = ApplyView.new(data):addTo(self)
    -- self.applyList_:tanChuang(100) -- ClubZhanJi
end

function ClubScene:onGameCountLogsHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data == nil then return end
        if data.status == 1 then
            if self.messageList_ then
                self.messageList_:updateView(data.data)
                self.messageList_:show()
                return
            end
            self.messageList_ = MessageView.new():addTo(self)
            self.messageList_:updateView(data.data)
            self.messageList_:tanChuang(100) 
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onQueryClubBlock(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data == nil then return end
        if data.status == 1 then
            data.data.status = 2
            if self.messageList_ then
                self.messageList_:updateView(data.data)
                self.messageList_:show()
                return
            end
            self.messageList_ = MessageView.new():addTo(self)
            self.messageList_:updateView(data.data)
            self.messageList_:tanChuang(100) 
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onJoinListHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data == nil then return end
        if data.status == 1 then
            if self.MMMView_ then
                self.MMMView_:showView(2,data.data)
            end
            if data.data.type+0 == 1 then
                self.layerRight_:setVisibleJoinLisyRed(#data.data.data > 0)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:onHttpMessageHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setClubList(data.data)
            app:enterScene("ChaGuanListScene", {data.data})
        else
            app:showTips(CLUB_HTTP_ERR[data.status] or "未知错误:" .. data.status)
        end
    end
end

function ClubScene:initChaGuanView_()
    self.chaGuanView_ = app:createView("chaguan.ChaGuanView")
    self.chaGuanView_:update(self.data_.data)
    self:addChild(self.chaGuanView_)
end

function ClubScene:initAutoKaiFang(data)
    local view = app:createView("chaguan.AutoKaiFangView", data)
    self:addChild(view)
end

function ClubScene:copyClubs(params)
    local msg = "你确定要复制吗？\n\n你将创建一个新的社区\n新的社区成员和当前成员一样"
    local  function copyClubsHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.COPY_CLUB)
        end
    end
    -- app:confirm(msg, copyClubsHandler)
    local view = ClubConfirmWindow.new(msg, copyClubsHandler)
    self:addChild(view)
end

function ClubScene:distoryClubs(params)
    local msg = "你确定要解散社区吗？\n\n解散后将无法恢复"
    local  function distoryClubsHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.DISMISS_CLUB)
        end
    end
    -- app:confirm(msg, copyClubsHandler)
    local view = ClubConfirmWindow.new(msg, distoryClubsHandler)
    self:addChild(view)
end

function ClubScene:upgrdeClubs(params)
    local msg = "你确定要升级吗？\n"
    if CHANNEL_CONFIGS.DIAMOND then
        msg = msg .. "升级将消耗："..params.price.."钻石".."\n"
    end
    msg = msg .. "社区当前人数上限："..params.total.."人\n"
    msg = msg .. "升级后人数上限："..params.nextTotal.."人\n"
    msg = msg .. "(" .."如需更多人数，还可升级" .. ")"
    local  function upgradeClubsHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.UPGRADE_CLUB)
        end
    end
    -- app:confirm(msg, upgradeClubsHandler)
    local view = ClubConfirmWindow.new(msg, upgradeClubsHandler)
    self:addChild(view)
end

function ClubScene:pinBiPlayer(params, callback)
    local msg = "你确定要屏蔽该玩家吗？\n屏蔽后将无法再次接受该玩家申请"
    local  function pinBiPlayerClubsHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.VERIFY_CLUB_USER)
            if callback then
                callback()
            end
        end
    end
    -- app:confirm(msg, copyClubsHandler)
    local view = ClubConfirmWindow.new(msg, pinBiPlayerClubsHandler)
    self:addChild(view)
end

function ClubScene:refusePlayer(params, callback)
    local msg = "你确定要拒绝该玩家的申请吗？"
    local  function refusePlayerHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.VERIFY_CLUB_USER)
            if callback then
                callback()
            end
        end
    end
    -- app:confirm(msg, copyClubsHandler)
    local view = ClubConfirmWindow.new(msg, refusePlayerHandler)
    self:addChild(view)
end

function ClubScene:agreePlayer(params, callback)
    local msg = "你确定要同意该玩家的申请吗？"
    local  function agreePlayerClubsHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.VERIFY_CLUB_USER)
            if callback then
                callback()
            end
        end
    end
    -- app:confirm(msg, copyClubsHandler)
    local view = ClubConfirmWindow.new(msg, agreePlayerClubsHandler)
    self:addChild(view)
end

function ClubScene:tiPlayer(params, callback)
    local msg = "你确定要踢该玩家出茶馆吗？"
    local  function tiHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.KICK_CLUB_USER)
            if callback then
                callback()
            end
        end
    end
    -- app:confirm(msg, tiHandler)
    local view = ClubConfirmWindow.new(msg, tiHandler)
    self:addChild(view)
end

function ClubScene:shengPlayer(params)
    local msg = "你确定要升该玩家为管理员吗？"
    params.clubID = self.data_.clubID
    params.permission = 1
    local  function shengHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.SET_PLAYER_PERMISSION)
            if callback then
                callback()
            end
        end
    end
    app:confirm(msg, shengHandler)
end

function ClubScene:jiangPlayer(params, callback)
    local msg = "你确定要降该玩家为牌友吗？"
    params.clubID = self.data_.clubID
    params.permission = 99
    local  function shengHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.SET_PLAYER_PERMISSION)
            if callback then
                callback()
            end
        end
    end
    app:confirm(msg, shengHandler)
end

function ClubScene:zhuanRangPlayer(params, callback)
    local msg = "你确定要转让亲友圈吗？"
    params.clubID = self.data_.clubID
    local  function shengHandler(bool)
        if bool then
            httpMessage.requestClubHttp(params, httpMessage.CLUB_TRANSFER)
            if callback then
                callback()
            end
        end
    end
    app:confirm(msg, shengHandler)
end

--[[
    return 
    1 -- 该桌子的是之前的桌子
    2 -- 该桌子的是其它的桌子
    3 -- 之前没有进入桌子
]]
function ClubScene:cheakMyPlaying(roomid)
    local result = ChaGuanData.getRoomList()
    for _, v in ipairs(result) do
        if #v.playerList > 0 then
            if table.indexof(v.playerList, selfData:getUid()) then
                if v.tid == roomid then 
                    return 1
                else 
                    return 2
                end
            end
        end 
    end
    return 3
end

function ClubScene:enterGameRoom(roomid, data)
    print("roomId:", roomid)

    data = clone(data)
    data = data or {}
    data.playerList = data.playerList or {}
    if selfData:getNowRoomID() ~= 0 and selfData:getNowRoomID() == roomid then
        app:showLoading("正在加入房间")
        dataCenter:sendEnterRoom(roomid)
    elseif selfData:isInGame() then
        local msg = "您当前已经在其他桌子内，确认退出之前房间,加入新的房间么?"
        local function enterHandler(bool)
            if bool then
                app:showLoading("正在加入房间")
                dataCenter:sendEnterRoom(roomid)
            end
        end
        app:confirm(msg, enterHandler)
    elseif ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
        data.roomid = roomid
        self.opeRecordsView_ = ClubConfirmView.new(data,self.data_.isOwner):addTo(self)
        self.opeRecordsView_:tanChuang(100)
    else
        local msg = "你确定进入房间游戏么？"
        local res = self:cheakMyPlaying(roomid)
        if res == 2 then
            msg = "是否退出上一桌，进入此桌？"
        end
        local function enterHandler(bool)
            if bool then
                ChaGuanData.clearRoomList()
                app:showLoading("正在加入房间")
                dataCenter:sendEnterRoom(roomid)
            end
        end
        app:confirm(msg, enterHandler)
    end

   -- print(self:getChildByTag("1001").__cname)
end

function ClubScene:createRoom(data)
    local view = app:createView("chaguan.ChaGuanCreateView", data)
    self:addChild(view, 1, "1002")
end

function ClubScene:initCaoZuoView(data, clubID)
    local view = app:createView("chaguan.CaoZuoView", data, clubID)
    self:addChild(view)
end

function ClubScene:initInputView(msg,callback)
    local view = app:createView("chaguan.InputView", msg,callback)
    self:addChild(view)
    return view
end

function ClubScene:initGameOver(data)
    local view
    if data.gameType == GAME_TIANZHA then
        view = TianZhaGameOver.new(data)
    elseif data.gameType == GAME_PAODEKUAI then
        view = PaoDeKuaiGameOver.new(data)
    elseif data.gameType == GAME_BOPI then
        view = BoPiGameOver.new(data)
    elseif data.gameType == GAME_DATONGZI then
        view = DaTongZiGameOver.new(data)
    end
    self:addChild(view)
end

function ClubScene:quickEnterHandler_()
    if not ChaGuanData.isMyClub() and  self.data_.dou < ChaGuanData.getClubInfo().lowestScore then
        return app:showTips("金豆不够")
    end
    self:quickGotoRoom()
end

function ClubScene:returnHandler_()
    app:showLoading("正在进入社区")
    httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
end

function ClubScene:wanfaHandler_()
    self:createRoomHandler_()
end

function ClubScene:guanLiHandler_()
    if ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有管理员和馆主可以打开")
        return
    end
    self:getClubOwnerInfo()
end

function ClubScene:shengjiHandler_()
    ShengJiView.new():addTo(self):tanChuang(150)
end

function ClubScene:initShengJiXiaoView()
    ShengJiXiaoView.new():addTo(self):tanChuang(150)
end

function ClubScene:initGuanLi_(data)
    self.guanLiView_ = SetView.new(data):addTo(self)
    self.guanLiView_:tanChuang(100)
end

function ClubScene:zhanjiHandler_()
    if ChaGuanData.getClubInfo().permission == 1 or ChaGuanData.getClubInfo().permission == 0 then
        display.getRunningScene():requestDuiZhanList(0)
    else
        display.getRunningScene():requestDuiZhanList(1)
    end
end

function ClubScene:rankHandler_()
    if ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有管理员和馆主可以打开")
        return
    end
    RankView:new():addTo(self)
end

function ClubScene:shareHandler_()
    self:yaoQing()
end

function ClubScene:yaoQing()
    local title = "社区ID【"..self.data_.clubID.."】"
    local description = "赶快加入【"..self.data_.ownerName .. "】社区，社区私密局"
    self:shareWeiXin(1, title, description,0, callback)
end


function ClubScene:showMMMView_()
    self.MMMView_ = MMMView.new(self.data_.clubID,self.data_.name):addTo(self)
    self.MMMView_:setVisibleJoinLisyRed(self.layerRight_:getVisibleJoinLisyRed())
    self.MMMView_:tanChuang(100)
end

function ClubScene:chengYuanHandler_()
    self:requestClubUserList_()
end

function ClubScene:initChaGuanPlayerInfo(data)
    if self.playerInfo_ and self.playerInfo_.isOpen then
        self.playerInfo_:removeSelf()
        self.playerInfo_ = nil
    end
    self.playerInfo_ = ChaGuanPlayerInfo.new(data):addTo(self)
    self.playerInfo_:tanChuang(100)
end

function ClubScene:initTiRen(name, playerID)
    local view = TiRenView.new(name, playerID):addTo(self)
    view:tanChuang(100)
end

function ClubScene:initAddMember(msg, callfunc)
    local view = AddMemberView.new(msg, callfunc):addTo(self)
    view:tanChuang(100)
end

function ClubScene:markPlayer(msg, uid)
    local function callfunc(bool, msg)
        if not bool then return end
        if string.utf8len(msg) > 8 then
            app:alert("备注名字最长为8个字符")
            return
        end
        local params = {}
        params.clubID = self.data_.clubID
        params.uid = uid
        params.remark = msg
        httpMessage.requestClubHttp(params, httpMessage.REMARK_CLUB_USER)
    end
    local view = AddMemberView.new(msg, callfunc):addTo(self)
    view:tanChuang(100)
end

function ClubScene:initClubZhanJi()
    self.clubZhanJi_ = ClubZhanJi.new():addTo(self)
    self.clubZhanJi_:tanChuang(100) -- ClubZhanJi
end

function ClubScene:createRoomHandler_(isFirst)
    do return end
    local isMyClub = ChaGuanData:isMyClub()
    if isMyClub == false and isFirst == true then
        app:showTips("当前楼层未设置玩法,请联系社长创建!")
        self.floorNume = 1
        self:floorChange()
        return
    end
    local view = CreateRoomView.new(2, isFirst)
    self:addChild(view, 100)
    view:tanChuang()
    self.gameRuleView = view
end

function ClubScene:requestClubUserList_()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_USER_LIST)
    app:showLoading("正在请求成员数据，请稍候")
end

function ClubScene:tiPlayer(uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.KICK_CLUB_USER)
end

function ClubScene:requestDuiZhanList(owner)
    local params = {}
    params.clubID = self.data_.clubID
    params.isOwner = owner
    params.matchType = self.nowTopTag
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_SCORE_LIST)
end

function ClubScene:requestDaYingJiaList()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_WINNER_LIST)
end

function ClubScene:clearDaYingJia(id)
    local params = {}
    params.clubID = self.data_.clubID
    params.ids = id
    httpMessage.requestClubHttp(params, httpMessage.SET_CLUB_WINNER_LIST)
end

function ClubScene:getClubOwnerInfo()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_OWNER_INFO)
end

function ClubScene:quickGotoRoom()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_QUICK_ROOM)
end

function ClubScene:getPlayerClubInfo(uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_SCORE_BY_UID)
end

function ClubScene:editChaGuanName(msg)
    local params = {}
    params.clubID = self.data_.clubID
    params.text = msg
    httpMessage.requestClubHttp(params, httpMessage.EDIT_CLUB_NAME)
end

function ClubScene:editChaGuanGongGao(msg)
    local params = {}
    params.clubID = self.data_.clubID
    params.notice = msg
    httpMessage.requestClubHttp(params, httpMessage.EDIT_CLUB_NOTICE)
end

function ClubScene:zengSongDouZi(count,uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.count = count
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.TRANSFER_DOU)
end

function ClubScene:upGradeCity(count,uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.count = count
    httpMessage.requestClubHttp(params, httpMessage.UPGRADE_CITY)
end

function ClubScene:getUpGradeList()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.UPGRADE_LOGS)
end

function ClubScene:tuiChuClub()
    local msg = "你确定要退出俱乐部吗？"
    local  function tuiChuClubsHandler(bool)
        if bool then
            local params = {}
            params.clubID = self.data_.clubID
            httpMessage.requestClubHttp(params, httpMessage.QUIT_CLUB)
        end
    end
    app:confirm(msg, tuiChuClubsHandler)
end

function ClubScene:setUpGradeRedLog(id)
    local params = {}
    params.clubID = self.data_.clubID
    params.id = id
    httpMessage.requestClubHttp(params, httpMessage.SET_UPGRADE_REDLOGS)
end

function ClubScene:setLowestScore(score)
    local params = {}
    params.clubID = self.data_.clubID
    params.score = score
    httpMessage.requestClubHttp(params, httpMessage.SET_LOWEST_SCORE)
end

function ClubScene:getClubUseRank()
    local params = {}
    params.clubID = self.data_.clubID
end

function ClubScene:setOverScoreReduceScore(overScore, reduceScore)
    local params = {}
    params.clubID = self.data_.clubID
    params.overScore = overScore
    params.reduceScore = reduceScore
    httpMessage.requestClubHttp(params, httpMessage.SET_OVERSCORE_REDUCESCORE)
end

function ClubScene:jieSanClub()
    local function jieSanClubsHandler(bool)
        if bool then
            local params = {}
            params.clubID = self.data_.clubID
            httpMessage.requestClubHttp(params, httpMessage.DISMISS_CLUB)
        end
    end
    app:confirm("您确定要解散俱乐部么？", jieSanClubsHandler)
end


function ClubScene:upFHandler_()
    print("upFHandler_")
    local temp = self.floorNume - 1
    if temp < 1 or self.floorNume == 0 then
        return 
    end
    self.floorNume = temp
    self:floorChange()
end

function ClubScene:upDHandler_()
    print("upDHandler_")
    local temp = self.floorNume + 1
    if temp > 3 or self.floorNume == 0 then
        return 
    end
    self.floorNume = temp
    self:floorChange()
end

function ClubScene:copyIDHandler_()
   app:showTips("敬请期待")
end

function ClubScene:jfwHandler_()
    app:showTips("敬请期待")
end

function ClubScene:ckxqHandler_()
    app:showTips("敬请期待")
end

function ClubScene:bscHandler_()
    app:showTips("敬请期待")
end

function ClubScene:cksqHandler_()
    if  ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有群主和管理员可以查看申请列表！")
        return
    end
    if self.applyList_ then
        self.applyList_:removeSelf()
        self.applyList_ = nil
    end
    self.applyList_ = ApplyView.new():addTo(self)
    self.applyList_:tanChuang(100) -- ClubZhanJi
end

function ClubScene:floorChange(isNoNeedReq)
    -- local floorFont = {"一","二","三"}
    -- self.floorNum_:setString(floorFont[self.floorNume] .. "\n楼")
    -- gameData:setClubFloor(self.floorNume)
    -- if not isNoNeedReq then
    --     self:requestRoomList_()
    -- end
end

function ClubScene:onHttpDiamondReturn_(data)
    if tolua.isnull(self) then return end
    local result = json.decode(data)
    if not result then
        return
    end
    if result.status == -1 then
        app:enterLoginScene()
        return
    end
    if result.status ~= 1 then
        printInfo("onHttpDiamondReturn_ with ")
        return
    end
    local diamond = checkint(result.data.diamond)
    local laJiaoDou = checkint(result.data.laJiaoDou)
    if diamond > selfData:getDiamond() then
        app:showTips("恭喜获得"..(diamond-selfData:getDiamond()).."颗钻石")
    end
    selfData:setYuanBao(result.data.yuanBao)
    selfData:setDiamond(diamond)
    selfData:setScore(result.data.score)
    selfData:setBiSaiKa(laJiaoDou)
    self.layerTopView_:setYuanBao()
    -- self:shopUpdate()
end

function ClubScene:refreshHandler_()
    self:requestRoomList_()
end

return ClubScene