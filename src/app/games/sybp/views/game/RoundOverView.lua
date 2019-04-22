local BaseAlgorithm = require("app.games.sybp.utils.BaseAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
local BaseGameResult = import("app.views.BaseGameResult")
local RoundOverView = class("RoundOverView", BaseGameResult)
local PaperCardGroup = import("app.games.sybp.utils.PaperCardGroup")
local PaoHuZiAlgorithm = require("app.games.sybp.utils.PaoHuZiAlgorithm")
local TYPES = gailun.TYPES

local posx = 10
local fontSize = 24
local fontColor = cc.c3b(245, 233, 184)

local csbPath =  "csd/views/RoundOverItem.csb"
local cardsNodePath =  "csd/views/cardsNode%d_.csb"


local nodeWinScore = {type = gailun.TYPES.LABEL_ATLAS, var = "labelWinScore_", filename = "fonts/js_y_phz.png", 
					  options = {w = 35, h = 46, startChar = "0"}, ap = {0, 0}}
local nodeLoseScore = {type = gailun.TYPES.LABEL_ATLAS, var = "labelLoseScore_", filename = "fonts/js_s_phz.png", 
					   options = {w = 34, h = 52, startChar = "-"}, ap = {0, 0}}
local nodeFan = {type = gailun.TYPES.LABEL_ATLAS, var = "labelNodeFan_", filename = "fonts/js_fs_phz_x.png", 
					   options = {w = 19, h = 30, startChar = "+"}, ap = {0, 0}}
local nodeTun = {type = gailun.TYPES.LABEL_ATLAS, var = "labelNodeTun_", filename = "fonts/js_tun.png", 
					   options = {w = 24, h = 35, startChar = "0"}, ap = {0, 0}}

local TIQIANJIESHU_JIESAN = 1

function RoundOverView:ctor(params, isGameOver)
	self:init_(params)
	self:setMask(150)
end

function RoundOverView:setMask(operate)
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, operate))
    self:addChild(maskLayer, -1)
    self:performWithDelay(function()
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(DESIGN_WIDTH, DESIGN_HEIGHT))
        layout:setTouchEnabled(true)
        layout:setSwallowTouches(true)
        self:addChild(layout, -1)
        end, 0)
end

function RoundOverView:loadCsb_()
	-- self:addMaskLayer(self, 127)
	self.csbNode = cc.uiloader:load(csbPath):addTo(self)
	for k,v in pairs(self.csbNode:getChildren()) do
		print(v:getName())
	end

	self:setMemberVariable_()

	self.jieSuanTitle_:pos(display.cx, display.height * 0.98)
	self.infoBack_:pos(0, display.height)
	self.jieSuanItemBack_:pos(display.width / 2, display.height * 0.12)
	self.buttonContinue_:setPositionX(display.cx)
	self.buttonGameOver_:setPositionX(display.cx)

	local x = display.cx + self.jieSuanTitle_:getContentSize().width / 2 + (display.cx - self.jieSuanTitle_:getContentSize().width / 2 - self.diPaiBack_:getContentSize().width) / 2 + self.diPaiBack_:getContentSize().width
	local scale = 1
	local num = 2
	if (display.width / display.height) == (16 / 10) then
		scale = 0.6
		num = 4
	end
	self.diPai_:setScale(scale)
	local width = self.diPai_:getContentSize().width

	self.diPaiBack_:setPositionX(x + width / num)
end 

function RoundOverView:getCsbNode_()
	return self.csbNode
end

function RoundOverView:setMemberVariable_()
	local nodeName = {"tableIdLabel_", "roundInfo_", "currRound_", "totalRound_", "infoLabel_","buttonContinue_", 
					  "buttonGameOver_","panelBack_", "jieSuanItemBack_", "playerItem_1", "playerItem_2", "playerItem_3",
					  "jieSuanTitle_", "root_", "infoBack_", "imageWinBack_", "imageLoseBack1_", "winLose1_", "winLose2_",
					  "winLose3_", "diPaiNode_", "diPaiNode1_", "diPaiBack_", "diPai_", "imageLine1_", "imageLine2_"}
	for k,v in pairs(nodeName) do
    	self[v]= UIHelp.seekNodeByNameEx(self:getCsbNode_(), v)
    end
end 

