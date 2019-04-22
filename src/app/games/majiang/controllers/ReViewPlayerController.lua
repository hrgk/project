local PlayerController = import("app.games.majiang.controllers.PlayerController")
local ReViewPlayerController = class("ReViewPlayerController", PlayerController)

function ReViewPlayerController:ctor(seatID, maJiangNode)
    ReViewPlayerController.super.ctor(self, seatID, maJiangNode)
end

return ReViewPlayerController 
