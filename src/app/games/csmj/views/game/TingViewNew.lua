local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "bg_", filename = "res/images/majiang/tingBg.png", scale9 = true, capInsets = {34, 34, 10, 100}, ap = {0.5, 0.5}, x = display.cx, py = display.cy + 20},
        -- {type = TYPES.BUTTON, var = "hideBtn_", autoScale = 1, x = display.cx, y = display.cy + 20,},
    }
}

local TingViewNew = class("TingViewNew", gailun.BaseView)

function TingViewNew:ctor()
    gailun.uihelper.render(self, node)
    self.bg_:setScale(0.5)
    gailun.uihelper.setTouchHandler(self.bg_, handler(self, self.onBgClicked_))
    self.bgPosY = self.bg_:getPositionY()
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

function TingViewNew:onBgClicked_()
    print("click")
    self:setVisible(false)
end

function TingViewNew:setCards(cards)
    -- dump(debug.traceback(),"TingViewNew:setCards")
    dump(cards,"cardscards")
    -- cards = {
    --     [31] = 3,
    --     [32] = 3,
    --     [33] = 3,
    --     [34] = 3,
    --     [35] = 3,
    --     [36] = 3,
    --     [37] = 3,
    --     [38] = 3,
    --     [39] = 3,

    --     [21] = 3,
    --     [22] = 3,
    --     [23] = 3,
    --     [24] = 3,
    --     [25] = 3,
    --     [26] = 3,
    --     [27] = 3,
    --     [28] = 3,
    --     [29] = 3,

    --     [11] = 3,
    --     [12] = 3,
    --     [13] = 3,
    --     [14] = 3,
    --     [15] = 3,
    --     [16] = 3,
    --     [17] = 3,
    --     [18] = 3,
    --     [19] = 3,

    --     [51] = 3,
        
    -- }
    self.bg_:removeAllChildren()
    local index = 0
    local interval = 200
    local row = 1
    for card, count in pairs(cards) do
        local line = index % 6 + 1
        row = math.floor(index / 6) + 1
        local x = interval * line
        local maJiang = app:createConcreteView("MaJiangView", card, 1, false):addTo(self.bg_):pos(x, 100 + (row-1) * 146)
        local numBg = ccui.ImageView:create("res/images/majiang/numBg.png"):addTo(self.bg_):pos(x+90, 100 + (row-1) * 146)
        numBg:setScaleY(2.1)
        local labelInfo_ = display.newTTFLabel({text = "", size = 50, color = cc.c3b(255,255,255),align = cc.ui.TEXT_ALIGN_LEFT,}):addTo(self.bg_)
        if count == 0 then
            labelInfo_:setColor(cc.c4b(255, 0, 0))
        end
        labelInfo_:setString(count .. "张")
        labelInfo_:setPosition(x+90, 100 + (row-1) * 146)
        index = index + 1
    end
    local huFont = ccui.ImageView:create("res/images/majiang/fontH.png"):addTo(self.bg_):pos(60, row * 140 - 90+70)
    huFont:setScale(2)
    local size = {width = math.min((index + 1) * 200, 10 * 140), height = math.ceil(index / 6) * 140 + 80 }
    self.bg_:setContentSize(size)
    self.bg_:setPositionY(self.bgPosY+(row-1)*25)
    
end

function TingViewNew:hide()
end

return TingViewNew
