local BaseView = import("app.views.BaseView")
local AppMapSubView = class("AppMapSubView", BaseView)

function AppMapSubView:ctor(mainIndex,subIndex)
    print("AppMapSubView:ctor",mainIndex,subIndex)
    AppMapSubView.super.ctor(self)
    self.mainIndex = mainIndex
    self.subIndex = subIndex
    self:initItemData(mainIndex)
    local str = ADDRESS_FONT[mainIndex]
    if subIndex then
        str = ADDRESS_FONT[mainIndex] .. ADDRESS_FONT[subIndex]
    end
    self.address_:setString(str)
    if subIndex then
        self:updateItem(self.mapItem[table.indexof(ADDRESS_SUB_CONF[mainIndex], subIndex)])
    end
end

function AppMapSubView:initItemData(mainIndex)
    self.mapItem = {}
    for i,v in ipairs(ADDRESS_SUB_CONF[mainIndex]) do
        local subId = v%1000
        self.mapItem[i] = self["item" .. i .. "_"]
        self.mapItem[i]:setTag(v)
        self.mapItem[i]:show()
        self.mapItem[i]:setTouchEnabled(true)
        local path = string.format("views/appMap/subitem/%d/%d.png", mainIndex,subId)
        self.mapItem[i]:loadTexture(path)
    end
end

function AppMapSubView:item1Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:item2Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:item3Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:item4Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:item5Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:item6Handler_(item)
    self:updateItem(item)
end

function AppMapSubView:updateItem(item)
    for i = 1,#self.mapItem do
        self.mapItem[i]:setTouchEnabled(true)
        self.mapItem[i]:removeAllChildren()
    end
    item:setTouchEnabled(false)
    local mask = ccui.ImageView:create("views/appMap/subitem/ItemBg.png")
    mask:setAnchorPoint(0,0)
    mask:setPosition(0,2)
    item:addChild(mask)
    self.tagValue = item:getTag()
    self.address_:setString(ADDRESS_FONT[self.mainIndex] .. ADDRESS_FONT[self.tagValue])
end

function AppMapSubView:changeHandler_()
    local runScene = display.getRunningScene()
    if runScene.showAppMapView then
        runScene:showAppMapView(self.mainIndex,self.subIndex)
    end
    self:closeHandler_()
end

function AppMapSubView:okHandler_()
    if self.tagValue then
        setData:setAddress(self.mainIndex .. ":" .. self.tagValue)
        print(self.mainIndex, self.tagValue)
        createRoomData:setOpenGameList({})
        local runScene = display.getRunningScene()
        if runScene.setAddress then
            runScene:setAddress()
        end
        self:closeHandler_()
    else
        app:showTips("请选择家乡")
    end
end

function AppMapSubView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/appMap/appMapSub.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

return AppMapSubView 
