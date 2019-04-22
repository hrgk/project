local VoiceChatButton = class("VoiceChatButton", function ( ... )
    return display.newSprite()
end)

local CLICK_SCALE = 0.9

function VoiceChatButton:ctor()
    self.button_ = ccui.Button:create("res/images/game/btn_luyin.png", "res/images/game/btn_luyin.png")
    self.button_:setAnchorPoint(0.5,0.5)
    self.button_:setSwallowTouches(false)  
    self:addChild(self.button_)
    self.button_:addTouchEventListener(handler(self, self.onButtonTouch_))
    self.oldScale_ = self.button_:getScale()
    self.isCancel_ = false
    self.isSended_ = false
    -- self:setPosition(590, -70)
    self.sendCount_ = 0
    self.startTime_ = 0
    self.endTime_ = 0
end

function VoiceChatButton:onButtonTouch_(sender, eventType)
    if eventType == 0 then
        self:onTouchBegin_()
    elseif eventType == 1 then
        self:onTouchMoved_()
    elseif eventType == 2 then
        self:onTouchEnded_()
    elseif eventType == 3 then
        self:onTouchCancel_()
    end
end

function VoiceChatButton:setView(view)
    self.voiceView_ = view
    self.voiceView_:hide()
end

function VoiceChatButton:recordCallback_(data)
    if data.progress == 1 then
        return self:onFinishRecordReturn_(data)
    elseif data.progress == 0 then
        return self:onStartRecordReturn_(data)
    end
end

function VoiceChatButton:onStartRecordReturn_(data)
    if data.flag == 1 then
        gameAudio.setMusicVolume(0)
        self.startTime_ = gailun.utils.getTime()
        self:startRecord_()
    elseif data.flag == -1 then
        self:cancelRecord_()
        app:showTips("录音失败，没有录音权限！")
    elseif data.flag == -2 then
        self:cancelRecord_()
    elseif data.flag == -3 then
        self:cancelRecord_()
    elseif data.flag == -4 then
        self:cancelRecord_()
    elseif data.flag == -5 then
        self:cancelRecord_()
        app:showTips("录音失败，未知错误!")
    end
end

function VoiceChatButton:onFinishRecordReturn_(data)
    self:hideRecordView_()
    if tonumber(setData:getMusicIsCLose()) == 1 then
        gameAudio.setMusicVolume(0)
    else
        gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
    end
    if data.flag == 1 then
        self.endTime_ = gailun.utils.getTime()
        if (self.endTime_ - self.startTime_) < 1 then
            return
        end
        self:sendRecord_(0.1)
    end
end

function VoiceChatButton:hideRecordView_()
    self.voiceView_:stopRecordMC()
    self.voiceView_:hide()
end

function VoiceChatButton:onTouchBegin_()
    self.hostPlayer_ = display.getRunningScene():getHostPlayer()
    gailun.native.startRecorder(handler(self, self.recordCallback_))
end

function VoiceChatButton:onTouchMoved_(event)
    self.voiceView_:setInfoLable("移动取消录音")
end

function VoiceChatButton:onTouchEnded_(event)
    self.hostPlayer_:stopRecordVoice()
    gailun.native.stopRecorder()
    self.voiceView_:hide()
    transition.scaleTo(self, {scale = self.oldScale_, time = 0.1})
end

function VoiceChatButton:onTouchCancel_(event)
    self:cancelRecord_()
end

function VoiceChatButton:startRecord_()
    self.voiceView_:show()
    self.isSended_ = false
    self.isCancel_ = false
    transition.scaleTo(self, {scale = CLICK_SCALE, time = 0.1})
    self.voiceView_:playeRecordMC()
end

function VoiceChatButton:cancelRecord_()
    gailun.native.stopRecorder()
    self.isCancel_ = true
    self.voiceView_:stopRecordMC()
end

-- 聊天类型 1-> 表情 2-> 常用语 3->普通文字
function VoiceChatButton:sendChatMessage_(messageType, soundID, url)
    local params = {
        action = "chat", 
        messageType = messageType, 
        soundID = soundID,
        url = url,
    }
    params.seatID = self.hostPlayer_:getSeatID()
    params.uid = self.hostPlayer_:getUid()
    params.duration = self.endTime_ - self.startTime_
    params.nickname = self.hostPlayer_:getNickName()
    params.time = gailun.utils.getTime()
    dataCenter:clientBroadcast(params)
end

function VoiceChatButton:sendRecord_(delaySeconds)
    print("=================sendRecord_=====================")
    if self.isCancel_ then
        return
    end
    if self.isSended_ then
        return
    end
    self.isSended_ = true
    local delaySeconds = delaySeconds or 0
    self:performWithDelay(function ( ... )
        local roomID = display.getRunningScene():getTid()
        HttpApi.uploadAAC(roomID, app:soundPath(), handler(self,self.upLoadSuce), handler(self,self.upLoadFail))
        transition.stopTarget(self)
    end, delaySeconds)
end

function VoiceChatButton:upLoadSuce(data)
    local obj = json.decode(data)
    if obj.status == 1 then
        local soundID= obj.data.soundID
        local url= obj.data.url
        self:sendChatMessage_(CHAT_VOICE, soundID, url)
        gameAudio.playSound("sounds/common/sent_message.mp3")
    end
end

function VoiceChatButton:upLoadFail(event)
    self.sendCount_ = self.sendCount_ + 1
    if self.sendCount_ > 2 then
        self.sendCount_ = 0
        return
    end
    self:sendRecord_()
end

function VoiceChatButton:isInBtnSkin_(x, y)
    if cc.rectContainsPoint(self.buttonSkin_:getCascadeBoundingBox(), cc.p(x, y)) then
        return true
    end
    return false
end

return VoiceChatButton
