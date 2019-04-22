local BandView = import("app.views.BandView")
local ShopView = import("app.views.shop.ShopView")
local TopView = class("TopView", gailun.BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, filename = "views/club/top/topBg.png", scale9 = true, size = {display.width, 121}, ap = {0.5, 1}, x = display.cx, y = display.top, capInsets = cc.rect(1000, 20, 10, 10) },
        {type = TYPES.SPRITE, filename = "views/club/top/idBg.png", x = display.left + 130, y = display.top - 55, children = {}},
        {type = TYPES.SPRITE, filename = "views/club/top/diamondBg.png", x = display.left + 330, y = display.top - 35, children = {
            {type = TYPES.SPRITE, var = "scoreIcon_", filename = "views/club/top/scoreIcon.png", x = 0, y = 15},
            {type = TYPES.LABEL, var = "scoreLabel_", options = {text="999", size=28, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(247, 217, 50)}, y = 15, x = 30, ap = {0, 0.5}},
        }},
        {type = TYPES.SPRITE, filename = "views/club/top/diamondBg.png", x = display.left + 330, y = display.top - 85, children = {
            {type = TYPES.SPRITE, var = "diamondIcon_", filename = "res/images/common/zuanshi.png", x = 0, y = 15},
            {type = TYPES.LABEL, var = "diamondLabel_", options = {text="999", size=28, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(247, 217, 50)}, y = 15, x = 30, ap = {0, 0.5}},
            {type = TYPES.BUTTON, var = "addDiamondBtn_", normal = "res/images/dating/btn_add.png", autoScale = 1, ap = {0.5, 0.5}, ppx = 0.9, y = 15},
        }},
        {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView",x = display.left+80, y = display.top-55},
        {type = TYPES.BUTTON, var = "returnBtn_", normal = "views/club/top/back.png", autoScale = 1, ap = {1, 1}, x = display.right, y = display.top},
        {type = TYPES.BUTTON, var = "clubBtn_", normal = "res/images/julebu/main/qyq0.png", autoScale = 1, ap = {0, 1}, x = display.left + 434, y = display.top - 4},
        {type = TYPES.BUTTON, var = "championBtn_", normal = "res/images/julebu/main/bsc0.png", autoScale = 1, ap = {0, 1}, x = display.left + 635, y = display.top - 4},
        {type = TYPES.LABEL, var = "name_", options = {text="999", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 255, 255)}, x = display.left+122, y = display.top-37, ap = {0, 0.5}},
        {type = TYPES.LABEL, var = "id_", options = {text="ID", size=20, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(247, 217, 50)}, x = display.left+122, y = display.top-72, ap = {0, 0.5}},

        {type = TYPES.BUTTON, var = "switchModelBtn_", normal = "views/club/top/hallModelBtn.png", autoScale = 1, ap = {0, 1}, x = display.right - 300, y = display.top - 4},
    }
}
function TopView:ctor()
    gailun.uihelper.render(self, node)
    self.callback = function () return true end
    self:initEvent()
    -- self.name_:setString(selfData:getNickName())
    self.name_:setString(gailun.utf8.formatNickName(selfData:getNickName(), 8, '..'))
    self.id_:setString("ID:"..selfData:getUid())
    self.diamondLabel_:setString(selfData:getDiamond())
    self.avatar_:showWithUrl(selfData:getAvatar())

    self.nowModel = 0
    self.index = 0
    self:updateDiamonds()
end

function TopView:setYuanBao()
    if self.index == 0 then
        self.scoreLabel_:setString(selfData:getYuanBao())
    end
end

function TopView:setCallback(callback)
    self.callback = callback
end

function TopView:setSwitchCallback(callback)
    self.switchCallback = callback
end

function TopView:setScore(dou)
    if self.index ~= 1 then
        return
    end
    self.scoreLabel_:setString(dou) 
end

function TopView:initEvent()
    self.returnBtn_:onButtonClicked(handler(self, self.onReturnBtn_))
    self.addDiamondBtn_:onButtonClicked(handler(self, self.onAddDiamondBtn_))
    self.clubBtn_:onButtonClicked(handler(self, self.onClubBtn_))
    self.championBtn_:onButtonClicked(handler(self, self.onChampionBtn_))

    self.switchModelBtn_:onButtonClicked(handler(self, self.onSwitchModelBtn_))

    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.SHOP_CONF, handler(self, self.onShopConf_))
