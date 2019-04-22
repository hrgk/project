local FaceAnimationViewItem =class("FaceAnimationViewItem", gailun.BaseView)

function FaceAnimationViewItem:ctor(gameType)
    self.seats_ = display.getRunningScene().tableController_.seats_
end

function FaceAnimationViewItem:sendChatMessage_(faceID, faceCMD, targetSeatID)
    local params = {
        action = "chat", 
        messageData = faceID,
        messageType = faceCMD, 
        fromSeatID = display.getRunningScene():getHostPlayer():getSeatID(),
        faceID = faceID,
        toSeatID = targetSeatID,
    }
    dataCenter:clientBroadcast(params)
end

function FaceAnimationViewItem:setCallback(callfunc)
    self.callfunc_ = callfunc
end

function FaceAnimationViewItem:update(data, seatID, uid)
    self.uid_ = uid
    self.data_ = data
    self.data_.seatID = seatID
    if self.icon_ then
        self:removeChild(self.icon_)
        self.icon_ = nil 
    end
    
    self.icon_ = ccui.Button:create(data.icon, data.icon, data.icon)
    self.icon_:setSwallowTouches(false)  
    self.icon_:setPosition(0, 15)
    self:addChild(self.icon_)
    self.icon_:addTouchEventListener(handler(self, self.onButtonClick_))
end

function FaceAnimationViewItem:onButtonClick_(sender, eventType)
    if (2== eventType) then  
    local faceType = CHAT_FACE_ANIMATION
    if self.uid_ == selfData:getUid() then
        for i,v in ipairs(self.seats_) do
            if selfData:getUid() ~= v:getUid() and v:getUid() > 0 then
                self:sendChatMessage_(self.data_.id, self.data_.faceCmd, v:getSeatID())
            end
        end
    else
        self:sendChatMessage_(self.data_.id, self.data_.faceCmd, self.data_.seatID)
    end
        if self.callfunc_ then
            self.callfunc_()
        end
    end  
end

return FaceAnimationViewItem
