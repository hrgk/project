local BaseAlgorithm = require("app.games.hzmajiang.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local DebugView = require("app.games.DebugView")
local testData = require("app.games.hzmajiang.data.test")
local ZZAlgorithm = require("app.games.hzmajiang.utils.ZZAlgorithm")
local TYPES = gailun.TYPES
local tableNodes = {}
tableNodes.normal = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            -- {type = TYPES.SPRITE, var = "logo_", filename = "res/images/majiang/logo_zm.png", x = display.cx, y = display.cy + 130 * display.width / DESIGN_WIDTH},
            -- {type = TYPES.SPRITE, var = "leftNum_", filename = "res/images/majiang/game/shengyuzhangshu.png", x = display.cx - 180, y = display.cy +25},
            -- {type = TYPES.LABEL, options = {text="房间号", size=28, font = DEFAULT_FONT, color=cc.c3b(220, 255, 184)}, x = 54, y = 623, ap = {0.5, 0.5}},
            {type = TYPES.CUSTOM, var = "directorController_", class = "app.games.hzmajiang.controllers.DirectorController", px = 0.5, py = display.cy + 30 * display.width / DESIGN_WIDTH},
            {type = TYPES.LABEL, var = "labelTableRules_", options = {text="", font=DEFAULT_FONT, size=20, color=cc.c3b(124, 229, 114)}, x = 20, y = display.height, ap = {0, 1}},
        }},
        {type = TYPES.NODE, var = "nodeChui_", children = {
            {type = TYPES.BUTTON, var = "buttonChui_", normal = "res/images/majiang/game/chui.png", px = 0.25, py = 0.5},
            {type = TYPES.BUTTON, var = "buttonBuChui_", normal = "res/images/majiang/game/buchui.png", px = 0.75, py = 0.5},
        
        }},
        {type = TYPES.NODE, var = "nodePublicPokers_"}, --公共牌容器
        {type = TYPES.LABEL, var = "mjTableCardView_", type = TYPES.CUSTOM, class = "app.games.hzmajiang.views.game.MJTableCardView", x = display.cx, y = display.cy + 35},
        {type = TYPES.NODE, var = "nodePlayers_",}, --玩家容器
        {type = TYPES.LABEL, var = "viewProgress_", type = TYPES.CUSTOM, class = "app.games.hzmajiang.views.game.ProgressView", x = display.cx, y = display.cy + 35},
        {type = TYPES.CUSTOM, var = "focusArrow_", class = "app.games.hzmajiang.views.game.FocusArrowView", px = 0.2, py = 0.5, visible = false},
        {type = TYPES.SPRITE, var = "spriteDealer_", filename = "res/images/majiang/game/banker_flag.png", px = 0.086, py = 0.42},
       
        {type = TYPES.NODE, var = "nodeChat1_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat2_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat3_"}, -- 玩家3聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat4_"}, -- 玩家4聊天气泡容器
        {type = TYPES.NODE, var = "nodeHostMaJiang_"}, -- 主玩家的手牌容器，需要最高等级的显示
        {type = TYPES.NODE, var = "nodeAnim_"}, -- 打牌动画容器
        {type = TYPES.SPRITE, var = "nodeRoundOver_"}, -- 结束展示
        {type = TYPES.NODE, var = "nodeFaceAnim_"}, -- 表情动画容器
        {type = TYPES.CUSTOM, var = "tingView_", class = "app.games.csmj.views.game.TingViewNew", visible = true,x = display.cx-600,y = -120},
        {type = TYPES.SPRITE, var = "tgFontBg_", filename = "res/images/majiang/game/tgfont/bg.png", px = 0.5, py = 0.25},
        {type = TYPES.SPRITE, var = "tgFont_", filename = "res/images/majiang/game/tgfont/1.png", px = 0.5, py = 0.25},
    }
}

