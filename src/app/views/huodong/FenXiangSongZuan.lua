local FenXiangSongZuan = class("FenXiangSongZuan", function()
    return display.newSprite()
    end)

function FenXiangSongZuan:ctor()
    local view = display.newSprite("res/images/huodong/xinren_fuli.jpg"):addTo(self)
    view:setPositionY(view:getPositionY()+40)
    self.button_ = ccui.Button:create("res/images/common/fenxiang.png", "res/images/common/fenxiang.png")
    self.button_:setAnchorPoint(0.5,0.5)
    self.button_:setSwallowTouches(false)
    self.button_:pos(-20,-250) 
    self:addChild(self.button_)
    self.button_:addTouchEventListener(handler(self, self.onButtonClick_))
end

function FenXiangSongZuan:onButtonClick_(item, eventType)
    if 2 == eventType then  
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        local index = math.random(1, 7)
        local title = "【乐途互娱】" .. FENXIANGNEIRONG[index]
        local function callback()
            HttpApi.fenXiangDeZuan(handler(self, self.sucHandler_), handler(self, self.failHandler_))
        end
        display.getRunningScene():shareWeiXin(title, "", 0,callback)
        self:performWithDelay(function()
            callback()
            end, 1)
    end
end

function FenXiangSongZuan:sucHandler_(data)
    if tolua.isnull(self) then return end
    app:clearLoading()
    local obj = json.decode(data)
    if obj.status == -9 then
        self:performWithDelay(function()
            app:showTips("今日已参与，请明天再来")
        end, 2)
        return
    end
    if obj.status == 1 then
        local haveDiamond = selfData:getDiamond()
        haveDiamond = haveDiamond + obj.data.diamond
        selfData:setDiamond(haveDiamond)
        app:showTips("得到钻石，" .. obj.data.diamond)
    end
end

function FenXiangSongZuan:failHandler_(data)

end

return FenXiangSongZuan 

