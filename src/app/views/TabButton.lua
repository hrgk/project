local TabButton = class("TabButtonTabButton", function()
    return display.newSprite()
end)

function TabButton:ctor()
    self.isClick_ = false
    self.hotConf = {"cdphz","dtz","hzmj"}
    self.gcConf = {"sk"}
end

function TabButton:update(data, index)
    self.index_ = index
    if self.buttonIcon_ then
        self.buttonIcon_:removeSelf()
        self.buttonIcon_ = nil
    end
    self.buttonIcon_ = ccui.Button:create(data[1], data[1], data[2])
    self.buttonIcon_:setAnchorPoint(0,0.5)
    self.buttonIcon_:setSwallowTouches(false)  
    self:addChild(self.buttonIcon_)
    self.buttonIcon_:addTouchEventListener(handler(self, self.onButtonClick_))
    for i,v in ipairs(self.hotConf) do
        if string.find(data[1], v) ~= nil then
            self:addHotFlag()
        end
    end
    for i,v in ipairs(self.gcConf) do
        if string.find(data[1], v) ~= nil then
            self:addGCFlag()
        end
    end
end

function TabButton:updateEditRoom(data)
    self.data_ = data
    if self.buttonIcon_ then
        self.buttonIcon_:removeSelf()
        self.buttonIcon_ = nil
    end
    local spr = data.spr
    self.buttonIcon_ = ccui.Button:create(spr[1], spr[1], spr[2])
    self.buttonIcon_:setAnchorPoint(0,0.5)
    self.buttonIcon_:setSwallowTouches(false)  
    self:addChild(self.buttonIcon_)
    self.buttonIcon_:addTouchEventListener(handler(self, self.onButtonClick_))
    self:addCloseFlag()
end

function TabButton:addGCFlag()
    local sp = display.newSprite("res/images/createRoom/gcFlag.png")
    sp:pos(185,43)
    self:addChild(sp, 0, 1)
end

function TabButton:addHotFlag()
    local sp = display.newSprite("res/images/createRoom/hotFlag.png")
    sp:pos(185,43)
    self:addChild(sp, 0, 1)
end

function TabButton:addFreeFlag()
    local sp = display.newSprite("res/images/createRoom/freeFlag.png")
    sp:pos(25,25)
    self:addChild(sp, 0, 2)
end

function TabButton:addCloseFlag()
    if self:getChildByName("close") then
        return
    end

    local sp = display.newSprite("views/editCreateRoom/close.png")
    sp:pos(185,30)
    sp:setName("close")
    self:addChild(sp, 1)
end

function TabButton:getIndex()
    return self.index_
end

function TabButton:updateState(bool)
    self.buttonIcon_:setEnabled(not bool)
    self.buttonIcon_:setBright(not bool)
end

function TabButton:onButtonClick_(sender, eventType)
    if (2== eventType) then  
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
        if self.editCallfunc_ then
            self.editCallfunc_(self.data_)
        end
        if self.callfunc_ then
            self.callfunc_(self.index_)
        end
    end  
end

function TabButton:setCallback(callfunc)
    self.callfunc_ = callfunc
end

function TabButton:setEditRoomCallback(callfunc)
    self.editCallfunc_ = callfunc
end

return TabButton 
