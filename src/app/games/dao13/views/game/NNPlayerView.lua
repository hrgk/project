local PlayerView = import("app.views.game.PlayerView")
local NNPlayerView = class("PDKPlayerView", PlayerView)
local PokerList = import("app.views.game.PokerList")
local PokerListView = import("app.games.dao13.views.game.PokerListView")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local D13Algorithm = import("app.games.dao13.utils.D13Algorithm")
NNPlayerView.HOST = 1
NNPlayerView.LEFT = 2
NNPlayerView.UP = 3
NNPlayerView.RIGHT = 4

function NNPlayerView:ctor(index,totalSeat)
    NNPlayerView.super.ctor(self, index)
    self.playerCount = totalSeat
    self.daoCardShow = {}
    self.cardTypeShow = {}
    self.daoFenShow = {{},{},{},{}}
end

function NNPlayerView:addEventListeners_()
    NNPlayerView.super.addEventListeners_(self)
    cc.EventProxy.new(self.player_, self.csbNode_, true)
    :addEventListener(self.player_.SHOW_TIAO_PAI, handler(self, self.onTiaoPaiHandler_))
    :addEventListener(self.player_.SHOW_ZP_OK, handler(self, self.onZPOKHandler_))
    :addEventListener(self.player_.SHOW_DAO_CARD, handler(self, self.onShowDaoCardHandler_))
    :addEventListener(self.player_.SHOW_DAO_SCORE, handler(self, self.onShowDaoScoreHandler_))
    :addEventListener(self.player_.CLEAR_ALL, handler(self, self.onClearAllHandler_))
    :addEventListener(self.player_.SHOW_ZHUANG_KUANG, handler(self, self.onShouZhuangHandler_))
    :addEventListener(self.player_.HIDE_REAY, handler(self, self.onHideReayHandler_))
    :addEventListener(self.player_.QIANG_ZHUANG, handler(self, self.onQiangZhuangHandler_))
end

function NNPlayerView:onQiangZhuangHandler_(event)
    if event.callScore == - 1 then
        self.qiang_:hide()
        self.buqiang_:hide()
        self.qiangFen_:setString("")
        return
    end
    if event.callScore > 0 then
        self.qiang_:show()
        self.qiangFen_:setString("*"..event.callScore)
    else
        self.qiang_:hide()
        self.buqiang_:show()
        self.qiangFen_:setString("")
        if not event.isReConnect then
            gameAudio.playNiuNiuHumanSound("buqiang.mp3", self.player_:getSex())
        end
    end
end

function NNPlayerView:initQiangFen_()
    self.qiangFen_ = cc.LabelBMFont:create("", "fonts/niuqiang.fnt")
    self.qiangFen_:setAnchorPoint(0,0.5)
    self.csbNode_:addChild(self.qiangFen_)
    self.qiangFen_:setPosition(40,88)
end

function NNPlayerView:onRoomInfo_(event)
   
end

-- function NNPlayerView:updatePos()
--     local offX = 0
--     local offY = 0
--     print("updatePosupdatePos",self.index_,NNPlayerView.LEFT,self.playerCount)
--     if self.index_ == NNPlayerView.LEFT and self.playerCount == 2 then
--         offX = -580+50
--         offY = -250+50+5+50-5
--     else
--         return
--     end
  
--     for i = 1,3 do 
--         local x = offX
--         local y = (3-i)*55+offY
--         self.daoCardShow[i]:setPosition(x+190,y)
--         self.daoCardShow[i]:setScale(0.8,0.6)
--         if i == 1 then
--             if self.index_ == NNPlayerView.LEFT and self.playerCount == 2  then
--                 self.zjBg:setPosition(x+260,y-155)
--                 self.zjTip:setPosition(x+220,y-155)
--                 self.daoFenShow[4].lose:setPosition(x+280,y-155)
--                 self.daoFenShow[4].win:setPosition(x+280,y-155)
--             end
--         end
--         if i == 1 then
--             self.daoFenShow[i].lose:setPosition(x+350,y+80)
--             self.daoFenShow[i].win:setPosition(x+350,y+80)
--         else
--             self.daoFenShow[i].lose:setPosition(x+380,y+80)
--             self.daoFenShow[i].win:setPosition(x+380,y+80)
--         end
       
--         if i == 3 then
--             self.zPOK:setPosition(x+260,y)
--         end
--         self.cardTypeShow[i]:setPosition(x+260,y)
--     end
-- end

