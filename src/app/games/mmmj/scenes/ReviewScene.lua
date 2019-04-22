local GameScene = import(".GameScene")
local ReviewScene = class("ReviewScene", GameScene)
local Player = import("app.games.mmmj.models.Player")
local Nodes = import("..data.uidata.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")

function ReviewScene:ctor(data)
    ReviewScene.super.ctor(self)
    self.gameData_ = data
    self.player_ = Player.new()
    self:bindReturnKeypad_()

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
    self.buttonVoice_:hide()
    self.buttonVoice_:setPosition(-100, -100)
    -- self.buttonToWechat_:hide()
    self.buttonReconnect_:hide()
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
    self:initReview_()
    app:clearLoading()
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
        -- p:warning(0)
        v.winType = 0
        v.posX, v.posY = p:getPlayerPosition()
        if v.score > 0 then
            v.winType = 1
        elseif v.score < 0 then
            v.winType = -1
        end 
        p:doRoundOver(v)
    end
    local table = self:getTable()
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
    self:removeFromParent()
end

function ReviewScene:onPlayAction_(event)
    if event.data.inFastMode then
        return
    end
    self:showMiniActionView_(event.data)
    ReviewScene.super.onPlayAction_(self, event)
end

local mini_actions = {
    CSMJ_ACTIONS.CHI,
    CSMJ_ACTIONS.AN_GANG,
    CSMJ_ACTIONS.CHI_GANG,
    CSMJ_ACTIONS.BU_GANG,
    CSMJ_ACTIONS.PENG,
    CSMJ_ACTIONS.CHI_HU,
    CSMJ_ACTIONS.ZI_MO
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
    self.playController_ = app:createConcreteController("ReviewPlayController", self.gameData_, self.player_):addTo(self):pos(display.cx, 350)
    self:dennyButton_(self.buttonInvite_)
    -- self:dennyButton_(self.buttonSort_)
    -- self:dennyButton_(self.buttonReturn_)
    self:dennyButton_(self.buttonReconnect_)
    -- self:dennyButton_(self.buttonVoice_)
    self:dennyButton_(self.buttonHuaYu_)
    -- self:dennyButton_(self.buttonChat_)
    self:dennyButton_(self.buttonVoice_)
end

function ReviewScene:dennyButton_(button)
    button:hide()
    button.setVisible = function () end
end

function ReviewScene:resetPlayer()
    self.tableController_:resetPlayer()
    self:clearTmpButtonOK_()
    self:clearBirds_()
end

function ReviewScene:onShowBirds_(event)
    if self.tableController_:isNoBird() then
        return 
    end

    -- self.tmpButtonOK_ = self.buttonOK_:clone()
    -- self.tmpButtonOK_:addTo(self.layerWindows_)
    -- self.tmpButtonOK_:onButtonClicked(handler(self, self.onTmpButtonOKClicked_))
    -- self.tmpButtonOK_:show()
    self:showBirds_(event.data)
end

function ReviewScene:showBirds_(data)
    self.tableController_:stopAllZhuanQuanAction()
    self:getTable():setBirds(data.birdList)
    self:clearBirds_()

    local huInfo = self.tableController_:getHuInfo()
    for k,v in pairs(huInfo) do
        data[k] = v
    end
    local configdata = self.tableController_:getTable():getConfigData()
    data.isSortBird = configdata.ruleDetails.birdType
    data.playerCount = configdata.ruleDetails.totalSeat
    data.tableController = self.tableController_
    self.birdView_ = app:createConcreteView("game.BirdsView", data):addTo(self.layerWindows_, -1)
end

return ReviewScene
