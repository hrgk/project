local BaseLayer = import("..BaseLayer")
local GameDestoryRoomView = class("GameDestoryRoomView", BaseLayer)
local msg = "等待其他用户选择中..."
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.LAYER, var = "rootTouchLayer_", children = {
            {type = TYPES.SPRITE, var = "joinRoomBg_", filename = "res/images/sz_bg.png", scale9 = true, size = {740, 500}, capInsets = cc.rect(340, 150, 1, 1), x = display.cx, y = display.cy, children = {
                {type = TYPES.SPRITE, filename = "res/images/game/alarm_clock.png", ppx = 0.1, ppy = 0.9, children = {
                    {type = gailun.TYPES.LABEL_ATLAS, var = "labelTimeNum_", filename = "fonts/game_timer.png", options = {text="", w = 18, h = 32, startChar = "0"}, ppx = 0.48, ppy = 0.5, ap = {0.5, 0.5}},
                }},
                {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.51, ppy = 0.920, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, filename = "res/images/common/jsfj_word.png", ppx = 0.5, ppy = 0.95, ap = {0.5, 0.5}},
                -- {type = TYPES.LABEL, options = {text = "申请解散房间", size = 40, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = 0.5, ppy = 0.907, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "labelStarter_", options = {text = "", size = 32, font = DEFAULT_FONT, color = cc.c3b(77, 36, 21)} ,ppx = 0.075, ppy = 0.73, ap = {0, 0.5}},
                {type = TYPES.LABEL, var = "labelAgree_", options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c3b(255, 0, 0)} ,ppx = 0.08, ppy = 0.63, ap = {0, 0.5}},
                {type = TYPES.LABEL, var = "labelPlayerName1_", options = {text = "【?】同意", size = 32, font = DEFAULT_FONT, color = cc.c3b(77, 36, 21)} ,ppx = 0.075, ppy = 0.53, ap = {0, 0.5}},
                {type = TYPES.LABEL, var = "labelPlayerName2_", options = {text = "【?】同意", size = 32, font = DEFAULT_FONT, color = cc.c3b(77, 36, 21)} ,ppx = 0.075, ppy = 0.43, ap = {0, 0.5}},
                {type = TYPES.LABEL, var = "labelPlayerName3_", options = {text = "【?】同意", size = 32, font = DEFAULT_FONT, color = cc.c3b(77, 36, 21)} ,ppx = 0.075, ppy = 0.33, ap = {0, 0.5}},
                {type = TYPES.BUTTON, var = "buttonCancel_", autoScale = 0.9, normal = "res/images/game/button_refuse.png", visible = true, 
                    options = {}, ppx = 0.7, ppy = 0.19 },
                {type = TYPES.BUTTON, var = "buttonOK_", autoScale = 0.9, normal = "res/images/game/button_agree.png",  visible = true,
                    options = {}, ppx = 0.3, ppy = 0.19 },
            }}
        }}
    }
}

function GameDestoryRoomView:ctor(params)
    GameDestoryRoomView.super.ctor(self)
    self:addMaskLayer(self)
    gailun.uihelper.render(self, nodes)
    self:schedule(handler(self,self.updateLeftTime_), 1)
    self:initEvents_()
    self:updateView_(params)
    if  not params.myChoosed then
        self.buttonOK_:onButtonClicked(handler(self, self.onAgreeClicked_))
        self.buttonCancel_:onButtonClicked(handler(self, self.onDisagreeClicked_))
    else
        self.buttonCancel_:hide()
        self.buttonOK_:hide()
    end
end

function GameDestoryRoomView:initEvents_()
    self.rootTouchLayer_:setTouchEnabled(true)
    self.rootTouchLayer_:setTouchSwallowEnabled(true)  -- 吞噬
    local listener = self.rootTouchLayer_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y = event.name, event.x, event.y
        if name == "began" then
            return true
        end
        local touchInside = cc.rectContainsPoint(self.joinRoomBg_:getCascadeBoundingBox(), cc.p(x, y))
        if name == "moved" then
            return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
        else
            if not touchInside then
                self:onClose_()
            end
        end
    end)
    return listener
end

function GameDestoryRoomView:updateView_(params)
    local str = string.format("玩家【%s】申请解散房间", params.starter or '')
    self.labelStarter_:setString(str)

    local agree = string.format("(超过%d分钟未做选择，则默认同意)", math.ceil(params.configTime / 60))
    self.labelAgree_:setString(agree)

    self.leftTime_ = params.remainTime or params.configTime
    self.leftTime_ = math.ceil(math.max(0, self.leftTime_))
    self.labelTimeNum_:setString(self.leftTime_)
    local labels = {self.labelPlayerName1_, self.labelPlayerName2_}--, self.labelPlayerName3_}
    local all = {1, 2, 3}

    self.labelPlayerName3_:hide()
    if not table.indexof(GAMES_3, dataCenter:getCurGammeType()) then
        table.insert(labels, self.labelPlayerName3_)
        table.insert(all, 4)
        self.labelPlayerName3_:show()
    end
    local offset = 1
    table.removebyvalue(all, params.yesSeatIDs[1])
    local function setLabel_(list, str, start)
        local list = clone(list)
        for i = start or 1, #list do
            local seatID = list[i]
            if params.nickNames[seatID] then
                local label = labels[offset]
                offset = offset + 1
                if label then
                    label:setString(string.format(str, params.nickNames[seatID] or ""))
                end
                table.removebyvalue(all, seatID)
            end
        end
    end
    setLabel_(params.yesSeatIDs, "【%s】同意", 2)
    setLabel_(params.noSeatIDs, "【%s】拒绝")
    setLabel_(all, "【%s】等待选择")
end

function GameDestoryRoomView:onAgreeClicked_(event)
    local key = GAMES_REQUEST_DISMISS[dataCenter:getCurGammeType()] or GAMES_REQUEST_DISMISS[GAME_DEFAULT]
    local cmd = COMMANDS[key]
    dataCenter:sendOverSocket(cmd, {agree = true})
end

function GameDestoryRoomView:onDisagreeClicked_(event)
    local key = GAMES_REQUEST_DISMISS[dataCenter:getCurGammeType()] or GAMES_REQUEST_DISMISS[GAME_DEFAULT]
    local cmd = COMMANDS[key]
    dataCenter:sendOverSocket(cmd, {agree = false})
end

function GameDestoryRoomView:updateLeftTime_()
    self.leftTime_ = self.leftTime_ - 1
    if self.leftTime_ < 0 then
        return 
    end
    self.labelTimeNum_:setString(self.leftTime_)
end

-- 屏蔽上层的 onClose_ 为空但不可删
function GameDestoryRoomView:onClose_(event)
end

return GameDestoryRoomView
