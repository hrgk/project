local BaseScene = import(".BaseScene")
local LoginScene = class("LoginScene", BaseScene)
local ChannelConfig = require("app.utils.ChannelConfig")

function LoginScene:ctor()
    LoginScene.super.ctor(self)
    self.name = "LoginScene"
    dataCenter:closeSocket()
    --
    -- StaticConfig:checkConfigUpdate(handler(self, self.checkVersion_))
    -- ChannelConfig.loadRemote(handler(self, self.onVersionDownloaded_))
    self:onLocation_()
    -- require("app.games.paodekuai.utils.RulesTest").new()
end

function LoginScene:init()
    if (CHANNEL_CONFIGS.WECHAT_LOGIN == false) then
        self.weiXinLogin_:setVisible(false)
    end

    if (CHANNEL_CONFIGS.GUEST_LOGIN == false) then
        self.youke_:setVisible(false)
    end
end

function LoginScene:checkVersion_(data)
    HttpApi.checkNewVersion(handler(self, self.onVersionDownloaded_), handler(self, self.onVersionFail_))
end

function LoginScene:onVersionDownloaded_(data)
    self.loadView_:setPercentage(98)
    local result = json.decode(data)
    if not result or result.status ~= 1 then  -- 请求无返回
        return self:onLoadFinish_()
    end
    if not result.data.hasNewVersion then  -- 没有新版本
        return self:onLoadFinish_()
    end
    local isForce = result.data.detail.isForce
    self:onNewVersionFound_(isForce, result.data.detail)
end

function LoginScene:onNewVersionFound_(isForce, versionInfo)
    self.isForce_ = isForce
    self.versionInfo_ = versionInfo
    self.loadView_:hide()
    local view = app:createView("load.UpdateView", isForce, versionInfo):addTo(self.layerTop_)
    view:onUpdateCancel(handler(self, self.onLoadFinish_))
end

-- 加载完成，进入登录场景
function LoginScene:onLoadFinish_()
    self.loadView_:setPercentage(100)
    self.loadView_:hide()
    if not network.isInternetConnectionAvailable() then
        self:performWithDelay(handler(self, self.onLoadFinish_), 1)
        return
    end

    
        --测试直接进游戏场景
    -- app:enterLoginScene()
end

function LoginScene:weiXinLoginHandler_()
    local params = {
        callback = handler(self, self.onWeChatAuthReturn_),
        authScope = "snsapi_userinfo",
        authOpenID = "",
        authState = tostring(os.time()),
    }
    logger.Debug("进入微信登入")
    gailun.native.startWeChatAuth(params)
    logger.Debug("进入微信登入")
end