local logoNames =  {
                        [GAME_MJZHUANZHUAN] = "res/images/majiang/logo_zz.png",
                        [GAME_MJHONGZHONG] = "res/images/majiang/logo_hz.png",
                        -- [GAME_MJSHAOYANG] = "res/images/majiang/logo_sy.png",
                        [GAME_MJCHANGSHA] = "res/images/majiang/logo_cs.png",
                        -- [GAME_MJGUIDONG] = "res/images/majiang/logo_gd.png",
                    }

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatString(POOL_PREFIX)
NumberRoller:setFormatHandler(gailun.utils.formatChips)

local POSITION_OF_DEALER_4 = {
    {-35, 35},
    {-35, 35},
    {-35, 35},
    {-35, 35},
}

local PUBLIC_CARD_SPACE = 68  -- 公共牌间距

local TableView = class("TableView", gailun.BaseView)

function TableView:ctor(table)
    self.table_ = table
    local data = tableNodes.normal
    gailun.uihelper.render(self, data)
    local gameType = dataCenter:getCurGammeType()
    -- local file = logoNames[gameType] or logoNames[GAME_MJZHUANZHUAN]
    -- self.logo_:setTexture(file)

    local debugView = DebugView.new(COMMANDS.HZMJ_DEBUG_CONFIG_CARD, testData)
    debugView:setPosition(display.right - 200, display.top - 100)
    self:addChild(debugView)

    -- self:showByTableState_({to = self.table_:getState()})
    self.tingView_:setVisible(false)
    self.buttonChui_:onButtonClicked(handler(self, self.onChuiClicked_))
    self.buttonBuChui_:onButtonClicked(handler(self, self.onBuChuiClicked_))

    self.buttonTing_ = ccui.Button:create("res/images/majiang/game/tingBtn.png", "res/images/majiang/game/tingBtn.png")
    self:addChild(self.buttonTing_)
    self.buttonTing_:setPosition(display.width - 50, display.bottom + 170)

    self.buttonTing_:addTouchEventListener(handler(self, self.onTingTouch_))
    self:showChuiTool(false)
    display.addSpriteFrames("res/res/images/game/shaiziAnima.plist", "res/res/images/game/shaiziAnima.png")
    self:initShaiZiAnima_()
    self:onChangSkinHandler_({index = setData:getMJBgIndex()})
    self:initTGAnim()
end

function TableView:initTGAnim()
    self.buttonTG_ = ccui.Button:create("res/images/majiang/game/btn_tg.png", "res/images/majiang/game/btn_tg.png", "res/images/majiang/game/btn_qxtg.png")
    self:addChild(self.buttonTG_)
    self.buttonTG_:setPosition(display.left + 280, display.bottom + 150)
    self.buttonTG_:addTouchEventListener(handler(self, self.onTGTouch_))
    self.tgIndex = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.tgIndex = self.tgIndex + 1
                    if self.tgIndex > 3 then
                        self.tgIndex = 1
                    end
                    local frameName = string.format("res/images/majiang/game/tgfont/%d.png", self.tgIndex)
                    local texture = cc.Director:getInstance():getTextureCache():addImage(frameName)
                    self.tgFont_:setTexture(texture)
                end
            )
        }
    )
    self.tgFont_:runAction(cc.RepeatForever:create(sequence))
    self.tgFontBg_:hide()
    self.tgFont_:hide()
end

function TableView:onTGTouch_(sender, eventType)
    self.tableController_ = display.getRunningScene().tableController_
    if eventType == 0 then
        self.tableController_:doTG()
        local isBri = self.buttonTG_:isBright()
        self.buttonTG_:setBright(not isBri)
        self.tgFontBg_:setVisible(isBri)
        self.tgFont_:setVisible(isBri)
    elseif eventType == 1 then
    elseif eventType == 2 then
        -- self.tingView_:setVisible(false)
    elseif eventType == 3 then
        -- self.tingView_:setVisible(false)
    end

end

function TableView:initTG()
    self.buttonTG_:hide()
    self.buttonTG_:setBright(true)
    self.tgFontBg_:hide()
    self.tgFont_:hide()
end

