local BaseAlgorithm = require("app.games.mmmj.utils.BaseAlgorithm")
local CSAlgorithm = require("app.games.mmmj.utils.CSAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")

local TingView = require("app.games.mmmj.views.game.TingView")

local QI_PAO_X, QI_PAO_Y = 130, 20

local PLAY_FLAG_X, PLAY_FLAG_Y = -42, -95
local TYPES = gailun.TYPES
local nodeData = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeChuPai_"},  -- 出牌容器
        {type = TYPES.NODE, var = "nodeWaiPai_"},  -- 外牌容器
        {type = TYPES.NODE, var = "nodeMaJiangs_"},  -- 手牌容器
        {type = TYPES.NODE, var = "nodePlayer_", children = {  -- 玩家基本数据的对象
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView"},
            {type = TYPES.SPRITE, var = "spriteBg_", filename = "res/images/common/avatar_border.png",},
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/majiang/game/off_line_sign.png", x = 30, y = -30},
            {type = TYPES.SPRITE, var = "spriteZhuanquan_"},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
            {type = TYPES.LABEL_ATLAS, var = "tanFenAdd_", visible = false, filename = "fonts/game_tanfen_win.png", options = {text="10", w = 26, h = 51, startChar = "+"}, y = 0, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "tanFenDel_", visible = false, filename = "fonts/game_tanfen_lose.png", options = {text="10", w = 26, h = 51, startChar = "+"}, y = 0, x = 0, ap = {0.5, 0.5}},
            
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="fdsafdsafdsa", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = 45, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/majiang/game/score-bg.png", y = -45, scale9 = true, size = {116, 30}, children = {
                --{type = TYPES.SPRITE, filename = "res/images/majiang/game/score-bg1.png", x = 16, ppy = 0.48},
                {type = TYPES.LABEL, options = {text="得分", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, x = 10, ppy = 0.48},
                {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.35, x = 50, ap = {0, 0.5}},
                -- {type = TYPES.SPRITE, var = "nodeChui_", visible = false, filename = "res/images/majiang/game/flag_chui.png", ppx = 0.5, y = -20},
            },
            },
            },
            },
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/game/readyFlag.png", visible = false},
        {type = TYPES.NODE, var = "nodeChat_"},  -- 聊天容器        
        {type = TYPES.NODE, var = "nodeTanPai_"},  -- 外牌容器 nodeAnims_
        {type = TYPES.NODE, var = "nodeAnims_"},  -- 出牌动画容器
        {type = TYPES.NODE, var = "nodeGangAnims_"},  -- 杠牌动画容器

    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatHandler(tostring)
local PlayerView = class("PlayerView", gailun.BaseView)

local HOST_OFFSET_X, HOST_SPACE_X = 100, 12  -- 主玩家发牌终点偏移量、两张手牌的间距
local PLAYER_OFFSET_X, PLAYER_OFFSET_Y, PLAYER_SPACE_X = 34, -18, 3  -- 其它玩家发牌终点X与Y，两张手牌的间距
local CARD_DELAY_SECONDS = 0.1  -- 发牌移动动作与旋转动作之间的时间间隔
local MO_PAI_MARGIN_BOTTOM, MO_PAI_MARGIN_OTHER = 40, 18
local MA_JIANG_BOTTOM_SCALE = 1  -- 底部的牌的缩放

local player_pos = {
    {0.2, 0.28},
    {0.94, 0.635},
    {0.76, 0.91},
    {0.061, 0.635},
}

local CHU_PAI_ANIM_POS = {
    {display.cx, display.height * 0.3},
    {display.width * 0.7, display.cy + 30 * display.width / DESIGN_WIDTH},
    {display.cx, display.height * 0.75},
    {display.width * 0.3, display.cy + 30 * display.width / DESIGN_WIDTH},
}

local ACTION_ANIM_POS = {
    {display.cx, display.height * 0.3},
    {display.width * 0.7, display.cy + 30 * display.width / DESIGN_WIDTH},
    {display.cx, display.height * 0.75},
    {display.width * 0.3, display.cy + 30 * display.width / DESIGN_WIDTH},
}

local adjust_ready_x = 100
local ready_pos = {
    {display.cx, display.height * 0.3},
    {display.width * 0.7, display.cy},
    {display.cx, display.height * 0.75},
    {display.width * 0.3, display.cy},
}

local OFFSET_OF_SEATS_4 = {}
for i,v in ipairs(player_pos) do
    OFFSET_OF_SEATS_4[i] = {display.width * v[1], display.height * v[2]}
    ready_pos[i][2] = OFFSET_OF_SEATS_4[i][2]
end

ready_pos[1][1] = OFFSET_OF_SEATS_4[1][1] + adjust_ready_x
ready_pos[2][1] = OFFSET_OF_SEATS_4[2][1] - adjust_ready_x
ready_pos[3][1] = OFFSET_OF_SEATS_4[3][1] - adjust_ready_x
ready_pos[4][1] = OFFSET_OF_SEATS_4[4][1] + adjust_ready_x

local MA_JIANG_SHU_WIDTH = {82, 27, 35, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {56, 27, 35, 27}  -- 倒着的麻将的宽度
local MA_JIANG_CHU_WIDTH = {52, 27, 40, 27}
local BOTTOM_CHU_PAI_SCALE = 51/55
local BOTTOM_WAI_PAI_SCALE = 55/51
local TOP_CHU_PAI_SCALE = 0.9
local TOP_CHUPAI_WIDTH = 49
local TOP_REVIEW_DOWN_HAND_WIDTH = 42

PlayerView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
PlayerView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"

function PlayerView:ctor(index, maJiangNode)
    assert(index > 0 and index < 5 and maJiangNode, "bad player index of " .. checkint(index))
    self.index_ = index
    gailun.uihelper.render(self, nodeData)
    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))

    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    self.nodeMaJiangs_:setCascadeOpacityEnabled(true)
    self.nodeMaJiangsHost_ = maJiangNode

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.buttonInvite_:onButtonClicked(handler(self, self.onAvatarClicked_))

    self.tingPaiMap = {}

    self:zhuanQuanAction_()
    self:stopZhuanQuanAction_()
    self.isGangLocked_ = false
    self:initTiShiAnimation_()
    self.cpLian = 8
end

function PlayerView:updateTingPaiTag(card)
    if not self:isHost() then
        return
    end

    local waiPai = self.player_:getWaiPai()
    local handCards = self.player_:getCards()

    if card ~= nil and card ~= 0 then
        table.insert(handCards, card)
    end

    if CSAlgorithm.canHu_(waiPai, handCards) then
        self.tingPaiMap = {}
    else
        self.tingPaiMap = gailun.utils.invert(CSAlgorithm.getTingOperate(waiPai, handCards))
    end

    local nodes = self:getMaJiangNode_():getChildren()
    
    for _, v in pairs(nodes) do
        if not v:isDown() then
            v:setTingTag(self.tingPaiMap[v:getCard()] ~= nil)
        end
    end
end

function PlayerView:initTiShiAnimation_()
    local animaData = FaceAnimationsData.getCocosAnimation(6)
    gameAnim.createCocosAnimations(animaData, self.spriteZhuanquan_)
    self.spriteZhuanquan_:hide()
end

function PlayerView:setTable(model)
    self.table_ = model
end

function PlayerView:onEnter()
    self:initPosByIndex_()
    self:onStateIdle_()
    self.labelNickName_:enableShadow(cc.c4b(0, 0, 0, 128), cc.size(2, -3), 1)
    gailun.uihelper.setTouchHandler(self.spriteBg_, handler(self, self.onAvatarClicked_))
    self.spriteOffline_:hide()
end

function PlayerView:setTable(model)
    self.table_ = model
    self:initTableEvent_()
end

function PlayerView:initTableEvent_()
    local cls = self.table_.class
    local events = {
        {cls.MA_JIANG_HIGH_LIGHT, handler(self, self.onHighLight)},
    }
    gailun.EventUtils.create(self, self.table_, self, events)
end

function PlayerView:onFlwoEvent_(event)
    print("playerview onflow event "..event.flag)
    if event.flag ~= nil and event.flag ~= -1 then
        self.spriteZhuanquan_:show()
    else
        self.spriteZhuanquan_:hide()
    end
end

function PlayerView:onExit()
    gailun.EventUtils.clear(self)
end

function PlayerView:onHighLight(event)
   if event.name == display.getRunningScene():getTable().MA_JIANG_HIGH_LIGHT then
    local nodes = self.nodeChuPai_:getChildren()
    local wNodes = self.nodeWaiPai_:getChildren()

    for i = #wNodes,1,-1 do
        if event.card == wNodes[i]:getMaJiang() then
            if event.flag then
                wNodes[i]:highLight()
            else
                wNodes[i]:clearHighLight()
            end
        end
    end

    for i = #nodes,1,-1 do
        if event.card == nodes[i]:getMaJiang() then
            if event.flag then
                nodes[i]:highLight()
           else
                nodes[i]:clearHighLight()
           end
        end
    end

   end
