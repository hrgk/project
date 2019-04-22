local BaseAlgorithm = require("app.games.hzmajiang.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local ZZAlgorithm = require("app.games.hzmajiang.utils.ZZAlgorithm")

local TingView = require("app.games.csmj.views.game.Ting2DView")

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
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView",x = 0,y = 30},
            {type = TYPES.SPRITE, var = "playerBg_", filename = "res/images/common/playerBg.png",},
            {type = TYPES.SPRITE, var = "spriteBg_", filename = "res/images/common/avatar_border.png",x = 0,y = 30},

            {type = TYPES.SPRITE, var = "spriteZhuanquan_",x = 0,y = 30},
            {type = TYPES.CUSTOM, var = "voiceQiPao_", class = "app.views.game.VoiceQiPao", x = QI_PAO_X, y = QI_PAO_Y, visible = false},
            {type = TYPES.LABEL_ATLAS, var = "tanFenAdd_", visible = false, filename = "fonts/game_tanfen_win.png", options = {text="10", w = 26, h = 51, startChar = "+"}, y = 0, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.LABEL_ATLAS, var = "tanFenDel_", visible = false, filename = "fonts/game_tanfen_lose.png", options = {text="10", w = 26, h = 51, startChar = "+"}, y = 0, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text="fdsafdsafdsa", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, y = -15, x = 0, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/majiang/game/score-bg.png", y = -45,children = {
                --{type = TYPES.SPRITE, filename = "res/images/majiang/game/score-bg1.png", x = 16, ppy = 0.48},
                {type = TYPES.LABEL, options = {text="得分", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, x = 10, ppy = 0.48},
                {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.3, x = 50, ap = {0, 0.5}},
                {type = TYPES.SPRITE, var = "nodeChui_", visible = false, ppx = 0.5, y = -20},
            },
            },
            {type = TYPES.SPRITE, var = "spriteOffline_", filename = "res/images/majiang/game/off_line_sign.png", x = 30, y = -30},
            },  
        },
        {type = TYPES.SPRITE, var = "spriteReady_", filename = "res/images/game/ready/1.png", visible = false},
        {type = TYPES.NODE, var = "nodeChat_"},  -- 聊天容器
        {type = TYPES.NODE, var = "nodeTanPai_"},  -- 外牌容器 nodeAnims_
        {type = TYPES.NODE, var = "nodeAnims_"},  -- 动画容器
    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatHandler(tostring)
local Player2DView = class("Player2DView", gailun.BaseView)

local HOST_OFFSET_X, HOST_SPACE_X = 100, 12  -- 主玩家发牌终点偏移量、两张手牌的间距
local PLAYER_OFFSET_X, PLAYER_OFFSET_Y, PLAYER_SPACE_X = 34, -18, 3  -- 其它玩家发牌终点X与Y，两张手牌的间距
local CARD_DELAY_SECONDS = 0.1  -- 发牌移动动作与旋转动作之间的时间间隔
local MO_PAI_MARGIN_BOTTOM, MO_PAI_MARGIN_OTHER = 40, 18
local MA_JIANG_BOTTOM_SCALE = 1.3 -- 底部的牌的缩放

local player_pos = {
    {0.061, 0.28},
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

local MA_JIANG_SHU_WIDTH = {91, 27, 35, 27}  -- 竖着的麻将的宽度
local MA_JIANG_DAO_WIDTH = {56, 27, 35, 27}  -- 倒着的麻将的宽度
local MA_JIANG_CHU_WIDTH = {50, 32, 50, 32}
local BOTTOM_WAI_PAI_SCALE = 55/51
local TOP_CHUPAI_WIDTH = 49
local TOP_REVIEW_DOWN_HAND_WIDTH = 42

Player2DView.SIT_DOWN_CLICKED = "SIT_DOWN_CLICKED"
Player2DView.ON_AVATAR_CLICKED = "ON_AVATAR_CLICKED"

function Player2DView:ctor(index, maJiangNode)
    assert(index > 0 and index < 5 and maJiangNode, "bad player index of " .. checkint(index))
        print("==============majiang PLAYERVIEDW-===============")

    self.index_ = index
    -- self.table_ = display.getRunningScene():getTable()
    gailun.uihelper.render(self, nodeData)
    self.nodePlayer_:pos(unpack(OFFSET_OF_SEATS_4[index]))

    self:setCascadeOpacityEnabled(true)
    self.nodePlayer_:setCascadeOpacityEnabled(true)
    self.nodeMaJiangs_:setCascadeOpacityEnabled(true)
    self.nodeMaJiangsHost_ = maJiangNode

    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.buttonInvite_:onButtonClicked(handler(self, self.onAvatarClicked_))

    -- self.spriteZhuanquan_:setScale(2)
    self.isGangLocked_ = false
    self:initTiShiAnimation_()
    self.cpLian = 6
    self.runScene = display.getRunningScene()
end

function Player2DView:setTable(model)
    self.table_ = model
end

function Player2DView:showReayAnim()
    self.spriteReady_:show()
    self.readyIndex = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.readyIndex = self.readyIndex + 1
                    if self.readyIndex > 3 then
                        self.readyIndex = 1
                    end
                    local frameName = string.format("res/images/game/ready/%d.png", self.readyIndex)
                    local texture = cc.Director:getInstance():getTextureCache():addImage(frameName)
                    self.spriteReady_:setTexture(texture)
                end
            )
        }
    )
    self.spriteReady_:runAction(cc.RepeatForever:create(sequence))
end

function Player2DView:onEnter()
    self:initPosByIndex_()
    self:onStateIdle_()
    self.labelNickName_:enableShadow(cc.c4b(0, 0, 0, 128), cc.size(2, -3), 1)
    gailun.uihelper.setTouchHandler(self.spriteBg_, handler(self, self.onAvatarClicked_))
    self.spriteOffline_:hide()

    local cls = self.table_
    local events = {
        {cls.MA_JIANG_HIGH_LIGHT, handler(self, self.onHighLight)},
    }
    gailun.EventUtils.create(self, self.table_, self, events)
