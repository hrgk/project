local Player = import("app.games.cdphz.models.Player")
local BaseController = import("app.controllers.BaseController")
local PlayerController = class("PlayerController", BaseController)

function PlayerController:ctor(seatID)
    assert(seatID and seatID > 0)
    self.player_ = Player.new()
    self.seatID_ = seatID
    self.index_ = seatID 
    self.view_ = app:createConcreteView("game.PlayerView", self.index_):addTo(self)
end

function PlayerController:onEnter()
    -- local handlers = dataCenter:s2cCommandToNames {
    --     -- {COMMANDS.GOLDCHANGED, handler(self, self.onGoldChanged_)},
    -- }
    -- gailun.EventUtils.create(self, dataCenter, self, handlers)

    local handlers = {
        {self.view_.SIT_DOWN_CLICKED, handler(self, self.onSitDownClicked_)},
        {self.view_.ON_AVATAR_CLICKED, handler(self, self.onAvatarClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)
end

function PlayerController:setPaperCardList(paperCardList)
    paperCardList:setPlayer(self.player_)
    self.view_:setPaperCardList(paperCardList)
end

function PlayerController:getIP()
    return self.player_:getIP()
end

function PlayerController:getAvatar()
    if not self.player_ then
        return
    end
    return self.player_:getAvatar()
end

function PlayerController:getChuCards()
    if not self.player_ then
        return
    end
    return self.player_:getChuCards()
end

function PlayerController:setUid(...)
    if not self.player_ then
        return
    end
    return self.player_:setUid(...)
end

function PlayerController:clearAllCard()
    if not self.player_ then
        return
    end
    return self.player_:clearAllCard()
end

function PlayerController:getZhuoCards()
    if not self.player_ then
        return
    end
    return self.player_:getZhuoCards()
end

function PlayerController:getMyHandCards()
    if not self.player_ then
        return
    end
    return self.player_:getMyHandCards()
end

function PlayerController:isHost()
    if not self.player_ then
        return
    end
    return self.player_:getUid() == selfData:getUid()
end

function PlayerController:getZhuomianCards()
    if not self.view_ then
        return
    end
    return self.view_:getZhuomianCards()
end

function PlayerController:doChiPai(...)    
    if not self.player_ then
        return
    end
    return self.player_:doChiPai(...)
end
function PlayerController:getHandCards()    
    if not self.view_ then
        return
    end
    return self.view_:getHandCards()
end

function PlayerController:isOutCarding(...)
    if not self.player_ then
        return
    end
    self.player_:isOutCarding(...)
end

function PlayerController:doNotifyHu(...)
    if not self.player_ then
        return
    end
    self.player_:doNotifyHu_(...)
end

function PlayerController:doAllPass(...)
    if not self.player_ then
        return
    end
    self.player_:doAllPass(...)
end

function PlayerController:chupai(...)
    if not self.player_ then
        return
    end
    self.player_:chupai(...)
end

function PlayerController:showMoPai(...)
    if not self.player_ then
        return
    end
    self.player_:showMoPai(...)
end

function PlayerController:shouzhang(...)
    if not self.player_ then
        return
    end
    self.player_:shouzhang(...)
end

function PlayerController:pass(...)
    if not self.player_ then
        return
    end
    self.player_:pass(...)
end

function PlayerController:doMoPai(...)
    if not self.player_ then
        return
    end
    self.player_:doMoPai(...)
end

function PlayerController:showReady_(...)
    if not self.player_ then
        return
    end
    self.player_:showReady_(...)
end

function PlayerController:onExit()
    gailun.EventUtils.clear(self)
end

function PlayerController:onAvatarClicked_(event)
    if self.avatarCallback_ then
        self.avatarCallback_(event.params)
    else
    end
end

function PlayerController:setOffline(...)
    if not self.player_ then
        return
    end
    self.player_:setOffline(...)
end

function PlayerController:getShowParams()
    if not self.player_ then
        return
    end
    return self.player_:getShowParams()
end

function PlayerController:setAvatarCallback(callback)
    self.avatarCallback_ = callback
end

function PlayerController:removeChuPai(card)
    if not self.player_ then
        return
    end
    self.player_:removeCardFromChuPai_(card)
end

function PlayerController:beQiangGang(...)
    if not self.player_ then
        return
    end
    self.player_:beQiangGang(...)
end

function PlayerController:onGoldChanged_(event)
    if not self.player_ then
        return
    end
    
    if self.player_:getNickName() ~= event.data.nickName then
        return
    end

    if self.player_:getUid() == dataCenter:getHostPlayer():getUid() then
        return
    end

    self.player_:setGold(event.data.gold)
end

function PlayerController:getLastChuPaiPos()
    if not self.view_ then
        return 0, 0
    end
    return self.view_:getLastChuPaiPos()
end

function PlayerController:onWin(cardType)
    if cardType then
        self.view_:onWinWithCtype(cardType)
    end
end

function PlayerController:onSitDownClicked_(event)
    if self.player_ and self.player_:isSitDown() then
        return
    end
    local table = dataCenter:getPokerTable()
    table:onSitDownClicked(self.seatID_)
end

function PlayerController:setPlayer_()
    self.view_:bindPlayer(self.player_)
end

function PlayerController:clearPlayer_()
    self.view_:onStandUp()
end

function PlayerController:standUp()
    if not self.player_ then
        return
    end
    self.player_:setGold(0)
    self.player_:removeCards()
    self.player_:forceStandUp()
    self:clearPlayer_()
end

function PlayerController:sitDown(data)
    assert(data and data.seatID > 0 and data.uid > 0, 'sitDown fail!')
    self:show()
    if self.player_ == nil then
        self.player_ = Player.new()
    end
    self:setPlayer_()
    self.player_:setSeatID(seatID)
    self.player_:setIndex(self.index_)
    self.player_:setMulti(data)
    self.player_:sitDown() 
end

function PlayerController:getEmptyPlayerPos(index)
    self.view_:setIndex(index)
end

function PlayerController:sitDownByPlayer(player)
    assert(not self.player_ and player)
    self:show()
    self:setPlayer_(player)
    player:setSeatID(self.seatID_)
    self.player_:setIndex(self.index_)
    self.player_:sitDownJoin()  -- 等待下一轮
end

function PlayerController:getPlayerPosition()
    return self.view_:getPlayerPosition()
end

function PlayerController:getCardsCount()
    if not self.player_ then
        return 0
    end
    return #self.player_:getCards()
end

function PlayerController:getWaiPai()
    if not self.player_ then
        return
    end
    return self.player_:getWaiPai()
end

function PlayerController:getPlayer()
    if not self.player_ then
        return
    end
    return self.player_
end

function PlayerController:getCards()
    if not self.player_ then
        return
    end
    return self.player_:getCards()
end

function PlayerController:filterPokers(cards5)
    return self.view_:filterPokers(cards5)
end

function PlayerController:addGold(gold)
    if not self.player_ then
        return
    end
    return self.player_:addGold(gold)
end

-- flag: 0 = 重连，1 = 掉线， 2 = 网络慢, 3: ??
function PlayerController:onNetEvent_(event)
    local flag, userName = event.data.code, event.data.userName
    if not self.player_ then
        return
    end
    if self.player_:getUserName() ~= userName then
        return
    end
    if flag == NET_EVENT.RE_CONNECT then
        printInfo('重连')
    elseif flag == NET_EVENT.OFF_LINE then
        printInfo('掉线')
    elseif flag == NET_EVENT.SLOW then
        printInfo('网络慢')
    end
end

function PlayerController:isEmpty()
    return (not self.player_ or self.player_:getUid() <= 0)
end

function PlayerController:isPlaying()
    if self:isEmpty() then
        return false
    end
    return self.player_:isPlaying()
end

function PlayerController:doReconnectStart(isReConnect)
    return self:doEventForce('reconnect', isReConnect)
end

function PlayerController:doRoundStart(isReConnect)
    return self:tryDoEvent_('round_start', isReConnect)
end

function PlayerController:doFindPao(...)
    if not self.player_ then
        return
    end
    self.player_:doFindPao((...))
end

function PlayerController:doFindWei(...)
    if not self.player_ then
        return
    end
    self.player_:doFindWei((...))
end

function PlayerController:doFindTi(...)
    if not self.player_ then
        return
    end
    self.player_:doFindTi((...))
end

function PlayerController:doTianHuStart(...)
    if not self.player_ then
        return
    end
    self.player_:doTianHuStart((...))
end

function PlayerController:doTianHuEnd(...)
     if not self.player_ then
        return
    end
    self.player_:doTianHuEnd((...))
end

function PlayerController:checkOutFold()
    if not self.player_ then
        return
    end
    return self.player_:checkOutData(0, 0)
end

function PlayerController:doRoundOver(...)
    if not self.player_ then
        return
    end
    return self.player_:doRoundOver()
end

function PlayerController:onTurnEnd(...)
    if self.player_ then
        self.player_:setTurnBet(0, true)
    end
    return self:tryDoEvent_('turn_end', ...)
end

function PlayerController:doEventForce(eventName, ...)
    if not self.player_ then
        return
    end
    return self.player_:doEventForce(eventName, ...)
end

function PlayerController:tryDoEvent_(eventName, ...)
    if not self.player_ then
        return
    end
    return self.player_:tryDoEvent_(eventName, ...)
end

function PlayerController:doReady(...)
    if not self.player_ then
        return
    end
    self.player_:doReady(...)
end

function PlayerController:doTurnto(...)
    if not self.player_ then
        return
    end
    self.player_:doTurnto(...)
end

function PlayerController:doOtherChiPai(...)
    if not self.player_ then
        return
    end
    self.player_:doOtherChiPai(...)
end


function PlayerController:doOtherPengPai(...)
    if not self.player_ then
        return
    end
    self.player_:doOtherPengPai(...)
end

function PlayerController:doFindChuPai(...)
    if not self.player_ then
        return
    end
    self.player_:doFindChuPai(...)
end

function PlayerController:doPaoPai(...)
    if not self.player_ then
        return
    end
    self.player_:doPaoPai(...)
end

function PlayerController:doPengPai(...)
    if not self.player_ then
        return
    end
    self.player_:doPengPai(...)
end

function PlayerController:doOtherHuPai(...)
    if not self.player_ then
        return
    end
    self.player_:doOtherHuPai(...)
end

function PlayerController:doHuPai(...)
    if not self.player_ then
        return
    end
    self.player_:doHuPai(...)
end

function PlayerController:doChuPai(...)
    if not self.player_ then
        return
    end
    self.player_:doChuPai(...)
end

function PlayerController:doChi(...)
    if not self.player_ then
        return
    end
    self.player_:doChi(...)
end

function PlayerController:doPlayAction(data)
    if not self.player_ then
        return
    end
    if self.player_:getSeatID() ~= data.seatID then
        return
    end
    self.player_:doPlayAction(data)
end

function PlayerController:adjustMaJiang(...)
    self.view_:adjustMaJiang(...)
end

function PlayerController:adjustMaJiangWithoutMoPai(...)
    self.view_:adjustMaJiangWithoutMoPai(...)
end

-- 自己的坐位ID在对象创建后是不允许更改的，可以更改的只是player对象的值
function PlayerController:setSeatID(seatID)
    assert(seatID == self.seatID_)
    if not self.player_ then
        return
    end
    return self.player_:setSeatID(seatID)
end

function PlayerController:setIndex(index)
    self.index_ = index
    if self.player_ then
        self.player_:setIndex(index)
    else
        self.view_:onIndexChanged_({index = index})
    end
end

function PlayerController:getIndex()
    return self.index_
end

function PlayerController:getNickName()
    if not self.player_ then
        return
    end
    return self.player_:getNickName()
end

function PlayerController:getUid()
    if not self.player_ then
        return 0
    end
    return self.player_:getUid()
end

function PlayerController:getSex()
    if not self.player_ then
        return SEX_MALE
    end
    return self.player_:getSex()
end

function PlayerController:bet(...)
    if not self.player_ then
        return 0
    end
    return self.player_:bet(...)
end

function PlayerController:resumeCards(...)
    if not self.player_ then
        return
    end
    return self.player_:resumeCards(...)
end

function PlayerController:setTotalBet(chips)
    if not self.player_ then
        return
    end
    return self.player_:setTotalBet(chips)
end

function PlayerController:setTurnBet(chips)
    if not self.player_ then
        return
    end
    return self.player_:setTurnBet(chips)
end

function PlayerController:setGold(gold)
    if not self.player_ then
        return
    end
    return self.player_:setGold(gold)
end

function PlayerController:setScore(score)
    if not self.player_ then
        return
    end
    return self.player_:setScore(score)
end

function PlayerController:setIsReady(flag)
    if not self.player_ then
        return
    end
    return self.player_:setIsReady(flag)
end

function PlayerController:getIsReady()
    if not self.player_ then
        return
    end
    return self.player_:getIsReady()
end

function PlayerController:setTotalScore(totalScore)
    if not self.player_ then
        return
    end
    return self.player_:setTotalScore(totalScore)
end

function PlayerController:getState()
    if not self.player_ then
        return 0
    end
    return self.player_:getState()
end

function PlayerController:getChips()
    if not self.player_ then
        return 0
    end
    return self.player_:getChips()
end

function PlayerController:getSeatID()
    return self.seatID_
end

function PlayerController:addPoker(...)
    if not self.player_ then
        return
    end
    return self.player_:addPoker(...)
end

function PlayerController:addChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:addChuPai(...)
end

function PlayerController:addWaiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:addWaiPai(...)
end

function PlayerController:safeRemoveCards(...)
    if not self.player_ then
        return
    end
    return self.player_:safeRemoveCards(...)
end

function PlayerController:setLouHu(...)
    if not self.player_ then
        return
    end
    return self.player_:setLouHu(...)
end

function PlayerController:setCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setCards(...)
end

function PlayerController:setZhuoCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setZhuoCards(...)
end

function PlayerController:setChuCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setChuCards(...)
end

function PlayerController:dealCards(...)
    if not self.player_ then
        return
    end
    return self.player_:dealCards(...)
end

function PlayerController:showCards(...)
    if not self.player_ then
        return
    end
    return self.player_:showCards(...)
end

function PlayerController:setWaiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setWaiPai(...)
end

function PlayerController:setPaoPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setPaoPai(...)
end

function PlayerController:setPengPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setPengPai(...)
end

function PlayerController:setChiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setChiPai(...)
end

function PlayerController:setWeiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setWeiPai(...)
end

function PlayerController:setTiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setTiPai(...)
end

function PlayerController:setFirstHandTiPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setFirstHandTiPai(...)
end

function PlayerController:setHuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setHuPai(...)
end

function PlayerController:setChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setChuPai(...)
end

function PlayerController:setChi(...)
    if not self.player_ then
        return
    end
    return self.player_:setChi(...)
end

function PlayerController:setDealer(...)
    if not self.player_ then
        return
    end
    return self.player_:setDealer(...)
end

function PlayerController:getDealer(...)
    if not self.player_ then
        return
    end
    return self.player_:getIsDealer(...)
end

function PlayerController:getScore()
    if not self.player_ then
        return
    end
    return self.player_:getScore()
end

function PlayerController:doFlow(...)
    if not self.player_ then
        return
    end
    return self.player_:doFlow(...)
end

function PlayerController:showRoundOverPoker( ... )
    if not self.player_ then
        return
    end
    return self.player_:showRoundOverPoker(...)
end

function PlayerController:playRecordVoice( ... )
    if not self.player_ then
        return
    end
    self.player_:playRecordVoice(...)
end

return PlayerController, BaseController