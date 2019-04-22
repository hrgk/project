local BaseView = import("app.views.BaseView")
local SetMJView = class("SetMJView",BaseView)

function SetMJView:ctor()
    SetMJView.super.ctor(self)
    self.perList_ = {}
    self.perList_[1] = self.Select2D_
    self.perList_[2] = self.Select3D_
    self.mjPTypeList_ = {}
    self.mjPTypeList_[1] = self.PML_
    self.mjPTypeList_[2] = self.PMH_
    self:initState_()
end

function SetMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gameSetView/mjSetView.csb"):addTo(self)
end

function SetMJView:initState_()
    for i=1,4 do
        if i == setData:getMJBgIndex() then
            local x,y = self["mjbg"..i.."_"]:getPosition()
            self.mjBgMask_:setPosition(x, y)
        end
    end
    self:onPerspectiveChange_(setData:getMJHMTYPE()+0)
    self:onMJPTypeChange_(setData:getMJPAITYPE()+0)
end

function SetMJView:mjbg1Handler_(item)
    self.mjBgMask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(1)
    setData:setMJBgIndex(1)
end

function SetMJView:mjbg2Handler_(item)
    self.mjBgMask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(2)
    setData:setMJBgIndex(2)
end

function SetMJView:mjbg3Handler_(item)
    self.mjBgMask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(3)
    setData:setMJBgIndex(3)
end

function SetMJView:mjbg4Handler_(item)
    self.mjBgMask_:setPosition(item:getPositionX(), item:getPositionY())
    display.getRunningScene():getTable():setTableSkin(4)
    setData:setMJBgIndex(4)
end


function SetMJView:showMJPTypeChange_(index)
    setData:setMJPAITYPE(index)
    local runScene = display.getRunningScene()
    if runScene.showMJPTypeChange_ then
        runScene:showMJPTypeChange_()
    end
end

function SetMJView:PMLHandler_()
    self:onMJPTypeChange_(1)
    self:showMJPTypeChange_(1)
end

function SetMJView:PMHHandler_()
    self:onMJPTypeChange_(2)
    self:showMJPTypeChange_(2)
end

function SetMJView:onMJPTypeChange_(index)
    for i,v in ipairs(self.mjPTypeList_) do
        self.mjPTypeList_[i]:setEnabled(not (i == index))
        self.mjPTypeList_[i]:setBright(not (i == index))
    end
end

function SetMJView:showPerspectiveChange_(index)
    setData:setMJHMTYPE(index)
    local runScene = display.getRunningScene()
    if runScene.showPerspectiveChange_ then
        runScene:showPerspectiveChange_()
    end
end

function SetMJView:onPerspectiveChange_(index)
    for i,v in ipairs(self.perList_) do
        self.perList_[i]:setEnabled(not (i == index))
        self.perList_[i]:setBright(not (i == index))
    end
end

function SetMJView:Select2DHandler_()
    self:onPerspectiveChange_(1)
    self:showPerspectiveChange_(1)
end

function SetMJView:Select3DHandler_()
    self:onPerspectiveChange_(2)
    self:showPerspectiveChange_(2)
end

function SetMJView:pmTypeHandler_(item)
    local res = item:isSelected()
    setData:setPDKPMTYPE(res and 1 or 0)
    local tableController = display.getRunningScene().tableController_
    if tableController and tableController.doChangePMTYPE_ then
        tableController:doChangePMTYPE_() 
    end
end

return SetMJView 
