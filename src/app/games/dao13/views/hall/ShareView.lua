local BaseDialog = import("..base.BaseDialog")
local ShareView = class("ShareView", BaseDialog)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.LAYER, var = "dialogLayer_", children = {
            {type = TYPES.SPRITE, filename = "res/images/sz_bg.png", var = "rootLayer_",px = 0.5, py = 0.5 ,ap = {0.5,0.5},scale9 = true, size = {630, 370}, capInsets = cc.rect(100, 100, 100, 100), children = {
            {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.5, ppy = 0.96},
            {type = TYPES.SPRITE, filename = "res/images/common/fx_word.png", ppx = 0.5, ppy = 0.96 ,ap = {0.5,0.5}},
            {type = TYPES.BUTTON, var = "buttonWeixin_", autoScale = 0.9, normal = "res/images/common/weixin.png", 
                options = {}, ppx = 0.3, ppy = 0.45 },
            {type = TYPES.BUTTON, var = "buttonFriends_", autoScale = 0.9, normal = "res/images/common/pengyouquan.png", 
                options = {}, ppx = 0.7, ppy = 0.45 },
            {type = TYPES.BUTTON, var = "buttonClose_", autoScale = 0.9, normal = "res/images/common/closebutton.png", 
                options = {}, ppx = 0.97, ppy = 0.93 },
            -- {type = TYPES.LABEL, options = {text = "好友/群", font = DEFAULT_FONT, size = 32, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.3, ppy = 0.25 ,ap = {0.5, 0.5}},
            -- {type = TYPES.LABEL, options = {text = "朋友圈", font = DEFAULT_FONT, size = 32, color = cc.c4b(77, 36, 21, 255)} ,ppx = 0.7, ppy = 0.25 ,ap = {0.5, 0.5}},
        }},
    },
    }
}
}

local shareStr = "河池人民最爱的朋来牛鬼游戏，简单好玩，随时随地组局，亲！快快加入吧！猛戳下载！"

function ShareView:ctor()
    local param = {}
    param.size = {600, 360}
    ShareView.super.ctor(self)
    self:addMaskLayer(self, 100)
    gailun.uihelper.render(self, nodes)
    self.buttonWeixin_:onButtonClicked(handler(self, self.onButtonWeixinClicked_))
    self.buttonFriends_:onButtonClicked(handler(self, self.onButtonFriendsClicked_))
    self.buttonClose_:onButtonClicked(handler(self, self.onClose_))
    self.autoRemove_ = true
    self:androidBack()
    self.rootLayer:hide()
end

function ShareView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

function ShareView:onButtonWeixinClicked_(event)
    local url = StaticConfig:get("shareURL") .. "?" .. "shareCode=" .. display.getRunningScene():getShareCode()
    local params = {
        type = "url",
        tagName = "",
        title = "朋来牛鬼",
        description = shareStr,
        imagePath = "res/images/ic_launcher.png",
        url = url or BASE_API_URL,
        inScene = 0,
    }
    gailun.native.shareWeChat(params)
end

function ShareView:onButtonFriendsClicked_(event)
    local url = StaticConfig:get("shareURL") .. "?" .. "shareCode=" .. display.getRunningScene():getShareCode()
    local params = {
        type = "url",
        tagName = "",
        title = shareStr,
        description = shareStr,
        imagePath = "res/images/ic_launcher.png",
        url = url or BASE_API_URL,
        inScene = 1,
    }
    gailun.native.shareWeChat(params)
end

return ShareView