function NNPlayerView:onHideReayHandler_(event)
    self.readyFlag_:setVisible(false)
end

function NNPlayerView:onShouZhuangHandler_(event)
    -- self.kuang_:setVisible(event.isShow)
    -- if event.isShow then
    --     gameAudio.playSound("res/sounds/niuniu/sound_bankert.mp3")
    -- end
end

function NNPlayerView:showDaoCardAnim(node,node1)
    local seconds = 1
    local x,y = node:getPosition()
    local sequence = transition.sequence({
        cc.Spawn:create(cc.MoveTo:create(seconds, cc.p(x-60, y+20)),
           cc.ScaleTo:create(checknumber(seconds), 1,1)),
        cc.Spawn:create(cc.MoveTo:create(seconds, cc.p(x, y)),
           cc.ScaleTo:create(checknumber(seconds), 0.8,0.6)),
        cc.DelayTime:create(seconds / 2),
        cc.CallFunc:create(function ()
            node1:show()
        end)
    })
    node:runAction(sequence)
end

function NNPlayerView:onClearAllHandler_()
    self.zPOK:hide()
    self.zjBg:hide()
    self.zjTip:hide()
    self.tiaoPai:hide()
    for i = 1, 4 do
        if i == 4 then
            self.daoFenShow[i].lose:hide()
            self.daoFenShow[i].win:hide()
        else
            self.daoCardShow[i]:hide()
            self.cardTypeShow[i]:hide()
            self.daoFenShow[i].lose:hide()
            self.daoFenShow[i].win:hide()
        end
    end
end

function NNPlayerView:onShowDaoScoreHandler_(event)
    if event.index <= 3 then
        if event.score >= 0 then
            self.daoFenShow[event.index].lose:hide()
            self.daoFenShow[event.index].win:show()
            self.daoFenShow[event.index].win:setString(event.score)
        else
            self.daoFenShow[event.index].win:hide()
            self.daoFenShow[event.index].lose:show()
            self.daoFenShow[event.index].lose:setString(event.score)
        end
    else
        if event.score >= 0 then
            self.daoFenShow[4].lose:hide()
            self.daoFenShow[4].win:show()
            self.daoFenShow[4].win:setString(event.score)
            self.zjTip:loadTexture("views/games/d13/caozuo/zj2.png")
        else
            self.daoFenShow[4].win:hide()
            self.daoFenShow[4].lose:show()
            self.daoFenShow[4].lose:setString(event.score)
            self.zjTip:loadTexture("views/games/d13/caozuo/zj1.png")
        end
        self.zjBg:show()
        self.zjTip:show()
    end
end

function NNPlayerView:onShowDaoCardHandler_(event)
    self.zPOK:hide()
    local date = display.getRunningScene():getTable():getConfigData()
    local needTipCard = -99
    if date.config.rules.maPai == 1 then
        needTipCard = 410
    end
    for i = 1,3 do
        self.daoCardShow[i]:setNeedTipCard(needTipCard)
    end
    if event.index <= 3 then
        if event.index == 1 then
            table.insert(event.cards,1,0)
        end
        if not event.isHost then
            self.daoCardShow[event.index]:showPokers(event.cards,true)
        end
        if event.index > 1 then
            self.cardTypeShow[event.index-1]:hide()
        end
        self.cardTypeShow[event.index]:loadTexture("views/games/d13/caozuo/font/roundEnd/".. event.type ..".png")
        self.cardTypeShow[event.index]:show()
    else
        local dao1Card = {0}
        for i = 1,3 do
            dao1Card[i+1] = event.cards[i]
        end
       
        local dao2Card = {}
        for i = 4,8 do
            dao2Card[i-3] = event.cards[i]
        end
        
        local dao3Card = {}
        for i = 9,13 do
            dao3Card[i-8] = event.cards[i]
        end
        local type1,cmp1 = D13Algorithm.getCardType(dao2Card)
        local type2,cmp2 = D13Algorithm.getCardType(dao3Card)
        dump(dao1Card,"dao1Card")
        dump(dao2Card,"dao2Card")
        dump(dao3Card,"dao3Card")
        if D13Algorithm.cmpType(type1,type2,cmp1,cmp2) then
            self.daoCardShow[1]:showPokers(dao1Card,true)
            self.daoCardShow[2]:showPokers(dao3Card,true)
            self.daoCardShow[3]:showPokers(dao2Card,true)
        else
            self.daoCardShow[1]:showPokers(dao1Card,true)
            self.daoCardShow[2]:showPokers(dao2Card,true)
            self.daoCardShow[3]:showPokers(dao3Card,true)
        end
        
        if event.type ~= -1 then
            self.cardTypeShow[3]:loadTexture("views/games/d13/caozuo/font/roundEnd/".. event.type ..".png")
            self.cardTypeShow[3]:show()
        else
            self.cardTypeShow[3]:hide()
        end
    end
