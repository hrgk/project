local TipsView = class("TipsView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/common/tipsbg.png", var = "tipsbgName_", scale9 = true, capInsets = cc.rect(208, 1, 40, 50), size = {display.width * 0.80,56}, children = {
            {type = TYPES.LABEL, var = "labelTips_", options = {text = "", size = 36, font = DEFAULT_FONT, color = cc.c4b(255, 255, 0, 255)}, ppx = 0.5, ppy = 0.5, ap = {0.5,0.5}},
        }, px = 0.5, py = 0.5, ap = {0.5, 0.5}},
    }
}

function TipsView:ctor(tips, seconds)
    gailun.uihelper.render(self, nodes)
    self.labelTips_:setString(tips or '')
    self:runFadeOut_(seconds or 0.8)
end

function TipsView:runFadeOut_(seconds)
    local actions = transition.sequence({
        cc.MoveTo:create(seconds, cc.p(0, 85)),
        cc.CallFunc:create(function ()
            self:removeFromParent()
        end)
    })
    self:runAction(actions)
end

return TipsView