function RoundOverView:init_(params)
	self:loadCsb_()
	self:btnEvent_()

	self.isHuangZhuang_ = false
	self:showHuangZhuang_(params)
	local playerTable = display.getRunningScene():getTable()

	if params.finishType == TIQIANJIESHU_JIESAN then
		self:endInMiddleHandler_()
		self.isTiQianJieSan_ = true
	end

	playerTable:setRoundId(params.seq)
	
	self.isZhuangWin_ = false
	self:calcRoundResult_(params)

	self.items = {}
	self:setRoundInfo_(params.seq, playerTable:getTotalRound())
	local isGameOver = not params.hasNextRound
	self:setIsGameOver(isGameOver)
	self:setRoomLabel_(params)
	-- self:setTimeLable_(params)
	self:createRoundOverItem_(params)
end 

function RoundOverView:btnEvent_()
	UIHelp.addTouchEventListenerToBtnWithScale(self.buttonContinue_, function() self:onContinueClicked_() end)
	UIHelp.addTouchEventListenerToBtnWithScale(self.buttonGameOver_, function() self:onGameOverClicked_() end)
	self.buttonGameOver_:setVisible(false)
end 

function RoundOverView:calcRoundResult_(params)
	local threeCount = 0
	for k,v in pairs(checktable(params.seats)) do
		if v.isZhuang then
			self.isZhuangWin_ = v.score > 0
		end
	end
end

function RoundOverView:endInMiddleHandler_()
	-- self.liujuTtitle_:show()
	-- self.liujuTtitle_:zorder(100)
end

function RoundOverView:showLiuju_(params)
	if not (params.winInfo.winner >= 1 and params.winInfo.winner <= 3) then
		self.jiesuanBack_:setTexture(liujuFileName)
		self.isLiuju = true
	end
end

function RoundOverView:showHuangZhuang_(params)
	self.imageWinBack_:setVisible(true)
	self.imageLoseBack1_:setVisible(false)
	self.winLose1_:setVisible(true)
	self.winLose2_:setVisible(true)
	self.winLose3_:setVisible(true)
	if params.isHuangZhuang == 1 or params.finishType == TIQIANJIESHU_JIESAN then
		local frame = nil
		if params.isHuangZhuang == 1 then
			frame = "res/images/round_over/js_huangzhuang.png"
		end
		if params.finishType == TIQIANJIESHU_JIESAN then
			frame = "res/images/round_over/js_tqjs.png"
		end
		self.jieSuanTitle_:setTexture(frame)
		self.isHuangZhuang_ = true

		self.imageWinBack_:setVisible(false)
		self.imageLoseBack1_:setVisible(true)

		self.winLose1_:setVisible(false)
		self.winLose2_:setVisible(false)
		self.winLose3_:setVisible(false)
	end
end

function RoundOverView:setRoomLabel_(params)
	local tableId = display.getRunningScene():getTable():getTid()
	self.tableIdLabel_:setString(string.format("房间号：%d", tableId))
	params.ruleString = ""
	if params.tableController_ then
		params.ruleString = params.tableController_:makeRuleString("   ") or ""  -- "全名堂 强制胡"
	end
	self.infoLabel_:setString(params.ruleString)
end

function RoundOverView:setRoundInfo_(currRound, totalRound)
	self.roundInfo_:setString("局数：")
	self.currRound_:setString(currRound)
	self.totalRound_:setString("/" .. totalRound)

	local round_pox = posx + self.roundInfo_:getContentSize().width
	self.currRound_:setPositionX(round_pox)
	round_pox = round_pox + self.currRound_:getContentSize().width
	self.totalRound_:setPositionX(round_pox)
end

function RoundOverView:setTimeLable_(params)
	local overTime = "结束时间："
	if params.finishTime then
		overTime = overTime .. params.finishTime
	else
		overTime = overTime .. os.date("%Y-%m-%d %H:%M:%S")
	end
	self.timeLabel_:setString(overTime)
end

function RoundOverView:createRoundOverItem_(params)
	local seats = {}
	local seatID
	local zhuangID = params.seats[1].zhuangID
	if self.isHuangZhuang_ then
		seatID = zhuangID
	else
		seatID = params.winInfo.winner
	end
	table.insert(seats, params.seats[seatID])
	for i,v in ipairs(checktable(params.seats)) do
		if v.seatID ~= seatID then
			table.insert(seats, v)
		end
	end
	params.seats = seats
	for i=1, #(checktable(params.seats)) do
		local v = params.seats[i]
		local index = i
		if v.score > 0 then
			v.isWin_ = true
		else
			v.isWin_ = false
		end
		v.isTiQianJieSan = self.isTiQianJieSan_
		v.index = i
		v.tableController_ = params.tableController_
		local showData = v
		showData.isEndInMiddle = self.isEndInMiddle_
		local item = app:createConcreteView("game.RoundOverItemView", v, showData)
		UIHelp.seekNodeByNameEx(self["playerItem_" .. i], "nodeHead_"):addChild(item)
		self:initWinScore_(i, showData)
		self:showCards_(i, showData, params.winInfo)
		table.insert(self.items, item)
	end

	-- params.winInfo.huList = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
	-- params.winInfo.fanList = {2,3,4,14,5,6,17,18,6,1,8,9,6,8,8} -- // 番率列表
	self:showFanshu_(1, params.winInfo, params.winInfo.winner == zhuangID)
	self:showTunshu_(1, params)
	self:showLeftCards_(params.leftCards)
