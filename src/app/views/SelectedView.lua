local TabButton = import(".TabButton")
local SelectedView = class("SelectedView", function()
        return display.newSprite()
end)

local zhuoM = {
    "res/images/game/showTb_n.png",
    "res/images/game/showTb_o.png"
}

local jieS = {
    "res/images/game/showJs_n.png",
    "res/images/game/showJs_o.png"
}

function SelectedView:ctor(callfunc, skins1, skins2, bg)
    self.skins1_ = skins1 or jieS
    self.skins2_ = skins2 or zhuoM
    local bg = bg or "res/images/game/qieHuanDi.png"
    self.btnList_ = {}
    self.callfunc_ = callfunc
    local back = display.newSprite(bg)
    self:addChild(back)

    self.btn1_ = TabButton.new():addTo(self)
    self.btn1_:setCallback(handler(self, self.setClickCallFunc_))
    self.btn1_:update(self.skins1_, 1)
    self.btn1_:setPositionX(-210) 
    table.insert(self.btnList_, self.btn1_)

    self.btn2_ = TabButton.new():addTo(self)
    self.btn2_:setCallback(handler(self, self.setClickCallFunc_))
    self.btn2_:update(self.skins2_,2)
    self.btn2_:setPositionX(10)  --setCallback
    table.insert(self.btnList_, self.btn2_)

end

function SelectedView:setBtnOffsetByIndex(index, x, y)
    for i,v in ipairs(self.btnList_) do
        if index == i then
            v:setPosition(v:getPositionX() + x, v:getPositionY() + y)
            return
        end
    end
end

function SelectedView:setDefaults(index)
    self:updateView_(index)
end

function SelectedView:updateView_(index)
    for i,v in ipairs(self.btnList_) do
        if index == v:getIndex() then
            v:updateState(true)
        else
            v:updateState(false)
        end
    end
end

function SelectedView:setClickCallFunc_(index)
    self:updateView_(index)
    if self.callfunc_ then
        self.callfunc_(index)
    end
end

return SelectedView 
