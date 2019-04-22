local BaseLayer = require("app.views.base.BaseDialog")
local TianZhaMsgView = class("TianZhaMsgView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        -- {type = TYPES.SPRITE, var = "labelHelp_", filename = "res/images/wanfaimage.png", x = 640 * display.width / DESIGN_WIDTH, y = -50 , ap = {0.5, 0.5}, scale = display.width / DESIGN_WIDTH},
        {type = TYPES.SPRITE, filename = "res/images/hall.png", x = display.cx, y = display.cy},
        {type = TYPES.SPRITE, filename = "res/images/sz_bg.png", x = display.cx, y = display.cy,scale9 = true, size = {1168, 630}, capInsets = cc.rect(100, 100, 100, 100)},
        {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.93},
        {type = TYPES.SPRITE, filename = "res/images/hall/msg.png", x = display.cx, y = display.top - 50},
        {type = TYPES.SCROLL_VIEW, var = "scrollView1_", options = {viewRect = cc.rect(100, 60, display.width * 0.98 * WIDTH_SCALE, display.height * 0.72 * HEIGHT_SCALE),direction = 1}},
        {type = TYPES.BUTTON, var = "buttonBack_", autoScale = 0.9, normal = "res/images/common/closebutton.png", options = {}, ppx = 0.95, ppy = 0.92},
        
    }
}

function TianZhaMsgView:initListViewParam()
    local content = StaticConfig:get('sysInform') or ''
    local params = {type = TYPES.LABEL, x = 100 , y = display.height * 0.35, ap = {0, 0}, 
        options = {text = content, size = 36, color = cc.c4b(121, 78, 33, 255), font = DEFAULT_FONT, dimensions = cc.size(display.width * 0.85, 305), align = cc.TEXT_ALIGNMENT_LEFT,},}
    local newNode = gailun.uihelper.createObject(params)
    -- newNode:setLineHeight(45)
    self.scrollView1_:addScrollNode(newNode)
    if StaticConfig:get('gong_gao_id') == nil then return end
    gameCache:set(StaticConfig:get('gong_gao_id'), true)
end

function TianZhaMsgView:onClose_(event)
    self.param_ = nil
    self.nodeBg = nil
    self.nodes = nil
    self.nodesListView = nil
    self:removeFromParent()
    display.getRunningScene():closeWindow()
    display.getRunningScene():showMessageRedPoint()
end

function TianZhaMsgView:ctor()
    TianZhaMsgView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.rootLayer:setPosition(display.cx, display.cy)
    self:androidBack()
    self:initListViewParam()
    self.buttonBack_:onButtonClicked(handler(self, self.onClose_))
end


function TianZhaMsgView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

return TianZhaMsgView