function LoginScene:onWeChatAuthReturn_(ret)
    logger.Debug("ret ===",ret)
    self.weiXinLogin_:setButtonEnabled(true)
    if not ret or ret == "" then
        app:showTips("请求失败!")
        return     
    end
    local param
    if type(ret) == "string" then
        param = json.decode(ret)
    elseif type(ret) == "table" then
        param = ret
    end

    if 0 ~= param.errCode then
        self:onWeChatError_(param.errCode)
        return
    end
    app:showLoading()
    logger.Debug("ret ===---------------------------------------")
    HttpApi.sdkLogin(param, handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
end


function LoginScene:youkeHandler_()
    app:showLoading()
    -- self:httpLogin(nil, nil, handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
    HttpApi.guestLogin(handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
end

function LoginScene:loaderCsb()
    self.csbNode_ = cc.uiloader:load("scenes/LoginScene.csb"):addTo(self)
end

function LoginScene:onLocation_()
    local params = {
        callback = handler(dataCenter, dataCenter.onLocationReturn),
    }

    if CHANNEL_CONFIGS.LOCATION == true then
        gailun.native.getLocation(params)
    end
end

function LoginScene:onEnterTransitionFinish()
    LoginScene.super.onEnterTransitionFinish(self)
    self:onEnterTransitionFinish_()
    local isSimulator = not gailun.native.getEnvId()
    if not isSimulator then 
        local str = gailun.native.getEnvId() .."-" .. gailun.native.getShortVersionName() .. "-" ..SCRIPT_VERSION_ID
        self.labelVersion_:setString(str)
    end
    -- print("======labelVersion_=======>"..str)
end

function LoginScene:onEnterTransitionFinish_()
    if not network.isInternetConnectionAvailable() then
        self:showNoNetwork_()
    end
    self:bindReturnKeypad_()
    self:updateVersionLabel_()
    self:checkLogin_()
    self:init()
end

function LoginScene:onExitTransitionStart()
end

function LoginScene:onExit()
    gailun.EventUtils.clear(self)
end

function LoginScene:onCleanup()
    display.removeSpriteFrameByImageName("res/images/login.png")
    collectgarbage("collect")
end

function LoginScene:updateVersionLabel_()
    -- self.labelVersion_:setString(dataCenter:getAppVersionName())
end

function LoginScene:bindReturnKeypad_()
    if "android" ~= device.platform then
        return
    end

    self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            local function onButtonClicked(isOK)
                if isOK then
                    app:exit()
                end
            end
            app:confirm("您确定要完全退出游戏吗？", onButtonClicked)
        end
    end)
end

function LoginScene:onGuestClicked_(event)
    if self.protocolSelected == false then
        app:alert("请确认并同意用户协议！")
        return
    end
    app:showLoading()
    -- self:httpLogin(nil, nil, handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
    HttpApi.guestLogin(handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
end

function LoginScene:onWeChatClicked_(event)
    if self.protocolSelected == false then
        app:alert("请确认并同意用户协议！")
        return
    end

    local params = {
        callback = handler(self, self.onWeChatAuthReturn_),
        authScope = "snsapi_userinfo",
        authOpenID = "",
        authState = tostring(os.time()),
    }
    gailun.native.startWeChatAuth(params)
    -- local action = transition.sequence({cc.DelayTime:create(10), cc.CallFunc:create(function() self.buttonWeChatLogin_:setButtonEnabled(true) end)})
    -- self.buttonWeChatLogin_:runAction(action)
end

function LoginScene:onWeChatAuthReturn_(ret)
    if not ret or ret == "" then
        app:showTips("请求失败!")
        return     
    end
    local param
    if type(ret) == "string" then
        param = json.decode(ret)
    elseif type(ret) == "table" then
        param = ret
    end
    if 0 ~= param.errCode then
        self:onWeChatError_(param.errCode)
        return
    end
    app:showLoading()
    HttpApi.sdkLogin(param, handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
end

--[[
    errorCode : 微信登录的错误码
    -2（用户取消）
    -4（用户拒绝授权）
    -98（未安装微信）
    -99（微信版本过低）
    -100（未知错误）
]]
function LoginScene:onWeChatError_(errorCode)
    local errorStr
    if errorCode == -2 or errorCode == -4 then
        errorStr = "微信登录已取消！"
        app:showTips(errorStr)
        return
    elseif errorCode == -98 then
        errorStr = "您还没有安装微信哦！"
    elseif errorCode == -99 then
        errorStr = "微信版本过低，请升级后重试！"
    else
        errorStr = "登录申请失败，请重新申请！"
    end
    app:alert(errorStr)
end

-- 自动登录请求
function LoginScene:onAutoLogin_(event)
    local expired, autoToken = gameCache:get("autoToken")
    if not autoToken or autoToken == "" then
        if CHANNEL_CONFIGS.WX_AUTO_LOGIN then
            local isSimulator = not gailun.native.getEnvId()
            if isSimulator then
                self:onGuestClicked_(nil)            
            end
        end
        app:clearLoading()
        return
    end
    app:showLoading()
    local param = {}
    param.autoToken = autoToken
    HttpApi.autoLogin(param, handler(self, self.onHttpLoginSuccess_), handler(self, self.onHttpLoginFail_))
end

function LoginScene:onCheckProtocolClicked_(event)
    local selected = event.target:isButtonSelected()
    self.protocolSelected = selected
    if selected then
        --local view = app:createView("login.LoginProtocolView"):addTo(self.layerWindows_)
        --gailun.EventUtils.create(self, view, self, {{"CHECK_BOX_PROTOCOL", handler(self, self.onUpdateCheckBoxStatus_)}})
    end
end

function LoginScene:showNoNetwork_()
    app:alert("出错啦～, 世界上最遥远的距离就是没有网～～～")
end

function LoginScene:checkLogin_()
    if not network.isInternetConnectionAvailable() then
        self:performWithDelay(handler(self, self.checkLogin_), 1)
        return
    end
    device.cancelAlert()
    self:onAutoLogin_()
    print("4444444")
end

function LoginScene:onHttpLoginSuccess_(data)
    logger.Debug("data = =",data)
    app:clearLoading()
    local result = json.decode(data)
    if not result then
        app:alert("登录返回错误, 数据格式异常！")
        return
    end
    if result.desc and string.len(result.desc) > 0 then
        app:alert(result.desc)
    end

    if  WEB_AUTO_TOKEN_EXPIRED == result.status then
        self:onWeChatClicked_(nil)
        return
    end
    if -2 == result.status then
        gameCache:set("autoToken", '')
        app:alert("登录返回错误, 错误码" .. result.status)
        return
    end
    if 1 ~= result.status then
        app:alert("登录返回错误, 错误码" .. result.status)
        return
    end
    local uid = checkint(result.data.uid)
    if not uid or uid <= 0 then
        app:alert("登录返回错误, 玩家数据异常！")
        return
    end

    if buglySetUserId ~= nil then
        buglySetUserId(tostring(SCRIPT_VERSION_ID .. "-" .. uid))
    end

    local autoToken = result.data.autoToken
    if autoToken then
        gameCache:set("autoToken", autoToken)
    end
    dump(result)
    local params = {
        uid = uid,
        userName = '',
        nickName = result.data.nickname,
        laJiaoDou = result.data.laJiaoDou,
        token = result.data.token,
        avatar = result.data.avatar,
        diamond = checkint(result.data.diamond),
        sex = checkint(result.data.sex),
        IP = result.data.IP or '',
        phone = result.data.phone or '',
        fatherId = checkint(result.data.fatherId),
        allowNiuNiu = checkint(result.data.allowNiuNiu),
        customType = checkint(result.data.customType),
        loginTime = result.data.loginTime,
        roundCount = result.data.roundCount,
        rateScore = result.data.rateScore,
        score = result.data.score,
        signTime = result.data.signTime,
        signCount = result.data.signCount,
        yuanBao = result.data.yuanBao,
    }
    selfData:setUserData(params)
    dataCenter:setHostAndPort(result.data.server.host, result.data.server.port)
    dataCenter:setRoomID(0)
    if result.data.roomInfo then
        dataCenter:resumeSocketMessage()
        dataCenter:setRoomID(result.data.roomInfo.roomID)
        dataCenter:setAutoEnterRoom(true)
        dataCenter:tryConnectSocket()
        local gameType = result.data.roomInfo.gameType
        return
    end

    -- require("app.games.shuangKou.utils.RulesTest").new()
    app:enterScene("DaTingScene")
end

function LoginScene:onGetClubInfoHandler_(event)
    if event.data.isSuccess then
        local data = json.decode(event.data.result)
        if data.status == 1 then
            app:enterScene("ChaGuanScene", {data})
        else
            app:enterScene("DaTingScene")
        end
    end
end

function LoginScene:onHttpLoginFail_(...)
    logger.Debug("登入失败",...)
    app:clearLoading()
    app:alert("登录请求失败, 请检查网络后重试！")
end

function LoginScene:registerTextButton_()
    if not CHANNEL_CONFIGS.AGGREMENT then
        return
    end
    local function onTopTouchEnded(event)
        self:onTextProtocolTouched_(event)
    end
    gailun.uihelper.setTouchHandler(self.buttonProtocolText_, onTopTouchEnded)
end

function LoginScene:onTextProtocolTouched_(event)
    --显示协议
    local view = app:createView("login.LoginProtocolView"):addTo(self.layerWindows_)
    -- gailun.EventUtils.create(self, view, self, {{"CHECK_BOX_PROTOCOL", handler(self, self.onUpdateCheckBoxStatus_)}})
end
return LoginScene
