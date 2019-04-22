local BaseAlgorithm = require("app.games.sybp.utils.BaseAlgorithm")
local PaperCardGroup = require("app.games.sybp.utils.PaperCardGroup")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local DebugView = require("app.games.DebugView")
local testData = require("app.games.sybp.data.test")

local HuangAnim = require("app.games.sybp.views.HuangAnim")
local TYPES = gailun.TYPES
local tableNodes = {}
tableNodes.normal = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            {type = TYPES.SPRITE, var = "imgleftCards_", filename = "res/images/paohuzi/game/phz_comm_lastcard4.png", x = display.cx , y = display.height - 120, ap = {0.5, 0.5}},
            {type = TYPES.BM_FONT_LABEL, var = "labelLeftCards_", options={text="", UILabelType = 1,font = "fonts/pjx.fnt",}, x = display.cx , y = display.height - 90, ap = {0.5, 0.5}},
        }},
        {type = TYPES.NODE, var = "nodePublicPokers_", children = {  -- 桌子信息容器
             }}, --公共牌容器
        {type = TYPES.LABEL, var = "ruleInfo_", x = 0, y = 0,opacity = 60, options = {text="", size=25, font = DEFAULT_FONT, color=cc.c3b(0, 0, 0)}, ap = {0.5, 0.5},x = display.cx, y =  display.cy+60},
        {type = TYPES.LABEL, var = "timeTips_", x = 0, y = 0, options = {text="", size=25, font = DEFAULT_FONT, color=cc.c3b(255, 255, 255)}, ap = {0.5, 0.5}},
        {type = TYPES.SPRITE, var = "spriteDealer_", filename = "res/images/game/flag_zhuang.png", px = 0.086, py = 0.42},
        {type = TYPES.SPRITE, var = "nodeFaPai1_"}, -- 发牌容器
        {type = TYPES.SPRITE, var = "nodeFaPai2_"}, -- 发牌容器
        {type = TYPES.SPRITE, var = "nodeFaPai3_"}, -- 发牌容器 
        {type = TYPES.NODE, var = "nodePlayers_",}, --玩家容器
       
        {type = TYPES.CUSTOM, var = "directorController_", class = "app.games.sybp.controllers.DirectorController"},
        {type = TYPES.NODE, var = "nodeChat1_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat2_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat3_"}, -- 玩家3聊天气泡容器
        {type = TYPES.SPRITE, var = "nodeMoPaiDaPai_"}, -- 发牌容器 
        {type = TYPES.NODE, var = "nodeHandPaper_",}, --玩家容器
        {type = TYPES.NODE, var = "nodeAnim_"}, -- 打牌动画容器
        {type = TYPES.SPRITE, var = "nodeRoundOver_"}, -- 结束展示
        {type = TYPES.NODE, var = "nodeFaceAnim_"}, -- 表情动画容器
        {type = TYPES.SPRITE, var = "showHuCard_", filename = "res/images/cdphz/tip/tip.png",ap = {0,1}, x = display.fixLeft+90, y =  display.cy+80},
        {type = TYPES.SPRITE, var = "showHuCardBg_", filename = "res/images/cdphz/tip/tipBg.png",ap = {0,1}, x = display.fixLeft-10, y =  display.cy+30},
        {type = TYPES.NODE, var = "showHuCardNode_",x = display.fixLeft+90, y =  display.cy-40}, 
        {type = TYPES.CUSTOM, var = "progressView_", class = "app.games.sybp.views.game.ProgressView"}, -- 主玩家的手牌容器，需要最高等级的显示

    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatString(POOL_PREFIX)
NumberRoller:setFormatHandler(gailun.utils.formatChips)

local POSITION_OF_DEALER_4 = {
    {-35, 35},
    {35, 35},
    {35, 35},
}

local countPerLine, perWidth, perHeight = 10, 60, 80

local player_pos_adjusty = 90
local player_pos_adjustx = 160
local player_pos = {
    {player_pos_adjustx, display.bottom + player_pos_adjusty},
    {display.width - player_pos_adjustx, display.height - player_pos_adjusty},
    {player_pos_adjustx, display.height - player_pos_adjusty},
}

local PUBLIC_CARD_SPACE = 68  -- 公共牌间距
local PASS_POINT_Y = 750

local alarm_pos_adjustx = 50
local alarm_pos_adjusty = 100

local ALARM_POSITION = {
    {player_pos[1][1] + alarm_pos_adjustx-30, player_pos[1][2] - alarm_pos_adjusty+145},
    {player_pos[2][1] - alarm_pos_adjustx-90, player_pos[2][2] - alarm_pos_adjusty+145},
    {player_pos[3][1] + alarm_pos_adjustx+90, player_pos[3][2] - alarm_pos_adjusty+145},
}

local OUT_CARD_POSITION = {
    {display.cx, display.cy+120},
    {player_pos[2][1] - alarm_pos_adjustx+40, player_pos[2][2] - alarm_pos_adjusty+100},
    {player_pos[3][1] + alarm_pos_adjustx-50, player_pos[3][2] - alarm_pos_adjusty+100},
}

local TIME_TIP_POSITION = {
    {display.cx,display.cy+30},
    {display.cx,display.cy+180},
    {display.cx,display.cy+180},
}

local TIME_TIP_FONT = {
    "计时结束,赶紧操作","对方可能暂时离开,等待对方操作中...","对方可能暂时离开,等待对方操作中..."
}