end

function NNPlayerView:initAnimation_()
    self.tiaoPai = ccui.ImageView:create("views/games/d13/caozuo/tiaoPai1.png")
    self.csbNode_:addChild(self.tiaoPai)
    local x = self.pokersContent_:getPositionX()
    local y = self.pokersContent_:getPositionY()+80
    if self.index_ == NNPlayerView.UP or self.index_ == NNPlayerView.LEFT then
        x = x - 170
    elseif self.index_ == NNPlayerView.RIGHT then
        x = x + 100
    end
    self.tiaoPai:setPosition(x, y)
    self.tiaoPai:hide()
end

function NNPlayerView:onZPOKHandler_()
    self.tiaoPai:hide()
    self.tiaoPai:stopAllActions()
    for i = 1, 3 do
        self.daoCardShow[i]:setAllBack()
        self.daoCardShow[i]:show()
    end
    self.zPOK:show()
end

function NNPlayerView:onTiaoPaiHandler_()
    self.tiaoPai:show()
    self.tiaoPaiIndex = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.tiaoPaiIndex = self.tiaoPaiIndex + 1
                    if self.tiaoPaiIndex > 3 then
                        self.tiaoPaiIndex = 1
                    end
                    local frameName = string.format("views/games/d13/caozuo/tiaoPai%d.png", self.tiaoPaiIndex)
                    self.tiaoPai:loadTexture(frameName)
                end
            )
        }
    )
    self.tiaoPai:runAction(cc.RepeatForever:create(sequence))
end

function NNPlayerView:setBombLayer(bombLayer)
    self.bombLayer_ = bombLayer
end

function NNPlayerView:setNode(node)
    NNPlayerView.super.setNode(self, node)
    self.buqiang_:hide()
    self.kuang_:hide()
    self.qiang_:hide()
    self:initAnimation_()
    self:initQiangFen_()
    self:initCardInfo_()
    --self:updatePos()
    --self:initZhongF_()
end

function NNPlayerView:initZhongF_()
   
    
end