end

-------------------------------
-- 得分
function RoundOverView:initWinScore_(index, params)
	if self.isHuangZhuang_ then
		return
	end
	local scoreNode = UIHelp.seekNodeByNameEx(self["playerItem_" .. index], "nodeScore_")
	local layer = display.newLayer()
	local sprite
	local labelAtlas 
	local posx = 0
	local adjustWinX = 10
	local adjustLoseX = 10
	if index == 1 then
		sprite = display.newSprite("res/images/round_over/defen_ying.png")
		sprite:setAnchorPoint(cc.p(0, 0))
		labelAtlas = gailun.uihelper.createLabelAtlas(nodeWinScore)
		labelAtlas:setString(params.score)
		layer:addChild(sprite)
		layer:addChild(labelAtlas)
		labelAtlas:setPositionX(sprite:getContentSize().width + adjustWinX)
		layer:setContentSize(cc.size(sprite:getContentSize().width + adjustWinX + labelAtlas:getContentSize().width, 1))
		layer:setAnchorPoint(cc.p(0.5, 0.5))
		scoreNode:addChild(layer)
	else
		sprite = display.newSprite("res/images/round_over/defen_shu.png")
		sprite:setAnchorPoint(cc.p(0, 0))
		labelAtlas = gailun.uihelper.createLabelAtlas(nodeLoseScore)
		labelAtlas:setString(string.format("%d", params.score))
		layer:addChild(sprite)
		layer:addChild(labelAtlas)
		labelAtlas:setPositionX(sprite:getContentSize().width + adjustLoseX)
		layer:setContentSize(cc.size(sprite:getContentSize().width + adjustLoseX + labelAtlas:getContentSize().width, 1))
		-- if index == 2 then
		-- 	layer:setAnchorPoint(cc.p(0, 1))
		-- 	layer:setPositionX(-layer:getContentSize().width)
		-- else
			layer:setAnchorPoint(cc.p(0, 0))
		-- end

		scoreNode:addChild(layer)
	end
end
-- 得分
-------------------------------

-------------------------------
-- 牌
local function getCardFile(value, isXiao)
	local ret
	local file = "zp_"
	if isXiao then
		file = "xp_"
	end
	if value > 300 then
		ret = "dp_bm"
	elseif value > 200 then
		ret = string.format(file .. "d%d.png", value - 200)
	elseif value > 100 then
		ret = string.format(file .. "x%d.png", value - 100)
	end
	return ret
end

local function getHuXi(cType, cards)
	local calcHuXiFunctions = {}
	calcHuXiFunctions[CTYPE_TI] = PaoHuZiAlgorithm.calcHuXiTi
	calcHuXiFunctions[CTYPE_PAO] = PaoHuZiAlgorithm.calcHuXiPao
	calcHuXiFunctions[CTYPE_WEI] = PaoHuZiAlgorithm.calcHuXiWei
	calcHuXiFunctions[CTYPE_CHOU_WEI] = PaoHuZiAlgorithm.calcHuXiWei
	calcHuXiFunctions[CTYPE_PENG] = PaoHuZiAlgorithm.calcHuXiPeng
	calcHuXiFunctions[CTYPE_SHUN] = PaoHuZiAlgorithm.calcHuXiShun
	calcHuXiFunctions[CTYPE_2710] = PaoHuZiAlgorithm.calcHuXi2710

    local func = calcHuXiFunctions[cType]
	if func then
		return func(cards)
	end
	return nil
end

local function isInRang(value, from, to)
	local v = checkint(value)
	local from = checkint(from)
	local to = checkint(to)
	local tmp = from
	if from > to then
		from = to
		to = tmp
	end
	if (v >= from) and (v <= to) then
		return true
	end
	return false
end

