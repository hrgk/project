local BaseScene = import(".BaseScene")
local DaTingScene = class("DaTingScene", BaseScene)
local JoinRoom = import("app.views.hall.JoinRoom")
local CreateRoomView = import("app.views.hall.CreateRoomView")
local EditRoomView = import("app.views.hall.editRoomView.EditRoomView")
local SetView = import("app.views.hall.SetViewNew")
local PlayerHead = import("app.views.PlayerHead")
local ZhanJiListView = import("app.views.zhan_ji.ZhanJiListView")
local ZhanJuListView = import("app.views.zhan_ji.ZhanJuListView")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local KefuView = import("app.views.hall.KefuView")
local AppMapView = import("app.views.hall.AppMapView")
local SignInView = import("app.views.hall.SignInView")
local AppMapSubView = import("app.views.hall.AppMapSubView")
local AddressView = import("app.views.hall.AddressView")
-- local ZuanShiTiShiView = import("app.views.activitys.ZuanShiTiShiView")
local FanKuiView = import("app.views.FanKuiView")
local ShareView = import("app.views.hall.ShareView")
local ShopView = import("app.views.shop.ShopView")
local XiaoXiView = import("app.views.xiaoxi.XiaoXiView")
local HuoDongView = import("app.views.huodong.HuoDongView")
local GuiZeView = import("app.views.GuiZeView")
local DaiLiView = import("app.views.daili.DaiLiView")
local BandView = import("app.views.BandView")
local ErWeiShareView = import("app.views.ErWeiShareView")
local NewYearView = import("app.views.hall.NewYearView")


function DaTingScene:ctor()
    DaTingScene.super.ctor(self)
    dataCenter:tryConnectSocket()
    dataCenter:setRoomID(0)

    print("check firstLaunch", setData:getFirstLaunchCheck())
    if setData:getFirstLaunchCheck() == "" or setData:getFirstLaunchCheck() == nil then
        setData:setFirstLaunchCheck()

        self:checkAddr()
    end

    -- print("---------asdfasdfasdf")
    -- dump(al.getAllPropaganda({103, 203, 303, 403, 518, 520}, {107, 107, 207, 207, 307, 208, 208, 308}, {bianPai = 2}))
    -- dump(al.checkBombCount({103, 103, 103, 103}, {{204, 204, 204, 204}, {105, 105, 105, 105}}, {4, 4, 4}))

    chatRecordData:clearGameRecord()

    -- require("app.views.game.CuoPokerView").new(520):addTo(self.csbNode_, 1000)
    self:initNode(self.huaTiao_)
    self.huaTiao_:hide()
    self.addDou_:hide()
    self:setAddress()
    self:showHDRed()
    --特制项目界面调整
    if SPECIAL_PROJECT then
        self.change_:hide()
        self.changebg_:hide()
        self.address_:hide()
    end
end

function DaTingScene:getAddr_()
    local inf = dataCenter:getLocationInfo()
    if inf[1] == "181" and inf[2] == "91" then
        return 
    end
  
    local url = string.format("https://apis.map.qq.com/ws/geocoder/v1/?location=%s,%s&key=YUMBZ-ZLUWI-DLMGN-5WYKA-PLAKO-44B4J&get_poi=1",inf[2],inf[1])
    local http = require "loader.http"
    http.get(
        url,
        function (event)
            local info = json.decode(event)
            if info.status ~= 0 then
                return
            end
            -- self.Adr_:setString(info.result.address)
            selfData:setAddress(info.result.address)
        end,
        function ()
        end
    )
end

function DaTingScene:yanhuoPlay()
    self.animaLayer_ = display.newSprite():addTo(self.csbNode_, 100):pos(display.cx, display.cy)
    local yanhua1X = math.random(-500,500)
    local yanhua1Y = math.random(-300,300)

    local yanhua1 = FaceAnimationsData.getCocosAnimation(45)
    yanhua1.x = yanhua1X
    yanhua1.y = yanhua1Y
    gameAnim.createCocosAnimations(yanhua1, self.animaLayer_)

    self:performWithDelay(function()
        local yanhua2X = math.random(-500,500)
        local yanhua2Y = math.random(-300,300)
        local yanhua2 = FaceAnimationsData.getCocosAnimation(46)
        yanhua2.x = yanhua2X
        yanhua2.y = yanhua2Y
        gameAnim.createCocosAnimations(yanhua2, self.animaLayer_)
    end, 0.5)
