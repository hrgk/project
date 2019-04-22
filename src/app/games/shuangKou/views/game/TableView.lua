local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local ShuangKouAlgorithm = import("app.games.shuangKou.utils.ShuangKouAlgorithm")
local ShuangKouCardType = import("app.games.shuangKou.utils.ShuangKouCardType")
local PokerListView = import(".PokerListView")
local PokerView = import("app.views.game.PokerView")

local TYPES = gailun.TYPES
local tableNodes = {}
tableNodes.normal = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            {type = TYPES.LABEL, var = "viewProgress_", type = TYPES.CUSTOM, class = "app.games.shuangKou.views.game.ProgressView"},
            {type = TYPES.LABEL, var = "labelTableRules_", options = {text="", font=DEFAULT_FONT, size=38, color=cc.c3b(5, 67, 103)}, x = display.cx - 150, y = 700, ap = {0.5, 0.5}},
        }},
        -- {type = TYPES.CUSTOM, var = "scoreNode_", class = "app.games.shuangKou.views.game.CountingScoreView"}, --计分面板
        {type = TYPES.NODE, var = "nodePublicPokers_"}, --公共牌容器
        {type = TYPES.NODE, var = "nodePlayers_",}, --玩家容器
        {type = TYPES.NODE, var = "nodePokerContent_"}, -- 主玩家的手牌容器，需要最高等级的显示
        {type = TYPES.SPRITE, var = "spriteDealer_", filename = "res/images/game/flag_zhuang.png", x = display.cx, y = display.cy},
        {type = TYPES.NODE, var = "nodeJianFenQu_", x = DAI_JIAN_FEN_X, y = DAI_JIAN_FEN_Y},
        {type = TYPES.NODE, var = "nodeChat1_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat2_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat3_"}, -- 玩家3聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat4_"}, -- 玩家4聊天气泡容器
        {type = TYPES.CUSTOM, var = "directorController_", class = "app.games.shuangKou.controllers.DirectorController"},

        {type = TYPES.NODE, var = "nodeAnim_"}, -- 打牌动画容器
        {type = TYPES.NODE, var = "nodeFaceAnim_"}, -- 表情动画容器


        {type = TYPES.SPRITE, visible = false, var = "nodeGroupInfo_", filename = "res/images/shuangKou/game/groupBg.png", ap = {0, 0.5}, x = display.left, y = display.top - 80, children = {
            {type = TYPES.LABEL, options = {text = "分组:", size = 28, color = cc.c3b(216,209,95), font = DEFAULT_FONT}, x = 10, ppy = 0.5, ap = {0, 0.5}},
            {type = TYPES.SPRITE, var = "cardType_", filename = "res/images/shuangKou/game/meihua.png", ppx = 0.46, ppy = 0.55, ap = {0.5, 0.5}},
			{type = TYPES.LABEL, var = "cardValue_", options = {text = "3", size = 28, color = cc.c3b(11,11,11), font = DEFAULT_FONT}, x = 132, ppy = 0.55, ap = {0.5, 0.5}},
        }}, -- 分组展示
    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatString(POOL_PREFIX)
NumberRoller:setFormatHandler(gailun.utils.formatChips)

local POSITION_OF_DEALER_4 = {
    -- {-35, 35},
    -- {35, 35},
    -- {-35, 35},
}

local NODE_FAPAI_POS = {
    -- {200, 200},
    -- {1050, 600},
    -- {200, 600},
}

local PUBLIC_CARD_SPACE = 68  -- 公共牌间距
local PASS_POINT_Y = 750

local ALARM_POSITION = {
    -- {90 / DESIGN_WIDTH * display.width, 280},
    -- {1070 / DESIGN_WIDTH * display.width, 580},
    -- {200 / DESIGN_WIDTH * display.width, 580}
}

local TableView = class("TableView", gailun.BaseView)

function TableView:ctor(table)
    self.table_ = table
    local data = tableNodes.normal
    gailun.uihelper.render(self, data)
    self:showByTableState_({to = self.table_:getState()})
    self.downCount_ = 0
    self.viewProgress_:updateTableID_(self.table_:getTid())

    self:dealData()
    -- self:showPoker(408)
end

