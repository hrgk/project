local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, x = display.left, y = display.top, filename = "res/images/shuangKou/progressView/bg.png", scale = 1, ap = {0, 1},
            children = {
                {type = TYPES.SPRITE,filename = "res/images/shuangKou/game/youshangtiao.png", x = 200, y = 90},
                -- {type = TYPES.SPRITE,filename = "res/images/shuangKou/game/fanghao.png", x = 40, y = 90},
                {type = TYPES.LABEL, var = "labelTableID_", x = 80, ppy = 0.5, options = {text="", size=24, font = DEFAULT_FONT, color=cc.c3b(0x58, 0x86, 0x88)}, ap = {0, 0.5}},
                -- {type = TYPES.SPRITE,filename = "res/images/shuangKou/game/dipaidi.png", x = 80, y = 20},
                {type = TYPES.SPRITE, visible = false, filename = "res/images/shuangKou/game/shengpai.png", x = 100, y = 20},
                {type = TYPES.LABEL, visible = false, x = 115, y = 7, options = {text="底牌", size=20, font = DEFAULT_FONT, color=cc.c3b(149, 204, 255)}, ap = {0.5, 0.5}},
                -- {type = TYPES.SPRITE,filename = "res/images/shuangKou/game/dipai.png", x = 40, y = 40},
                {type = TYPES.LABEL, visible = false, var = "remainCountLabel", x = 115, y = 30, options = {text="0", size=24, font = DEFAULT_FONT, color=cc.c3b(255, 247, 118)}, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "content_", ppx = 0.5, ppy = 0.5},
                {type = TYPES.LABEL, visible = true, var = "timeLabel_", x = 40, y = 15, options = {text="00:00", size=20, font = DEFAULT_FONT, color=cc.c3b(0x58, 0x86, 0x88)}, ap = {0.5, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryLv_", filename = "res/images/game/dianchilv.png", x = 20, y = 35, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryBg_", filename = "res/images/game/dianchikuang.png", x = 20, y = 35, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = true, var = "batteryHong_", filename = "res/images/game/dianchihong.png", x = 157, y = 5, ap = {0, 0.5}},
                {type = TYPES.SPRITE, visible = false, var = "networkBg_", filename = "res/images/shuangKou/wifi.png", x = 170, y = 87},
                {type = TYPES.LABEL, visible = false, var = "msLabel_", x = 225, y = 85, options = {text="60ms", size=18, font = DEFAULT_FONT, color=cc.c3b(0, 255, 0)}, ap = {0.5, 0.5}},

                {type = TYPES.LABEL, visible = true, var = "labelProgress_", x = 220, ppy = 0.5, options = {text="", font=DEFAULT_FONT, size=20, color=cc.c3b(0x58, 0x86, 0x88)}, ap = {0, 0.5}},

                {type = TYPES.LABEL, var = "labelRoomInfo_", x = 200, ppy = 0.5, options = {text="", font=DEFAULT_FONT, size=35, color=cc.c3b(5,67,103)}, ap = {0, 0.5}},
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
end

function ProgressView:onEnter()
    -- self.batteryHong_:setVisible(false)
    -- self.batteryLv_:setVisible(false)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,function(dt)
        self:update(dt)
    end)
    self:scheduleUpdate()
    gailun.EventUtils.clear(self)
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
    local config = playerTable:getConfigData()
    -- table.insert(temp, playerTable:getConfigData().totalSeat .. "人")
    -- if playerTable:getPaiZhangInfo() ~= "" then
    --     table.insert(temp, playerTable:getPaiZhangInfo())
    -- end
    -- -- table.insert(temp, playerTable:getPlayerCountInfo())
    -- table.insert(temp, playerTable:getOverScoreInfo())
    -- if playerTable:getOverScoreInfo() ~= "" then
    --     table.insert(temp, playerTable:getOverBonusInfo())
    -- end
    -- if playerTable:getShowCardsInfo() ~= "" then
    --     table.insert(temp, playerTable:getShowCardsInfo())
    -- end
    -- if playerTable:getRandomDealerInfo() ~= "" then
    --     table.insert(temp, playerTable:getRandomDealerInfo())
    -- end

    -- local jushuTex = "第"..self.currRound_.."局"
    -- table.insert(temp,jushuTex)


    -- local playerCountInfo = playerTable:getPlayerCountInfo() .. "  "
    -- local overScoreInfo = playerTable:getOverScoreInfo() .. "  "
    -- local overBonusInfo = playerTable:getOverBonusInfo() .. "  "
    -- local showCardsInfo = playerTable:getShowCardsInfo() .. "  "
    -- local paiZhangInfo = playerTable:getPaiZhangInfo() .. "  "
    -- local randomDealerInfo = playerTable:getRandomDealerInfo() .. "  "
    -- local msg = table.concat(temp, " ")
    -- self.labelRoomInfo_:setString("asdfasdfadfasdf")
end

function ProgressView:addRound()
    self.currRound_ = self.currRound_ + 1
    display:getRunningScene():getTable():setFinishRound(self.currRound_)
    self:setRoundState(self.currRound_)
    -- self:showRoomConfig()
end

function ProgressView:getRound()
    return self.currRound_
end

function ProgressView:setRemainCards(cardsCount)
    self.remainCountLabel:setString(cardsCount)
end

function ProgressView:setRoundState(current)
    local playerTable = display:getRunningScene():getTable()
    local config = playerTable:getConfigData()
    local msg = ""
    if playerTable.getGameType then
        if playerTable:getGameType() == GAME_SHUANGKOU then
            if config.bianPai == 1 then
                msg = "百变 "
            elseif config.bianPai == 2 then
                msg = "千变 "
            end
        end
    end
    self.labelProgress_:setString(string.format("%s局数 %d/%d", msg, current, playerTable:getConfigData().juShu))
end

function ProgressView:updateTableID_(tid)
    self.labelTableID_:setString(string.format("房号:%06d", tid or 0))
end

function ProgressView:onExit()
    gailun.EventUtils.clear(self)
end

return ProgressView
