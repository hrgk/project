local PDKTableView = import("app.games.paodekuai.views.game.PDKTableView")
local ReViewTableView = class("PDKTableView", PDKTableView)
local ReVeiwPlayerView = import(".ReVeiwPlayerView")

function ReViewTableView:ctor(table)
    ReViewTableView.super.ctor(self, table)
    self.shuaXin_:hide()
    self.yaoQing_:hide()
    self.naoZhong_:hide()
    self.headLogic_:hideSub()
    self.buttonHuaYu_:hide()
end

function ReViewTableView:initPlayerSeats()
    self.players_ = {}
    for i=1,3 do
        local playerView = ReVeiwPlayerView.new(i)
        local player = "player" .. i .."_"
        if self[player] then
            playerView:setNode(self[player])
            playerView:setBombLayer(self.csbNode_)
            self.players_[i] = playerView
            self[player]:hide()
        end
    end
end

function ReViewTableView:initYuYin_()

end

return ReViewTableView 