local mopai_pos_adjustx = 300
local mopai_pos_adjusty = 180
local cur_card_pos = 
{
    {display.cx, display.cy+25},
    {player_pos[2][1] - mopai_pos_adjustx+120, display.height - mopai_pos_adjusty-160},
    {player_pos[3][1] + mopai_pos_adjustx-120, display.height - mopai_pos_adjusty-160}
}

local TableView = class("TableView", gailun.BaseView)

local PuPingCardList = import("app.games.sybp.views.pingPu.PaperCardList")
local ShanXingCardList = import("app.games.sybp.views.shanXing.PaperCardList")
-- "app.games.sybp.views.pingPu.PaperCardList"
local paiXingList = {}
paiXingList[1] = PuPingCardList
paiXingList[2] = ShanXingCardList
function TableView:ctor(table)
    -- display.addSpriteFrames("textures/hall.plist", "textures/hall.png")
    -- :setOpacity(opacity)
    self.table_ = table
    local data = tableNodes.normal
    gailun.uihelper.render(self, data)
    self.nodeHostMaJiang_ = paiXingList[setData:getCDPHZCardLayout()].new():addTo(self.nodeHandPaper_, 100)
    self:showByTableState_({to = self.table_:getState()})
    self.downCount_ = 0
    self.labelLeftCards_:setVisible(false)
    self.imgleftCards_:setVisible(false)
    self.roundindx = ""
    self.showHuCardBg_:setVisible(false)
    self.showHuCard_:setVisible(false)
    self.timeTips_:setString("")
    self.showHuCardBg_:setScale(0.8,1.3)
    self.showHuCardNode_:setScale(0.8)
    self.directorController_:setTimeOverFunc(handler(self, self.showTimeTip))

    local debugView = DebugView.new(COMMANDS.SYBP_DEBUG_CONFIG_CARD, testData)
    debugView:setPosition(display.right - 200, display.top - 100)
    self:addChild(debugView,100)
end

function TableView:onEnter()
    printInfo("TableView:onEnter()")
    local cls = self.table_.class
    local handlers = {
      {cls.CHANGE_STATE_EVENT, handler(self, self.onStateChanged_)},
        {cls.DEALER_FOUND, handler(self, self.onDealerChanged_)},   
        {cls.CONFIG_CHANGED, handler(self, self.onRoomConfigChanged_)},
        {cls.TURN_TO_EVENT, handler(self, self.onTurnToEvent_)},
        {cls.TABLE_CHANGED, handler(self, self.onTableChanged_)},
        {cls.CARDSNUM_CHANGED, handler(self, self.onCardsNumChanged_)},
        {cls.ROUND_OVER_EVENT, handler(self, self.onRoundOverEvent_)},
        {cls.ROUND_START_EVENT, handler(self, self.onRoundStartEvent_)},
        {cls.FINISH_ROUND_CHANGED, handler(self, self.onFinishRoundChanged_)}, 
        {cls.GOLD_FLY_EVENT, handler(self, self.onGoldFlyEvent_)}, 
        {cls.CURR_CARD_CHANGE, handler(self, self.onCurrCardChange_)}, 
        {cls.CURR_CARD_FAGUANG, handler(self, self.onCurrCardFaGuang_)},
        {cls.SHOW_DI_PAI, handler(self, self.onShowDiPai_)},
        {cls.SHOW_HAND_PAI,handler(self, self.onShowHandPai_)},
        {cls.CLEAR_ROUND_OVER_SHOW_PAI,handler(self,self.onClearRoundOverShowPai_)},
        {cls.SHOW_HUANGZHUANG,handler(self,self.onShowHuangZhuang_)},
        {cls.RESET_ROUND_TABLE,handler(self,self.onRoundReset_)},
        {cls.TABLE_BG_CHANGE,handler(self,self.doChangeTableBg_)},
        {cls.HXTS,handler(self,self.doHXTS_)},
        {cls.TPTS,handler(self,self.doTPTS_)},
        {cls.CARD_TYPE,handler(self,self.doChangeCardType_)},
        {cls.CARD_LAYOUT,handler(self,self.doChangeLayout_)},
        {cls.SHOW_HU_CARD,handler(self,self.doShowHuCard_)},

        -- 回放
        {cls.REVIEW_HAND_CARDS, handler(self, self.onReviewHandCards_)},
        {cls.REVIEW_CHU, handler(self, self.onReviewChu_)},
        {cls.REVIEW_CHI, handler(self, self.onReviewChi_)},
        {cls.REVIEW_PENG, handler(self, self.onReviewPeng_)},
        {cls.REVIEW_WEI, handler(self, self.onReviewWei_)},
        {cls.REVIEW_PAO, handler(self, self.onReviewPao_)},
        {cls.REVIEW_TI, handler(self, self.onReviewTi_)},
        {cls.REVIEW_SHOUZHANG, handler(self, self.onReviewShouZhang_)},
        -- 回放
    }
    gailun.EventUtils.create(self, self.table_, self, handlers)

    self:showByTableState_({to = self.table_:getState()})
    -- self:updateTableID_(self.table_:getTid())
end

local curCardPos = {
    {400, 817 * display.height /DESIGN_HEIGHT },
    {500, 1017 * display.height /DESIGN_HEIGHT },
    {300, 1017 * display.height /DESIGN_HEIGHT },
}

