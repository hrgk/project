local LocationTipsView = class("LocationTipsView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
    {type = TYPES.NODE, var = "ipTipLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}, children = {
            {type = TYPES.NODE, var = "bgLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}},
            {type = TYPES.SPRITE, var = "locationbg_", filename = "res/images/locationbg.png", scale9 = true, size = {1180, 820}, capInsets = cc.rect(340, 50, 1, 1), x = display.cx, y = display.cy - 20, children = {
            {type = TYPES.SPRITE, filename = "res/images/majiang/game/dw_titile.png", ppx = 0.5, ppy = 0.96, ap = {0.5, 1}},
            {type = TYPES.SPRITE, var = "sanjiao_", filename = "res/images/majiang/sijiao.png", ppx = 0.5, ppy = 0.47, ap = {0.5, 0.5}},
            -- {type = TYPES.LABEL, options = {text = "防作弊提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelusername1_", options = {text = "11111", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.53, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar1_", class = "app.views.AvatarView", ppx = 0.5, ppy = 0.43, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labeluserid1_", options = {text = "11111", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.33, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "labelusername2_", options = {text = "2222", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.82, ppy = 0.4, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar2_", class = "app.views.AvatarView", ppx = 0.82, ppy = 0.31, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labeluserid2_", options = {text = "2222", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.82, ppy = 0.215, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "labelusername3_", options = {text = "3333", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.85, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar3_", class = "app.views.AvatarView", ppx = 0.5, ppy = 0.75, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labeluserid3_", options = {text = "3333", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.5, ppy = 0.65, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "labelusername4_", options = {text = "3333", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.18, ppy = 0.4, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar4_", class = "app.views.AvatarView", ppx = 0.18, ppy = 0.31, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labeluserid4_", options = {text = "3333", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255)}, ppx = 0.18, ppy = 0.215, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "juli1_", options = {text = "111米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.65, ppy = 0.4, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "juli2_", options = {text = "222米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.51, ppy = 0.59, ap = {0, 0.5}},
            {type = TYPES.LABEL, var = "juli3_", options = {text = "333米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.35, ppy = 0.4, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "juli4_", options = {text = "444米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.68, ppy = 0.64, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "juli6_", options = {text = "666米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.32, ppy = 0.64, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "juli5_", options = {text = "555米", 
                size = 26, font = DEFAULT_FONT, color = cc.c4b(171, 99, 56, 255)}, ppx = 0.5, ppy = 0.22, ap = {0.5, 0.5}},


            {type = TYPES.BUTTON, var = "buttonQuit_", autoScale = 0.9, normal = "res/images/majiang/game/quit_room.png", y = 115, x = 330,},
            {type = TYPES.BUTTON, var = "buttonContinue_", autoScale = 0.9, normal = "res/images/majiang/game/button_continue_game.png", y = 115, x = 850},
            {type = TYPES.BUTTON, var = "buttonContinueGaming_", autoScale = 0.9, normal = "res/images/majiang/game/button_continue_game.png", y = 115, x = 590, visible= false},
        }},
    }
    }}
}


function LocationTipsView:ctor(params,data, isKaiju)
    -- dump(params)
    -- self.layerBG_ = display.newColorLayer(cc.c4b(0, 0, 0, 99)):addTo(self)

    gailun.uihelper.render(self, nodes)
    -- self.labelIP_:setLineHeight(55)
    -- self.isIdle_ = dataCenter:getPokerTable():isIdle()
    if false then
        self.buttonQuit_:setButtonImage('pressed', "res/images/majiang/game/quit_room.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/majiang/game/quit_room.png")
    else
        self.buttonQuit_:setButtonImage('pressed', "res/images/majiang/game/button_dismiss2.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/majiang/game/button_dismiss2.png")
    end
    if not isKaiju then
        self.buttonQuit_:hide()
        self.buttonContinue_:hide()
        self.buttonContinueGaming_:show()
        -- self.locationbg_:setTouchEnabled(true)
        -- self.locationbg_:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
        -- self.locationbg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --  if event.name == "began" then 
        --      return true
        --  elseif event.name == "moved" then 
        --  elseif event.name == "ended" then
        --      -- self:doClose()
        --  end
        -- end)
        -- gailun.uihelper.setTouchHandler(self.bgLayer_, handler(self, self.onBgClicked_))
    end

    self.buttonQuit_:onButtonClicked(handler(self, self.onQuitClicked_))
    self.buttonContinue_:onButtonClicked(handler(self, self.onContinueClicked_))
    self.buttonContinueGaming_:onButtonClicked(handler(self, self.onContinueGamingClicked_))


    self.ipTipLayer_:setTouchEnabled(true)
    self.ipTipLayer_:setTouchSwallowEnabled(true)
    self:updateTips_(params, data)
    
end
function LocationTipsView:onBgClicked_(event)
    print("onBgClicked_(event)")
    self:doClose()
end
-- 【ssssss你是谁】、【城有要有有】IP相同【ssssss你是谁】、【城有要有有】IP相同
function LocationTipsView:updateTips_(params,data)
    if #params ~= 4 then
        return
    end 
    -- dump(params)

    if #params >= 1 then
        --todo
        local player = params[1]
        self.labelusername1_:setString(player.nickName)
        self.avatar1_:showWithUrl(player.avatar)
        self.labeluserid1_:setString(player.uid)
    end
    if #params >= 2 then
        local player = params[2]
        self.labelusername2_:setString(player.nickName)
        self.avatar2_:showWithUrl(player.avatar)
        self.labeluserid2_:setString(player.uid)
    end

    if #params >= 3 then
        local player = params[3]
        self.labelusername3_:setString(player.nickName)
        self.avatar3_:showWithUrl(player.avatar)
        self.labeluserid3_:setString(player.uid)
    end

    if #params >= 4 then
        local player = params[4]
        self.labelusername4_:setString(player.nickName)
        self.avatar4_:showWithUrl(player.avatar)
        self.labeluserid4_:setString(player.uid)
    end

    self.labeluserid1_:setVisible(CHANNEL_CONFIGS.IP)
    self.labeluserid2_:setVisible(CHANNEL_CONFIGS.IP)
    self.labeluserid3_:setVisible(CHANNEL_CONFIGS.IP)
    self.labeluserid4_:setVisible(CHANNEL_CONFIGS.IP)

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


    if data[4] == -1 then
        self.juli4_:setString("未知")
    elseif data[4] > 1000 then
        local distance = math.floor(data[4]/100)/10
        self.juli4_:setString(distance.."千米")
    else
        self.juli4_:setString(data[4].."米")
    end

    if data[5] == -1 then
        self.juli5_:setString("未知")
    elseif data[5] > 1000 then
        local distance = math.floor(data[5]/100)/10
        self.juli5_:setString(distance.."千米")
    else
        self.juli5_:setString(data[5].."米")
    end

    if data[6] == -1 then
        self.juli6_:setString("未知")
    elseif data[6] > 1000 then
        local distance = math.floor(data[6]/100)/10
        self.juli6_:setString(distance.."千米")
    else
        self.juli6_:setString(data[6].."米")
    end
    
    local showStr = ""--table.concat(showList, "\n")
    -- self.labelIP_:setString(showStr)
end

function LocationTipsView:onQuitClicked_(event)
    -- if self.isIdle_ then
    if not dataCenter:getPokerTable():isOwner(dataCenter:getHostPlayer():getUid()) then
        dataCenter:sendOverSocket(COMMANDS.MJ_LEAVE_ROOM)
    else
        -- dataCenter:sendOverSocket(COMMANDS.MJ_REQUEST_DISMISS, {agree = true})
        dataCenter:sendOverSocket(COMMANDS.MJ_OWNER_DISMISS)
    end
    self:doClose()
end

function LocationTipsView:onContinueClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.MJ_READY)
    self:doClose()
end

function LocationTipsView:onContinueGamingClicked_(event)
    self:doClose()
end

function LocationTipsView:doClose()
    self:removeFromParent()
end

return LocationTipsView
