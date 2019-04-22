local PlayerView = import("app.views.game.PlayerView")
local PDKPlayerView = class("PDKPlayerView", PlayerView)
local PdkAlgorithm = import("app.games.paodekuai.utils.PdkAlgorithm")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local PokerListView = import("app.games.paodekuai.views.game.PokerListView")
local PokerList = import("app.views.game.PokerList")

function PDKPlayerView:ctor(index)
    PDKPlayerView.super.ctor(self, index)
    self.spriteWarning_ = display.newSprite()
    self.spriteWarning_:hide()
end

function PlayerView:getAddPos()
    return 0,self.myPosYAdd
end

function PDKPlayerView:setNode(node)
    PDKPlayerView.super.setNode(self, node)
    self.headInfoList = {
        self.headBg_,
        self.head_,
        self.scoreBg_,
        self.name_,
        self.score_,
        self.xianshou_,
        self.readyFlag_,
        self.offLine_,
        self.defenLabel_,
        self.paiBg_,
        self.animotionContent_,
        self.headNode_,
        self.head_,
    }
    self.headInfoPosY = {}
    for i = 1,#self.headInfoList do 
        self.headInfoPosY[i] = self.headInfoList[i]:getPositionY()
    end
    self.spriteWarning_:addTo(self.headNode_)
    self.myPosY = self.headNode_:getPositionY()
    
    self.myPosYAdd = 0
    self:initWarningPos_()
    local params = {}
    params.filename = "fonts/card_number.png"
    params.options = {text= "15", w = 27, h = 40, startChar = "0"}
    self.cardNumber_ = gailun.uihelper.createLabelAtlas(params):addTo(self.paiBg_):pos(35,50):setAnchorPoint(0.5,0.5)
    self.paiBg_:hide()
    if self.index_ == 1 then
        self:onChangeMyPos_()
    end
end

function PDKPlayerView:initWarningPos_()
    local animaData = FaceAnimationsData.getCocosAnimation(29)
    gameAnim.createCocosAnimations(animaData, self.spriteWarning_)
    if self.index_ == 2 then
        self.spriteWarning_:setPosition(-150, 0)
    else
        self.spriteWarning_:setPosition(150, 0)
    end
end

function PDKPlayerView:addEventListeners_()
    PDKPlayerView.super.addEventListeners_(self)
    cc.EventProxy.new(self.player_, self.csbNode_, true)
    :addEventListener(self.player_.PLAYER_CHUPAI, handler(self, self.onPlayerChuHandler_))
    :addEventListener(self.player_.PASS, handler(self, self.onPassHandler_))
    :addEventListener(self.player_.INIT_HAND_CARDS, handler(self, self.initHandCards_))
    :addEventListener(self.player_.RESET_HAND_CARDS, handler(self, self.reSetHandCards_))
    :addEventListener(self.player_.DO_CHU_PAI, handler(self, self.playerDoChuPai_))
    :addEventListener(self.player_.DO_TI_SHI, handler(self, self.playerDoTiShi_))
    :addEventListener(self.player_.REMOVE_HAND_CARDS, handler(self, self.onRemoveHandCards_))
    :addEventListener(self.player_.WARNING, handler(self, self.onWarningHandler_))
    :addEventListener(self.player_.CLICK_TABLE, handler(self, self.onClickTableHandler_))
    :addEventListener(self.player_.SHOU_XIAN_SHOU, handler(self, self.onXianShouHandler_))
    :addEventListener(self.player_.SHOU_XIAN_SHOU_WORD, handler(self, self.onXianShouWordHandler_))
    :addEventListener(self.player_.ON_ROUND_OVER_SHOW_POKER, handler(self, self.onRoundOverCardsHandler_))
    :addEventListener(self.player_.TURN_TO, handler(self, self.onTurnTo_))
    :addEventListener(self.player_.CHANGE_MY_POS, handler(self, self.onChangeMyPos_))
end

function PDKPlayerView:onChangeMyPos_()
    if setData:getPDKPMTYPE()+0 == 1 then
        self.myPosYAdd = 240
      
    else
        self.myPosYAdd = 0
    end
    for i = 1,#self.headInfoList do
        self.headInfoList[i]:setPositionY(self.headInfoPosY[i]+self.myPosYAdd)
    end    
end

function PDKPlayerView:onTurnTo_(event)
    if event.isBeTurnTo == false then
        return
    end

    if self.pokerList_ ~= nil then
        self.pokerList_:updatePokerStatue()
    end
end

function PDKPlayerView:onRoundOverCardsHandler_(event)
    if event.cards == nil and self.roundOverPoker_ then
        self.roundOverPoker_:removeSelf()
        self.roundOverPoker_ = nil
        return
    end
    if self.player_:isHost() then
        if self.pokerList_ then
            self.pokerList_:showPokers(event.cards,false)
            self.pokerList_:setTouchEnabled(false)
        end
        return
    end
    self.roundOverPoker_ = PokerList.new():addTo(self.csbNode_)
    self.roundOverPoker_:showPokers(event.cards,false)
    self.roundOverPoker_:setScale(0.5)
    if self.index_ == 2 then
        self.roundOverPoker_:setPosition(-250,-80-150)
    elseif self.index_ == 3 then
        self.roundOverPoker_:setPosition(250,-80-150)
    end
