local TableController = import("app.games.hzmajiang.controllers.TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)

function ReViewTableController:ctor(hostPlayer)
    ReViewTableController.super.ctor(self, hostPlayer)
end

function ReViewTableController:createSeats_(number)
    self.seats_ = {}
    local number = number or 3 -- 默认3人桌
    for i=1, number do
        self.seats_[i] = ReViewPlayerController.new(i, self.tableView_.nodeHostMaJiang_):addTo(self.nodePlayers_, -i)
        self.seats_[i]:setTable(self.table_)
    end
end

function ReViewTableController:doPublicTime_(data)
    self.table_:setInPublicTime(true)
    self.table_:setMaJiangCount(data.leftCount)
    for k, v in ipairs(self.seats_) do
        if k ~= data.seatID then
            v:zhuanQuanAction()
        else
            v:stopZhuanQuanAction()
        end
    end
end

function ReViewTableController:resetPlayer()
    for i,v in ipairs(self.seats_) do
        if v and v:getPlayer() then
            v:getPlayer():gameOver()
        end
    end
end

function ReViewTableController:changeUserPosByRule_()
    local rule = self:getRoomConfig()
    dump(rule,"rulerule")
    if rule and rule.ruleDetails and rule.ruleDetails.totalSeat and rule.ruleDetails.totalSeat == 2 then
        local changeTo = 2
        local changeFrom = 3
        local formPlayer = self:getPlayerBySeatID(changeFrom)
        local toPlayer = self:getPlayerBySeatID(changeTo)
        formPlayer:setIndex(self:calcPlayerIndex(changeTo))
        toPlayer:setIndex(self:calcPlayerIndex(changeFrom))
    end
    self:changeUserChuPaiCount_()
end

function ReViewTableController:doResumeRoomInfo_(data)
    if not data.isReview and data.inFlow and data.inFlow > 0  then
        self:showCurrFlow_(data.inFlow, data)
    end
    display.getRunningScene():setBtnIsInGame(false)
end

function ReViewTableController:doPlayerMoPai_(data)
    self.table_:setInPublicTime(false)
    self.table_:setMaJiangCount(data.leftCount)
    self.seats_[data.seatID]:setLouHu(nil)  -- 清空漏胡列表

    self.seats_[data.seatID]:addMaJiang(data.card or 0, data.isDown)

    if data.operates and #data.operates >0 then
        self.actionButtonsController_:showOperates(data.operates, self:getGameType())
    else
        self.actionButtonsController_:hide()
    end
    self:setTurnTo_(data.seatID, 20, nil, true)
end

function ReViewTableController:init_()
     self.tableView_ = app:createConcreteView("game.TableView", self.table_):addTo(self)

    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = nil
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController", self:getGameType()):addTo(self):hide()
    self.actionButtonsController_:setReViewEnable(false)
    self.isReview_ = true
end

return ReViewTableController