function TableView:showPoker(card, isAni)
    print(card, "showPoker")
    if self.groupPoker_ ~= nil then
        self.groupPoker_:removeSelf()
        self.groupPoker_ = nil
    end

    if card == nil or card == 0 then
        self.nodeGroupInfo_:hide()
        return
    end

    local node = cc.Node:create()
    self:addChild(node)

    local poker = PokerView.new(card):addTo(node)
    poker:setPosition(display.cx, display.cy + 100)
    poker:fanPai()

    poker:setScale(0.5)
    if isAni == false then
        poker:setScale(0)
    end

    local actionList = {}
    if isAni ~= false then
        actionList = {
            cc.ScaleTo:create(0.1, 0, 0.6),
            cc.CallFunc:create(function ()
                poker:makePaiBei_()
            end),
            cc.ScaleTo:create(0.1, 1, 0.7),
            cc.ScaleTo:create(0.1, 0, 0.8),
            cc.CallFunc:create(function ()
                poker:fanPai()
            end),
            cc.ScaleTo:create(0.1, 1, 1),
            cc.DelayTime:create(2),
            cc.Spawn:create({
                cc.ScaleTo:create(0.3, 0),
                -- cc.MoveTo:create(0.3, cc.p(display.left + 450, display.top - 40)),
            }),
        }
    end

    table.insert(actionList, 
        cc.CallFunc:create(function ()
            poker:removeSelf()
            self.nodeGroupInfo_:show()
            local value = card % 100
            local type = math.floor(card / 100)
            local path = {
                "fangkuai", "meihua", "hongxin", "heitao"
            }

            self.cardType_:setTexture("res/images/shuangKou/game/" .. path[type] .. ".png")

            if value == 11 then
                value = "J"
            elseif value == 12 then
                value = "Q"
            elseif value == 13 then
                value = "K"
            elseif value == 14 then
                value = "A"
            elseif value == 16 then
                value = "2"
            end
            self.cardValue_:setString(value)
        end))

    local actions = cc.Sequence:create(actionList)

    poker:runAction(actions)

    self.groupPoker_ = node
end

function TableView:dealData()
    if self.table_:getMaxPlayer() == 2 then
            ALARM_POSITION = {
                {70 / DESIGN_WIDTH * display.width, 250},
                -- {1050 / DESIGN_WIDTH * display.width, 580},
                {200 / DESIGN_WIDTH * display.width, 480}
            }
            NODE_FAPAI_POS = {
                {200, 200},
                -- {1050, 600},
                {200, 600},
            }
            POSITION_OF_DEALER_4 = {
                {-35, 35},
                {35, 35},
                {-35, 35},
            }

    elseif self.table_:getMaxPlayer() == 3 then
            ALARM_POSITION = {
                {70 / DESIGN_WIDTH * display.width, 250},
                {1050 / DESIGN_WIDTH * display.width, 480},
                {200 / DESIGN_WIDTH * display.width, 480}
            }
            NODE_FAPAI_POS = {
                {200, 200},
                {1050, 600},
                {200, 600},
            }
            POSITION_OF_DEALER_4 = {
                {-35, 35},
                {35, 35},
                {-35, 35},
            }

    end

end


function TableView:isShowRankButton(isShow)
    if isShow then
        self.buttonRank_:show()
        self.buttonRank_:setButtonEnabled(true)
    else
        self.buttonRank_:hide()
    end
end

function TableView:addCircleCards(cards)
    -- self.scoreNode_:addCircleCards(cards)
end

function TableView:resetCircleCards()
    -- self.scoreNode_:resetCircleCards()
end

function TableView:showDealerAtIndex_(seatID)
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
    local time_ = 1
    if display:getRunningScene():getTable():getFinishRound() ~= 1 then
        time_ = 0
    end
    transition.moveTo(self.spriteDealer_, {x = x + ox, y = y + oy, time = time_, easing = "exponentialOut"})
end

function TableView:updateRoundScore()
end

function TableView:updateCircleScore(cards)
    -- self.scoreNode_:updateCircleScore(cards)
end

function TableView:onAdjustSeats(dealer)
    self:showDealerAtIndex_(dealer)
end

function TableView:onDealerChanged_(event)
    self:showDealerAtIndex_(event.seatID)
end

function TableView:onRankButtonShow(isShow)
    -- self.buttonRank_:setButtonEnabled(isShow)
    -- self.buttonLiPai_:setButtonEnabled(isShow)
    -- self.buttonWuZhang_:setButtonEnabled(isShow)
    -- self.buttonHuiFu_:setButtonEnabled(isShow)
end

