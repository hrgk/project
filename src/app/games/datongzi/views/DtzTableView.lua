local DtzPlayerController = import(".DtzPlayerController")
local TableView = import(".TableView")
local DtzTableView = class("DtzTableView", TableView)

function DtzTableView:ctor(table)
    DtzTableView.super.ctor(self,table)
end

return DtzTableView   
