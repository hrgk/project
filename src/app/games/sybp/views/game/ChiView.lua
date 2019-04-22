local PaoHuZiAlgorithm = require("app.games.sybp.utils.PaoHuZiAlgorithm")

local ChiView = class("ChiView", function()
	return display.newNode()
end)
local BG_SIZE = {
    {538, 190},
    {338,190},
    {138, 190},
}

local chi_pos_y = 40
local chi_pos_intervaly = 200
local chi_scale = 1

local function centerNodeX(node, width, isLeft)
	local size = node:getContentSize()
	local x = (width - size.width) / 2
	if isLeft then
		x = x - width + size.width / 2
	else
		x = x + size.width / 2
	end
	node:setPositionX(x)
end

-- 构造函数
function ChiView:ctor()
	self.width = 800
	self.height = 200

	self.group_items = {}
	self.group_items2 = {}
	self.group_items3 = {}
	self.chiList = {}
	self.curr_level = 0
	self.curr_card = 0
	self.p_choose = {}
	self.curr_level_data = {}
	self.curr_level_data2 = {}
	self.curr_level_data3 = {}
	self.choose_level = 0
	self.addChiBgDis = -120
	self:draw()
	self.offX = {8,3,0,-2,-8,0,0,0,0,0,0,0}
	self.orignX = self:getPositionX()
end

-- -- 新建一个九宫格的背景格，专门用来拦截节点上的触摸事件
-- function ChiView:onTouch(event, x, y)
--	 if event == "began" then
--		 return true
--	 end
--	 local touchInSprite = self.chiBg:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
--	 if event == "ended" then
--		 if touchInSprite then
--			 local nodePoint = self.chiBg:convertToNodeSpace(ccp(x, y))
--			 self:onGroupChoosed(math.ceil(nodePoint.x / (self.width / 6)))
--		 end
--	 end
-- end
function ChiView:onTouchCards(event, x, y)
	local nodePoint = self.chiBg:convertToNodeSpace(cc.p(x, y))
	print(nodePoint.x.."width-"..self.width)
	self:onGroupChoosed(math.ceil(nodePoint.x / (self.width / 10)))
end

function ChiView:onTouchCards2(event, x, y)
	local nodePoint = self.chiBg2:convertToNodeSpace(cc.p(x, y))
	self:onGroupChoosed2(math.ceil(nodePoint.x / (self.width / 10)))
end

function ChiView:onTouchCards3(event, x, y)
	local nodePoint = self.chiBg3:convertToNodeSpace(cc.p(x, y))
	self:onGroupChoosed3(math.ceil(nodePoint.x / (self.width / 10)))
end
-- 逐个比较判断两个table是否相等
local function isEqual(a, b)
	table.sort(a)
	table.sort(b)
	if #a ~= #b then
		return false
	end
	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end
	return true
end

local function isMatchPath(choosed, chi_path)
	for i = 1, #choosed do
		if not isEqual(choosed[i], chi_path[i]) then
			return false
		end
	end
	return true
end

local function inChoise(curr_list, wait_list)
	for i = 1, #curr_list do
		if isEqual(curr_list[i], wait_list) then
			return true
		 end
	end
	return false
end

function ChiView:cheakHaveNext(index)
	if index > #self.curr_level_data or index < 1 then
		return false
	end 
	local choose = self.curr_level_data[index]
	self.p_choose = {}
	self.p_chooselv1 = choose
	table.insert(self.p_choose, choose)
	local curr_level =  2
	if curr_level > #self.chiList[1] then -- 选择结束
		return false
	end
	self.curr_level_data2 = {}
	for i = 1, #self.chiList do
		if # self.chiList[i] >= curr_level then		
			if isMatchPath(self.p_choose, self.chiList[i]) 
				and not inChoise(self.curr_level_data2, self.chiList[i][curr_level]) then
				table.insert(self.curr_level_data2, self.chiList[i][curr_level])
			end
		end
	end
	if 0 == #self.curr_level_data2 then -- 已经比完牌，无需再比
		return false
	end
	return true