function TableView:onEnter()
    local cls = self.table_.class
    local handlers = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.DEALER_FOUND, handler(self, self.onDealerChanged_)},
        {cls.CONFIG_CHANGED, handler(self, self.onRoomConfigChanged_)},
        {cls.TURN_TO_EVENT, handler(self, self.onTurnToEvent_)},
        {cls.TABLE_CHANGED, handler(self, self.onTableChanged_)},
        {cls.MA_JIANG_COUNT_CHANGED, handler(self, self.onMaJiangCountChanged_)},
        {cls.FINISH_ROUND_CHANGED, handler(self, self.onFinishRoundChanged_)},
        {cls.FOCUS_ON, handler(self, self.onFocusOn_)},
        {cls.GOLD_FLY_EVENT, handler(self, self.onGoldFlyEvent_)}, 
        {cls.ROUND_OVER_EVENT, handler(self, self.onRoundOverEvent_)}, 
        {cls.PLAY_SHAIZI_ANIMA, handler(self, self.playShaiZiAnima_)},  
        {cls.INIT_TABLE_CARDS, handler(self, self.faPaiHideCard_)},    
        {cls.MA_JIANG_COUNT_CHANGED, handler(self, self.setLeftCount_)},   
        {cls.CHANGE_SKIN, handler(self, self.onChangSkinHandler_)},  
    }
    gailun.EventUtils.create(self, self.table_, self, handlers)

    self:showByTableState_({to = self.table_:getState()})
    self:updateTableID_(self.table_:getTid())
end

function TableView:onChangSkinHandler_(event)
    local texture = cc.Director:getInstance():getTextureCache():addImage("res/images/majiang/tableBg/3d/" .. event.index .. ".png")
    display.getRunningScene().bgSprite_:setTexture(texture)
end

function TableView:calcPokerPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * 80
    local x = offset+640
    local y = 0+400
    return x, y
end

function TableView:initShaiZiAnima_()
    local list = {{"shaizianim", "shaizianim%d.png", 0, 5, 0.5, true}}
    self.shaiZiData_ = gameAnim.formatAnimData(unpack(list[1]))
end

function TableView:playShaiZiAnima_(event)
    local shaiZiList = {}
    for i=1,2 do
        local x, y = self:calcPokerPos_(2, i)
        local shaizi = display.newSprite():addTo(self)
        gameAnim.play(shaizi, clone(self.shaiZiData_))
        table.insert(shaiZiList, shaizi)
        shaizi:pos(x,y)
    end
    gameAudio.playSound("sounds/shaizi.mp3")
    self:performWithDelay(function()
        -- local points = BaseAlgorithm.clacShaiZiPoint(event.data.diePoint, self.totalSeat)
        local items  = {}
        
        for i=1,2 do
            transition.stopTarget(shaiZiList[i])
            local path = "res/images/majiang/shaizi"..event.data.saiZi[i]..".png"
            local shaizi = display.newSprite(path):addTo(self)
            shaizi:setPosition(shaiZiList[i]:getPosition())
            shaiZiList[i]:removeSelf()
            table.insert(items, shaizi)
        end
        self:performWithDelay(function()
            for k,v in pairs(items) do
                v:removeSelf()
            end
            end, 2)
    end, 2)
end


function TableView:onRoundOverEvent_()
    self.tingView_:setVisible(false)
end

function TableView:onExit()
    gailun.EventUtils.clear(self)
end

function TableView:showChatBQ_(player, chatID, node)
    local path = string.format("views/yuyinwenzi/face%d.png", chatID)
    local x, y = player:getPlayerPosition()
    local sprite = display.newSprite(path):addTo(node):pos(x, y)
    local moveBy = cc.MoveBy:create(0.4, cc.p(0, 10))
    local seq = transition.sequence({
        moveBy,
        moveBy:reverse(),
        moveBy,
        moveBy:reverse(),
        cc.DelayTime:create(0.8),
        cc.FadeOut:create(0.5),
        cc.RemoveSelf:create()
    })
    sprite:runAction(seq)
end

function TableView:setLeftCount_(event)
    self.mjTableCardView_:setLeftCount(event.count)
end

function TableView:faPaiHideCard_(event)
    self.mjTableCardView_:faPaiHideCard(event.zhuangIndex,event.dice1,event.dice2,event.leftCount)
end

function TableView:faceBQ_(player, chatID, node)
    self:showChatBQ_(player, chatID, node)
