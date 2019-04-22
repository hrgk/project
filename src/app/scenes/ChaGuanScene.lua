local BaseScene = import("app.scenes.BaseScene")
local ChaGuanData = import("app.data.ChaGuanData")
local PlayerHead = import("app.views.PlayerHead")
local ZhuoZi = import("app.views.chaguan.ZhuoZi")
local YuanZhuo = import("app.views.chaguan.YuanZhuo")

local SetView = import("app.views.chaguan.SetView")
local ChengYuanListView = import("app.views.chaguan.ChengYuanListView")
local ChaGuanPlayerInfo = import("app.views.chaguan.ChaGuanPlayerInfo")
local AddMemberView = import("app.views.chaguan.AddMemberView")
local SureAddMemberView = import("app.views.chaguan.SureAddMemberView")

local ApplyView = import("app.views.chaguan.shenQing.ApplyView")
local TiRenView = import("app.views.chaguan.TiRenView")
local CreateRoomView = import("app.views.hall.CreateRoomView")

local ClubZhanJi = import("app.views.chaguan.ClubZhanJi")
local ShengJiView = import("app.views.chaguan.ShengJiView")
local DuiJuListView = import("app.views.chaguan.DuiJuListView")
local ShengJiXiaoView = import("app.views.chaguan.ShengJiXiaoView")
local RankView = import("app.views.chaguan.rank.RankView")
local ChaGuanScene = class("ChaGuanScene", BaseScene)
-- local TianZhaGameOver = import("app.games.tianzha.views.game.GameOverView")
-- local PaoDeKuaiGameOver = import("app.games.paodekuai.views.game.GameOverView")
-- local BoPiGameOver = import("app.games.bopi.views.game.GameOverView")
-- local DaTongZiGameOver = import("app.games.datongzi.views.game.GameOverView")

function ChaGuanScene:ctor(data)
    ChaGuanScene.super.ctor(self)
    clubData:setCreateType("")
    self:initTableScroll()
    self.zhuoZiList_ = {}
    self.yuanZhuoList_ = {}
    self.floorList_ = {}
    self.data_ = data.data
    ChaGuanData.setClubInfo(data.data)
    dataCenter:tryConnectSocket()
    gameData:setClubID(self.data_.clubID)
    self:getElement(self.floor_,"btn")
    self.floorNum_ = self.floor_:getChildByName("txt_floor")
    -- self.upF_ = self.floor_:getChildByName("btn_upF")
    -- self.upD_ = self.floor_:getChildByName("btn_upD")
    -- self:buttonRegister(self.upF_, handler(self, self["upFHandler_"]))
    -- self:buttonRegister(self.upD_, handler(self, self["upDHandler_"]))
    if ChaGuanData.getClubInfo().permission == 99 then
        self.zhanji_:hide()
        self.wanfa_:hide()
        self.cksq_:hide()
    end
end

function ChaGuanScene:getElement(aimNode,aimType)
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
    for k,v in pairs(aimNode:getChildren()) do
        local vInfo = string.split(v:getName(), "_")
        local itemName
        local itemType = vInfo[1]
        if itemType == aimType then
            if vInfo[2] then
                itemName =  vInfo[2] .. "_"
                self[itemName] = v
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
            end
        end
    end
end

-- function ChaGuanScene:onEnterTransitionFinish()
--     ChaGuanScene.super.onEnterTransitionFinish(self)
-- end

function ChaGuanScene:initTableScroll()
    local scrollview=ccui.ScrollView:create() 
    scrollview:setTouchEnabled(true) 
    scrollview:setBounceEnabled(true) --这句必须要不然就不会滚动噢 
    scrollview:setDirection( ccui.ScrollViewDir.horizontal) --设置滚动的方向 
    scrollview:setContentSize(cc.size(1100,400)) --设置尺寸 
    scrollview:setClippingEnabled(true)
    scrollview:setAnchorPoint(cc.p(0.5,0.5))
    scrollview:setPosition(0, 0) 
    self.tableScroll_ = scrollview
    self.content_:addChild(scrollview)
end

function ChaGuanScene:loaderCsb()
    self.csbNode_ = cc.uiloader:load("scenes/ChaGuanScene.csb"):addTo(self)
end

