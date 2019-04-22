local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, x = display.cx, y = display.top - 15, scale = display.width / DESIGN_WIDTH, ap = {0.5, 0.5}, size = {660, 60},
            children = {
                {type = TYPES.SPRITE, filename = "res/images/game/topBg.png", ppx = 0.5, y =0},
                {type = TYPES.LABEL, var = "labelInfo_", x = 360, y = 15,opacity = 80, options = {text="房间号:456287   局数12/16", size=20, font = DEFAULT_FONT, color=cc.c3b(255, 255, 255)}, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, var = "content_", ppx = 0.5, ppy = 0.5},
                {type = TYPES.LABEL, visible = true, var = "timeLabel_", x = 165, y = 0, opacity = 80,options = {text="00:00", size=20, font = DEFAULT_FONT, color=cc.c3b(255, 255, 255)}, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryLv_", filename = "res/images/game/dianchilv.png", x = 167, y = 25, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryHong_", filename = "res/images/game/dianchihong.png", x = 167, y = 25, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryBg_", filename = "res/images/game/dianchikuang.png", x = 190, y = 25},
                {type = TYPES.BUTTON, var = "buttonMenu_", normal = "res/images/game/btn_tub.png", autoScale = 0.9, x = 530, y = 15},
                {type = TYPES.BUTTON, var = "buttonWanFa_", normal = "res/images/game/bt_gz.png", autoScale = 0.9, x = 130, y = 15},
                {type = gailun.TYPES.SPRITE, var = "btnMenu_", filename = "res/images/game/btnBg.png", x = 482, y = -15,scale9 = true, size = {300, 270},ap = {0.5, 1},
                    children = {
                        {type = TYPES.BUTTON, var = "buttonConfig_", normal = "res/images/game/btn_sheZhi.png", autoScale = 0.9, ppx =  0.5, ppy = 0.6,},
                        {type = TYPES.BUTTON, var = "buttonDismiss_", normal = "res/images/game/btn_jieSan.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                        {type = TYPES.BUTTON, var = "buttonQuitRomm_", normal = "res/images/game/btn_tuiChu.png", autoScale = 0.9, ppx = 0.5, ppy = 0.4,},
                        {type = TYPES.BUTTON, var = "buttonDingWei_", normal = "res/images/game/btn_dingw.png", autoScale = 0.9, ppx =  0.5, ppy = 0.8,},
                        {type = TYPES.BUTTON, var = "buttonZl_", normal = "res/images/game/btn_zanshilikai.png", autoScale = 0.9, ppx =  0.5, ppy = 0.2,},
                    }
                },
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
    self.buttonMenu_:onButtonClicked(handler(self, self.onMenuClicked_))
    self.buttonDingWei_:onButtonClicked(handler(self, self.onDingWeiClicked_))
    self.buttonConfig_:onButtonClicked(handler(self, self.onConfigClicked_))
    self.buttonDismiss_:onButtonClicked(handler(self, self.onDismissClicked_))
    self.buttonQuitRomm_:onButtonClicked(handler(self, self.onQuitRoomClicked_))
    self.btnMenu_:hide()
    self.buttonWanFa_:onButtonClicked(handler(self, self.onWanFa_))
    self.buttonZl_:onButtonClicked(handler(self, self.onZlClicked_))
    self.buttonConfig_:setScale(1.3)
    self.buttonDingWei_:setScale(1.3)
    self.buttonDismiss_:setScale(1.3)
    self.buttonQuitRomm_:setScale(1.3)
    self.buttonZl_:setScale(1.3)
end

function ProgressView:menuHide_()
    self.btnMenu_:hide()
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

function ProgressView:onZlClicked_(event)
    selfData:setNowRoomID(0)
    display.getRunningScene():enterQianScene()
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
    display.getRunningScene():showGameSheZhi(true, GAME_LDFPF)
end

function ProgressView:onMenuClicked_(event)
    self.isPlaying_, self.isMenuOpen_ = display.getRunningScene():onMenuClicked_()
    local date = display.getRunningScene():getTable():getConfigData()
    
    if self.isPlaying_ then
        local height = self.btnMenu_:getContentSize().height
        self.buttonDismiss_:hide()
        self.buttonQuitRomm_:hide()
        self.buttonZl_:hide()
        self.buttonConfig_:setPositionY(height*0.3)
        self.buttonDingWei_:setPositionY(height*0.7)
        if date.rules.totalSeat <= 2 then
            self.buttonDingWei_:hide()
            self.btnMenu_:setSpriteFrame(display.newSprite("res/images/game/btnBg1.png"):getSpriteFrame())
            self.btnMenu_:setContentSize(cc.size(300, 90))
            local height = self.btnMenu_:getContentSize().height
            self.buttonConfig_:setPositionY(height*0.5)
        end
    else
        if date.rules.totalSeat <= 2 then
            self.buttonDingWei_:hide()
            if display.getRunningScene():getTable():getClubID() > 0 then
                self.btnMenu_:setContentSize(cc.size(300, 200))
            else
                self.btnMenu_:setContentSize(cc.size(300, 170))
                local height = self.btnMenu_:getContentSize().height
                self.buttonConfig_:setPositionY(height*0.7)
                self.buttonDismiss_:setPositionY(height*0.3)
                self.buttonQuitRomm_:setPositionY(height*0.3)
            end
        end
    end
    self.btnMenu_:setVisible(self.isMenuOpen_)
end

function ProgressView:setRoomInfo(info)
    self.labelInfo_:setString(info)
end

function ProgressView:onEnter()
    -- self.batteryHong_:setVisible(false)
    -- self.batteryLv_:setVisible(false)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
        self:update(dt)
    end)
    self:scheduleUpdate()

    local events = {
        {dataCenter.NET_DELAY_FOUND, handler(self, self.onNetDelayFound_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, events)
end

function ProgressView:onNetDelayFound_(data)
    do return end
    local num_ = math.floor(data.data.seconds*1000)
    if num_ < 0 then
        num_ = 0
    elseif num_ >=0 and num_ <= 100 then
        self.msLabel_:setColor(cc.c3b(0, 255, 0))
    elseif num_ >100 and num_ <= 200 then
        self.msLabel_:setColor(cc.c3b(255, 255, 0))
    elseif num_ >200 then
        self.msLabel_:setColor(cc.c3b(255, 0, 0))
    end
    if num_ >= 1000 then
        num_ = 999
    end
    self.msLabel_:setString(num_.."ms")
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

function ProgressView:timeUpdate(dt)
    self.secondTime = self.secondTime + dt
    if self.secondTime > 1 then
        self.secondTime = 0
        local time = os.date("%X", os.time())
        time = string.sub(time,1,-4)
        self.timeLabel_:setString(time)
    end
end

function ProgressView:showRoomConfig()
    local playerTable = display:getRunningScene():getTable()
    self.currRound_ = playerTable:getFinishRound()
    self:setRoundState(self.currRound_)
    local temp = {}
    table.insert(temp, playerTable:getConfigData().totalSeat .. "人")
    if playerTable:getPaiZhangInfo() ~= "" then
        table.insert(temp, playerTable:getPaiZhangInfo())
    end
    -- table.insert(temp, playerTable:getPlayerCountInfo())
    table.insert(temp, playerTable:getOverScoreInfo())
    if playerTable:getOverScoreInfo() ~= "" then
        table.insert(temp, playerTable:getOverBonusInfo())
    end
    if playerTable:getShowCardsInfo() ~= "" then
        table.insert(temp, playerTable:getShowCardsInfo())
    end
    if playerTable:getRandomDealerInfo() ~= "" then
        table.insert(temp, playerTable:getRandomDealerInfo())
    end

    local jushuTex = "第"..self.currRound_.."局"
    table.insert(temp,jushuTex)


    -- local playerCountInfo = playerTable:getPlayerCountInfo() .. "  "
    -- local overScoreInfo = playerTable:getOverScoreInfo() .. "  "
    -- local overBonusInfo = playerTable:getOverBonusInfo() .. "  "
    -- local showCardsInfo = playerTable:getShowCardsInfo() .. "  "
    -- local paiZhangInfo = playerTable:getPaiZhangInfo() .. "  "
    local randomDealerInfo = playerTable:getRandomDealerInfo() .. "  "
    local msg = table.concat(temp, " ")
    self.labelRoomInfo_:setString(msg)
end

function ProgressView:addRound()
    self.currRound_ = self.currRound_ + 1
    display:getRunningScene():getTable():setFinishRound(self.currRound_)
    self:setRoundState(self.currRound_)
    self:showRoomConfig()
end

function ProgressView:getRound()
    return self.currRound_
end

function ProgressView:setRemainCards(cardsCount)
    self.remainCountLabel:setString(cardsCount)
end

function ProgressView:setRoundState(current)
    self.labelProgress_:setString(string.format("第 %d 局", current))
end

function ProgressView:updateTableID_(tid)
    self.labelTableID_:setString(string.format("房间号:%06d", tid or 0))
end

function ProgressView:onExit()
    gailun.EventUtils.clear(self)
end

return ProgressView
