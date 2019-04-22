local JiFuInfoView = class("JiFuInfoView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_ditu.png", px = 0.5, py = 0.44 ,scale9 = true, size ={914, 522}},
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_shuoming.png", px = 0.498, py = 0.45, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "yellowD_",filename = "res/images/jifu/jifu_yellow_d.png", px = 0.62, py = 0.32 ,scale9 = true, size ={315, 50}},
            {type = TYPES.LABEL, var = "yitianxieLabel_", options = {text="您已填写，邀请他人获得现金红包", size = 18, font = DEFAULT_FONT, color = cc.c4b(0, 0, 0, 255)}, visible = true, px = 0.61, py = 0.32, ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonYaoqing_", normal = "res/images/jifu/jifu_yaoqing.png", px = 0.57, py = 0.32},
            {type = TYPES.BUTTON, var = "buttonTiJiao_", autoScale = 0.9, normal = "res/images/jifu/jifu_tijiao.png", px = 0.71, py = 0.32},
            {type = TYPES.BUTTON, var = "buttonFenXiang_", autoScale = 0.9, normal = "res/images/hall/rankshare.png", px = 0.22, py = 0.17},
            {type = TYPES.LABEL, var = "inputLabel_", options = {text="请输入邀请者ID", size = 18, font = DEFAULT_FONT, color = cc.c4b(143, 143, 143, 255)}, visible = true, px = 0.52, py = 0.32, ap = {0, 0.5}},
            {type = TYPES.LABEL, var = "inviteCount_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.665, py = 0.538, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "inviteFu_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.77, py = 0.538, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "createRoomCount_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.665, py = 0.492, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "createRoomFu_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.77, py = 0.492, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "reInviteCount_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.665, py = 0.445, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "reInviteFu_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.77, py = 0.445, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "totalFu_", options = {text="0", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.77, py = 0.39, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "activityTime_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, visible = true, px = 0.5, py = 0.75, ap = {0.5, 0.5}},
            }
        }

function JiFuInfoView:ctor()
    JiFuInfoView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.buttonYaoqing_:onButtonClicked(handler(self, self.yaoQingHandler_))
    self.buttonTiJiao_:onButtonClicked(handler(self, self.tijiaoHandler_))
    self.buttonFenXiang_:onButtonClicked(handler(self, self.fenXiangHandler_))
    self.testID_ = true
    self.numberStr_ = ""
    self.buttonTiJiao_:hide()
    self.inputLabel_:hide()
    self.buttonYaoqing_:hide()
    self.yitianxieLabel_:hide()
    self.yellowD_:hide()
end

function JiFuInfoView:update(data)
    local startTime = os.date("%Y-%m-%d", data.startTime)
    local endTime =  os.date("%Y-%m-%d", data.endTime)
    local info = data.myJiFu
    self.inviteCount_:setString(info.inviteCount)
    self.inviteFu_:setString(info.inviteFu)
    self.createRoomCount_:setString(info.createRoomCount)
    self.createRoomFu_:setString(info.createRoomFu)
    self.reInviteCount_:setString(info.reInviteCount)
    self.reInviteFu_:setString(info.reInviteFu)
    self.totalFu_:setString(info.totalFu)
    self.activityTime_:setString("活动时间 " .. startTime .. "--" .. endTime)
    if info.isBind then
        self.yitianxieLabel_:show()
        self.yellowD_:show()
        return
    end
    if info.canBind then
        self.buttonTiJiao_:show()
        self.inputLabel_:show()
        self.buttonYaoqing_:show()
    end
end

function JiFuInfoView:yaoQingHandler_(event)
    self.inputView_ = app:createView("hall.PuTongInputNumberView", "请输入邀请者ID"):addTo(self):pos(display.left + 300, display.cy)
    self.inputView_:scale(0.8)
    self.inputView_:setNumberInputCallback(handler(self, self.numberInput))
    self.inputView_:setCallback(handler(self, self.checkID_))
end

function JiFuInfoView:numberInput(num)
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

function JiFuInfoView:checkID_()
    HttpApi.getQueryUid(self.numberStr_, handler(self, self.queryUidHandler_), handler(self, self.queryUidFailHandler_))
end

function JiFuInfoView:queryUidHandler_(data)
    local obj = json.decode(data)
    if obj.data.exist == false then
        app:showTips("您输入的ID不存在!")
    else
        self.inputView_:removeSelf()
    end

    if 1 ~= obj.status then
        printInfo("查询用户ID失败!")
        return
    end
end

function JiFuInfoView:queryUidFailHandler_()
    app:showTips("查询用户ID失败!")
end

function JiFuInfoView:tijiaoHandler_(event)
    HttpApi.getBindInviter(self.numberStr_, handler(self, self.bindHandler_), handler(self, self.bindFailHandler_))
end

function JiFuInfoView:bindHandler_(data)
    local obj = json.decode(data)
    if obj.data.success == true then
        app:showTips("绑定成功!")
        self.inputLabel_:hide()
        self.buttonTiJiao_:hide()
        self.buttonYaoqing_:hide()
        self.yitianxieLabel_:show()
        self.yellowD_:show()
    else
        app:showTips("绑定失败!")
    end

    if 1 ~= obj.status then
        printInfo("用户ID提交失败!")
        return
    end
end

function JiFuInfoView:bindFailHandler_()
    app:showTips("提交失败!")
end

function JiFuInfoView:fenXiangHandler_(event)
    self.player_ = dataCenter:getHostPlayer()
    local nick = self.player_:getNickName()
    local ID = self.player_:getUid()
    local description = "您的好友：" .. nick .. "  邀请您加入[朋来棋牌]，来就送红包！猛戳。。。"
    local title = "游戏邀请  " .. "邀请者ID：" .. ID 
    local params = {
        type = "url",
        tagName = "",
        title = title,
        description = description,
        imagePath = "res/images/ic_launcher.png",
        url = StaticConfig:get("shareURL") or BASE_API_URL,
        inScene = 0,
    }
    gailun.native.shareWeChat(params)
end

return JiFuInfoView 