end

function TableView:showPlayerChat(player, params, toPlayer)
    local node = self["nodeChat" .. player:getIndex() .. "_"]
    if not node then
        return
    end
    node:removeAllChildren()
    local messageType = params.messageType
    if CHAT_FACE == messageType then
        self:doChatFace_(player, params.messageData, node)
    end
    if CHAT_QUICK == messageType then
        self:doChatQuick_(player, params.wordID, node)
    end
    if CHAT_TEXT == messageType then
        self:doChatText_(player, params.wordID, node)
    end
    if CHAT_VOICE == messageType then
        self:doVoiceChat_(player,params, node)
    end
    if CHAT_FACE_ANIMATION == messageType then
        if setData:getJZBQ() and toPlayer:getUid() == selfData:getUid() then
            return 
        end
        self:faceIconFly_(params.faceID, player, toPlayer)
    end
    if CHAT_FACE_BQ == messageType then
        self:faceBQ_(player, params.messageData, node)
    end
end

function TableView:doVoiceChat_(player, params, node)
    dump(params, "-----asdfasdf")
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    self.voicePlayer_ = player
    self.soundUrl_ = params.url
    self.soundDuration_ = self.soundDuration_ or {}
    local soundDuration_ = params.duration or 1
    table.insert(self.soundDuration_, soundDuration_)
    local fileName =  params.uid .. "_".. params.time .. ".aac"
    local path = gailun.native.getSDCardPath() .. "/" .. fileName
    gailun.HTTP.download(self.soundUrl_, path, function (filePath)
        self:downloadVoiceSuceess_(filePath, params)
    end,
    function (reason)
        self:downloadVoiceFail(reason, params)
    end, 10)
end

function TableView:showChuiTool(show)
    if show then
        self.nodeChui_:show()
        return
    end
    self.nodeChui_:hide()
end

function TableView:onTingTouch_(sender, eventType)
    self.tableController_ = display.getRunningScene().tableController_
    if eventType == 0 then
        if self.tingView_:isVisible() then
            self.tingView_:setVisible(false)
        else
            local seats = self.tableController_:getSeats()
            local handCards = {}
            local waiCards = {}
            local zhuoCards = {}
            local selfHandCards = {}
            for k, v in pairs(seats) do
                if v:isHost() then
                    selfHandCards = clone(v:getCards())
                end
                table.insert(handCards, v:getCards() or {})
                table.insert(waiCards, v:getWaiPai() or {})
                table.insert(zhuoCards, v:getOutCards() or {})
            end
    
            local remainCards = ZZAlgorithm.getRemainCards(handCards, zhuoCards, waiCards)
    
            local hostPlayer = self.tableController_:getHostPlayer()
            local tingPai = ZZAlgorithm.getTingPai(remainCards, 
                hostPlayer:getCards(), 
                display.getRunningScene():getTable():getAllowSevenPairs())
            if display.getRunningScene():getTable():isHongZhong() then
                local count = 0
                for i,v in ipairs(selfHandCards) do
                    if v == 51 then
                        count = count + 1
                    end
                end
                tingPai[51] = 4 - count
            end
            self.tingView_:setCards(tingPai)
            self.tingView_:setVisible(true)
        end
    elseif eventType == 1 then
    elseif eventType == 2 then
        -- self.tingView_:setVisible(false)
    elseif eventType == 3 then
        -- self.tingView_:setVisible(false)
    end

end

function TableView:onChuiClicked_(event)
    local data = {chui = 2}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_PLAYER_CHUI, data)
end

function TableView:onBuChuiClicked_(event)
    local data = {chui = 1}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_PLAYER_CHUI, data)
end

function TableView:downloadVoiceSuceess_(fileName, params)
    chatRecordData:addGameRecord(fileName, params)
    gailun.native.playSound(fileName, handler(self, self.onPlaySoundReturn_))
    -- gailun.native.playSound(fileName)
    -- local duration = self.soundDuration_[1] or 1
    -- table.remove(self.soundDuration_, 1)
    -- self.voicePlayer_:playRecordVoice(duration)
end

