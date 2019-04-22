local BaseView = import("app.views.BaseView")
local ShareView = class("ShareView", BaseView)

function ShareView:ctor()
    ShareView.super.ctor(self)
    if selfData:getCustomType() == 0 then
        self.gzh_:hide()
        self.weiXin_:setPositionX(self.weiXin_:getPositionX()+50)
        self.pyq_:setPositionX(self.pyq_:getPositionX()-50)
        return
    end
end

function ShareView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/share.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ShareView:weiXinHandler_()
    -- local index = math.random(1, 7)
    -- local title = "【云图辣椒】" .. FENXIANGNEIRONG[index]
    local function callback()
        print("===========weiXinHandler_=================")
    end
    -- display.getRunningScene():shareWeiXin(1, title, "", 0, callback)
    display.getRunningScene():initErWeiView(0, callback)
end

function ShareView:pyqHandler_()
    local function callback()
        print("===========weiXinHandler_=================")
    end
    display.getRunningScene():initErWeiView(1, callback)
end

function ShareView:gzhHandler_()
    local url = StaticConfig:get("shareWXURL")
    local function callback()
        print("===========weiXinHandler_=================")
    end
    display.getRunningScene():shareWeiXin("乐途互娱", "", 0, callback)
end

return ShareView 
