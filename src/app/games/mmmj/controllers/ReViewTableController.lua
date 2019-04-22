local TableController = import("app.games.mmmj.controllers.TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)
local BaseAlgorithm = import("app.games.mmmj.utils.BaseAlgorithm")

function ReViewTableController:ctor()
    ReViewTableController.super.ctor(self)
end

function ReViewTableController:createSeats_(number)
    self.seats_ = {}
    local number = number or 3 -- 默认3人桌
    for i=1, number do
        self.seats_[i] = ReViewPlayerController.new(i, self.tableView_.nodeHostMaJiang_):addTo(self.nodePlayers_, -i)
        self.seats_[i]:setTable(self.table_)
    end
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController", self:getGameType()):addTo(self):hide()
    self.actionButtonsController_:setTable(self.table_)
    self.actionButtonsController_:hide()
end

function ReViewTableController:init_()
    self.tableView_ = app:createConcreteView("game.TableView", self.table_):addTo(self)
    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = nil
    self:createSeats_(self.maxPlayer_)
    self.isReview_ = true
end

function ReViewTableController:doRoomInfo(data)
    self.table_:setConfigData(data.config)
    self.table_:setOwner(data.creator or 0)
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setClubID(data.clubID)
    self.table_:setFinishRound(data.roundIndex or 0)
    if data.leftCount then
        local count = data.leftCount or 0
        self.table_:setMaJiangCount(count)
    end
    local isBuGang = (data.lastAct and data.lastAct == CSMJ_ACTIONS.BU_GANG)
    if data.lastCards then
        self:setLastCard_(data.lastSeatID, data.lastCards, isBuGang)
        if #data.lastCards > 1 then
            local player = self:getPlayerBySeatID(data.turn)
            player:setInGangState(true)
        end
    end
    if data.status ~= TABLE_PLAYING then  -- 空闲中
        self:stopAllZhuanQuanAction()
        for k, v in ipairs(self.seats_) do
            v:removeAllCards()
        end
        if data.status == TABLE_CHECKOUT then
            display.getRunningScene():piaoFenSelectHide_()
        end
        return
    end


    self:doResumeRoomInfo_(data)

    if data.isLastCardExist == 1 and data.lastSeatID then
        local player = self:getPlayerBySeatID(data.lastSeatID)
        if player then
            player:setReconnectFocusOn()
        end
    end
end

function ReViewTableController:onHostPlayerTingEvent_(event)

end

function ReViewTableController:doUserChi_(data)
    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    if data.code == -8 then
        return
    end
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        local chiData = {
            action =  CSMJ_ACTIONS.CHI,
            cards = data.operateCards,
            card = data.card,
            dennyAnim = false,
        }
        player:onActionChi(chiData)
    end

    local lastSeatID = data.fromSeatID or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if data.card then
        lastCard = data.card
    end
    if self.seats_[lastSeatID] then
        self.seats_[lastSeatID]:removeChuPai(lastCard)
    end
    self.table_:removeLastCard()
    self:clearFocus_()
    if data.seatID == 1 then
        local player = self:getPlayerBySeatID(1)
        local cards = clone(player:getCards())
        BaseAlgorithm.sort(cards)
        local card = cards[#cards]
        table.remove(cards,#cards)
        self.seats_[data.seatID]:onMoPai(card or 0, isDown, cards)
    else
        self:adjustMaJiang_(data.seatID, false, true)
    end
end

function ReViewTableController:doUserPeng_(data)
    if data.isFinish == 0 then  -- 已收到操作, 隐藏操作栏
        self.actionButtonsController_:hideSelf()
        return
    end
    if data.code == -8 then
        return
    end

    self.actionButtonsController_:hideSelf()
    self.table_:setInPublicTime(false)  -- 公共牌时间结束
    local player = self.seats_[data.seatID]
    if player then
        local pengdata = {
        action =  CSMJ_ACTIONS.PENG,
        cards = {data.card,data.card,data.card},
        dennyAnim = false,
        }
        player:onActionPeng(pengdata)
    end

    local lastSeatID = data.fromSeatID or self.table_:getLastSeatID()
    local lastCard = self.table_:getLastCard()
    if data.card then
        lastCard = data.card
    end
    if self.seats_[lastSeatID] then
        self.seats_[lastSeatID]:removeChuPai(lastCard)
    end
    self.table_:removeLastCard()
    self:clearFocus_() 
    if data.seatID == 1 then
        local player = self:getPlayerBySeatID(1)
        local cards = clone(player:getCards())
        BaseAlgorithm.sort(cards)
        local card = cards[#cards]
        table.remove(cards,#cards)
        self.seats_[data.seatID]:onMoPai(card or 0, isDown, cards)
    else
        self:adjustMaJiang_(data.seatID, false, true)
    end
end

function ReViewTableController:resumePlayer_(player, data)
    local cardCount = checkint(data.countCard)
    if data.judgeInfo and data.judgeInfo.naiZi then
        dataCenter:setIsLaiZi(true)
    end
    player:setOffline(data.offline, data.IP)
    local isDown = data.isDown
    player:showCards(data.handCards, isDown, nil)
    if data.lock then
        player:onGangLock(data.lock)
    end
end

function ReViewTableController:changeUserPosByRule_()
    local rule = self:getRoomConfig()
    -- dump(rule,"rulerule")
    if rule and rule.ruleDetails and rule.ruleDetails.totalSeat and rule.ruleDetails.totalSeat == 2 then
        -- local hostSeatID = 1
        -- local changeTo,changeFrom
        -- if hostSeatID == 1 then
        --     changeTo,changeFrom = 2,3
        -- end
        local formPlayer = self:getPlayerBySeatID(1)
        local toPlayer = self:getPlayerBySeatID(2)
        formPlayer:setIndex(1)
        toPlayer:setIndex(3)
    end
    self:changeUserChuPaiCount_()
    
end

function ReViewTableController:doPlayerSitDown(params)
    self:doPlayerSitDownByInfo(params)
end

return ReViewTableController

