local BaseItem = import("app.views.BaseItem")
local ShopViewItem = class("ShopViewItem", BaseItem)

function ShopViewItem:ctor()
    ShopViewItem.super.ctor(self)
end

function ShopViewItem:setNode(node)
    ShopViewItem.super.setNode(self, node)
    self:initElementRecursive_(self.csbNode_)
    self.yuanPosY = self.chongzhi_:getChildByName("Image_yuan"):getPositionY()
end

function ShopViewItem:update(data)
    self.data = data
    if self.data.type == 4 then
        self.show1_:hide()
        self.show2_:show()
        self:showJFIconView_()
        self:showJFPriceView_()
    elseif self.data.type == 6 then
        self.show1_:show()
        self.show2_:hide()
        if self.tag and not tolua.isnull(self.tag) then
            self.tag:removeFromParent()
        end
        if self.icon and not tolua.isnull(self.icon) then
            self.icon:removeFromParent()
        end
        self:showIconView_()
        self:showPriceView_()
        self:showNumber_()
        self.yuan_:loadTexture("res/images/shop/y.png")
    else
        self.yuan_:loadTexture("res/images/shop/y.png")
        -- self.yuan_:loadTexture("res/images/shop/icon/y0.png")
        self.show1_:show()
        self.show2_:hide()
        if self.tag and not tolua.isnull(self.tag) then
            self.tag:removeFromParent()
        end
        if self.icon and not tolua.isnull(self.icon) then
            self.icon:removeFromParent()
        end
        self:showIconView_()
        self:showPriceView_()
        self:showNumber_()
    end
    self.csbNode_:show()
end

function ShopViewItem:showJFIconView_()
    local picPath = JFITEM_PATH .. self.data.Id .. ".jpg"
    self.jfIcon = ccui.ImageView:create(picPath)
    local size = self.jfIcon:getContentSize()
    self.jfIcon:setScale(223/size.width,142/size.height)
    self.jfIcon:pos(0, 5)
    self.jfContent_:addChild(self.jfIcon)
end

function ShopViewItem:showJFPriceView_()
    self.jfValue_:setString(self.data.Prices)
end

function ShopViewItem:hideItem()
    self.csbNode_:hide()
end

function ShopViewItem:addTag(index)
    if index <= 2 then
        return 
    end
    self.tag = display.newSprite("res/images/shop/icon/addZ" .. index .. ".png")
    self.tag:pos(70, 20)
    self.content_:addChild(self.tag)
end


function ShopViewItem:yuanBaoAddTag(index)
    if index <= 2 then
        return 
    end
    self.tag = display.newSprite("res/images/shop/icon/addZB" .. index .. ".png")
    self.tag:pos(70, 20)
    self.content_:addChild(self.tag)
end

function ShopViewItem:showIconView_()
    local preChar = {"z","j","d","","d","y"}
    local str = preChar[self.data.type] .. self.data.index
    self.icon = display.newSprite("res/images/shop/icon/" .. str .. ".png")
    self.icon:pos(0, -45)
    self.content_:addChild(self.icon)
    if self.data.type == 1 then
        self:addTag(self.data.index)
    elseif self.data.type == 6 then
        -- self:yuanBaoAddTag(self.data.index)
    end
    self.ke_:setVisible(self.data.type ~= 2)
    self.ge_:setVisible(self.data.type == 2)
end

function ShopViewItem:showNumber_()
    if self.zuanShi_ and not tolua.isnull(self.zuanShi_) then
        self.zuanShi_:setString(self.data.Numbers)
    else
        self.zuanShi_ = cc.LabelBMFont:create(self.data.Numbers, "fonts/ssz.fnt")
        self.zuanShi_:setPosition(0, self.ke_:getPositionY()-30)
        self.zuanShi_:setAnchorPoint(1,0.5)
        self.content_:addChild(self.zuanShi_)
    end
end

function ShopViewItem:showPriceView_()
    if self.price_ and not tolua.isnull(self.price_) then
        self.price_:setString(self.data.Prices)
    else    
        self.price_ = cc.LabelBMFont:create(self.data.Prices, "fonts/sxz.fnt")
        self.price_:setPosition(98, self.yuanPosY)
        self.price_:setAnchorPoint(1,0.5)
        self.chongzhi_:addChild(self.price_,10)
    end
end

function ShopViewItem:chongzhiHandler_()
    -- dump(self.data)
    if self.data.type == 6 then
        -- app:showTips("请联系管理员进行充值")
        local params = {
            paytype = 4,
            uid = selfData:getUid(),
            productid = self.data.Prices
        }
        local function callback()
        end
        if device.platform == "android" then
            local function sucHandler(data)
                local info = json.decode(data)
                if info.status == 1 then
                    gailun.native.weChatPay(info.data, callback)
                end
            end
            local function failHandler()
            end
            HttpApi.wxpay(params, sucHandler, failHandler)
            return
        end
        local Sing = crypto.encodeBase64(json.encode(params))
        local url = "http://weixinpay.jingangdp.com/Home/Index?Sing=" .. Sing
        device.openURL(url)
    elseif self.data.type == 1 or self.data.type == 3 then
        local params = {
            paytype = self.data.type,
            uid = selfData:getUid(),
            productid = self.data.Id
        }
        local function callback()
        end
        if device.platform == "android" then
            local function sucHandler(data)
                local info = json.decode(data)
                if info.status == 1 then
                    gailun.native.weChatPay(info.data, callback)
                end
            end
            local function failHandler()
            end
            HttpApi.wxpay(params, sucHandler, failHandler)
            return
        end
        local Sing = crypto.encodeBase64(json.encode(params))
        local url = "http://weixinpay.jingangdp.com/Home/Index?Sing=" .. Sing
        device.openURL(url)
    else
        local function sucHandler(data)
            local info = json.decode(data)
            if info.status == 1 then
                display.getRunningScene():updateDiamonds()
            elseif info.status == -8 then
                app:showTips("元宝不足")
            end
        end
        local function failHandler()
        end

        app:confirm(string.format("是否花费%d元宝,兑换%d钻石", self.data.Prices, self.data.Numbers), function (isOK)
            if  isOK then
                HttpApi.changeYuanBaoToDiamond({count = self.data.Prices}, sucHandler, failHandler)
            end
        end)
    end
end

function  ShopViewItem:chongZhiCallBack_()
    print("===========ShopViewItem:chongZhiCallBack_=============")
end

function ShopViewItem:daiLiHandler_()

end

function ShopViewItem:jfChangeHandler_()
    local params = {
        itemId = self.data.Id
    }
    local function sucHandler(data)
        local info = json.decode(data)
        local runScene = display.getRunningScene()
        if info.status == 1 then
            app:showTips("兑换成功")
            runScene:updateDiamonds()
        elseif info.status == -2 then
            local function goAddress(isOK)    
                if isOK then
                    if runScene.showAddressView then
                        runScene:showAddressView()
                    end
                end
            end
            app:confirm("您没有填写地址信息,是否填写", goAddress)
        elseif info.status == -36 then
            app:showTips("积分不足")
        end
    end
    local function failHandler(data)
        dump(data,"failHandlerinfo")
    end
    HttpApi.jfChange(params, sucHandler, failHandler)
end

return ShopViewItem 
