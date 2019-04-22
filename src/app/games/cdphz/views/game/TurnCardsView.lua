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
        local poker = app:createConcreteView("PaperCardView", v, 3, true):pos(x, y):addTo(self)
        poker:setAnchorPoint(cc.p(0, 0.5))
    end
end

function TurnCardsView:calcPos_(total, index)
    return (index - 1) * SMALL_POKER_MARGIN, 0
end

return TurnCardsView
