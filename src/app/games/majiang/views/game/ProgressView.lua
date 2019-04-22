local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LABEL, var = "label2_", options = {text="", font=DEFAULT_FONT, size=24, color=cc.c3b(222, 224, 48)}, ap = {1, 0.5}},
        {type = gailun.TYPES.LABEL_ATLAS, var = "label2_", filename = "fonts/game_paishu.png", options = {text="", w = 24, h = 31, startChar = "0"}, ap = {0.5, 0.5}},
        {type = TYPES.SPRITE, var = "guizetiaoBg_", filename = "res/images/game//tableHead/bg.png", x = -535, y = 300,scale9 = true, size = {260, 80}},
        {type = TYPES.LABEL, var = "labelTableID_", options = {text="", size=20, font = DEFAULT_FONT, color=cc.c3b(255, 255, 255)}, x = 162-800, y = 305 , ap = {0, 0.5}},
        {type = TYPES.LABEL, visible = true, var = "timeLabel_", x = 162-620-65, y = 246+38,options = {text="00:00", size=20, font = DEFAULT_FONT, color=cc.c3b(255, 255, 255)}, ap = {0, 0.5}},
        {type = TYPES.SPRITE, visible = true, var = "batteryLv_", filename = "res/images/game/dianchilv.png", x = 162-680, y = 244+60, ap = {0, 0.5}},
        {type = TYPES.SPRITE, visible = true, var = "batteryHong_", filename = "res/images/game/dianchihong.png", x = 162-680, y = 244+60, ap = {0, 0.5}},
        {type = TYPES.SPRITE, visible = true, var = "batteryBg_", filename = "res/images/game/dianchikuang.png", x = 185-680, y = 244+60},

        {type = TYPES.BUTTON, var = "buttonMenu_", normal = "res/images/game/btn_tub.png", autoScale = 0.9, 
            x = 600,y = 290
        },
        {type = TYPES.BUTTON, var = "buttonWanFa_", normal = "res/images/game/bt_gz.png", autoScale = 0.9, 
           x = 540, y = 290
        },
        {type = TYPES.BUTTON, var = "buttonSX_", normal = "res/images/game/btn_sx.png", autoScale = 0.9, 
            x = 480, y = 290
        },
        {type = gailun.TYPES.SPRITE, var = "btnMenu_", filename = "res/images/game/btnBg.png", x = 543, y = 120,scale9 = true, size = {180, 270},
            children = {
                {type = TYPES.BUTTON, var = "buttonConfig_", normal = "res/images/game/btn_sheZhi.png", autoScale = 0.9, ppx =  0.5, ppy = 0.6,},
                {type = TYPES.BUTTON, var = "buttonDismiss_", normal = "res/images/game/btn_jieSan.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                {type = TYPES.BUTTON, var = "buttonQuitRomm_", normal = "res/images/game/btn_tuiChu.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                {type = TYPES.BUTTON, var = "buttonDingWei_", normal = "res/images/game/btn_dingw.png", autoScale = 0.9, ppx =  0.5, ppy = 0.8,},
                {type = TYPES.BUTTON, var = "buttonZl_", normal = "res/images/game/btn_zanshilikai.png", autoScale = 0.9, ppx =  0.5, ppy = 0.2,},

            }
        },
    }
}

local ProgressView = class("ProgressView", gailun.BaseView)

function ProgressView:ctor(table)
    self.secondTime = 0
    self.isFirstBattry = true
    self.secondBattery = 0
    gailun.uihelper.render(self, nodes)
    self:updateLabelPosition_()
    self.buttonMenu_:onButtonClicked(handler(self, self.onMenuClicked_))
    self.buttonDingWei_:onButtonClicked(handler(self, self.onDingWeiClicked_))
    self.buttonConfig_:onButtonClicked(handler(self, self.onConfigClicked_))
    self.buttonDismiss_:onButtonClicked(handler(self, self.onDismissClicked_))
    self.buttonQuitRomm_:onButtonClicked(handler(self, self.onQuitRoomClicked_))
    self.buttonZl_:onButtonClicked(handler(self, self.onZlClicked_))
    self.btnMenu_:hide()
    self.buttonWanFa_:onButtonClicked(handler(self, self.onWanFa_))
    self.buttonSX_:onButtonClicked(handler(self, self.onSX_))
end

function ProgressView:onSX_(event)
    display.getRunningScene():onReconnectClicked_()
end

function ProgressView:setCardCount(count)
    self.label2_:setString(count)
    self:updateLabelPosition_()
    self.label2_:setVisible(not (not count or count <= 0))
