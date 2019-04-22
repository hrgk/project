local BaseLayer = require("app.views.base.BaseDialog")
local BaseAlgorithm = require("app.utils.BaseAlgorithm")
local TianZhaHelpView = class("TianZhaHelpView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        -- {type = TYPES.SPRITE, var = "labelHelp_", filename = "images/wanfaimage.png", x = 640 * display.width / DESIGN_WIDTH, y = -50 , ap = {0.5, 0.5}, scale = display.width / DESIGN_WIDTH},
        {type = TYPES.SPRITE, filename = "images/sz_bg.png", x = display.cx, y = display.cy,scale9 = true, size = {1200, 630}, capInsets = cc.rect(100, 100, 100, 100)},
        -- {type = TYPES.SPRITE, filename = "images/chuangjiandi.png", ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}},
        {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.93},
        {type = TYPES.SPRITE, filename = "images/hall/guiz.png", ppx = 0.5, ppy = 0.935, ap = {0.5, 0.5}},
        {type = TYPES.SCROLL_VIEW, var = "scrollView1_", options = {viewRect = cc.rect(100, 60, display.width * 0.98 * WIDTH_SCALE, display.height * 0.72 * HEIGHT_SCALE),direction = 1}},
        {type = TYPES.BUTTON, var = "buttonBack_", autoScale = 0.9, normal = "res/images/common/closebutton.png", options = {}, ppx = 0.95, ppy = 0.92},
        
    }
}

function TianZhaHelpView:ctor()
    TianZhaHelpView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    -- self.rootLayer:setContentSize(cc.size(display.width * 0.98 * WIDTH_SCALE, display.height * 0.85 * HEIGHT_SCALE))
    self.rootLayer:setPosition(display.cx, display.cy)
    self:androidBack()
    self:initScrollView_()
    self.buttonBack_:onButtonClicked(handler(self, self.onClose_))
end

function TianZhaHelpView:initScrollView_()
    local sprite = display.newSprite("images/wanfaimage.png")
    sprite:setPosition(display.cx+50, -610)
    self.scrollView1_:addScrollNode(sprite)
end

function TianZhaHelpView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

return TianZhaHelpView