function TableView:onEnter()
    local cls = self.table_.class
    gailun.EventUtils.clear(self)
    local handlers = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.DEALER_FOUND, handler(self, self.onDealerChanged_)},
        {cls.CONFIG_CHANGED, handler(self, self.onRoomConfigChanged_)},
        {cls.TURN_TO_EVENT, handler(self, self.onTurnToEvent_)},
        {cls.TABLE_CHANGED, handler(self, self.onTableChanged_)},
        {cls.ROUND_OVER_EVENT, handler(self, self.onRoundOverEvent_)},
        {cls.ROUND_START_EVENT, handler(self, self.onRoundStartEvent_)},
        {cls.FINISH_ROUND_CHANGED, handler(self, self.onFinishRoundChanged_)},
        {cls.GOLD_FLY_EVENT, handler(self, self.onGoldFlyEvent_)},
    }
    gailun.EventUtils.create(self, self.table_, self, handlers)

    self:showByTableState_({to = self.table_:getState()})
end

function TableView:getPopUpPokers()
    return self.nodeHostMaJiang_:getPopUpPokers()
end

function TableView:setPokerToHuiSe(cards, list)
    self.nodeHostMaJiang_:setPokerTohuise(cards, list)
end

function TableView:removeHuise()
    self.nodeHostMaJiang_:removeHuise()
end

function TableView:onGoldFlyEvent_(event)
    for i,v in ipairs(event.data) do
        for j,p in ipairs(event.data) do
            if v.winType == -1 and p.winType == 1 then
                local count = math.abs(v.score)
                self:creatGoldFly_(count, cc.p(v.posX, v.posY), cc.p(p.posX, p.posY))
                break
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
    local total = count
    local delayTime = 0
    if total > 20 then
        total = math.floor(total / 2)
    end
    for i=1,total do
        self:performWithDelay(function()
            local spriteGold = display.newSprite("res/images/game/score-bg1.png"):addTo(self):pos(startPoint.x, startPoint.y):scale(2)
            self:zhuanQuanAction_(spriteGold,0.5)
            gameAudio.playSound("sounds/common/chips_to_table.mp3")
            transition.moveTo(spriteGold, {x = endPoint.x, y = endPoint.y, time = 0.5, easing = "exponentialOut", onComplete = function()
                spriteGold:removeFromParent(true)
            end})
        end, delayTime)
        delayTime = delayTime + 0.1
    end
end

function TableView:stopGlodFly()
end

function TableView:zhuanQuanAction_(target, timer)
    local sequence = transition.sequence({
        cc.RotateTo:create(timer, 180),
        cc.RotateTo:create(timer, 360),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

function TableView:onRoundStartEvent_(event)
    if display:getRunningScene():getTable():getPlayerCount() == 2 then
        self.viewProgress_:setRemainCards(66)
    else
        self.viewProgress_:setRemainCards(9)
    end
end

function TableView:onRoundOverEvent_(event)
    self.directorController_:stop()
    -- self.scoreNode_:updateRoundScore()
    self.viewProgress_:setRemainCards(0)
end

function TableView:calcPokerPos_(total, index, pokerWidth)
    local margin = pokerWidth * 0.5
    local offset = (index - (total - 1) / 2 - 1) * margin
    local x = offset
    local y = 0
    return x, y, index
end


function TableView:onExit()
    gailun.EventUtils.clear(self)
end

function TableView:showPlayerChat(player, params, toPlayer)
    local index = player:getIndex()
    if index == nil then
        return
    end

    local node = self["nodeChat" .. player:getIndex() .. "_"]
    if not node then
        return
    end
    node:removeAllChildren()
    local messageType = params.messageType
    dump(params)
    if CHAT_FACE == messageType then
        self:doChatFace_(player, params.messageData, node)
    end
    if CHAT_QUICK == messageType then
        self:doChatQuick_(player, params.messageData, node)
    end
    if CHAT_TEXT == messageType then
        self:doChatText_(player, params.messageData, node)
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
        cc.CallFunc:create(function ()
            sprite:removeSelf()
        end)
    })
    sprite:runAction(seq)
end

function TableView:faceBQ_(player, chatID, node)
    self:showChatBQ_(player, chatID, node)
end

local POKER_ANIMS = {
    [ShuangKouCardType.ZHA_DAN] = {{"coscosdizha"}},
    -- [ShuangKouCardType.XI_ZHA] = {{"xizha"}},
    -- [ShuangKouCardType.TONG_ZI] = {{"coscostongzi"}},
}
function TableView:playAnimByData_(cardType, x, y)
    local aniInfo = POKER_ANIMS[cardType]
    if aniInfo == nil then
        return
    end

    local fileName = aniInfo[1][1]
    local manager = ccs.ArmatureDataManager:getInstance()
    manager:addArmatureFileInfo("animations/".. fileName .."/"..fileName..".ExportJson")
    local armature = ccs.Armature:create(fileName)
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(x,y))
    armature:getAnimation():setMovementEventCallFunc(function ()
        armature:removeFromParent()
    end)
    self.nodeAnim_:addChild(armature)
