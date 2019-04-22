local BaseHelpView = import("..base.BaseHelpView")
local HelpMsgView = class("HelpMsgView", BaseHelpView)
local TYPES = gailun.TYPES

function HelpMsgView:ctor()
    self:addMaskLayer(self, 100)
    HelpMsgView.super.ctor(self, {targetName = "MSG", titlePng = "#msg.png", viewType = "SCROLL_VIEW"})
    self:androidBack()
end

function HelpMsgView:initListViewParam()
    local node = self.rankListView:getScrollNode()
    if node then
        node:removeFromParent()
    end
    local content = StaticConfig:get('sysInform') or ''
    local params = {type = TYPES.LABEL, x = 80 , y = display.height * 0.35, ap = {0, 0}, 
        options = {text = content, size = 36, color = cc.c4b(121, 78, 33, 255), font = DEFAULT_FONT, dimensions = cc.size(display.width * 0.85, 305), align = cc.TEXT_ALIGNMENT_LEFT,},}
    local newNode = gailun.uihelper.createObject(params)
    -- newNode:setLineHeight(45)
    self.rankListView:addScrollNode(newNode)
    if StaticConfig:get('gong_gao_id') == nil then return end
    gameCache:set(StaticConfig:get('gong_gao_id'), true)
end

function HelpMsgView:onClose_(event)
    self.param_ = nil
    self.nodeBg = nil
    self.nodes = nil
    self.nodesListView = nil
    self:removeFromParent()
    display.getRunningScene():closeWindow()
    display.getRunningScene():showMessageRedPoint()
end

return HelpMsgView
