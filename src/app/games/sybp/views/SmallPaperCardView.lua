local PaperCardView = import(".PaperCardView")
local SmallPaperCardView = class("SmallPaperCardView", PaperCardView)
local BaseAlgorithm = require("app.games.sybp.utils.BaseAlgorithm")

function SmallPaperCardView:calcCardName_()
	return BaseAlgorithm.getCardName(self.card_,3)
end

function SmallPaperCardView:initPoker_()
	display.newFilteredSprite(self:calcCardName_()):addTo(self)
end

return SmallPaperCardView 
