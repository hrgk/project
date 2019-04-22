local TableController = import("app.games.hhqmt.controllers.TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)
local TableModel = import("app.games.hhqmt.models.PokerTable")
local TaskQueue = require("app.controllers.TaskQueue")

function ReViewTableController:ctor(hostPlayer)
    self.table_ = TableModel.new() 
    self:init_()
    self.isTurnStart_ = false
end

function ReViewTableController:doPlayerPass_(data)
    if data.code ~= 0  then
        print("没有轮到你操作")
        return 
    end
    self.actionButtonsController_:hideSelf()
end

function ReViewTableController:init_()
    self.tableView_ = app:createConcreteView("game.TableView", self.table_):addTo(self)

    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = 0
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController"):addTo(self):hide()
    self.actionButtonsController_:setTable(self.table_)
end

function ReViewTableController:doPlayerSitDown(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)
    player:sitDown(playerData, self.table_:isIdle())
    self:resumePlayer_(player, params)
    self:setRoomPlayerCount_()
end

function ReViewTableController:resetPlayer()
    for i,v in ipairs(self.seats_) do
        if v and v:getPlayer() then
            v:getPlayer():gameOver()
        end
    end
end

function ReViewTableController:checkHu()
    
end

function ReViewTableController:setRoomPlayerCount_()
    
end

function ReViewTableController:doRoomInfo(data)
    self.table_:setMaxPlayer(data.config.rules.totalSeat or 3)
    if data.status ~= TABLE_IDLE then
        self.table_:doEventForce("roundstart")
    end
    if data.status == TABLE_CHECKOUT then
        self.table_:doEventForce("roundover")
        for _,v in ipairs(self.seats_) do
            v:doRoundOver()
        end
    end
    self.table_:setTid(data.tid or dataCenter:getRoomID())
    self.table_:setConfigData(data.config)
    self.table_:setOwner(data.creator or 0)
    self.table_:setFinishRound(data.roundIndex or 0,data.config.juShu)
    TaskQueue.removeAll()
    self:doResumeRoomInfo_(data)
end

function ReViewTableController:createSeats_(number)
    self.seats_ = {}
    local number = number or 3 -- 默认3人桌
    for i=1, number do
        self.seats_[i] = ReViewPlayerController.new(i,self.tableView_.nodeHostMaJiang_):addTo(self.nodePlayers_, -i)
    end
end

function ReViewTableController:doUserHu_(data)
    if not data or not data.seatID then
        return
    end 
    if data.isFinish == 0 then
        self.actionButtonsController_:hideSelf()
        self.tableView_:stopTimer()
        return
    end 
end

-- 断线重连
function ReViewTableController:resumePlayer_(player, data)
    player:setIsReady(data.isPrepare)
    player:showReady_(data.isPrepare)
    player:setScore(data.score)
    player:doReconnectStart(true)
    -- 恢复手牌
    local cards = data.shouPai
    player:setDealer(data.dealer, true)
    player:setOffline(data.offline, data.IP)
    self.table_:setReviewHandCards(data.seatID, cards)
end

return ReViewTableController 