end

function ProgressView:onEnter()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
        self:update(dt)
    end)
    self:scheduleUpdate()

    local events = {
        {dataCenter.NET_DELAY_FOUND, handler(self, self.onNetDelayFound_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, events)
end

function ProgressView:onNetDelayFound_(dt)
    
end

function ProgressView:timeUpdate(dt)
    self.secondTime = self.secondTime + dt
    if self.secondTime > 1 then
        self.secondTime = 0
        local time = os.date("%X", os.time())
        time = string.sub(time,1,-4)
        self.timeLabel_:setString(time)
    end
end

function ProgressView:update(dt)
    self:timeUpdate(dt)
    self:batteryUpdate(dt)
end

function ProgressView:batteryUpdate(dt)
    self.secondBattery = self.secondBattery + dt
    local number = 0.1
    if not self.isFirstBattry then
        number = 5
    end
    if self.secondBattery > number then
        self.isFirstBattry = false
        self.secondBattery = 0
        local num_ = gailun.native.getBattery()/100
        self.batteryHong_:setVisible(false)
        self.batteryLv_:setVisible(false)
        self.batteryHong_:setScaleX(num_)
        self.batteryLv_:setScaleX(num_)
        if num_ > 0.1 then
            self.batteryHong_:setVisible(false)
            self.batteryLv_:setVisible(true)
        elseif num_ <= 0.1 then
            self.batteryHong_:setVisible(true)
            self.batteryLv_:setVisible(false)
        end
    end
end

function ProgressView:menuHide_()
    self.btnMenu_:hide()
end

function ProgressView:onZlClicked_(event)
    selfData:setNowRoomID(dataCenter:getRoomID())
    display.getRunningScene():enterQianScene()
end

function ProgressView:showOnStatePlaying_()
    self.buttonDismiss_:hide()
    self.buttonQuitRomm_:hide()
    self.buttonConfig_:show()
    self.buttonZl_:hide()
end

function ProgressView:showOnStateIdle_()
    if display.getRunningScene():getTable():isOwner(selfData:getUid()) then  -- 房主才显示此按钮
        self.buttonDismiss_:show()
        self.buttonQuitRomm_:hide()
        self.buttonZl_:hide()
    else
        self.buttonQuitRomm_:show()
        self.buttonDismiss_:hide()
        self.buttonZl_:hide()
    end
    if display.getRunningScene():getTable():getClubID() > 0 then
        self.buttonQuitRomm_:show()
        self.buttonDismiss_:hide()
        self.buttonZl_:show()
    end
end

function ProgressView:onDingWeiClicked_(event)
    display.getRunningScene():onDingWeiClicked_()
end

function ProgressView:onWanFa_(event)
    display.getRunningScene():onWanFa_()
end

function ProgressView:onQuitRoomClicked_(event)
    display.getRunningScene():onQuitRoomClicked_()
end

function ProgressView:onDismissClicked_(event)
    display.getRunningScene():onDismissClicked_()
end

function ProgressView:onConfigClicked_(event)
    display.getRunningScene():onConfigClicked_()
end

function ProgressView:onMenuClicked_(event)
    self.isPlaying_, self.isMenuOpen_ = display.getRunningScene():onMenuClicked_()
    if self.isPlaying_ then
        local height = self.btnMenu_:getContentSize().height
        self.buttonDismiss_:hide()
        self.buttonQuitRomm_:hide()
        self.buttonZl_:hide()
        self.buttonConfig_:setPositionY(height*0.3)
        self.buttonDingWei_:setPositionY(height*0.7)
    end
    self.btnMenu_:setVisible(self.isMenuOpen_)
end

function ProgressView:setCardCount(count)
    self.label2_:setString(count)
    self:updateLabelPosition_()
    self.label2_:setVisible(not (not count or count <= 0))
end

function ProgressView:setRoundState(total, current)
    -- self.label4_:setString(string.format(" %d/%d ", current, total))
    -- self:updateLabelPosition_()
end

function ProgressView:updateLabelPosition_()
    -- self.label3_:setPositionX(0)
    -- local width1 = self.label3_:getContentSize().width
    -- self.label2_:setPositionX(-width1 / 2)
    -- self.label4_:setPositionX(width1 / 2)
    -- local width2 = self.label2_:getContentSize().width
    -- self.label1_:setPositionX(-width1 / 2 - width2)

    -- local width3 = self.label4_:getContentSize().width
    -- self.label5_:setPositionX(width1 / 2 + width3)
end

return ProgressView