function ChaGuanScene:onEnterTransitionFinish()
    ChaGuanScene.super.onEnterTransitionFinish(self)
    dataCenter:startKeepOnline()
    dataCenter:resumeSocketMessage()
    if tonumber(self.data_.dismissTime) > 0 then
        -- app:alert("社区正在解散中，请谨慎操作")
        gameData:setClubFloor(1)
        gameData:setClubID(0)
        app:enterHallScene()
        return
    end
    self.paoView_  = app:createView("MarqueeView", display.cx+200, 550):addTo(self)
    self:initClubInfo_()
    self:requestRoomList_()
    -- self:kfHandler_()
    self:getClubUseRank()
end

function ChaGuanScene:initClubInfo_()
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
    self:initChaGuanInfo_()
    -- if not CHANNEL_CONFIGS.DOU then
    --     -- self.douziIcon_:hide()
    --     -- self.douzibg_:hide()
    --     -- self.douzi_:hide()
    -- end
end

function ChaGuanScene:initZhuoZiList_(values)
    local content = self.tableScroll_:getInnerContainer()

    local row = math.floor((#values - 1) / 2)
    self.tableScroll_:setInnerContainerSize(cc.size(row * 320 + 180+300, 400))
    -- content:setContentSize(cc.size(row * 320 + 180, 400))
    -- self.tableScroll_:updateInset()

    for i=1, #values do
        local zhuozi = self.zhuoZiList_[i]
        if zhuozi == nil then
            zhuozi = ZhuoZi.new():addTo(content)
            table.insert(self.zhuoZiList_, i, zhuozi)
        end
        local x,y = self:clacZhuoZiPos_(i)
        local node = "zhuozi" .. i .. "_"
        zhuozi:pos(x,y)
        zhuozi:update(values[i])
    end

    for i = #values + 1, #self.zhuoZiList_ do
        self.zhuoZiList_[#values + 1]:removeSelf()
        table.remove(self.zhuoZiList_, #values + 1)
    end
end

function ChaGuanScene:updateZhuoZiByTid_(tid)
    for k,v in pairs(self.zhuoZiList_) do
        if v:getTid() == tid then
            v:update(ChaGuanData.getRoomInfoByTid(tid))
        end
    end
end

function ChaGuanScene:clacZhuoZiPos_(index)
    local ceng = math.mod(index, 2) 
    local row = math.floor((index - 1) / 2)
    local x = row  * 300 + 180 -- - 450
    local y = ceng * -220 + 320 --  + 150
    return x, y
end

function ChaGuanScene:initChaGuanInfo_()
    self.paoView_:run(self.data_.notice)
    self.zuanshi_:setString(self.data_.diamond)
    if (ChaGuanData.isMyClub() or ChaGuanData.getClubInfo().permission == 1) and CHANNEL_CONFIGS.DOU then
        self.guanLi_:show()
        self.shengji_:hide()
    elseif (ChaGuanData.isMyClub() or ChaGuanData.getClubInfo().permission == 1) and not CHANNEL_CONFIGS.DOU then
        self.guanLi_:show()
        self.shengji_:hide()
    elseif ChaGuanData.getClubInfo().permission == 99 and CHANNEL_CONFIGS.DOU then
        self.guanLi_:hide()
        self.shengji_:show()
    else
        self.guanLi_:show()
        self.shengji_:hide()
    end
    self.nickName_:setString(selfData:getNickName())
    self.userID_:setString("ID:"..selfData:getUid())
    self.clubName_:setString("社区：".. self.data_.name)
    self.zs_:setString(selfData:getDiamond())
    local gameConfig = ChaGuanData.getFloorGameConfig(gameData:getClubFloor()) or {}
    if gameConfig.gameType == nil then
        return
    end
    self:initGameRuleMsg_()
end

function ChaGuanScene:initGameRuleMsg_()
    local msg = ""
    if ChaGuanData.getGameConfig().gameType == GAME_PAODEKUAI then
        msg = self:paoDeKuaiInfo_()
    elseif ChaGuanData.getGameConfig().gameType == GAME_MJZHUANZHUAN then
        msg = self:zuanzhuanInfo_()
    elseif ChaGuanData.getGameConfig().gameType == GAME_MJCHANGSHA then
        msg = self:csmjInfo_()
    end
    self.gameName_:setString(GAMES_NAME[ChaGuanData.getGameConfig().gameType])
    self.msg_:setString(msg)
end

function ChaGuanScene:paoDeKuaiInfo_()
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

function ChaGuanScene:zuanzhuanInfo_()
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

function ChaGuanScene:csmjInfo_()
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

function ChaGuanScene:niuniuInfo_()
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

function ChaGuanScene:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(selfData:getAvatar())
end

function ChaGuanScene:onAllBroadcast_(event)
    if event.data.type == 2 then
        app:showTips("有玩家申请加入社区")
        ChaGuanData.setRedPoint(true)
        self:getJoinList(1)
    elseif event.data.type == 1 or event.data.type == 6 then
        if event.data.message.floor ~= tonumber(gameData:getClubFloor()) then
            return
        end
        if event.data.message.isOver then
            self:requestRoomList_()
        else
            ChaGuanData.updateRoomList(event.data.message)
            self:updateZhuoZiByTid_(event.data.message.tid)
        end
    elseif event.data.type == 5 then
        if not ChaGuanData.isMyClub() then
            self:requestRoomList_()
            local params = {}
            params.clubID = ChaGuanData.getClubInfo().clubID
            httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        end
    elseif event.data.type == 9 then
        local msg = event.data.data.clubName .."社区馆长给您赠送了".. event.data.data.dou .."金豆"
        msg = msg .. "您目前的金豆为".. event.data.data.nowDou
        app:alert(msg)
        ChaGuanData.getClubInfo().dou = event.data.data.nowDou
        -- self.douzi_:setString(event.data.data.nowDou)
    end
end

function ChaGuanScene:requestRoomList_()
    local params = {}
    params.clubID = self.data_.clubID
    params.floor = gameData:getClubFloor()
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_ROOMS)
end

function ChaGuanScene:bindEvent()
    ChaGuanScene.super.bindEvent(self)
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.GET_CLUB_INFO, handler(self, self.onGetClubInfoHandler_))
    :addEventListener(httpMessage.GET_CLUBS, handler(self, self.onHttpMessageHandler))
    :addEventListener(httpMessage.GET_REQUEST_JOIN_LIST, handler(self, self.onJoinListHandler))
    :addEventListener(httpMessage.VERIFY_CLUB_USER, handler(self, self.onVerifyClubUser_))
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
    :addEventListener(httpMessage.GET_DETAILS_RESULT, handler(self, self.onClubDetailsResult_))
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

end

function ChaGuanScene:onClubUserRankHandler_(event)
    -- dump(event.data)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            -- app:enterHallScene()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onQuitClubHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:enterHallScene()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onSetOverScoreHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("修改成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onSetLowestSocreHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("修改成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onSetUpgradeRedLogsHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:getUpGradeList()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onUpgradeLogsHandler_(event)
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

function ChaGuanScene:onUpgradeCityHandler_(event)
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

function ChaGuanScene:onClubScoreByUIDHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.playerInfo_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onTransferDouZiHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("赠送成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onClubQuickRoomHandler_(event)
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

function ChaGuanScene:onClubOwnerInfoHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initGuanLi_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onDaYingJiaClearHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.clubZhanJi_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onClubWinnerListHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.clubZhanJi_:update(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onClubConfigHandler_(event)
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

function ChaGuanScene:onClubCreateRoomHandler_(event)
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

function ChaGuanScene:onGetClubInfoHandler_(event)
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


function ChaGuanScene:initDuiJuList(data, isHuiFang)
    dump("ChaGuanScene:initDuiJuList")
    local view = DuiJuListView.new(data,isHuiFang):addTo(self)
    view:tanChuang(150)
    return view
end

function ChaGuanScene:onClubDetailsResult_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            local gameInfo = json.decode(data.data)
            local playerTable = dataCenter:getPokerTable(tonumber(gameInfo.gameType))
            playerTable:setTid(gameInfo.roomInfo.tid)
            playerTable:setRoundId(gameInfo.roomInfo.roundIndex)
            gameInfo.isClub = true
            playerTable:setConfigData(gameInfo.roomInfo.config)
            self:initGameOver(gameInfo)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onClubScoreList_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if self.clubZhanJi_ == nil or not self.clubZhanJi_.isOpen then
                self.clubZhanJi_ = ClubZhanJi.new(data.data):addTo(self)
                self.clubZhanJi_:tanChuang(150)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onSetClubAutoRoom_(event)
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

function ChaGuanScene:onSetClubMode_(event)
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

function ChaGuanScene:onDismissClub_(event)
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

function ChaGuanScene:onUpgradeClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.chaGuanView_:requestClubInfo()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onEditClubName_(event)
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

function ChaGuanScene:onEditClubNotice_(event)
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

function ChaGuanScene:onCopyClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("复制社区成功！")
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onRemarkPlayer_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onKickPlayer_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onTransfer_(event)
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

function ChaGuanScene:onSetPlayerPermission_(event)
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

function ChaGuanScene:onGetPlayerInfo_(event)
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

function ChaGuanScene:onClubRooms_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            if #data.data == 0 then
                 self:createRoomHandler_(true)
                return
            end
            local gameInfo = {}
            gameInfo.ruleDetails = json.decode(data.data[1].ruleDetails)
            gameInfo.gameType = data.data[1].gameType
            gameInfo.totalRound = data.data[1].totalRound
            ChaGuanData.setGameConfig(gameInfo)
            self:initGameRuleMsg_()
            ChaGuanData.setRoomList(data.data)
            self:updateZhuoZi_()
        elseif data.status == -9 then
            app:showLoading("正在退出社区")
            httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:updateZhuoZi_()
    local roomList = ChaGuanData.getRoomList()
    self:initZhuoZiList_(roomList)
end

function ChaGuanScene:onAddPlayerToClub_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:requestClubUserList_()
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onClubUserList_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:initChengYuanView_(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onVerifyClubUser_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self:getJoinList(1)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:getJoinList(type)
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    params.type = type
    httpMessage.requestClubHttp(params, httpMessage.GET_REQUEST_JOIN_LIST)
end

function ChaGuanScene:initApplyView(data)
    if self.applyList_ then
        self.applyList_:update(data)
        self.applyList_:show()
        return
    end
    self.applyList_ = ApplyView.new(data):addTo(self)
    self.applyList_:tanChuang(100) -- ClubZhanJi
end

function ChaGuanScene:onJoinListHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data == nil then return end
        if data.status == 1 then
            if self.applyList_ then
                self.applyList_:updateView(data.data)
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:onHttpMessageHandler(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setClubList(data.data)
            app:enterScene("ChaGuanListScene", {data.data})
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanScene:initChaGuanView_()
    self.chaGuanView_ = app:createView("chaguan.ChaGuanView")
    self.chaGuanView_:update(self.data_.data)
    self:addChild(self.chaGuanView_)
end

function ChaGuanScene:initAutoKaiFang(data)
    local view = app:createView("chaguan.AutoKaiFangView", data)
    self:addChild(view)
end

function ChaGuanScene:copyClubs(params)
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

function ChaGuanScene:distoryClubs(params)
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

function ChaGuanScene:upgrdeClubs(params)
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

function ChaGuanScene:pinBiPlayer(params, callback)
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

function ChaGuanScene:refusePlayer(params, callback)
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

function ChaGuanScene:agreePlayer(params, callback)
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

function ChaGuanScene:tiPlayer(params, callback)
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

function ChaGuanScene:shengPlayer(params)
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

function ChaGuanScene:jiangPlayer(params, callback)
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

function ChaGuanScene:zhuanRangPlayer(params, callback)
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

function ChaGuanScene:enterGameRoom(roomid)
    local msg = "你确定进入房间游戏么？"
    local  function enterHandler(bool)
        if bool then
            dataCenter:sendEnterRoom(roomid)
        end
    end
    app:confirm(msg, enterHandler)
    -- print(self:getChildByTag("1001").__cname)
end

function ChaGuanScene:createRoom(data)
    local view = app:createView("chaguan.ChaGuanCreateView", data)
    self:addChild(view, 1, "1002")
end

function ChaGuanScene:initCaoZuoView(data, clubID)
    local view = app:createView("chaguan.CaoZuoView", data, clubID)
    self:addChild(view)
end

function ChaGuanScene:initInputView(msg,callback)
    local view = app:createView("chaguan.InputView", msg,callback)
    self:addChild(view)
    return view
end

function ChaGuanScene:initGameOver(data)
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

function ChaGuanScene:quickEnterHandler_()
    if not ChaGuanData.isMyClub() and  self.data_.dou < ChaGuanData.getClubInfo().lowestScore then
        return app:showTips("金豆不够")
    end
    self:quickGotoRoom()
end

function ChaGuanScene:returnHandler_()
    app:showLoading("正在进入社区")
    httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
end

function ChaGuanScene:wanfaHandler_()
    self:createRoomHandler_()
end

function ChaGuanScene:guanLiHandler_()
    if ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有管理员和馆主可以打开")
        return
    end
    self:getClubOwnerInfo()
end

function ChaGuanScene:shengjiHandler_()
    ShengJiView.new():addTo(self):tanChuang(150)
end

function ChaGuanScene:initShengJiXiaoView()
    ShengJiXiaoView.new():addTo(self):tanChuang(150)
end

function ChaGuanScene:initGuanLi_(data)
    self.guanLiView_ = SetView.new(data):addTo(self)
    self.guanLiView_:tanChuang(100)
end

function ChaGuanScene:zhanjiHandler_()
    display.getRunningScene():requestDuiZhanList(1)
end

function ChaGuanScene:rankHandler_()
    if ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有管理员和馆主可以打开")
        return
    end
    RankView:new():addTo(self)
end

function ChaGuanScene:shareHandler_()
    self:yaoQing()
end

function ChaGuanScene:yaoQing()
    local title = "社区ID【"..self.data_.clubID.."】"
    local description = "赶快加入【"..self.data_.ownerName .. "】社区，社区私密局"
    self:shareWeiXin(1, title, description,0, callback)
end

function ChaGuanScene:initChengYuanView_(data)
    if self.chengYuanList_ then
        self.chengYuanList_:updateMemberList(data)
        self.chengYuanList_:show()
        return
    end
    self.chengYuanList_ = ChengYuanListView.new(data):addTo(self)
    self.chengYuanList_:tanChuang(100)
end

function ChaGuanScene:chengYuanHandler_()
    self:requestClubUserList_()
end

function ChaGuanScene:initChaGuanPlayerInfo(data)
    if self.playerInfo_ and self.playerInfo_.isOpen then
        self.playerInfo_:removeSelf()
        self.playerInfo_ = nil
    end
    self.playerInfo_ = ChaGuanPlayerInfo.new(data):addTo(self)
    self.playerInfo_:tanChuang(100)
end

function ChaGuanScene:initTiRen(name, playerID)
    local view = TiRenView.new(name, playerID):addTo(self)
    view:tanChuang(100)
end

function ChaGuanScene:initAddMember(msg, callfunc)
    local view = AddMemberView.new(msg, callfunc):addTo(self)
    view:tanChuang(100)
end

function ChaGuanScene:markPlayer(msg, uid)
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

function ChaGuanScene:initClubZhanJi()
    self.clubZhanJi_ = ClubZhanJi.new():addTo(self)
    self.clubZhanJi_:tanChuang(100) -- ClubZhanJi
end

function ChaGuanScene:createRoomHandler_(isFirst)
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

function ChaGuanScene:requestClubUserList_()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_USER_LIST)
    app:showLoading("正在请求成员数据，请稍候")
end

function ChaGuanScene:tiPlayer(uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.KICK_CLUB_USER)
end

function ChaGuanScene:requestDuiZhanList(owner)
    local params = {}
    params.clubID = self.data_.clubID
    params.isOwner = owner
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_SCORE_LIST)
end

function ChaGuanScene:requestDaYingJiaList()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_WINNER_LIST)
end

function ChaGuanScene:clearDaYingJia(id)
    local params = {}
    params.clubID = self.data_.clubID
    params.ids = id
    httpMessage.requestClubHttp(params, httpMessage.SET_CLUB_WINNER_LIST)
end

function ChaGuanScene:getClubOwnerInfo()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_OWNER_INFO)
end

function ChaGuanScene:quickGotoRoom()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.CLUB_QUICK_ROOM)
end

function ChaGuanScene:getPlayerClubInfo(uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_SCORE_BY_UID)
end

function ChaGuanScene:editChaGuanName(msg)
    local params = {}
    params.clubID = self.data_.clubID
    params.text = msg
    httpMessage.requestClubHttp(params, httpMessage.EDIT_CLUB_NAME)
end

function ChaGuanScene:editChaGuanGongGao(msg)
    local params = {}
    params.clubID = self.data_.clubID
    params.notice = msg
    httpMessage.requestClubHttp(params, httpMessage.EDIT_CLUB_NOTICE)
end

function ChaGuanScene:zengSongDouZi(count,uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.count = count
    params.uid = uid
    httpMessage.requestClubHttp(params, httpMessage.TRANSFER_DOU)
end

function ChaGuanScene:upGradeCity(count,uid)
    local params = {}
    params.clubID = self.data_.clubID
    params.count = count
    httpMessage.requestClubHttp(params, httpMessage.UPGRADE_CITY)
end

function ChaGuanScene:getUpGradeList()
    local params = {}
    params.clubID = self.data_.clubID
    httpMessage.requestClubHttp(params, httpMessage.UPGRADE_LOGS)
end

function ChaGuanScene:tuiChuClub()
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

function ChaGuanScene:setUpGradeRedLog(id)
    local params = {}
    params.clubID = self.data_.clubID
    params.id = id
    httpMessage.requestClubHttp(params, httpMessage.SET_UPGRADE_REDLOGS)
end

function ChaGuanScene:setLowestScore(score)
    local params = {}
    params.clubID = self.data_.clubID
    params.score = score
    httpMessage.requestClubHttp(params, httpMessage.SET_LOWEST_SCORE)
end

function ChaGuanScene:getClubUseRank()
    local params = {}
    -- params.clubID = self.data_.clubID
    params.clubID = 830980
end

function ChaGuanScene:setOverScoreReduceScore(overScore, reduceScore)
    local params = {}
    params.clubID = self.data_.clubID
    params.overScore = overScore
    params.reduceScore = reduceScore
    httpMessage.requestClubHttp(params, httpMessage.SET_OVERSCORE_REDUCESCORE)
end

function ChaGuanScene:jieSanClub()
    local function jieSanClubsHandler(bool)
        if bool then
            local params = {}
            params.clubID = self.data_.clubID
            httpMessage.requestClubHttp(params, httpMessage.DISMISS_CLUB)
        end
    end
    app:confirm("您确定要解散俱乐部么？", jieSanClubsHandler)
end


function ChaGuanScene:upFHandler_()
    print("upFHandler_")
    local temp = self.floorNume - 1
    if temp < 1 or self.floorNume == 0 then
        return 
    end
    self.floorNume = temp
    self:floorChange()
end

function ChaGuanScene:upDHandler_()
    print("upDHandler_")
    local temp = self.floorNume + 1
    if temp > 3 or self.floorNume == 0 then
        return 
    end
    self.floorNume = temp
    self:floorChange()
end

function ChaGuanScene:copyIDHandler_()
   app:showTips("敬请期待")
end

function ChaGuanScene:jfwHandler_()
    app:showTips("敬请期待")
end

function ChaGuanScene:ckxqHandler_()
    app:showTips("敬请期待")
end

function ChaGuanScene:bscHandler_()
    app:showTips("敬请期待")
end

function ChaGuanScene:cksqHandler_()
    if  ChaGuanData.getClubInfo().permission == 99 then
        app:showTips("只有群主和管理员可以查看申请列表！")
        return
    end
    local params = {}
    params.clubID = ChaGuanData.getClubInfo().clubID
    httpMessage.requestClubHttp(params, httpMessage.GET_REQUEST_JOIN_LIST)
    if self.applyList_ then
        self.applyList_:removeSelf()
        self.applyList_ = nil
    end
    self.applyList_ = ApplyView.new():addTo(self)
    self.applyList_:tanChuang(100) -- ClubZhanJi
end

function ChaGuanScene:floorChange(isNoNeedReq)
    local floorFont = {"一","二","三"}
    self.floorNum_:setString(floorFont[self.floorNume] .. "\n楼")
    gameData:setClubFloor(self.floorNume)
    if not isNoNeedReq then
        self:requestRoomList_()
    end
end

function ChaGuanScene:refreshHandler_()
    self:requestRoomList_()
end

return ChaGuanScene
