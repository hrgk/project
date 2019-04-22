local VoiceRecordView = class("VoiceRecordView", gailun.BaseView)

function VoiceRecordView:ctor()
    VoiceRecordView.super.ctor(self)
    local bg = display.newSprite("res/images/game/record_voice_bg.png")
    self:addChild(bg)

    self.infoLabel_ = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "移动取消录音",
            size = 20,
            color = cc.c3b(76, 131, 162)
        }):addTo(self):pos(0, -90)
    self.infoLabel_:setAnchorPoint(0.5, 0.5)
    local progressBg = display.newSprite("res/images/game/progress_record_voice_bg.png"):pos(0, -70)
    self:addChild(progressBg)
    self:initProgress_()
end

function VoiceRecordView:setInfoLable(str)
    self.infoLabel_:setString(str)
end

function VoiceRecordView:initProgress_()
    self.bloodProgress_ = cc.ProgressTimer:create(display.newSprite("res/images/game/progress_record_voice.png"))  
    self.bloodProgress_:setType(cc.PROGRESS_TIMER_TYPE_BAR) --设置为条形 type:cc.PROGRESS_TIMER_TYPE_RADIAL  
    self.bloodProgress_:setMidpoint(cc.p(0, 0)) --设置起点为条形右方  
    self.bloodProgress_:setBarChangeRate(cc.p(1, 0))  --设置为横向  
    self.bloodProgress_:setPosition(0, -70)
    self.bloodProgress_:setPercentage(50)
    self:addChild(self.bloodProgress_) 
end

function VoiceRecordView:playeRecordMC()
    transition.resumeTarget(self.bloodProgress_)
    self.bloodProgress_:setPercentage(100)
    local progressTo = cc.ProgressTo:create(10, 0)
    self.bloodProgress_:runAction(progressTo)
end

function VoiceRecordView:stopRecordMC()
    transition.pauseTarget(self.bloodProgress_)
end

function VoiceRecordView:cancelRecordMC()
    transition.pauseTarget(self.bloodProgress_)
end

return VoiceRecordView 