end

function Player2DView:onFlwoEvent_(event)
    print("playerview onflow event "..event.flag)
    if event.flag ~= nil and event.flag ~= -1 then
        self.spriteZhuanquan_:show()
        -- transition.resumeTarget(self.spriteZhuanquan_)

    else
        self.spriteZhuanquan_:hide()
        -- transition.pauseTarget(self.spriteZhuanquan_)
    end
end

function Player2DView:onExit()
    gailun.EventUtils.clear(self)
end

function Player2DView:onHighLight(event)
   if event.name == self.table_.MA_JIANG_HIGH_LIGHT then
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
function Player2DView:showActionAnim_(spriteName,moveEnable,callback)
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

function Player2DView:onChuiEvent_(event)
    print("onChuiEvent_(event)"..event.isChui)
    if event.isChui == -1 then
        self.nodeChui_:hide()
            print("onChuiEvent_ hide nodechui")
        return
    end
    if event.isChui == 2 then            
        self.nodeChui_:show()      

        self:hideReay()
        print("onChuiEvent_ show nodechui")
        if event.isRecon or event.inFastMode then         
            return 
        end
        self:showActionAnim_("#bz_chui.png",true,function() self:showBottomFlag_(self.nodeChui_) end)
    elseif event.isChui == 1 then
        self.nodeChui_:hide()
        
        self:hideReay()
        print("onChuiEvent_ hide nodechui")

        if event.isRecon then return end
        if event.inFastMode then return end
        self:showActionAnim_("#bz_bu_chui.png")
    end
end

function Player2DView:onSitDownClicked_(event)
    self:dispatchEvent({name = Player2DView.SIT_DOWN_CLICKED})
end

function Player2DView:onSitDown(player)
    printInfo("Player2DView:onSitDown(player)")
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
        {cls.TAN_PAI_RESUME, handler(self, self.onTanPaiChanged_)},
        {cls.WAI_PAI_CHANGED, handler(self, self.onWaiPaiChanged_)},
        {cls.WAI_PAI_ADDED, handler(self, self.onWaiPaiAdded_)},
        {cls.TAN_PAI_ADDED, handler(self, self.onTanPaiAdded_)},
        {cls.CHU_PAI_CHANGED, handler(self, self.onChuPaiChanged_)},
        {cls.CHU_PAI_ADDED, handler(self, self.onChuPaiAdded_)},
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
        {cls.CHUI, handler(self, self.onChuiEvent_)},
        {cls.ON_RESET_PLAYER, handler(self, self.onResetPlayer_)},
        {cls.ON_FLOW_EVENT, handler(self, self.onFlwoEvent_)},  --ON_SHOWHEISAN_EVENT
        {cls.ON_TAN_PAI, handler(self, self.onTanPai_)},
        {cls.CHU_PAI_COUNT,handler(self,self.onChangeChuPaiCount_)},
        {cls.RESET_CARD_POS,handler(self,self.onRestCardPos_)},
        {cls.GANG_LOCK, handler(self, self.onGangLock_)},
        {cls.HIDE_PLAYER_INFO, handler(self, self.onHidePlayerInfo_)},
    }
  
    gailun.EventUtils.create(self, player, self, events)
    gameAudio.playSound("sounds/common/sound_enter.mp3")
    if self.player_ and self.player_:getIsChui() == 2 then
        self.nodeChui_:show()
        print("sitdown show  nodechui")
    else
        self.nodeChui_:hide()
        print("sitdown hide nodechui")
    end
end

function Player2DView:onHidePlayerInfo_()
    self.nodePlayer_:hide()
    self.spriteReady_:hide()
    self.nodeWaiPai_:hide()
    self.nodeMaJiangs_:hide()
end

function Player2DView:onGangLock_(event)
    self.isGangLocked_ = event.isLock or false
    if self.index_ == 1 then
        if self.isGangLocked_ then
            for k,v in pairs(self:getMaJiangs()) do
                if not v:isMoPai() then
                    v:setFixed(true)
                    v:doFixed_()
                end
            end
        else
            for k,v in pairs(self:getMaJiangs()) do
                if not v:isMoPai() then
                    v:setFixed(false)
                    v:doFixed_()
                end
            end
        end
    end
end

function Player2DView:onRestCardPos_()
    if self.beforeMJ then
        self.beforeMJ:setPositionY(self.rawY)
        self.beforeMJ = nil
    end
end

function Player2DView:onChangeChuPaiCount_(event)
    if event and event.chuPaiCount then
        self.cpLian = event.chuPaiCount
    end
end

function Player2DView:onTanPai_(event)
    local data = event.data
    if data.cards then

    end
    if data.huNameList then

    end
end

function Player2DView:onTanPaiChanged_(event)
    self.nodeTanPai_:removeAllChildren()
end

function Player2DView:onTanPaiAdded_(event)
    print("onTanPaiAdded_")
    if not event.data then
        printInfo("if not event.cards or 0 == #event.cards then")
        return
    end
    print(event.isReview)
    self:createTanPai_(event.data, event.index, event.isReview)
end

function Player2DView:createTanPai_(data, index, isReview)
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
    self:showHuType(huNameList, data.cards, self, isReview)
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

function Player2DView:showHuType(huList,cards,winner, isReview)
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

    local actionDelay1 = cc.DelayTime:create(3)
    table.insert(actions, actionDelay1)
    local sequence = transition.sequence(actions)
    self.nodeTanPai_:runAction(sequence)
end


