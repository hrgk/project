local BaseView = import("app.views.BaseView")
local SetPDKView = class("SetPDKView",BaseView)

function SetPDKView:ctor()
    SetPDKView.super.ctor(self)
    self:initState_()
end

function SetPDKView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gameSetView/pdkSetView.csb"):addTo(self)
end

function SetPDKView:initState_()
    for i=1,4 do
        if i == setData:getPDKBgIndex() then
            local x,y = self["ptbg"..i.."_"]:getPosition()
            self.ptmask_:setPosition(x, y)
        end
    end
    self.pmType_:setSelected(setData:getPDKPMTYPE()+0 == 1)
end

function SetPDKView:pmTypeHandler_(item)
    local res = item:isSelected()
    setData:setPDKPMTYPE(res and 1 or 0)
    local tableController = display.getRunningScene().tableController_
    if tableController and tableController.doChangePMTYPE_ then
        tableController:doChangePMTYPE_() 
    end
end

function SetPDKView:ptbg1Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(1)
    setData:setPDKBgIndex(1)
end

function SetPDKView:ptbg2Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(2)
    setData:setPDKBgIndex(2)
end

function SetPDKView:ptbg3Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(3)
    setData:setPDKBgIndex(3)
end

function SetPDKView:ptbg4Handler_(item)
    self.ptmask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(4)
    setData:setPDKBgIndex(4)
end

return SetPDKView 
