local PlayControllerView = class("PlayControllerView", gailun.BaseView)
local TYPES = gailun.TYPES
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "res/images/replay/control_panel_bg.png", touchEnabled = true, children = {
            {type = TYPES.BUTTON, var = "buttonFastBack_", autoScale = 0.9, normal = "res/images/replay/review_fb.png", ppx = 0.14, ppy = 0.5},
            {type = TYPES.BUTTON, var = "buttonPlay_", autoScale = 0.9, normal = "res/images/replay/review_play.png", ppx = 0.38, ppy = 0.5},
            {type = TYPES.BUTTON, var = "buttonPause_", autoScale = 0.9, normal = "res/images/replay/review_pause.png", ppx = 0.38, ppy = 0.5},
            {type = TYPES.BUTTON, var = "buttonFastForward_", autoScale = 0.9, normal = "res/images/replay/review_ff.png", ppx = 0.62, ppy = 0.5},
            {type = TYPES.BUTTON, var = "buttonReturn_", autoScale = 0.9, normal = "res/images/replay/review_return.png", ppx = 0.86, ppy = 0.5},

            {type = TYPES.LABEL, var = "labelProgress_", options = {text = "", size = 24, color = cc.c4b(255, 0, 0, 255), font = DEFAULT_FONT}, ppx = 0.5, y = 110 ,ap = {0.5,0.5}},
        }, y = display.cy - 540 },
    }
}

PlayControllerView.FAST_BACK_EVENT = "FAST_BACK_EVENT"
PlayControllerView.FAST_FORWARD_EVENT = "FAST_FORWARD_EVENT"
PlayControllerView.PAUSE_EVENT = "PAUSE_EVENT"
PlayControllerView.PLAY_EVENT = "PLAY_EVENT"
PlayControllerView.RETURN_EVENT = "RETURN_EVENT"

function PlayControllerView:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    
    display.addSpriteFrames("textures/replay.plist", "textures/replay.png")
    gailun.uihelper.render(self, data)

    self.buttonFastBack_:onButtonClicked(handler(self, self.onFastBackClicked_))
    self.buttonFastForward_:onButtonClicked(handler(self, self.onFastForwardClicked_))
    self.buttonPause_:onButtonClicked(handler(self, self.onPauseClicked_))
    self.buttonPlay_:onButtonClicked(handler(self, self.onPlayClicked_))
    self.buttonReturn_:onButtonClicked(handler(self, self.onReturnClicked_))

    self.labelProgress_:enableOutline(cc.c4b(134, 55, 7, 255), 2)
end

function PlayControllerView:onReturnClicked_(event)
    self:dispatchEvent({name = PlayControllerView.RETURN_EVENT})
end

function PlayControllerView:onFastBackClicked_(event)
    self:dispatchEvent({name = PlayControllerView.FAST_BACK_EVENT})
end

function PlayControllerView:onFastForwardClicked_(event)
    self:dispatchEvent({name = PlayControllerView.FAST_FORWARD_EVENT})
end

function PlayControllerView:onPauseClicked_(event)
    self:dispatchEvent({name = PlayControllerView.PAUSE_EVENT})
end

function PlayControllerView:onPlayClicked_(event)
    self:dispatchEvent({name = PlayControllerView.PLAY_EVENT})
end

function PlayControllerView:setProgress(total, index)
    assert(total and index)
    local str = string.format("进度:%d/%d", index, total)
    self.labelProgress_:setString(str)
end

function PlayControllerView:showPlay(flag)
    self.buttonPlay_:setVisible(not flag)
    self.buttonPause_:setVisible(flag)
end

return PlayControllerView
