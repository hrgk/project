local TableController = import(".TableController")
local ReViewPlayerController = import(".ReViewPlayerController")
local ReViewTableController = class("ReViewTableController", TableController)
local ZMZAlgorithm = import("app.games.nxlmz.utils.ZMZAlgorithm")


function ReViewTableController:ctor(hostPlayer)
    ReViewTableController.super.ctor(self)
end

function ReViewTableController:init_()
    self.tableView_ = app:createConcreteView("review.ReViewTableView", self.table_)
    display.getRunningScene():addGameView(self.tableView_)
end

function ReViewTableController:doPlayerChuPai(data)
    local cards = data.cards
    local player = self:getPlayerBySeatID(data.seatID)
    if not player then
        return
    end
    player:setChuPai(clone(cards))
    self.table_:setCurrCards(clone(cards))
    dump(self.table_:getConfigData())
    local xianPai = self.table_:getConfigData().config.rules.xianPai
    player:warning(data.warning, data.inFastMode, false, xianPai)
    player:removeHandCards(clone(cards))
end

function ReViewTableController:resumePlayer_(player, data)
    player:setOffline(data.offline, data.IP)
    if data.status ~= 2 then  -- 空闲中
        return
    end
    -- -- 恢复手牌
    player:setHandCards(data.shouPai, true)
    player:setIsReady(false)
    -- -- 恢复各种标志
    player:warning(data.warning, false, true, 0)
end

return ReViewTableController 