function TableView:onPlaySoundReturn_(data)
    if data.flag == 1 then
        self.voicePlayer_:playRecordVoice(data.duration)
    else
        app:showTips("播放失败！")
    end
end

function TableView:downloadVoiceFail(data, params)
    self.downCount_ = self.downCount_ or 0
    self.downCount_ = self.downCount_ + 1
    if self.downCount_ > 2 then
        self.downCount_ = 0
        return
    end
    local fileName =  params.uid .. "_".. params.time .. ".aac"
    local path = gailun.native.getSDCardPath() .. "/" .. fileName
    gailun.HTTP.download(self.soundUrl_, path, function (fileName)
        self:downloadVoiceSuceess_(fileName, params)
    end, 
    function (reason)
        self:downloadVoiceFail(reason, params)
    end, 10)
end

function TableView:doChatFace_(player, index, node)
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    local id = checkint(index)
    if id < 1 then
        return
    end
    local obj = FaceAnimationsData.getMyFaceAnimationById(id)

    if not obj then
        return
    end
    local file = obj.icon
    local x, y = player:getPlayerPosition()
    local sprite = display.newSprite(file):addTo(node):pos(x, y)
    
    local moveBy = cc.MoveBy:create(0.4, cc.p(0, 10))
    local seq = transition.sequence({
        moveBy,
        moveBy:reverse(),
        moveBy,
        moveBy:reverse(),
        cc.DelayTime:create(0.8),
        cc.FadeOut:create(0.5),
        cc.RemoveSelf:create()
    })
    sprite:runAction(seq)
    gameAudio.playSound(obj.sound)
end

function TableView:faceIconFly_(faceID, fromPlayer, toPlayer)
    local data = FaceAnimationsData.getFaceAnimation(faceID)
    local flyIcon = display.newSprite(data.flyIcon):addTo(self.nodeFaceAnim_)
    local startX, startY = fromPlayer:getPlayerPosition()
    local toX, toY =  toPlayer:getPlayerPosition()
    local toIndex = toPlayer:getIndex()
    if toIndex == MJ_TABLE_DIRECTION.LEFT then
        data.offsetX = - data.offsetX
        data.flyIconOffsetX = - data.flyIconOffsetX
        data.flipX = true
    end
    flyIcon:setPosition(startX, startY)
    if data.isXuanZhuan then
        self:zhuanQuanAction_(flyIcon, 0.2)
    end
    transition.moveTo(flyIcon, {x = toX + data.flyIconOffsetX, y = toY + data.flyIconOffsetY, time = 0.5, easing = "exponentialOut", onComplete = function()
        flyIcon:removeFromParent()
        flyIcon = nil
        if data.animation ~= "" then
            data.x = toX - data.offsetX
            data.y = toY - data.offsetY
            gameAnim.createCocosAnimations(data, self.nodeFaceAnim_)
        end
    end})
end

