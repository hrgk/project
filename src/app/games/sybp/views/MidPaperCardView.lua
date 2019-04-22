local PaperCardView = import(".PaperCardView")
local MidPaperCardView = class("MidPaperCardView", PaperCardView)
local BaseAlgorithm = require("app.games.sybp.utils.BaseAlgorithm")

function MidPaperCardView:calcCardName_()
    return BaseAlgorithm.getCardName(self.card_,2)
end

function MidPaperCardView:initPoker_()
    display.newFilteredSprite(self:calcCardName_()):addTo(self)
end

return MidPaperCardView 