local function createCards(layer, isLeft, cardsTable, tableCardsX, adjustX, isShowHuxi, huCardIndex, adjustNum, huCard)
	tableCardsX = checkint(tableCardsX)
	adjustX = checkint(adjustX)
	local n = #cardsTable
	local finalNum = 1
	local setnNum = -1
	local maxHeightNum = 0
	local maxHeight = 0
	local NumI = checkint(adjustNum)
	local adjustHuCardIndex = checkint(huCardIndex) - NumI
	local isHu = false
	local index = 1
	local isSetColor = false

	if isLeft then
		n = 1
		finalNum = #cardsTable
		setnNum = 1
		adjustHuCardIndex = n - adjustHuCardIndex + 1
	else
		adjustHuCardIndex = checkint(huCardIndex) - NumI
	end

    if huCardIndex then
    end
	
	if huCardIndex and not isInRang(adjustHuCardIndex, n, finalNum) then
		print("createCards adjustHuCardIndex not isInRang adjustHuCardIndex = " .. adjustHuCardIndex)
		adjustHuCardIndex = 0
	end
	for i = n, finalNum, setnNum do
		local v = clone(cardsTable[i])
		local huXiType = v[1]
		table.remove(v, 1)
		local num = #v
		local cardsNode = cc.uiloader:load(string.format(cardsNodePath, num)):addTo(layer)
		local hu_ = UIHelp.seekNodeByNameEx(cardsNode, "hu_")
		if hu_ then
			hu_:setVisible(false)
		end

		local typeNode_ = UIHelp.seekNodeByNameEx(cardsNode, "typeNode_")
		if typeNode_ then
			typeNode_:setVisible(false)
		end

		if not isLeft then
			cardsNode:setPositionX((i - n) * adjustX - tableCardsX)
		else
			cardsNode:setPositionX((i - 1) * adjustX + tableCardsX)
		end
		
		if num > maxHeightNum then
			local card1 = UIHelp.seekNodeByNameEx(cardsNode, "card1_")
			maxHeightNum = num
			maxHeight = card1:getContentSize().height + (maxHeightNum - 1) * 40
		end
		for ii = 1 , num do
			local card = UIHelp.seekNodeByNameEx(cardsNode, string.format("card%d_", ii))
			local file = getCardFile(v[ii],true)
			if file then
				local frame = display.newSpriteFrame(file)
				card:setSpriteFrame(frame)
				if isShowHuxi then
					if (adjustHuCardIndex == i) then
						if (ii == num) then
							isHu = true
							index = i
							if hu_ then
								hu_:setVisible(true)
							end
							-- print("createCards adjustHuCardIndex = " .. adjustHuCardIndex)
						end

						if (not isSetColor) and (v[ii] == huCard) then
							isSetColor = true
							card:setColor(cc.c3b(255, 255, 0))
						end
					end
				end
			end
		end

		if isShowHuxi then
			local huXi = checknumber(getHuXi(huXiType, v))
			if huXi and huXi > 0 then
				local labelAtlasHuXi = gailun.uihelper.createLabelAtlas(nodeTun)
				labelAtlasHuXi:setString(huXi)
				labelAtlasHuXi:setAnchorPoint(cc.p(0.5, 0.5))
				local pos = cc.p(0, 5)
				labelAtlasHuXi:setPosition(pos)
				cardsNode:addChild(labelAtlasHuXi)
			end
		end
	end

	if isHu then
	    local v = #(cardsTable[index])
	    if v > maxHeightNum then
	    	local huHeight = 22
			maxHeight = maxHeight + huHeight
		end
	end
	return maxHeight
end