end

function PDKPlayerView:onXianShouWordHandler_(event)
    if event.isShow then
        self.csbNode_:performWithDelay(function()
            local animaData = FaceAnimationsData.getCocosAnimation(23)
            gameAnim.createCocosAnimations(animaData, self.animotionContent_)
            self.xianshou_:setVisible(event.isShow)
        end, 1)        
    end
    self.xianshou_:setVisible(event.isShow)
end

function PDKPlayerView:onXianShouHandler_(event)
    if  event.card == -1 then
        if self.xianCard_ then
            self.xianCard_:removeSelf()
            self.xianCard_ = nil
        end
        return
    end
    if event.card then
        self.xianCard_ = display.newSprite("res/images/game/xianshou" .. event.card .. ".png")
        self.xianCard_:setScale(0.5)
        self.headNode_:addChild(self.xianCard_)
        local x = -50
        if self.index_ == 2 then
            self.xianCard_:setPositionX(-x)
        else
            self.xianCard_:setPositionX(x)
        end
    end
end

function PDKPlayerView:onClickTableHandler_(event)
    if self.pokerList_ then 
        local res = self.pokerList_:isInPokers_(event.clickInfo.x, event.clickInfo.y)
        if not res then 
            self.pokerList_:resetPopUpPokers()
        end 
    end
end

function PDKPlayerView:onWarningHandler_(event)
    if event.warningType == - 1 then
        self.spriteWarning_:hide()
        self.paiBg_:hide()
        return
    end 
    if not self.player_:isHost() and event.xianPai == 1 then
        self.cardNumber_:setString(event.warningType)
        self.paiBg_:show()
    else
        self.paiBg_:hide()
    end
    if event.warningType == 1 then
        self.spriteWarning_:show()
        if not event.isReConnect then
            gameAudio.playPDKHumanSound("last.mp3", self.player_:getSex())
        end
    else
        self.spriteWarning_:hide()
    end
end

function PDKPlayerView:onRemoveHandCards_(event)
    if event.cards == nil or #event.cards == 0 then
        return
    end
    self.pokerList_:removePokers(event.cards)
end

function PDKPlayerView:playerDoChuPai_(event)
    local outCards = self.pokerList_:getPopUpPokers()
    if #outCards == 0 then
        return
    end
    local currCards = display.getRunningScene():getCurrCards()
    local data = {cards = outCards}
    if currCards and #currCards == 0 then
        dataCenter:sendOverSocket(COMMANDS.PDK_CHU_PAI, data)
    else
        dataCenter:sendOverSocket(COMMANDS.PDK_CHU_PAI, data)
    end
end

function PDKPlayerView:playerDoTiShi_(event)
    local tempCards = display.getRunningScene():getCurrCards()
    self.pokerList_:tishi(clone(tempCards), display.getRunningScene():getRuleDetails())
end
function PDKPlayerView:reSetHandCards_(event)
    dump("PDKPlayerView:reSetHandCards_")
    if self.pokerList_ == nil or (self.pokerList_ and self.pokerList_:cheackIsBack_()) or event.isNeedReset then 
        dump("PDKPlayerView:reSetHandCards_111")
        self:initHandCards_(event) 
    end
end

function PDKPlayerView:initHandCards_(event)
    local tempCard = nil
    if self.pokerList_ then
        if event.isNeedReset then
            tempCard = self.pokerList_:getCards_()
        end
        self.pokerList_:removeFromParent()
        self.pokerList_ = nil
    end
    if self.pokerList_ == nil then 
        self.pokerList_ = PokerListView.new(self.player_):addTo(self.csbNode_)
        self:clacHandCardPos_()
    end
    self.pokerList_:removeAllPokers()
    self.pokerList_:setTouchEnabled(true)
    if event.isNeedReset then
        event.cards = tempCard
    else
        self.cards = event.cards
    end
   
    if event.isNeedReset then
        if self.isBack ~= nil then
            event.isBack = self.isBack
        end
    else
        self.isBack = event.isBack
    end
    self.pokerList_:showPokers(event.cards,not event.isReConnect,event.isBack)
end

function PDKPlayerView:clacHandCardPos_()
    if self.index_ == 1 then
        self.pokerList_:pos(570, -10)
    end
end

function PDKPlayerView:onPassHandler_(event)
    local animaData = FaceAnimationsData.getCocosAnimation(24)
    gameAnim.createCocosAnimations(animaData, self.animotionContent_)
    local count = math.random(1,4)
    local sound = "buyao" .. count .. ".mp3"
    gameAudio.playPDKHumanSound(sound, self.player_:getSex())
