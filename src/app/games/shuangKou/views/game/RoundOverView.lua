local BaseView = import("app.views.BaseView")
local RoundOverView = class("RoundOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local TaskQueue = require("app.controllers.TaskQueue")
local RoundOverItem = import(".RoundOverItem")

function RoundOverView:ctor(data)
    dump(data,"RoundOverView:ctor")
    RoundOverView.super.ctor(self)
    self:initData_(data.seats, data.rankList)

    self:tanChuang(100)
end

function RoundOverView:initData_(seats,rankList)
    for i=1, 4 do
        local node = self["player" .. i .. "Node_"]
        local item = RoundOverItem.new()
        item:setNode(node)
        item:updateView(seats[i], i, rankList)
    end
end

function RoundOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/shuangkou/roundOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

return RoundOverView 
