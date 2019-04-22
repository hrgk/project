local BaseView = import("app.views.BaseView")
local SetNNView = class("SetNNView",BaseView)

function SetNNView:ctor()
    SetNNView.super.ctor(self)
    self:initState_()
end

function SetNNView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gameSetView/nnSetView.csb"):addTo(self)
end

function SetNNView:initState_()
    for i=1,4 do
        if i == setData:getNNBgIndex() then
            local x,y = self["ptbg"..i.."_"]:getPosition()
            self.ptmask_:setPosition(x, y)
        end
    end
end

function SetNNView:ptbg1Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(1)
    setData:setNNBgIndex(1)
end

function SetNNView:ptbg2Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(2)
    setData:setNNBgIndex(2)
end

function SetNNView:ptbg3Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(3)
    setData:setNNBgIndex(3)
end

function SetNNView:ptbg4Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(4)
    setData:setNNBgIndex(4)
end

return SetNNView 
