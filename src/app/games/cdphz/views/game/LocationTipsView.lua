local LocationTipsView = class("LocationTipsView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
	type = TYPES.ROOT, children = {
	{type = TYPES.NODE, var = "ipTipLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}, children = {
			{type = TYPES.NODE, var = "bgLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}},
			{type = TYPES.SPRITE, var = "locationbg_", filename = "res/images/locationbg.png", scale9 = true, size = {1180, 692}, capInsets = cc.rect(340, 50, 1, 1), x = display.cx, y = display.cy, children = {
			-- {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.985, ap = {0.5, 1}},
            {type = TYPES.SPRITE, var = "sanjiao_", filename = "res/images/sanjiao.png", ppx = 0.5, ppy = 0.55, ap = {0.5, 0.5}},
			-- {type = TYPES.LABEL, options = {text = "防作弊提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "labelusername3_", options = {text = "3333", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.28, ppy = 0.8, ap = {0.5, 0.5}},
			{type = TYPES.CUSTOM, var = "avatar3_", class = "app.views.AvatarView", ppx = 0.28, ppy = 0.7, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "labeluserid3_", options = {text = "3333", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.28, ppy = 0.6, ap = {0.5, 0.5}},

			{type = TYPES.LABEL, var = "labelusername2_", options = {text = "2222", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.72, ppy = 0.8, ap = {0.5, 0.5}},
			{type = TYPES.CUSTOM, var = "avatar2_", class = "app.views.AvatarView", ppx = 0.72, ppy = 0.7, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "labeluserid2_", options = {text = "2222", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.72, ppy = 0.6, ap = {0.5, 0.5}},

			{type = TYPES.LABEL, var = "labelusername1_", options = {text = "1111", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.36, ap = {0.5, 0.5}},
			{type = TYPES.CUSTOM, var = "avatar1_", class = "app.views.AvatarView", ppx = 0.5, ppy = 0.26, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "labeluserid1_", options = {text = "1111", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.16, ap = {0.5, 0.5}},

			{type = TYPES.LABEL, var = "juli3_", options = {text = "333米", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.75, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "juli2_", options = {text = "222米", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.38, ppy = 0.55, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "juli1_", options = {text = "111米", 
				size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.62, ppy = 0.55, ap = {0.5, 0.5}},


			{type = TYPES.BUTTON, var = "buttonQuit_", autoScale = 0.9, normal = "res/images/game/quit_room.png", y = 120, x = 330,},
			{type = TYPES.BUTTON, var = "buttonContinue_", autoScale = 0.9, normal = "res/images/game/button_continue_game.png", y = 120, x = 850},

		}},
	}
	}}
}


function LocationTipsView:ctor(params,data, isKaiju)
	-- dump(params)
	-- self.layerBG_ = display.newColorLayer(cc.c4b(0, 0, 0, 99)):addTo(self)

	gailun.uihelper.render(self, nodes)

	-- if true then
	-- 	return
	-- end	
	-- self.labelIP_:setLineHeight(55)
	self.isIdle_ = dataCenter:getPokerTable():isIdle()
	if not dataCenter:getPokerTable():isOwner(dataCenter:getHostPlayer():getUid()) then
		self.buttonQuit_:setButtonImage('pressed', "res/images/game/quit_room.png")
		self.buttonQuit_:setButtonImage('normal', "res/images/game/quit_room.png")
	else
		self.buttonQuit_:setButtonImage('pressed', "res/images/game/button_dismiss2.png")
		self.buttonQuit_:setButtonImage('normal', "res/images/game/button_dismiss2.png")
	end
	if not isKaiju then
		self.buttonQuit_:hide()
		self.buttonContinue_:hide()
		self.locationbg_:setTouchEnabled(true)
		self.locationbg_:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
		self.locationbg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "began" then 
				return true
			elseif event.name == "moved" then 
			elseif event.name == "ended" then
				self:doClose()
			end
		end)
		gailun.uihelper.setTouchHandler(self.bgLayer_, handler(self, self.onBgClicked_))
	end

	self.buttonQuit_:onButtonClicked(handler(self, self.onQuitClicked_))
	self.buttonContinue_:onButtonClicked(handler(self, self.onContinueClicked_))
	self.ipTipLayer_:setTouchEnabled(true)
	self.ipTipLayer_:setTouchSwallowEnabled(true)
	self:updateTips_(params,data)
	
end
function LocationTipsView:onBgClicked_(event)
	print("onBgClicked_(event)")
    self:doClose()
end
-- 【ssssss你是谁】、【城有要有有】IP相同【ssssss你是谁】、【城有要有有】IP相同
function LocationTipsView:updateTips_(params,data)
	if #params ~= 3 then
		return
	end	
	-- dump(params)

	if #params >= 1 then
		--todo
		local player = params[1]
		self.labelusername1_:setString(player.nickName)
	    self.avatar1_:showWithUrl(player.avatar)
		self.labeluserid1_:setString(player.IP)
	end
	if #params >= 2 then
		local player = params[2]
		self.labelusername2_:setString(player.nickName)
	    self.avatar2_:showWithUrl(player.avatar)
		self.labeluserid2_:setString(player.IP)
	end

	if #params >= 3 then
		local player = params[3]
		self.labelusername3_:setString(player.nickName)
	    self.avatar3_:showWithUrl(player.avatar)
		self.labeluserid3_:setString(player.IP)
	end
	self.labeluserid1_:setVisible(CHANNEL_CONFIGS.IP)
	self.labeluserid2_:setVisible(CHANNEL_CONFIGS.IP)
	self.labeluserid3_:setVisible(CHANNEL_CONFIGS.IP)
	if not data then
		return
	end

	if data[1] == -1 then
		self.juli1_:setString("未知")
	elseif data[1] > 1000 then
		local distance = math.floor(data[1]/100)/10
		self.juli1_:setString(distance.."千米")
	else
		self.juli1_:setString(data[1].."米")
	end


	if data[2] == -1 then
		self.juli2_:setString("未知")
	elseif data[2] > 1000 then
		local distance = math.floor(data[2]/100)/10
		self.juli2_:setString(distance.."千米")
	else
		self.juli2_:setString(data[2].."米")
	end

	if data[3] == -1 then
		self.juli3_:setString("未知")
	elseif data[3] > 1000 then
		local distance = math.floor(data[3]/100)/10
		self.juli3_:setString(distance.."千米")
	else
		self.juli3_:setString(data[3].."米")
	end
	
	local showStr = ""--table.concat(showList, "\n")
	-- self.labelIP_:setString(showStr)
end

function LocationTipsView:onQuitClicked_(event)
	-- if self.isIdle_ then
	if not dataCenter:getPokerTable():isOwner(dataCenter:getHostPlayer():getUid()) then
		dataCenter:sendOverSocket(COMMANDS.LEAVE_ROOM)
	else
		-- dataCenter:sendOverSocket(COMMANDS.REQUEST_DISMISS, {agree = true})
		dataCenter:sendOverSocket(COMMANDS.OWNER_DISMISS)
	end
	self:doClose()
end

function LocationTipsView:onContinueClicked_(event)
	dataCenter:sendOverSocket(COMMANDS.READY)
	self:doClose()
end

function LocationTipsView:doClose()
	self:removeFromParent()
end

return LocationTipsView
