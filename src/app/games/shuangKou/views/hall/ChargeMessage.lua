local BaseLayer = require("app.views.base.BaseDialog")
local ChargeMessage = class("ChargeMessage", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "images/shoufei_message.png", ppx = 0.5, ppy = 0.5 , ap = {0.5, 0.5}},
        -- {type = TYPES.BUTTON, var = "buttonCopy1_", ppx = 0.65, ppy = 0.40, normal = "#tipcopybutton.png", autoScale = 0.9},
        -- {type = TYPES.BUTTON, var = "buttonCopy2_", ppx = 0.65, ppy = 0.34, normal = "#tipcopybutton.png", autoScale = 0.9},
        -- {type = TYPES.BUTTON, var = "buttonCopy3_", ppx = 0.65, ppy = 0.28, normal = "#tipcopybutton.png", autoScale = 0.9},
    }
}

local TIAN_WEIXIN1 = "tianzha6677"
local TIAN_WEIXIN2 = "tianzha9988"
local TIAN_WEIXIN3 = "shenyou9168"

function ChargeMessage:ctor()
    ChargeMessage.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    -- self.buttonCopy1_:onButtonClicked(handler(self, self.onCopy1Clicked_))
    -- self.buttonCopy2_:onButtonClicked(handler(self, self.onCopy2Clicked_))
    -- self.buttonCopy3_:onButtonClicked(handler(self, self.onCopy3Clicked_))
    -- self.content_ = ""
    self:androidBack()
end

function ChargeMessage:onCopy1Clicked_(event)
    self.content_ = TIAN_WEIXIN1
    gailun.native.copy(self.content_)
    app:showTips("复制成功!")
end

function ChargeMessage:onCopy2Clicked_(event)
    self.content_ = TIAN_WEIXIN2
    gailun.native.copy(self.content_)
    app:showTips("复制成功!")
end

function ChargeMessage:onCopy3Clicked_(event)
    self.content_ = TIAN_WEIXIN3
    gailun.native.copy(self.content_)
    app:showTips("复制成功!")
end

return ChargeMessage  
