local PlayerController = import(".PlayerController")
local BaseTableController = import("app.controllers.BaseTableController")
local TableController = class("TableController", BaseTableController)
local PokerTable = import("app.games.dao13.models.PokerTable")
local D13Algorithm = require("app.games.dao13.utils.D13Algorithm")
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
    self.resumePlayerInfo = {}
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

function TableController:onStartCompareCards_()
    self.table_:showGameTips(1)
end

function TableController:clearTableTip()
    self.table_:showGameTips(-1)
end

function TableController:doFanPai(data)
    self.hostPlayer_:kaiPai(data.handCards, data.type, true)
    self.hostPlayer_:setIsKaiPai(true)
    self.table_:showGameTips(6)
    self.table_:setFlow(2)
end

function TableController:setScore(score)
    for i,v in ipairs(self.seats_) do
        print("TableController:setScore",v.player_.score_ + score)
        v.view_.score_:setString(v.player_.score_ + score)
    end
end

function TableController:doKaiPai(data)
    dump(data)
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
    local player = self:getPlayerBySeatID(data.seatId)
    dump(data,"doQiangZhuangdoQiangZhuang")
    player:qiangZhuang(data.callScore)
    if self.qiangZhuangList_[data.callScore] == nil then
        self.qiangZhuangList_[data.callScore] = {}
    end
    table.insert(self.qiangZhuangList_[data.callScore], player)
    if player:isHost() then 
        self.tableView_:hideYZ()
        self.table_:showGameTips(3)
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
    if self.hostSeatID_ == data.seatID then
        if not self:isStanding() then
            self.table_:showGameTips(4)
            self.table_:setFlow(-1)
        end
    end
end

function TableController:onRoundFlow(data)
    if data.flow == 3 then
        self.table_:showGameTips(2)
        self.tableView_:showYZ()
    end
end

function TableController:doDingZhuang(data)
    if self.table_:getConfig().ruleType == 2 then
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
    if tempList == nil or #tempList == 1 then
        local player = self:getPlayerBySeatID(data.dealer)
        player:showZhuangKuang(true)
        if player:isHost() then
            self.table_:showGameTips(4)
        else
            self.table_:showGameTips(3)
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

function TableController:isMyTable()
    return self.table_:isOwner(selfData:getUid())
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
    print("==========self.table_:getStatus()=========",self.table_:getStatus())
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
    end
    self:doResumeRoomInfo_(data)
    if self.hostSeatID_ ~= 1 then
        self.table_:showGameStartBtn(false)
    end
    if self.table_:getClubID() > 0 then
        local player = self:getHostPlayer()
        player:showDouZi()
    end
    for i,v in ipairs(self.seats_) do
        v:setRoomInfo(data)
    end
end

function TableController:showNewPos()
    self.tableView_:showNewPos()
end

function TableController:changeViewByRule(rule)
    self.tableView_:showMPTip(rule.maPai == 1)
end


