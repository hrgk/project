local BaseLayer = require("app.views.base.BaseDialog")
local ShareDownloadView = class("ShareDownloadView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.SPRITE, filename = "res/images/downLoad_info.png", ppx = 0.5, ppy = 0.5},
            {type = TYPES.BUTTON, var = "buttonCopy_", autoScale = 0.9, normal = "res/images/copy_button.png", 
                options = {}, ppx = 0.65, ppy = 0.35},
    }
}

local DOWNLOAD_URL = "http://niugui.172pl.com/share"

function ShareDownloadView:ctor()
    ShareDownloadView.super.ctor(self, data)
    gailun.uihelper.render(self, nodes)
    self.buttonCopy_:onButtonClicked(handler(self, self.onButtonCopyClicked_))
    self:androidBack()
end

function ShareDownloadView:onButtonCopyClicked_(event)
    gailun.native.copy(DOWNLOAD_URL)
    app:showTips("复制成功!")
end

return ShareDownloadView 
