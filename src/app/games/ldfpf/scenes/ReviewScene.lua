local GameScene = import(".GameScene")
local ReviewScene = class("ReviewScene", GameScene)
local Player = import("app.games.ldfpf.models.Player")
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

function ReviewScene:showOnStatePlaying_()
    -- self:showVoiceChat_()
end

function ReviewScene:onAllLoaded_()
    self.tableController_ = app:createConcreteController("ReViewTableController", self.player_ ):addTo(self.layerTable_)
    self.tableController_:setScene(self)
    gailun.uihelper.render(self, Nodes.menuLayerTree, self.layerMenu_)
    self:onEnter_()
    self.buttonVoice_:hide()
    self.buttonHuaYu_:hide()
	self.buttonTiPai_:hide()
	self.buttonInvite_:hide()
	self.buttonReconnect_:hide()
end

function ReviewScene:showIPTips_()
   
end

function ReviewScene:onRoundOver_(event)
    if event.data.finishType == 3 then  -- 提前结束
        app:showTips("大局已定，提前结束！")
    end
	self:doRoundReview_(event.data)
	self:doRoundOver_(event.data)
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
    for _,v in pairs(checktable(data.seats)) do
        local p = self.tableController_:getPlayerBySeatID(v.seatID)
        p:setScore(v.totalScore)
    end
    if data.finishType == 0 then
	    if data.isHuangZhuang == 0 then
	    	if data.winInfo.huList then
	            self.tableController_:doHuPai(data)
	        end
	    end
	end
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
	local table = dataCenter:getPokerTable()
    table:doRoundOver()
	dataCenter:getHostPlayer():gameOver()
	self.player_:gameOver()
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
	self.playController_ = app:createConcreteController("ReviewPlayController", self.gameData_, self.player_):addTo(self):pos(display.cx, 450)
end

return ReviewScene
