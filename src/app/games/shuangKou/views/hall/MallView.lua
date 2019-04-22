local BaseLayer = require("app.views.base.BaseDialog")
local MallView = class("MallView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
    {type = TYPES.NODE, var = "mainLayer_", size = {display.width, display.height}, ap = {0, 0}, children = {
        {type = TYPES.SPRITE, filename = "images/sz_bg.png", var = "rootLayer_", x = display.cx, y = display.cy,scale9 = true, size = {1000, 540}, capInsets = cc.rect(100, 100, 100, 100),
            children = {
                {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.51, ppy = 0.98, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, filename = "images/mall/mai1.png", ppx = 0.25, ppy = 0.55, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, filename = "images/mall/mai2.png", ppx = 0.5, ppy = 0.55, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, filename = "images/mall/mai3.png", ppx = 0.75, ppy = 0.55, ap = {0.5, 0.5}},

                {type = TYPES.SPRITE, filename = "images/mall/shangcheng.png", ppx = 0.5, ppy = 0.98, ap = {0.5, 0.5}},
                
                {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closebutton.png", 
                    options = {}, ppx = 0.97, ppy = 0.95 },
                {type = TYPES.BUTTON, var = "buttonQueDing1_", autoScale = 0.9, normal = "images/mall/goumai.png", 
                    options = {}, ppx = 0.25, ppy = 0.2 },
                {type = TYPES.BUTTON, var = "buttonQueDing2_", autoScale = 0.9, normal = "images/mall/goumai.png", 
                    options = {}, ppx = 0.5, ppy = 0.2 },
                {type = TYPES.BUTTON, var = "buttonQueDing3_", autoScale = 0.9, normal = "images/mall/goumai.png", 
                    options = {}, ppx = 0.75, ppy = 0.2 },
                
                {type = TYPES.LABEL, var = "price1_", options = {text="1", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.25, ppy = 0.74, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "price2_", options = {text="5", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.5, ppy = 0.74, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "price3_", options = {text="10", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.75, ppy = 0.74, ap = {0.5, 0.5}},

                {type = TYPES.LABEL, var = "number1_", options = {text="2", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.25, ppy = 0.64, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "number2_", options = {text="10", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.5, ppy = 0.64, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "number3_", options = {text="20", size = 35, font = DEFAULT_FONT, color = cc.c3b(0, 0, 0)}, ppx = 0.75, ppy = 0.64, ap = {0.5, 0.5}},


                
            }
        },}
    }}
}

function MallView:ctor()
    MallView.super.ctor(self)
    self:addMaskLayer(self, 100)
    gailun.uihelper.render(self,nodes)

    self.buttonQueDing1_:onButtonClicked(handler(self,self.onQuedingClick1_))
    self.buttonQueDing2_:onButtonClicked(handler(self,self.onQuedingClick2_))
    self.buttonQueDing3_:onButtonClicked(handler(self,self.onQuedingClick3_))
    self.buttonClosed_:onButtonClicked(handler(self,self.onClose_))
    if "ios" == device.platform then
        -- local transactions= dataCenter.IAPWrapper:getAllTransactions()
        -- dump(transactions)
        local products =  dataCenter.IAPWrapper:getProductDetails(IOS_IAP_PRODUCTS[1])
        dump(products)
    end
end

function MallView:onQuedingClick1_(event)
    if dataCenter.IAPWrapper:canMakePurchases() then
        dataCenter.IAPWrapper:purchaseProduct(IOS_IAP_PRODUCTS[1])
    else
        device.showAlert("温馨提示", "IOS内购抽风了暂时不能使用，请稍后再试！", {"ok"})
    end
end

function MallView:onQuedingClick2_(event)
    if dataCenter.IAPWrapper:canMakePurchases() then
        dataCenter.IAPWrapper:purchaseProduct(IOS_IAP_PRODUCTS[2])
    else
        device.showAlert("温馨提示", "IOS内购抽风了暂时不能使用，请稍后再试！", {"ok"})
    end
end

function MallView:onQuedingClick3_(event)
    if dataCenter.IAPWrapper:canMakePurchases() then
        dataCenter.IAPWrapper:purchaseProduct(IOS_IAP_PRODUCTS[3])
    else
        device.showAlert("温馨提示", "IOS内购抽风了暂时不能使用，请稍后再试！", {"ok"})
    end
end

function MallView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

return MallView 
