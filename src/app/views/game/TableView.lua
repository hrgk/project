local BaseAlgorithm = require("app.games.paodekuai.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local HandPokerList = import(".HandPokerList")
local BaseView = import("app.views.BaseView")
local TableView = class("TableView", BaseView)
local PlayController = import("app.views.game.PlayController")
local TableHead = import("app.views.game.TableHead")
local NaoZhong = import("app.views.game.NaoZhong")
local VoiceChatButton = import("app.views.game.VoiceChatButton")
local VoiceRecordView = import("app.views.game.VoiceRecordView")
local GameSetting = import("app.views.game.GameSetting")
local SelectedView = import("app.views.SelectedView")

function TableView:ctor(table)
    self.table_ = table
    self.isShowMenu_ = false
    self.inGame_ = false
    TableView.super.ctor(self)
    self:initPlayerSeats()
    self:initTableHead_()
    self:initNaoZhong_()
    self:initPlayController_()
    self:initEventListeners()
    self.tuiChuCMD_ = 0
    self.jieSanCMD_ = 0
    self:initYuYin_()
    self:initShenhe()
    self:initGameSetting_()
    self:initLayerTouch_()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
        self:update(dt)
    end)
    self:scheduleUpdate()
end

function TableView:initLayerTouch_()
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 0))
    self:addChild(maskLayer)
    maskLayer:setTouchEnabled(true)
    maskLayer:setTouchSwallowEnabled(false)  -- 吞噬
    maskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        display.getRunningScene():clickTable(event)
        display.getRunningScene():hideWenYuYin()
        self.isShowMenu_ = false
        self.setting_:setVisible(self.isShowMenu_)
        end)
end

function TableView:update(dt)
    self.headLogic_:update(dt)
end

function TableView:initGameSetting_()
    self.setting_ = GameSetting.new(self.table_)
    self.setting_:setNode(self.gameSetting_:getChildByName("btnBg"))
    self.setting_:setVisible(self.isShowMenu_)
end

function TableView:setCMD()
    self.setting_:setCMD(cmd1, cmd2)
end

function TableView:initShenhe()
    if CHANNEL_CONFIGS.SHARE == false then
        self.yaoQing_:setVisible(false)
    end

    if CHANNEL_CONFIGS.LOCATION ~= true then
        if self.dingWei_ then
            self.dingWei_:setVisible(false)
        end
    end
end

function TableView:initYuYin_()
    local view = VoiceRecordView.new()
    local voiceBtn =  VoiceChatButton.new()
    voiceBtn:setView(view)
    voiceBtn:setPosition(590*self.itemScale, voiceBtn:getPositionY() - 150)
    self.csbNode_:addChild(voiceBtn, 100)
    self.csbNode_:addChild(view, 100)
end

function TableView:isShowJieSanOrTuiChu_()
    if self.table_:getClubID() > 0 then
        self.setting_:isWanJia(true,self.inGame_)
        return
    end
    if selfData:getUid() == self.table_:getCreator() then
        self.setting_:isWanJia(false,self.inGame_)
    else
        self.setting_:isWanJia(true,self.inGame_)
    end
end

function TableView:enterGame( ... )
    
end

function TableView:initPlayerSeats()
    
end

function TableView:getPlayerView(seatID)
    return self.players_[seatID]
end

function TableView:initPlayController_()
    if self.caozuo_ then
        self.playController_ = PlayController.new(self.table_)
        self.playController_:setNode(self.caozuo_)
        self.caozuo_:hide()
    end
    if self.liangPai_ then
        self.liangPai_:hide()
    end
end

function TableView:initNaoZhong_()
    if self.naoZhong_ then
        self.naoZhongController_ = NaoZhong.new(self.table_)
        self.naoZhongController_:setNode(self.naoZhong_)
    end
end

function TableView:initTableHead_()
    if self.tableHead_ then
        self.headLogic_ = TableHead.new(self.table_)
        self.headLogic_:setNode(self.tableHead_)
        self.headLogic_:setSubHandler(handler(self, self.menuHandler_))
        self.headLogic_:setWanFaHandler(handler(self, self.wanFaHandler_))
    end
end

function TableView:initEventListeners()
    cc.EventProxy.new(self.table_, self, true)
    :addEventListener(self.table_.IS_SHOW_PALYCONTROLLER, handler(self, self.onShowPlayHandler_))
    :addEventListener(self.table_.BE_TURNTO, handler(self, self.onTurnToHandler_))
    :addEventListener(self.table_.GAME_START, handler(self, self.onGameStart_))
    :addEventListener(self.table_.ROUND_OVER, handler(self, self.onRoundOver_))
    :addEventListener(self.table_.ROUND_START, handler(self, self.onRoundStart_))
    :addEventListener(self.table_.TI_SHI, handler(self, self.onTiShi_))
    :addEventListener(self.table_.INIT_TABLE_INFO, handler(self, self.onTableInfoHandler_))
    :addEventListener(self.table_.GOLD_FLY, handler(self, self.onGoldFlyHandler_))
    :addEventListener(self.table_.FACE_PLAY, handler(self, self.onFacePlayHandler_))
    :addEventListener(self.table_.CHANGE_SKIN, handler(self, self.onChangSkinHandler_))
end

function TableView:onChangSkinHandler_(event)
    local texture = cc.Director:getInstance():getTextureCache():addImage("res/images/game/bg" .. event.index ..".jpg")
    self.bg_:setTexture(texture)
end

function TableView:onFacePlayHandler_(event)
    
    local fromPlayer = self["player" .. event.info.fromIndex .. "_"]
    local toPlayer = self["player" .. event.info.toIndex .. "_"]
    --self:showRoundAni_(event)
    self:faceIconFly_(event.info.faceID, fromPlayer, toPlayer)
