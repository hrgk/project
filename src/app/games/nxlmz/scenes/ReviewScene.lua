local GameScene = import(".GameScene")
local ReviewScene = class("ReviewScene", GameScene)
local Player = import("app.games.nxlmz.models.Player")
local Nodes = import("..data.GameSceneNodes")
local TaskQueue = require("app.controllers.TaskQueue")
local ReViewTableController = import("app.games.nxlmz.controllers.ReViewTableController")

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
end

function ReviewScene:onEnterTransitionFinish()
    self:loaderCsb()
    self:initElement_()
    self:bindSocketListeners()
    self:bindEvent()
    local node = display.newNode():addTo(self)
    TaskQueue.init(node)
    self.tableController_ = ReViewTableController.new()
    dataCenter:resumeSocketMessage()
    self:initReview_()
end

function ReviewScene:onLoginReturn_(event)
    
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

function ReviewScene:initReview_()
    self.playController_ = app:createConcreteController("ReviewPlayController", self.gameData_, self.player_):addTo(self):pos(display.cx, 300)
end

function ReviewScene:dennyButton_(button)
    button:hide()
    button.setVisible = function () end
end

return ReviewScene