end

local POKER_ANIMS_FRAMES = {
    [ShuangKouCardType.ZHA_DAN] = {{"sizha", "sizha%02d.png", 1, 18, 1.5, false}, {"sounds/zhadanbaozha.mp3", nil, nil, 0.7}},
}

function TableView:playFramesAnimByData_(cardType, x, y, scale)

    local animaData = FaceAnimationsData.getCocosAnimation(32)
    animaData.x = x
    animaData.y = y
    gameAnim.createCocosAnimations(animaData, self.nodeAnim_, cc.p(x, y))

    do return end
    local params = POKER_ANIMS_FRAMES[cardType]
    if not params then
        return
    end


    local data = gameAnim.formatAnimData(unpack(params[1]))
    -- data = gameAnim.appendAnimAttrs(data, unpack(params[2]))
    local sp = display.newSprite():addTo(self.nodeAnim_):pos(x, y)
    if scale then
        sp:scale(scale)
    end
    gameAnim.play(sp, data)
    -- if cardType == TianZhaCardType.DI_ZHA then
    --     local word = display.newSprite("#dizha_word.png"):addTo(self.nodeAnim_):pos(x, y - 100)
    --     transition.fadeTo(word, {opacity = 0, time = 1})
    -- end
end

function TableView:countingScoreBindPlayer(player)
    -- self.scoreNode_:bindPlayer(player)
end

function TableView:playPokerAnimation(index, sex, cards, scale)
    display.addSpriteFrames("res/images/tianzha/game_anims.plist", "res/images/tianzha/game_anims.png")
    local cardType, value = ShuangKouAlgorithm.getCardType(cards, display:getRunningScene():getTable():getConfigData())
    if cardType == ShuangKouCardType.DI_ZHA then
        return self:playBomb_(cardType, nil, 2)
    elseif cardType == ShuangKouCardType.XI_ZHA then
        return self:playBomb_(cardType, index, 2)
    elseif cardType == ShuangKouCardType.TONG_ZI then
        return self:playBomb_(cardType, index, 2)
    elseif cardType == ShuangKouCardType.ZHA_DAN then
        return self:playFramesBomb_(cardType, index, 2)
    elseif cardType == ShuangKouCardType.FEI_JI then
        return self:playFeiJiAnim_(index)
    end
end

function TableView:getAniPos_(index)
    local x, y = display.cx, 400
    if index == SK_TABLE_DIRECTION.RIGHT then
        if 3 == display:getRunningScene():getTable():getMaxPlayer() then
            x, y = display.width * 0.78, 500
        elseif 2 == display:getRunningScene():getTable():getMaxPlayer() then
            x, y = display.width * 0.22, 500
        end
    elseif index == SK_TABLE_DIRECTION.LEFT then
        x, y = display.width * 0.22, 500
    end
    return x, y
end

function TableView:playFramesBomb_(cardType, index, scale)
    local x, y = self:getAniPos_(index)
    self:playFramesAnimByData_(cardType, x, y, scale)
end

function TableView:playBomb_(cardType, index, scale)
    local x, y = self:getAniPos_(index)
    self:playAnimByData_(cardType, x, y, scale)
end

function TableView:playFeiJiAnim_(index)
    -- 初始位置 终点X坐标 是否翻转
    local ap = display.LEFT_CENTER
    local fromX, fromY, toX = 0, 297, display.right
    local flipX = false
    if index == SK_TABLE_DIRECTION.RIGHT and 3 == display:getRunningScene():getTable():getMaxPlayer() then
        fromX, toX = display.right, display.left
        ap = display.RIGHT_CENTER
        fromY = 544
        flipX = true
    elseif index == SK_TABLE_DIRECTION.RIGHT and 2 == display:getRunningScene():getTable():getMaxPlayer() then
        fromY = 544
    elseif index == SK_TABLE_DIRECTION.LEFT then
        fromY = 544
    end
    gameAudio.playSound("sounds/feijifeiguo.mp3")
    local sprite = display.newSprite("#anim_plane.png"):addTo(self.nodeAnim_):align(ap, fromX, fromY)
    if flipX then
        sprite:flipX(true)
    end
    transition.moveTo(sprite, {x = toX, time = 1.5, easing = "Out", onComplete = function ()
        sprite:removeFromParent()
    end})