function TableController:doResumeRoomInfo_(data)
    self:changeViewByRule(data.config.rules)
    local hostPlayer = self:getPlayerBySeatID(self.hostSeatID_)
    self.table_:setOwner(data.creator)
    local function getElementInfoByIndex(arry,sIndex,eIndex)
        local temp = {}
        for i = sIndex,eIndex do
            table.insert(temp,arry[i])
        end
        return temp
    end
    if hostPlayer and data.dealer then
        if data.dealer > 0 then
            local player = self:getPlayerBySeatID(data.dealer)
            player:showZhuangKuang(true)
            self.table_:setDealerSeatID(data.dealer, player:getIndex(),nil,true)
        end
        if data.inFlow  then
            if data.inFlow == 3 then
                if not self.resumePlayerInfo[self.hostSeatID_].isOverQiang then
                    self.table_:showGameTips(2)
                    self.tableView_:showYZ()
                else
                    self.table_:showGameTips(3)
                end
            elseif data.inFlow == 2 then
                if self.resumePlayerInfo[self.hostSeatID_] and self.resumePlayerInfo[self.hostSeatID_].cards 
                    and self.resumePlayerInfo[self.hostSeatID_].type then
                    if self.resumePlayerInfo[self.hostSeatID_].playCards then
                        hostPlayer:showDaoCard(self.resumePlayerInfo[self.hostSeatID_].cards,-1,4)
                        hostPlayer:showZPOK()
                    else
                        local info = {
                            handCards = self.resumePlayerInfo[self.hostSeatID_].cards,
                            type = self.resumePlayerInfo[self.hostSeatID_].type,
                            isReConnect = true,
                        }
                        self.tableView_:showCaoZu(info)
                    end 
                end
                for i,info in pairs(self.resumePlayerInfo) do
                    local info = self.resumePlayerInfo[i]
                    local player = self:getPlayerBySeatID(info.seatID)
                    if not player then
                        printError("onPlayerReady with empty player!")
                        return
                    end
                    player:hideReay()
                    if info.seatID ~= self.hostSeatID_ then
                        if self.resumePlayerInfo[i].playCards then
                            player:showZPOK()
                        else
                            player:showTiaoPai()
                        end
                    end
                end
            elseif data.inFlow >= 5 and data.inFlow <= 7 then
                self:onStartCompareCards_()
                local indexConf = {{1,3},{4,8},{9,13}}
                local hostInfo = self.resumePlayerInfo[self.hostSeatID_]
               
                local scoreValue = {hostInfo.headScore,hostInfo.middleScore,hostInfo.tailScore,hostInfo.specialScore}
                -- dump(scoreValue,"scoreValue")
                for flowValue = 5 ,data.inFlow do
                    local daoIndex = flowValue - 4
                    local showCardCount = 0
                    for i,info in pairs(self.resumePlayerInfo) do
                        local player = self:getPlayerBySeatID(info.seatID)
                        player:showZPOK()
                        player:hideReay()
                        if info.specialType <= 9 then
                            if #info.allShowCards > 0 then
                              
                                local cardData = getElementInfoByIndex(info.allShowCards,indexConf[daoIndex][1],indexConf[daoIndex][2])
                                local daoCardInfo = 
                                {
                                    cards = cardData,
                                    type = D13Algorithm.getCardType(cardData),
                                }
                                player:showDaoCard(daoCardInfo.cards,daoCardInfo.type,daoIndex)
                                showCardCount = showCardCount + 1
                            end
                        else
                            if data.inFlow == 7 then
                                player:showDaoCard(info.allShowCards,info.specialType,4)
                                showCardCount = showCardCount + 1
                            end
                        end
                    end
                    if hostInfo.specialType <= 9 then
                        -- print("XXXXXXXXX",showCardCount,scoreValue[daoIndex])
                        if showCardCount == 4 then
                            if scoreValue[daoIndex] ~= 0 then
                                hostPlayer:showDaoScore(scoreValue[daoIndex],daoIndex)
                            end
                        end
                    else
                        if data.inFlow == 7 and showCardCount == 4 then
                            if scoreValue[4] ~= 0 then
                                hostPlayer:showDaoScore(scoreValue[4],4)
                            end
                        end
                    end
                end
            end
        end
    end
    self.resumePlayerInfo = {}
end

-- 断线重连
function TableController:resumePlayer_(player, data)
    player:setIsReady(data.isPrepare)
    player:setOffline(data.offline)
    -- if self.table_:getTid() and self.table_:getTid() > 0 then
    --     player:setRoomInfo(self.table_:getData())
    -- end
    if data.status ~= 2 then  -- 空闲中
        return
    end
    dump(data,"TableController:resumePlayer_")
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        printError("onPlayerReady with empty player!")
        return
    end
    player:hideReay()
    if data.callDealer >= 0 then
        player:qiangZhuang(data.callDealer)
        data.isOverQiang = true
    end
    self.resumePlayerInfo[data.seatID] = clone(data)
   
end

function TableController:getHostSeatID()
    return self.hostSeatID_
end

function TableController:getCreator()
    return self.table_:getCreator()
end

function TableController:doPlayerSitDown(params)
    if params.seatID == -1 then
        if params.uid == selfData:getUid() then
           self.myStanding = params
        end
    else
        local playerData = params
        local data = json.decode(playerData.data)
        assert(playerData and playerData.seatID, "sitDown fail by error data")
        table.merge(playerData, data)
        local player = PlayerController.new(playerData)
        if player:getUid() == selfData:getUid() then
            self.hostSeatID_ = player:getSeatID() 
            self.hostPlayer_ = player:getPlayer()
            -- self.myStanding = nil
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

function TableController:isStanding()
    return self.myStanding
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

function TableController:getPlayerByUid(uid)
    for i,v in ipairs(self.seats_) do
        if v:getUid() == uid then
            return v
        end
    end
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

