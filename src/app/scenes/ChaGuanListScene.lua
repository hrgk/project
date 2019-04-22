local BaseScene = import("app.scenes.BaseScene")
local ChaGuanData = import("app.data.ChaGuanData")
local ShopView = import("app.views.shop.ShopView")
local ChaGuanListScene = class("ChaGuanListScene", BaseScene)
local ChaGuanList = import("app.views.chaguan.ChaGuanList")
local JoinRoom = import("app.views.hall.JoinRoom")

function ChaGuanListScene:ctor(data)
    self.data_ = data
    ChaGuanListScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    --gameAudio.playMusic("sounds/julebu_bgm.mp3", true)
    gameAudio.playMusic("sounds/niuniu/bgm.mp3", true)
    app:initMusicState_()
    self.tipInfo = {"您还没有创建亲友圈哟","您还没有加入亲友圈哟","暂无亲友圈信息，请创建亲友圈或者加入亲友圈"}
    self:getSelectData()
end

function ChaGuanListScene:getSelectData()
    self.myClubData = {}
    self.otherClubData = {}
    self.seletDate = {self.myClubData,self.otherClubData,self.data_}
    for i = 1,#self.data_ do
        if self.data_[i].uid then
            if self.data_[i].uid == selfData:getUid() then
                table.insert(self.myClubData,self.data_[i])
            else
                table.insert(self.otherClubData,self.data_[i])
            end
        end
    end
end

function ChaGuanListScene:addJoinInfo(clubID)
    for i = 1,3 do
        for j = 1,#self.seletDate[i] do
            if self.seletDate[i][j].clubID == clubID then
                self.seletDate[i][j].review = 1
            end
        end
    end
end

function ChaGuanListScene:onEnterTransitionFinish()
    ChaGuanListScene.super.onEnterTransitionFinish(self)
    dataCenter:startKeepOnline()
    dataCenter:resumeSocketMessage()
    self:initChaGuanView_(self.data_)
    httpMessage.requestClubHttp({}, httpMessage.GET_CLUB_CONFIG)
end

function ChaGuanListScene:loaderCsb()
    self.csbNode_ = cc.uiloader:load("scenes/ChaGuanListScene.csb"):addTo(self)
end

function ChaGuanListScene:bindEvent()
    ChaGuanListScene.super.bindEvent(self)
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.CREATE_CLUB, handler(self, self.onCreateClubHandler_))
    :addEventListener(httpMessage.JOIN_CLUB, handler(self, self.onJoinClubHandler_))
    :addEventListener(httpMessage.GET_CLUB_CONFIG, handler(self, self.onClubConfigHandler_))
    :addEventListener(httpMessage.SHOP_CONF, handler(self, self.onShopConf_))
end

function ChaGuanListScene:onShopConf_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            local resData = json.decode(data.data)
            resData.shopShowType = self.shopShowType or 1
            self.shopShowType = nil
            if self.shopView_ and not tolua.isnull(self.shopView_) then
                self.shopView_:removeFromParent()
            end
            self.shopView_ = ShopView.new(resData, 1):addTo(self,999)
            self.shopView_:tanChuang(150)
            app:clearLoading()
        end
    end
end

function ChaGuanListScene:shopHandler_()
    if selfData:getFatherId() == 0 then
        display.getRunningScene():showBandView()
        return
    end
    app:showLoading("")
    self:requestShopConf()
end

function ChaGuanListScene:requestShopConf()
    local params = {}
    httpMessage.requestClubHttp(params, httpMessage.SHOP_CONF)
end

function ChaGuanListScene:onAllBroadcast_(event)
    if event.data.type == 4 then
        app:showLoading("正在进入社区")
        local params = {}
        params.clubID = event.data.data.clubID
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
    elseif event.data.type == 2 then
        app:showTips("有玩家申请加入社区")
        ChaGuanData.setRedPoint(true)
        self:addJoinInfo(event.data.data.clubID)
        self:updateTYype(self.type_,true)
    end
end

function ChaGuanListScene:onGetClubsHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            self.data_ = data.data
            self:getSelectData()
            self:updateTYype(3,true)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanListScene:onClubConfigHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            ChaGuanData.setConfig(data.data)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanListScene:onJoinClubHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:showTips("申请成功，请等待馆主审核")
            if self.addView_ then
                self.addView_:removeSelf()
                self.addView_ = nil
            end
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanListScene:onCreateClubHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            -- app:showLoading("正在进入社区")
            httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
        else
            app:showTips(CLUB_HTTP_ERR[data.status])
        end
    end
end

function ChaGuanListScene:createChaGaunView()
    local view = app:createView("chaguan.CreateChaGuan")
    self:addChild(view)
end

function ChaGuanListScene:type1hideHandler_(event)
    self:updateTYype(1)
end

function ChaGuanListScene:type2hideHandler_(event)
    self:updateTYype(2)
end

function ChaGuanListScene:type3hideHandler_(event)
    self:updateTYype(3)
end

function ChaGuanListScene:updateTYype(type,needShow)
    self.type_ = type
    clubData:setCreateType(type)
    if self["type" .. type .. "show_"]:isVisible() and not needShow then
        return
    end
    for i = 1,3 do
        self["type" .. i .. "show_"]:setVisible(type == i)
    end
    if #self.seletDate[type] > 0 then
        self.msg_:hide()
    else
        self.msg_:show()
        self.msg_:setString(self.tipInfo[type])
    end
    self.listView_:update(self.seletDate[type])
end

function ChaGuanListScene:initChaGuanView_()
    if #self.data_ > 0 then
        self.msg_:hide()
    end
    self.listView_ = ChaGuanList.new()
    self:updateTYype(3,true)
    self.content_:addChild(self.listView_)
end

function ChaGuanListScene:initInputView(inputType)
    local view = JoinRoom.new(inputType):addTo(self)
    view:tanChuang()
end

function ChaGuanListScene:addClubHandler_()
    self.addView_ = JoinRoom.new(3):addTo(self)
    self.addView_:tanChuang()
end

function ChaGuanListScene:createClubHandler_()
    local view = app:createView("chaguan.CreateChaGuan")
    self:addChild(view)
    view:tanChuang()
end

function ChaGuanListScene:returnHandler_()
    clubData:setCreateType("")
    app:enterHallScene()
end

return ChaGuanListScene 