end

function TopView:onSwitchModelBtn_()
    self.nowModel = self.nowModel == 0 and 1 or 0

    if self.nowModel == 0 then
        self.switchModelBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "views/club/top/hallModelBtn.png", true)
    elseif self.nowModel == 1 then
        self.switchModelBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "views/club/top/packageModelBtn.png", true)
    end
    self.switchCallback(self.nowModel)
end

function TopView:initSwitchModel(model)
    self.nowModel = model == 1 and 1 or 0
    if self.nowModel == 0 then
        self.switchModelBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "views/club/top/hallModelBtn.png", true)
    elseif self.nowModel == 1 then
        self.switchModelBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "views/club/top/packageModelBtn.png", true)
    end
end

function TopView:setSwitchModel(model)
    self:initSwitchModel(model)
    self.switchCallback(self.nowModel)
end

function TopView:onAddDiamondBtn_()
    if selfData:getFatherId() == 0 then
        local view = BandView.new():addTo(self)
        view:tanChuang(150)
        return
    end
    app:showLoading("")

    if self.index == 0 then
        self.shopShowType = 1
    else
        self.shopShowType = 3
    end
    self:requestShopConf()
end

function TopView:onShopConf_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            local resData = json.decode(data.data)
            resData.shopShowType = self.shopShowType or 1
            if self.shopView_ and not tolua.isnull(self.shopView_) then
                self.shopView_:removeFromParent()
            end
            self.shopView_ = ShopView.new(resData, self.index+1):addTo(display.getRunningScene(),999)
            self.shopView_:tanChuang(150)
            app:clearLoading()
        end
    end
end


function TopView:requestShopConf()
    local params = {}
    httpMessage.requestClubHttp(params, httpMessage.SHOP_CONF)
end

function TopView:onReturnBtn_()
    if selfData:isInGame() then
        app:showTips("您正在房间内，无法退出亲友圈，请先退出房间")
        return
    end
    app:showLoading("正在进入社区")
    httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
end

function TopView:updateDiamonds()
    HttpApi.queryDiamondMessage(handler(self, self.onHttpDiamondReturn_))
end

function TopView:onHttpDiamondReturn_(data)
    if tolua.isnull(self) then return end
    local result = json.decode(data)
    if not result then
        return
    end
    if result.status == -1 then
        app:enterLoginScene()
        return
    end
    if result.status ~= 1 then
        printInfo("onHttpDiamondReturn_ with ")
        return
    end
    local diamond = checkint(result.data.diamond)
    selfData:setDiamond(diamond)
    local laJiaoDou = checkint(result.data.laJiaoDou)
    selfData:setBiSaiKa(laJiaoDou)

    self:switchTag(self.index)
end

function TopView:switchTag(index)
    if index == 0 then
        self:onClubBtn_()
    elseif index == 1 then
        self:onChampionBtn_()
    end
end

function TopView:onClubBtn_()
    local result = self.callback(0)
    if isResult == false then
        return
    end
    self.index = 0
    self.clubBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/images/julebu/main/qyq1.png", true)
    self.championBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/images/julebu/main/bsc0.png", true)

    self.diamondLabel_:setString(selfData:getDiamond())
    self.diamondIcon_:setTexture("res/images/common/zuanshi.png")

    self.scoreLabel_:setString(selfData:getYuanBao())
    self.scoreIcon_:setTexture("res/images/shop/icon/y0.png")
end

function TopView:onChampionBtn_()
    if not ChaGuanData.isOpenChampion() then
        app:showTips("比赛场暂未开放")
        return
    end

    local result = self.callback(1)
    if isResult == false then
        return
    end

    self.index = 1
    self.clubBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/images/julebu/main/qyq0.png", true)
    self.championBtn_:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/images/julebu/main/bsc1.png", true)

    self.scoreLabel_:setString(ChaGuanData.getClubInfo().dou)
    self.scoreIcon_:setTexture("views/club/top/scoreIcon.png")

    self.diamondLabel_:setString(selfData:getBiSaiKa())
    self.diamondIcon_:setTexture("res/images/common/bsk.png")
end

return TopView