function TableView:resetPos()
    ALARM_POSITION = {
        {player_pos[1][1] + alarm_pos_adjustx-120, player_pos[1][2] - alarm_pos_adjusty+100},
        {player_pos[2][1] - alarm_pos_adjustx-90, player_pos[2][2] - alarm_pos_adjusty+145},
        {player_pos[3][1] + alarm_pos_adjustx+90, player_pos[3][2] - alarm_pos_adjusty+145},
    }
    OUT_CARD_POSITION = {
        {display.cx, display.cy+120},
        {player_pos[2][1] - alarm_pos_adjustx+40, player_pos[2][2] - alarm_pos_adjusty+100},
        {player_pos[3][1] + alarm_pos_adjustx-50, player_pos[3][2] - alarm_pos_adjusty+100},
    }
end

function TableView:showRuleInfo(ruleInfo)
    self.ruleInfo_:setString(ruleInfo)
end


function TableView:doShowHuCard_(event)
    local h,w = self.showHuCardBg_:getContentSize().height,self.showHuCardBg_:getContentSize().width
    local huCardInfo = event.hucard

    local len = #huCardInfo
    self.showHuCardNode_:removeAllChildren()
    if len > 0 and setData:getCDPHZTPTS() then
        self.showHuCardBg_:setVisible(true)
        self.showHuCard_:setVisible(true)
        for i = 1,len do
            local huCard = app:createConcreteView("PaperCardView", huCardInfo[i].card, 2 , false, nil):addTo(self.showHuCardNode_):pos(0+50+(i-1)*40+80-(len-1)*20-100 , h*0.5-60+100):scale(0.30)
            local labelInfo_ = display.newTTFLabel({text = "", size = 32, color = cc.c3b(255,213,109),align = cc.ui.TEXT_ALIGN_LEFT,}):addTo(self.showHuCardNode_):pos(0+50+(i-1)*40+80-(len-1)*20-100 , h*0.5-98+100)
            labelInfo_:setString(huCardInfo[i].count)
        end
    else
        self.showHuCardNode_:removeAllChildren()
        self.showHuCardBg_:setVisible(false)
        self.showHuCard_:setVisible(false)
    end
end

function TableView:doChangeCardType_(event)
    self.nodeHostMaJiang_:changeHandCard()
end

function TableView:doChangeLayout_(event)
    local cards = clone(self.nodeHostMaJiang_.handCards_)
    if self.nodeHostMaJiang_ then
        self.nodeHostMaJiang_:removeSelf()
        self.nodeHostMaJiang_ = nil
    end
    local player = display.getRunningScene():getHostPlayer()
    self.nodeHostMaJiang_ = paiXingList[setData:getCDPHZCardLayout()].new():addTo(self.nodeHandPaper_, 100)
    display.getRunningScene():setHostPlayerPaperCard(self.nodeHostMaJiang_)
    self.nodeHostMaJiang_:setPlayer(player)
    self.nodeHostMaJiang_:showPokers(cards)
end

function TableView:doChangeTableBg_(event)
    local texture = cc.Director:getInstance():getTextureCache():addImage("res/images/game/bg" .. event.aimIndex ..".jpg")
    display.getRunningScene().bgSprite_:setTexture(texture)
end

function TableView:doHXTS_(event)
    display.getRunningScene().tableController_:reShowCard()
    print("胡息提示",event.need)
end

function TableView:doTPTS_(event)
    if event.need then
        display.getRunningScene().tableController_:checkHu()
    else
        self.showHuCardNode_:removeAllChildren()
        self.showHuCardBg_:setVisible(false)
        self.showHuCard_:setVisible(false)
    end
end


function TableView:clearNodeMoPaiDaPai_()
    if self.nodeMoPaiDaPai_ then
        self.nodeMoPaiDaPai_:removeAllChildren()
        self.currCard = nil
    end
end

function TableView:onCurrCardChange_(event)
    local isMo = event.isMo
    if not event.card  or event.card == 0 then
        self:clearNodeMoPaiDaPai_()
    else
        local dyTime = 0.0618
        local card = event.card
        self:clearNodeMoPaiDaPai_()
        if TABLE_DIRECTION.BOTTOM == event.index then
            self.currCard  = app:createConcreteView("PaperCardView", card, 1, false,nil):addTo(self.nodeMoPaiDaPai_):pos(unpack(cur_card_pos[1]))
            self.currCard:fanPai() 
            self.currCard:showMark(isMo)
            transition.scaleTo(self.currCard, {scale = 0.8, time = 0.1})
        elseif TABLE_DIRECTION.RIGHT == event.index then   
            local orgX,orgY = display.cx,cur_card_pos[2][2]
            if not isMo then
                orgX,orgY = OUT_CARD_POSITION[2][1],OUT_CARD_POSITION[2][2]
            end
            self.currCard = app:createConcreteView("PaperCardView", card, 1, false,nil):addTo(self.nodeMoPaiDaPai_):pos(orgX,orgY)
            self.currCard:fanPai()     
            self.currCard:showMark(isMo)
            local action1 = cc.MoveTo:create(dyTime, cc.p(cur_card_pos[2][1],cur_card_pos[2][2]))
            local action2 = cc.ScaleTo:create(dyTime, 0.8)    
            self.currCard:setScale(0.1) 
            self.currCard:runAction(cc.Sequence:create(cc.Spawn:create(action1,action2)))
            
        else
            local orgX,orgY = display.cx,cur_card_pos[3][2]
            if not isMo then
                orgX,orgY = OUT_CARD_POSITION[3][1],OUT_CARD_POSITION[3][2]
            end
            self.currCard  = app:createConcreteView("PaperCardView", card, 1, false, nil):addTo(self.nodeMoPaiDaPai_):pos(orgX,orgY)
            self.currCard:fanPai()   
            self.currCard:showMark(isMo)
            local action1 = cc.MoveTo:create(dyTime, cc.p(cur_card_pos[3][1],cur_card_pos[3][2]))
            local action2 = cc.ScaleTo:create(dyTime, 0.8)   
            self.currCard:setScale(0.1) 
            self.currCard:runAction(cc.Sequence:create(cc.Spawn:create(action1,action2))) 
            
        end
    end