end

function TableView:doVoiceChat_(player, params, node)
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    -- self:doChatText_(player, "voice msg", node)
    self.voicePlayer_ = player
    self.soundUrl_ = params.url
    local fileName =  params.uid .. "_".. params.time .. ".aac"
    local path = gailun.native.getSDCardPath() .. "/" .. fileName
    gailun.HTTP.download(self.soundUrl_, path, function (fileName)
        self:downloadVoiceSuceess_(fileName, params)
    end, 
    function (reason)
        self:downloadVoiceFail(reason, params)
    end, 10)
end

function TableView:downloadVoiceSuceess_(fileName, params)
    chatRecordData:addGameRecord(fileName, params)
    gailun.native.playSound(fileName, handler(self, self.onPlaySoundReturn_))
end

function TableView:onPlaySoundReturn_(data)
    if data.flag == 1 then
        self.voicePlayer_:playRecordVoice(data.duration)
    else
        app:showTips("播放失败！")
    end
end

function TableView:downloadVoiceFail(data, params)
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
        cc.CallFunc:create(function ()
            sprite:removeSelf()
        end)
    })
    sprite:runAction(seq)
    gameAudio.playSound(string.format("sounds/chat/game_face_%d.mp3", id))
end

local chatBg = {
    {"#chat_bgl.png", 17, 75, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"#chat_bgr.png", -47, 20, cc.size(300, 80), cc.rect(50, 47, 1, 1), cc.p(1, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"#chat_bgt.png", -14, -88, cc.size(300, 80), cc.rect(30, 47, 1, 1), cc.p(1, 30/80), cc.p(0.5, 0.5), {20, 32}},
    {"#chat_bgl.png", 52, 32, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
}

function TableView:showChatText_(player, chatID, node)
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    local sprite = display.newSprite("res/images/yuyinwenzi/quickChatbg.png"):addTo(node)
    sprite:setCascadeOpacityEnabled(true)
    if player:getIndex() == 1 then
        node:pos(480-200,230)
    elseif player:getIndex() == 2 then
        node:pos(980,470)
        sprite:setScaleX(-1)
    elseif player:getIndex() == 4 then
        node:pos(320,480)
    elseif player:getIndex() == 3 then
        node:pos(750,680)
        sprite:setScaleX(-1)
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

function TableView:doChatQuick_(player, chatID, node)
    local id = checkint(chatID)
    self:showChatText_(player, chatID, node)
    local sound = string.format("%d.mp3", id)
    gameAudio.playQuickChat(sound, player:getSex())
end


function TableView:doChatText_(player, text, node)
    self:showChatText_(player, text, node)
end

function TableView:onFinishRoundChanged_(event)
    self.viewProgress_:show()
    self.viewProgress_:setRoundState(event.total, event.num)
    self.viewProgress_:setRemainCards(0)
end

function TableView:setRoundTxt()
    self.viewProgress_:addRound()
    -- self.viewProgress_:setRoundState(self.configData_.juShu, curRound)
end

function TableView:onTableChanged_(event)
    self.viewProgress_:updateTableID_(event.tid)
end

function TableView:makeRuleString(spliter)
    local data = self.configData_
    dump(data,"TableView:makeRuleString")
    local list = {}
    local skInfo = {"常规双扣","百变双扣","千变双扣"}
    table.insert(list,  skInfo[data.bianPai+1])
    local gxInfo = {"无进贡","有进贡"}
    table.insert(list,  gxInfo[data.contribution+1])
    return table.concat(list, spliter)
end

--[[
"<var>" = {
    "totalRound"      = 8
}
]]
function TableView:onRoomConfigChanged_(event)
    self.configData_ = event.data
    self.viewProgress_:showRoomConfig(event.data)
    self.nodeHostMaJiang_ = PokerListView.new():addTo(self.nodePokerContent_)
    self.nodeHostMaJiang_:setScale(1.1)
    self.nodeHostMaJiang_:setPositionX(display.cx)

    -- self:initFriendPoker()
end

function TableView:getNewFriendPoker()
    if self.nodeHostFriend_ then
        if not tolua.isnull(self.nodeHostFriend_) then
            self.nodeHostFriend_:removeSelf()
        end
        self.nodeHostFriend_ = nil
    end

    self.nodeHostFriend_ = PokerListView.new():addTo(self.nodePokerContent_)
    self.nodeHostFriend_:setWatchingCardsVisible(true)
    self.nodeHostFriend_:setScale(1.1)
    self.nodeHostFriend_:setPositionX(display.cx)

    return self.nodeHostFriend_
end

function TableView:initTishi()
    self.nodeHostMaJiang_:initTishi()
end

function TableView:getRoomConfig()
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

function TableView:showAlarm(seatID, seconds, flow)
    self.directorController_:show()
    self.directorController_:startTimeCount(seatID, seconds)
    local player = self:getParent().seats_[seatID]
    if player then
        local x, y = unpack(ALARM_POSITION[player:getIndex()] or {0, 0})
        self.directorController_:pos(x, y)
    end
end

function TableView:onTurnToEvent_(event)
    self:showAlarm(event.seatID, event.seconds)
end

function TableView:stopTimer()
    self.directorController_:stop()
    self.directorController_:hide()
end

function TableView:getTableInfo_()
    local str = "初级场 %s（%d人）"
    return string.format(str, self.table_:getName(), self.table_:getMaxPlayer())
end


function TableView:onStateCheckout_(event)
    self.directorController_:stop()
end

function TableView:onStateIdle_(event)
    self.directorController_:hide()
    self.spriteDealer_:hide()
    self.labelTableRules_:show()
end

function TableView:focusOff( ... )
    -- body
end

function TableView:onStatePlaying_(event)
    self.viewProgress_:show()
    self.labelTableRules_:show()
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


function TableView:hideDealer()
    self.spriteDealer_:hide()
end

function TableView:onAdjustSeats(dealer)
end

function TableView:resetPopUpPokers()
    if self.nodeHostMaJiang_ == nil then return end
    self.nodeHostMaJiang_:initTishi(1)
    self.nodeHostMaJiang_:resetPopUpPokers()
end

function TableView:shouPaiAnim_(index)  -- 收牌
    local nodeFaPai = self["nodeFaPai".. index .. "_"]
    local nodes = nodeFaPai:getChildren()
    local endX = nodes[1]:getPositionX()
    local endY = nodes[1]:getPositionY()
    for i=1,#nodes do
        if SK_TABLE_DIRECTION.BOTTOM ~= index then
            transition.moveTo(nodes[i], {x = endX, y = endY, time = 0.5})
        end
    end
    self:performWithDelay(function ( ... )
        nodeFaPai:removeAllChildren()
        self.nodeHostMaJiang_:setVisible(true)
    end, 0.6)
end

function TableView:calcFaPaiPokerPos_(total, index)
    if SK_TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcFaPaiPokerPosLeft_(total, index)
    elseif SK_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcFaPaiPokerPosRight_(total, index)
    else
        return self:calcFaPaiBottomPos_(total, index)
    end
end

function TableView:calcFaPaiBottomPos_(total, index)
    local majiang_width = 55
    local offset = (index - (total - 1) / 2 - 1) * majiang_width
    local x = display.cx + offset - 190
    local scale = 0.7
    local y = -115
    return x, y, index, scale
end

function TableView:calcFaPaiPokerPosLeft_(total, index)
    local majiang_width = 20
    local x = (index - 1) * majiang_width + 60
    local scale = 0.7
    return x, 0, index, scale
end

function TableView:calcFaPaiPokerPosRight_(total, index)
    local majiang_width = 20
    majiang_width = - majiang_width
    local x = (index - 1) * (majiang_width) - 20
    local scale = 0.7
    return x, 0, index, scale
end

function TableView:faceIconFly_(faceID, fromPlayer, toPlayer)
    if toPlayer == nil then
        return
    end

    local data = FaceAnimationsData.getFaceAnimation(faceID)
    local flyIcon = display.newSprite(data.flyIcon):addTo(self.nodeFaceAnim_)
    local startX, startY = fromPlayer:getPlayerPosition()
    local toX, toY =  toPlayer:getPlayerPosition()
    local toIndex = toPlayer:getIndex()
    if toIndex == SK_TABLE_DIRECTION.RIGHT then
        data.offsetX = - data.offsetX
        data.flyIconOffsetX = - data.flyIconOffsetX
        data.flipX = true
    end
    flyIcon:setPosition(startX, startY)
    if data.isXuanZhuan then
        self:zhuanQuanAction(flyIcon, 0.2)
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

function TableView:zhuanQuanAction(target, timer)
    local sequence = transition.sequence({
        cc.RotateTo:create(timer, 180),
        cc.RotateTo:create(timer, 360),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

return TableView
