local Player = import("..models.Player")
local PlayerController = class("PlayerController", function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    return node
end)

function PlayerController:ctor(seatID, maJiangNode)
    assert(seatID and seatID > 0 and assert(maJiangNode))
    self.player_ = Player.new()
    self.seatID_ = seatID
    self.index_ = seatID
    if setData:getMJHMTYPE()+0  == 1 then
        self.view_ = app:createConcreteView("game.Player2DView", self.index_, maJiangNode):addTo(self)
    else
        self.view_ = app:createConcreteView("game.PlayerView", self.index_, maJiangNode):addTo(self)
    end
end

function PlayerController:getOutCards()
    return self.player_:getChuPai()
end

function PlayerController:setTable(model)
    self.view_:setTable(model)
end

function PlayerController:onEnter()
    -- local handlers = dataCenter:s2cCommandToNames {
    --     {COMMANDS.MJ_CHU_PAI, handler(self, self.onPlayerChuPai_)},
    --     {COMMANDS.MJ_GOLDCHANGED, handler(self, self.onGoldChanged_)},
    -- }
    -- gailun.EventUtils.create(self, dataCenter, self, handlers)

    local handlers = {
        {self.view_.SIT_DOWN_CLICKED, handler(self, self.onSitDownClicked_)},
        {self.view_.ON_AVATAR_CLICKED, handler(self, self.onAvatarClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)
end

function PlayerController:doFlow(...)
    if not self.player_ then
        return
    end
    return self.player_:doFlow(...)
end

function PlayerController:isHost()
    return self.player_:getUid() == selfData:getUid()
end

function PlayerController:updateTingTag(...)
    self.view_:updateTingPaiTag(...)
end

function PlayerController:onExit()
    gailun.EventUtils.clear(self)
end

function PlayerController:onAvatarClicked_(event)
    if self.avatarCallback_ then
        self.avatarCallback_(event.params)
    else
        dump(event.params)
    end
end

function PlayerController:chui(...)
    if not self.player_ then
        return
    end
    self.player_:chui(...)
end

function PlayerController:setOnline(data)
    self.view_:showOnline(data)
    if data.IP and self.player_ then
        self.player_:setIP(data.IP)
    end
end

function PlayerController:showScoreAnim(...)
    if not self.player_ then
        return
    end
    self.player_:showScoreAnim(...)
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

function PlayerController:onPlayerChuPai_(event)
    if not self.player_ then
        return
    end
    if event.data.seatID ~= self.seatID_ then
        return
    end
    self:addChuPai(event.data.card, event.data.dennyAnim)
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

function PlayerController:doTurnto(...)
    if not self.player_ then
        return
    end
    self.player_:doTurnto(...)
end

function PlayerController:getLastChuPaiPos()
    if not self.view_ then
        return 0, 0
    end
    return self.view_:getLastChuPaiPos()
end

function PlayerController:getCardsCount()
    if not self.player_ then
        return 0
    end
    return #self.player_:getCards()
end

function PlayerController:setCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setCards(...)
end

function PlayerController:setOffline(...)
    if not self.player_ then
        return
    end
    self.player_:setOffline(...)
end

function PlayerController:onWin(cardType)
    if cardType then
        self.view_:onWinWithCtype(cardType)
    end
end

function PlayerController:doReconnectStart(isReConnect)
    return self:doEventForce('reconnect', isReConnect)
end

function PlayerController:setIsReady(flag)
    if not self.player_ then
        return
    end
    return self.player_:setIsReady(flag)
end

function PlayerController:setChuPaiCount_(...)
    if not self.player_ then
        return
    end
    self.player_:setChuPaiCount_(...)
end

function PlayerController:showReady_(...)
    if not self.player_ then
        return
    end
    self.player_:showReady_(...)
end

function PlayerController:onSitDownClicked_(event)
    if self.player_ and self.player_:isSitDown() then
        return
    end
    local table = dataCenter:getPokerTable()
    table:onSitDownClicked(self.seatID_)
end

function PlayerController:setPlayer_(player)
    self.player_ = player
    self.view_:onSitDown(self.player_)
end

function PlayerController:clearPlayer_()
    self.player_ = nil
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

function PlayerController:sitDown(seatID, data)
    assert(seatID and seatID > 0 and data and data.uid > 0, 'sitDown fail!')
    data.seatID = seatID
    self:show()
    if self.player_ == nil then
        self.player_ = Player.new()
    end
    self:setPlayer_(self.player_)
    self.player_:setSeatID(seatID)
    self.player_:setIndex(self.index_)
    self.player_:setMulti(data)
    self.player_:sitDown()  -- 等待
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

function PlayerController:getIsChui()
    if not self.player_ then
        return
    end
    self.player_:getIsChui()
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
        print('重连')
    elseif flag == NET_EVENT.OFF_LINE then
        print('掉线')
    elseif flag == NET_EVENT.SLOW then
        print('网络慢')
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

function PlayerController:doRoundStart(isReConnect)
    return self:tryDoEvent_('round_start', isReConnect)
end

function PlayerController:beTurnTo(seconds)
    if not self.player_ then
        return
    end
    self.player_:beTurnTo(seconds)
end

function PlayerController:checkTingPai(...)
    self.player_:checkTingPai(...)
end

function PlayerController:checkOutFold()
    if not self.player_ then
        return
    end
    return self.player_:checkOutData(0, 0)
end

function PlayerController:doCheckOut(result, seconds)
    if not self.player_ then
        return
    end
    self.player_:doCheckOut(result)
    self:performWithDelay(function ()
        self:tryDoEvent_('round_over')
    end, seconds or 0.01)
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

function PlayerController:onActionGang(data)
    if not self.player_ then
        return
    end
    self.player_:onActionGang_(data)
end

function PlayerController:onActionHu(data)
    if not self.player_ then
        return
    end
    self.player_:onActionHu_(data)
end

function PlayerController:onActionPeng(data)
    if not self.player_ then
        return
    end
    self.player_:onActionPeng_(data)
end

function PlayerController:onActionChi(data)
    if not self.player_ then
        return
    end
    self.player_:onActionChi_(data)
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

function PlayerController:setUid(...)
    if not self.player_ then
        return 
    end
    return self.player_:setUid(...)
end

function PlayerController:getAvatarName()
    if not self.player_ then
        return
    end
    return self.player_:getAvatarName()
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

function PlayerController:addMaJiang(...)
    if not self.player_ then
        return
    end
    return self.player_:addMaJiang(...)
end

function PlayerController:onMoPai(...)
    if not self.player_ then
        return
    end
    return self.player_:onMoPai(...)
end

function PlayerController:addChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:addChuPai(...)
end

function PlayerController:addGangPai(...)
    if not self.player_ then
        return
    end
    return self.player_:addGangPai(...)
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

function PlayerController:removeAllCards(...)
    if not self.player_ then
        return
    end
    return self.player_:removeAllCards(...)
end

function PlayerController:setLouHu(...)
    if not self.player_ then
        return
    end
    return self.player_:setLouHu(...)
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

function PlayerController:setChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setChuPai(...)
end

function PlayerController:setReconnectFocusOn(...)
    if not self.player_ then
        return
    end

    return self.player_:setReconnectFocusOn(...)
end

function PlayerController:playRecordVoice( ... )
    if not self.player_ then
        return
    end
    self.player_:playRecordVoice(...)
end

function PlayerController:stopZhuanQuanAction(...)
    if not self.player_ then
        return
    end
    self.player_:stopZhuanQuanAction(...)
end

function PlayerController:zhuanQuanAction(...)
    if not self.player_ then
        return
    end
    self.player_:zhuanQuanAction(...)
end

function PlayerController:doRoundOver(...)
    if not self.player_ then
        return
    end
    self.player_:doRoundOver(...)
end

function PlayerController:getIP()
    if not self.player_ then
        return
    end
    return self.player_:getIP()
end

function PlayerController:playRecordVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:playRecordVoice(...)
end

function PlayerController:stopRecordVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:stopRecordVoice(...)
end

function PlayerController:playVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:playVoice(...)
end

function PlayerController:onGameTG_(...)
    if not self.player_ then
        return
    end
    return self.player_:onGameTG_(...)
end

function PlayerController:isLocked(...)
    if not self.player_ then
        return
    end
    return self.player_:isLocked(...)
end

function PlayerController:checkTingPaiByRemoveCard(...)
    if not self.player_ then
        return
    end
    return self.player_:checkTingPaiByRemoveCard(...)
end

function PlayerController:autoOutCard_(...)
    if not self.player_ then
        return
    end
    return self.player_:autoOutCard_(...)
end

return PlayerController
