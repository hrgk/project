local TYPES = gailun.TYPES
local Nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "#device_info_bg.png", scale9 = true, size = {104, 50},},
        {type = TYPES.SPRITE, var = "spriteNetWWAN_", filename = "#wwan-5.png", x = -25, y = 6},
        {type = TYPES.SPRITE, var = "spriteNetWIFI_", filename = "#net-wifi-5.png", x = -25, y = 8},
        {type = TYPES.SPRITE, var = "spriteBattery_", filename = "#battery-2.png", x = 25, y = 6},   -- alarm_clock
        {type = TYPES.SPRITE, var = "spriteBatteryRed_", visible = false, filename = "#battery-1.png", x = 25, y = 6},
        {type = TYPES.PROGRESS_TIMER, var = "batteryProgress_", bar = "#battery-3.png", percent = 80, x = 23.5, y = 6},
        -- {type = TYPES.LABEL, var = "labelSysTime_", options = {text="", size=24, font = DEFAULT_FONT, color=cc.c3b(159, 193, 125)}, y = -20, ap = {0.5, 0.5}},
    },
}

local DeviceInfoView = class("DeviceInfoView", gailun.BaseView)

local NET_WIFI = 1
local NET_WWAN = 2
local TICK_SECONDS = 1  -- 步进的单位时间

function DeviceInfoView:ctor(table)
    gailun.uihelper.render(self, Nodes)
    self.runCount_ = 1
    self.net_ = NET_WIFI
    self:tickByDeltaTime_()
end

function DeviceInfoView:onEnter()
    self:schedule(handler(self, self.tickByDeltaTime_), TICK_SECONDS)
    local events = {
        {dataCenter.NET_DELAY_FOUND, handler(self, self.onNetDelayFound_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, events)
end

function DeviceInfoView:onExit()
    gailun.EventUtils.clear(self)
end

local NET_LEVELS = {
    {2, 1, 0.4, 0.1, 0.05},  -- WIFI延时
    {3, 1.5, 0.8, 0.4, 0.1},  -- WWAN延时
}
function DeviceInfoView:calcNetLevel_(seconds)
    local net, level = NET_WIFI, 1
    if not network.isInternetConnectionAvailable() then
        level = 1
    end
    if not network.isLocalWiFiAvailable() then
        net = NET_WWAN
    end

    for i = #NET_LEVELS[net], 1, -1 do
        if seconds < NET_LEVELS[net][i] then
            level = i
            break
        end
    end

    return net, level
end

function DeviceInfoView:onNetDelayFound_(event)
    if not event or not event.seconds then
        return
    end
    
    local net, level = self:calcNetLevel_(checknumber(event.seconds))
    self.net_ = net
    self:updateNetView_(net, level)
end

function DeviceInfoView:updateNetView_(net, level)
    local image = string.format("net-wifi-%d.png", level)
    if 1 ~= net then
        image = string.format("wwan-%d.png", level)
    end
    local frame = display.newSpriteFrame(image)
    if 1 == net then
        self.spriteNetWIFI_:show()
        self.spriteNetWWAN_:hide()
        self.spriteNetWIFI_:setSpriteFrame(frame)
    else
        self.spriteNetWIFI_:hide()
        self.spriteNetWWAN_:show()
        self.spriteNetWWAN_:setSpriteFrame(frame)
    end
end

function DeviceInfoView:tickByDeltaTime_()
    self.runCount_ = self.runCount_ + 1
    -- self:updateTime_()
    self:updateNet_()
    if self.runCount_ < 3 or self.runCount_ % 20 == 0 then
        self:updateBattery_()
    end
end

function DeviceInfoView:updateTime_()
    local time = os.date("%H:%M", os.time())
    self.labelSysTime_:setString(time)
end

function DeviceInfoView:updateNet_()
    if not network.isInternetConnectionAvailable() then
        return self:updateNetView_(self.net_, 1)
    end
    local isWIFI = network.isLocalWiFiAvailable()
    self.spriteNetWIFI_:setVisible(isWIFI)
    self.spriteNetWWAN_:setVisible(not isWIFI)
end

function DeviceInfoView:updateBattery_()
    local percent = gailun.native.getBattery()
    -- percent = math.random(0, 100)
    self.batteryProgress_:setPercentage(percent)
    self.batteryProgress_:show()
    self.spriteBattery_:show()
    self.spriteBatteryRed_:hide()
    if percent < 20 then
        self.spriteBattery_:hide()
        self.batteryProgress_:hide()
        self.spriteBatteryRed_:show()
    end
end

return DeviceInfoView
