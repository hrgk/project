local PlayerController = import(".PlayerController")
local BaseTableController = import("app.controllers.BaseTableController")
local TableController = class("TableController", BaseTableController)
local PokerTable = import("app.games.niuniu.models.PokerTable")
local HOST_POSITION_INDEX = 1  -- 主机玩家的位置固定为1号

local ZHUANG = 1
local XIAN = 2

local TABLE_CHECKOUT = 3 --结算中
local TABLE_PLAYING = 2 --游戏进行中
local TABLE_READY = 1 --准备中
local TABLE_IDLE = 0  --空闲

function TableController:ctor()
    self.seats_ = {}
    self.hostSeatID_ = 0
    self.table_ = PokerTable.new()
    self.isTurnStart_ = false
    self.yaoDeQi_ = true
    self.qiangZhuangList_ = {}
end

function TableController:init_(totalSeat)
    self.tableView_ = app:createConcreteView("game.NNTableView", self.table_, totalSeat)
    display.getRunningScene():addGameView(self.tableView_)
end

function TableController:gameStart()
    self.table_:setGameStart(true)
end

function TableController:doDealerKaiPai(data)
    local player = self:getPlayerBySeatID(self.table_:getDealerSeatID())
    if player == nil then return end
    if player:isHost() then return end
    player:kaiPai(data.cards, data.type, true)
end

function TableController:doFanPai(data)
    self.hostPlayer_:kaiPai(data.handCards, data.type, true)
    self.hostPlayer_:setIsKaiPai(true)
    self.table_:showGameTips(6)
    self.table_:setFlow(2)
end

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        v.view_.score_:setString(v.player_.score_ + score)
    end
end

function TableController:doKaiPai(data)
    if data.code ~= 0 then
        app:showTips("等闲家先开牌")
        return
    end
    local player = self:getPlayerBySeatID(data.seatID)
    if player and player:isHost() then 
        self.table_:showGameTips(7)
        self.table_:setFlow(-1)
        if player:isKaiPai() then
            player:setIsKaiPai(false)
            return
        end
    end
    player:kaiPai(data.cards, data.type, true)
end

function TableController:doQiangZhuang(data)
    if data.code ~= 0 then
        app:showTips("等待其他玩家抢庄")
        return
    end
    local player = self:getPlayerBySeatID(data.seatID)
    player:qiangZhuang(data.callScore)
    if self.qiangZhuangList_[data.callScore] == nil then
        self.qiangZhuangList_[data.callScore] = {}
    end
    table.insert(self.qiangZhuangList_[data.callScore], player)
    if player:isHost() then 
        self.table_:showGameTips(2)
        self.table_:setFlow(-1)
    end
end

function TableController:doCanCallList(data)
    self.table_:setFlow(1, data.score)
end

function TableController:sitDownHide()
    self.tableView_:sitDownHide()
end

function TableController:sitDownShow()
    self.tableView_:sitDownShow()
end

function TableController:doCallScore(data)
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return 
    end
    player:setCallScore(data.callScore)
    player:setTurnTo(false)
    self.table_:setFlow(4)
    if self.hostSeatID_ == data.seatID then
        if self:isStanding() then
            self.table_:showGameTips(4)
            self.table_:setFlow(-1)
        end
    end
end

function TableController:onRoundFlow(data)
    if data.flow == 3 then
        self.table_:showGameTips(1)
        self.table_:setFlow(3)
    end
    if data.flow == 2 and self.hostPlayer_ then
        local ruleType = self.table_:getConfigData().config.ruleType
        if ruleType == 5 then
            self.table_:setFlow(4)
            self.table_:showGameTips(5)
        elseif self.hostPlayer_:getRealCount() == 4 then
            self.table_:setFlow(4)
            self.table_:showGameTips(5)
        elseif self.hostPlayer_:getRealCount() == 5 then
            self.table_:setFlow(2)
            self.table_:showGameTips(6)
        end
    end
end

