local BaseView = import("app.views.BaseView")
local ShopView = class("ShopView", BaseView)
local ShopViewItem = import(".ShopViewItem")
-- sceneIndex1游戏大厅2俱乐部大厅
function ShopView:ctor(date, sceneIndex, type)
    self.cType_ = type
    self:getDate(date)
    ShopView.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self.itemShow = {}
    for i = 1, 6 do
        local item = ShopViewItem.new()
        item:setNode(self["item" .. i .. "_"])
        self.itemShow[i] = item
    end
    self.jbNum_:setString(0)
    self.jfNum_:setString(selfData:getScore())
    self.zbNum_:setString(selfData:getDiamond())
    self.douNum_:setString(selfData:getBiSaiKa())
    self.ybNum_:setString(selfData:getYuanBao())
    self:titleAnimation_()
    self:showType(date.shopShowType)
    self.type2_:removeFromParent()
    if sceneIndex == 1 then
        self.type3_:removeFromParent()
        self.jfIcon_:hide()
        self.douBg_:hide()
        self.douNum_:hide()
        self.ljdIcon_:setPositionY(self.jfIcon_:getPositionY())
        self.jfNum_:setPositionY(self.douNum_:getPositionY())
        self.jfBg_:setPositionY(self.douBg_:getPositionY())
        if self.cType_ == 2 then
            self:type5Handler_()
        else
            self:type1Handler_()
        end
    else
        self.type1_:removeFromParent()
        self.type4_:removeFromParent()

        self.zsBg_:hide()
        self.jfBg_:hide()
        self.zbNum_:hide()
        self.jfNum_:hide()
        self.zsIcon_:hide()
        self.ljdIcon_:hide()
        self:type5Handler_()
    end

    -- self:performWithDelay(function ()
        self.typeListView_:refreshView()
    -- end,0.01)

    if SPECIAL_PROJECT then
        self.type4_:hide()
    end
end

function ShopView:upDateInfo()
    self.jfNum_:setString(selfData:getScore())
    self.zbNum_:setString(selfData:getDiamond())
    self.douNum_:setString(selfData:getBiSaiKa())
end

function ShopView:getPic(id,url)
    local picPath = JFITEM_PATH .. id .. ".jpg"
    local function sucFunc(path)

    end
    local function failFunc()
    end
    local function progressFunc()
    end
    if not io.exists(picPath) then
        HttpApi.download(url, picPath, sucFunc, failFunc, 5, progressFunc)
    end
end

function ShopView:getDate(date)
    dump(date,"ShopView:getDate")
    self.confDate = {}
    for i,v in ipairs(date) do
        if self.confDate[v.Configid] == nil then
            self.confDate[v.Configid] = {}
        end
        if v.Imgpath then
            self:getPic(v.Id,v.Imgpath)
        end
        table.insert(self.confDate[v.Configid],v)
    end
    local douConf = {
        {
            Numbers = 500,
            Prices = 500,
            Id = 500
        },
        {
            Numbers = 1000,
            Prices = 1000,
            Id = 1000
        },
        {
            Numbers = 5000,
            Prices = 5000,
            Id = 5000
        },
        {
            Numbers = 10000,
            Prices = 10000,
            Id = 10000
        }
    }
    self.confDate[5] = douConf
end

function ShopView:titleAnimation_()
    local actions = {}
    local actionHide1 = cc.CallFunc:create(function ()
        self.shangcheng2_:show()
        self.shangcheng1_:hide()
        end)
    local actionDelay1 = cc.DelayTime:create(0.5)
    local actionHide2 = cc.CallFunc:create(function ()
        self.shangcheng1_:show()
        self.shangcheng2_:hide()
        end)
    local actionDelay2 = cc.DelayTime:create(0.5)
    table.insert(actions, actionHide1)
    table.insert(actions, actionDelay1)
    table.insert(actions, actionHide2)
    table.insert(actions, actionDelay2)
    local sequence = transition.sequence(actions)
    self:runAction(cc.RepeatForever:create(sequence))
end

function ShopView:loaderCsb()
    if self.cType_ == 2 then
        self.csbNode_ = cc.uiloader:load("views/shop/shop2.csb"):addTo(self)
    else
        self.csbNode_ = cc.uiloader:load("views/shop/shop.csb"):addTo(self)
    end
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ShopView:fuZhiHandler_()
    gailun.native.copy(StaticConfig:get("goumaizuanshi"))
end

function ShopView:infoHandler_()
    local runScene = display.getRunningScene()
    if runScene.showAddressView then
        runScene:showAddressView()
    end
end

function ShopView:type1Handler_()
    self:showType(1)
    self:updateListView()
    self.type1_:setBright(false)
    self.type1_:setEnabled(false)
end

function ShopView:type2Handler_()
    self:showType(2)
    self:updateListView()
    self.type2_:setBright(false)
    self.type2_:setEnabled(false)
end

function ShopView:type3Handler_()
    self:showType(3)
    self:updateListView()
    self.type3_:setBright(false)
    self.type3_:setEnabled(false)
end

function ShopView:type4Handler_()
    self:showType(4)
    self:updateListView()
    self.type4_:setBright(false)
    self.type4_:setEnabled(false)
end

function ShopView:type5Handler_()
    self:showType(5)
    self:updateListView()
    self.type5_:setBright(false)
    self.type5_:setEnabled(false)
end

function ShopView:updateListView()
    for i,v in pairs({self.type1_, self.type2_, self.type3_, self.type4_, self.type5_}) do
        v:setBright(true)
        v:setEnabled(true)
    end
end

function ShopView:updateInfo(index)
    local data = self.confDate[index] 
    local types = {1,3,1,4,3,6}
    local len = #data
    for i = 1, 6 do
        if i <= len then
            data[i].type = types[index]
            data[i].index = i
            print(self.index, index, types[index])
            self.itemShow[i]:update(data[i])
        else
            self.itemShow[i]:hideItem()
        end
    end
end

function ShopView:showType(index)
    if self.index and self.index == index then
        return 
    end
    self.index = index
    local indexCof = {3,3,5,4,6}
    local btns = {1,3,4}
    self:updateInfo(indexCof[index])
end

return ShopView 