function Player2DView:onSitDownEvent_(event)
    gameAudio.playSound("sounds/common/sound_enter.mp3")
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    -- self:setScoreWithRoller_(self.player_:getScore())
    local clockScore = display.getRunningScene():getLockScore()
    self.labelScore_:setString(self.player_:getScore()+clockScore)
    self:setVisible(true)
    self:stopZhuanQuanAction_()
end

function Player2DView:showReadyCommand_(event)
    print("showReadyCommand")
    if  event.isReady then
        self:showReayAnim()
    else
        self:hideReay()
    end
    
end
function Player2DView:showScoreChange_(event)
    
end

function Player2DView:onStandUp()
    gailun.EventUtils.clear(self)
    self.player_ = nil
    gameAudio.playSound("sounds/common/sound_left.mp3")
    self:setVisible(false)
end

function Player2DView:showOnline(data)
    local isOffline = (data.IP == nil)
    self.spriteOffline_:setVisible(isOffline)
    local str
    if not isOffline then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

function Player2DView:isHost()
    if self.player_ then
        return self.player_:getUid() == selfData:getUid()
    end
end

function Player2DView:onScoreChanged_(event)
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
    end
    if distScore ~= 0 then
        self:setScoreWithRoller_(event.score, event.from)
    end
end

function Player2DView:tanFenAnimation_(target)
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
function Player2DView:onBuGangEvent_(event)
    self:playActionAnim_(MJ_ACTIONS.BU_GANG)
end

function Player2DView:onWaiPaiChanged_(event)
    if not event.data or 0 == #event.data then
        self.nodeWaiPai_:removeAllChildren()
        return
    end
    for i,v in ipairs(event.data) do
        self:createWaiPai_(v, i)
    end
end

function Player2DView:createWaiPai_(data, index)
    assert(data.action and data.cards)
    for j, card in ipairs(data.cards) do
        local x, y = self:calcWaiPaiPos_(index, j)
        local showIndex = j
        if self.index_ == MJ_TABLE_DIRECTION.RIGHT and j < 4 then
            showIndex = -j - index * 10
        end
        if data.action == MJ_ACTIONS.AN_GANG and j < 4 then
            card = 0
        end
        local maJiang = app:createConcreteView("MaJiang2DView", card, self.index_, true):addTo(self.nodeWaiPai_, showIndex):pos(x, y)
        if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
            maJiang:scale(1.3)
            if card == 0 then
                maJiang:scale(1.3)
            end
        elseif self.index_ == MJ_TABLE_DIRECTION.TOP then
            maJiang:scale(0.8)
        end
    end
end

function Player2DView:onWaiPaiAdded_(event)
    if not event.data then
        printInfo("if not event.cards or 0 == #event.cards then")
        return
    end
    self:createWaiPai_(event.data, event.index)
    if not event.data.dennyAnim then
        self:playActionAnim_(event.data.action)
    end
end

function Player2DView:playActionAnim_(action)
    if MJ_ACTIONS.PENG == action then
        self:playPeng()
    elseif MJ_ACTIONS.CHI == action then
        self:playChi()
    elseif MJ_ACTIONS.ZI_MO == action then
        self:playZiMo()
    elseif MJ_ACTIONS.CHI_HU == action or action == MJ_ACTIONS.QIANG_GANG_HU then
        self:playFangPao(action)
    elseif MJ_ACTIONS.AN_GANG == action or MJ_ACTIONS.CHI_GANG == action or MJ_ACTIONS.BU_GANG == action then
        self:playGang(action)
    end
end

function Player2DView:calcWaiPaiPos_(index, offset)
    if MJ_TABLE_DIRECTION.BOTTOM == self.index_ then
        return self:calcWaiPaiPosBottom_(index, offset)
    elseif MJ_TABLE_DIRECTION.RIGHT == self.index_ then
        return self:calcWaiPaiPosRight_(index, offset)
    elseif MJ_TABLE_DIRECTION.TOP == self.index_ then
        return self:calcWaiPaiPosTop_(index, offset)
    else
        return self:calcWaiPaiPosLeft_(index, offset)
    end
end

function Player2DView:calcWaiPaiOffsetWidth_(width, offset)
    if offset < 4 then
        return (offset - 1) * width
    end
    return width
end

function Player2DView:calcWaiPaiOffsetHeight_(height, offset)
    if offset < 4 then
        return 0
    end
    return height / 3.8
end

function Player2DView:calcWaiPaiPosBottom_(index, offset)
    local majiang_height = 84
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local bottom_margin, mopai_space = 21, 40
    local startX = self:calcMaJiangBottomMargin_() + majiang_width / 2 + (index - 1) * (mopai_space + majiang_width * 3)
    local x = startX + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    local y = bottom_margin + majiang_height / 2 + self:calcWaiPaiOffsetHeight_(majiang_height, offset)
    return x, y
end

function Player2DView:calcWaiPaiPosRight_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local bottom_margin, wai_pai_space = 180, 20
    local x = display.width * (1114 / DESIGN_WIDTH) 
    local startY = bottom_margin + (index - 1) * (wai_pai_space + majiang_width * 3)
    local y = startY + self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

-- 390 890
function Player2DView:calcWaiPaiPosTop_(index, offset)
    local wai_pai_space = 20
    local majiang_height, majiang_width = 55, MA_JIANG_DAO_WIDTH[self.index_]
    local startX = display.width * 900 / DESIGN_WIDTH - (index - 1) * (wai_pai_space + majiang_width * 3)
    local x = startX - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    local y = display.height - 62 + self:calcWaiPaiOffsetHeight_(majiang_height, offset)
    return x, y
end

function Player2DView:calcWaiPaiPosLeft_(index, offset)
    local majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    local top_margin, wai_pai_space = 712, 16
    local x = display.width * (166 / DESIGN_WIDTH) 
    local startY = top_margin - (index - 1) * (wai_pai_space + majiang_width * 3) - 80
    local y = startY - self:calcWaiPaiOffsetWidth_(majiang_width, offset)
    return x, y + self:calcWaiPaiOffsetHeight_(majiang_width, offset)