function TableController:doDingZhuang(data)
    self.table_:showGameTips(-1)

    if self.table_:getConfig().ruleType == 5 then
        return
    elseif self.table_:getConfig().ruleType == 2 then
        local player = self:getPlayerBySeatID(data.dealer)
        if not player then
            return
        end 
        player:showZhuangKuang(true)
        if player:isHost() then
            self.table_:showGameTips(4)
        else
            self.table_:showGameTips(3)
        end
        self.table_:setDealerSeatID(data.dealer, player:getIndex())
        return
    end
    local tempKey = 0
    for k,v in pairs(self.qiangZhuangList_) do
        if tempKey < k then
            tempKey = k
        end
    end
    local actions = {}
    local index = 1
    local tempList = self.qiangZhuangList_[tempKey]
    if tempList == nil or #tempList == 1 or #tempList == 0 then
        -- if data.dealer == -1 then
        --     return
        -- end
        local player = self:getPlayerBySeatID(data.dealer)
        player:showZhuangKuang(true)
        if player:isHost() then
            self.table_:showGameTips(4)
        else
            self.table_:showGameTips(3)
        end
        for i,v in ipairs(self.seats_) do
            if v:getSeatID() ~= data.dealer then
                v:qiangZhuang(-1)
            end
        end
        self.table_:setDealerSeatID(data.dealer, player:getIndex())
        self.qiangZhuangList_ = {}
        return
    end
    for i=1,12 do
        table.insert(actions, cc.CallFunc:create(function ()
            if index > #tempList then
                index = 1
            end
            for i,v in ipairs(tempList) do
                v:showZhuangKuang(false)
            end
            tempList[index]:showZhuangKuang(true)
            index = index + 1
        end))
        table.insert(actions, cc.DelayTime:create(0.1))
    end
    table.insert(actions, cc.CallFunc:create(function ()
            for i,v in ipairs(tempList) do
                v:showZhuangKuang(false)
            end
            for i,v in ipairs(self.seats_) do
                v:qiangZhuang(-1)
            end
            local player = self:getPlayerBySeatID(data.dealer)
            player:showZhuangKuang(true)
            if player:isHost() then
                self.table_:showGameTips(3)
            else
                self.table_:showGameTips(4)
            end
            self.table_:setDealerSeatID(data.dealer, player:getIndex())
            self.qiangZhuangList_ = {}
        end))
    self.tableView_:runAction(transition.sequence(actions))
end

function TableController:doPlayerStateChanged(data)
    local player = self:getPlayerBySeatID(data.seatID)
    player:setOffline(data.offline)
end

function TableController:doRoundStart(data)
    self.table_:roundStart()
    self.table_:roundChange(data.seq)
    self.table_:setStatus(2)
    for i,v in ipairs(self.seats_) do
        v:roundStart()
    end
end

function TableController:setHostPlayerState(offline)
    if self.hostPlayer_ then
        self.hostPlayer_:setOffline(offline, self.hostPlayer_:getIP())
    end
end

function TableController:getSeats()
    return self.seats_
end

function TableController:setRoomPlayerCount_()
    local count = 0
    for k,v in pairs(self.seats_) do
        if v:getPlayer() then
            count = count + 1
        end
    end
    self.table_:setCurrPlayerCount(count)
end

function TableController:clearSeats()
    self.seatsTemp = clone(self.seats_)
    for k,v in pairs(self.seats_) do
        v:mingPai({})
        v.player_:levelRoom()
        self.seats_[v:getSeatID()] = nil
    end
    self.table_:setCurrPlayerCount(0)
end

function TableController:doLeaveRoom(data)
    local player = self:getPlayerById(data.uid)
    if not player then
        return
    end
    player:levelRoom()
    self.seats_[player:getSeatID()] = nil
    self:setRoomPlayerCount_()
end

function TableController:doPlayerPass(data)
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    player:pass(data.inFastMode)
end

function TableController:doPlayerStateChanged(data)
    local player = self:getPlayerById(data.uid)
    if not player then
        return
    end
    player:setOffline(data.offline, data.IP)
end

