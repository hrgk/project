local LoadLayer = class("LoadLayer", gailun.BaseView)

local TYPES = gailun.TYPES
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LABEL, var = "labelTips_", options = {text = "", size = 20, color = display.COLOR_WHITE, dimensions = cc.size(500, 74)}, ap = {0.5, 1}, ppx = 0.5, ppy = 0.8},
        
        {type = TYPES.LABEL, var = "labelProgress_", options = {text = "", size = 34, font=DEFAULT_FONT, color = display.COLOR_WHITE}, ap = {0.5, 0.5}, px = 0.5, y = display.cy - 70},
        {type = TYPES.SPRITE, var = "progressSprite_", filename = "res/images/loadScene/progress_bg.png", px = 0.5, y = display.cy - 130, children = {
            {type = TYPES.PROGRESS_TIMER, var = "loadProgress_", bar = "res/images/loadScene/progress.png", ppx = 0.5, ppy = 0.5}, -- 升级进度条
        }},
    }
}

function LoadLayer:ctor()
    LoadLayer.super.ctor(self)
    gailun.uihelper.render(self, data)
end

function LoadLayer:onEnter()
    self:setPercentage(0)
end

function LoadLayer:onCleanup()
    gailun.EventUtils.clear(self)
end

function LoadLayer:setPercentage(percent)
    local str = string.format("检查资源更新...%s", '')--percent)
    self.loadProgress_:setPercentage(percent)
    self.labelProgress_:setString(str)
end

function LoadLayer:onClose_()
    if self.callback_ then
        self.callback_()
    end
    self:removeFromParent()
end

return LoadLayer
