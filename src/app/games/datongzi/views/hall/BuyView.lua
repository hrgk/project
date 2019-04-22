local BaseLayer = import("app.views.base.BaseDialog")
local BuyView = class("BuyView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
{type = TYPES.SPRITE, filename = "images/sz_bg.png", var = "rootLayer_", x = display.cx, y = display.cy,scale9 = true, size = {630, 370}, capInsets = cc.rect(100, 100, 100, 100),
            children = {
                {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.965},
                {type = TYPES.SPRITE, filename = "res/images/common/ts_word.png",ppx = 0.5, ppy = 0.96 ,ap = {0.5,0.5}},
                -- {type = TYPES.LABEL, var = "labelTitleName_", options = {text = "提示", size = 40, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)} ,ppx = 0.5, ppy = 0.905 ,ap = {0.5,0.5}},
                {type = TYPES.LABEL, var = "labelName_1_", options = {text = "", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.1, ppy = 0.6 ,ap = {0,0.5}},
                {type = TYPES.LABEL, var = "labelName_2_", options = {text = "", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.1, ppy = 0.4 ,ap = {0,0.5}},
                {type = TYPES.LABEL, var = "labelName_3_", options = {text = "", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.1, ppy = 0.2 ,ap = {0,0.5}},
                {type = TYPES.LABEL, options = {text = "【微信】", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.55, ppy = 0.6 ,ap = {0,0.5}},
                {type = TYPES.LABEL, options = {text = "【微信】", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.55, ppy = 0.4 ,ap = {0,0.5}},
                {type = TYPES.LABEL, options = {text = "【微信】", font = DEFAULT_FONT, size = 24, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.55, ppy = 0.2 ,ap = {0,0.5}},
                {type = TYPES.SPRITE, filename = "res/images/common/facehline.png", scale9 = true, size = {display.width* 0.45 *WIDTH_SCALE * 0.9, 2}, ppx = 0.5, ppy = 0.52},
                {type = TYPES.SPRITE, filename = "res/images/common/facehline.png", scale9 = true, size = {display.width* 0.45 *WIDTH_SCALE * 0.9, 2}, ppx = 0.5, ppy = 0.32},
                {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closebutton.png",
                    options = {}, ppx = 0.97, ppy = 0.94 },
                {type = gailun.TYPES.BUTTON, var = "buttonCopy_1_", autoScale = 0.9, normal = "images/hall/tipcopybutton.png",
                    options = {}, ppx = 0.82, ppy = 0.6 },
                {type = gailun.TYPES.BUTTON, var = "buttonCopy_2_", autoScale = 0.9, normal = "images/hall/tipcopybutton.png",
                    options = {}, ppx = 0.82, ppy = 0.4 },
                {type = gailun.TYPES.BUTTON, var = "buttonCopy_3_", autoScale = 0.9, normal = "images/hall/tipcopybutton.png",
                    options = {}, ppx = 0.82, ppy = 0.2 },
            }
        },
    }
}

function BuyView:ctor()
    BuyView.super.ctor(self)
    self:addMaskLayer(self, 100)
    gailun.uihelper.render(self, nodes)

    self.buttonClosed_:onButtonClicked(handler(self, self.onClose_))
    self:addButtonEvents_()

    local tips1 = string.format("购买钻石：%s", StaticConfig:get("goumaizuanshi") or '')
    local tips2 = string.format("代理招募：%s", StaticConfig:get("daili1") or "")
    local tips3 = string.format("代理招募：%s", StaticConfig:get("daili2") or "")

    if CHANNEL_CONFIGS.DIAMOND then
        self.labelName_1_:setString(tips1)
    end

    self.labelName_2_:setString(tips2)
    self.labelName_3_:setString(tips3)
    self:androidBack()
    self.rootLayer:hide()
end

function BuyView:setTitle(title)
    -- self.labelTitleName_:setString(title)
end

function BuyView:addButtonEvents_()
    for i = 1 , 3 do
        local function onTouchEnded()
            self:onCopyButtonClicked_(i)
        end
        if i == 1 and not CHANNEL_CONFIGS.DIAMOND then
            self["buttonCopy_" .. i .. "_"]:setVisible(false)
        else
            gailun.uihelper.setTouchHandler(self["buttonCopy_" .. i .. "_"], onTouchEnded)
        end
    end
end

function BuyView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

function BuyView:onCopyButtonClicked_(index)
    local content = StaticConfig:get("goumaizuanshi") or ""
    if 2 == index then
        content = StaticConfig:get("daili1")
    elseif 3 == index then
        content = StaticConfig:get("daili2")
    end
    gailun.native.copy(content)
    app:showTips("复制成功!")
end

return BuyView