end

local roundOver_AdjustY = 30
function TableView:calcRoundOverShowPokerPos_(total, i, j, postion, playerX, playerY,perkan)
    if TABLE_DIRECTION.LEFT == postion then
        return self:calcRoundOverPokerPosLeft_(total, i, j, playerX, playerY,perkan)
    elseif TABLE_DIRECTION.RIGHT == postion then
        return self:calcRoundOverPokerPosRight_(total, i, j, playerX, playerY,perkan)
    end
    return 0, 0, 0 - roundOver_AdjustY
end

function TableView:calcRoundOverPokerPosLeft_(total, i, j, playerX, playerY,perkan)
    local majiang_width = SMALL_CARD_WIDTH
    local per_height = majiang_width
   
    local x = -100 +  i * majiang_width + 15
    local y =  50 + (j - 1) * per_height - per_height
    if  perkan == 4 then
        y = y + per_height
    end
    return  x + playerX + 300,  y + playerY - roundOver_AdjustY - 130
end

function TableView:calcRoundOverPokerPosRight_(total, i, j, playerX, playerY,perkan)
    local majiang_width = SMALL_CARD_WIDTH
    local per_height = majiang_width
    local x =  -100 + i * majiang_width + 20
    local y =  50 + (j - 1) * per_height - per_height
    if  perkan == 4 then
        y = y + per_height
    end
    return playerX - x - 300 , y + playerY - roundOver_AdjustY - 130
end