function TableController:showReady()
    self.tableView_:showReady()
end

function TableController:stopTimer()
    -- self.tableView_:stopTimer()
end

function TableController:onShowHeadCards_(data)
    for key,value in pairs(data) do
        if key ~= "code" then
            local player = self:getPlayerBySeatID(key + 0)
            player:showDaoCard(value.cards,value.type,1,player:isHost())
            player:showDaoScore(value.score,1)
        end
    end
end

function TableController:onShowMiddleCards_(data)
    for key,value in pairs(data) do
        if key ~= "code" then
            local player = self:getPlayerBySeatID(key + 0)
            player:showDaoCard(value.cards,value.type,2,player:isHost())
            player:showDaoScore(value.score,2)
        end
    end
end

function TableController:onShowTailCards_(data)
    for key,value in pairs(data) do
        if key ~= "code" then
            local player = self:getPlayerBySeatID(key + 0)
            player:showDaoCard(value.cards,value.type,3,player:isHost())
            player:showDaoScore(value.score,3)
        end
    end
end

function TableController:onShowSepcialCards_(data)
    local player = self:getPlayerBySeatID(data.seat_id)
    player:showDaoCard(data.cards,data.type,4)
end

function TableController:onShowHeiLe_(data)
    local info = {
        fromIndex = self:getPlayerBySeatID(data.seat_id):getIndex(),
        type = 3,
    }
    self.table_:showRoundAni(info)
end

function TableController:onShowHongLe_(data)
    dump(data,"TableController:onShowHongLe_")
    local info = {
        fromIndex = self:getPlayerBySeatID(data.seat_id):getIndex(),
        type = 2,
    }
    self.table_:showRoundAni(info)
end

function TableController:onShowDaQiang_(data)
    dump(data,"TableController:onShowDaQiang_")
    local toIndexInfo  = {}
    for i = 1,#data.to do
        toIndexInfo[i] = self:getPlayerBySeatID(data.to[i]):getIndex()
    end
    local info = {
        fromIndex = self:getPlayerBySeatID(data.from):getIndex(),
        toIndex = toIndexInfo,
        type = 1,
    }
    self.table_:showRoundAni(info)
end

function TableController:onShowSepcialScore_(data)
    dump(data,"TableController:onShowSepcialScore_")
    local player = self:getPlayerBySeatID(data.seat_id)
    if player then
        player:showDaoScore(data.score,4)
    end
end

function TableController:onShowPlayerScore_(data)
    dump(data,"TableController:onShowPlayerScore_")
    for key,value in pairs(data) do
        if key ~= "code" then
            local player = self:getPlayerBySeatID(key + 0)
            player:showDaoScore(value.head,1)
            player:showDaoScore(value.middle,2)
            player:showDaoScore(value.tail,3)
        end
    end
end

function TableController:doPlayerChuPai(data)
    dump(data,"TableController:doPlayerChuPai")
    if data.code == -1 then
        app:showTips("倒水,请重新组牌")
        return
    end
    if data.seat_id then
        local player = self:getPlayerBySeatID(data.seat_id)
        if player:isHost() then
            self.tableView_:hideCaoZu()
        end
        player:showZPOK()
    end
    if data.handCards then
        local hostPlayer = self:getPlayerBySeatID(self.hostSeatID_)
        hostPlayer:showDaoCard(data.handCards,-1,4)
        hostPlayer:showZPOK()
    end
end

function TableController:doFaPai(data)
    self:clearTableTip()
    local function showCZ()
        self.tableView_:showCaoZu(data)
        for i,v in ipairs(self.seats_) do
            if not v:isHost() then
                v:showTiaoPai()
            end
            if v:isHost() then
                v:setAnlyScore(data.score)
            end
        end
    end
    if data.dealerSeatID > 0 then
        local player = self:getPlayerBySeatID(data.dealerSeatID)
        if not player then
            return
        end 
        player:showZhuangKuang(true)
        self.table_:setDealerSeatID(data.dealerSeatID, player:getIndex(),data.randomPoker,nil,showCZ)
    else
        showCZ()
    end
end

function TableController:makeRuleString(spliter)
    return self.table_:makeRuleString(spliter or ",")
end

function TableController:clearAll()
    for i,v in ipairs(self.seats_) do
        v:clearAll()
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
    self.tableView_:hideYZ()
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
    self.table_:roundOver()
end

return TableController