end

-- 展示玩家的动作动画
function PlayerView:showActionAnim_(spriteName,moveEnable,callback)
    local toX, toY = unpack(ACTION_ANIM_POS[self.index_])
    local params = nil
    if moveEnable then
        params = {}
        local ox, oy = unpack(OFFSET_OF_SEATS_4[self.index_])
        params.toX = ox
        params.toY = oy
        params.onComplete = callback
    end
    local actionAnim = app:createView("game.ActionAnim", spriteName,params):addTo(self.nodeAnimations_):pos(toX, toY)
    actionAnim:run()
end

function PlayerView:onSitDownClicked_(event)
    self:dispatchEvent({name = PlayerView.SIT_DOWN_CLICKED})
end

function PlayerView:onSitDown(player)
    printInfo("PlayerView:onSitDown(player)")
    assert(player)
    gailun.EventUtils.clear(self)
    self.player_ = player
    local cls = player.class
    local events = {
        {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.MA_JIANG_FOUND, handler(self, self.onMaJiangFound_)},
        {cls.HAND_CARDS_CHANGED, handler(self, self.onHandCardsChanged_)},
        {cls.INDEX_CHANGED, handler(self, self.onIndexChanged_)},
        {cls.SIT_DOWN_EVENT, handler(self, self.onSitDownEvent_)},

        {cls.WAI_PAI_CHANGED, handler(self, self.onWaiPaiChanged_)},
        {cls.TAN_PAI_RESUME, handler(self, self.onTanPaiChanged_)},
        {cls.WAI_PAI_ADDED, handler(self, self.onWaiPaiAdded_)},
        {cls.TAN_PAI_ADDED, handler(self, self.onTanPaiAdded_)},
        {cls.TAN_PAI_ONLY_DATA, handler(self, self.onTanPaiOnlyData_)},
        {cls.CHU_PAI_CHANGED, handler(self, self.onChuPaiChanged_)},
        {cls.CHU_PAI_ADDED, handler(self, self.onChuPaiAdded_)},
        {cls.AFTER_GANG_PAI_ADDED, handler(self, self.onAfterGangPaiAdded_)},

        {cls.SCORE_CHANGED, handler(self, self.onScoreChanged_)},
        {cls.HAND_CARD_REMOVED, handler(self, self.onHandCardRemoved_)},
        {cls.ON_BU_GANG_EVENT, handler(self, self.onBuGangEvent_)},
        {cls.SHOW_READY,handler(self,self.showReadyCommand_)},
        {cls.ON_SCORE_CHANGE_EVENT, handler(self, self.showScoreChange_)},
        {cls.ON_RECONNECT_FOCUSON, handler(self, self.onReconnectOn_)},
        {cls.ON_STOP_ZHUANQUAN, handler(self, self.stopZhuanQuanAction_)},
        {cls.ON_ZHUANQUAN, handler(self, self.zhuanQuanAction_)},
        {cls.ON_STOP_RECORD_VOICE, handler(self, self.onStopRecordVoice_)},
        {cls.ON_PLAY_RECORD_VOICE, handler(self, self.onPlayerVoice_)},
        {cls.OFFLINE_EVENT, handler(self, self.onOfflineEvent_)},
        {cls.ON_RESET_PLAYER, handler(self, self.onResetPlayer_)},
        {cls.ON_FLOW_EVENT, handler(self, self.onFlwoEvent_)},  --ON_SHOWHEISAN_EVENT
        {cls.ON_TAN_PAI, handler(self, self.onTanPai_)},
        {cls.GANG_LOCK, handler(self, self.onGangLock_)},
        {cls.ON_MING_BU_EVENT, handler(self, self.onMingBuEvent_)},
        {cls.CHU_PAI_COUNT,handler(self,self.onChangeChuPaiCount_)},
    }
  
    gailun.EventUtils.create(self, player, self, events)
    gameAudio.playSound("sounds/common/sound_enter.mp3")
end

function PlayerView:onSitDownEvent_(event)
    gameAudio.playSound("sounds/common/sound_enter.mp3")
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    -- self:setScoreWithRoller_(self.player_:getScore())
    self:setVisible(true)
    self:stopZhuanQuanAction_()
end

function PlayerView:onChangeChuPaiCount_(event)
    if event and event.chuPaiCount then
        self.cpLian = event.chuPaiCount
    end
end

function PlayerView:showReadyCommand_(event)
    if  event.isReady then
        self.spriteReady_:show()
    print("showReadyCommand")
    else
        self.spriteReady_:hide()
    print("hideReadyCommand")
    end
    
end

function PlayerView:onTanPai_(event)
    local data = event.data
    if data.cards then

    end
    if data.huNameList then

    end
end

function PlayerView:showScoreChange_(event)
    
end

function PlayerView:onStandUp()
    gailun.EventUtils.clear(self)
    self.player_ = nil
    gameAudio.playSound("sounds/common/sound_left.mp3")
    self:setVisible(false)
end

function PlayerView:showOnline(data)
    local isOffline = (data.IP == nil)
    self.spriteOffline_:setVisible(isOffline)
    local str
    if not isOffline then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

function PlayerView:isHost()
    if self.player_ then
        return self.player_:getUid() == selfData:getUid()
    end
end

function PlayerView:onScoreChanged_(event)
    local clockScore = display.getRunningScene():getLockScore()
    if event.isReConnect then
        self.labelScore_:setString(event.score+clockScore)
    end
    local distScore = event.score - event.from
    if distScore > 0 then
        self.tanFenAdd_:show()
        self.tanFenAdd_:setOpacity(255)
        self.tanFenAdd_:setString("+"..distScore)
        self.tanFenDel_:hide()
        self:tanFenAnimation_(self.tanFenAdd_)
    elseif distScore < 0 then
        self.tanFenDel_:show()
        self.tanFenAdd_:hide()
        self.tanFenDel_:setOpacity(255)
        self.tanFenDel_:setString(distScore)
        self:tanFenAnimation_(self.tanFenDel_)
    else
        self.labelScore_:setString(event.score+clockScore)
    end
    if distScore ~= 0 then
        self:setScoreWithRoller_(event.score, event.from)
    end
end

function PlayerView:tanFenAnimation_(target)
    target:show()
    local oldY = target:getPositionY()
    transition.moveTo(target, {y = oldY + 20, time = 0.3})
    self:performWithDelay(function()
        target:hide()
        -- target:setOpacity(255)
        target:setPositionY(oldY)
        end, 1.2)
end

-- 补杠事件里面，已经更新了外牌，删除了手牌，所以不再多做操作
function PlayerView:onBuGangEvent_(event)
    self:playActionAnim_(CSMJ_ACTIONS.BU_GANG)
end

-- 补杠事件里面，已经更新了外牌，删除了手牌，所以不再多做操作
function PlayerView:onMingBuEvent_(event)
    self:playActionAnim_(CSMJ_ACTIONS.MING_BU)
end

function PlayerView:onWaiPaiChanged_(event)
    if not event.data or 0 == #event.data then
        self.nodeWaiPai_:removeAllChildren()
        return
    end
    for i,v in ipairs(event.data) do
        self:createWaiPai_(v, i)
    end
end

function PlayerView:onTanPaiChanged_(event)
    self.nodeTanPai_:removeAllChildren()
end

function PlayerView:createWaiPai_(data, index)
    dump(data, "PlayerView:createWaiPai_")
    assert(data.action and data.cards)
    for j, card in ipairs(data.cards) do
        local x, y = self:calcWaiPaiPos_(index, j)
        local showIndex = j
        if self.index_ == MJ_TABLE_DIRECTION.RIGHT and j < 4 then
            showIndex = -j - index * 10
        end
        if (data.action == MJ_ACTIONS.AN_GANG or data.action == CSMJ_ACTIONS.AN_BU) and j < 4 then
            card = 0
        end
        local maJiang = app:createConcreteView("MaJiangView", card, self.index_, true):addTo(self.nodeWaiPai_, showIndex):pos(x, y)
        if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
            maJiang:scale(BOTTOM_WAI_PAI_SCALE)
            if card == 0 then
                maJiang:scale(1.3)
            end
        elseif self.index_ == MJ_TABLE_DIRECTION.TOP then
            maJiang:scale(0.8)
        end
    end
end

function PlayerView:onTanPaiOnlyData_(event)
    self:createTanPaiOnlyData_(event.cards)
end

function PlayerView:createTanPaiOnlyData_(cards)
    self:clearValue_()
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        for k,v in pairs(cards) do
            print("XXXXXXXX")
            local maJiang = self:getMaJiangByValue_(v)
            if maJiang then
                maJiang:setScale(1.47)
                maJiang:setMaJiang(v, true)
            end
        end
    else
        for j, card in ipairs(cards) do
            local maJiang = self:getMaJiangByValue_(0)
            maJiang:setMaJiang(card, true)
            if self.index_ == MJ_TABLE_DIRECTION.TOP then
                maJiang:setScale(0.8)
            end
        end
    end
