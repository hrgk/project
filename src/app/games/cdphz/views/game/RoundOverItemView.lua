local RoundOverItemView = class("RoundOverItemView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodeSize = {display.width, display.height / 5}
local defen_config = {{x = 396, y = 485}}
local nodes = {
	type = TYPES.ROOT, children = {
		{type = TYPES.NODE, var = "nodeRoot_", children = {	
			{type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView", x = 0, y = 0},
			{type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/game/gold_bg.png", x = 2, y = -54, scale9 = true, size = {116, 30}, children = {
                {type = TYPES.SPRITE, filename = "res/images/game/gold.png", x = 10, ppy = 0.5},
                {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.34, ppx = 0.5, ap = {0.5, 0.5}},
            },scale = 1.2},
			{type = TYPES.SPRITE, var = "spriteZhuang_", filename = "res/images/game/flag_zhuang.png", x = -38, y = 30, visible = false},
			{type = TYPES.LABEL, var = "labelNickName_", options = {text = "", size = 22, font = DEFAULT_FONT, lign = cc.TEXT_ALIGNMENT_CENTER, color = cc.c3b(255, 255, 255)}, x = 0, y = 70, ap = {0.5, 0.5}},
			{type = TYPES.NODE, var = "nodeHandCards_"},
			{type = TYPES.NODE, var = "nodeTurnCards_"}
			}				
		}
	}
}

local COLOR_XIAN = cc.c4b(255, 255, 255, 255)
local BG_WIDTH, BG_HEIGHT = 1068, 182

function RoundOverItemView:ctor(params)
	RoundOverItemView.super.ctor(self)
	gailun.uihelper.render(self, nodes)
	self:hideFlags()
	self:initView_(params)
	-- self:setScoreWithRoller_(params.tableController_:getPlayerBySeatID(params.seatID).view_.player_:getScore())
	self:setScoreWithRoller_(params.totalScore, params.totalScore)
end

function RoundOverItemView:hideFlags( ... )
end

function RoundOverItemView:initBg_(params)
end

function RoundOverItemView:setScoreWithRoller_(score, fromScore)
	-- local NumberRoller = gailun.NumberRoller.new()
	-- NumberRoller:run(self.labelScore_, fromScore, score)
	self.labelScore_:setString(tostring(checkint(score)))
end

function RoundOverItemView:initWinFlag_(params)
	if params.score < 0 then
		return
	end
	if params.score == 0 then
		self.spriteWin_:hide()
		return
	end
	self.spriteWin_:setSpriteFrame(display.newSpriteFrame("js_win.png"))
end

function RoundOverItemView:showZhuangXian_(params)
	if params.isZhuang then
		self.spriteZhuang_:setVisible(true)
	end
end

function RoundOverItemView:endInMiddleHandler_(params)
	self.spriteZhuang_:hide()
	self:showHandCards_(params)
	self:showTurnCards_(params)
end

function RoundOverItemView:initView_(params)
	self:initBg_(params)
	self.handStartX_ = 0.01 * display.width
	self.labelNickName_:setString(params.nickName or '')
	self.avatar_:showWithUrl(params.avatar)
	if params.isEndInMiddle then
		self:endInMiddleHandler_(params)
		return
	end
	self:showZhuangXian_(params)
	self.downItems_ = {}
	self:showZhuangFlag_(params)
end

function RoundOverItemView:showZhuangFlag_(params)
	if params.isZhuang == true then
		if params.isTiQianJieSan then
			return
		end
	else
		if params.isTiQianJieSan then
			return
		end
	end
end

function RoundOverItemView:showFlagList_()
	for i,v in ipairs(self.downItems_) do
		v:show()
        v:setPosition((i - 1) * 50 + 30, 32)
	end
end

function RoundOverItemView:showTurnCards_(params)
	local data = params.turnCards
	if not data then
		return
	end
	local startX, startY = BG_WIDTH * 0.175 + 35, 55
	for i,v in ipairs(data) do
		local view = app:createConcreteView("game.TurnCardsView", v):addTo(self.nodeTurnCards_):pos(startX, startY)
		local size = view:getCascadeBoundingBox()
		startX = startX + size.width - 6
	end
end

function RoundOverItemView:showHandCards_(params)
	local data = params.handCards
	if not data then
		return
	end
	local startX, startY = BG_WIDTH * 0.175 + 35, BG_HEIGHT - 55
	for i, v in ipairs(data) do
		local x, y = startX + (i - 1) * SMALL_POKER_MARGIN, startY
		local poker = app:createConcreteView("PaperCardView", v, 3, true):pos(x, y):addTo(self.nodeHandCards_)
	end
end

function RoundOverItemView:adjustByX(x)
end

function RoundOverItemView:getMaJiangX()
	return self.handStartX_
end

return RoundOverItemView
