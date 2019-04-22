local PlayerController = import(".PlayerController")
local ReViewPlayerController = class("ReViewPlayerController", PlayerController)

function ReViewPlayerController:ctor(seatID)
    assert(seatID and seatID > 0)
    self.player_ = nil
    self.seatID_ = seatID
    self.index_ = seatID
    self.view_ = app:createConcreteView("review.ReVeiwPlayerView", self.index_):addTo(self)
end

function ReViewPlayerController:initPokerList(gameModel)
    self.view_:initPokerList(gameModel)
end

return ReViewPlayerController 
