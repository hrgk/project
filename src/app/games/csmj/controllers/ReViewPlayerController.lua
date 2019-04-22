local PlayerController = import("app.games.csmj.controllers.PlayerController")
local ReViewPlayerController = class("ReViewPlayerController", PlayerController)

function ReViewPlayerController:ctor(seatID, maJiangNode)
    ReViewPlayerController.super.ctor(self, seatID, maJiangNode)
    self.isReview_ = true
end

return ReViewPlayerController 
