local GameScene = import(".GameScene")
local ReviewScene = class("ReviewScene", GameScene)
local Player = import("app.games.dao13.models.Player")
local Nodes = import("..data.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")

function ReviewScene:ctor(data)
    ReviewScene.super.ctor(self)
    self.gameData_ = data
    local seatInfo = {}
    local ruleInfo = {}
    local dealer = 0
    ccui.ImageView:create("res/images/niuniu/bg.png"):addTo(self.window_):pos(display.cx,display.cy)
    ccui.ImageView:create("res/images/niuniu/gamebg10.png"):addTo(self.window_):pos(display.cx,display.cy)
    for i = 1,#self.gameData_ do
        local info = self.gameData_[i]
        if info.cmd == COMMANDS.DAO13_PLAYER_ENTER_ROOM then
            seatInfo[info.msg.seatID] = json.decode(info.msg.data)
        end
        if info.cmd == COMMANDS.DAO13_ROOM_INFO then
            ruleInfo = info.msg
            dealer = info.msg.dealer
        end
        if info.cmd == COMMANDS.DAO13_ROUND_OVER then
            self:doRoundOver_(info.msg,ruleInfo,seatInfo,dealer)
        end
    end
    self.buttonBack_ = ccui.Button:create("res/images/game/button_back.png", "res/images/game/button_back.png"):addTo(self.window_):pos(display.cx,display.bottom+50)
    self.buttonBack_:addTouchEventListener(handler(self, self.onBackTouch_))
    self.buttonBack_:setSwallowTouches(true)  
end

function ReviewScene:onBackTouch_(sender, eventType)
    if eventType == 0 then
        sender:scale(0.9)
    elseif eventType == 1 then
    elseif eventType == 2 then
        sender:scale(1)
        self:onClose_()
    elseif eventType == 3 then
      
    end
end

function ReviewScene:doRoundOver_(data,ruleInfo,seatInfo,dealer)
    for _,v in pairs(checktable(data.seats)) do
        if dealer == 0 then
            
        else
            v.isZhuang = dealer == v.seatID
        end
        v.nickName = seatInfo[v.seatID].nickName
        v.avatar = seatInfo[v.seatID].avatar
        v.hostUid = selfData:getUid()
        v.uid = seatInfo[v.seatID].uid
    end

    self.roundOverView_ = app:createConcreteView("game.RoundOverView", data,ruleInfo):addTo(self.window_)
    self.roundOverView_:tanChuang(50)
end

-- 覆盖游戏场景中的暂停消息广播
function ReviewScene:onExitTransitionStart()
end

function ReviewScene:getHostPlayer()
    return self.player_
end

function ReviewScene:onAllLoaded_()
    self.tableController_ = app:createConcreteController("ReViewTableController", self.player_ ):addTo(self.layerTable_)
    gailun.uihelper.render(self, Nodes.menuLayerTree, self.layerMenu_)
    self:onEnter_()
end

function ReviewScene:showIPTips_()
   
end

function ReviewScene:onRoundOver_(event)
    if event.data.finishType == 3 then  -- 提前结束
        app:showTips("大局已定，提前结束！")
    end
    self:doRoundReview_(event.data)
end

function ReviewScene:taskRemoveAll()
end

function ReviewScene:resetPlayer()
    self.tableController_:resetPlayer()
end

function ReviewScene:onEnterTransitionFinish()
    ReviewScene.super.onEnterTransitionFinish(self)
end

function ReviewScene:onLoginReturn_(event)
    
end

function ReviewScene:onEnterTransitionFinish_()
    ReviewScene.super.onEnterTransitionFinish_(self)
    --self:initReview_()
    --app:clearLoading()
end

function ReviewScene:onNetWorkChanged_(event)
end

-- 仅用来覆盖父类的方法
function ReviewScene:checkSocketConnected_()
end

-- 仅用来覆盖父类的方法
function ReviewScene:startReConnect_()
end

function ReviewScene:doRoundReview_(data)
    self.tableController_:stopTimer()
    local rankCount = 0
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        p:setScore(v.totalScore)
        p:warning(0)
        v.winType = 0
        v.posX, v.posY = p:getPlayerPosition()
        if v.score > 0 then
            v.winType = 1
        elseif v.score < 0 then
            v.winType = -1
        end 
        p:doRoundOver(v)
    end
    local table = dataCenter:getPokerTable()
    table:goldFly(data.seats)
    table:doRoundOver()
end

-- 头像点击事件
function ReviewScene:onAvatarClicked_(params)
end

function ReviewScene:bindReturnKeypad_()
    if "android" ~= device.platform then
        return
    end
    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:onClose_()
        end
    end)
end

function ReviewScene:onClose_(event)
    app:popScene()
end

function ReviewScene:onPlayAction_(event)
    if event.data.inFastMode then
        return
    end
    self:showMiniActionView_(event.data)
    ReviewScene.super.onPlayAction_(self, event)
end

local mini_actions = {
    ACTIONS.CHI,
    ACTIONS.AN_GANG,
    ACTIONS.CHI_GANG,
    ACTIONS.BU_GANG,
    ACTIONS.PENG,
    ACTIONS.CHI_HU,
    ACTIONS.ZI_MO
}
function ReviewScene:showMiniActionView_(data)
    if not data or not data.actType then
        return
    end
    if false == table.indexof(mini_actions, data.actType) then
        return
    end
    
    local player = self.tableController_:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end

    local actions = self.tableController_:calcCanDoActions(player:getPlayer())
    table.insert(actions, data.actType)
    self.actionView_:showWithData(player:getIndex(), data, actions)
end

function ReviewScene:initReview_()
    self.playController_ = app:createConcreteController("ReviewPlayController", self.gameData_, self.player_):addTo(self):pos(display.cx, 300)
    self:dennyButton_(self.buttonInvite_)
    self:dennyButton_(self.buttonDismiss_)
    self:dennyButton_(self.buttonVoice_)
    self:dennyButton_(self.buttonConfig_)
    self:dennyButton_(self.buttonToWechat_)
    self:dennyButton_(self.buttonReconnect_)
end

function ReviewScene:dennyButton_(button)
    button:hide()
    button.setVisible = function () end
end

return ReviewScene
