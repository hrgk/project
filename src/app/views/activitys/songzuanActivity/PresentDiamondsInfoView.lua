local PresentDiamondsInfoView = class("PresentDiamondsInfoView", gailun.BaseView)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/jifu/jifu_ditu.png", px = 0.5, py = 0.44 ,scale9 = true, size ={914, 522}},
            {type = TYPES.SPRITE, filename = "res/images/songzuan/qiangzuan_back.png", px = 0.498, py = 0.45, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "yellowD_",filename = "res/images/jifu/jifu_yellow_d.png", px = 0.62, py = 0.32 ,scale9 = true, size ={315, 50}},
            {type = TYPES.LABEL, var = "yiTianXieLabel_", options = {text="您已填写，邀请他人获得钻石", size = 18, font = DEFAULT_FONT, color = cc.c4b(0, 0, 0, 255)}, visible = true, px = 0.62, py = 0.32, ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonYaoQing_", normal = "res/images/jifu/jifu_yaoqing.png", px = 0.57, py = 0.32},
            {type = TYPES.BUTTON, var = "buttonTiJiao_", autoScale = 0.9, normal = "res/images/jifu/jifu_tijiao.png", px = 0.71, py = 0.32},
            {type = TYPES.BUTTON, var = "buttonShare_", autoScale = 0.9, normal = "res/images/hall/rankshare.png", px = 0.293, py = 0.25},
            {type = TYPES.LABEL, var = "inputLabel_", options = {text="请输入邀请者ID", size = 18, font = DEFAULT_FONT, color = cc.c4b(143, 143, 143, 255)}, visible = true, px = 0.52, py = 0.32, ap = {0, 0.5}},
            {type = TYPES.LABEL, var = "inviteCount_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.683, py = 0.536, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "inviteDiamonds_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.771, py = 0.536, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "createRoomCount_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.683, py = 0.49, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "createRoomDiamonds_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.771, py = 0.49, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "reInviteCount_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.683, py = 0.443, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "reInviteDiamonds_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.771, py = 0.443, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "totalDiamonds_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 132, 0, 255)}, visible = true, px = 0.771, py = 0.388, ap = {1, 0.5}},
            {type = TYPES.LABEL, var = "activityTime_", options = {text="", size = 24, font = DEFAULT_FONT, color = cc.c4b(255, 255, 255, 255)}, visible = true, px = 0.5, py = 0.75, ap = {0.5, 0.5}},
            }
        }

function PresentDiamondsInfoView:ctor()
    PresentDiamondsInfoView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self:getDiamondsInfo_()
    self.buttonYaoQing_:onButtonClicked(handler(self, self.yaoQingHandler_))
    self.buttonTiJiao_:onButtonClicked(handler(self, self.tijiaoHandler_))
    self.buttonShare_:onButtonClicked(handler(self, self.ShareHandler_))
    self.testID_ = true
    self.numberStr_ = ""
    self.player_ = dataCenter:getHostPlayer()
    self.buttonTiJiao_:hide()
    self.inputLabel_:hide()
    self.buttonYaoQing_:hide()
    self.yiTianXieLabel_:hide()
    self.yellowD_:hide()
end

function PresentDiamondsInfoView:getDiamondsInfo_()
    HttpApi.getYaoQingInfo(handler(self, self.infoSucHandler_), handler(self, self.infoFailHandler_))
end

function PresentDiamondsInfoView:infoSucHandler_(data)
    local diamondsInfo = json.decode(data)
    if diamondsInfo.data.flag == 0 then
        return
    end
    if diamondsInfo.data.flag == 2 then
        return
    end
    if diamondsInfo.data.flag == 1 then
        self:update_(diamondsInfo.data)
    end
end

function PresentDiamondsInfoView:infoFailHandler_()
    app:showTips("获取活动数据失败")
end

function PresentDiamondsInfoView:update_(data)
    local info = data.myYaoQing
    self.inviteCount_:setString(info.inviteCount)
    self.inviteDiamonds_:setString(info.inviteZuan)
    self.createRoomCount_:setString(info.createRoomCount)
    self.createRoomDiamonds_:setString(info.createRoomZuan)
    self.reInviteCount_:setString(info.reInviteCount)
    self.reInviteDiamonds_:setString(info.reInviteZuan)
    self.totalDiamonds_:setString(info.totalZuan)
    if info.isBind then
        self.yiTianXieLabel_:show()
        self.yellowD_:show()
        return
    end
    if info.canBind then
        self.buttonTiJiao_:show()
        self.inputLabel_:show()
        self.buttonYaoQing_:show()
    end
end

function PresentDiamondsInfoView:yaoQingHandler_(event)
    self.inputLabel_:setString("")
    self.numberStr_ = ""
    self.inputView_ = app:createView("hall.PuTongInputNumberView", "请输入邀请者ID"):addTo(self):pos(display.left + 300, display.cy)
    self.inputView_:scale(0.8)
    self.inputView_:setNumberInputCallback(handler(self, self.numberInput))
    self.inputView_:setCallback(handler(self, self.checkID_))
end

function PresentDiamondsInfoView:numberInput(num)
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

function PresentDiamondsInfoView:checkID_()
    if checkint(self.numberStr_) == checkint(self.player_:getUid()) then
        app:showTips("请输入他人ID！")
        self.inputLabel_:setString("")
        return
    end
    if self.numberStr_ == "" or self.numberStr_ == nil then
        app:showTips("请输入正确的玩家ID!")
        return
    end
    HttpApi.getQueryUid(self.numberStr_, handler(self, self.queryUidHandler_), handler(self, self.queryUidFailHandler_))
end

function PresentDiamondsInfoView:queryUidHandler_(data)
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

function PresentDiamondsInfoView:queryUidFailHandler_()
    app:showTips("查询用户ID失败!")
end

function PresentDiamondsInfoView:tijiaoHandler_(event)
    HttpApi.bindYaoQingInviter(self.numberStr_, handler(self, self.bindHandler_), handler(self, self.bindFailHandler_))
end

function PresentDiamondsInfoView:bindHandler_(data)
    local obj = json.decode(data)
    if obj.data.success == true then
        app:showTips("绑定成功!")
        self.inputLabel_:hide()
        self.buttonTiJiao_:hide()
        self.buttonYaoQing_:hide()
        self.yiTianXieLabel_:show()
        self.yellowD_:show()
    else
        app:showTips("绑定失败!")
    end

    if 1 ~= obj.status then
        printInfo("用户ID提交失败!")
        return
    end
end

function PresentDiamondsInfoView:bindFailHandler_()
    app:showTips("提交失败!")
end

function PresentDiamondsInfoView:ShareHandler_(event)
    self.player_ = dataCenter:getHostPlayer()
    local nick = self.player_:getNickName()
    local ID = self.player_:getUid()
    local description = "您的好友：" .. nick .. "  邀请您加入[朋来棋牌]，猛戳。。。"
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

return PresentDiamondsInfoView 
