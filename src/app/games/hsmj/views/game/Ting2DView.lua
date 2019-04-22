local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "bg_"}, -- 玩家4聊天气泡容器
    }
}

local Ting2DView = class("Ting2DView", gailun.BaseView)

function Ting2DView:ctor()
    gailun.uihelper.render(self, node)
    self.bg_:setScale(0.8)
end

function Ting2DView:setCards(cards)
    self.bg_:removeAllChildren()
    local index = 0
    local interval = 120
    for k, v in ipairs(cards) do
        local count = v.num
        local card = v.value
        local line = 1
        local row = index
        local x = interval * line + 30
        local y = row * 75 - 10
        print("setCards",x,y)
        local numBg = ccui.ImageView:create("res/images/majiang/2DTing/huBg.png"):addTo(self.bg_):pos(x+50, y)
        local huFont = ccui.ImageView:create("res/images/majiang/2DTing/huFont.png"):addTo(self.bg_):pos(x+110, y)
        numBg:setScale(1.3)
        huFont:setScale(1.3)
        local maJiang = app:createConcreteView("MaJiangView", card, 1, false):addTo(self.bg_):pos(x, y)
        maJiang:setScale(0.5)
        local labelInfo_ = display.newTTFLabel({text = "", size = 30, color = cc.c3b(255,255,255),align = cc.ui.TEXT_ALIGN_LEFT,}):addTo(self.bg_)
        labelInfo_:setString(count .. "张")
        labelInfo_:setPosition(x+50, y)
        index = index + 1
    end
    -- self.hideBtn_:setContentSize(size)
end

function Ting2DView:hide()
end

return Ting2DView
