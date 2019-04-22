local BaseLayer = import("app.views.base.BaseLayer")
local ActivityListView = class("ActivityListView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, px = 0.5, py = 0.5, ap = {0.5, 0.5},size = {974, 637},
            children = {
                {type = TYPES.SPRITE,var = "bg_", filename = "res/images/proxy_system/proxy_bg.png", ppx = 0.5, ppy = 0.48 ,scale9 = true, capInsets = cc.rect(220, 165, 1, 1), size ={974, 637}},
                {type = TYPES.SPRITE,var = "content_",ppx = 0.5, ppy = 0.48,ap = {0.5, 0.5}},
                {type = TYPES.BUTTON, var = "buttonClose_", autoScale = 0.9, normal = "res/images/common/closebutton.png", options = {}, ppx = 0.96, ppy = 0.96},
                
            }
        }
    }
}
ActivityListView.TUI_GUANG_VIEW = 1
ActivityListView.JI_FU_VIEW = 2
ActivityListView.SONG_ZUAN_VIEW = 3

function ActivityListView:ctor(index, data)
    self.activityList_ = {
        handler(self, self.initTuiGuangView_),
        handler(self, self.initJiFuView_),
        handler(self, self.initSongZuanView_)
    }
    self:addMaskLayer(self, 100)
    gailun.uihelper.render(self, nodes)
    self.buttonClose_:onButtonClicked(handler(self, self.onCloseClicked_))
    self.activityList_[index](data)
end

function ActivityListView:initTuiGuangView_(data)
    self:removeCurrentView_()
    self.currentView_ = app:createView("activitys.tuiguangActivity.TuiGuangView"):addTo(self.content_)
    self.currentView_:setPosition(- display.cx, - display.cy)
    self.bg_:hide()
    self.buttonClose_:setPosition(930, 560)
end

function ActivityListView:initJiFuView_(data)
    self:removeCurrentView_()
    self.currentView_ = app:createView("activitys.jifuActivity.JiFuActivityView"):addTo(self.content_)
    self.currentView_:setPosition(- display.cx, - display.cy)
    local girl = display.newSprite("res/images/jiaruyouxixiaochangjing.png"):addTo(self):scale(0.6)
    girl:setFlippedX(true)
    girl:setPosition(1150, 220)
end

function ActivityListView:initSongZuanView_(data)
    self:removeCurrentView_()
    self.currentView_ = app:createView("activitys.songzuanActivity.PresentDiamondsView"):addTo(self.content_)
    self.currentView_:setPosition(- display.cx, - display.cy)
end

function ActivityListView:removeCurrentView_()
    if self.currentView_ then
        self.currentView_:removeFromParent()
        self.currentView_ = nil
    end
end

function ActivityListView:onCloseClicked_(event)
    self:removeFromParent()
end

return ActivityListView 
