local PlayerController = import("app.games.ldfpf.controllers.PlayerController")
local ReViewPlayerController = class("ReViewPlayerController", PlayerController)

function ReViewPlayerController:ctor(seatID, maJiangNode)
    assert(seatID and seatID > 0)
    self.player_ = nil
    self.seatID_ = seatID
    self.index_ = seatID
    self.view_ = app:createConcreteView("review.ReVeiwPlayerView", self.index_, maJiangNode):addTo(self)
end

return ReViewPlayerController 