end

function PDKPlayerView:onPlayerChuHandler_(event)
    self.chuPaiContent_:removeAllChildren()
    if event.cards == nil or #event.cards == 0 then return end
    local view = PokerList.new()
    local cards = PdkAlgorithm.sortOutPokers(clone(event.cards),display.getRunningScene():getRuleDetails())
    view:showPokers(clone(cards))
    self:chuPaiAnimotion_(view)
    self.chuPaiContent_:addChild(view)
    local result = PdkAlgorithm.getCardType(clone(event.cards),display.getRunningScene():getRuleDetails())
    self:playSound_(clone(result))
    self:getChuPaiWord_(clone(result))
end

function PDKPlayerView:chuPaiAnimotion_(target)
    local fromScale = 1.2
    local toScale = 0.5
    target:scale(fromScale)
    transition.scaleTo(target, {scale = toScale, time = 0.2,easing = "bounceOut"})
end

function PDKPlayerView:playSound_(result)
    local sound
    if result.cardType == 1 then
        sound = result.value .. ".mp3"
    elseif result.cardType == 2 then
        sound = "d"..result.value .. ".mp3"
    elseif result.cardType == 8 then
        sound = "zhadan.mp3"
        gameAudio.playSound("sounds/zhadanbaozha.mp3")
        local animaData = FaceAnimationsData.getCocosAnimation(7)
        gameAnim.createCocosAnimations(animaData, self.bombLayer_)
    elseif result.cardType == 7 then
        sound = "shunzi.mp3"
        local animaData = FaceAnimationsData.getCocosAnimation(31)
        gameAnim.createCocosAnimations(animaData, self.bombLayer_)
    elseif result.cardType == 4 then
        sound = "sandai2.mp3"
    elseif result.cardType == 3 then
        sound = "liandui.mp3"
    elseif result.cardType == 5 then
        sound = "feiji.mp3"
        local animaData = FaceAnimationsData.getCocosAnimation(30)
        gameAnim.createCocosAnimations(animaData, self.bombLayer_)
    elseif result.cardType == 6 then
        sound = "sidai3.mp3"
    end
    gameAudio.playPDKHumanSound(sound, self.player_:getSex())
end

function PDKPlayerView:setBombLayer(bombLayer)
    self.bombLayer_ = bombLayer
end

function PDKPlayerView:getChuPaiWord_(result)
    local animaData
    if result.cardType == 3 then
        animaData = FaceAnimationsData.getCocosAnimation(19)
    elseif result.cardType == 4 then
        animaData = FaceAnimationsData.getCocosAnimation(20)
    elseif result.cardType == 5 then
        animaData = FaceAnimationsData.getCocosAnimation(18)
    elseif result.cardType == 7 then
        animaData = FaceAnimationsData.getCocosAnimation(22)
    end
    if animaData then
        gameAnim.createCocosAnimations(animaData, self.animotionContent_)
    end
end

function PDKPlayerView:playerWordAnima_(sprite)
    self.animotionContent_:addChild(sprite)
    local fromScale = 1.5
    local toScale = 0.8
    sprite:scale(fromScale)
    self.csbNode_:performWithDelay(function ()
        transition.scaleTo(sprite, {scale = 0.1,onComplete = function() 
                sprite:removeSelf()
        end, time = 0.5,easing = "bounceOut"})
    end, 1.5)
end

function PDKPlayerView:updateRightPlayer_()
    if self.index_ == PlayerView.RIGHT then
        local animotionContentX = self.animotionContent_:getPositionX()
        local animotionContentY = self.animotionContent_:getPositionY()
        self.animotionContent_:setPosition(-animotionContentX, animotionContentY - 80)
        local chuPaiContentX = self.chuPaiContent_:getPositionX()
        local chuPaiContentY = self.chuPaiContent_:getPositionY()
        self.chuPaiContent_:setPosition(-chuPaiContentX, chuPaiContentY - 80)
        local paiBgX = self.paiBg_:getPositionX()
        self.paiBg_:setPositionX(- paiBgX)
    elseif self.index_ == PlayerView.LEFT then
        local animotionContentX = self.animotionContent_:getPositionX()
        local animotionContentY = self.animotionContent_:getPositionY()
        self.animotionContent_:setPosition(animotionContentX, animotionContentY - 80)
        local chuPaiContentX = self.chuPaiContent_:getPositionX()
        local chuPaiContentY = self.chuPaiContent_:getPositionY()
        self.chuPaiContent_:setPosition(chuPaiContentX, chuPaiContentY - 80)
    elseif self.index_ == PlayerView.HOST then
        self.chuPaiContent_:setPosition(550, 230)
        self.animotionContent_:setPosition(550, 230)
    end
end

function PDKPlayerView:bindPlayer(player)
    PDKPlayerView.super.bindPlayer(self, player)
end

return PDKPlayerView 