end

function Player2DView:createChuPai_(card, total, index)
    local x, y, showIndex = self:calcChuPaiPos_(total, index)
    local nx, ny, _ = self:calcChuPaiPos_(total, index + 1)
    local maJiang = app:createConcreteView("MaJiang2DView", card, self.index_, true):addTo(self.nodeChuPai_, showIndex):pos(nx, ny)
    transition.moveTo(maJiang, {time = 0.2, x = x, y = y, easing = "Out"})
    maJiang:scale(1.2)
    return maJiang
end

function Player2DView:onChuPaiChanged_(event)
    self.nodeChuPai_:removeAllChildren()
    if not event.cards or 0 == #event.cards then
        printInfo("Player2DView:onChuPaiChanged_(event) with no cards")
        return
    end

    local tmpMJ = {}
    for i,v in ipairs(event.cards) do
        local MJ = self:createChuPai_(v, #event.cards, i)
        table.insert(tmpMJ, MJ)
    end
    self.reConnectLastMJ_ = tmpMJ[#tmpMJ]
end

function Player2DView:onChuPaiAdded_(event)
    if not event or not event.card then
        printInfo("Player2DView:onChuPaiAdded_(event) return with no event or card")
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

-- 出牌的动画
function Player2DView:showChuPaiAnim_(card)
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
    local obj = app:createConcreteView("MaJiang2DView", card, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeAnims_, -1)
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
function Player2DView:showActionAnim_(animName)
    local toX, toY = unpack(ACTION_ANIM_POS[self.index_])
    local action = 'play' .. string.ucfirst(animName)
    local obj = app:createConcreteView("game.ActionAnim"):addTo(self.nodeAnims_):pos(toX, toY)
    if obj[action] and type(obj[action]) == 'function' then
        obj[action](obj)
    end
end

function Player2DView:playZiMo()
    self:showActionAnim_("ziMo")
    gameAudio.playActionSound('zimo', self.player_:getSex())
end

function Player2DView:playChi()
    self:showActionAnim_("chi")
    gameAudio.playActionSound('chi', self.player_:getSex())
end

function Player2DView:playPeng()
    self:showActionAnim_("peng")
    gameAudio.playActionSound('peng', self.player_:getSex())
end

function Player2DView:playGang(action)
    if action == MJ_ACTIONS.AN_GANG then
        self:playGangAnimation_(false)
    else
        self:playGangAnimation_(true)
    end
    self:showActionAnim_("gang")
    gameAudio.playActionSound('gang', self.player_:getSex())
end

function Player2DView:playGangAnimation_(isMingG)

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

function Player2DView:playFangPao(action)
    local soundAction = "hu"
    if action == MJ_ACTIONS.ZI_MO then
        soundAction = "zimo"
    elseif action == MJ_ACTIONS.CHI_HU then
        if math.random(1, 100) < 50 then
            soundAction = "dianpao"
        end
    else
        soundAction = "qiangganghu"
    end
    self:showActionAnim_("hu")
    gameAudio.playActionSound(soundAction, self.player_:getSex())
end

function Player2DView:onHandCardRemoved_(event)
    print("Player2DView onHandCardRemoved_"..event.card)
    self:removeHandMaJiang_(event.card)
end

function Player2DView:getRemoveMaJiang_(card)
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

function Player2DView:removeHandMaJiang_(card)
    local obj = self:getRemoveMaJiang_(card)
    if obj then
        obj:removeFromParent()
    end
end

function Player2DView:getLastChuPaiPos()
    local nodes = self.nodeChuPai_:getChildren()
    if not nodes or #nodes < 1 then
        return self:calcChuPaiPos_(1, 1)
    end
    return self:calcChuPaiPos_(#nodes, #nodes)
end

function Player2DView:calcChuPaiPos_(total, index)
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

function Player2DView:calcChuPaiPosBottom_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_] 
    local x = (display.width - majiang_width * self.cpLian) / 2 + (index - 1) % self.cpLian * majiang_width + 19
    local y = display.height * 300 / DESIGN_HEIGHT + math.floor((index - 1) / self.cpLian) * 55 - 130+20
    return x, y, -index
end

function Player2DView:calcChuPaiPosRight_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local x = display.width * 935 / DESIGN_WIDTH - math.floor((index - 1) / self.cpLian) * 55+120-20
    local y = (display.height - majiang_width * self.cpLian) / 2 + (index - 1) % self.cpLian * majiang_width + 44
    return x, y, -index
end

-- 390 890
function Player2DView:calcChuPaiPosTop_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local x = display.width - (display.width - majiang_width * self.cpLian) / 2 - (index - 1) % self.cpLian * majiang_width - 30
    local y = display.height * (display.height - 250) / DESIGN_HEIGHT - math.floor((index - 1) / self.cpLian) * 55 +120-20
    return x, y, index
end

function Player2DView:calcChuPaiPosLeft_(total, index)
    local majiang_width = MA_JIANG_CHU_WIDTH[self.index_]
    local isAdd = false
    local x = display.width * 340 / DESIGN_WIDTH + math.floor((index - 1) / self.cpLian) * 55  -120+20
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

function Player2DView:onWinWithCtype(ctype)
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
function Player2DView:calcMaxWidthValues_(nodes)
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

function Player2DView:calcMaJiangBottomMargin_()
    local width = MA_JIANG_SHU_WIDTH[MJ_TABLE_DIRECTION.BOTTOM] * MA_JIANG_BOTTOM_SCALE
    local total_width = (width * 14 + MO_PAI_MARGIN_BOTTOM * MA_JIANG_BOTTOM_SCALE)
    local margin = (display.width - total_width) / 2
    if margin >= 0 then
        return margin
    end
    MA_JIANG_BOTTOM_SCALE = MA_JIANG_BOTTOM_SCALE * 0.9
    return self:calcMaJiangBottomMargin_()
end

function Player2DView:calcWaiPaiWidth_()
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
            return 722
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
        return minY - width /2+70
    end
end

function Player2DView:calcMaJiangPosBottom_(total, index, isDown)
    local majiang_height = 125
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]

    local wai_width = self:calcWaiPaiWidth_()+30
    majiang_width = majiang_width * MA_JIANG_BOTTOM_SCALE
    majiang_height = majiang_height * MA_JIANG_BOTTOM_SCALE

    local bottom_margin, wai_pai_space = 16, 0
    if wai_width > 30 then  -- 如果左右间距大于此值，则可以设置一点外牌与手牌的间距
        wai_pai_space = 20
    end
    local x = wai_width + wai_pai_space + (index - 1) * majiang_width + majiang_width / 2 -40
    local y = bottom_margin + majiang_height / 2
    return x, y, 0
end

function Player2DView:calcMaJiangPosRight_(total, index, isDown)
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
    if isDown then
        majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    end
    local bottom_margin = 216
    local x = display.width * (1114 / DESIGN_WIDTH)
    local y = self:calcWaiPaiWidth_() + 22 + (index - 1) * majiang_width + majiang_width / 2 + 20
    return x, y, -index
end

-- 390 890
function Player2DView:calcMaJiangPosTop_(total, index, isDown, isHand)
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
    local y = display.height - 62
    return x, y, 0
end

function Player2DView:calcMaJiangPosLeft_(total, index, isDown)
    local majiang_width = MA_JIANG_SHU_WIDTH[self.index_]
    if isDown then
        majiang_width = MA_JIANG_DAO_WIDTH[self.index_]
    end
    local top_margin = 622
    local x = display.width * (166 / DESIGN_WIDTH)
    local y = self:calcWaiPaiWidth_() - (index - 1) * majiang_width - 10 - majiang_width / 2 - 100
    return x, y, index
end

function Player2DView:calcMaJiangPos_(total, index, isDown, isHand)
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

function Player2DView:adjustMaJiangWithoutMoPai(isDown)
    self:performWithDelay(function ()
        self:doAdjustHandCards_(false, isDown)
    end, 0.05)
end

function Player2DView:adjustMaJiang(isDown)
    self:performWithDelay(function ()
        self:doAdjustHandCards_(true, isDown)
    end, 0.05)
end

function Player2DView:getMaJiangNode_()
    if self:isHost() then
        return  self.nodeMaJiangsHost_
    end
    return self.nodeMaJiangs_
end

function Player2DView:doAdjustHandCards_(includeMoPai, isDown)
    print("doAdjustHandCards_1")
    self.inAdjustMaJiang_ = true
    local includeMoPai = includeMoPai or false
    local nodes = self:getMaJiangNode_():getChildren()
    if not nodes or table.nums(nodes) < 1 then
        self.inAdjustMaJiang_ = false
        return
    end
        print("doAdjustHandCards_2")

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
        local withLizi = true
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
        print("doAdjustHandCards_3")

    local index = 1
    for _,v in ipairs(nodes) do
        if not v:isMoPai() or includeMoPai then
            transition.stopTarget(v)
            local x, y, z = self:calcMaJiangPos_(count, index, isDown, true)
            v:setLocalZOrder(z)
            if self.isGangLocked_ then
                v:setFixed(true)     
            else
                v:setFixed(false)
            end
            v:doFixed_()
            transition.moveTo(v, {time = 0.2, x = x, y = y, easing = "Out", onComplete = function ()
                self.inAdjustMaJiang_ = false
            end})
            index = index + 1
        end
    end
    self:performWithDelay(function()
        self:updateTingPaiTag()
        self.inAdjustMaJiang_ = false
        end, 0.5)
end

function Player2DView:showMaJiangsDirectly_(cards, isDown)
    local showCards = clone(cards)
    local withLizi = true
    BaseAlgorithm.sort(showCards, withLizi)
    for i,v in ipairs(showCards) do
        local x, y, z = self:calcMaJiangPos_(#showCards, i, isDown)
        self:createMaJiangWithTouch_(v, i, x, y, z, isDown)
    end
end

function Player2DView:createMaJiangWithTouch_(card, index, x, y, z, isDown, isMoPai)
    local node = self:getMaJiangNode_()
    local isDown = isDown or false
    local isMax = false
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        if not card or 0 == card then
            isDown = true
            isMax = true
        end
    end
    local maJiang = app:createConcreteView("MaJiang2DView", card, self.index_, isDown, isMax):addTo(node, z):pos(x,y)
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
        if self.index_ ~= MJ_TABLE_DIRECTION.BOTTOM then
            maJiang:scale(1.52)
        else
            maJiang:scale(MA_JIANG_BOTTOM_SCALE*2.2)
        end
        return
    end
    if not card or 0 == card then
        return
    end

    maJiang:scale(MA_JIANG_BOTTOM_SCALE*1.14)
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

function Player2DView:onMaJiangTouchEnded_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end

    if self.inAdjustMaJiang_ then
        return
    end
    if not maJiang.rawX and not maJiang.rawY then
        return
    end
    maJiang:show()

    if self.tMJ_ then
        self.tMJ_:removeSelf()
        self.tMJ_ = nil
        maJiang:clearMaJiangMask()
    end
  
    if self:canChuPai_() then  
        if self.beforeMJ and self.beforeMJ == maJiang then
            return self:onMaJiangChuAction_(maJiang)
        end
    end
    self.beforeMJ = maJiang
    self.selectMaJiang = maJiang
    if event.y > display.height * 135 / DESIGN_HEIGHT then  -- 拖出了界面
        if not self:canChuPai_() then
            self:resetMaJiangAfterTouch_(maJiang)
            return
        else
            return self:onMaJiangChuAction_(maJiang)
        end
    end
    local clickTime = os.time() + os.clock()
    if maJiang.clickTime_ and
        maJiang.clickTime_ > 0 and
        clickTime - maJiang.clickTime_ < 0.6 then
            if not self:canChuPai_() then
                self:resetMaJiangAfterTouch_(maJiang)
                return
            else
                return self:onMaJiangChuAction_(maJiang)
            end
    end
    maJiang.clickTime_ = clickTime
    self:resetMaJiangAfterTouch_(maJiang)
    if self:canChuPai_() then
        local card = maJiang:getMaJiang()

        local tableController = display.getRunningScene().tableController_
        local hostPlayer = tableController:getHostPlayer()

        local seats = tableController:getSeats()
        local handCards = {}
        local waiCards = {}
        local zhuoCards = {{card}}
        for k, v in pairs(seats) do
            if v:isHost() then
                selfHandCards = clone(v:getCards())
            end
            table.insert(handCards, v:getCards() or {})
            table.insert(waiCards, v:getWaiPai() or {})
            table.insert(zhuoCards, v:getOutCards() or {})
        end

        local nowCards = hostPlayer:getCards()
        table.removebyvalue(nowCards, card)

        local remainCards = ZZAlgorithm.getRemainCards(handCards, zhuoCards, waiCards)
        local tingPai = ZZAlgorithm.getTingPai(remainCards, 
            nowCards, 
            display.getRunningScene():getTable():getAllowSevenPairs())
        if self.selectMaJiang and self.selectMaJiang ~= maJiang then
            if self.selectMaJiang.isSelct then
                self.selectMaJiang:setPositionY(self.selectMaJiang:getPositionY()-20)
                self.selectMaJiang.isSelct = nil
            end
            local tingView = self.runScene:getChildByName("playerTingView")
            if tingView ~= nil then
                tingView:removeFromParent()
            end
        end
        if #table.values(tingPai) ~= 0 then
            local tingView = self.runScene:getChildByName("playerTingView")
            if tingView ~= nil then
                tingView:removeFromParent()
            end
            local tingView = TingView.new()
            tingView:setName("playerTingView")
            tingView:setCards(tingPai)

            local majiangPos = cc.p(maJiang:getPosition())
            tingView:setPosition(display.cx-600,-120)
            self.runScene:addChild(tingView, 9999)
        end
    end
end

function Player2DView:canChuPai_()
    if display.getRunningScene():getTable():getInPublicTime() then  -- 公共牌时间不允许出牌
        print("NO 11111")
        return false
    end
    if not display.getRunningScene():getTable():isMyTurn(self.player_:getSeatID()) then
        print("NO 22222")
        return false
    end
    return true
end

function Player2DView:onMaJiangChuAction_(maJiang)
    local card = maJiang:getMaJiang()
    if not self:canChuPai_() then  -- 公共牌时间不允许出牌
        return self:resetMaJiangAfterTouch_(maJiang)
    end

    if self.table_:getMaJiangType() == 1 and BaseAlgorithm.isNaiZi(card) then
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

    dataCenter:sendOverSocket(COMMANDS.HZMJ_CHU_PAI, {
        cards = card
    })
    local allowSevenPairs = display.getRunningScene():getTable():getAllowSevenPairs()
    if self.player_:canZiMoHu(allowSevenPairs) then
        self.player_:addLouHu(card)
    end
    gameAudio.playSound("sounds/common/sound_card_out.mp3")
    self.table_:setMaJiangLight(card, false)

    display.getRunningScene():getTable():clearCurrSeatID()
    -- self:resetMaJiangAfterTouch_(maJiang)

    local tingView = self.runScene:getChildByName("playerTingView")
    if tingView ~= nil then
        tingView:removeFromParent()
    end
    self.beforeMJ = nil
end

function Player2DView:resetMaJiangAfterTouch_(maJiang)
    local x, y = maJiang:getPosition()
    local dis = gailun.utils.distance(cc.p(x, y), cc.p(maJiang.rawX, maJiang.rawY))
    local move
    if dis < 10 then
        maJiang:pos(maJiang.rawX, self.rawY+20)
    else
        maJiang.select = true
        maJiang:pos(maJiang.rawX, maJiang.rawY)
    end
    local actions = transition.sequence({
        cc.CallFunc:create(function ()
            maJiang:setTouchEnabled(false)
        end),
        cc.CallFunc:create(function ()
            maJiang:setTouchEnabled(true)
            if maJiang.rawZOrder_ then
                maJiang:setLocalZOrder(maJiang.rawZOrder_)
            end
        end),
    })
    maJiang:runAction(actions)
    local card = maJiang:getMaJiang()

    self.table_:setMaJiangLight(card,false)
end

function Player2DView:onMaJiangTouchdBegin_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end
    if self.inAdjustMaJiang_ then
        print("not inAdjustMaJiang_")
        return
    end
    local card = maJiang:getMaJiang()
    local x = maJiang:getPositionX()
    local y = maJiang:getPositionY()
    maJiang:setMaJiangMask()
    maJiang:hide()
    self.tMJ_ = app:createConcreteView("MaJiang2DView", card, self.index_, false, true):addTo(maJiang:getParent())
    maJiang.rawZOrder_ = maJiang:getLocalZOrder()
    maJiang:setLocalZOrder(100)
    if not self.rawY then
        self.rawY = maJiang:getPositionY()
    else
        if self.beforeMJ and self.beforeMJ ~= maJiang then
            self.beforeMJ:setPositionY(self.rawY)
        end
    end 
    maJiang:setPositionY(self.rawY+20)
    self.rawX = maJiang:getPositionX()
    maJiang.rawX, maJiang.rawY = maJiang:getPosition()
    self.table_:setMaJiangLight(card,true)
    if self.tMJ_ then
        self.tMJ_:setPosition(x, self.rawY+20)
    end
    gameAudio.playSound("sounds/common/sound_card_click.mp3")
end

function Player2DView:onMaJiangTouchMove_(maJiang, event)
    if maJiang:isBeOut() then
        return
    end

    if self.inAdjustMaJiang_ then
        return
    end

    if not maJiang.rawX and not maJiang.rawY then
        return
    end

    local width = MA_JIANG_SHU_WIDTH[MJ_TABLE_DIRECTION.BOTTOM]
    local x, y = event.x, event.y
    x = math.max(width / 2, x)
    x = math.min(display.width - width / 2, x)
    local height = 125
    y = math.max(self.rawY+20, y)
    y = math.min(display.height - height / 2, y)
    maJiang:pos(x, y)
    if y > self.rawY+50 then
        maJiang:show()
    end 
end

function Player2DView:getPlayerPosition()
    local index = self.index_
    assert(index > 0 and index < 10)
    return unpack(OFFSET_OF_SEATS_4[index])
end

-- cc.BezierTo:create(time，{cc.p(x, y), cc.p(x1, y1), cc.p(x2, y2)})
-- TODO: 贝塞尔曲线运动
function Player2DView:adjustSeatPos_(index, withAction)
    self:initPosByIndex_()
    local moveTime = 0.5
    local x, y = self:getPlayerPosition()
    if withAction then
        transition.moveTo(self.nodePlayer_, {x = x, y = y, time = moveTime, easing = "exponentialOut"})
    else
        self.nodePlayer_:pos(x, y)
    end
end

function Player2DView:onIndexChanged_(event)
    self.index_ = event.index
    self:adjustSeatPos_(self.index_, event.withAction)
    self:adjustReady_()
end

function Player2DView:removeMaJiangs_()
    self:getMaJiangNode_():removeAllChildren()
end

function Player2DView:calcPokerOffsetX_(isHost)
    if isHost then
        return HOST_OFFSET_X
    else
        return PLAYER_OFFSET_X
    end
end

function Player2DView:filterMaJiangs(cards5)
    local majiangs = self:getMaJiangs()
    for _,v in pairs(checktable(majiangs)) do
        if false == table.indexof(cards5, v:getPoker()) then
            v:lowLight()
        else
            v:highLight()
        end
    end
end

function Player2DView:getMaJiangs()
    local node = self:getMaJiangNode_()
    return node:getChildren()
end

function Player2DView:showHostHandCards_()
    if not self:isHost() then
        return
    end

    local majiangs = self:getMaJiangs()
    for _,v in pairs(checktable(majiangs)) do
        transition.rotateTo(v, {rotate = 0, time = 0.2})
    end
end

function Player2DView:onHandCardsChanged_(event)
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

function Player2DView:calcMoPaiPos_(isDown)
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
        y = y + MO_PAI_MARGIN_OTHER+15
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
    elseif self.index_ == MJ_TABLE_DIRECTION.LEFT then
        z = maxZ + 1
        x = x + 5
    end
    return x, y, z
end

function Player2DView:onMaJiangFound_(event)
    local card = event.card
    local isDown = event.isDown or false
    self.beforeMJ = nil
    local x, y, z = self:calcMoPaiPos_(isDown)
    self:setAllNotMoPai_()
    self:createMaJiangWithTouch_(card, #self.player_:getCards(), x, y, z, isDown, true)
    gameAudio.playSound("sounds/common/sound_deal_card.mp3")
    self:performWithDelay(function()
        self:updateTingPaiTag()
    end,0.5)
end

function Player2DView:setAllNotMoPai_()
    local nodes = self:getMaJiangNode_():getChildren()
    for _,v in pairs(nodes) do
        v:setIsMoPai(false)
    end
end

function Player2DView:onAvatarClicked_(event)
    if not self.player_ then
        printInfo("if not self.player_ then")
        self:dispatchEvent({name = Player2DView.ON_AVATAR_CLICKED, params = {isInvite = true}})
        return
    end

    local info = self.player_:getShowParams()
    info.x = display.cx
    info.y = display.cy
    info.seatID = self.player_:getSeatID()

    self:dispatchEvent({name = Player2DView.ON_AVATAR_CLICKED, params = info})
end

function Player2DView:setScoreWithRoller_(score, fromScore)
    local clockScore = display.getRunningScene():getLockScore()
    NumberRoller:run(self.labelScore_, fromScore+clockScore, score+clockScore)
end

function Player2DView:setScore(score)
    NumberRoller:run(self.labelScore_, score, score)
end

function Player2DView:setNickName(name)
    self.labelNickName_:setString(name)
end

function Player2DView:setPlayerChildrenVisible(flag)
    local children = self.nodePlayer_:getChildren()
    local visible = self.spriteZhuanquan_:isVisible()
    local visible1 = self.voiceQiPao_:isVisible()
    for _,v in pairs(children) do
        if v ~= self.spriteOffline_ 
            and v ~= self.tanFenAdd_ 
            and v ~= self.tanFenDel_
            then
            v:setVisible(flag or false)
        end
    end
    self.tanFenAdd_:setVisible(visible1)
    self.tanFenDel_:setVisible(visible1)
    self.spriteZhuanquan_:setVisible(visible) -- 转圈
    local visible1 = self.voiceQiPao_:setVisible(visible1)
    -- self.buttonInvite_:hide()
end

function Player2DView:clearAllMaJiangs_()
    self:getMaJiangNode_():removeAllChildren()
    self.nodeChuPai_:removeAllChildren()
    self.nodeWaiPai_:removeAllChildren()
    self.nodeTanPai_:removeAllChildren()
    self.isGangLocked_ = false
end

------------- 一系列的响应状态变化而改变view的函数，下划线后面都是player model里面的状态 ---------------
function Player2DView:onPlayStateChanged_(opacity)
    if opacity and opacity >= 0 and opacity <= 255 then
        self:setOpacity(opacity)
    end
    self:setPlayerChildrenVisible(true)
end

function Player2DView:onStateIdle_(event)
    self:setPlayerChildrenVisible(false)
    -- self.buttonInvite_:show()
    self:setOpacity(255)
    self.spriteBg_:show()
    self:clearAllMaJiangs_()
    self:hideReay()
end

function Player2DView:onStateReady_(event)
    self:clearAllMaJiangs_()
    print("stage Readdy")
    self:showReady_()
    gameAudio.playSound("sounds/common/sound_ready.mp3")
end

function Player2DView:showReady_()
    self:showReayAnim()
    self:adjustReady_()
    self.isGangLocked_ = false
end

function Player2DView:onResetPlayer_()
    print("playview reset player")
    self:hideReay()
    self.nodeChui_:hide()
    self.isGangLocked_ = false
end

function Player2DView:adjustReady_()
    local x, y = unpack(ready_pos[self.index_])
    self.spriteReady_:pos(x, y)
end

function Player2DView:onStateWaiting_(event)
    self:onStateWaitNext_()
    -- self:setScoreWithRoller_(self.player_:getScore())
    self:hideReay()
end
function Player2DView:hideReay()
    self.spriteReady_:hide()
    self.spriteReady_:stopAllActions()
end

function Player2DView:onStateWaitNext_(event)
    self:onPlayStateChanged_(255)
    self.avatar_:showWithUrl(self.player_:getAvatarName())
    self:setNickName(self.player_:getNickName())
    self:clearAllMaJiangs_()
    self:hideReay()
end

function Player2DView:onStateWaitCall_(event)
    self:onPlayStateChanged_(nil, 255)
    self.isCtypeShowDown_ = false
    self:hideReay()
end

function Player2DView:onStateThinking_(event)
    self:onPlayStateChanged_(255)
    self:hideReay()
    local seconds = checknumber(event.args[1])
    if self:isHost() then
        gameAudio.playSound("turnto.mp3")
    end
end

function Player2DView:onStateChanged_(event)
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

function Player2DView:focusOn_(maJiang, index)
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

    self.table_:setFocusOn(posX, posY)
end

function Player2DView:onReconnectOn_(event)
    -- dump(self.reConnectLastMJ_ , "onReconnectOn_")
    if self.reConnectLastMJ_ then
        self:focusOn_(self.reConnectLastMJ_)
    end
end

function Player2DView:updateTingPaiTag(card)
    if not self:isHost() then
        return
    end

    local waiPai = self.player_:getWaiPai()
    local handCards = self.player_:getCards()

    if card ~= nil and card ~= 0 then
        table.insert(handCards, card)
    end

    local configData = display.getRunningScene():getTable():getConfigData()
    local allowSevenPairs = display.getRunningScene():getTable():getAllowSevenPairs()
    if ZZAlgorithm.canZiMoHu(handCards, allowSevenPairs) then
        self.tingPaiMap = {}
    else
        self.tingPaiMap = gailun.utils.invert(ZZAlgorithm.getTingOperate(handCards,display.getRunningScene():getTable():getAllowSevenPairs()))
    end

    local nodes = self:getMaJiangNode_():getChildren()
    
    for _, v in pairs(nodes) do
        if not v:isDown() then
            v:setTingTag(self.tingPaiMap[v:getCard()] ~= nil)
        end
    end
end

function Player2DView:initTiShiAnimation_()
    local animaData = FaceAnimationsData.getCocosAnimation(6)
    gameAnim.createCocosAnimations(animaData, self.spriteZhuanquan_)
    self.spriteZhuanquan_:hide()
end

function Player2DView:zhuanQuanAction_(event)
    self.spriteZhuanquan_:show()

end

function Player2DView:stopZhuanQuanAction_(event)
    self.spriteZhuanquan_:hide()
end

function Player2DView:onPlayerVoice_(event)
    self.voiceQiPao_:playVoiceAnim(event.time)
end

function Player2DView:onStopRecordVoice_(event)
    self.voiceQiPao_:stopRecordVoice()
end

function Player2DView:initPosByIndex_()
    local qiPaoX = QI_PAO_X
    local tanFenX = 100
    if self.index_ == MJ_TABLE_DIRECTION.BOTTOM then
        self.voiceQiPao_:setFlipX(false)
        self.voiceQiPao_:setPositionX(qiPaoX) 
        self.tanFenAdd_:setPositionX(tanFenX)
        self.tanFenDel_:setPositionX(tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.LEFT then
        self.voiceQiPao_:setFlipX(false)
        self.voiceQiPao_:setPositionX(qiPaoX) 
        self.tanFenAdd_:setPositionX(tanFenX)
        self.tanFenDel_:setPositionX(tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.RIGHT then
        qiPaoX = - QI_PAO_X
        self.voiceQiPao_:setPositionX(qiPaoX)
        self.voiceQiPao_:setFlipX(true)
        self.tanFenAdd_:setPositionX(-tanFenX)
        self.tanFenDel_:setPositionX(-tanFenX)
    elseif self.index_ == MJ_TABLE_DIRECTION.TOP then
        self.tanFenAdd_:setPositionX(-tanFenX)
        self.tanFenDel_:setPositionX(-tanFenX)
    end
    self.tanFenDel_:setPositionY(-10)
end

function Player2DView:onOfflineEvent_(event)
    self.spriteOffline_:setVisible(event.offline)
    if not event.offline and event.isChanged then
        local str = string.format("%s回来了。", self.player_:getNickName())
        app:showTips(str)
    end
end

------------- 响应状态变化函数段结束 ------------------------------------------------------------

return Player2DView