end

function TableView:faceIconFly_(faceID, fromPlayer, toPlayer)
    local data = FaceAnimationsData.getFaceAnimation(faceID)
    local flyIcon = display.newSprite(data.flyIcon):addTo(self.csbNode_)
    local startX, startY = fromPlayer:getPosition()
    local toX, toY =  toPlayer:getPosition()
    if toIndex == MJ_TABLE_DIRECTION.LEFT then
        data.offsetX = - data.offsetX
        data.flyIconOffsetX = - data.flyIconOffsetX
        data.flipX = true
    end
    flyIcon:setPosition(startX, startY)
    transition.moveTo(flyIcon, {x = toX + data.flyIconOffsetX, y = toY + data.flyIconOffsetY, time = 0.5, easing = "exponentialOut", onComplete = function()
        flyIcon:removeFromParent()
        flyIcon = nil
        if data.animation ~= "" then
            data.x = toX - data.offsetX
            data.y = toY - data.offsetY
            gameAnim.createCocosAnimations(data, self.csbNode_)
        end
    end})
end

function TableView:onGoldFlyHandler_(event)
    local winner = self["player" .. event.winner .. "_"]
    local toX, toY = winner:getPosition()
    local actions = {}
    for i,v in ipairs(event.loses) do
         table.insert(actions, cc.CallFunc:create(function ()
            local loser = self["player" .. v .. "_"]
            local fromX, fromY = loser:getPosition()
            self:goldFly_(toX,toY,fromX,fromY)
        end))
        table.insert(actions, cc.DelayTime:create(0.5))
    end
    self.csbNode_:runAction(transition.sequence(actions))
end

function TableView:goldFly_(endX, endY, startX, startY)
    gameAudio.playSound("sounds/common/chips_to_table.mp3")
    local actions = {}
    for i = 1, 10 do
        table.insert(actions, cc.CallFunc:create(function ()
        local sprite = display.newSprite("res/res/images/game/gold.png")
        sprite:scale(1.5)
        sprite:pos(startX, startY)
        self.csbNode_:addChild(sprite)
        transition.moveTo(sprite, {x = endX, y = endY, time = 0.5, onComplete = function()
            sprite:removeSelf()
            end})
        end))
        table.insert(actions, cc.DelayTime:create(0.1))
    end
    self.csbNode_:runAction(transition.sequence(actions))
end


function TableView:onTableInfoHandler_(event)
    self:isShowJieSanOrTuiChu_()
    self.setting_:setMode(self.table_)
end

function TableView:onRoundStart_(event)
    self.inGame_ = true
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
    self.caozuo_:hide()
    if self.liangPai_ then
        self.liangPai_:hide()
    end
    display.getRunningScene():isShowSelectedView(false)
end

function TableView:onRoundOver_(event)
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
    self.caozuo_:hide()
    if self.liangPai_ then
        self.liangPai_:hide()
    end
    display.getRunningScene():isShowSelectedView(true)
end

function TableView:onTiShi_(event)
    local tempCards = self.table_:getCurrCards()
    self.pokerList_:tiShi(clone(tempCards), self.table_:getRuleDetails())
end

function TableView:onGameStart_(event)
    self.inGame_ = true
    self.yaoQing_:hide()
end

function TableView:onRemoveHandCards_(event)
    if event.cards == nil or #event.cards == 0 then
        return
    end
    self.pokerList_:removePokers(event.cards)
end

function TableView:onChuPai_(event)
    local outCards = self.pokerList_:getPopUpPokers()
    if #outCards == 0 then
        return
    end
    local currCards = self.table_:getCurrCards()
    local data = {cards = outCards}
    if currCards and #currCards == 0 then
        dataCenter:sendOverSocket(COMMANDS.PDK_CHU_PAI, data)
    else
        dataCenter:sendOverSocket(COMMANDS.PDK_CHU_PAI, data)
    end
    self.pokerList_:resetTiShi()
    self.naoZhongController_:stop()
end

function TableView:onShowPlayHandler_(event)
    self.caozuo_:setVisible(event.isShow)
end

function TableView:onTurnToHandler_(event)
    dump("===============TableView:onTurnToHandler_===============")
end

function TableView:hideAllBtn( ... )
    self.yaoQing_:hide()
    self.dingWei_:hide()
    self.luYin_:hide()
    self.sheZhi_:hide()
end

function TableView:dismissRoomHandler_()
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(self.jieSanCMD_)
        end
    end
    app:confirm("是否确定解散房间", callback)
end

function TableView:quitGameHandler_()
    local function callback(bool)
        if bool then
            selfData:setNowRoomID(0)
            dataCenter:sendOverSocket(self.tuiChuCMD_)
        end
    end
    app:confirm("是否确定退出房间", callback)
end

function TableView:shuaXinHandler_()
    dataCenter:setConnectGameSceneCallBack(nil)
    -- app:enterLoginScene()
    dataCenter:closeSocket()
    dataCenter:tryConnectSocket()
end

function TableView:dingWeiHandler_()
    
end

function TableView:buttonHuaYuHandler_()
    display.getRunningScene():initWenYuYin()
end

function TableView:luYinHandler_()
end

function TableView:menuHandler_()
    self.isShowMenu_ = not self.isShowMenu_
    self.setting_:setVisible(self.isShowMenu_)
    if self.inGame_ then
        self.setting_:setNewPos()
    end
end

function TableView:showNewPos()
    self.setting_:showNewPos()
end

function TableView:wanFaHandler_()
end

return TableView 
