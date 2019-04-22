local BaseElement = import("app.views.BaseElement")

local PullDownContent = class("PullDownContent", BaseElement)

function PullDownContent:ctor()
    PullDownContent.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)

    self.content_:setSwallowTouches(false)
end

function PullDownContent:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/subFloorSet/pullDownContent.csb"):addTo(self)
end

function PullDownContent:update(index, str)
    self.content_:setString(str)
    self.index = index
end

function PullDownContent:setCallback(callback)
    self.callback = callback
end

function PullDownContent:contentHandler_()
    self.callback(self.index, self.content_:getString())
end

return PullDownContent