local function showFenPaiCards(layer, sprite9, params, adjustX, intervalY, tableCardsX, cardsTotalWidth, huIndexTable)
	local isHuanZhuang = huIndexTable.isHuanZhuang
	local huCardIndex = huIndexTable.huCardIndex
	local adjustNum = huIndexTable.adjustNum
	local huCard = huIndexTable.huCard
	local handCards = clone(params.handCards)
	-- handCards = {{102, 102, 202}, {208, 208}}
	local cards = {}
	if huIndexTable.isHuanZhuang then
		cards = PaperCardGroup.roundOverChaiPai(handCards)
		for i=1, #cards do
			table.insert(cards[i], 1 , 0)
		end
	else
		cards = handCards
	end

	adjustNum = #params.tableCards
	local maxHeight1 = createCards(layer, false, cards, nil, adjustX, not isHuanZhuang, huCardIndex, adjustNum, huCard)
	if #params.tableCards == 0 or #params.handCards == 0 then
		tableCardsX = 0
	end
	tableCardsX = tableCardsX + #cards * adjustX
	adjustNum = 0
	local maxHeight2 = createCards(layer, false, params.tableCards, tableCardsX, adjustX, not isHuanZhuang, huCardIndex, adjustNum, huCard)
	layer:setAnchorPoint(cc.p(0, 1))
	cardsTotalWidth = tableCardsX + (#params.tableCards - 3 / 2) * adjustX
	local maxHeight = maxHeight1
	if maxHeight < maxHeight2 then
		maxHeight = maxHeight2
	end
	sprite9:setContentSize(cc.size(tableCardsX + #params.tableCards * adjustX + adjustX, maxHeight + intervalY))
	sprite9:setPosition(cc.p(adjustX, -intervalY / 2 - 5))
	return tableCardsX, cardsTotalWidth
end

function RoundOverView:showCards_(index, params, wininfo)
	local srcWidth = 51
	local adjustX = srcWidth - 5
	local tableCardsX = 20
	local intervalY = 40
	local scoreCards = UIHelp.seekNodeByNameEx(self["playerItem_" .. index], "nodeCards_")
	local layer = display.newLayer()
	layer:setContentSize(cc.size(1, 1))
	scoreCards:addChild(layer)
	
	if index == 1 then
		local cardsPanel = UIHelp.seekNodeByNameEx(self["playerItem_" .. index], "cardsPanel_")
		local cardsTotalWidth = 0
		local options = {filename = "res/images/round_over/js_fkd.png", scale9 = true}
		local sprite9 = gailun.uihelper.createSprite(options)
		sprite9:setAnchorPoint(cc.p(1, 0))
		sprite9:setPosition(cc.p(adjustX, -intervalY / 2 - 2))
		scoreCards:addChild(sprite9, -1)
		if self.isHuangZhuang_ then
			tableCardsX, cardsTotalWidth = showFenPaiCards(layer, sprite9, params, adjustX, intervalY, tableCardsX, cardsTotalWidth, {isHuanZhuang = true})
		else
			local huPath = wininfo.huPath
			local huCardIndex = checkint(wininfo.huCardIndex)
			local handCardIndex = checkint(wininfo.handCardIndex)
			local huCard = checkint(wininfo.huCard)
			local numFrom = 2
			local numTo = 7
			if isInRang(handCardIndex, numFrom, numTo) then
				local p = {}
				p.tableCards = {}
				p.handCards = {}
				for i = 1, #huPath do
					if i < handCardIndex then
						table.insert(p.tableCards, clone(huPath[i]))
					else
						table.insert(p.handCards, clone(huPath[i]))
					end
				end
				local huIndexTable = {isHuanZhuang = false, huCardIndex = huCardIndex, adjustNum = 0, huCard = huCard}
				tableCardsX, cardsTotalWidth = showFenPaiCards(layer, sprite9, p, adjustX, intervalY, tableCardsX, cardsTotalWidth, huIndexTable)
			else
				local maxHeight = createCards(layer, false, huPath, nil, adjustX, true, huCardIndex, 0, huCard)
				maxHeight = maxHeight
				tableCardsX = #huPath * adjustX
				layer:setContentSize(cc.size(tableCardsX, 1))
				cardsTotalWidth = (#huPath - 1) * adjustX
				sprite9:setContentSize(cc.size((#huPath + 1) * adjustX , maxHeight + intervalY))
			end
		end
		local size = cardsPanel:getContentSize()
		scoreCards:setPositionX(size.width - (size.width - cardsTotalWidth) / 2)
		layer:setAnchorPoint(cc.p(0, 1))

	else
		-- local handCards = clone(params.handCards)
		-- local cards = PaperCardGroup.roundOverChaiPai(handCards)
		-- for i=1, #cards do
		-- 	table.insert(cards[i], 1 , -1)
		-- end
		-- createCards(layer, true, params.tableCards, nil, adjustX)
		-- tableCardsX = tableCardsX + #params.tableCards * adjustX
		-- createCards(layer, true, cards, tableCardsX, adjustX)
		-- layer:setAnchorPoint(cc.p(1, 0))
	-- elseif index == 3 then
		local handCards = clone(params.handCards)
		local cards = PaperCardGroup.roundOverChaiPai(handCards)
		for i=1, #cards do
			table.insert(cards[i], 1 , -1)
		end
		createCards(layer, false, cards, nil, adjustX)
		tableCardsX = tableCardsX + #cards * adjustX
		createCards(layer, false, params.tableCards, tableCardsX, adjustX)
		layer:setAnchorPoint(cc.p(0, 1))
	end
end
-- 牌
-------------------------------

-------------------------------
-- 剩余牌
function RoundOverView:showLeftCards_(allLeftCards)
	if not allLeftCards or #allLeftCards == 0 then
		return
	end
	local srcWidth = 34
	local adjustY = 100
	local leftCards = checktable(allLeftCards)
	local letfCardsNode
	local maxNum = #leftCards
	if maxNum > 10 then
		maxNum = 10
		letfCardsNode = self.diPaiNode1_
	else
		letfCardsNode = self.diPaiNode_
	end
	 

	for i = 1, #leftCards do
		local file = getCardFile(leftCards[i], true)
		if file then
			local row = 1
			local col = i
			if i > 10 then
				row = 2
				col = i - maxNum
			end
			
			local card = display.newSprite("#" .. file):addTo(letfCardsNode)
			card:setPositionX((col - 1) * srcWidth)
			card:setPositionY((1 - row) * adjustY)
		end
	end
end
-- 剩余牌
-------------------------------

-------------------------------
-- 翻数

-- HONG_HU = 1  # 红胡 红字=4只 红字=7只 红字>10只且<13只，均为红胡
-- ZHEN_DIAN_HU = 2  # 真点胡，红字仅有一只
-- JIA_DIAN_HU = 3  # 假点胡, 红字=10只
-- HONG_WU_HU = 4  # 红乌 红字大于等于13只
-- WU_HU = 5  # 全黑字胡
-- DUI_DUI_HU = 6  # 对对胡，7方门子中全部是碰、提、跑、臭偎、对子组成
-- DA_ZI_HU = 7  # 大字>=18只
-- XIAO_ZI_HU = 8  # 小字>=16只
-- HAI_DI_HU = 9  # 所胡牌是最后一只牌
-- ZI_MO_HU = 10  # 所胡牌是自己摸上来的
-- TIAN_HU = 11  # 3提或5坎 亮张胡牌
-- DI_HU = 12  # 地胡
-- SHUA_HOU_HU = 13  # 耍猴胡
-- TUAN_HU = 14  # 团胡(某数字的8张均在手里)
-- HAND_HANG_XI_HU = 15  # 行行息胡
-- TING_HU = 16  -- # 听胡

local fanFile = 
{
	[HONG_HU] = "honghu.png",
	[ZHEN_DIAN_HU] = "zhendianhuy.png",
	[JIA_DIAN_HU] = "jiadianhua.png",
	[HONG_WU_HU] = "hognwu.png",
	[WU_HU] = "heiwu.png",
	[DUI_DUI_HU] = "duiduihu.png",
	[DA_ZI_HU] = "dazihu.png",
	[XIAO_ZI_HU] = "xiaozihu.png",
	[HAI_DI_HU] = "haidihu.png",
	[ZI_MO_HU] = "zimo_kuang.png",
	[TIAN_HU] = "tianhu.png",
	[DI_HU] = "dihu.png",
	[SHUA_HOU_HU] = "shuahou.png",
	[TUAN_HU] = "js_tuanhu.png",
	[HAND_HANG_XI_HU] = "js_hanghangxihu.png",
	[JIA_HAND_HANG_XI_HU] = "js_jiahanghangxihu.png",
	[SI_QI_HU] = "js_siqihu.png",
	[TING_HU] = "tinghuzi.png"
}

local fanNum = 3
local function createFan(layer, index, file, fan, obj, adjustTable)
	local row = math.ceil(index / fanNum) - 1
	local col = math.fmod(index, fanNum)
	if col == 0 then
		col = fanNum
	end
	-- print("col=" .. col .. ",row=" .. row)
	local sprite
	local labelAtlas
	if not obj then
		sprite = display.newSprite(file)
		labelAtlas = gailun.uihelper.createLabelAtlas(nodeFan)
		labelAtlas:setString("+" .. fan)
		labelAtlas:setAnchorPoint(cc.p(0.5, 0))
		sprite:addChild(labelAtlas)

		local h1 = labelAtlas:getContentSize().height
		local h2 = sprite:getContentSize().height
		labelAtlas:setPosition(cc.p(136, (h2 - h1) / 2 - 2))
	else
		sprite = obj
	end

	sprite:setPositionX((col - 1) * adjustTable.adjustX)
	local adY = checkint(adjustTable.adY)
	sprite:setPositionY(-(row - 1) * adjustTable.adjustY + adY)
	sprite:setAnchorPoint(cc.p(0, 1))
	layer:addChild(sprite)
	sprite:setVisible(true)
	return sprite, labelAtlas
end

function RoundOverView:showFanshu_(index, wininfo, isZhuangWin)
	if index == 1 and not (self.isHuangZhuang_) then
		local nodeFanShu = UIHelp.seekNodeByNameEx(self["playerItem_" .. index], "nodeFanShu_")
		local layer = display.newLayer()
		layer:setContentSize(cc.size(1, 1))
		nodeFanShu:addChild(layer)

		local adjustX = 180
		local adjustY = 60

		local fan = 0
		wininfo.huList = checktable(wininfo.huList)
		-- dump(fanFile)
		for i = 1, #wininfo.huList do
			if fanFile[wininfo.huList[i]] then
				local file = "res/images/round_over/" .. fanFile[wininfo.huList[i]]
				-- if not isZhuangWin and wininfo.huList[i] == 11 then
				-- 	file = "res/images/round_over/" .. fanFile[12]
				-- end
				createFan(layer, i, file, wininfo.fanList[i], nil, {adjustX = adjustX, adjustY = adjustY})
				fan = fan + wininfo.fanList[i]
			end
		end

		if fan == 0 then
			fan = 1
		end

		local index = 1
		if wininfo.huList and #wininfo.huList > 0 then
			index = #wininfo.huList + 1
		end

		local huangFanRate = checkint(wininfo.huangFanRate)
		if huangFanRate > 1 then
			local sprite, labelAtlas = createFan(layer, index, "res/images/round_over/js_huangfan.png", huangFanRate, nil, {adjustX = adjustX, adjustY = adjustY})
			if sprite and labelAtlas then
				labelAtlas:setAnchorPoint(cc.p(0, 0))
				labelAtlas:setString(huangFanRate)
				local spriteX = display.newSprite("res/images/round_over/js_x.png")
				spriteX:setAnchorPoint(cc.p(1, 0.5))
				local posX = labelAtlas:getPositionX()
				local posY = sprite:getContentSize().height / 2
				spriteX:setPosition(cc.p(posX, posY))
				sprite:addChild(spriteX)
			end
			index = index + 1
		else
			huangFanRate = 1
		end

		local layerItem = display.newLayer()
		layerItem:setContentSize(cc.size(179, 59))
		local spriteFan = display.newSprite("res/images/round_over/fan.png")
		spriteFan:setAnchorPoint(cc.p(0, 0))
		layerItem:addChild(spriteFan)
		local labelAtlas = gailun.uihelper.createLabelAtlas(nodeFan)
		labelAtlas:setString(fan * huangFanRate)
		layerItem:addChild(labelAtlas)
		labelAtlas:setPositionX(spriteFan:getContentSize().width / 2)
		local w1 = spriteFan:getContentSize().width
		local w2 = labelAtlas:getContentSize().width
		local h1 = spriteFan:getContentSize().height
		local h2 = labelAtlas:getContentSize().height
		local width = w1 + w2
		local x1 = (layerItem:getContentSize().width - width) / 2 
		local y1 = layerItem:getContentSize().height / 2
		local adY = 6
		labelAtlas:setPosition(cc.p(x1 - 2, y1 - h2 /2 - 2))
		spriteFan:setPosition(cc.p(x1 + labelAtlas:getContentSize().width + 2, y1 - h1 / 2))

		createFan(layer, index, "res/images/round_over/fan.png", fan * huangFanRate, layerItem, {adjustX = adjustX, adjustY = adjustY, adY = adY})
		-- local x, y = layerItem:getPosition()
		-- layerItem:setPositionY(y - 6)
		-- print("cc.bPlugin_:" .. tostring(cc.bPlugin_))
	end
end
-- 翻数
-------------------------------

-------------------------------
-- 屯数
local function createTun(posX, filesTable, nodeTunShu, adjustTable)
	local ft = checktable(filesTable)
	if #ft <= 0 then
		return false, posX
	end
	local ap = cc.p(0, 0)
	local layer = display.newLayer()
	layer:setContentSize(cc.size(1, 1))
	layer:setAnchorPoint(ap)
	nodeTunShu:addChild(layer)
	layer:setPositionX(posX)

	local function createNode(files, x)
		local node
		if files.type == 0 then
			node = display.newSprite(files.filename)
		else
			node = gailun.uihelper.createLabelAtlas(nodeTun)
			node:setString(files.num)
		end
		layer:addChild(node)
		node:setAnchorPoint(ap)
		node:setPositionX(x)
		if files.y then
			node:setPositionY(files.y)
		end
		return node:getContentSize().width + 10
	end
	
	local tmpX = 0
	for i=1, #ft do
		tmpX = tmpX + createNode(ft[i], tmpX)
	end
	return true, posX + tmpX + adjustTable.adjustX
end

-- 胡息屯
local function createHuXiTun(index, nodeTunShu, adjustTable, params)
	local baseTun = 1
	if params.tableController_ then
		local data = params.tableController_:getRoomConfig()
		if data then
			baseTun = data.baseTun or baseTun
		end
	end
	local huXiTun = math.floor((params.winInfo.totalHuXi - 15) / 3) + checkint(baseTun)
	local filesTable = {{type = 1, num = params.winInfo.totalHuXi}, {type = 0, filename = "res/images/round_over/js_xi.png"}, {type = 1, num = huXiTun}, {type = 0, filename = "res/images/round_over/tun.png",  y = -4}}
	return createTun(index, filesTable, nodeTunShu, adjustTable)
end

-- 自摸屯
local function createZiMoTun(index, nodeTunShu, adjustTable, params)
	local filesTable = {{type = 0, filename = "res/images/round_over/js_zimo.png"}, {type = 1, num = 1}, {type = 0, filename = "res/images/round_over/tun.png", y = -4}}
	return createTun(index, filesTable, nodeTunShu, adjustTable)
end

-- 中庄屯
local function createZhongZhuangTun(index, nodeTunShu, adjustTable, params)
	local filesTable = {{type = 0, filename = "res/images/round_over/zhongzhuang.png", y = -4}, {type = 1, num = 1}, {type = 0, filename = "res/images/round_over/tun.png", y = -4}}
	return createTun(index, filesTable, nodeTunShu, adjustTable)
end

-- 总屯数
local function createZongTun(index, nodeTunShu, adjustTable, params)
	local filesTable = {{type = 0, filename = "res/images/round_over/js_zongtun.png", y = -4}, {type = 1, num = params.winInfo.totalTun}, {type = 0, filename = "res/images/round_over/tun.png", y = -4}}
	return createTun(index, filesTable, nodeTunShu, adjustTable)
end

function RoundOverView:showTunshu_(index, params)
	if index == 1 and not (self.isHuangZhuang_) then
		local nodeTunShu = UIHelp.seekNodeByNameEx(self["playerItem_" .. index], "nodeTunShu_")
		local adjustTable = {adjustX = 10, adjustY = -2}
		local posX = 0
		local ret, posX = createHuXiTun(posX, nodeTunShu, adjustTable, params) 
		if ret then
			index = index + 1
		end
	
		local data = params.tableController_:getRoomConfig()
		local is48 = false
		if data and data.ruleType == 4 then
			is48 = true
		end
		if (not is48) and params.winInfo.isZiMo and params.winInfo.isZiMo == 1 then
			ret, posX = createZiMoTun(posX, nodeTunShu, adjustTable, params) 
			if ret then
				index = index + 1
			end
		end
		if params.winInfo.isZhongzhuang and params.winInfo.isZhongzhuang == 1 then
			ret, posX = createZhongZhuangTun(posX, nodeTunShu, adjustTable, params)
			if ret then
				index = index + 1
			end
		end
		createZongTun(posX, nodeTunShu, adjustTable, params)
	end
end
-- 屯数
-------------------------------

function RoundOverView:setItemPosBySelf_(params)
	local index = 3
	local player  = nil 
	for i,v in ipairs(params.seats) do
		if v.isHost then
			player = v
			v.index = 3
			break
		end
	end
	for _,p in ipairs(params.seats) do
		if p.seatID ~= params.hostSeatID then
			if player.isZhuang then
				index = index - 1
				p.index = index
			else
				if p.isZhuang then
					p.index = 1
				else
					p.index = 2
				end
			end
		end
	end
end

function RoundOverView:setCloseHandler(callback)
	self.closeHandler_ = callback
end

function RoundOverView:setIsGameOver(isGameOver)
	if display.getRunningScene():getTable():getIsDismiss() then
		isGameOver = true
	end
	self.buttonGameOver_:setVisible(isGameOver)
	self.buttonContinue_:setVisible(not isGameOver)
end

function RoundOverView:onContinueClicked_()
	printInfo("RoundOverView:onContinueClicked_()")
	dataCenter:sendOverSocket(COMMANDS.SYBP_READY)
	self:close()
end

function RoundOverView:onGameOverClicked_(event)
	self:close()
end

function RoundOverView:close()
	TaskQueue.continue()
	if self.closeHandler_ then
		self.closeHandler_()
	end
	self:removeFromParent()
end

return RoundOverView
