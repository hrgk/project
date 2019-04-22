local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "bg_", filename = "res/images/majiang/tingBg.png", scale9 = true, capInsets = {34, 34, 10, 100}, ap = {0.5, 0.5}, x = display.cx, py = display.cy + 20},
        -- {type = TYPES.BUTTON, var = "hideBtn_", autoScale = 1, x = display.cx, y = display.cy + 20,},
    }
}

local TingView = class("TingView", gailun.BaseView)

function TingView:ctor()
    gailun.uihelper.render(self, node)
    self.bg_:setScale(0.5)
    gailun.uihelper.setTouchHandler(self.bg_, handler(self, self.onBgClicked_))
    -- self.hideBtn_:setScale(0.5)
    -- self.bg_:setOpacity(200)
    -- self:setCards({
    --     [11] = 1,
    --     [12] = 1,
    --     [13] = 1,

    --     [22] = 1,
    --     [23] = 1,
    --     [32] = 1,
    --     [33] = 1,
    --     [35] = 1,
    --     [38] = 1,
    -- })
end

function TingView:onBgClicked_()
    print("click")
    self:setVisible(false)
end

function TingView:setCards(cards)
    self.bg_:removeAllChildren()
    local index = 0
    local interval = 120
    for card, count in pairs(cards) do
        local line = index % 9 + 1
        local row = math.floor(index / 9) + 1
        local x = interval * line
        local maJiang = app:createConcreteView("MaJiangView", card, 1, false):addTo(self.bg_):pos(x, row * 170 - 10)
        local labelInfo_ = display.newTTFLabel({text = "", size = 32, color = cc.c3b(216,209,95),align = cc.ui.TEXT_ALIGN_LEFT,}):addTo(self.bg_)
        if count == 0 then
            labelInfo_:setColor(cc.c4b(255, 0, 0))
        end
        labelInfo_:setString(count .. "张")
        labelInfo_:setPosition(x, row * 170 - 90)
        index = index + 1
    end

    local size = {width = math.min((index + 1) * 120, 10 * 120), height = math.ceil(index / 9) * 170 + 80 }
    self.bg_:setContentSize(size)
    -- self.hideBtn_:setContentSize(size)
end

function TingView:hide()
end

return TingView
