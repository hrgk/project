local TableController = import(".TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)
local PdkAlgorithm = import("app.games.paodekuai.utils.PdkAlgorithm")


function ReViewTableController:ctor(hostPlayer)
    self.table_ = dataCenter:getPokerTable()
    self.table_:setController(self)
    self.hostPlayer_ = hostPlayer
    self:init_()
    self.isTurnStart_ = false
end

function ReViewTableController:init_()
    self.tableView_ = app:createConcreteView("review.ReViewTableView", self.table_):addTo(self)
    self.nodePlayers_ = self.tableView_.nodePlayers_
    self.maxPlayer_ = self.table_:getMaxPlayer()
    self.hostSeatID_ = nil
    self:createSeats_(self.maxPlayer_)
    self.actionButtonsController_ = app:createConcreteController("ActionButtonsController"):addTo(self):hide()
end

-- function ReViewTableController:doRoomInfo(data)
--     ReViewTableController.super.doRoomInfo(data)
--     for i,v in ipairs(self.seats_) do
--         v:initPokerList(data.config.gameMode)
--     end
-- end

function ReViewTableController:doPlayerSitDown(params)
    local playerData = params
    local data = json.decode(playerData.data)
    assert(playerData and data.uid and playerData.seatID, "sitDown fail by error data")
    table.merge(playerData, data)
    local player = self:getPlayerBySeatID(params.seatID)
    player:sitDown(playerData, self.table_:isIdle())
    self:resumePlayer_(player, params)
    -- self:setRoomPlayerCount_()
     if self.selfID_ == player:getUid() then
        self.hostPlayer_ = player:getPlayer()
    end
end

function ReViewTableController:doHunCard(data)
    self.table_:showHunPai(data.hunCard)
    local obj = NiuGuiAlgorithm.getHunPai(data.hunCard)
    self.table_:setShangXiaHun(obj)
    self.table_:setDealerSeatID(data.dealerSeatID)
    self.tableView_:showDealerAtIndex_(data.dealerSeatID)
    self.tableView_.buttonRank_:hide()
end

function ReViewTableController:resetPlayer()
    for i,v in ipairs(self.seats_) do
        if v and v:getPlayer() then
            v:getPlayer():gameOver()
        end
    end
end

function ReViewTableController:createSeats_(number)
    self.seats_ = {}
    local number = number or 3 -- 默认3人桌
    for i=1, number do
        self.seats_[i] = ReViewPlayerController.new(i):addTo(self.nodePlayers_, -i)
    end
end

-- 断线重连
function ReViewTableController:resumePlayer_(player, data)
    ReViewTableController.super.resumePlayer_(self, player, data)
end

return ReViewTableController 
