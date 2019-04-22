-- 回访码弹窗界面
local ReviewScene = require("app.scenes.ReviewScene")

local BaseLayer = require("app.views.base.BaseLayer")
local RecordSharedView = class("RecordSharedView", BaseLayer)
local TYPES = gailun.TYPES

local layerBg = {
                type = TYPES.ROOT,
                children = {
                    {type = TYPES.LAYER, var = "layerbg_", size = {display.width * WIDTH_SCALE, display.height * HEIGHT_SCALE}},
                }
            }   

local nodeBg = {
        type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "images/hall/msgbg.png", var = "bg_", scale9 = true, size = {display.width * 0.97 * WIDTH_SCALE, display.height * 0.82 * HEIGHT_SCALE}, ppx = 0.5, ppy = 0.43, ap = {0.5, 0.5}},
        }
    }

local nodeTitle = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "images/hall/lookbackbg.png", var = "imgbg_", children = {
            {type = TYPES.SPRITE, filename = "images/hall/hall_bg9.png", scale9 = true, size = {display.width * 0.88 * WIDTH_SCALE, display.height /14 * HEIGHT_SCALE} , ppx = 0.5, ppy = 0.93},
            {type = TYPES.LABEL, options = {text = "序号", size = 28, color = cc.c4b(77, 36, 21, 0), font = DEFAULT_FONT}, ppx = 0.04, ppy = 0.93 ,ap = {0.5 ,0.5}},
            {type = TYPES.SPRITE, filename = "images/hall/rankfgx.png", ppx = 0.085, ppy = 0.93 ,scale9 = true, size = {2, 40}},

            {type = TYPES.LABEL, options = {text = "对战时间", size = 28, color = cc.c4b(77, 36, 21, 0), font = DEFAULT_FONT}, ppx = 0.16, ppy = 0.93 ,ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "images/hall/rankfgx.png", ppx = 0.24, ppy = 0.93 ,scale9 = true, size = {2, 40}},
            
            {type = TYPES.LABEL, var = "playerName1_",options = {text = "玩家昵称1", size = 28, color = cc.c4b(77, 36, 21, 0), font = DEFAULT_FONT}, ppx = 0.33, ppy = 0.93 ,ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "images/hall/rankfgx.png", ppx = 0.42, ppy = 0.93 ,scale9 = true, size = {2, 40}},

            {type = TYPES.LABEL, var = "playerName2_",options = {text = "玩家昵称2", size = 28, color = cc.c4b(77, 36, 21, 0), font = DEFAULT_FONT}, ppx = 0.51, ppy = 0.93 ,ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "images/hall/rankfgx.png", ppx = 0.6, ppy = 0.93 ,scale9 = true, size = {2, 40}},

            {type = TYPES.LABEL, var = "playerName3_",options = {text = "玩家昵称3", size = 28, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 0)} ,ppx = 0.69, ppy = 0.93 ,ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "images/hall/rankfgx.png", ppx = 0.78, ppy = 0.93 ,scale9 = true, size = {2, 40}},

            {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/closebutton.png", 
                    options = {}, ppx = 1, ppy = 0.98 },
        }, scale9 = true, size = {display.width * 0.88 * WIDTH_SCALE, display.height * 0.7 * HEIGHT_SCALE}, ppx = 0.5, ppy = 0.43}
    }
}
local nodeItem = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "images/hall/hall_bg29.png", scale9 = true, size = {display.width * 0.88 * WIDTH_SCALE, display.height /10 * HEIGHT_SCALE} , ppx = 0.5, ppy = 0.63, children = {
            {type = gailun.TYPES.LABEL, var = "labelNumber_", options = {text = "", size = 28, color = cc.c4b(177, 66, 37, 0), font = DEFAULT_FONT} ,ppx = 0.03, ppy = 0.5, ap = {0,0.5}},
            {type = gailun.TYPES.LABEL, var = "labelFightTime_", options = {text = "07:02 22:10", font = DEFAULT_FONT,  size = 28, color = cc.c4b(177, 66, 37, 0), } ,ppx = 0.16, ppy = 0.5, ap = {0.5, 0.5}, scale = 0.8},
            {type = gailun.TYPES.LABEL, var = "playerScore_1_", options = {text = "玩家昵称1玩家昵称1", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.33, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "playerScore_2_", options = {text = "玩家昵称2玩家昵称2", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.51, ppy = 0.5 ,ap = {0.5 ,0.5}},
            {type = gailun.TYPES.LABEL, var = "playerScore_3_", options = {text = "玩家昵称3玩家昵称3", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.69, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonLook_", autoScale = 0.9, normal = "images/hall/ranklook.png", options = {}, ppx = 0.90, ppy = 0.5 },
        }},
    }
}
function RecordSharedView:ctor(param)
    RecordSharedView.super.ctor(self)
    self.param_ = param
    self:addMaskLayer(self)
    gailun.uihelper.render(self, layerBg)
    gailun.uihelper.render(self, nodeBg, layerbg_)
    gailun.uihelper.render(self, nodeTitle, layerbg_)
    gailun.uihelper.render(self, nodeItem, layerbg_)
    self:initTouchEvent_()
    self:initTextInfo_()
    self.buttonClosed_:onButtonClicked(handler(self,self.onButtonCloseClicked_))
    self.buttonLook_:onButtonClicked(handler(self,self.onButtonLookClicked_))
    if not CHANNEL_CONFIGS.ROUND_REVIEW then
        self["buttonLook_"]:setVisible(false)
    end
    self.labelNumber_:setString(param.seq or 1)
end

function RecordSharedView:initTouchEvent_()
    self.layerbg_:setTouchEnabled(true)
    self.layerbg_:setTouchSwallowEnabled(true)  -- 吞噬
    local listener = self.layerbg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y = event.name, event.x, event.y
        if name == "began" then
            return true
        end
        local touchInside = cc.rectContainsPoint(self.imgbg_:getCascadeBoundingBox(), cc.p(x, y))
        if name == "moved" then
            return cc.TOUCH_MOVED_SWALLOWS
        else
            if not touchInside then
                self:removeFromParent(true)
            end
        end
    end)
end

function RecordSharedView:initTextInfo_()
    if self.param_ and self.param_.users then 
        local timeStr = os.date("%m-%d %H:%M:%S", self.param_.time)
        self["labelFightTime_"]:setString(timeStr)
        for i = 1 , 3 do
            self["playerScore_" ..i .."_"]:setString(self.param_.users[i][2])
            self["playerName" ..i .."_"]:setString(self.param_.users[i][1])
        end
    end
end

function RecordSharedView:onButtonCloseClicked_(event)
    self:removeFromParent(true)
end

function RecordSharedView:onButtonLookClicked_(event)
    display.getRunningScene():requestReViewData(self.param_.roundID, self.param_.seq)
end

return RecordSharedView
