local BaseView = import("app.views.base.BaseGameResult")
local BanBanHuView = class("BanBanHuView", BaseView)
local TYPES = gailun.TYPES

local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER_COLOR, var = "layerMask_", color = {0, 0, 0, 128}},
        {type = TYPES.SPRITE, var = "bg_", filename = "res/images/jrfj_bj.png", scale9 = true, size = {1000, 600}, capInsets = cc.rect(340, 150, 1, 1), 
        x = display.cx, y = display.cy, children = {
    
        },              
        {type = TYPES.BUTTON, var = "buttonBack_", autoScale = 0.9, normal = "res/images/common/back.png", options = {}, px = 0.065, py = 0.925},

    },
},
}

function BanBanHuView:ctor(data)
    BanBanHuView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    -- self.buttonBack_:onButtonClicked(handler(self, self.onBackClicked_))
    local space = 130
    for _,v in pairs(checktable(data.seats)) do
        local y = display.height - 500 -(v.seatID - 2) * space + space / 2
        app:createConcreteView("game.BanBanHuViewItemView", v):addTo(self.bg_):pos(100, y)
    end

    -- for _,v in pairs(checktable(data.seats)) do
    --  if data.hostSeatID == v.seatID then
    --      if v.score < 0 then
    --          self.titlePng_:setTexture("res/images/majiang/game_over/sb_title.png")
    --      end
    --  end
    -- end
    local function touchEnded_1(event)
        self:removeFromParent()
    end
    gailun.uihelper.setTouchHandler(self.layerMask_, touchEnded_1)

    for i=1,#data.dice do
        local dice = data.dice[i]
        local sprite = display.newSprite("res/images/majiang/shaizi"..dice..".png"):addTo(self):pos(display.cx  - #data.dice * 40+ i * 80 - 20, display.height - 50)

    end
end

function BanBanHuView:onBackClicked_()
    self:removeFromParent()
end


return BanBanHuView
