local BaseView = import("app.views.BaseElement")
local HistoryItem = class("HistoryItem", BaseView)
local SelectedView = import("app.views.SelectedView")
local QiPaoView = import("app.views.game.VoiceQiPao")

function HistoryItem:ctor()
    HistoryItem.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)

    self.qiPaoView_ = QiPaoView.new():addTo(self.csbNode_):pos(200, 25)
    self.voiceClick_:setSwallowTouches(false)
end

function HistoryItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/yuyinwenzi/historyItem.csb"):addTo(self)
    -- self.csbNode_:setPosition(display.cx + 320, display.cy)
end

function HistoryItem:update(file, params)
    self.file = file
    self.nameLabel_:setString(params.nickname .. ":")
    self.qiPaoView_:setStatus((params.duration or 0) * 1000)
end

function HistoryItem:voiceClickHandler_()
    gailun.native.playSound(self.file, handler(self, self.onPlaySoundReturn_))
end

function HistoryItem:onPlaySoundReturn_(data)
    self.qiPaoView_:playVoiceAnim(data.duration, false)
end

return HistoryItem 