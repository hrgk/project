local PlayerView = import("app.views.game.PlayerView")
local NNPlayerView = class("PDKPlayerView", PlayerView)
local PokerList = import("app.views.game.PokerList")
local BaseAlgorithm = import("app.games.niuniu.utils.BaseAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
NNPlayerView.HOST = 1
NNPlayerView.LEFT_UP = 4
NNPlayerView.LEFT_DOWN = 5
NNPlayerView.RIGHT_UP = 3
NNPlayerView.RIGHT_DOWN = 2

local TONG_YONG_NIUNIU = {}
TONG_YONG_NIUNIU[0] = {niu = "wuniu",bei = 1, sound = "niu_0.mp3"}
TONG_YONG_NIUNIU[1] = {niu = "niu1",bei = 1, sound = "niu_1.mp3"}
TONG_YONG_NIUNIU[2] = {niu = "niu2",bei = 1, sound = "niu_2.mp3"}
TONG_YONG_NIUNIU[3] = {niu = "niu3",bei = 1, sound = "niu_3.mp3"}
TONG_YONG_NIUNIU[4] = {niu = "niu4",bei = 1, sound = "niu_4.mp3"}
TONG_YONG_NIUNIU[5] = {niu = "niu5",bei = 1, sound = "niu_5.mp3"}
TONG_YONG_NIUNIU[6] = {niu = "niu6",bei = 1, sound = "niu_6.mp3"}
TONG_YONG_NIUNIU[7] = {niu = "niu7",bei = 2, sound = "niu_7.mp3"}
TONG_YONG_NIUNIU[8] = {niu = "niu8",bei = 2, sound = "niu_8.mp3"}
TONG_YONG_NIUNIU[9] = {niu = "niu9",bei = 2, sound = "niu_9.mp3"}
TONG_YONG_NIUNIU[20] = {niu = "niuniu",bei = 3, sound = "niu_10.mp3"}
TONG_YONG_NIUNIU[25] = {niu = "sunziniu",bei = 5, sound = "niu_11.mp3"}
TONG_YONG_NIUNIU[30] = {niu = "wuniu",bei = 1, sound = "niu_0.mp3"}
TONG_YONG_NIUNIU[40] = {niu = "wuhuaniu",bei = 5, sound = "niu_12.mp3"}
TONG_YONG_NIUNIU[50] = {niu = "tonghuaniu",bei = 6, sound = "niu_13.mp3"}
TONG_YONG_NIUNIU[60] = {niu = "huluniu",bei = 7, sound = "niu_14.mp3"}
TONG_YONG_NIUNIU[70] = {niu = "zadanniu",bei = 8, sound = "niu_15.mp3"}
TONG_YONG_NIUNIU[80] = {niu = "wuxiaoniu",bei = 10, sound = "niu_16.mp3"}
TONG_YONG_NIUNIU[90] = {niu = "tonghuasun",bei = 10, sound = "niu_17.mp3"}
TONG_YONG_NIUNIU[100] = {niu = "daniu",bei = 10, sound = "niu_17.mp3"}

function NNPlayerView:ctor(index)
    NNPlayerView.super.ctor(self, index)
end

function NNPlayerView:addEventListeners_()
    NNPlayerView.super.addEventListeners_(self)
    self.pokers_ = PokerList.new(self.player_:isHost()):addTo(self.pokersContent_)
    if self.player_:isHost() then
        self.pokers_:setPositionY(20)
    end
    self.aniPosY = self.animationContent_:getPositionY()
    cc.EventProxy.new(self.player_, self.csbNode_, true)
    :addEventListener(self.player_.CALL_SCORE, handler(self, self.onCallScoreHandler_))
    :addEventListener(self.player_.MING_PAI, handler(self, self.onMingPaiHandler_))
    :addEventListener(self.player_.KAI_PAI, handler(self, self.onKaiPaiHandler_))
    :addEventListener(self.player_.QIANG_ZHUANG, handler(self, self.onQiangZhuangHandler_))
    :addEventListener(self.player_.SHOW_ZHUANG_KUANG, handler(self, self.onShouZhuangHandler_))
end

function NNPlayerView:onRoomInfo_(event)
    local fanBeiType = event.info.config.rules.fanBeiType
    if fanBeiType == 1 then
        TONG_YONG_NIUNIU[9] = {niu = "niu9",bei = 2, sound = "niu_9.mp3"}
        TONG_YONG_NIUNIU[20] = {niu = "niuniu",bei = 3, sound = "niu_10.mp3"}
    else
        TONG_YONG_NIUNIU[9] = {niu = "niu9",bei = 3, sound = "niu_9.mp3"}
        TONG_YONG_NIUNIU[20] = {niu = "niuniu",bei = 4, sound = "niu_10.mp3"}
    end
    self:initPokerContent_(event.info.config.rules.playerCount)
    self:initZhuContont_(event.info.config.rules.playerCount)
    print("===========pppppppppppp===========")
    self:setScorePos_(event.info.config.rules.playerCount)
    self:initAnimation_()
end

function NNPlayerView:initZhuContont_(totalSeat)
end

function NNPlayerView:initPokerContent_(totalSeat)
    print("============initPokerContent_===========",totalSeat)
    local pokersX = self.pokersContent_:getPositionX()
    local pokersY = self.pokersContent_:getPositionY()
    if self.index_ == NNPlayerView.HOST then
        self.pokersContent_:setPosition(580,5)
        self.pokersContent_:setScale(0.7)
        return
    end
    if totalSeat == 6 then
        if self.index_ == 2 or self.index_ == 3 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-200,0)
        elseif self.index_ == 4 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-30,pokersY-20)
        elseif self.index_ == 5 or self.index_ == 6 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX+140,0)
        end
    elseif totalSeat == 8 then
        self.csbNode_:scale(0.8)
        if self.index_ == 2 or self.index_ == 3 or self.index_ == 4 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-200,0)
        elseif self.index_ == 5 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-30,pokersY-20)
        elseif self.index_ == 7 or self.index_ == 6 or self.index_ == 8 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX+140,0)
        end
    elseif totalSeat == 10 then
        self.csbNode_:scale(0.7)
        if self.index_ == 2 or self.index_ == 3 or self.index_ == 4 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-200,0)
        elseif self.index_ == 5 or self.index_ == 7 or self.index_ == 6 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX-30,pokersY-20)
        elseif self.index_ == 8 or self.index_ == 9 or self.index_ == 10 then
            self.pokersContent_:setScale(0.4)
            self.pokersContent_:setPosition(pokersX+140,0)
        end
    end
