local ChannelConfig = require("app.utils.ChannelConfig")

local TYPES = gailun.TYPES
local nodes = {}

nodes.layers = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, var = "layerBG_", },
        {type = TYPES.LAYER, var = "layerContent_",},
        {type = TYPES.LAYER, var = "layerTop_",},
    }
}

nodes.bg = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/loadScene/loading_bg.png", x = display.cx, y = display.cy, scale = display.width / DESIGN_WIDTH},
    }
}

nodes.main = {
    type = TYPES.ROOT, children = {
        -- {type = TYPES.SPRITE, filename = "res/images/logo.png", ap = {1, 1}, px = 0.99, py = 0.99},
        {type = TYPES.LABEL, var = "labelVersion_", ap = {1, 0.5}, x = display.width - 10, y = 20, options={text=VERSION_HOST, size = 22, font = DEFAULT_FONT, color = display.COLOR_WHITE}},
    }
}

local LoadScene = class("LoadScene", function()
    return display.newScene("LoadScene")
end)

function LoadScene:ctor()
    gailun.uihelper.render(self, nodes.layers)
    self:onBgLoaded_()
    ChannelConfig.init(display.newNode():addTo(self))
end

function LoadScene:onBgLoaded_()
    gailun.uihelper.render(self, nodes.bg, self.layerBG_)
end

function LoadScene:onEnterTransitionFinish()
    audio.preloadSound(DEFAULT_CLICK_SOUND)
    self:onLoadAllFinish_()
end

function LoadScene:onExitTransitionStart()
end

function LoadScene:onExit()
    gailun.EventUtils.clear(self)
    ChannelConfig.clear()
end

function LoadScene:onCleanup()
    collectgarbage("collect")
end

function LoadScene:onLoadAllFinish_()
    gailun.uihelper.render(self, nodes.main, self.layerContent_)
    self.loadView_ = app:createView("load.LoadLayer"):addTo(self.layerContent_)
    self.loadView_:setPercentage(95)
    self:onEnterTransitionFinish_()
end

function LoadScene:onEnterTransitionFinish_()
    if not network.isInternetConnectionAvailable() then
        self:showNoNetwork_()
    end

    self:bindReturnKeypad_()
    self:updateVersionLabel_()
    self:pullChannelConfig_()
end

-- 拉取渠道配置
function LoadScene:pullChannelConfig_()
    self.loadView_:setPercentage(96)
    ChannelConfig.loadRemote(handler(self, self.onPullChannelConfigFinish_))
end

function LoadScene:onPullChannelConfigFinish_(flag)
    self:updateVersionLabel_()
    self.loadView_:setPercentage(97)
    StaticConfig:checkConfigUpdate(handler(self, self.checkVersion_))
end

-- 检查新版本
function LoadScene:checkVersion_()
    HttpApi.checkNewVersion(handler(self, self.onVersionDownloaded_), handler(self, self.onVersionFail_))
end

function LoadScene:onVersionDownloaded_(data)
    self.loadView_:setPercentage(98)
    local result = json.decode(data)
    logger.Debug("data.status===",result.status)
    logger.Debug("data.status===",result.data.hasNewVersion)
    if not result or result.status ~= 1 then  -- 请求无返回
        return self:onLoadFinish_()
    end
    if not result.data.hasNewVersion then  -- 没有新版本
        return self:onLoadFinish_()
    end
    local isForce = result.data.detail.isForce
    self:onNewVersionFound_(isForce, result.data.detail)
end

function LoadScene:onVersionFail_()
    self.loadView_:setPercentage(98)
    printInfo("============ LoadScene:onVersionFail_ ============")
    self:onLoadFinish_()
end

function LoadScene:onNewVersionFound_(isForce, versionInfo)
    self.isForce_ = isForce
    self.versionInfo_ = versionInfo
    self.loadView_:hide()
    local view = app:createView("load.UpdateView", isForce, versionInfo):addTo(self.layerTop_)
    view:onUpdateCancel(handler(self, self.onLoadFinish_))
end

-- 加载完成，进入登录场景
function LoadScene:onLoadFinish_()
    self.loadView_:setPercentage(100)
    self.loadView_:hide()
    if not network.isInternetConnectionAvailable() then
        self:performWithDelay(handler(self, self.onLoadFinish_), 1)
        return
    end
        --测试直接进游戏场景
    -- app:enterGameScene()
    app:enterLoginScene()
end

function LoadScene:updateVersionLabel_()
    self.labelVersion_:setString(dataCenter:getAppVersionName())
end

function LoadScene:bindReturnKeypad_()
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

function LoadScene:showNoNetwork_()
    app:alert("世界上最遥远的距离就是没有网～～～", nil, "出错啦～")
end

return LoadScene
