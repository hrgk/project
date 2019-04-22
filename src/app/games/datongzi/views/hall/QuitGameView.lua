local BaseLayer = require("app.views.base.BaseDialog")
local QuitGameView = class("QuitGameView", BaseLayer)
local TYPES = gailun.TYPES
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER_COLOR, var = "layerMask_", color = {0, 0, 0, 128}},
        {type = TYPES.SPRITE, filename = "images/sz_bg.png", scale9 = true, size = {700, 480}, capInsets = cc.rect(100, 100, 100, 100), x = display.cx, y = display.cy, children = {
            {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.51, ppy = 0.98, ap = {0.5, 0.5}},
           
            -- {type = TYPES.LABEL, var = "labelTitle_", options = {text = "提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelContent_", options = {text = "", align = cc.TEXT_ALIGNMENT_CENTER,
                size = 30, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255), dimensions = cc.size(600, 0)}, ppx = 0.5, ppy = 0.52, ap = {0.5, 0.5}},
            
            {type = TYPES.SPRITE, var = "tc_word_", filename = "res/images/common/tc_word.png", ppx = 0.5, ppy = 0.98, ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonPlayeragain_", normal = "res/images/common/button_playagain.png", autoScale = 0.9, y = 90, ppx = 0.70,},
            {type = TYPES.BUTTON, var = "buttonOut_", normal = "res/images/common/button_out.png", autoScale = 0.9, y = 90, ppx = 0.30,},

        }},
    }
}

function QuitGameView:ctor(message, callback, title)
    QuitGameView.super.ctor(self)
    self.title = title
    gailun.uihelper.render(self, data)
    if message then
        -- self.labelContent_:setLineHeight(40)
        self.labelContent_:setString(message)
    end
    self.callback_ = callback
    self:androidBack()
end

function QuitGameView:onEnter()
    self.buttonPlayeragain_:onButtonClicked(function ()
        self:callHandler_(false)
    end)
    self.buttonOut_:onButtonClicked(function ()
        self:callHandler_(true)
    end)
end

function QuitGameView:callHandler_(isOK)
    if self.callback_ and 'function' == type(self.callback_) then
        self.callback_(isOK)
    end
    if tolua.isnull(self) then
        return
    end
    self:onClose_()
end

function QuitGameView:onClose_(event)
    display.getRunningScene():closeWindow()
    display.getRunningScene():closeQuitGameView()
    self.callback_ = nil
    if tolua.isnull(self) then
        return
    end
    self:removeFromParent()
end

return QuitGameView 
