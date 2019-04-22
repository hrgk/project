local UpdateView = class("UpdateView", gailun.BaseView)

local TYPES = gailun.TYPES
local data = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LABEL, var = "labelUpdateTips_", options = {text = "", size = 20, color = display.COLOR_WHITE, dimensions = cc.size(500, 74)}, ap = {0.5, 1}, ppx = 0.5, ppy = 0.8},
        
        {type = TYPES.LABEL, var = "labelProgress_", options = {text = "", size = 34, font=DEFAULT_FONT, color = display.COLOR_WHITE}, ap = {0.5, 0.5}, px = 0.5, y = display.cy - 70},
        {type = TYPES.SPRITE, var = "progressSprite_", filename = "res/images/loadScene/progress_bg.png", px = 0.5, y = display.cy - 130, children = {
            {type = TYPES.PROGRESS_TIMER, var = "downloadProgress_", bar = "res/images/loadScene/progress.png", ppx = 0.5, ppy = 0.5}, -- 升级进度条
        }},
    }
}

function UpdateView:ctor(isForce, versionInfo)
    UpdateView.super.ctor(self)
    self.isForce_ = isForce and isForce == true
    self.versionInfo_ = versionInfo
    gailun.uihelper.render(self, data)
end

function UpdateView:onEnter()
    -- self.labelUpdateTips_:setString(self.versionInfo_.readme)
    self:setPercentage_(0)

    local handlers = {
        {app.BACK_GROUND_EVENT, handler(self, self.onBackGroundEvent_)},
    }
    gailun.EventUtils.create(self, app, self, handlers)

    app:confirm(self.versionInfo_.readme, handler(self, self.onUpdateClicked_))
end

function UpdateView:onCleanup()
    gailun.EventUtils.clear(self)
end

function UpdateView:onUpdateCancel(callback)
    assert(callback and type(callback) == "function")
    self.callback_ = callback
end

function UpdateView:onUpdateClicked_(isOK)
    if isOK then
        self:startDownload_()
        return
    end
    if self.isForce_ then
        app:exit()
        return
    end
    self:onClose_()
end

function UpdateView:onBackGroundEvent_(event)
    if event.isBackground then
        return
    end

    if self.isForce_ then
        app:exit()
        return
    end

    self:onClose_()
end

function UpdateView:startDownload_()
    if self.inDownload_ then
        return
    end
    
    if "ios" == device.platform then
        device.openURL(self.versionInfo_.url)
        return
    end

    self.inDownload_ = true
    self.progressSprite_:show()
    local url = self.versionInfo_.url
    local path = gailun.native.getSDCardPath() .. device.directorySeparator
    local filename = path .. 'yoyo_new_version.apk'
    local seconds = 0
    gailun.HTTP.download(url, filename, handler(self, self.onApkDownloaded_), 
        handler(self, self.onApkFail_), seconds, handler(self, self.onApkProgress_))
end

function UpdateView:onApkProgress_(total, downloaded)
    local percent = 0
    if total > 0 and downloaded > 0 then
        percent = math.round(downloaded / total * 100)
    end

    self:setPercentage_(percent)
end

function UpdateView:setPercentage_(percent)
    local str = string.format("正在下载新版本：%d％", percent)
    self.downloadProgress_:setPercentage(percent)
    self.labelProgress_:setString(str)
end

function UpdateView:onApkDownloaded_(filename)
    self:setPercentage_(100)
    self.inDownload_ = false
    gailun.native.installAPK(filename)
end

function UpdateView:onApkFail_(...)
    self.inDownload_ = false
    if self.isForce_ then
        app:alert("更新请求失败，请重试！", handler(self, self.startDownload_))
    else
        app:confirm("更新请求失败，请在网络畅通的情况下点击确定再试一次，或者下次再试！", function (isOK)
            if isOK then
                self:startDownload_()
                return
            end
            self:onClose_()
        end)
    end
end

function UpdateView:onClose_()
    if self.callback_ and not self.isForce_ then
        self.callback_()
    end
    self:removeFromParent()
end

return UpdateView