local chatBg = {
    {"res/images/majiang/game/chat_bgl.png", 17, 75, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"res/images/majiang/game/chat_bgr.png", -47, 20, cc.size(300, 80), cc.rect(50, 47, 1, 1), cc.p(1, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"res/images/majiang/game/chat_bgt.png", -14, -88, cc.size(300, 80), cc.rect(30, 47, 1, 1), cc.p(1, 30/80), cc.p(0.5, 0.5), {20, 32}},
    {"res/images/majiang/game/chat_bgl.png", 52, 32, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
}
function TableView:showChatText_(player, chatID, node)
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    local sprite = display.newSprite("res/images/yuyinwenzi/quickChatbg.png"):addTo(node)
    sprite:setCascadeOpacityEnabled(true)
    sprite:setAnchorPoint(ap)
    if player:getIndex() == 1 then
        node:pos(480,230)
    elseif player:getIndex() == 2 then
        node:pos(980,470)
        sprite:setScaleX(-1)
    elseif player:getIndex() == 3 then
        node:pos(750,650)
        sprite:setScaleX(-1)
    elseif player:getIndex() == 4 then
        node:pos(320,480)
    end
    local word = display.newSprite("res/images/yuyinwenzi/word" .. chatID .. ".png"):addTo(node)
    :pos(0,10)
    local seq = transition.sequence({cc.FadeIn:create(0.5), 
        cc.DelayTime:create(3), 
        cc.FadeOut:create(0.5), 
        cc.CallFunc:create(function ()
            node:pos(0,0)
            node:removeAllChildren()
        end)
        })
    node:runAction(seq)
end

function TableView:getProgreesView()
    return self.viewProgress_
end

function TableView:doChatQuick_(player, chatID, node)
    local id = checkint(chatID)
    self:showChatText_(player, chatID, node)
    local sound = string.format("%d.mp3", id)
    gameAudio.playQuickChat(sound, player:getSex())
end

function TableView:doChatText_(player, wordID, node)
    self:showChatText_(player, wordID, node)
end

function TableView:onFinishRoundChanged_(event)
    self.viewProgress_:setRoundState(event.total, event.num)
    local roomID = self.table_:getTid()
    local str =""
    local text = str .. "\n房号:"..roomID
    if self.table_:getMatchType() ~= 2 then
        text = text .. "\n局数:"..event.num.."/"..self.table_:getTotalRound()
    end
    local msg = text 
    self.viewProgress_.labelTableID_:setString(msg)
end

function TableView:onMaJiangCountChanged_(event)
    self.viewProgress_:setCardCount(event.count)
end

function TableView:onTableChanged_(event)
    self:updateTableID_(event.tid)
end

function TableView:updateTableID_(tid)
    self.viewProgress_.labelTableID_:setString("房间号:" .. tostring(tid))
end

function TableView:makeRuleString(spliter)
    local data = self.configData_
    -- 可抢杠胡 庄闲 可胡七对 红中癞子 抓六鸟
    local list = {self:makeGameTypeString(" ")}
    -- if data.maJiangType == 1 then
    --     table.insert(list, "转转麻将")
    -- elseif data.maJiangType == 2 then
    --     table.insert(list, "长沙麻将")
    -- end
    if data then
        -- if data.ruleDetails and data.ruleDetails.fengPai then
        --         if data.ruleDetails.fengPai == 1 then 
        --             table.insert(list, "带风(13幺)")
        --         else
        --             table.insert(list, "不带风")
        --         end
        -- end
        if data.isLaiZi then
            table.insert(list, "红中癞子")
        end
        if data.ruleDetails.huType == 1 then
            table.insert(list, "接炮胡")
        else
            table.insert(list, "自摸胡")
        end

        if data.isLaiZi then
            table.insert(list, "4红中胡")
        end

        if data.ruleDetails and data.ruleDetails then
            if data.ruleDetails.canQiangGangHu == 1 then
                table.insert(list, "抢杠胡")
            end
        end
        -- if data.ruleDetails.isSevenPairs == 1 then
        --     table.insert(list, "可胡七对")
        -- else
        --     table.insert(list, "不可胡七对")
        -- end

        -- if data.ruleDetails.zhuangXian then
        --     table.insert(list, "庄闲(算分)")
        -- end

        -- if data.ruleDetails and data.ruleDetails then
        --     if data.ruleType == 1 and not data.isLaiZi and data.ruleDetails.piaoScore then
        --         if data.ruleDetails.score_rate then

        --             local beishu = {"2-4", "5-10", "10-20"}
        --             table.insert(list, "底分"..data.ruleDetails.score_rate.."-"..data.ruleDetails.score_rate * 2)
        --         end
        --         local piao = data.ruleDetails.piaoScore
        --         local piaoTable = {"不飘", "飘1", "飘2"}
        --         if piao >= 0 and piao <= 2 then
        --             table.insert(list, piaoTable[piao + 1])
        --         end
        --     end
        -- end
        if data.ruleType == 3 then
            table.insert(list, "杠开胡")
            table.insert(list, "锤")
        end
        if data.ruleDetails.birdCount and data.ruleDetails.birdCount > 0 then
            if data.ruleDetails then
                if data.ruleDetails.birdType == 1 then
                    table.insert(list, "顺序鸟")
                elseif data.ruleDetails.birdType == 0 then
                    table.insert(list, "159鸟")
                else
                    if not data.isLaiZi then
                        table.insert(list, "159鸟")
                    end
                end
                if not data.ruleDetails.score_rate then
                    data.ruleDetails.score_rate = 1 
                end
                if data.ruleDetails.birdCount == 1 then
                    table.insert(list, "一码全中")
                else
                    table.insert(list, string.format("抓%d鸟", data.ruleDetails.birdCount))
                end
                if data.isLaiZi then
                    if data.ruleDetails.birdScore == 1 then
                        table.insert(list, "159(+1分)")
                    elseif data.ruleDetails.birdScore == 2 then
                        table.insert(list, "159(+2分)")
                    end
                else
                    if data.ruleDetails.birdCount > 1 then
                        table.insert(list, "中鸟+"..data.ruleDetails.birdScore * data.ruleDetails.score_rate)
                    end
                end

                if data.ruleDetails.fixedBird == 1 then
                    table.insert(list, "预留鸟牌")
                end
            end
        else
            table.insert(list, "不抓鸟")
        end
    end
    return table.concat(list, spliter)
end

function TableView:isSortBird()
    local data = self.configData_
    if data then
        if data.ruleDetails and data.ruleDetails.birdType == 1 then
            return true
        end
    end
end

function TableView:isNoBird()
    local data = self.configData_
    if data then
        if data.birdCount and data.birdCount == 0 then
            return true
        end
    end
end

function TableView:getRoomInfo()
    local roomID = self.table_:getTid() or 0
    local str = ""
    local num, total = display.getRunningScene():getTable():getRoundParams()
    num = num or 0
    num = num + 1
    total = total or  0
    local text = str .. "房间号:"..roomID
    if self.table_:getMatchType() ~= 2 then
        text = text .. " 局数:"..event.num.."/"..self.table_:getTotalRound()
    end
    return text
end

function TableView:makeGameTypeString(spliter)
    
end

function TableView:makeAddRuleString(spliter)
    if self.configData_ then
        local data = self.configData_
        local list = {}
        for i,v in ipairs(data.ruleDetails) do
            if v == 2 then  
                table.insert(list, "耍猴")
            elseif v == 3 then
                table.insert(list, "黄番")
            elseif v == 1 then
                -- table.insert(list, "3提5坎")
            elseif v== 4 then
                table.insert(list, "行行息")
            elseif v== 5 then
                table.insert(list, "听胡")
            end
        end
        return table.concat(list, spliter)
    end
end

function TableView:onRoomConfigChanged_(event)
    self.configData_ = event.data
    self:makeRuleString(" ")
    -- self.labelTableRules_:setString(self:makeRuleString(" "))
end

function TableView:isOneBrid()
    return self.configData_.ruleDetails.birdCount == 1
end

function TableView:getRoomConig()
    return self.configData_ 
end

function TableView:calcNewPublicCardPosition_()
    local width = PUBLIC_CARD_SPACE
    local y = display.cy
    local count = self.nodePublicPokers_:getChildrenCount() or 0
    local x = display.cx - width * 2 + count * width
    return x, y
end

function TableView:filterPokers(cards5)
    local pokers = self.nodePublicPokers_:getChildren()
    for _,v in pairs(checktable(pokers)) do
        if false == table.indexof(cards5, v:getPoker()) then
            v:lowLight()
        else
            v:highLight()
        end
    end
end

function TableView:onTurnToEvent_(event)
    print("==========onTurnToEvent_===========")
    -- if self.configData_.ruleDetails.totalSeat == 3 then return end
    self.directorController_:startTimeCount(event.index, event.seconds)
end

function TableView:focusOn(x, y)
    self.focusArrow_:focusOn(x, y)
end

function TableView:focusOff()
    self.focusArrow_:stop()
end

function TableView:getTableInfo_()
    local str = "初级场 %s（%d人）"
    return string.format(str, self.table_:getName(), self.table_:getMaxPlayer())
end

function TableView:getBlindsInfo_()
    return string.format("盲注 %d/%d", self.table_:getSb(), self.table_:getBb())
end

function TableView:clearEveryThing_()
    self.spriteDealer_:hide()
    self.focusArrow_:hide()
end

function TableView:onStateCheckout_(event)
    self.directorController_:stop()
    self:focusOff()
end

function TableView:stopTimer()
    self.directorController_:stop()
end


function TableView:onStateIdle_(event)
    self.directorController_:hide()
    self.viewProgress_:show()
    self.spriteDealer_:hide()
    self.focusArrow_:hide()

    self.labelTableRules_:show()

    -- self.leftNum_:hide()
end

function TableView:onStatePlaying_(event)
    self:clearEveryThing_()

    self.directorController_:show()
    self.viewProgress_:show()
    self.labelTableRules_:show()
    self.spriteDealer_:show()

    -- self.leftNum_:show()
end

function TableView:showByTableState_(event)
    local state = event.to
    printInfo("TableView:showByTableState_(state)" .. state)
    if state == "playing" then
        self:onStatePlaying_(event)
    elseif state == "idle" then
        self:onStateIdle_(event)
    elseif state == "checkout" then
        self:onStateCheckout_(event)
    else
        printInfo("Unknown Table State Of: " .. state)
    end
end

function TableView:onStateChanged_(event)
    self:showByTableState_(event)
end

function TableView:clearPublicPokers_()
    self.nodePublicPokers_:removeAllChildren()
end

function TableView:showDealerAtIndex_(seatID, anim)
    local player = self:getParent():getPlayerBySeatID(seatID)
    if not player then
        return
    end
    local x, y = player:getPlayerPosition()
    local index = player:getIndex()
    if not POSITION_OF_DEALER_4[index] then
        self.spriteDealer_:hide()
        return
    end
    self.spriteDealer_:show()
    local ox, oy = unpack(POSITION_OF_DEALER_4[index])
    transition.stopTarget(self.spriteDealer_)
    transition.moveTo(self.spriteDealer_, {x = x + ox, y = y + oy, time = 1, easing = "exponentialOut"})
end

function TableView:onAdjustSeats(dealer)
    self:showDealerAtIndex_(dealer)
end

function TableView:onDealerChanged_(event)
    self:showDealerAtIndex_(event.seatID)
end

function TableView:getRoomConfig()
    return self.configData_ 
end

function TableView:onFocusOn_(event)
    self:focusOn(event.x, event.y)
end

function TableView:hideDirectorController()
    self.directorController_:hide()
    -- self.leftNum_:hide()
end

function TableView:stopEffect()
    self.directorController_:stopEffect()
end


function TableView:getGameType()
    local ret = 1
    local data = self.configData_
    -- 可抢杠胡 庄闲 可胡七对 红中癞子 抓六鸟
    if data then
        ret = data.maJiangType or ret
    end
    return ret
end

function TableView:onGoldFlyEvent_(event)
    for i,v in ipairs(event.data) do
        for i,p in ipairs(event.data) do
            if v.winType == -1 and p.winType == 1 then
                local count = math.abs(checknumber(v.updateScore))
                self:creatGoldFly_(count, cc.p(v.posX, v.posY), cc.p(p.posX, p.posY))
            end
        end
    end
    self:performWithDelay(function()
        if event.callfunc then
            event.callfunc()
        end
    end, 2)
end

function TableView:creatGoldFly_(count, startPoint, endPoint)
    local total = math.min(count, 20)
    local delayTime = 0
    for i=1, total do
        self:performWithDelay(function()
            local spriteGold = display.newSprite("res/images/majiang/game/score-bg1.png"):addTo(self):pos(startPoint.x, startPoint.y):scale(2)
            self:zhuanQuanAction_(spriteGold,0.5)
            gameAudio.playSound("sounds/common/chips_to_table.mp3")
            transition.moveTo(spriteGold, {x = endPoint.x, y = endPoint.y, time = 0.5, easing = "exponentialOut", onComplete = function()
                spriteGold:removeFromParent(true)
            end})
        end, delayTime)
        delayTime = delayTime + 0.1
    end
end

function TableView:zhuanQuanAction_(target, timer)
    local sequence = transition.sequence({
        cc.RotateTo:create(timer, 180),
        cc.RotateTo:create(timer, 360),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

return TableView