function TableController:onPlayerChat_(uid, params)
    local player, toPlayer
    if params.seatID then
        player = self.seats_[params.seatID]
    end
    if params.toSeatID then
        toPlayer = self.seats_[params.toSeatID]
    end
    if not player then
        player = self:getPlayerById(uid)
    end
    if not player then
        print("TableController:onPlayerChat_(uid, params) fail!!!!")
        return
    end
    self.tableView_:showPlayerChat(player, params, toPlayer)
end

function TableController:onPlayerReady(data)
    if self.hostSeatID_ == data.seatID then
        self.tableView_:sitDownHide()
        self.tableView_.ready_:hide()
    end

    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        printError("onPlayerReady with empty player!")
        return
    end
    player:setIsReady(data.isPrepare)
    if self:showGameStart_() then
        if self.hostSeatID_ == 1 then
            self.table_:showGameStartBtn(true)
        end
    end
end

function TableController:getUserCount()
    return self.table_:getCurrPlayerCount()
end

function TableController:showGameStart_()
    if self.table_:getStatus() == 2 then 
        return
    end
    local count = 0
    for i,v in ipairs(self.seats_) do
        if v:isReady() then
            count = count + 1
        end
    end
    if count == self.table_:getCurrPlayerCount() and count ~= 1 then
        return true
    else
        return false
    end
end

function TableController:doPreRoomInfo(data)
    local totalSeat = data.totalSeat

    self.table_:setPlayerCount(totalSeat)

    self:init_(totalSeat)
end

function TableController:doRoomInfo(data)
    self.table_:setData(data)
    if data.status == 2 or data.status==3 then
        self.table_:setGameStart(true, data.inFlow)
        if data.status == 3 then
            self.table_:showGameTips(8)
        end
    end
    for i,v in ipairs(self.seats_) do
        v:setRoomInfo(data)
        if v:getSeatID() ~= data.dealer then
            v:qiangZhuang(-1)
        end
    end
    self:doResumeRoomInfo_(data)
    if self.hostSeatID_ ~= 1 then
        self.table_:showGameStartBtn(false)
    end
    if self.table_:getClubID() > 0 then
        local player = self:getHostPlayer()
        -- 观战时没有豆子
        if player == nil then
            return
        end
        player:showDouZi()
    end
    for i,v in ipairs(self.seats_) do
        if v:getSeatID() ~= data.dealer then
            v:qiangZhuang(-1)
        end
    end
end

function TableController:setTempSeats()
    self.seats_ = clone(self.seatsTemp)
    for i,v in ipairs(self.seats_) do
        if not v:isHost() and v.player_.status_ > 1 then
            v:mingPai({-1,-1,-1,-1})
        else
            v:mingPai({})
        end
    end
end

function TableController:showCard_()
    for i,v in ipairs(self.seats_) do
        if not v:isHost() and v.player_.status_ > 1 then
            v:mingPai({-1,-1,-1,-1})
        else
            v:mingPai({})
        end
    end
end

function TableController:showNewPos()
    self.tableView_:showNewPos()
end

