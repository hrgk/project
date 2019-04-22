local BaseItem = import("app.views.BaseItem")
local BeiShuView = class("BeiShuView", BaseItem)

function BeiShuView:ctor(callfunc)
    self.callfunc_ = callfunc
    BeiShuView.super.ctor(self)
end

function BeiShuView:setVisible(visible)
    self.csbNode_:setVisible(visible)
end

function BeiShuView:bei1Handler_(item)
    if self.callfunc_ then
        self.callfunc_(1)
    end
    self.fanBeiType_ = 1
    self.csbNode_:setVisible(false)
    bcnnData:setFanBeiType(self.fanBeiType_)
end

function BeiShuView:bei2Handler_(item)
    if self.callfunc_ then
        self.callfunc_(2)
    end
    self.fanBeiType_ = 2
    self.csbNode_:setVisible(false)
    bcnnData:setFanBeiType(self.fanBeiType_)
end

function BeiShuView:getFanBeiType()
    return self.fanBeiType_
end

function BeiShuView:setFanBeiType(type)
    self.fanBeiType_ = type
end

return BeiShuView  
