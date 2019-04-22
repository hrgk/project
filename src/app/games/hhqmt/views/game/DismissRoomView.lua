local DismissRoomView = class("DismissRoomView", gailun.BaseView)
local TYPES = gailun.TYPES
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER_COLOR, var = "layerMask_", color = {0, 0, 0, 128}},
        {type = TYPES.SPRITE, filename = "res/images/sz_bg.png", scale9 = true, size = {740, 500}, capInsets = cc.rect(340, 150, 1, 1), x = display.cx, y = display.cy, children = {
            {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.51, ppy = 0.920, ap = {0.5, 0.5}},
            
            -- {type = TYPES.LABEL, var = "labelTitle_", options = {text = "提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelContent_", options = {text = "", align = cc.TEXT_ALIGNMENT_CENTER,
                size = 30, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255), dimensions = cc.size(600, 0)}, ppx = 0.5, ppy = 0.52, ap = {0.5, 0.5}},
            
            {type = TYPES.SPRITE, var = "jsfj_word_", filename = "res/images/common/jsfj_word.png", ppx = 0.5, ppy = 0.95, ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonPlayeragain_", normal = "res/images/common/button_playagain.png", autoScale = 0.9, y = 90, ppx = 0.70,},
            {type = TYPES.BUTTON, var = "buttonOut_", normal = "res/images/common/button_out.png", autoScale = 0.9, y = 90, ppx = 0.30,},

            -- {type = TYPES.SPRITE, var = "jsfj_word_", filename = "#jsfj_word.png", ppx = 0.5, ppy = 0.95, ap = {0.5, 0.5}},
        }},
    }
}

function DismissRoomView:ctor(message, callback, title)
    self.title = title
    gailun.uihelper.render(self, data)
    if message then
        -- self.labelContent_:setLineHeight(40)
        self.labelContent_:setString(message)
    end
    self.callback_ = callback
end

function DismissRoomView:onEnter()
    self.buttonPlayeragain_:onButtonClicked(function ()
        self:callHandler_(false)
    end)
    self.buttonOut_:onButtonClicked(function ()
        self:callHandler_(true)
    end)
end

function DismissRoomView:callHandler_(isOK)
    if self.callback_ and 'function' == type(self.callback_) then
        self.callback_(isOK)
    end
    if tolua.isnull(self) then
        return
    end
    self:onClose_()
end

function DismissRoomView:onClose_(event)
    self.callback_ = nil
    if tolua.isnull(self) then
        return
    end
    self:removeFromParent()
end

return DismissRoomView 
