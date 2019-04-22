local BaseView = import("app.views.BaseView")

local ShareView = class("ShareView", BaseView)
function ShareView:ctor(data)
    ShareView.super.ctor(self)
    self.data_ = data
end

function ShareView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/gameShare/gameShare.csb"):addTo(self)
end

function ShareView:shareWebHandler_()
    display.getRunningScene():shareOpenWeb(self.data_.roomId,selfData:getUid())
    self:hide()
end

function ShareView:shareWXHandler_()
    display.getRunningScene():gameShareWeiXin(self.data_.name,self.data_.description,self.data_.callback,self.data_.roomId,selfData:getUid())
    self:hide()
end

return ShareView 
