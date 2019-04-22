local BaseView = import("app.views.BaseView")
local AppMapView = class("AppMapView", BaseView)

function AppMapView:ctor(mianIndex,subIndex)
    AppMapView.super.ctor(self)
    self.mianIndex = mianIndex
    self.subIndex = subIndex
    self:initItemData()
end

function AppMapView:initItemData()
    self.mapItem = {}
    for i,v in ipairs(ADDRESS_MAIN_CONF) do
        self.mapItem[i] = self["adr" ..v.. "_"]
        self.mapItem[i]:setTag(v)
    end
end

function AppMapView:adr1Handler_(item)
    self:updateItem(item)
end

function AppMapView:adr2Handler_(item)
    self:updateItem(item)
end

function AppMapView:adr3Handler_(item)
    self:updateItem(item)
end

function AppMapView:adr4Handler_(item)
    self:updateItem(item)
end

function AppMapView:updateShow(item)
    for i = 1,#self.mapItem do
        self.mapItem[i]:setBright(true)
    end
    item:setBright(false)
end

function AppMapView:updateItem(item)
    local runScene = display.getRunningScene()
    local tagValue = item:getTag()
    if #ADDRESS_SUB_CONF[tagValue] > 0 then
        setData:setAddress(tagValue)
        if runScene.showAppMapSubView then
            runScene:showAppMapSubView(tagValue)
        end
        if runScene.setAddress then
            runScene:setAddress()
        end
        self:removeSelf()
    else
        app:showTips("敬请期待")
    end
end

function AppMapView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/appMap/appMap.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function AppMapView:closeHandler_()
    local runScene = display.getRunningScene()
    if runScene.showAppMapSubView then
        runScene:showAppMapSubView(self.mianIndex,self.subIndex)
    end
    self:removeSelf()
end

return AppMapView 