end

function NNPlayerView:onShouZhuangHandler_(event)
    self.kuang_:setVisible(event.isShow)
    if event.isShow then
        gameAudio.playSound("res/sounds/niuniu/sound_bankert.mp3")
    end
end

function NNPlayerView:onQiangZhuangHandler_(event)
    if event.callScore == - 1 or event.callScore == 0 then
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
    self.zhuContent_:hide()
end

function NNPlayerView:initAnimation_()
    self.animationContent_ = display.newSprite():addTo(self.csbNode_)
    local x = self.pokersContent_:getPositionX()
    local y = self.pokersContent_:getPositionY()
    if self.index_ == 1 then
        print(self.index_, x, y,"===========initAnimation_===========")
        self.animationContent_:setPosition(x, y+150)
        self.animationContent_:scale(1.5)
    else
        self.animationContent_:setPosition(x, y-20)
    end
    local animaData = FaceAnimationsData.getCocosAnimation(27)
    self.animation_ = gameAnim.createCocosAnimationsTeams(animaData, self.animationContent_)
    self.animationContent_:hide()
end

function NNPlayerView:onRoundHandler_(event)
    dump("onRoundHandler_")
   if event.isShow then
      self.pokers_:showPokers(event.cards)
   end
end

function NNPlayerView:onMingPaiHandler_(event)
    dump(event.cards, "onMingPaiHandler_")
    if event.cards and #event.cards == 0 then
        self.pokers_:removeAllPokers()
    end
    self.pokers_:setNiuNiuMask(false)
    self.pokers_:showPokers(event.cards, false)
    if self.player_:isHost() then
        self.pokers_:setScale(1.2)
    end
end

function NNPlayerView:onKaiPaiHandler_(event)
    if event.isShow == false then
        return
    end
    if event.cards and #event.cards == 0 then
        self.pokers_:removeAllPokers()
        self.animationContent_:hide()
        return
    end
    if #event.cards == 1 then
        self.pokers_:addPokers(event.cards[1])
    else
        self.pokers_:removeAllPokers()
        local maps = BaseAlgorithm.getTenByInCards(clone(event.cards))
        local tempCards = {}
        if #maps ~= 0 then
            for i,v in ipairs(maps) do
                local index = v+1
                table.insert(tempCards, event.cards[index])
            end
            self.pokers_:setNiuNiuMask(true)
            self.pokers_:showPokers(tempCards, false)
        else
            self.pokers_:setNiuNiuMask(false)
            self.pokers_:showPokers(event.cards, false)
        end
    end
    self.animationContent_:show()
    self.animationList_ = TONG_YONG_NIUNIU
    self.animation_:getAnimation():play(self.animationList_[event.niuType].niu)
    gameAudio.playNiuNiuHumanSound(self.animationList_[event.niuType].sound, self.player_:getSex())
    local bei = self.animationList_[event.niuType].bei
    local cards = event.cards
    local addBei = 0
    if event.niuType >= 20 then
        addBei = addBei + (table.indexof(cards, 518) and 1 or 0)
        addBei = addBei + (table.indexof(cards, 520) and 1 or 0)
    end
    self.niuFen_:setString(bei == 1 and "" or ("*" .. (bei + addBei)))
    if self.player_:isHost() then
        self.pokers_:setScale(1.2)
        self.animationContent_:setPositionY(self.aniPosY-100)
    end