end

function DaTingScene:addXue()
    local snow_part1 = cc.ParticleSystemQuad:create("textures/snow/snow.plist")
    snow_part1:setPositionX(display.cx+300)
    self.bg_:addChild(snow_part1)
    local snow_part2 = cc.ParticleSystemQuad:create("textures/snow1/snow.plist")
    snow_part2:setPositionX(display.cx+300)
    self.bg_:addChild(snow_part2)
end

function DaTingScene:newYearHandler_()
    if not CHANNEL_CONFIGS.CHUN_JIE_HUO_DONG then
        app:showTips("春节活动暂未开启，敬请期待")
        return
    end
    local view = NewYearView.new():addTo(self.csbNode_)
    view:tanChuang(150)
end

function DaTingScene:showHDRed()
    local signCount,signTime = selfData:getSignData()
    local nowTime = gailun.utils.getTime()
    signTime = os.date("%Y-%m-%d", signTime)
    nowTime = os.date("%Y-%m-%d", nowTime)
    if nowTime ~= signTime then
        self.signRed_:show()
    else
        self.signRed_:hide()
    end
end

function DaTingScene:onGetDetailsResult(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == -3 then
            -- 清理recordId
            gameLocalData:setGameRecordID("")
            return
        end
    end

    DaTingScene.super.onGetDetailsResult(self, event)
end

function DaTingScene:initShenHe()
    if CHANNEL_CONFIGS.DIAMOND == false then
        self.zuanshibg_:setVisible(false)
        self.zuanshi_:setVisible(false)
        self.zuanshiTxt_:setVisible(false)
        self.zj_:setVisible(false)
        self.downLine_:setVisible(false)
    end

    if CHANNEL_CONFIGS.DAI_LI == false then
        self.zj_:setVisible(false)
        self.kf_:setVisible(false)
        self.downLine_:setVisible(false)
    end

    if CHANNEL_CONFIGS.SHARE == false then
        self.zj_:setVisible(false)
        self.share_:setVisible(false)
        self.downLine_:setVisible(false)
    end

    if CHANNEL_CONFIGS.RECOMMEND == false then
        self.zj_:setVisible(false)
        self.huoDong_:setVisible(false)
        self.downLine_:setVisible(false)
    end

    if CHANNEL_CONFIGS.MARKET == false then
        self.zj_:setVisible(false)
        self.shop_:setVisible(false)
        self.downLine_:setVisible(false)
    end
end

function DaTingScene:initHead_()
    local data = {}
    data.nickName = selfData:getNickName()
    data.avatar = selfData:getAvatar()
    data.sex = selfData:getSex()
    data.uid = selfData:getUid()
    local view = PlayerHead.new(data)
    view:setNode(self.head_)
    view:showWithUrl(selfData:getAvatar())
end

function DaTingScene:setAddress()
    local info = setData:getAddress()
    info = string.split(info, ':')
    local addrInfo = ADDRESS_FONT[info[1]+0]
    if info[2] then
        addrInfo = addrInfo .. ADDRESS_FONT[info[2]+0]
    end 
    self.address_:setString(addrInfo)
end

function DaTingScene:initUserInfo()

    self.name_:setString(gailun.utf8.formatNickName(selfData:getNickName(), 8, '..'))
    self.ID_:setString("ID:"..selfData:getUid())
    self.zuanshiTxt_:setString(selfData:getDiamond())
    --self.douTxt_:setString(selfData:getScore())
    self.ybTxt_:setString(selfData:getYuanBao())
end

function DaTingScene:onEnterTransitionFinish()
    DaTingScene.super.onEnterTransitionFinish(self)
    dataCenter:resumeSocketMessage()
    self:initUserInfo()
    self:initHead_()
    self:initShenHe()
    self:updateDiamonds()
    if self.paoView_ == nil then
        self.paoView_ = app:createView("MarqueeView", display.cx, 580):addTo(self.csbNode_)
        self.paoView_:run(StaticConfig.sysBroadcast)
    end
    gameAudio.playMusic("sounds/dating_bgm.mp3", true)
    app:initSoundState_()
    app:initMusicState_()
    local time = math.random(1,5)
    local sequence = transition.sequence({
        cc.CallFunc:create(function ()
                    self:yanhuoPlay()
                end),
        cc.DelayTime:create(time),
        })
    self:runAction(cc.RepeatForever:create(sequence))
    if  CHANNEL_CONFIGS.CHUN_JIE_HUO_DONG then
        self:newYearHandler_()
    end
    self:getAddr_()
end

function DaTingScene:bindEvent()
    DaTingScene.super.bindEvent(self)
    cc.EventProxy.new(dataCenter, self, true)
    :addEventListener(httpMessage.FEED_BACK, handler(self, self.onFeedBack_))
    :addEventListener(httpMessage.SHOP_CONF, handler(self, self.onShopConf_))
end

function DaTingScene:onFeedBack_(event)
    if event.data.isSuccess then
        app:showTips("提交成功")
    end
end

function DaTingScene:loaderCsb()
    self.csbNode_ = cc.uiloader:load("scenes/NewYearDaTingScene.csb"):addTo(self)
end

function DaTingScene:shezhiHandler_()
    local view = SetView.new():addTo(self)
    view:tanChuang()
    self.huaTiao_:hide()
end

function DaTingScene:shareHandler_()
    if SPECIAL_PROJECT then
        app:showTips("该功能开发中，敬请期待!")
        return
    end
    self.huaTiao_:hide()
    if selfData:getFatherId() == 0 then
        self:showBandView()
        return
    end
    local view = ShareView.new():addTo(self)
    view:tanChuang()
end

function DaTingScene:keFuHandler_()
    local view = KefuView.new():addTo(self)
    view:tanChuang()
    self.huaTiao_:hide()
end

function DaTingScene:fanKuiHandler_()
    local view = FanKuiView.new():addTo(self)
    view:tanChuang(150)
    self.huaTiao_:hide()
end

function DaTingScene:zjHandler_()
    local view = ZhanJiListView.new():addTo(self)
    view:tanChuang(150)
    self.huaTiao_:hide()
end

function DaTingScene:requestShopConf()
    local params = {}
    httpMessage.requestClubHttp(params, httpMessage.SHOP_CONF)
end

function DaTingScene:onShopConf_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            local resData = json.decode(data.data)
            resData.shopShowType = self.shopShowType or 1
            self.shopShowType = nil
            if self.shopView_ and not tolua.isnull(self.shopView_) then
                self.shopView_:removeFromParent()
            end
            self.shopView_ = ShopView.new(resData, 1, self.cType_):addTo(self,999)
            self.shopView_:tanChuang(150)
            app:clearLoading()
        end
    end
end

function DaTingScene:shopUpdate()
    if self.shopView_ and not tolua.isnull(self.shopView_) then
        self.shopView_:upDateInfo()
    end
end

function DaTingScene:shopHandler_()
    if selfData:getFatherId() == 0 then
        display.getRunningScene():showBandView()
        return
    end
    self.cType_ = 1
    app:showLoading("")
    self:requestShopConf()
    self.huaTiao_:hide()
end

function DaTingScene:juLeBuHandler_(data)
--    绑定功能关闭的话  注释这里判断
--    if selfData:getFatherId() == 0 then
--        self:showBandView()
--        return
--    end
    if CHANNEL_CONFIGS.CLUB_IS_OPEN == false then
        app:showTips("该功能开发中，敬请期待!")
        return
    end
    app:showLoading("正在进入社区")
    httpMessage.requestClubHttp(nil, httpMessage.GET_CLUBS)
end

function DaTingScene:huoDongHandler_()
    local view = HuoDongView.new():addTo(self)
    view:tanChuang(150)
    self.huaTiao_:hide()
end

function DaTingScene:joinRoomHandler_()
    self:initInputView(1)
    self.huaTiao_:hide()
end

function DaTingScene:guizeHandler_()
    local view = GuiZeView.new():addTo(self)
    view:tanChuang(150)
    self.huaTiao_:hide()
end

function DaTingScene:showBandView()
    local view = BandView.new():addTo(self,999)
    view:tanChuang(150)
end

function DaTingScene:showAddressView()
    local view = AddressView.new():addTo(self,999)
    view:tanChuang(150)
end

function DaTingScene:showAppMapSubView(mainIndex,subIndex)
    local view = AppMapSubView.new(mainIndex,subIndex):addTo(self)
    view:tanChuang(150)
end

function DaTingScene:showAppMapView(mianIndex,subIndex)
    local view = AppMapView.new(mianIndex,subIndex):addTo(self)
    view:tanChuang(150)
end

function DaTingScene:changeHandler_()
    local info = setData:getAddress()
    info = string.split(info, ':')
    dump(info,"info-info-info-info-info")
    if info[2] then
        self:showAppMapSubView(info[1]+0,info[2]+0)
    else 
        self:showAppMapSubView(info[1]+0,nil)
    end
    self.huaTiao_:hide()
end

function DaTingScene:moreGameHandler_()
    -- app:showTips("敬请期待!")
    self.huaTiao_:setVisible( not self.huaTiao_:isVisible())
end

function DaTingScene:ltsHandler_()
    app:showTips("敬请期待!")
    self.huaTiao_:hide()
end

function DaTingScene:bscHandler_()
    -- http://yt.jingangdp.com/Login/UploadQcode?Sing= Base64加密uid
    app:showTips("敬请期待!")
    self.huaTiao_:hide()
end

function DaTingScene:qdHandler_()
    HttpApi.getSignInItems(function (event)
        local data = json.decode(event)
        if data.status == 1 then
            local view = SignInView.new(data.data):addTo(self)
            view:tanChuang(150)
        end
    end)
    self.huaTiao_:hide()
end

function DaTingScene:xxqHandler_()
    -- app:showTips("敬请期待!")
    self:shopHandler_()
    self.huaTiao_:hide()
end

function DaTingScene:msgHandler_()
    local view = XiaoXiView.new():addTo(self)
    view:tanChuang(150)
    self.huaTiao_:hide()
end

function DaTingScene:addZSHandler_()
    self:shopHandler_()
    self.cType_ = 1
    self.huaTiao_:hide()
end

function DaTingScene:addYbHandler_()
    self:shopHandler_()
    self.cType_ = 2
    self.huaTiao_:hide()
end

function DaTingScene:addDouHandler_()
    self.shopShowType = 3
    self:shopHandler_()
    self.huaTiao_:hide()
end

function DaTingScene:copyIDHandler_()
    gailun.native.copy(selfData:getUid() .. "")
    app:showTips("复制成功!")
end

function DaTingScene:dailiHandler_()
    -- local view = DaiLiView.new():addTo(self)
    -- view:tanChuang(150)
    app:showTips("敬请期待")
end

function DaTingScene:createRoomHandler_()
    local view = CreateRoomView.new(1):addTo(self, 100)
    -- local view = EditRoomView.new(1):addTo(self, 100)
    view:tanChuang()
    self.huaTiao_:hide()
end

function DaTingScene:initInputView(inputType)
    local view = JoinRoom.new(inputType):addTo(self)
    view:tanChuang()
    return view
end

function DaTingScene:initZhanJuList(data, isHuiFang)
    local view = ZhanJuListView.new(data,isHuiFang):addTo(self)
    view:tanChuang()
    return view
end

function DaTingScene:initErWeiView(inScene, callfunc)
    local view = ErWeiShareView.new(inScene, callfunc):addTo(self)
    view:tanChuang()
end

function DaTingScene:zuanShiTishi(count)
    -- local view = ZuanShiTiShiView.new(count)
    -- self.layerWindows_:addChild(view, 10)
end

function DaTingScene:updateDiamonds()
    HttpApi.queryDiamondMessage(handler(self, self.onHttpDiamondReturn_), handler(self, self.onHttpDiamondFail_))
end

function DaTingScene:onHttpDiamondReturn_(data)
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
    local laJiaoDou = checkint(result.data.laJiaoDou)
    if diamond > selfData:getDiamond() then
        app:showTips("恭喜获得"..(diamond-selfData:getDiamond()).."颗钻石")
    end
    selfData:setYuanBao(result.data.yuanBao)
    selfData:setDiamond(diamond)
    selfData:setScore(result.data.score)
    selfData:setBiSaiKa(laJiaoDou)
    self.zuanshiTxt_:setString(diamond)
    self.ybTxt_:setString(result.data.yuanBao)
    --self.douTxt_:setString(result.data.score)
    self:shopUpdate()
end

function DaTingScene:setZuanShi(diamond)
    self.zuanshiTxt_:setString(diamond)
end

function DaTingScene:onHttpDiamondFail_()
    printInfo("HallScene:onHttpDiamondFail_")
end

return DaTingScene 
