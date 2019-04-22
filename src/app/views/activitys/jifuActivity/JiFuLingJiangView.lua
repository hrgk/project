local JiFuLingJiangView = class("JiFuLingJiangView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_ditu.png", px = 0.5, py = 0.44 ,scale9 = true, size ={914, 522}},
        {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_lingjiang_bg.png", px = 0.5, py = 0.4, size ={870, 400}},
        {type = TYPES.LABEL, var = "totalFu_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.425, py = 0.54, ap = {1, 0.5}},
        {type = TYPES.LABEL, var = "activityTime_", options = {text="2017.02.10 -- 2017.02.12", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, visible = true, px = 0.5, py = 0.75, ap = {0.5, 0.5}},
        {type = TYPES.LABEL, options = {text="（仅邵阳地区的用户可参与）", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, px = 0.5, py = 0.715, ap = {0.5, 0.5}},
        {type = TYPES.BUTTON, var = "buttonPhone_", normal = "res/images/jifu/jifu_yaoqing.png", px = 0.42, py = 0.45},
        {type = TYPES.LABEL, var = "inputLabel_", options = {text="输入您的电话号码", size = 18, font = DEFAULT_FONT, color = cc.c4b(143, 143, 143, 255)}, visible = true, px = 0.365, py = 0.45, ap = {0, 0.5}},
        {type = TYPES.BUTTON, var = "buttonTiJiao_", autoScale = 0.9, normal = "res/images/jifu/jifu_tijiao.png", px = 0.58, py = 0.45},        
    }
}

function JiFuLingJiangView:ctor()
    JiFuLingJiangView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.numberStr_ = ""
    self.buttonPhone_:onButtonClicked(handler(self, self.inputPhoneHandler_))
end

function JiFuLingJiangView:update_(data)
    local startTime = os.date("%Y-%m-%d", data.startTime)
    local endTime =  os.date("%Y-%m-%d", data.endTime)
    local info = data.myJiFu
    self.totalFu_:setString(info.totalFu)
    self.activityTime_:setString("活动时间 " .. startTime .. "－－" .. endTime)
end

function JiFuLingJiangView:inputPhoneHandler_(event)
    self.inputView_ = app:createView("hall.PuTongInputNumberView", "输入您的电话号码"):addTo(self):pos(display.left + 300, display.cy)
    self.inputView_:scale(0.8)
    self.inputView_:setNumberInputCallback(handler(self, self.numberInput))
    self.inputView_:setCallback(handler(self, self.checkID_))
end

function JiFuLingJiangView:numberInput(num)
    if num == 10 then
        self.numberStr_ = ""
    elseif num == 12 then
        local len = string.len(self.numberStr_)
        self.numberStr_ = string.sub(self.numberStr_, 1, len - 1)
    else
        local len = string.len(self.numberStr_)
        if len >=13 then
            self.numberStr_ = string.sub(self.numberStr_, 1, len - 1)
        end
        self.numberStr_ = self.numberStr_ .. num
    end
    self.inputLabel_:setString(self.numberStr_)
end

return JiFuLingJiangView 