end

function NNPlayerView:onCallScoreHandler_(event)
    if event.score == - 1 then
        self.zhu_:setString("")
        self.zhuContent_:hide()
        if self.index_ == NNPlayerView.HOST then
            self.zhuContent_:pos(0,0)
        end
        return
    end
    self.zhu_:setString(event.score)
    self.qiang_:hide()
    self.buqiang_:hide()
    self.qiangFen_:setString("")
    self.zhuContent_:show()
    if self.index_ == NNPlayerView.HOST then
        transition.moveTo(self.zhuContent_, {x=580,y=150, time = 0.1})
    end
    gameAudio.playSound("res/sounds/niuniu/sound_setrategold.mp3")
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
    self:initNiuFen_()
    self:initZhuFen_()
end

function NNPlayerView:initQiangFen_()
    self.qiangFen_ = cc.LabelBMFont:create("", "fonts/niuqiang.fnt")
    self.qiangFen_:setAnchorPoint(0,0.5)
    self.csbNode_:addChild(self.qiangFen_)
    self.qiangFen_:setPosition(50,50)
end

function NNPlayerView:initNiuFen_()
    self.niuFen_ = cc.LabelBMFont:create("*10", "fonts/niuqiang.fnt")
    self.niuFen_:setAnchorPoint(0,0.5)
    self.animationContent_:addChild(self.niuFen_,10)
    self.niuFen_:setPosition(80,0)
end

function NNPlayerView:initZhuFen_()
    self.zhuContent_ = display.newSprite("res/images/game/gold_bg.png")
    local gold = display.newSprite("res/images/game/gold.png"):addTo(self.zhuContent_):pos(15,12)
    self.csbNode_:addChild(self.zhuContent_, 100)
    self.zhu_ = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "This is a PushButton",
            size = 24
        })
    self.zhu_:pos(50,12)
    self.zhuContent_:addChild(self.zhu_)
    self.zhuContent_:hide()
end

function NNPlayerView:setScorePos_(totalSeat)
    if self.index_ == NNPlayerView.HOST then
        self.zhuContent_:setPosition(0, 0)
        return
    end
    if totalSeat == 6 then
        if self.index_ == 2 or self.index_ == 3 or self.index_ == 5 or self.index_ == 6 then
            self.zhuContent_:setPosition(50, -60)
        elseif self.index_ == 4 then
            self.zhuContent_:setPosition(190, 0)
        end
    elseif totalSeat == 8 then
        if self.index_ == 2 or self.index_ == 3 or self.index_ == 4 
            or self.index_ == 8 or self.index_ == 6 or self.index_ == 7 then
            self.zhuContent_:setPosition(50, -60)
        elseif self.index_ == 5 then
            self.zhuContent_:setPosition(190, 0)
        end
    elseif totalSeat == 10 then
        if self.index_ == 2 or self.index_ == 3 or self.index_ == 4 
            or self.index_ == 8 or self.index_ == 9 or self.index_ == 10 then
            self.zhuContent_:setPosition(50, -60)
        elseif self.index_ == 5 or self.index_ == 6 or self.index_ == 7 then
            self.zhuContent_:setPosition(190, 0)
        end
    end
    
end

function NNPlayerView:initYuYinAnimation_()
    self.yuYinContent_ = display.newSprite():addTo(self.csbNode_)
    local animaData = FaceAnimationsData.getCocosAnimation(25)
    gameAnim.createCocosAnimations(animaData, self.yuYinContent_)
    if self.index_ == 1  then
        self.yuYinContent_:setPositionX(110)
    elseif self.index_ == 10 or self.index_ == 9 or self.index_ == 8 
        or self.index_ == 7 or self.index_ == 6 or self.index_ == 5 then
        self.yuYinContent_:setPositionX(110)
    elseif self.index_ == 2 or self.index_ == 4 or self.index_ == 3 then
        self.yuYinContent_:setPositionX(-110)
        self.yuYinContent_:setScaleX(-1)
    end
    self.yuYinContent_:hide()
end

return NNPlayerView 
