local TianZhaCardType = require("app.utils.TianZhaCardType")
local TurnCardsView = class("TurnCardsView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        -- {type = TYPES.SPRITE, scale9 = true, filename = "#js_fkd.png", var = "sprite9_", ap = {0, 0.5}},
    },
}

function TurnCardsView:ctor(cards)
    gailun.uihelper.render(self, nodes)
    for i,v in ipairs(cards) do
        local x, y = self:calcPos_(#cards, i)
        local poker = app:createView("SmallPokerView", v, SK_TABLE_DIRECTION.BOTTOM, true):pos(x, y):addTo(self)
        poker:setAnchorPoint(cc.p(0, 0.5))
    end
    self:showCardTypeFlag_(cards)
end

function TurnCardsView:calcPos_(total, index)
    return (index - 1) * SMALL_POKER_MARGIN, 0
end

function TurnCardsView:showCardTypeFlag_(cards)
    if ctype < TianZhaCardType.LIAN_DUI then
        return
    end
    local size = self:getCascadeBoundingBox()
    local x, y = size.width / 4, size.height * 0.4
    display.newSprite(string.format("#ctype_flag_%d.png", ctype)):addTo(self):pos(x, y):setAnchorPoint(cc.p(0.5, 0.5))
    -- self.sprite9_:setContentSize(cc.size(size.width + 20, size.height + 20))
end

return TurnCardsView