function TableView:onShowHandPai_(event)

    -- self:onClearRoundOverShowPai_()
    if self.layerShowPai_ == nil then
        self.layerShowPai_ = display.newColorLayer(cc.c4b(0, 0, 0, 99)):addTo(self.nodeRoundOver_)   
        self.layerShowPai_:setTouchEnabled(true)
        self.layerShowPai_:setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
    end
    local cards = PaperCardGroup.clacKanList(event.cards)
    -- local cards = PaperCardGroup.roundOverChaiPai(event.cards,true)
    -- dump(res,"resresresresres")
    -- dump(cards,"cardscardscardscardscards")
    local index = event.index
    local ox = event.x
    local oy = event.y
    -- local actionDelay = cc.DelayTime:create(1)
    -- local actions = {actionDelay}
    if event.isWinner then
        local huPath = event.winnerInfo.huPath
        local handCardIndex = event.winnerInfo.handCardIndex
        local huCardIndex = event.winnerInfo.huCardIndex
        cards = huPath
        local highhu = false
         for i=1, #cards - handCardIndex + 1 do
            for j=1,#cards[i+handCardIndex -1] -1 do
                local x, y = self:calcRoundOverShowPokerPos_(#cards - handCardIndex + 1, i, j, index, ox, oy,#cards[i+handCardIndex -1] -1)
                    local poker = app:createConcreteView("PaperCardView", cards[i+handCardIndex -1][j+1], 3 , false, nil):addTo(self.nodeRoundOver_):pos(ox, oy)
                    poker:fanPai()
                    if not cards[i+handCardIndex -1][j+1] then
                        dump(cards[i+handCardIndex -1][j+1])
                    end
                    if huCardIndex - handCardIndex + 1 == i and  cards[i+handCardIndex -1][j+1] == event.winnerInfo.huCard and not highhu then
                        poker:highLight()
                        highhu = true
                    end
                    transition.moveTo(poker, {x = x, y = y, time = 0.1})
            end
        end
    else
        for i=1, #cards do
            for j=1,#cards[i] do
                local x, y = self:calcRoundOverShowPokerPos_(#cards, i, j, index, ox, oy,#cards[i])
                local poker = app:createConcreteView("PaperCardView", cards[i][j], 3 , false, nil):addTo(self.nodeRoundOver_):pos(ox, oy)
                poker:fanPai()
                transition.moveTo(poker, {x = x, y = y, time = 0.1})
            end
        end
    end
end

function TableView:onShowHuangZhuang_(event)
    print("onShowHuangZhuang_(event)")
    app:createConcreteView("HuangAnim"):addTo(self.nodeMoPaiDaPai_):pos(display.cx, display.cy)
end

function TableView:onShowDiPai_(event)
    -- if not event.cards then
    --     return
    -- end
    -- local cards = event.cards
    -- local winner = event.winner
    -- local actions = {}
    -- if event.huCard and event.huCard ~= 0 then
    --     local huCard = app:createConcreteView("PaperCardView", event.huCard, 1 , false, nil):addTo(self.nodeRoundOver_):pos(display.cx, display.cy + 320 - roundOver_AdjustY):scale(0.65)
    --     huCard:setPositionY(550)
    --     huCard:addFaGuang()
    -- end
    -- self:clearNodeMoPaiDaPai_()
    -- for i=1,#cards do
    --     local x, y = self:calcRoundOverShowDiPaiPos_(#cards, i)
    --     local poker = app:createConcreteView("PaperCardView", cards[i], 1 , false, nil):addTo(self.nodeRoundOver_):pos(display.cx, display.cy + 320 - roundOver_AdjustY)
    --     poker:fanPai()
    --     poker:hide()
    --     transition.moveTo(poker, {x = x, y = y - 90, time = 0.1})
    --     poker:setScale(0.65)
    --     poker:show()
    -- end
    -- local dipai =  display.newSprite("res/images/paohuzi/game/dipai.png"):addTo(self.nodeRoundOver_):pos(display.cx, display.cy + 50)
end

function TableView:showHutype(huList,cards,winner)

    if not huList or not winner then
        return 
    end
    if #huList == 0 and winner then
        table.insert(huList, 100)
    end
    local actions = {}
    for i = 1, #huList do
        local x, y = self:calcRoundOverHulistPos_(i,#cards, #huList,winner)
        local hutype = HUANIFILE[huList[i]]
        if not hutype then
            print (hutype, ' not exist')
        else
            local png = HUTYPE_LIST[hutype]
            if not png then
                print (id, ' not exist')
            else
                local action =   cc.CallFunc:create(function ()
                    local hutype =  display.newSprite(png):addTo(self.nodeRoundOver_):pos(x, y +50):scale(3)
                    transition.scaleTo(hutype, {scale = 1.1, time = 0.2, easing = "bounceOut"})
                    self:showHulizi(hutype)
                end)
                table.insert(actions, action)
                local actionDelay = cc.DelayTime:create(0.3)
                table.insert(actions, actionDelay)
            end
        end
    end
    local sequence = transition.sequence(actions)
    self.nodeRoundOver_:runAction(sequence)
end

function TableView:showHulizi(hutype)
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

function TableView:calcRoundOverHulistPos_(index,total,hutotal,winner)
    if winner then
        if TABLE_DIRECTION.LEFT == winner:getIndex() then
            return self:calcRoundOverHulistPosLeft_(index,total,hutotal,winner)
        elseif TABLE_DIRECTION.RIGHT == winner:getIndex() then
            return self:calcRoundOverHulistPosRight_(index,total,hutotal,winner)
        else
            return self:calcRoundOverHulistPosBottom_(index,total,hutotal,winner)
        end
    else
        -- dump("winner")
        return self:calcRoundOverHulistPosBottom_(index,total,hutotal,winner)
    end
end

function TableView:calcRoundOverHulistPosLeft_(index,total,hutotal,winner)
    local ox,oy = winner:getPlayerPosition()
    local x = ox + ((index -1) % 3 )* 110 - 10
    local y = oy - 100 -math.ceil(index / 3) * 50

    return x, y - 15
end

function TableView:calcRoundOverHulistPosRight_(index,total,hutotal,winner)
    local ox,oy = winner:getPlayerPosition()
    local x = ox - ((index -1) % 3 )* 110
    local y = oy - 100 - math.ceil(index / 3) * 50

    return x, y - 15
end

function TableView:calcRoundOverHulistPosBottom_(index,total,hutotal,winner)
    local ox,oy = 0, 90
    if winner then
        ox,oy = winner:getPlayerPosition()
    end
    local x =  150 + ((index -1) % 3 )* 200
    local y = oy + 100 - math.ceil(index / 3) * 50 + 100 - 50
    if hutotal == 1 then
        x = display.cx
    elseif hutotal == 2 then
        x = display.cx - 150* 2 + index  * 150
    end
    return x, y
end

function TableView:onClearRoundOverShowPai_()
    self.nodeRoundOver_:stop()
    self.nodeRoundOver_:removeAllChildren()
    self.reViewHandCards_ = nil
    self.reViewHandCardsView_ = nil
end

function TableView:onRoundReset_()
    self.nodeRoundOver_:stop()
    self.nodeRoundOver_:removeAllChildren()
    self.reViewHandCards_ = nil
    self.reViewHandCardsView_ = nil
end

function TableView:calcRoundOverShowDiPaiPos_(total,index)
    local startx,stary = 60, display.cy + 170
    local offset = index % countPerLine 
    if offset == 0 then
        offset = countPerLine
    end
    local x = display.cx - perWidth * countPerLine / 2 + offset * perWidth  - perWidth/2
    local y = stary - math.ceil(index / countPerLine) * perHeight
    if countPerLine > total then
        x = display.cx - perWidth * total / 2 + offset * perWidth  - perWidth/2
    end

    return x, y - roundOver_AdjustY
end

function TableView:onCurrCardFaGuang_(event)
    if self.currCard then
        self.currCard:addFaGuang()
        transition.moveTo(self.currCard, {x = display.cx, y = display.cy + 200, time = 0.1})
    end
end

function TableView:onGoldFlyEvent_(event)
    for i,v in ipairs(event.data) do
        for i,p in ipairs(event.data) do
            if v.winType == -1 and p.winType == 1 then
                local count = math.abs(v.score)
                if v.isZhuang then count = count / 2 end
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
            local spriteGold = display.newSprite("res/images/game/gold.png"):addTo(self):pos(startPoint.x, startPoint.y):scale(2)
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

--桌面一局开始设置
function TableView:onRoundStartEvent_(event)
    
end

function TableView:onRoundOverEvent_(event)
    self.directorController_:stop()
    self:updateTLeftCards_(0)
    if display.getRunningScene().__cname ~= "ZhanJiScene" then
        self:clearNodeMoPaiDaPai_()
        self:onClearRoundOverShowPai_()
    end
end
 
function TableView:getPokerByCard_(card)
    local nodes = self:getChildren()
    for _,v in pairs(nodes) do
        if v:getCard() == card then
            return v
        end
    end
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

local POKER_ANIMS = {
}

local ANIM_TEXTURES = {
}

function TableView:playAnimByData_(cardType, x, y, scale)
    local params = POKER_ANIMS[cardType]
    if not params then
        return
    end
    if ANIM_TEXTURES[cardType] then
        display.addSpriteFrames(unpack(ANIM_TEXTURES[cardType]))
    end
    local data = gameAnim.formatAnimData(unpack(params[1]))
    data = gameAnim.appendAnimAttrs(data, unpack(params[2]))
    local sp = display.newSprite():addTo(self.nodeAnim_):pos(x, y)
    if scale then
        sp:scale(scale)
    end
    gameAnim.play(sp, data)
end

function TableView:playTianZhaAnimation_()
    local sp = display.newSprite("#tianzha.png"):addTo(self.nodeAnim_)
    sp:scale(2)
    sp:pos(display.cx, display.cy + 350)
    transition.moveTo(sp, {y = sp:getPositionY() - 250, time = 0.1, onComplete = function()
        transition.stopTarget(sp)
        sp:removeFromParent()
        local word = display.newSprite("#tianzha_word.png"):addTo(self.nodeAnim_):pos(display.cx, display.cy + 170)
        transition.fadeTo(word, {opacity = 0, time = 1})
        local list = {{"tianzhabaozha", "tianzhabaozha%04d.png", 0, 8, 1, false}, {"sounds/zhadanbaozha.mp3"}}
        local baoZhadata = gameAnim.formatAnimData(unpack(list[1]))
        baoZhadata = gameAnim.appendAnimAttrs(baoZhadata, unpack(list[2]))
        local baozha = display.newSprite():addTo(self.nodeAnim_)
        baozha:scale(4)
        baozha:pos(display.cx, display.cy - 20)
        gameAnim.play(baozha, baoZhadata)
    end})
end

function TableView:playBomb_(cardType, index, scale)
    local x, y = display.cx, 300
    if index == TABLE_DIRECTION.RIGHT then
        x, y = display.width * 0.78, 500
    elseif index == TABLE_DIRECTION.LEFT then
        x, y = display.width * 0.22, 500
    end
    self:playAnimByData_(cardType, x, y, scale)
end

function TableView:playFeiJiAnim_(index)
    -- 初始位置 终点X坐标 是否翻转
    local ap = display.LEFT_CENTER
    local fromX, fromY, toX = 0, 297, display.right
    local flipX = false
    if index == TABLE_DIRECTION.RIGHT then
        fromX, toX = display.right, display.left
        ap = display.RIGHT_CENTER
        fromY = 544
        flipX = true
    elseif index == TABLE_DIRECTION.LEFT then
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
    gailun.HTTP.download(self.soundUrl_, path, 
    function (fileName)
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
    gailun.HTTP.download(self.soundUrl_, path, 
    function (fileName)
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
    if toIndex == TABLE_DIRECTION.LEFT then
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

local chatBg = {
    {"res/images/common/chat_bgl.png", 17, 75, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"res/images/common/chat_bgr.png", -47, 20, cc.size(300, 80), cc.rect(50, 47, 1, 1), cc.p(1, 50/80), cc.p(0.5, 0.5), {20, 50}},
    {"res/images/common/chat_bgt.png", -14, -88, cc.size(300, 80), cc.rect(30, 47, 1, 1), cc.p(1, 30/80), cc.p(0.5, 0.5), {20, 32}},
    {"res/images/common/chat_bgl.png", 52, 32, cc.size(300, 80), cc.rect(63, 47, 1, 1), cc.p(0, 50/80), cc.p(0.5, 0.5), {20, 50}},
}

function TableView:showChatText_(player, chatID, node)
    if not CHANNEL_CONFIGS.CHAT then
        return
    end
    local sprite = display.newSprite("res/images/yuyinwenzi/quickChatbg.png"):addTo(node)
    sprite:setCascadeOpacityEnabled(true)
    sprite:setAnchorPoint(ap)
    print("player:getIndex()",player:getIndex())
    if player:getIndex() == 1 then
        node:pos(480-120,230-50)
    elseif player:getIndex() == 2 then
        node:pos(980-140,470+160)
        sprite:setScaleX(-1)
    elseif player:getIndex() == 3 then
        node:pos(320+70,480+160)
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

function TableView:faceBQ_(player, chatID, node)
    self:showChatBQ_(player, chatID, node)
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
    local roomID = self.table_:getTid()
    local text = "房间号:"..roomID
    if self.table_:getMatchType() ~= 2 then
        text = text .. " 局数:"..event.num.."/".. event.total
    end
    self.progressView_:setRoomInfo(text)
end

function TableView:getProgreesView()
    return self.progressView_
end

function TableView:onTableChanged_(event)
    -- self:updateTableID_(event.tid)
end

function TableView:onCardsNumChanged_(event)
    self:updateTLeftCards_(event.cardsnum)
end

-- function TableView:updateTableID_(tid)
--     -- self.labelTableID_:setString(string.format("房间号:%06d", tid or 0))
-- end


function TableView:updateTLeftCards_(CardsNum)
    if CardsNum > 0 then
        self.labelLeftCards_:setVisible(true)
        self.imgleftCards_:setVisible(true)
        self.labelLeftCards_:setString(string.format("%d", CardsNum or 0))
        if CardsNum < 15 and CardsNum > 8 then
            local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/game/phz_comm_lastcard1.png')
            self.imgleftCards_:setTexture(texture)
        elseif CardsNum < 8 and CardsNum > 0 then
            local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/game/phz_comm_lastcard2.png')
            self.imgleftCards_:setTexture(texture)
        elseif CardsNum > 15 then
            local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/game/phz_comm_lastcard4.png')
            self.imgleftCards_:setTexture(texture)
        end
    else
        self.labelLeftCards_:setVisible(false)
        self.imgleftCards_:setVisible(false)
    end
end

function TableView:makeRuleString(spliter)
    if self.configData_ then
        local data = self.configData_
        local list = {}
        table.insert(list, (data.rules.totalSeat or 3) .. "人")
        return table.concat(list, spliter)
    end
end

function TableView:makeAddRuleString(spliter)
    if self.configData_ then
        local data = self.configData_
        local list = {}
        return table.concat(list, spliter)
    end
end

function TableView:onRoomConfigChanged_(event)
    self.configData_ = event.data
    -- dump(self.configData_,"self.configData_")
    local roomInfo = self:makeRuleString("   ") or ""
    local roomAddInfo = self:makeAddRuleString("   ") or ""
    roomInfo = roomInfo .."   ".. roomAddInfo
    -- self.labelTableRules_:setString(roomInfo)
    -- local roomAddInfo = self:makeAddRuleString("   ") or ""
    -- self.labelTableAddRules_:setString(roomAddInfo)
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
    self.directorController_:startTimeCount(seconds)
    local player = self:getParent().seats_[seatID]
    if player then
        local index = player:getIndex()
        local x, y = unpack(ALARM_POSITION[index] or {0, 0})
        self.directorController_:pos(x, y)
        local x, y = unpack(TIME_TIP_POSITION[index] or {0, 0})
        self.timeTips_:setString(TIME_TIP_FONT[index] or "")
        self.timeTips_:pos(x, y)
        self.timeTips_:hide()
    end
end

function TableView:showTimeTip()
    self.timeTips_:show()
end

function TableView:onTurnToEvent_(event)
    self:showAlarm(event.seatID, event.seconds)
end

function TableView:stopTimer()
    self.directorController_:stop()
    self.directorController_:hide()
    self.timeTips_:hide()
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
end

function TableView:onStateCheckout_(event)
    self.directorController_:stop()
end

function TableView:onStateIdle_(event)
    self.directorController_:hide()
    self.spriteDealer_:hide()
    self.timeTips_:hide()
    -- self.labelTableRules_:show()
    -- self.labelTableAddRules_:show()
end

function TableView:focusOff( ... )
    -- body
end

function TableView:onStatePlaying_(event)
    self:clearEveryThing_()
    -- self.labelTableRules_:show()
    -- self.labelTableAddRules_:show()
    self.spriteDealer_:hide()
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
    player:setDealer(true)
    -- if not POSITION_OF_DEALER_4[index] then
    --     self.spriteDealer_:hide()
    --     return
    -- end
    -- self.spriteDealer_:show()
    -- local ox, oy = unpack(POSITION_OF_DEALER_4[index])
    -- -- transition.stopTarget(self.spriteDealer_)
    -- -- transition.moveTo(self.spriteDealer_, {x = x + ox, y = y + oy, time = 1, easing = "exponentialOut"})
    -- self.spriteDealer_:setPosition(x + ox, y + oy)
end

function TableView:hideDealer()
    self.spriteDealer_:hide()
end

function TableView:onAdjustSeats(dealer)
    self:showDealerAtIndex_(dealer)
end

function TableView:resetPopUpPokers()
    -- self.nodeHostMaJiang_:resetPopUpPokers()
end

function TableView:onDealerChanged_(event)
    self:showDealerAtIndex_(event.seatID)
end

function TableView:onFaPaiAction_(index,seatID)
    self.index_ = index
    local player = self:getParent():getPlayerBySeatID(seatID)
    if not player then
        return
    end
    local pos = player:getIndex()
    local nodeFaPai = self["nodeFaPai".. index .. "_"]:removeAllChildren()
    local startPos = nodeFaPai:convertToNodeSpace(cc.p(display.cx, display.cy))
    local count = 17
    local time = 0.1 
    for i=1,count do
        local poker = app:createConcreteView("PaperCardView", 210, 1):addTo(nodeFaPai)
        poker:pos(startPos.x, startPos.y)
        local x, y, z, scale  = self:calcFaPaiPokerPos_(count, i)
        self:performWithDelay(function ()
            if TABLE_DIRECTION.BOTTOM == index then
                transition.scaleTo(poker, {scale = 1, time = 0.1, easing = "exponentialOut"})
            end
            transition.moveTo(poker, {x = x, y = y, time = 0.1, easing = "exponentialOut"})
        end, time)
        time = time + 0.1
        poker:zorder(z)
        poker:setScale(scale)
    end
    self:performWithDelay(function ( ... )
        self:shouPaiAnim_(index)
    end, time + 0.5)
end

function TableView:shouPaiAnim_(index)  -- 收牌
    local nodeFaPai = self["nodeFaPai".. index .. "_"]
    local nodes = nodeFaPai:getChildren()
    local endX = nodes[1]:getPositionX()
    local endY = nodes[1]:getPositionY()
    for i=1,#nodes do
        if TABLE_DIRECTION.BOTTOM ~= index then
            transition.moveTo(nodes[i], {x = endX, y = endY, time = 0.5})
        end
    end
    self:performWithDelay(function ( ... )
        nodeFaPai:removeAllChildren()
        self.nodeHostMaJiang_:setVisible(true)
    end, 0.6) 
end

function TableView:calcFaPaiPokerPos_(total, index)
    if TABLE_DIRECTION.LEFT == self.index_ then
        return self:calcFaPaiPokerPosLeft_(total, index)
    elseif TABLE_DIRECTION.RIGHT == self.index_ then
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

function TableView:zhuanQuanAction(target, timer)
    local sequence = transition.sequence({
        cc.RotateTo:create(timer, 180),
        cc.RotateTo:create(timer, 360),
        })
    target:runAction(cc.RepeatForever:create(sequence))
end

-- 回放
function TableView:onReviewHandCards_(event)
    local p = self:getParent():getPlayerBySeatID(event.seatID)
    local index = p:getIndex()
    self.reViewHandCards_ = self.reViewHandCards_ or {}
    self.reViewHandCards_[index] = clone(event.cards)
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:refreshReviewHandCards_(seatID)
    local p = self:getParent():getPlayerBySeatID(seatID)
    -- if (dataCenter:getHostPlayer():getSeatID() == seatID) then
    -- if not p or p:getIndex() == 1 then
    --     return
    -- end

    local index = p:getIndex()
    local cardSize = 3
    if p:getIndex() == 1 then
        cardSize = 2
    end
    self:clearReviewHandCards_(index)
    local cards = PaperCardGroup.clacKanList(self.reViewHandCards_[index])
    local posX, posY = p:getPlayerPosition()
    local index = p:getIndex()
    for i=1, #cards do
        for j=1,#cards[i] do
            local x, y = self:calcReviewShowPokerPos_(#cards, i, j, index, posX, posY, #cards[i])
            y = y - 173
            local poker = app:createConcreteView("PaperCardView", cards[i][j], cardSize , false, nil):addTo(self.nodeRoundOver_,-j):pos(x, y)
            poker:fanPai()
            table.insert(self.reViewHandCardsView_[index], poker)
        end
    end
end

function TableView:clearReviewHandCards_(index)
    self.reViewHandCardsView_ = self.reViewHandCardsView_ or {}
    self.reViewHandCardsView_[index] = self.reViewHandCardsView_[index] or {}
    for i=1, #self.reViewHandCardsView_[index] do
        self.reViewHandCardsView_[index][i]:removeFromParent()
    end
    self.reViewHandCardsView_[index] = {}
end

function TableView:deleteReviewHandCards_(seatID, card, isAll)
    local p = self:getParent():getPlayerBySeatID(seatID)
    local index = p:getIndex()

    local cards = self.reViewHandCards_[index]
    table.removebyvalue(cards, card, isAll)
end

function TableView:onReviewChu_(event)
    self:deleteReviewHandCards_(event.seatID, event.card)
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:onReviewChi_(event)
    local chiPai = event.data.chiPai
    local biPai = event.data.biPai or {}
    local card = event.data.card
    table.removebyvalue(chiPai, card)
    for i = 1, #chiPai do
        self:deleteReviewHandCards_(event.seatID, chiPai[i])
    end
    for i = 1, #biPai do
        for j = 1, #biPai[i] do
            self:deleteReviewHandCards_(event.seatID, biPai[i][j])
        end
    end
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:onReviewPeng_(event)
    self:deleteReviewHandCards_(event.seatID, event.card, true)
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:onReviewWei_(event)
    self:deleteReviewHandCards_(event.seatID, event.card, true)
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:onReviewPao_(event)
    self:deleteReviewHandCards_(event.seatID, event.cards, true)
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:onReviewTi_(event)
    if type(event.cards) == "table" then
        for i = 1, #event.cards do
            self:deleteReviewHandCards_(event.seatID, event.cards[i], true)
        end
    else
        self:deleteReviewHandCards_(event.seatID, event.cards, true)
    end
    
    self:refreshReviewHandCards_(event.seatID)
end

function TableView:calcReviewShowPokerPos_(total, i, j, postion, playerX, playerY,perkan)
    if TABLE_DIRECTION.LEFT == postion then
        return self:calcReviewPokerPosLeft_(total, i, j, playerX, playerY,perkan)
    elseif TABLE_DIRECTION.RIGHT == postion then
        return self:calcReviewPokerPosRight_(total, i, j, playerX, playerY,perkan)
    end
    return self:calcReviewPokerPosBotton_(total, i, j, playerX, playerY,perkan)
end

function TableView:calcReviewPokerPosBotton_(total, i, j, playerX, playerY,perkan)
    local majiang_width = 90
    local per_height = 110
   
    local x = 200 +  i * majiang_width + 15
    local y =  150 + (j - 1) * per_height 
    -- if  perkan == 4 then
    --     y = y + per_height
    -- end
    if total <= 5 then
        -- x = x + 120
    end
    return  x + playerX,  y + playerY
end

function TableView:calcReviewPokerPosLeft_(total, i, j, playerX, playerY,perkan)
    local majiang_width = SMALL_CARD_WIDTH
    local per_height = majiang_width
   
    local x =  i * majiang_width + 120
    local y =  40 + (j - 1) * per_height +150 - majiang_width
    -- if  perkan == 4 then
    --     y = y + per_height
    -- end
    if total <= 5 then
        -- x = x + 120
    end
    return  x + playerX+50,  y + playerY-150
end

function TableView:calcReviewPokerPosRight_(total, i, j, playerX, playerY,perkan)
    local majiang_width = SMALL_CARD_WIDTH
    local per_height = majiang_width
    local x =  i * majiang_width + 120
    local y =  40 + (j - 1) * per_height +150 - majiang_width
    -- if  perkan == 4 then
    --     y = y + per_height
    -- end
    if total <= 5 then
        -- x = x + 120
    end
    return playerX - x-50 , y + playerY-150
end

function TableView:onReviewShouZhang_(event)
    local p = self:getParent():getPlayerBySeatID(event.seatID)
    local index = p:getIndex()
    local cards = self.reViewHandCards_[index]
    table.insert(cards, event.card)

    self:refreshReviewHandCards_(event.seatID)
end
-- 回放

return TableView