function TableController:doResumeRoomInfo_(data)
    dump(data,"==============doResumeRoomInfo_=============")
    local hostPlayer = self:getPlayerBySeatID(self.hostSeatID_)
    if data.dealer and data.dealer > 0 then
        local player = self:getPlayerBySeatID(data.dealer)
        player:showZhuangKuang(true)
        self.table_:setDealerSeatID(data.dealer, player:getIndex())
    end

    if hostPlayer and data.dealer and data.dealer > 0 then
        if data.inFlow  then
            if data.inFlow == 1 then
                if hostPlayer:getCallScore() == - 1 and hostPlayer:getSeatID() ~= data.dealer then
                    self.table_:setFlow(data.inFlow, hostPlayer:getCanCallScore())
                    self.table_:showGameTips(3)
                elseif hostPlayer:getSeatID() == data.dealer then
                    self.table_:showGameTips(4)
                end
                for i,v in ipairs(self.seats_) do
                    if v:isHost() then
                        local cards = v:getCards() or {}
                        if #cards == 4 then
                            v:mingPai(v:getCards())
                        elseif #cards == 0 then
                            v:mingPai({-1,-1,-1,-1,-1})
                        else
                            v:mingPai({})
                        end
                    else
                        if self:hostNeedShowCard() then
                            if v.player_.status_ > 1 then
                                v:mingPai({-1,-1,-1,-1})
                            end
                        end
                    end
                end               
            elseif data.inFlow == 3 then
            elseif data.inFlow == 2 then
                for i,v in ipairs(self.seats_) do
                    dump(v:getCards(), "noshit")
                    print("isHost", v:isHost())
                    if v:isHost() then
                        if v:getCards() and #v:getCards() then
                            if #v:getCards() == 4 then
                                v:mingPai(v:getCards())
                                self.table_:setFlow(4)
                                self.table_:showGameTips(5)
                            elseif #v:getCards() == 0 then
                                v:mingPai({-1,-1,-1,-1,-1})
                            elseif v:getCards()[1] == -1 then
                                v:mingPai({-1,-1,-1,-1,-1})
                            else
                                v:kaiPai(v:getCards(), v:getNiuType(), true)
                                if v:isShowCards() then
                                    self.table_:setFlow(-1)
                                    self.table_:showGameTips(7)
                                elseif v:getCards()[5] ~= -1 then
                                    self.table_:setFlow(2)
                                    -- self.table_:showGameTips(6)
                                else
                                    self.table_:setFlow(4)
                                    self.table_:showGameTips(6)
                                end
                            end
                        else
                            v:mingPai({-1,-1,-1,-1,-1})
                            self.table_:setFlow(4)
                        end
                    else
                        if v:isShowCards() then
                            v:kaiPai(v:getCards(), v:getNiuType(), true)
                        else
                            if self:hostNeedShowCard() then
                                if v.player_.status_ > 1 then
                                    v:mingPai({-1,-1,-1,-1})
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        if data.inFlow then
            self.table_:showGameTips(1)
            self.table_:setFlow(data.inFlow)
            for i,v in ipairs(self.seats_) do
                if v:isHost() and v:getCards() and #v:getCards() then
                    if #v:getCards() == 4 then
                        v:mingPai(v:getCards())
                    elseif #v:getCards() == 0 then
                        v:mingPai({-1,-1,-1,-1,-1})
                    end
                else
                    v:mingPai({-1,-1,-1,-1,-1})
                end
            end
    
        else
            self.table_:roundOver()
        end
    end
end

-- 断线重连
function TableController:resumePlayer_(player, data)
    player:setIsReady(data.isPrepare)
    player:setOffline(data.offline)
    if self.table_:getTid() and self.table_:getTid() > 0 then
        player:setRoomInfo(self.table_:getData())
    end

    if data.status ~= 2 then  -- 空闲中
        return
    end
    player:setIsReady(false)
    player:setNiuType(data.type)
    player:setCards(data.cards)
    if data.canCallScore and #data.canCallScore > 0 then
        player:setCanCallScore(data.canCallScore)
    end
    -- -- 恢复各种标志
    player:qiangZhuang(data.callDealer, true)
    player:setCallScore(data.callScore)
    player:setShowCards(data.showCards)
end

function TableController:getHostSeatID()
    return self.hostSeatID_
end

function TableController:getCreator()
    return self.table_:getCreator()
end

function TableController:doPlayerSitDown(params)
    if params.seatID == -1 then
        if params.uid ~= selfData:getUid() then
            return
        end
        self.myStanding = params
    else
        local playerData = params
        local data = json.decode(playerData.data)
        assert(playerData and playerData.seatID, "sitDown fail by error data")
        table.merge(playerData, data)
        local player = PlayerController.new(playerData)
        if player:getUid() == selfData:getUid() then
            self.hostSeatID_ = player:getSeatID() 
            self.hostPlayer_ = player:getPlayer()
            if self:isStanding() then
                self:clearStanding()
            end
        elseif self:isStanding() and self.hostSeatID_ == 0 then
            self.hostSeatID_ = playerData.seatID
            self.hostPlayer_ = player:getPlayer()
        end
        self.seats_[params.seatID] = player
        self:setPlayerIndex_(self.hostSeatID_, player)
        self:resumePlayer_(player, params)
        self:setRoomPlayerCount_()
    end
