local LocationTipsView = class("LocationTipsView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
    {type = TYPES.NODE, var = "ipTipLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}, children = {
            {type = TYPES.NODE, var = "bgLayer_", size = {display.width, display.height}, color = cc.c4b(0, 0, 0, 99), ap = {0, 0}},
            {type = TYPES.SPRITE, var = "locationbg_", filename = "res/images/common/gameButton/view_gps_bg.png", x = display.cx, y = display.cy , children = {
            -- {type = TYPES.SPRITE, filename = "res/images/game_img_yydi.png",ppx = 0.5, ppy = 0.16, scale9 = true, capInsets = cc.rect(30, 30, 30, 30), size = {754, 368},ap = {0.5 ,0}},
            {type = TYPES.SPRITE, filename = "images/clubs/view_bg3.png",ppx = 0.375, ppy = 0.15,scaleX = 0.75,scaleY = 0.68, scale9 = false, capInsets = cc.rect(30, 30, 30, 30), size = {754, 368},ap = {0.5 ,0}},
            -- {type = TYPES.SPRITE, var = "locationsbg_", filename = "images/dingwei_back.png", scale9 = true, size = {489, 302}, capInsets = cc.rect(50, 50, 1, 1),ppx = 0.5, ppy = 0.5},

            -- {type = TYPES.SPRITE, var = "sanjiao_", filename = "images/sanjiao.png", ppx = 0.5, ppy = 0.65, ap = {0.5, 0.5}},
            -- {type = TYPES.LABEL, options = {text = "防作弊提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelusername1_", options = {text = "11111",
                size = 20, font = DEFAULT_FONT, color = cc.c4b(255, 97, 27, 255)}, ap = {0, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar1_", class="app.views.AvatarSquareView",classParams = {nil, nil, nil, 0.5,false}, scale = 0.7, ap = {0.5, 0.5}},
            --{type = TYPES.LABEL, var = "labeluserid1_", options = {text = "11111",
                --size = 18, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ppx = 0.07, ppy = 0.5, ap = {0, 0.5}},

            {type = TYPES.LABEL, var = "labelusername2_", options = {text = "2222",
                size = 20, font = DEFAULT_FONT, color = cc.c4b(255, 97, 27, 255)}, ap = {1, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar2_", class="app.views.AvatarSquareView", classParams = {nil, nil, nil, 0.5,false}, scale = 0.7, ap = {0.5, 0.5}},
            --{type = TYPES.LABEL, var = "labeluserid2_", options = {text = "2222",
                --size = 18, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ppx = 0.93, ppy = 0.5, ap = {1, 0.5}},

            {type = TYPES.LABEL, var = "labelusername3_", options = {text = "3333",
                size = 20, font = DEFAULT_FONT, color = cc.c4b(255, 97, 27, 255)}, ap = {0, 0.5}},
            {type = TYPES.CUSTOM, var = "avatar3_", class="app.views.AvatarSquareView", classParams = {nil, nil, nil, 0.5,false}, scale = 0.7, ap = {0.5, 0.5}},
            --{type = TYPES.LABEL, var = "labeluserid3_", options = {text = "3333",
                --size = 18, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ppx = 0.2, ppy = 0.35, ap = {0, 0.5}},

            {type = TYPES.LABEL, var = "juli1_", options = {text = "333米", --上
                size = 24, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "juli2_", options = {text = "333米", --右
                size = 24, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "juli3_", options = {text = "333米", --左
                size = 24, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},

            {type = TYPES.LABEL, var = "line3_", options = {text = "---------------", --左
                size = 20, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "line1_", options = {text = "--------------------------------", --上
                size = 20, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "line2_", options = {text = "---------------", --右
                size = 20, font = DEFAULT_FONT, color = cc.c4b(177, 101, 63, 255)}, ap = {0.5, 0.5}},

            {type = TYPES.BUTTON, var = "buttonQuit_", autoScale = 0.9, normal = "res/images/common/gameButton/btn_dissilution.png", ppy = 0.08, ppx = 0.25,},
            {type = TYPES.BUTTON, var = "buttonContinue_", autoScale = 0.9, normal = "res/images/common/gameButton/btn_jxyxan.png", ppy = 0.08, ppx = 0.75},
            {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closeBtn.png",
            options = {}, ppx = 0.985, ppy = 0.94 },

            {type = TYPES.LABEL, var = "ipTishi_", options = {text = "",
                size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 13, 11, 255)}, ppx=0.5, ppy=0.22, ap = {0.5, 0.5}},
        }},
    }
    }}
}
--两人
local TWO_AVATAR_POS={      --头像
    {x=0.25,y=0.55},
    {x=0.75,y=0.55},
}

local TWO_NAME_POS={        --名字
    {x=0.20,y=0.44},
    {x=0.80,y=0.44},
}

local TWO_DISTANCE_POS={    --距离
    {x=0.50,y=0.60},
}

local TWO_LINE_POS={        --线
    {x=0.50,y=0.55},
}

--三人
local THREE_AVATAR_POS={    --头像
    {x=0.18,y=0.72},
    {x=0.82,y=0.72},
    {x=0.50,y=0.42},
}

local THREE_NAME_POS={      --名字
    {x=0.13,y=0.60},
    {x=0.87,y=0.60},
    {x=0.45,y=0.30},
}

local THREE_DISTANCE_POS={  --距离
    {x=0.50,y=0.80},    --上
    {x=0.75,y=0.53},    --右
    {x=0.25,y=0.53},    --左
}

local THREE_LINE_POS={      --线
    {x=0.5,y=0.72},     --上
    {x=0.66,y=0.58},    --右
    {x=0.34,y=0.58},    --左
}

local THREE_LINE_ANGLE={    --角度
    0,                  --上
    150,                --右
    30,                 --左
}

function LocationTipsView:ctor(params,data, isKaiju)
    -- dump(params)
    -- self.layerBG_ = display.newColorLayer(cc.c4b(0, 0, 0, 99)):addTo(self)
    gailun.uihelper.render(self, nodes)
    self:init(params)
    self.isIdle_ = display:getRunningScene():getTable():isIdle()
    if not display:getRunningScene():getTable():isOwner(dataCenter:getHostPlayer():getUid()) then
        self.buttonQuit_:setButtonImage('pressed', "res/images/common/gameButton/btn_tcfjan.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/common/gameButton/btn_tcfjan.png")
    else
        self.buttonQuit_:setButtonImage('pressed', "res/images/common/gameButton/btn_jsfjx.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/common/gameButton/btn_jsfjx.png")
    end
    self.buttonClosed_:hide()
    if not isKaiju then
        self.buttonClosed_:show()
        self.buttonQuit_:hide()
        self.buttonContinue_:hide()
        self.locationbg_:setTouchEnabled(true)
        self.locationbg_:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
        self.locationbg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                return true
            elseif event.name == "moved" then
            elseif event.name == "ended" then
                -- self:doClose()
            end
        end)
        gailun.uihelper.setTouchHandler(self.bgLayer_, handler(self, self.onBgClicked_))
    end

    self.buttonQuit_:onButtonClicked(handler(self, self.onQuitClicked_))
    self.buttonContinue_:onButtonClicked(handler(self, self.onContinueClicked_))
    self.ipTipLayer_:setTouchEnabled(true)
    self.ipTipLayer_:setTouchSwallowEnabled(true)
    self:updateTips_(params,data)
    self.buttonClosed_:onButtonClicked(handler(self,self.doClose))

end

function LocationTipsView:init(params)--判断最大游戏人数
    for i=1,3 do
        self["avatar" .. i .. "_"]:setVisible(false)
        self["labelusername" .. i .. "_"]:setVisible(false)
        self["juli" .. i .. "_"]:setVisible(false)
        self["line" .. i .. "_"]:setVisible(false)
    end
    local size = self.locationbg_:getContentSize()
    local table = display:getRunningScene():getTable()--获取桌子
    self.MaxPlayer_ = 0 --= table:getMaxPlayer()--获取最大人数
    local userNum_ = 0
    for _,v in ipairs(params) do
        if v.uid and v.uid ~= 0 then
            self.MaxPlayer_ = self.MaxPlayer_ + 1
        end
    end
    -- dump(self.MaxPlayer_)
    --MaxPlayer=2
    if 3 == self.MaxPlayer_ then
        for i=1,3 do
            self["avatar" .. i .. "_"]:setPosition(size.width*THREE_AVATAR_POS[i].x,size.height*THREE_AVATAR_POS[i].y)
            self["labelusername" .. i .. "_"]:setPosition(size.width*THREE_NAME_POS[i].x,size.height*THREE_NAME_POS[i].y)
            self["juli" .. i .. "_"]:setPosition(size.width*THREE_DISTANCE_POS[i].x,size.height*THREE_DISTANCE_POS[i].y)
            self["line" .. i .. "_"]:setPosition(size.width*THREE_LINE_POS[i].x,size.height*THREE_LINE_POS[i].y)
            self["line" .. i .. "_"]:setRotation(THREE_LINE_ANGLE[i])
            self["avatar" .. i .. "_"]:setVisible(true)
            self["labelusername" .. i .. "_"]:setVisible(true)
            self["juli" .. i .. "_"]:setVisible(true)
            self["line" .. i .. "_"]:setVisible(true)
        end
    elseif 2 == self.MaxPlayer_ then
        self.juli1_:setPosition(size.width*TWO_DISTANCE_POS[1].x,size.height*TWO_DISTANCE_POS[1].y)
        self.line1_:setPosition(size.width*TWO_LINE_POS[1].x,size.height*TWO_LINE_POS[1].y)
        self.line1_:setString("------------------------")
        self.juli1_:setVisible(true)
        self.line1_:setVisible(true)
        for i=1,2 do
            self["avatar" .. i .. "_"]:setPosition(size.width*TWO_AVATAR_POS[i].x,size.height*TWO_AVATAR_POS[i].y)
            self["labelusername" .. i .. "_"]:setPosition(size.width*TWO_NAME_POS[i].x,size.height*TWO_NAME_POS[i].y)
            self["avatar" .. i .. "_"]:setVisible(true)
            self["labelusername" .. i .. "_"]:setVisible(true)
        end
    end
end

function LocationTipsView:onBgClicked_(event)
    print("onBgClicked_(event)")
    --self:doClose()
end

function LocationTipsView:formatDistance_(distance)
    if not distance then
        return ""
    end
    if -1 == distance then
        return "地理位置未知"
    end
    if distance < 1000 then
        return distance .. "米"
    end
    return string.format("%.1f千米", distance / 1000)
end

function LocationTipsView:setLineColor(i,distance)
    local templine =nil
    local tempjuli=nil
    if 1 == i then
        templine=self.line1_
        tempjuli=self.juli1_
    elseif 2 == i then
        templine=self.line2_
        tempjuli=self.juli2_
    elseif 3 == i then
        templine=self.line3_
        tempjuli=self.juli3_
    end

    if distance <= 100 and distance ~= -1 then--红
        templine:setColor(cc.c4b(255, 13, 11, 255))
        tempjuli:setColor(cc.c4b(255, 13, 11, 255))
    elseif distance > 100 and distance <= 1000 then--绿
        templine:setColor(cc.c4b(58, 136, 67, 255))
        tempjuli:setColor(cc.c4b(58, 136, 67, 255))
    else--蓝
        templine:setColor(cc.c4b(40, 90, 153, 255))--蓝
        tempjuli:setColor(cc.c4b(40, 90, 153, 255))
    end
end

function LocationTipsView:updateTips_(params, data)
    dump(params)
    local userNum_ = 0
    for _,v in ipairs(params) do
        if v.uid and v.uid ~= 0 then
            userNum_ = userNum_ + 1
        end
    end
    print(userNum_)
    -- if userNum_ ~= 3 then
    --     return
    -- end

    if userNum_ >= 1 then
        local player = params[1]
        self.labelusername1_:setString(player.nickName)
        self.avatar1_:showWithUrl(player.avatar)
        --self.labeluserid1_:setString(player.IP)
    end
    if userNum_ >= 2 then
        local player = params[2]
        self.labelusername2_:setString(player.nickName)
        self.avatar2_:showWithUrl(player.avatar)
        --self.labeluserid2_:setString(player.IP)
    end

    if userNum_ >= 3 then
        local player = params[3]
        self.labelusername3_:setString(player.nickName)
        self.avatar3_:showWithUrl(player.avatar)
        --self.labeluserid3_:setString(player.IP)
    end
    --self.labeluserid1_:setVisible(CHANNEL_CONFIGS.IP)
    --self.labeluserid2_:setVisible(CHANNEL_CONFIGS.IP)
    --self.labeluserid3_:setVisible(CHANNEL_CONFIGS.IP)
    if not data then
        return
    end
    self.juli1_:setString(self:formatDistance_(data[1]))--上
    self.juli2_:setString(self:formatDistance_(data[3]))--左  -- 特别注意索引与位置关系
    self.juli3_:setString(self:formatDistance_(data[2]))--右

    --设置距离线颜色
    self:setLineColor(1,data[1])
    self:setLineColor(2,data[3])
    self:setLineColor(3,data[2])

    --查找相同ip
    self:findSameIp_(params)
end

function LocationTipsView:findSameIp_(params)
    if params[self.MaxPlayer_].IP == nil then
        return
    end

    local table = {}
    if 3 == self.MaxPlayer_ then
       if params[1].IP == params[2].IP then
            table={1,2}
            if params[1].IP == params[3].IP then
                table={1,2,3}
            end
        elseif params[1].IP == params[3].IP then
            table={1,3}
        elseif params[2].IP == params[3].IP then
            table={2,3}
        end
    elseif 2 == self.MaxPlayer_ then
        if params[1].IP == params[2].IP then
            table={1,2}
        end
    end

    if 3 == #table then
        self.ipTishi_:setString("玩家".." "..gailun.utf8.formatNickName(params[table[1]].nickName, 8, '...').." "..gailun.utf8.formatNickName(params[table[2]].nickName, 8, '...').." "..gailun.utf8.formatNickName(params[table[3]].nickName, 8, '...').." ".."IP地址相同！")
    elseif 2 == #table then
        self.ipTishi_:setString("玩家".." "..gailun.utf8.formatNickName(params[table[1]].nickName, 8, '...').." "..gailun.utf8.formatNickName(params[table[2]].nickName, 8, '...').." ".."IP地址相同！")
    end
end

function LocationTipsView:onQuitClicked_(event)
    -- if self.isIdle_ then
    if not display:getRunningScene():getTable():isOwner(dataCenter:getHostPlayer():getUid()) then
        dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_LEAVE_ROOM)
    else
        -- dataCenter:sendOverSocket(COMMANDS.REQUEST_DISMISS, {agree = true})
        local obj = {}
        obj.roomID = display:getRunningScene():getTable():getTid()
        dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_OWNER_DISMISS, obj)
    end
    self:doClose()
end

function LocationTipsView:onContinueClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.SHUANGKOU_READY)
    self:doClose()
end

function LocationTipsView:doClose()
    self:removeFromParent()
end

return LocationTipsView
