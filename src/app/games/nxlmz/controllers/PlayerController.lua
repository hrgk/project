local Player = import("..models.Player")
local BasePlayerController = import("app.controllers.BasePlayerController")
local PlayerController = class("PlayerController", BasePlayerController)

function PlayerController:ctor(params)
    assert(params.seatID and params.seatID > 0)
    self.player_ = Player.new()
    self.player_:setData(params)
    self.seatID_ = params.seatID
    self.index_ = params.seatID
end

function PlayerController:setPlayerParams(params)
    assert(params.seatID and params.seatID > 0)
    self.player_:setData(params)
    self.seatID_ = params.seatID
    self.index_ = params.seatID
end

function PlayerController:getIP()
    return self.player_:getIP()
end

function PlayerController:isHost()
    return self.player_:isHost()
end

function PlayerController:initPlayerView(view)
    self.view_ = view
    self.view_:bindPlayer(self.player_)
end

function PlayerController:setPokerListView(pokerList)
    self.view_:setPokerListView(pokerList)
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

function PlayerController:warning(...)
    if not self.player_ then
        return
    end
    self.player_:warning(...)
end

function PlayerController:pass(...)
    if not self.player_ then
        return
    end
    self.player_:pass(...)
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

function PlayerController:onSitDownClicked_(event)
    if self.player_ and self.player_:isSitDown() then
        return
    end
    local table = dataCenter:getPokerTable()
    table:onSitDownClicked(self.seatID_)
end

function PlayerController:setPlayer_(player)
    self.player_ = player
    self.view_:bindPlayer(self.player_)
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

function PlayerController:sitDown(data)
    -- assert(data and data.seatID > 0 and data.uid > 0, 'sitDown fail!')
    -- self:show()
    local player = self.player_
    if not player then
        if data.uid == dataCenter:getHostPlayer():getUid() then
            player = dataCenter:getHostPlayer()
        else
            player = Player.new()
        end
    end
    dump(data)
    self:setPlayer_(self.player_)
    player:setSeatID(data.seatID)
    self.player_:setIndex(self.index_)
    self.player_:setMulti(data)
    self.player_:sitDown()  -- 等待
    print(self.player_:getUid())
end

function PlayerController:sitDownByPlayer(player)
    assert(not self.player_ and player)
    self:setPlayer_(player)
    player:setSeatID(self.seatID_)
    self.player_:setIndex(self.index_)
    self.player_:sitDownJoin()  -- 等待下一轮
end

function PlayerController:getCardsCount()
    if not self.player_ then
        return 0
    end
    return #self.player_:getCards()
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

function PlayerController:isPlaying()
    if self:isEmpty() then
        return false
    end
    return self.player_:isPlaying()
end

function PlayerController:doChuPai(...)
    if not self.player_ then
        return
    end
    self.player_:doChuPai(...)
end

function PlayerController:doTiShi(...)
    if not self.player_ then
        return
    end
    self.player_:doTiShi(...)
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

function PlayerController:getAvatar()
    if not self.player_ then
        return
    end
    return self.player_:getAvatar()
end

function PlayerController:getSex()
    if not self.player_ then
        return SEX_MALE
    end
    return self.player_:getSex()
end

function PlayerController:setScore(...)
    if not self.player_ then
        return
    end
    self.player_:setScore(...)
end

function PlayerController:getSeatID()
    return self.seatID_
end

function PlayerController:setCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setCards(...)
end

function PlayerController:showCards(...)
    if not self.player_ then
        return
    end
    return self.player_:showCards(...)
end

function PlayerController:setChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setChuPai(...)
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

function PlayerController:showWinFlg(...)
    if not self.player_ then
        return
    end
    self.player_:showWinFlg(...)
end

function PlayerController:setQiangZhuang(...)
    if not self.player_ then
        return
    end
    self.player_:setQiangZhuang(...)
end

function PlayerController:showZhaDanDeFen(...)
    if not self.player_ then
        return
    end
    self.player_:showZhaDanDeFen(...)
end

function PlayerController:playerHeiSan(...)
    if not self.player_ then
        return
    end
    self.player_:playerHeiSan(...)
end

function PlayerController:guanLong(...)
    if not self.player_ then
        return
    end
    self.player_:guanLong(...)
end

function PlayerController:showPokerBack(...)
    if not self.player_ then
        return
    end
    self.player_:showPokerBack(...)
end

function PlayerController:getWarningType()
    if not self.player_ then
        return
    end
    return self.player_:getWarningType()
end

function PlayerController:setIsReady(...)
    if not self.player_ then
        return
    end
    return self.player_:setIsReady(...)
end

function PlayerController:setChuPai(...)
    if not self.player_ then
        return
    end
    return self.player_:setChuPai(...)
end

function PlayerController:setTurnTo(...)
    if not self.player_ then
        return
    end
    return self.player_:setTurnTo(...)
end

function PlayerController:roundOver(...)
    if not self.player_ then
        return
    end
    return self.player_:roundOver(...)
end

function PlayerController:roundStart(...)
    if not self.player_ then
        return
    end
    return self.player_:roundStart(...)
end

function PlayerController:setHandCards(...)
    if not self.player_ then
        return
    end
    return self.player_:setHandCards(...)
end

function PlayerController:getHandCardBack()
    if not self.player_ then
        return
    end
    return self.player_:getHandCardBack()
end

function PlayerController:changeMyPos(...)
    if not self.player_ then
        return
    end
    return self.player_:changeMyPos(...)
end

function PlayerController:reShowHandCards(...)
    if not self.player_ then
        return
    end
    return self.player_:reShowHandCards(...)
end

function PlayerController:removeHandCards(...)
    if not self.player_ then
        return
    end
    return self.player_:removeHandCards(...)
end

function PlayerController:getNextPlayer()
    if not self.player_ then
        return
    end
    return self.player_:getNextPlayer()
end

function PlayerController:getWarningType()
    if not self.player_ then
        return
    end
    return self.player_:getWarningType()
end

function PlayerController:clickTable(event)
    if not self.player_ then
        return
    end
    return self.player_:clickTable(event)
end

function PlayerController:showXianShou(...)
    if not self.player_ then
        return
    end
    return self.player_:showXianShou(...)
end

function PlayerController:showXianShouWord(...)
    if not self.player_ then
        return
    end
    return self.player_:showXianShouWord(...)
end

function PlayerController:startRecordVoice(...)
    if not self.player_ then
        return
    end
    return self.player_:startRecordVoice(...)
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

function PlayerController:setTuoGuan(...)
    if not self.player_ then
        return
    end
    return self.player_:setTuoGuan(...)
end

function PlayerController:isTuoGuan(...)
    if not self.player_ then
        return
    end
    return self.player_:isTuoGuan(...)
end

return PlayerController