end

function TableController:clearStanding()
    if self.hostPlayer_ then
        self.myStanding = nil
    end
end

function TableController:getStandingInfo()
    return self.myStanding
end

function TableController:isStanding()
    return self.myStanding ~= nil
end

function TableController:getHostPlayer()
    return self.hostPlayer_
end

function TableController:hostNeedShowCard()
    if not self.hostPlayer_ then
        return true
    end
    if self.hostPlayer_ and not self.hostPlayer_.cards_ then
        return true
    end
    return false
end

function TableController:getHostPlayerIsReady()
    if self.hostPlayer_ and self.hostPlayer_.isReady_ and self.hostPlayer_.isReady_ then
        return true
    end
    return false
end

function TableController:setPlayerIndex_(hostSeatID, player)
    local view
    if hostSeatID == seatID then
        player:setIndex(1)
        view = self.tableView_:getPlayerView(1)
        player:initPlayerView(view)
        player:roundStart()
        return
    end
    local index = 1 + (player:getSeatID() - hostSeatID)
    local totalSeat = self.table_:getPlayerCount()
    if index > totalSeat then
        index = index - totalSeat
    elseif index < 1 then
        index = index + totalSeat
    end
    player:setIndex(index)
    view = self.tableView_:getPlayerView(index)
    player:initPlayerView(view)
    player:roundStart()
end

function TableController:getPlayerBySeatID(seatID)
    return self.seats_[seatID]
end

function TableController:getPlayerByIndex(index)
    for i,v in ipairs(self.seats_) do
        if v:getIndex() == index then
            return v
        end
    end
    return
end

function TableController:getPlayerById(id)
    if not id or id <= 0 then
        return
    end
    for _,v in pairs(self.seats_) do
        if v and v:getUid() == id then
            return v
        end
    end
end

function TableController:listeningAvatarClicked(callback)
    for _,v in ipairs(self.seats_) do
        v:setAvatarCallback(callback)
    end
end

function TableController:stopTimer()
    -- self.tableView_:stopTimer()
end

function TableController:doFaPai(data)
    if self.myStanding then
        self:showCard_()
    else
        if data.code == 0 then
            for i,v in ipairs(self.seats_) do
                if v:isHost() then
                    if #data.handCards == 4 then
                        v:mingPai(data.handCards)
                    elseif #data.handCards == 0 then
                        v:mingPai({-1,-1,-1,-1,-1})
                    else
                        v:kaiPai(data.handCards, data.type, false)
                    end
                    if self.table_:getDealerSeatID() == v:getSeatID() then
                        self.table_:showGameTips(4)
                    else
                        self.table_:showGameTips(3)
                    end
                else
                    if self.table_:getRuleDetails().zhuangType == 4 then
                        if #data.handCards ~= 1 then
                            v:mingPai({-1,-1,-1,-1})
                        end
                    end
                end
            end
        end
    end
end

-- 结算过程
function TableController:doRoundOver(data)
    self.table_:roundOver(data)
    for _,v in ipairs(data.seats) do
        local player = self:getPlayerBySeatID(v.seatID)
        if not player then
            break
        end
        player:roundOver()
    end
end

function TableController:doGameOver(data)
    printInfo("TableController:doGameOver")
    self:clearFocus_()
end

function TableController:setCurrCards(...)
    self.table_:setCurrCards(...)
end

function TableController:getCurrCards()
    return self.table_:getCurrCards()
end

function TableController:initCards(...)
    self.table_:initCards(...)
end

function TableController:showPlayController(...)
    self.table_:showPlayController(...)
end

function TableController:setTurnTo(...)
    self.table_:setTurnTo(...)
end

function TableController:clearFocus_()
end

function TableController:resetPopUpPokers()
    self.tableView_:resetPopUpPokers()
end

function TableController:goldFly(winnerIndex, loses)
    self.table_:goldFly(winnerIndex, loses)
end

function TableController:getTable()
    return self.table_
end

function TableController:nextStart()
    self.table_:showGameTips(8)
    self.table_:roundOver()
end

return TableController
