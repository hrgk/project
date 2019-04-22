local BaseView = require("app.views.BaseView")
local LoadingView = class("LoadingView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")

function LoadingView:ctor(tips, delaySeconds)
    LoadingView.super.ctor(self, tips, delaySeconds)
    local tips = tips or "正在登录游戏..."
    self.msg_:setString(tips)
    if delaySeconds and delaySeconds > 0 then
        self:hide()
        self:performWithDelay(function ()
            self:show()
        end, delaySeconds)
    end
    self:showLoadingAction_()
    self:setMask(150)
end

function LoadingView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/loadingView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function LoadingView:showLoadingAction_()
    local animaData = FaceAnimationsData.getCocosAnimation(26)
    gameAnim.createCocosAnimations(animaData, self.csbNode_)
end

return LoadingView