function NNPlayerView:initCardInfo_()
    local cardInfo = {{0,-1,-1,-1},{-1,-1,-1,-1,-1},{-1,-1,-1,-1,-1}}
    local offX = 0
    local offY = 0
    if self.index_ == NNPlayerView.HOST then
        offX = 260+50
        offY = -80
    elseif self.index_ == NNPlayerView.UP or self.playerCount == 2 then
        offX = -580+50
        offY = -250+50+5+50-5
    elseif self.index_ == NNPlayerView.LEFT  then
        offX = -520+120
        offY = -100-30
    elseif self.index_ == NNPlayerView.RIGHT then
        offX = -80+40
        offY = -100-30
    end
  
    for i = 1,3 do 
        local x = offX
        local y = (3-i)*55+offY
        self.daoCardShow[i] = PokerListView.new():addTo(self.csbNode_)
        self.daoCardShow[i]:showPokersOnlyBack(clone(cardInfo[i]))
        self.daoCardShow[i]:setInReView(true)
        self.daoCardShow[i]:setPosition(x+190,y)
        self.daoCardShow[i]:setScale(0.8,0.6)
        if i == 1 then
            self.zjTip = ccui.ImageView:create("views/games/d13/caozuo/zj1.png")
            self.zjBg = ccui.ImageView:create("views/games/d13/caozuo/zjbg.png")
            self.daoFenShow[4].lose = cc.LabelBMFont:create("-1", "fonts/jhs.fnt")
            self.daoFenShow[4].win = cc.LabelBMFont:create("+1", "fonts/jhy.fnt")  
            self.csbNode_:addChild(self.zjBg)
            self.csbNode_:addChild(self.zjTip)
            self.csbNode_:addChild(self.daoFenShow[4].win)
            self.csbNode_:addChild(self.daoFenShow[4].lose)
            if self.index_ == NNPlayerView.HOST then
                self.zjBg:setPosition(x+260,y+140)
                self.zjTip:setPosition(x+220,y+140)
                self.daoFenShow[4].lose:setPosition(x+280,y+140)
                self.daoFenShow[4].win:setPosition(x+280,y+140)
            elseif self.index_ == NNPlayerView.UP or self.playerCount == 2 then
                self.zjBg:setPosition(x+260,y-155)
                self.zjTip:setPosition(x+220,y-155)
                self.daoFenShow[4].lose:setPosition(x+280,y-155)
                self.daoFenShow[4].win:setPosition(x+280,y-155)
            elseif self.index_ == NNPlayerView.LEFT then
                self.zjBg:setPosition(x+70,y-30)
                self.zjTip:setPosition(x+30,y-30)
                self.daoFenShow[4].lose:setPosition(x+100,y-30)
                self.daoFenShow[4].win:setPosition(x+100,y-30)
            else
                self.zjBg:setPosition(x+450+20,y-30)
                self.zjTip:setPosition(x+410+20,y-30)
                self.daoFenShow[4].lose:setPosition(x+480+20,y-30)
                self.daoFenShow[4].win:setPosition(x+480+20,y-30)
            end
        end
        self.daoFenShow[i].lose = cc.LabelBMFont:create("-1", "fonts/jhs.fnt")
        self.daoFenShow[i].win = cc.LabelBMFont:create("+1", "fonts/jhy.fnt")       
        self.csbNode_:addChild(self.daoFenShow[i].win)
        self.csbNode_:addChild(self.daoFenShow[i].lose)
        if i == 1 then
            self.daoFenShow[i].lose:setPosition(x+350,y+80)
            self.daoFenShow[i].win:setPosition(x+350,y+80)
        else
            self.daoFenShow[i].lose:setPosition(x+380,y+80)
            self.daoFenShow[i].win:setPosition(x+380,y+80)
        end
       
        if i == 3 then
            self.zPOK = ccui.ImageView:create("views/games/d13/caozuo/wanc.png")
            self.csbNode_:addChild(self.zPOK)
            self.zPOK:setPosition(x+260,y)
        end
        self.cardTypeShow[i] = ccui.ImageView:create("views/games/d13/caozuo/font/roundEnd/23.png")
        self.csbNode_:addChild(self.cardTypeShow[i],2)
        self.cardTypeShow[i]:setPosition(x+260,y)
        self.cardTypeShow[i]:setScale(0.8)
    end
    self:onClearAllHandler_()
end

function NNPlayerView:setScorePos_()
    -- if self.index_ == NNPlayerView.HOST then
    --     self.zhuContent_:setPosition(0, 0)
    -- elseif self.index_ == 4 or self.index_ == 5 or self.index_ == 6 or self.index_ == 7 or self.index_ == 8 then
    --     self.zhuContent_:setPosition(50, -150)
    -- else
    --     self.zhuContent_:setPosition(50, -60)
    -- end
end

function NNPlayerView:onQuickBiaoQing_(event)
    local path = string.format("views/yuyinwenzi/face%d.png", event.info.wordID)
    local sprite = display.newSprite(path):addTo(self.csbNode_):pos(48,0)
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


function NNPlayerView:showText_(wordID)
    dump(self.index_,"self.index_")
    local node = display.newNode():addTo(self.csbNode_)
    local sprite = display.newSprite("res/images/yuyinwenzi/quickChatbg.png"):addTo(node)
    sprite:setCascadeOpacityEnabled(true)
    sprite:setAnchorPoint(ap)
    if self.index_ == 1 then
        node:pos(220,30)
    elseif self.index_ == 2 then
        node:pos(-220+50,30)
        sprite:setScaleX(-1)
    elseif self.index_ == 3 then
        node:pos(-220+50,30)
        sprite:setScaleX(-1)
    elseif self.index_ == 4 then
        node:pos(220,30)
    end
    local word = display.newSprite("res/images/yuyinwenzi/word" .. wordID .. ".png"):addTo(node)
    :pos(0,10)
    local seq = transition.sequence({cc.FadeIn:create(0.5), 
        cc.DelayTime:create(3), 
        cc.FadeOut:create(0.5), 
        cc.CallFunc:create(function ()
            node:removeAllChildren()
            node:removeSelf()
        end)
        })
    node:runAction(seq)
end

return NNPlayerView 
