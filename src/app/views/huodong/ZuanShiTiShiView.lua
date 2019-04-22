local BaseView = import("app.views.BaseView")
local ZuanShiTiShiView = class("ZuanShiTiShiView", BaseView)

function ZuanShiTiShiView:ctor(count)
    ZuanShiTiShiView.super.ctor(self)
end

function ZuanShiTiShiView:onLingQuClicked_(event)
    self:onClose_()
end

function ZuanShiTiShiView:rankAnimations_(target, time)
    local sequence1 = transition.sequence({
        cc.ScaleTo:create(time, 1),
        cc.ScaleTo:create(time, 1.1),
        cc.DelayTime:create(0.2),
        })
    local sequence2 = transition.sequence({
        cc.FadeTo:create(time, 128),
        cc.FadeTo:create(time, 255),
        cc.DelayTime:create(0.2),
        })

    target:runAction(cc.RepeatForever:create(sequence1))
    target:runAction(cc.RepeatForever:create(sequence2))
end

function ZuanShiTiShiView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

return ZuanShiTiShiView 