end

-- 玩家选择了某一列组合，继续向下深入
function ChiView:onGroupChoosed(index)
	if index > #self.curr_level_data or index < 1 then
		print("···"..index.."#"..#self.curr_level_data)
		return
	end 
	print("index",index)
	local choose = self.curr_level_data[index]
	self.p_choose = {}
	self.p_chooselv1 = choose
	table.insert(self.p_choose, choose)
	local curr_level =  2
	if curr_level > #self.chiList[1] then -- 选择结束
		self:onChooseEnd(self.p_choose)
		return
	end

	self.curr_level_data2 = {}
	for i = 1, #self.chiList do
		if # self.chiList[i] >= curr_level then		
			if isMatchPath(self.p_choose, self.chiList[i]) 
				and not inChoise(self.curr_level_data2, self.chiList[i][curr_level]) then
				table.insert(self.curr_level_data2, self.chiList[i][curr_level])
			end
		end
	end
	if 0 == #self.curr_level_data2 then -- 已经比完牌，无需再比
		return self:onChooseEnd(self.p_choose)
	end
    transition.moveTo(self.selectFaGuang1, {x = self.width/ 10 * index - self.width/ 30 - self.offX[#self.curr_level_data], y = 95, time = 0.2, onComplete = function()

    	self.selectFaGuang1:show()
    end})	


    self:showLevel2()
end


-- 玩家选择了某一列组合，继续向下深入
function ChiView:onGroupChoosed2(index)
	if index > #self.curr_level_data2 or index < 1 then
		return
	end 
	local choose = self.curr_level_data2[index]
	self.p_choose = {}
	table.insert(self.p_choose, self.p_chooselv1)
	table.insert(self.p_choose, choose)
	self.curr_level = 3
	if self.curr_level > 3 or self.curr_level > #self.chiList[1] then -- 选择结束
		self:onChooseEnd(self.p_choose)
		return
	end
	self.curr_level_data3 = {}
	for i = 1, #self.chiList do
		if # self.chiList[i] >= self.curr_level then	
			if isMatchPath(self.p_choose, self.chiList[i]) 
				and not inChoise(self.curr_level_data3, self.chiList[i][self.curr_level]) then
				table.insert(self.curr_level_data3, self.chiList[i][self.curr_level])
			end
		end
	end

	if 0 == #self.curr_level_data3 then -- 已经比完牌，无需再比
		return self:onChooseEnd(self.p_choose)
	end


    transition.moveTo(self.selectFaGuang2, {x = self.width/ 10 * index - self.width/ 30 - self.offX[#self.curr_level_data2], y = 95, time = 0.2, onComplete = function()
    	self.selectFaGuang2:show()
    end})			

	self:showLevel3()
    -- for k,v in pairs(self.group_items2) do
	-- 	v:setScale(1)
	-- end
    -- self.group_items2[index*2 -1]:setScale(1.05)

end

-- 玩家选择了某一列组合，继续向下深入
function ChiView:onGroupChoosed3(index)
	local choose = self.curr_level_data3[index]
	table.insert(self.p_choose, choose)

	self.selectFaGuang3:show()

    transition.moveTo(self.selectFaGuang3, {x = self.width/ 10 * index - self.width/ 30 - self.offX[#self.curr_level_data3], y = 95, time = 0.2})	
	self:onChooseEnd(self.p_choose)
end

function ChiView:hideSelf()
	print("chiview hideself")
	self:removeAllGroup()
	self:removeAllGroup2()
	self:removeAllGroup3()
	self:setVisible(false)
	self.chiBg:setVisible(false)
	self.chiBg2:setVisible(false)
	self.chiBg3:setVisible(false)
	self.choose_level = 0
end
function ChiView:onChooseEnd(pchoose)
	self:hideSelf()
	self.choose_level = 0
	dump(pchoose)
	if self.choose_end_handler then
		self.choose_end_handler(pchoose)
	end
end

-- 绘制图像
function ChiView:draw()
	self.chiBg = display.newScale9Sprite('res/images/game/chiview_bg.png', 0, 0, cc.size(538,190)):addTo(self)
	--local icon =  display.newSprite("res/images/game/chiview_chi.png"):pos(0, 0):addTo(self.chiBg)
	self.chiBg2 = display.newScale9Sprite('res/images/game/chiview_bg.png', 0, 200, cc.size(338,190)):addTo(self)
	--local icon2 =  display.newSprite("res/images/game/chiview_bi.png"):pos(0, 0):addTo(self.chiBg2)
	self.chiBg3 = display.newScale9Sprite('res/images/game/chiview_bg.png', 0, 400, cc.size(138,190)):addTo(self)
	--local icon3 =  display.newSprite("res/images/game/chiview_bi.png"):pos(0, 0):addTo(self.chiBg3)
	return self
end

function ChiView:hide()
	self:setVisible(false)
	if self.choose_end_handler then
		self.choose_end_handler(nil)
	end
end

function ChiView:showChoise(card, chiList, func)
	self:setVisible(true)
	self.chiList = chiList
	self.curr_level = 1
	self.curr_card = card
	self.p_choose = {}
	self:removeAllGroup()
	self:removeAllGroup2()
	self:removeAllGroup3()
	self.choose_end_handler = func

	local level1 = {}
	for i = 1, #chiList do
		if 0 == #level1 then
			table.insert(level1, chiList[i][1])
		else
			if not inChoise(level1, chiList[i][1]) then
				table.insert(level1, chiList[i][1])
			end
		end
	end

	self.curr_level_data = level1
	self:showLevel()
	return self
end

function ChiView:removeAllGroup()
	for k, v in pairs(self.group_items) do
		self:removeChild(v)
	end
	self.group_items = {}
end
function ChiView:removeAllGroup2()
	for k, v in pairs(self.group_items2) do
		self:removeChild(v)
	end
	self.group_items2 = {}
end
function ChiView:removeAllGroup3()
	for k, v in pairs(self.group_items3) do
		self:removeChild(v)
	end
	self.group_items3 = {}
end

function ChiView:getStringByInt(num)
	return "+" .. num
end
 
function ChiView:showLevel()
	self:removeAllGroup()
	self:removeAllGroup2()
	self:removeAllGroup3()
	self.chiBg:setVisible(true)
	self.chiBg2:setVisible(false)
	self.chiBg3:setVisible(false)
	self.choose_level = 1
	local cards = self.curr_level_data
	local x,y
	local startx, starty = - self.width / 2 - 46, 100
	self.haveNext = false
	for i = 1,#cards do
		if self:cheakHaveNext(i) then 
			self.haveNext = true
			break
		end
	end
 	
	-- 根据个数确定背景框以及坎的起始位置，最多6个
	-- if #cards % 2 == 0 then
	-- 	-- 偶数个
	startx, starty = - self.width / 2 - 50  + (6 - #cards)/ 2 * (self.width/6), 100
	self:removeChild(self.chiBg)
	local aimX = -display.cx / 2 + self.addChiBgDis 
	if not self.haveNext then
		self.chiBg = display.newScale9Sprite('res/images/game/chiview_bg.png', -display.cx+640 , chi_pos_y+185, cc.size(self.width / 9 * #cards,190)):addTo(self) 
		self.chiBg:setAnchorPoint(cc.p(0.5, 0.5))
	else
		self.chiBg = display.newScale9Sprite('res/images/game/chiview_bg.png',  -display.cx+640 , chi_pos_y+185, cc.size(self.width / 9 * #cards,190)):addTo(self) 
		self.chiBg:setAnchorPoint(cc.p(0.5, 0.5))
	end
	self.level1X = self.chiBg:getPositionX() 
	self.chiBg:setTouchEnabled(true)
	self.chiBg:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
	self.chiBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local x = event.x
		local y = event.y
		self:onTouchCards(event,x,y)
	
	end)
	--local icon =  display.newSprite("res/images/game/chiview_chi.png"):pos(5, 180):addTo(self.chiBg)

	self.selectFaGuang1 =  display.newSprite("res/images/game/chiview_faguang.png"):pos(startx + self.width / 10 , starty -100):addTo(self.chiBg)
	self.selectFaGuang1:hide()
	self.selectFaGuang1:setScale(1.2,1.03)
	for i = 1, #cards do
		local tmp_cards = {}

		if 3 > #cards[i] then -- 第一手要补张
			table.insert(tmp_cards, self.curr_card)
		end

		for j = 1, #cards[i] do
			table.insert(tmp_cards, cards[i][j])
		end
		-- 
		x = self.width/ 10 * i - self.width/ 30 - self.offX[#self.curr_level_data]
		local tmp = app:createConcreteView("game.ChiKanView", tmp_cards, 3, false, nil):addTo(self.chiBg):pos(x, 100)
		tmp:setScale(1.4)
		tmp:setAnchorPoint(cc.p(0.5, 0.5))
      
		table.insert(self.group_items, tmp)
		if i < #cards then
			local sepX =  self.width/ 10 * i + self.width/ 60 - self.offX[#self.curr_level_data]
			local sepY = 100
			local sep =  display.newSprite("res/images/game/chiview_sep.png"):pos(sepX, sepY):addTo(self.chiBg)
    		table.insert(self.group_items, sep)
		end
	end
	table.insert(self.group_items, self.selectFaGuang1)
end


function ChiView:showLevel2()
	self:removeAllGroup2()
	self:removeAllGroup3()
	self.chiBg2:setVisible(true)
	self.chiBg3:setVisible(false)
	self.choose_level = 2
	dump(self.curr_level_data2,"self.curr_level_data2")
	local cards = self.curr_level_data2
	local x,y
	local startx, starty = - self.width / 2 + 47, 300
	startx, starty = - self.width / 2 - 46  + (6 - #cards)/ 2 * (self.width/6), 300
	self:removeChild(self.chiBg2)

	local aimX = -display.cx+640 + self.chiBg:getContentSize().width/2 + 20
	self.chiBg2 = display.newScale9Sprite('res/images/game/chiview_bg.png', aimX , chi_pos_y+185, cc.size(self.width / 9 * #cards,190)):addTo(self) 
	self.chiBg2:setAnchorPoint(cc.p(0, 0.5))
	self.chiBg2:setTouchEnabled(true)
	self.chiBg2:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
	self.chiBg2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local x = event.x
		local y = event.y
		print("touchended"..event.name)
		self:onTouchCards2(event,x,y)
	
	end)
	self.selectFaGuang2 =  display.newSprite("res/images/game/chiview_faguang.png"):pos(startx + self.width / 10 , starty -100):addTo(self.chiBg2)
	self.selectFaGuang2:hide()
	self.selectFaGuang2:setScale(1.2,1.03)
	--local icon2 =  display.newSprite("res/images/game/chiview_bi.png"):pos(5, 180):addTo(self.chiBg2)
	for i = 1, #cards do
		local biPai = cards[i]
		for j = 1, #biPai do
			if biPai[j] == self.curr_card then
				table.remove(biPai,j)
				break
			end
		end 
		table.insert(biPai,1,self.curr_card)
		x = self.width/ 10 * i - self.width/ 30 - self.offX[#self.curr_level_data2]

		local tmp = app:createConcreteView("game.ChiKanView", biPai, 3, false, nil):addTo(self.chiBg2):pos(x, 100)		
		tmp:setScale(1.4)
		tmp:setAnchorPoint(cc.p(0.5, 0.5))

		table.insert(self.group_items2, tmp)
		if i < #cards then
			local sepX =  self.width/ 10 * i + self.width/ 60 - self.offX[#self.curr_level_data2]
			local sepY = 100
			local sep =  display.newSprite("res/images/game/chiview_sep.png"):pos(sepX, sepY):addTo(self.chiBg2)
    		table.insert(self.group_items2, sep)
		end
	end
	local tatalWidth = self.chiBg:getContentSize().width +20 + self.chiBg2:getContentSize().width
	self.chiBg:setPositionX(self.level1X - self.chiBg2:getContentSize().width/2)
	self.chiBg2:setPositionX(self.chiBg2:getPositionX() - self.chiBg2:getContentSize().width/2)
	table.insert(self.group_items2, self.selectFaGuang2)
end


function ChiView:showLevel3()
	self:removeAllGroup3()
	self.choose_level = 3
	local cards = self.curr_level_data3
	local x,y
	local startx, starty = - self.width / 2 - 46, 428
	startx, starty = - self.width / 2 - 46  + (6 - #cards)/ 2 * (self.width/6), 500
	self:removeChild(self.chiBg3)
	local aimX = -display.cx+640 + self.chiBg:getContentSize().width/2 + self.chiBg2:getContentSize().width/2 + 40
	self.chiBg3 = display.newScale9Sprite('res/images/game/chiview_bg.png', aimX , chi_pos_y+185, cc.size(self.width / 9 * #cards,190)):addTo(self) 
	self.chiBg3:setAnchorPoint(cc.p(0, 0.5))
	self.chiBg3:setTouchEnabled(true)
	self.chiBg3:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
	self.chiBg3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		local x = event.x
		local y = event.y
		print("touchended"..event.name)
		self:onTouchCards3(event,x,y)
	
	end)
	--local icon3 =  display.newSprite("res/images/game/chiview_bi.png"):pos(5, 180):addTo(self.chiBg3)

	self.selectFaGuang3=  display.newSprite("res/images/game/chiview_faguang.png"):pos(startx + self.width / 10 , starty -100):addTo(self.chiBg3)
	self.selectFaGuang3:hide()
	self.selectFaGuang3:setScale(1.2,1.03)
	for i = 1, #cards do
		x = startx + self.width / 10 * i
		y = starty
		
		local tmp_cards = {}
		local biPai = cards[i]
		for j = 1, #biPai do
			if biPai[j] == self.curr_card then
				table.remove(biPai,j)
				break
			end
		end 
		table.insert(biPai,1,self.curr_card)
		x = self.width/ 10 * i - self.width/ 30 - self.offX[#self.curr_level_data3]

		local tmp = app:createConcreteView("game.ChiKanView", biPai, 3, false, nil):addTo(self.chiBg3):pos(x, 100)
		table.insert(self.group_items3, tmp)
		tmp:setScale(1.4)
		tmp:setAnchorPoint(cc.p(0.5, 0.5))

		if i < #cards then
			local sepX =  self.width/ 6 * i + self.width/ 60 - self.offX[#self.curr_level_data3]
			local sepY = 100
			local sep =  display.newSprite("res/images/game/chiview_sep.png"):pos(sepX, sepY):addTo(self.chiBg3)
    		table.insert(self.group_items3, sep)
		end
	end
	table.insert(self.group_items3, self.selectFaGuang3)
end

function ChiView:bgClick()
	if self.choose_level == 3 then
		self:removeAllGroup3()
		self.chiBg3:setVisible(false)
		self.choose_level = 2
	elseif self.choose_level == 2 then
		self:removeAllGroup3()
		self:removeAllGroup2()
		self.chiBg2:setVisible(false)
		self.chiBg3:setVisible(false)
		self.choose_level = 1
	elseif self.choose_level == 1 then
		self:removeAllGroup3()
		self:removeAllGroup2()
		self:removeAllGroup()
		self.chiBg:setVisible(false)
		self.chiBg2:setVisible(false)
		self.chiBg3:setVisible(false)
		self.choose_level = 0
	else
	end
end

return ChiView
