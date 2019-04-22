local BaseLayer = require("app.views.base.BaseLayer")
local RecordSharedView = class("RecordSharedView", BaseLayer)
local TYPES = gailun.TYPES

local layerBg = {
                type = TYPES.ROOT,
                children = {
                    {type = TYPES.SPRITE, filename = "res/images/zj_bj.png", ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}, scale = display.width / DESIGN_WIDTH},
                    {type = TYPES.LAYER, var = "layerbg_", size = {display.width, display.height}},
                    {type = TYPES.BUTTON, var = "buttonRetrun_", autoScale = 0.9, normal = "res/images/common/arrow-return.png", options = {}, ppx = 0.06, ppy = 0.9 },
                    -- {type = TYPES.SPRITE, var = "layerbg_", filename = "res/images/zj_bsd.png", ap = {0.5, 0.5}, ppx = 0.5, ppy = 0.5, scale9 = true, size = {1280 * display.width / DESIGN_WIDTH, 800}},
                }
            }   

local nodeBg = {
        type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/common/msgbg.png", var = "bg_", scale9 = true, size = {1280 * display.width / DESIGN_WIDTH, display.height * 0.69 * HEIGHT_SCALE}, ppx = 0.5, y = 200, ap = {0.5, 0}},
        }
    }

local nodeTitle = {
    type = TYPES.ROOT, children = {
        -- "#lookbackbg.png"
        {type = TYPES.SPRITE, filename = "res/images/zj_bsd.png", var = "imgbg_", children = {
            {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", scale9 = true, size = {1086 * display.width / DESIGN_WIDTH, 50} , ppx = 0.5, ppy = 0.78, children = {
                    {type = TYPES.LABEL, options = {text = "序号", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.06, ppy = 0.5,ap = {0.5 ,0.5}},
                    -- {type = TYPES.SPRITE, filename = "#rankfgx.png", ppx = 0.085, ppy = 0.93 ,scale9 = true, size = {2, 40}},

                    {type = TYPES.LABEL, options = {text = "对战时间", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.2, ppy = 0.5 ,ap = {0.5, 0.5}},
                    -- {type = TYPES.SPRITE, filename = "#rankfgx.png", ppx = 0.24, ppy = 0.93 ,scale9 = true, size = {2, 40}},
                    
                    {type = TYPES.LABEL, var = "playerName1_",options = {text = "玩家昵称1", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.35, ppy = 0.5 ,ap = {0.5, 0.5}},
                    -- {type = TYPES.SPRITE, filename = "#rankfgx.png", ppx = 0.42, ppy = 0.93 ,scale9 = true, size = {2, 40}},

                    {type = TYPES.LABEL, var = "playerName2_",options = {text = "玩家昵称2", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, ppx = 0.47, ppy = 0.5 ,ap = {0.5, 0.5}},
                    -- {type = TYPES.SPRITE, filename = "#rankfgx.png", ppx = 0.6, ppy = 0.93 ,scale9 = true, size = {2, 40}},

                    {type = TYPES.LABEL, var = "playerName3_",options = {text = "玩家昵称3", size = 28, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.59, ppy = 0.5 ,ap = {0.5, 0.5}},

                    {type = TYPES.LABEL, var = "playerName4_",options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.71, ppy = 0.5 ,ap = {0.5, 0.5}},

                    {type = TYPES.LABEL, var = "labelGame_",options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,ppx = 0.9, ppy = 0.5 ,ap = {0.5, 0.5}},
                }
            },

            -- {type = TYPES.SPRITE, filename = "#rankfgx.png", ppx = 0.78, ppy = 0.93 ,scale9 = true, size = {2, 40}},

            {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/common/arrow-return.png", 
                    options = {}, ppx = 0.98, ppy = 0.98 , ap = {0.5, 0.5}, visible = false},
        }, scale9 = true, size = {1280 * display.width / DESIGN_WIDTH, 800}, ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}}
    }
}
local nodeItem = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg29.png", scale9 = true, size = {1086 * display.width / DESIGN_WIDTH, display.height / 8 * HEIGHT_SCALE} , ppx = 0.5, ppy = 0.68, children = {
            {type = gailun.TYPES.LABEL, var = "labelNumber_", options = {text = "", size = 28, color = cc.c4b(177, 66, 37, 0), font = DEFAULT_FONT} ,ppx = 0.06, ppy = 0.5, ap = {0.5,0.5}},
            {type = gailun.TYPES.LABEL, var = "labelFightTime_", options = {text = "07:02 22:10", font = DEFAULT_FONT,  size = 28, color = cc.c4b(177, 66, 37, 0), } ,ppx = 0.2, ppy = 0.5, ap = {0.5, 0.5},},
            {type = gailun.TYPES.LABEL, var = "playerScore_1_", options = {text = "玩家昵称1玩家昵称1", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.35, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "playerScore_2_", options = {text = "玩家昵称2玩家昵称2", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.47, ppy = 0.5 ,ap = {0.5 ,0.5}},
            {type = gailun.TYPES.LABEL, var = "playerScore_3_", options = {text = "玩家昵称3玩家昵称3", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.59, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "playerScore_4_", options = {text = "", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(177, 66, 37, 0)} ,ppx = 0.71, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonLook_", autoScale = 0.9, normal = "res/images/hall/ranklook.png", options = {}, ppx = 0.90, ppy = 0.5 },
        }},
    }
}
function RecordSharedView:ctor(param)
    RecordSharedView.super.ctor(self)
    self:addMaskLayer(self,240)
    self.param_ = param
    gailun.uihelper.render(self, layerBg)
    -- gailun.uihelper.render(self, nodeBg, layerbg_)
    gailun.uihelper.render(self, nodeTitle, layerbg_)
    gailun.uihelper.render(self, nodeItem, layerbg_)
    -- self:initTouchEvent_()

    local gameType = param.gameType
    local isNum3 = table.indexof(GAMES_3, gameType)

    self:initTextInfo_(isNum3)
    self.buttonClosed_:onButtonClicked(handler(self,self.onButtonCloseClicked_))
    self.buttonLook_:onButtonClicked(handler(self,self.onButtonLookClicked_))
    self.buttonRetrun_:onButtonClicked(handler(self,self.onButtonCloseClicked_))
    if not CHANNEL_CONFIGS.ROUND_REVIEW then
        self["buttonLook_"]:setVisible(false)
    end
    self.labelNumber_:setString(param.seq or 1)

    -- gameType = 10
    if not gameType then
        self.labelGame_:hide()
    else
        if GAMES_NAME[gameType] then
            self.labelGame_:setString(GAMES_NAME[gameType])
        else
            self.labelGame_:hide()
        end
    end
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

function RecordSharedView:initTextInfo_(isNum3)
    if self.param_ and self.param_.users then 
        local timeStr = os.date("%m-%d %H:%M:%S", self.param_.time)
        self["labelFightTime_"]:setString(timeStr)

        for i = 1, #self.param_.users do
            self["playerScore_" ..i .."_"]:setString(self.param_.users[i][2])
            local name = gailun.utf8.formatNickName(tostring(tostring(self.param_.users[i][1])), 8, '..')
            self["playerName" ..i .."_"]:setString(name)
        end

        if isNum3 then
            self["playerScore_4_"]:setString("")
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