end

function PlayerView:createTanPai_(data, index, isReview,noShowAni)
    assert(data.cards)
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        for k,v in pairs(data.cards) do
            local maJiang = self:getMaJiangByValue_(v)
            maJiang:setMaJiang(v, true)
            maJiang:setScale(1.47)
        end
    else
        for j, card in ipairs(data.cards) do
            local maJiang = self:getMaJiangByValue_(0)
            maJiang:setMaJiang(card, true)
            if self.index_ == MJ_TABLE_DIRECTION.TOP then
                maJiang:setScale(0.8)
            end
        end
    end
    local huNameList = data.huNameList
    self:showHuType(huNameList, data.cards, self, isReview,noShowAni)
end

local MJ_HUTYPE_LIST = {
    banBanHu = "res/images/majiang/game/hutype/banbanhu.png",
    danSeYiZhiHua = "res/images/majiang/game/hutype/danseyizhihua.png",
    jiangYiZhiHua = "res/images/majiang/game/hutype/jiangyizhihua.png",
    jieJieGao = "res/images/majiang/game/hutype/jiejiegao.png",
    liuLiuShun = "res/images/majiang/game/hutype/liuliushun.png",
    queYiSe = "res/images/majiang/game/hutype/queyise.png",
    sanTong = "res/images/majiang/game/hutype/santong.png",
    qiShouSiZhang = "res/images/majiang/game/hutype/sixi.png",
    yiZhiHua = "res/images/majiang/game/hutype/yizhihua.png",
    yiZhiNiao = "res/images/majiang/game/hutype/yizhiniao.png",
    zhongTuSiZhang = "res/images/majiang/game/hutype/zhongTuSiXi.png",
    zhongTuLiuLiuShun = "res/images/majiang/game/hutype/zhongTuLiuLiuShun.png",
    liuLiuShun = "res/images/majiang/game/hutype/liuliushun.png",
    queYiSe = "res/images/majiang/game/hutype/queyise.png",
}
function PlayerView:showHuType(huList,cards,winner,isReview,noShowAni)
   
    local actions = {}
    local hutypes = {}
    for i = 1, #huList do
        local x, y = self:calcRoundOverHulistPos_(i,0, #huList,self)
        local hutype = MJ_HUTYPE_LIST[huList[i]]
        if not hutype then
            print (hutype, ' not exist')
        else
            local png = hutype
            if not png then
                print (id, ' not exist')
            else
                if noShowAni then
                    display.newSprite(png):addTo(self.nodeTanPai_,100):pos(x, y +50):scale(1.1)
                else
                    local action =   cc.CallFunc:create(function ()
                        local hutype =  display.newSprite(png):addTo(self.nodeTanPai_,100):pos(x, y +50):scale(3)
                        transition.scaleTo(hutype, {scale = 1.1, time = 0.2, easing = "bounceOut"})
                        if not isReview then
                            self:showHulizi(hutype)
                        end
                        table.insert(hutypes, hutype)
                    end)
                    table.insert(actions, action)
    
                    local actionDelay = cc.DelayTime:create(0.3)
                    table.insert(actions, actionDelay)
                end
            end
        end
    end

    local actionDelay1 = cc.DelayTime:create(3)
    table.insert(actions, actionDelay1)
    --  local action1 =   cc.CallFunc:create(function ()
    --     for k,v in pairs(hutypes) do
    --         if v then
    --             v:removeFromParent()
    --         end
    --     end
    --     hutypes = {}
    -- end)

    -- table.insert(actions, action1)
    local sequence = transition.sequence(actions)
    self.nodeTanPai_:runAction(sequence)
end

function PlayerView:showHulizi(hutype)
    self.emitter_  = cc.ParticleExplosion:createWithTotalParticles(100)    --设置粒子数  
    -- self.emitter_ =cc.ParticleSystemQuad:create("textures/fireline.plist")  
    local cache = cc.Director:getInstance():getTextureCache():addImage("textures/explosion.png")
    self.emitter_:setTexture(cache)
    self.emitter_:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    self.emitter_:setLife(0)
    self.emitter_:setLifeVar(0.4)
    -- self.emitter_:setPosVar(cc.p(0,0))
    self.emitter_:setStartSize(34)
    self.emitter_:setEndSize(14)
    self.emitter_:setStartColor(cc.c4b(1,1,1,1))
    self.emitter_:setEndColor(cc.c4b(0.2,0.5,0.2,0.5))
    self.emitter_:setStartColorVar(cc.c4b(0,0,0,0.84))
    self.emitter_:setEndColorVar(cc.c4b(0.38,0,0,0))
    self.emitter_:setGravity(cc.p(0,1.58))
    self.emitter_:setRadialAccel(107.4)
    self.emitter_:setSpeedVar(227.8)
    self.emitter_:setBlendFunc(gl.SRC_ALPHA,gl.ONE)

    local locX,locY = 30,15
    self.emitter_:setPosition(cc.p(locX, locY))  
    hutype:addChild(self.emitter_,102)
end

function PlayerView:calcRoundOverHulistPos_(index,total,hutotal,winner)
    if MJ_TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcRoundOverHulistPosLeft_(index,total,hutotal,winner)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcRoundOverHulistPosRight_(index,total,hutotal,winner)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcRoundOverHulistPosTOP_(index,total,hutotal,winner)
    else
        return self:calcRoundOverHulistPosBottom_(index,total,hutotal,winner)
    end
end

function PlayerView:calcRoundOverHulistPosLeft_(index,total,hutotal,winner)
    local ox,oy = self:getPlayerPosition()
    local x = ox + 350
    local y = display.cy + 110 * hutotal/2 - ((index -1) % 3 )* 110 

    return x, y
end

function PlayerView:calcRoundOverHulistPosRight_(index,total,hutotal,winner)
    local ox,oy = self:getPlayerPosition()
    local x = ox - 280
    local y = display.cy + 110 * hutotal/2 - ((index -1) % 3 )* 110 -50

    return x, y
end

function PlayerView:calcRoundOverHulistPosBottom_(index,total,hutotal,winner)
    local ox,oy = self:getPlayerPosition()
    local x =  display.cx - 250 + ((index -1) % 3 )* 250
 
    local y = oy 
    return x, y
end

function PlayerView:calcRoundOverHulistPosTOP_(index,total,hutotal,winner)
    local ox,oy = self:getPlayerPosition()
    local x =  display.cx + 250 * hutotal/2 - ((index -1) % 3 )* 250 - 100
    local y = oy - math.ceil(index / 3) * 50 + 100 -150

    return x, y
end

function PlayerView:onWaiPaiAdded_(event)
    print("PlayerViewonWaiPaiAdded_")
    if not event.data then
        printInfo("if not event.cards or 0 == #event.cards then")
        return
    end
    self:createWaiPai_(event.data, event.index)
    if not event.data.dennyAnim then
        self:playActionAnim_(event.data.action)
    end
end

function PlayerView:onTanPaiAdded_(event)
    print("onTanPaiAdded_")
    if not event.data then
        printInfo("if not event.cards or 0 == #event.cards then")
        return
    end
    print(event.isReview)
    if not  event.isReview then
        self:createTanPai_(event.data, event.index, event.isReview,event.noShowAni)
    end
end

function PlayerView:playActionAnim_(action)
    if CSMJ_ACTIONS.PENG == action then
        self:playPeng()
    elseif CSMJ_ACTIONS.CHI == action then
        self:playChi()
    elseif CSMJ_ACTIONS.ZI_MO == action then
        self:playZiMo()
    elseif CSMJ_ACTIONS.CHI_HU == action or action == CSMJ_ACTIONS.QIANG_GANG_HU then
        self:playFangPao(action)
    elseif CSMJ_ACTIONS.AN_GANG == action or CSMJ_ACTIONS.CHI_GANG == action or CSMJ_ACTIONS.BU_GANG == action then
        self:playGang(action)
    elseif CSMJ_ACTIONS.AN_BU == action or CSMJ_ACTIONS.MING_BU == action or CSMJ_ACTIONS.GONG_BU == action then
        self:playBu(action)
    end
end

function PlayerView:calcTanPaiPos_(index, offset, isTanPai, total)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcTanPaiPosBottom_(index, offset, isTanPai, total)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcTanPaiPosRight_(index, offset, isTanPai, total)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcTanPaiPosTop_(index, offset, isTanPai, total)
    else
        return self:calcTanPaiPosLeft_(index, offset, isTanPai, total)
    end
end

function PlayerView:calcWaiPaiPos_(index, offset, isTanPai, total)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcWaiPaiPosBottom_(index, offset, isTanPai, total)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcWaiPaiPosRight_(index, offset, isTanPai, total)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcWaiPaiPosTop_(index, offset, isTanPai, total)
    else
        return self:calcWaiPaiPosLeft_(index, offset, isTanPai, total)
    end
end

function PlayerView:calcWaiPaiOffsetWidth_(width, offset)
    if offset < 4 then
        return (offset - 1) * width
    end
    return width
end

function PlayerView:calcTanPaiOffsetWidth_(width, offset)
    return (offset - 1) * width
end

function PlayerView:calcWaiPaiOffsetHeight_(height, offset)
    if offset < 4 then
        return 0
    end
    return height / 3.8
end

function PlayerView:calcWaiPaiPosBottom_(index, offset, isTanPai, total)

        local majiang_height = 84
        local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
        local bottom_margin, mopai_space = 21, 20
        local startX = self:calcMaJiangBottomMargin_() + majiang_width / 2 + (index - 1) * (mopai_space + majiang_width * 3)
        local x = startX + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
        local y = bottom_margin + majiang_height / 2 + self:calcWaiPaiOffsetHeight_(majiang_height, offset)
        return x, y

end

function PlayerView:calcWaiPaiPosRight_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local bottom_margin, wai_pai_space = 180, 20
    local x = display.width * (1114 / DESIGN_WIDTH)- offset*4 - index *15 + 75
    if offset == 4 then
        x = x + 11
    end
    local startY = bottom_margin + (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

-- 390 890
function PlayerView:calcWaiPaiPosTop_(index, offset, isTanPai, total)

        local wai_pai_space = 20
        local majiang_height, majiang_width = 55, MA_JIANG_DAO_WIDTH[self.index_]
        local startX = display.width * 900 / DESIGN_WIDTH - (index - 1) * (wai_pai_space + majiang_width * 3)
        local x = startX - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
        local y = display.height - 62 + self:calcWaiPaiOffsetHeight_(majiang_height, offset)
        return x, y

end

function PlayerView:calcWaiPaiPosLeft_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local top_margin, wai_pai_space = 712, 16
    local x = display.width * (166 / DESIGN_WIDTH) - offset*4 - index *15 + 30
    if offset == 4 then
        x = x + 4
    end
    local startY = top_margin - (index - 1) * (wai_pai_space + majiang_width * 3) - 80
    local y = startY - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

function PlayerView:calcTanPaiPosBottom_(index, offset, isTanPai, total)
        local majiang_height = 84
        local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
        local bottom_margin, mopai_space = 21, 20
        local startX = self:calcMaJiangBottomMargin_() + majiang_width / 2 + (index - 1) * (mopai_space + majiang_width * total)
        local x = startX + self:calcTanPaiOffsetWidth_(majiang_width, offset)
        local y = bottom_margin + majiang_height + majiang_height
        return x, y
end

function PlayerView:calcTanPaiPosRight_(index, offset, isTanPai, total)

        local majiang_height = 84
        local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
        local bottom_margin, wai_pai_space = 180, 20
        local x = display.width * (1114 / DESIGN_WIDTH) - majiang_height
        local startY = bottom_margin + (index - 1) * (wai_pai_space + majiang_width * total)
        local y = startY + self:calcTanPaiOffsetWidth_(majiang_width, offset)
        return x, y 

end

-- 390 890
function PlayerView:calcTanPaiPosTop_(index, offset, isTanPai, total)

        local wai_pai_space = 20
        local majiang_height, majiang_width = 55, MA_JIANG_DAO_WIDTH[self.index_]
        local startX = display.width * 900 / DESIGN_WIDTH - (index - 1) * (wai_pai_space + majiang_width * total)
        local x = startX - self:calcTanPaiOffsetWidth_(majiang_width, offset)
        local y = display.height - 62 - majiang_height
        return x, y

end

function PlayerView:calcTanPaiPosLeft_(index, offset, isTanPai, total)
   
        local majiang_height = 84
        local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
        local top_margin, wai_pai_space = 712, 20
        local x = display.width * (166 / DESIGN_WIDTH)+ majiang_height
        local startY = top_margin - (index - 1) * (wai_pai_space + majiang_width * total)
        local y = startY - self:calcTanPaiOffsetWidth_(majiang_width, offset)
        return x, y

end
function PlayerView:createChuPai_(card, total, index)
    local x, y, showIndex = self:calcChuPaiPos_(total, index)
    local nx, ny, _ = self:calcChuPaiPos_(total, index + 1)
    local maJiang = app:createConcreteView("MaJiangView", card, self.index_, true):addTo(self.nodeChuPai_, showIndex):pos(nx, ny)
    transition.moveTo(maJiang, {time = 0.2, x = x, y = y, easing = "Out"})
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        maJiang:scale(BOTTOM_CHU_PAI_SCALE)
    elseif self.index_ == MJ_TABLE_DIRECTION.TOP then
        maJiang:scale(TOP_CHU_PAI_SCALE)
    end
    return maJiang
end

function PlayerView:onGangLock_(event)
    self.isGangLocked_ = event.isLock or false
    if self.index_ == 1 then
        if self.isGangLocked_ then
            for k,v in pairs(self:getMaJiangs()) do
                if not v:isMoPai() then
                    v:setFixed(true)
                    v:doFixed_()
                end
            end
        end
    end
end

function PlayerView:onChuPaiChanged_(event)
    self.nodeChuPai_:removeAllChildren()
    if not event.cards or 0 == #event.cards then
        printInfo("PlayerView:onChuPaiChanged_(event) with no cards")
        return
    end

    local tmpMJ = {}
    for i,v in ipairs(event.cards) do
        local MJ = self:createChuPai_(v, #event.cards, i)
        table.insert(tmpMJ, MJ)
    end
    self.reConnectLastMJ_ = tmpMJ[#tmpMJ]
    if event.onlyShowCards then
        self.nodePlayer_:hide()
        self.nodeMaJiangs_:hide()
    end
end

function PlayerView:onChuPaiAdded_(event)
    if not event or not event.card then
        printInfo("PlayerView:onChuPaiAdded_(event) return with no event or card")
        return
    end
    local nodes = self.nodeChuPai_:getChildren()
    local maJiang = self:createChuPai_(event.card, #nodes + 1, #nodes + 1)
    self:focusOn_(maJiang)
    self:setAllNotMoPai_()
    if not event.dennyAnim then
        self:showChuPaiAnim_(event.card)
        gameAudio.playMaJiangSound(event.card, self.player_:getSex())
    end
end
function PlayerView:onAfterGangPaiAdded_(event)
    if not event or not event.cards then
        printInfo("PlayerView:onChuPaiAdded_(event) return with no event or card")
        return
    end
    -- self:showAfterGangPaiAnim_(event.cards)
    gameAudio.playMaJiangSound(event.card, self.player_:getSex())
    self:performWithDelay(function()
        for k,card in pairs(event.cards) do
        local nodes = self.nodeChuPai_:getChildren()
        local maJiang = self:createChuPai_(card, #nodes + 1, #nodes + 1)
        self:focusOn_(maJiang)
        self:setAllNotMoPai_()
    end
    end, 2)
end

-- 出牌的动画
function PlayerView:showChuPaiAnim_(card)
    local nodes = self:getMaJiangNode_():getChildren()
    local total = 0
    if nodes then
        total = table.nums(nodes)
    end
    local x, y, z = self:calcMaJiangPos_(total, total)
    local delObj = self:getRemoveMaJiang_(card)
    if delObj then
        x, y = delObj:getPosition()
    end
    local obj = app:createConcreteView("MaJiangView", card, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeAnims_, -1)
    obj:pos(x, y)
    local toX, toY = unpack(CHU_PAI_ANIM_POS[self.index_])
    local seconds = 0.5
    local move = cc.MoveTo:create(seconds, cc.p(toX, toY))
    local scale = cc.ScaleTo:create(seconds, 1.5)
    local walk = cc.Spawn:create(move, scale)
    local walkMagic = transition.newEasing(walk, "exponentialOut")
    local action = transition.sequence({
        walkMagic,
        cc.DelayTime:create(seconds / 2),
        cc.CallFunc:create(function ()
            obj:removeFromParent()
        end)
    })
    obj:runAction(action)
end

-- 展示玩家的动作动画
function PlayerView:showActionAnim_(animName)
    local toX, toY = unpack(ACTION_ANIM_POS[self.index_])
    local action = 'play' .. string.ucfirst(animName)
    local obj = app:createConcreteView("game.ActionAnim"):addTo(self.nodeAnims_):pos(toX, toY)
    if obj[action] and type(obj[action]) == 'function' then
        obj[action](obj)
    end
end

function PlayerView:playZiMo()
    self:showActionAnim_("ziMo")
    gameAudio.playActionSound('zimo', self.player_:getSex())
end

function PlayerView:playChi()
    self:showActionAnim_("chi")
    gameAudio.playActionSound('chi', self.player_:getSex())
end

function PlayerView:playPeng()
    self:showActionAnim_("peng")
    gameAudio.playActionSound('peng', self.player_:getSex())
end

function PlayerView:playGang(action)
    -- if action == CSMJ_ACTIONS.AN_GANG then
    --     self:playGangAnimation_(false)
    -- else
    --     self:playGangAnimation_(true)
    -- end
    self:showActionAnim_("gang")
    gameAudio.playActionSound('gang', self.player_:getSex())
end

function PlayerView:playBu(action)
    -- if action == CSMJ_ACTIONS.AN_Bu then
    --     self:playGangAnimation_(false)
    -- else
    --     self:playGangAnimation_(true)
    -- end
    self:showActionAnim_("bu")
    gameAudio.playActionSound('bu', self.player_:getSex())
end

function PlayerView:playBuAnimation_(isMingG)

    local sp = display.newSprite("#mj/ht_anim1.png"):pos(display.cx,display.cy):addTo(self)
    sp:scale(2)

    -- local frames = display.newFrames("ht_anim%d.png",1,10)

    local frames = {}
    for i=1,10 do
        local frame = display.newSpriteFrame(string.format("mj/ht_anim%d.png", i))
        table.insert(frames, frame)
    end

    local animation = display.newAnimation(frames,0.1)
    sp:playAnimationOnce(animation,true)

    local sequence = transition.sequence({
    cc.ScaleTo:create(0.2,2.5),
    cc.ScaleTo:create(0.2,2),
    cc.DelayTime:create(0.4),
    cc.FadeOut:create(0.2),cc.RemoveSelf:create(true),})

    if isMingG then
        local mingSp = display.newSprite("#mj/ht_mg.png"):pos(display.cx,display.cy):addTo(self)
        mingSp:runAction(sequence)
    else
        local anSp = display.newSprite("#mj/ht_ag.png"):pos(display.cx,display.cy):addTo(self)
        anSp:runAction(sequence)
    end
end

function PlayerView:playGangAnimation_(isMingG)

    local sp = display.newSprite("#mj/ht_anim1.png"):pos(display.cx,display.cy):addTo(self)
    sp:scale(2)

    -- local frames = display.newFrames("ht_anim%d.png",1,10)

    local frames = {}
    for i=1,10 do
        local frame = display.newSpriteFrame(string.format("mj/ht_anim%d.png", i))
        table.insert(frames, frame)
    end

    local animation = display.newAnimation(frames,0.1)
    sp:playAnimationOnce(animation,true)

    local sequence = transition.sequence({
    cc.ScaleTo:create(0.2,2.5),
    cc.ScaleTo:create(0.2,2),
    cc.DelayTime:create(0.4),
    cc.FadeOut:create(0.2),cc.RemoveSelf:create(true),})

    if isMingG then
        local mingSp = display.newSprite("#mj/ht_mg.png"):pos(display.cx,display.cy):addTo(self)
        mingSp:runAction(sequence)
    else
        local anSp = display.newSprite("#mj/ht_ag.png"):pos(display.cx,display.cy):addTo(self)
        anSp:runAction(sequence)
    end
end

function PlayerView:playFangPao(action)
    local soundAction = "hu"
    if action == CSMJ_ACTIONS.ZI_MO then
        soundAction = "zimo"
    elseif action == CSMJ_ACTIONS.CHI_HU then
        if math.random(1, 100) < 50 then
            soundAction = "dianpao"
        end
    else
        soundAction = "qiangganghu"
    end
    self:showActionAnim_("hu")
    gameAudio.playActionSound(soundAction, self.player_:getSex())
end

function PlayerView:onHandCardRemoved_(event)
    self:removeHandMaJiang_(event.card)
end

function PlayerView:getRemoveMaJiang_(card)
    local node = self:getMaJiangNode_()
    local nodes = node:getChildren()
    if not nodes or table.nums(nodes) < 1 then
        return
    end
    for _,v in pairs(nodes) do
        if v:isBeOut() and v:getMaJiang() == card then
            return v
        end
    end
    for _,v in pairs(nodes) do
        if v:getMaJiang() == card then
            return v
        end
    end
    for _,v in pairs(nodes) do
        if 0 == v:getMaJiang() then
            return v
        end
    end
    if self.index_ ~= MJ_TABLE_DIRECTION.BOTTOM then
        return nodes[math.random(1, table.nums(nodes) or 0)]
    end
end

function PlayerView:removeHandMaJiang_(card)
    local obj = self:getRemoveMaJiang_(card)
    if obj then
        obj:removeFromParent()
    end
end

function PlayerView:getLastChuPaiPos()
    local nodes = self.nodeChuPai_:getChildren()
    if not nodes or #nodes < 1 then
        return self:calcChuPaiPos_(1, 1)
    end
    return self:calcChuPaiPos_(#nodes, #nodes)
end

function PlayerView:calcChuPaiPos_(total, index)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcChuPaiPosBottom_(total, index)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcChuPaiPosRight_(total, index)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcChuPaiPosTop_(total, index)
    else
        return self:calcChuPaiPosLeft_(total, index)
    end
end

function PlayerView:calcChuPaiPosBottom_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_] * BOTTOM_CHU_PAI_SCALE
    local x = (display.width - majiang_width * self.cpLian) / 2 + (index - 1) % self.cpLian * majiang_width + 19
    local y = display.height * 300 / DESIGN_HEIGHT - math.floor((index - 1) / self.cpLian) * 50 - 25
    return x, y, index
end

function PlayerView:calcChuPaiPosRight_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local x = display.width * 935 / DESIGN_WIDTH + math.floor((index - 1) / self.cpLian) * 82 - index * 4 - 40
    local y = (display.height - majiang_width * self.cpLian) / 2 + (index - 1) % self.cpLian * majiang_width + 44
    return x, y, -index
end

-- 390 890
function PlayerView:calcChuPaiPosTop_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local x = display.width - (display.width - majiang_width * self.cpLian) / 2 - (index - 1) % self.cpLian * majiang_width - 30
    local y = display.height * (display.height - 250) / DESIGN_HEIGHT + math.floor((index - 1) / self.cpLian) * 40 +50
    return x, y, -index
end

function PlayerView:calcChuPaiPosLeft_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local x = display.width * 340 / DESIGN_WIDTH - math.floor((index - 1) / self.cpLian) * 18 - index * 4 +100
    local y = display.height - (display.height - majiang_width * self.cpLian) / 2 - (index - 1) % self.cpLian * majiang_width + 20
    if math.floor((index - 1) / self.cpLian) == 1 then
        index = -100 + index
    elseif math.floor((index - 1) / self.cpLian) == 2 then
        index = -200 + index
    elseif math.floor((index - 1) / self.cpLian) == 3 then
        index = -300 + index
    end
    return x, y, index
end

function PlayerView:onWinWithCtype(ctype)
    if not ctype or type(ctype) ~= 'number' then
        return
    end
    if not table.indexof({2, 3, 7, 8, 9, 10, 11, 12, 13, 14}, ctype) then
        return
    end
    if self.isCtypeShowDown_ then
        return
    end
    self.isCtypeShowDown_ = true
    local x, y = self:getPlayerPosition()
    local frames = display.newFrames("canim%d.png", 1, 11)
    local boom = display.newSprite(frames[1]):addTo(self.nodeAnims_):pos(x, y)
    local spriteCtype = display.newSprite(string.format("#ctype%d.png", ctype)):addTo(self.nodeAnims_):pos(x, y)
    transition.playAnimationOnce(boom, display.newAnimation(frames, 1 / 11), true, function ()
        transition.fadeOut(spriteCtype, {time = 1, delay = 1, onComplete = function ()
            spriteCtype:removeFromParent()
        end})
    end)
end

-- 计算节点们的四个最大值
function PlayerView:calcMaxWidthValues_(nodes)
    local maxX, maxY, minX, minY = nil, nil, nil, nil
    for i,v in ipairs(nodes) do
        local x, y = v:getPosition()
        if not maxX or not minX or not maxY or not minY then
            maxX = x
            minX = x
            maxY = y
            minY = y
        else
            maxX = math.max(maxX, x)
            minX = math.min(minX, x)
            maxY = math.max(maxY, y)
            minY = math.min(minY, y)
        end
    end
    return maxX, maxY, minX, minY
end

function PlayerView:calcMaJiangBottomMargin_()
    local width = MA_JIANG_SHU_WIDTH[MJ_TABLE_DIRECTION.BOTTOM] * MA_JIANG_BOTTOM_SCALE
    local total_width = (width * 14 + MO_PAI_MARGIN_BOTTOM * MA_JIANG_BOTTOM_SCALE)
    local margin = (display.width - total_width) / 2
    if margin >= 0 then
        return margin
    end
    MA_JIANG_BOTTOM_SCALE = MA_JIANG_BOTTOM_SCALE * 0.9
    return self:calcMaJiangBottomMargin_()
end

function PlayerView:calcWaiPaiWidth_()
    local nodes = self.nodeWaiPai_:getChildren()
    local width = MA_JIANG_DAO_WIDTH[self.index_]
    if not nodes or #nodes < 1 then
        if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
            return self:calcMaJiangBottomMargin_()
        elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
            return 150
        elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
            return display.width * 900 / DESIGN_WIDTH
        else
            return 650
        end
    end

    local maxX, maxY, minX, minY = self:calcMaxWidthValues_(nodes)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return maxX + width / 2
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return maxY + width / 2
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return minX - width / 2
    else
        return minY - width / 2
    end
end

function PlayerView:calcMaJiangPosBottom_(total, index, isDown)
    local majiang_height = 125
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]

    local wai_width = self:calcWaiPaiWidth_()
    majiang_width = majiang_width * MA_JIANG_BOTTOM_SCALE
    majiang_height = majiang_height * MA_JIANG_BOTTOM_SCALE

    local bottom_margin, wai_pai_space = 16, 0
    if wai_width > 30 then  -- 如果左右间距大于此值，则可以设置一点外牌与手牌的间距
        wai_pai_space = 20
    end
    local x = wai_width + wai_pai_space + (index - 1) * majiang_width + majiang_width / 2 + 10
    local y = bottom_margin + majiang_height / 2
    return x, y, 0
end

function PlayerView:calcMaJiangPosRight_(total, index, isDown)
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
    if isDown then
        majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    end
    local bottom_margin = 216
    local dist = -83
    if total == 10 or total == 9 then
        dist = -60
    elseif total == 7 or total == 6 then
        dist = -40
    elseif total == 4 or total == 3 then
        dist = -15
    elseif total == 1 or total == 0 then
        dist = 10
    end
    local x = display.width * (1114 / DESIGN_WIDTH) - dist - 40 - index*6
    local y = self:calcWaiPaiWidth_() + 22 + (index - 1) * majiang_width + majiang_width / 2 + 20
    return x, y, -index
end

-- 390 890
function PlayerView:calcMaJiangPosTop_(total, index, isDown, isHand)
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
    if isDown then
        majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
        if isHand then
            majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
        end

        if display.getRunningScene().__cname == "ZhanJiScene" then
            majiang_width = TOP_REVIEW_DOWN_HAND_WIDTH
        end
    end
    local x = self:calcWaiPaiWidth_() - (index - 1) * majiang_width - 10 - majiang_width / 2 - 10
    local y = display.height - 60
    return x, y, 0
end

function PlayerView:calcMaJiangPosLeft_(total, index, isDown)
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
    if isDown then
        majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    end
    local dist = 83
    if total == 10 or total == 9 then
        dist = dist - 40
    elseif total == 7 or total == 6 then
        dist = dist - 60
    elseif total == 4 or total == 3 then
        dist = dist - 85
    elseif total == 1 or total == 0 then
        dist = dist-110
    elseif total == 13 then
        dist = dist - 20
    end
    local distY = 0
    if total == 13 then
        distY = distY - 10
    end
    local top_margin = 622
    local x = display.width * (166 / DESIGN_WIDTH) - index*6.5 + dist
    local y = self:calcWaiPaiWidth_() - (index - 1) * majiang_width - 10 - majiang_width / 2 - 30 + distY
    return x, y, index
end

function PlayerView:calcMaJiangPos_(total, index, isDown, isHand)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcMaJiangPosBottom_(total, index, isDown)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcMaJiangPosRight_(total, index, isDown)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcMaJiangPosTop_(total, index, isDown, isHand)
    elseif MJ_TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcMaJiangPosLeft_(total, index, isDown)
    end
end

function PlayerView:adjustMaJiangWithoutMoPai(isDown)
    self:performWithDelay(function ()
        self:doAdjustHandCards_(false, isDown)
    end, 0.05)
end

function PlayerView:adjustMaJiang(isDown)
    self:performWithDelay(function ()
        self:doAdjustHandCards_(true, isDown)
    end, 0.05)
end

function PlayerView:getMaJiangNode_()
    if self:isHost() then
        return  self.nodeMaJiangsHost_
    end
    return self.nodeMaJiangs_
end

function PlayerView:doAdjustHandCards_(includeMoPai, isDown)
    self.inAdjustMaJiang_ = true
    local includeMoPai = includeMoPai or false
    local nodes = self:getMaJiangNode_():getChildren()
    if not nodes or table.nums(nodes) < 1 then
        return
    end

    local function maJiangCompare(v1, v2)
        if v1:getMaJiang() == v2:getMaJiang() then  -- 保证在值相同的情况下排序是稳定的
            if not v1.__sort_id__ then
                v1.__sort_id__ = math.random(100000000, 200000000)
            end
            if not v2.__sort_id__ then
                v2.__sort_id__ = math.random(100000000, 200000000)
            end
            return v1.__sort_id__ < v2.__sort_id__
        end
        local withLizi = dataCenter:getIsLaiZi()
        if withLizi then
            if v1:getMaJiang() == BaseAlgorithm.NAI_ZI then
                return true
            elseif v2:getMaJiang() == BaseAlgorithm.NAI_ZI then
                return false
            end
        end
        return v1:getMaJiang() < v2:getMaJiang()
    end
    table.sort(nodes, maJiangCompare)
    local count = table.nums(nodes)
    if not includeMoPai then
        count = count - 1
    end
    local index = 1

    for _,v in ipairs(nodes) do
        if not v:isMoPai() or includeMoPai then
            transition.stopTarget(v)
            local x, y, z = self:calcMaJiangPos_(count, index, isDown, true)
            v:setLocalZOrder(z)
            transition.moveTo(v, {time = 0.2, x = x, y = y, easing = "Out", onComplete = function ()
                self.inAdjustMaJiang_ = false
            end})
            index = index + 1
        end
    end
    self:performWithDelay(function()
        self:updateTingPaiTag()
        end, 0.5)
end

function PlayerView:showMaJiangsDirectly_(cards, isDown)
    local showCards = clone(cards)
    local withLizi = dataCenter:getIsLaiZi()

    BaseAlgorithm.sort(showCards, withLizi)
    for i,v in ipairs(showCards) do
        local x, y, z = self:calcMaJiangPos_(#showCards, i, isDown)
        self:createMaJiangWithTouch_(v, i, x, y, z, isDown)
    end
end

function PlayerView:removeMoMaJiangs_()
    local majiangs = self:getMaJiangNode_():getChildren()
     for k,v in pairs(majiangs) do
        if v:isMoPai() then
            v:removeFromParent()
        end
    end
end

function PlayerView:createMaJiangWithTouch_(card, index, x, y, z, isDown, isMoPai)
    local node = self:getMaJiangNode_()
    local isDown = isDown or false
    local isMax = false
    self:removeMoMaJiangs_()
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        if not card or 0 == card then
            isDown = true
            isMax = true
        end
    end
    local maJiang = app:createConcreteView("MaJiangView", card, self.index_, isDown, isMax):addTo(node, z):pos(x, y)
    maJiang.__sort_id__ = index
    if isMoPai then
        maJiang:setIsMoPai(isMoPai)
        transition.moveTo(maJiang, {x = x, y = y + 10, time = 0.1, onComplete = function()
            transition.moveTo(maJiang, {x = x, y = y, time = 0.1, onComplete = function()
            end})
            end})
    end

    if self.index_ ~= MJ_TABLE_DIRECTION.BOTTOM then
        if self.index_ == MJ_TABLE_DIRECTION.TOP then
            maJiang:scale(0.9)
        end
        return
    end
    if isDown then
        maJiang:scale(1.52)
        return
    end
    if not card or 0 == card then
        return
    end

    maJiang:scale(0.9)
    if self.isGangLocked_ and not maJiang:isMoPai() then
        maJiang:setFixed(true)
        return
    end
    gailun.uihelper.setRawTouchHandler(maJiang, function (event)
            self:onMaJiangTouchEnded_(maJiang, event)
        end,
        function (event)
            self:onMaJiangTouchdBegin_(maJiang, event)
        end,
        function (event)
            self:onMaJiangTouchMove_(maJiang, event)
        end
    )
end

function PlayerView:canChuPai_()
    -- if not dataCenter:isSocketReady() then
    --     return false
    -- end
    -- if self.player_.isLocked then
    --     return
    -- end
    if self.table_:getInPublicTime() then  -- 公共牌时间不允许出牌
        return false
    end
    if not self.table_:isMyTurn(self.player_:getSeatID()) then
        return false
    end
    return true
end

function PlayerView:onMaJiangChuAction_(maJiang)
    local card = maJiang:getMaJiang()
    if not self:canChuPai_() then  -- 公共牌时间不允许出牌
        return self:resetMaJiangAfterTouch_(maJiang)
    end

    if display.getRunningScene():getTable():getMaJiangType() == 1 and BaseAlgorithm.isNaiZi(card) then
        app:alert("红中癞子不能打出!")
        return self:resetMaJiangAfterTouch_(maJiang)
    end

    if self.isGangLocked_ and not maJiang:isMoPai() then
        app:alert("现在不能换张！")
        return self:resetMaJiangAfterTouch_(maJiang)
    end
    maJiang:setBeOut(true)
    printInfo(card .. " be out!")

    local tableController = display.getRunningScene().tableController_
    local data = {}
    data.code = 0
    data.cards = card
    data.isDown = true
    data.seatID = self.player_:getSeatID()
    tableController:doPlayerChuPai(data)

    dataCenter:sendOverSocket(COMMANDS.MMMJ_CHU_PAI, {
        cards = card
    })
    local allowSevenPairs = display.getRunningScene():getTable():getAllowSevenPairs()
    if self.player_:canZiMoHu(allowSevenPairs) then
        self.player_:addLouHu(card)
    end
    gameAudio.playSound("sounds/common/sound_card_out.mp3")
    display.getRunningScene():getTable():setMaJiangLight(card, false)

    display.getRunningScene():getTable():clearCurrSeatID()

    local tingView = self:getChildByName("tingView")
    if tingView ~= nil then
        tingView:removeFromParent()
    end
    -- self:resetMaJiangAfterTouch_(maJiang)
end

function PlayerView:setIndex(index)
    self.index_ = index
    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))
end

function PlayerView:resetMaJiangAfterTouch_(maJiang)
    local x, y = maJiang:getPosition()
    local dis = gailun.utils.distance(cc.p(x, y), cc.p(maJiang.rawX, maJiang.rawY))
    local move
    if dis < 10 then
        if maJiang.isSelct then
            maJiang.rawY = maJiang:getPositionY()-20
            maJiang.isSelct = nil
        else
            maJiang.rawY = maJiang:getPositionY()+20
            maJiang.isSelct = true
        end
    end
    if dis < 10 then
        move = cc.CallFunc:create(function ()
            maJiang:pos(maJiang.rawX, maJiang.rawY)
        end)
    else
        move = cc.MoveTo:create(0.1, cc.p(maJiang.rawX, maJiang.rawY))
    end
    local actions = transition.sequence({
        cc.CallFunc:create(function ()
            maJiang:setTouchEnabled(false)
        end),
        move,
        cc.CallFunc:create(function ()
            maJiang:setTouchEnabled(true)
            if maJiang.rawZOrder_ then
                maJiang:setLocalZOrder(maJiang.rawZOrder_)
            end
        end),
    })
    maJiang:runAction(actions)
    local card = maJiang:getMaJiang()

    display.getRunningScene():getTable():setMaJiangLight(card,false)
end

function PlayerView:onMaJiangTouchEnded_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end

    if self.inAdjustMaJiang_ then
        return
    end
    if not self:canChuPai_() then
        return
    end
    if event.y > display.height * 135 / DESIGN_HEIGHT then  -- 拖出了界面
        return self:onMaJiangChuAction_(maJiang)
    end
    local clickTime = os.time() + os.clock()
    if maJiang.clickTime_ and
        maJiang.clickTime_ > 0 and
        clickTime - maJiang.clickTime_ < 0.6 then
        return self:onMaJiangChuAction_(maJiang)
    end
    maJiang.clickTime_ = clickTime
    self:resetMaJiangAfterTouch_(maJiang)

    if not maJiang.isSelct then
        local tingView = self:getChildByName("tingView")
        if tingView ~= nil then
            tingView:removeFromParent()
        end
    end
end

function PlayerView:onMaJiangTouchdBegin_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end

    if self.inAdjustMaJiang_ then
        return
    end
    if not self:canChuPai_() then
        return
    end

    local card = maJiang:getMaJiang()

    local tableController = display.getRunningScene().tableController_
    local hostPlayer = tableController:getHostPlayer()

    local seats = tableController:getSeats()
    local handCards = {}
    local waiCards = {}
    local zhuoCards = {{card}}
    for k, v in pairs(seats) do
        table.insert(handCards, v:getCards() or {})
        table.insert(waiCards, v:getWaiPai() or {})
        table.insert(zhuoCards, v:getOutCards() or {})
    end

    local nowCards = hostPlayer:getCards()
    table.removebyvalue(nowCards, card)

    local remainCards = CSAlgorithm.getRemainCards(handCards, zhuoCards, waiCards)
    local tingPai = CSAlgorithm.getTingPai(remainCards, hostPlayer:getWaiPai(), nowCards)
    if self.selectMaJiang and self.selectMaJiang ~= maJiang then
        if self.selectMaJiang.isSelct then
            self.selectMaJiang:setPositionY(self.selectMaJiang:getPositionY()-20)
            self.selectMaJiang.isSelct = nil
        end
        local tingView = self:getChildByName("tingView")
        if tingView ~= nil then
            tingView:removeFromParent()
        end
    end
    if #table.values(tingPai) ~= 0 then
        local tingView = self:getChildByName("tingView")
        if tingView ~= nil then
            tingView:removeFromParent()
        end
        local tingView = TingView.new()
        tingView:setName("tingView")
        tingView:setCards(tingPai)

        local majiangPos = cc.p(maJiang:getPosition())
        if maJiang.isSelct then
            tingView:setPosition(majiangPos.x - display.cx, majiangPos.y - display.cy + 110-20)
        else
            tingView:setPosition(majiangPos.x - display.cx, majiangPos.y - display.cy + 110)
        end
        self:addChild(tingView, 9999)
    end
    self.selectMaJiang = maJiang
    maJiang.rawZOrder_ = maJiang:getLocalZOrder()
    maJiang:setLocalZOrder(100)
    maJiang.rawX, maJiang.rawY = maJiang:getPosition()
    display.getRunningScene():getTable():setMaJiangLight(card,true)
    gameAudio.playSound("sounds/common/sound_card_click.mp3")
end

function PlayerView:onMaJiangTouchMove_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end

    if self.inAdjustMaJiang_ then
        return
    end
    if not self:canChuPai_() then
        return
    end
    local width = MA_JIANG_SHU_WIDTH[MJ_TABLE_DIRECTION.BOTTOM]
    local x, y = event.x, event.y
    x = math.max(width / 2, x)
    x = math.min(display.width - width / 2, x)
    local height = 125
    y = math.max(height / 2, y)
    y = math.min(display.height - height / 2, y)
    maJiang:pos(x, y)
end

function PlayerView:getPlayerPosition()
    local index = self.index_
    assert(index > 0 and index < 10)
    return unpack(OFFSET_OF_SEATS_4[index])
end

-- cc.BezierTo:create(time，{cc.p(x, y), cc.p(x1, y1), cc.p(x2, y2)})
-- TODO: 贝塞尔曲线运动
function PlayerView:adjustSeatPos_(index, withAction)
    self:initPosByIndex_()
    local moveTime = 0.5
    local x, y = self:getPlayerPosition()
    if withAction then
        transition.moveTo(self.nodePlayer_, {x = x, y = y, time = moveTime, easing = "exponentialOut"})
    else
        self.nodePlayer_:pos(x, y)
    end
end

function PlayerView:onIndexChanged_(event)
    self.index_ = event.index
    self:adjustSeatPos_(self.index_, event.withAction)
    self:adjustReady_()
end

function PlayerView:removeMaJiangs_()
    self:getMaJiangNode_():removeAllChildren()
end

function PlayerView:calcPokerOffsetX_(isHost)
    if isHost then
        return HOST_OFFSET_X
    else
        return PLAYER_OFFSET_X
    end
end

function PlayerView:filterMaJiangs(cards5)
    local majiangs = self:getMaJiangs()
    for _,v in pairs(checktable(majiangs)) do
        if false == table.indexof(cards5, v:getPoker()) then
            v:lowLight()
        else
            v:highLight()
        end
    end
end

function PlayerView:clearValue_()
    local majiangs = self:getMaJiangs()
    for k,v in pairs(majiangs) do
        v:setFlag(false)
    end
end

function PlayerView:getMaJiangByValue_(card)
    local majiangs = self:getMaJiangs()
    for k,v in pairs(majiangs) do
        if v:getMaJiang() == card and not v:getFlag() then
            v:setFlag(true)
            return v
        end
    end
end

function PlayerView:getMaJiangs()
    local node = self:getMaJiangNode_()
    return node:getChildren()
end

function PlayerView:showHostHandCards_()
    if not self:isHost() then
        return
    end

    local majiangs = self:getMaJiangs()
    for _,v in pairs(checktable(majiangs)) do
        transition.rotateTo(v, {rotate = 0, time = 0.2})
    end
end

function PlayerView:onHandCardsChanged_(event)
    local cards = event.cards
    self:removeMaJiangs_()
    if not cards or 0 == #cards then  -- 无牌则清理手牌
        return
    end

    self:showMaJiangsDirectly_(cards, event.isDown)
    if event.action then
        self:playActionAnim_(event.action)
    end
    if event.huPai then
        local x, y, z = self:calcMoPaiPos_(event.isDown)
        self:setAllNotMoPai_()
        self:createMaJiangWithTouch_(event.huPai, #self.player_:getCards(), x, y, z, true, true)
    end
end

function PlayerView:calcMoPaiPos_(isDown)
    local nodes = self:getMaJiangNode_():getChildren()
    local total, index = 0, 1
    if nodes then
        total = table.nums(nodes)
    end
    index = total + 1
    local x, y, z = self:calcMaJiangPos_(total, index, isDown)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        x = x + MO_PAI_MARGIN_BOTTOM
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        y = y + MO_PAI_MARGIN_OTHER
    elseif MJ_TABLE_DIRECTION.LEFT == self.index_ then
        y = y - MO_PAI_MARGIN_OTHER
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        x = x - MO_PAI_MARGIN_OTHER
    end
    local maxZ, minZ = 0, 0
    for _,v in pairs(nodes) do
        if not maxZ or not minZ then
            maxZ = v:getLocalZOrder()
            minZ = v:getLocalZOrder()
        else
            maxZ = math.max(v:getLocalZOrder(), maxZ)
            minZ = math.min(v:getLocalZOrder(), minZ)
        end
    end
    if self.index_ == MJ_TABLE_DIRECTION.RIGHT then
        z = minZ - 1
        x = x - 4
    elseif self.index_ == MJ_TABLE_DIRECTION.LEFT then
        z = maxZ + 1
        x = x - 4
    end
    return x, y, z
end

function PlayerView:onMaJiangFound_(event)
    local card = event.card
    -- dump(card)
    local isDown = event.isDown or false
    local x, y, z = self:calcMoPaiPos_(isDown)
    self:setAllNotMoPai_()
    self:createMaJiangWithTouch_(card, #self.player_:getCards(), x, y, z, isDown, true)
    gameAudio.playSound("sounds/common/sound_deal_card.mp3")
    self:performWithDelay(function()
        self:updateTingPaiTag()
        end, 0.5)
end

function PlayerView:setAllNotMoPai_()
    local nodes = self:getMaJiangNode_():getChildren()
    for _,v in pairs(nodes) do
        v:setIsMoPai(false)
    end
end

function PlayerView:onAvatarClicked_(event)
    if not self.player_ then
        printInfo("if not self.player_ then")
        self:dispatchEvent({name = PlayerView.ON_AVATAR_CLICKED, params = {isInvite = true}})
        return
    end

    local info = self.player_:getShowParams()
    info.x = display.cx
    info.y = display.cy
    info.seatID = self.player_:getSeatID()

    self:dispatchEvent({name = PlayerView.ON_AVATAR_CLICKED, params = info})
end

function PlayerView:setScoreWithRoller_(score, fromScore)
    local clockScore = display.getRunningScene():getLockScore()
    NumberRoller:run(self.labelScore_, fromScore+clockScore, score+clockScore)
end

function PlayerView:setScore(score)
    NumberRoller:run(self.labelScore_, score, score)
end

function PlayerView:setNickName(name)
    self.labelNickName_:setString(name)
end

function PlayerView:setPlayerChildrenVisible(flag)
    local children = self.nodePlayer_:getChildren()
    local visible = self.spriteZhuanquan_:isVisible()
    local visible1 = self.voiceQiPao_:isVisible()
    for _,v in pairs(children) do
        if v ~= self.spriteOffline_ and 
            v ~= self.tanFenAdd_ and
            v ~= self.tanFenDel_  then
            v:setVisible(flag or false)
        end
    end
    self.spriteZhuanquan_:setVisible(visible) -- 转圈
    local visible1 = self.voiceQiPao_:setVisible(visible1)
    -- self.buttonInvite_:hide()
end

function PlayerView:clearAllMaJiangs_()
    self:getMaJiangNode_():removeAllChildren()
    self.nodeChuPai_:removeAllChildren()
    self.nodeWaiPai_:removeAllChildren()
    self.nodeTanPai_:removeAllChildren()
    self.isGangLocked_ = false
end

------------- 一系列的响应状态变化而改变view的函数，下划线后面都是player model里面的状态 ---------------
function PlayerView:onPlayStateChanged_(opacity)
    if opacity and opacity >= 0 and opacity <= 255 then
        self:setOpacity(opacity)
    end
    self:setPlayerChildrenVisible(true)
end

function PlayerView:onStateIdle_(event)
    self:setPlayerChildrenVisible(false)
    -- self.buttonInvite_:show()
    self:setOpacity(255)
    self.spriteBg_:show()
    self:clearAllMaJiangs_()
    self.spriteReady_:hide()
end

function PlayerView:onStateReady_(event)
    self:clearAllMaJiangs_()
    self:showReady_()
    gameAudio.playSound("sounds/common/sound_ready.mp3")
end

function PlayerView:showReady_()
    self.spriteReady_:show()
    self:adjustReady_()
    self.isGangLocked_ = false

end

function PlayerView:onResetPlayer_()
    self.spriteReady_:hide()
    self.isGangLocked_ = false
end

function PlayerView:adjustReady_()
    local x, y = unpack(ready_pos[self.index_])
    self.spriteReady_:pos(x, y)
end

function PlayerView:onStateWaiting_(event)
    self:onStateWaitNext_()
    -- self:setScoreWithRoller_(self.player_:getScore())
    self.spriteReady_:hide()
end

function PlayerView:onStateWaitNext_(event)
    self:onPlayStateChanged_(255)
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    self:clearAllMaJiangs_()
    self.spriteReady_:hide()
end

function PlayerView:onStateWaitCall_(event)
    self:onPlayStateChanged_(nil, 255)
    self.isCtypeShowDown_ = false
    self.spriteReady_:hide()
end

function PlayerView:onStateThinking_(event)
    self:onPlayStateChanged_(255)
    self.spriteReady_:hide()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        gameAudio.playSound("turnto.mp3")
    end
end

function PlayerView:onStateChanged_(event)
    if not event.to then
        return
    end
    local s = string.split(string.lower(event.to), '_')
    local methodName = "onState"
    for _,v in pairs(s) do
        methodName = methodName .. string.ucfirst(v)
    end
    methodName = methodName .. "_"
    if self[methodName] and type(self[methodName]) == 'function' then
        handler(self, self[methodName])(event)
    end
end

function PlayerView:focusOn_(maJiang, index)
    if not maJiang then
        return
    end

    local posX, posY = self:getLastChuPaiPos()

    -- local posX, posY = maJiang:getPosition()
    local size = maJiang:getContentSize()

    -- if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
    --     posX = posX + MA_JIANG_DAO_WIDTH[self.index_] * BOTTOM_CHU_PAI_SCALE
    -- elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
    --     posY = posY + MA_JIANG_DAO_WIDTH[self.index_]
    -- elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
    --     posX = posX - MA_JIANG_DAO_WIDTH[self.index_]
    -- elseif MJ_TABLE_DIRECTION.LEFT == self.index_ then
    --     posY = posY - MA_JIANG_DAO_WIDTH[self.index_]
    -- end

    display.getRunningScene():getTable():setFocusOn(posX, posY)
end

function PlayerView:onReconnectOn_(event)
    -- dump(self.reConnectLastMJ_ , "onReconnectOn_")
    if self.reConnectLastMJ_ then
        self:focusOn_(self.reConnectLastMJ_)
    end
end

function PlayerView:zhuanQuanAction_(event)
    self.spriteZhuanquan_:show()
end

function PlayerView:stopZhuanQuanAction_(event)
    self.spriteZhuanquan_:hide()
end

function PlayerView:onPlayerVoice_(event)
    self.voiceQiPao_:playVoiceAnim(event.time)
end

function PlayerView:onStopRecordVoice_(event)
    self.voiceQiPao_:stopRecordVoice()
end

function PlayerView:initPosByIndex_()
    local qiPaoX = QI_PAO_X
    local tanFenX = 100
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        self.nodeWaiPai_:setSkewX(0)
        self.voiceQiPao_:setFlipX(false)
        self.voiceQiPao_:setPositionX(qiPaoX) 
        self.tanFenAdd_:setPositionX(tanFenX)
        self.tanFenDel_:setPositionX(tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.LEFT then
        self.nodeWaiPai_:setSkewX(5)
        self.voiceQiPao_:setFlipX(false)
        self.voiceQiPao_:setPositionX(qiPaoX) 
        self.tanFenAdd_:setPositionX(tanFenX)
        self.tanFenDel_:setPositionX(tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.RIGHT then
        self.nodeWaiPai_:setSkewX(-5)
        qiPaoX = - QI_PAO_X
        self.voiceQiPao_:setPositionX(qiPaoX)
        self.voiceQiPao_:setFlipX(true)
        self.tanFenAdd_:setPositionX(-tanFenX)
        self.tanFenDel_:setPositionX(-tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.TOP then
        self.nodeWaiPai_:setSkewX(0)
        self.tanFenAdd_:setPositionX(-tanFenX)
        self.tanFenDel_:setPositionX(-tanFenX)
    end
    self.tanFenDel_:setPositionY(-10)
end

function PlayerView:onOfflineEvent_(event)
    self.spriteOffline_:setVisible(event.offline)
    if not event.offline and event.isChanged then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

------------- 响应状态变化函数段结束 ------------------------------------------------------------

return PlayerView
