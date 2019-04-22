local BaseView = import("app.views.BaseView")
local SignInView = class("SignInView", BaseView)

local itemTypeMap = {
    [1] = {
        name = "钻石",
        icon = "res/images/shop/icon/z2.png",
    },
    [2] = {
        name = "积分",
        icon = "res/images/shop/icon/z2.png",
    },
    [3] = {
        name = "比赛卡",
        icon = "res/images/shop/icon/d2.png",
    },
    [4] = {
        name = "红辣椒",
        icon = "res/images/shop/icon/j2.png",
    }
}

function SignInView:ctor(data)
    SignInView.super.ctor(self)

    self.effect_:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 30)))
    self:initView(data)
end

function SignInView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/signIn/signIn.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SignInView:initView(data)
    local nodeList = {self.reward1Node_, self.reward2Node_, self.reward3Node_, self.reward4Node_, self.reward5Node_, self.reward6Node_}

    local count, time = selfData:getSignData()

    local signDay = math.ceil((time + 8 * 3600) / 3600 / 24)
    local nowDay = math.ceil((gailun.utils.getTime() + 8 * 3600) / 3600 / 24)
    local canReceive = nowDay - signDay > 0

    -- if nowDay - signDay > 1 then
    --     app:showTips("您最近的签到已经断了,将重新开始")
    --     count = 0
    -- end

    local nowIndex = math.max(count + (canReceive and 1 or 0))
    local nowData = table.remove(data, nowIndex)

    self:initTodayNode(nowData, canReceive)

    for k, v in ipairs(nodeList) do
        local rewardInfo = data[k]
        if rewardInfo ~= nil then

            local str = rewardInfo.item_count .. "颗" .. itemTypeMap[rewardInfo.item_type].name
            v:getChildByName("txt_nowRewardName"):setString(str)
            v:getChildByName("spr_nowDay"):setTexture("views/signIn/day" .. rewardInfo.id .. ".png")
            v:getChildByName("node_rewardIcon"):removeAllChildren()
            v:getChildByName("node_rewardIcon"):setScale(0.8)
            v:getChildByName("node_rewardIcon"):addChild(display.newSprite(itemTypeMap[rewardInfo.item_type].icon))

            print(nowIndex, rewardInfo.id)
            if nowIndex > rewardInfo.id then
                v:getChildByName("spr_blueBg"):setVisible(true)
                v:getChildByName("spr_alreadyTag"):setVisible(true)
                v:getChildByName("spr_yellowBg"):setVisible(false)
                v:getChildByName("spr_nowDay"):setVisible(false)
            else
                v:getChildByName("spr_blueBg"):setVisible(false)
                v:getChildByName("spr_alreadyTag"):setVisible(false)
                v:getChildByName("spr_yellowBg"):setVisible(true)
                v:getChildByName("spr_nowDay"):setVisible(true)
            end
        end
    end
end

function SignInView:initTodayNode(nowData, canReceive)
    self.getRewardBtn_:setBright(canReceive == true)
    self.getRewardBtn_:setEnabled(canReceive == true)

    local str = nowData.item_count .. "颗" .. itemTypeMap[nowData.item_type].name
    self.todayRewardNode_:getChildByName("txt_nowRewardName"):setString(str)

    self.todayRewardNode_:getChildByName("spr_nowDay"):setTexture("views/signIn/day" .. nowData.id .. ".png")

    self.todayRewardNode_:getChildByName("node_rewardIcon"):removeAllChildren()
    self.todayRewardNode_:getChildByName("node_rewardIcon"):setScale(0.8)
    self.todayRewardNode_:getChildByName("node_rewardIcon"):addChild(display.newSprite(itemTypeMap[nowData.item_type].icon))
end

function SignInView:getRewardBtnHandler_()
    HttpApi.signInActivity(function (event)
        local data = json.decode(event)
        if data.status == 1 then
            app:showTips("签到成功")
            display.getRunningScene():updateDiamonds()

            if tolua.isnull(self) then
                return
            end


            selfData:updateSignData()
            self.getRewardBtn_:setBright(canReceive == true)
            self.getRewardBtn_:setEnabled(canReceive == true)
            local scene = display.getRunningScene()
            if scene.showHDRed then
                scene:showHDRed()
            end
            self:closeHandler_()
        else
            app:showTips("您已经领取过今天的奖励了")
            dump(data)
        end
    end)
end

return SignInView
