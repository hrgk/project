local VoiceQiPao = class("VoiceQiPao", gailun.BaseView)

local STEP_SECONDS = 0.1

function VoiceQiPao:ctor()
    self.secondLable_ = cc.ui.UILabel.new({
            UILabelType = 2,
            text = self.duration_,
            size = 18,
            color = cc.c3b(27, 77, 16),
            align = cc.ui.TEXT_ALIGN_CENTER
        }):addTo(self):pos(0, 0)

    self.haoMiaoLable_ = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            size = 18,
            color = cc.c3b(27, 77, 16),
            align = cc.ui.TEXT_ALIGN_CENTER
        }):addTo(self):pos(25, 0)

    self.voiceFlagContent_ = display.newSprite():addTo(self):pos(-25, 0)
    self.voice_s1_ = display.newSprite("res/images/game/voice_flag_1.png"):addTo(self.voiceFlagContent_):pos(-15, 0):hide()
    self.voice_s2_ = display.newSprite("res/images/game/voice_flag_2.png"):addTo(self.voiceFlagContent_):pos(-10, 0):hide()
    self.voice_s3_ = display.newSprite("res/images/game/voice_flag_3.png"):addTo(self.voiceFlagContent_):pos(-5, 0):hide()
    local backWidth = 78
    backWidth = backWidth * (1 + 5 / 8)
    local size = cc.size(backWidth, 60)
    self.back_ = display.newScale9Sprite("res/images/game/voice_bugle_bg.png", 0, 0, size)
    self:addChild(self.back_, -1)
    self:setTimeLable_(0)
    self.isPlaying_ = false
end

function VoiceQiPao:setTimeLable_(number)
    local str = string.format("%.1f", number / 1000)
    self.secondLable_:setString(str)
end


function VoiceQiPao:update_()
    local currTime = gailun.utils.getTime()
    local microSeconds = math.max(0, self.duration_ - (currTime - self.startTime_) * 1000)
    self:setTimeLable_(microSeconds)
end

function VoiceQiPao:updateVoiceAnim_()
    self.showFrame_ = self.showFrame_ or 0
    local list = {self.voice_s1_, self.voice_s2_, self.voice_s3_}
    local currNum = self.showFrame_ % 3
    for i,v in ipairs(list) do
        local isShow = i - 1 <= currNum
        v:setVisible(isShow)
    end
    self.showFrame_ = self.showFrame_ + 1
end

function VoiceQiPao:setFlipX(bool)
    if bool then
        self.back_:setScaleX(-1)
        self.voiceFlagContent_:setScaleX(-1)
        self.voiceFlagContent_:pos(25, 0)
        self.secondLable_:pos(-10, 0)
    else
        self.back_:setScaleX(1)
        self.voiceFlagContent_:setScaleX(1)
        self.voiceFlagContent_:pos(-25, 0)
        self.secondLable_:pos(10, 0)
    end
end

function VoiceQiPao:setStatus(duration)
    self:setTimeLable_(duration)
end

function VoiceQiPao:stopRecordVoice()
    if self.isPlaying_ then return end
    self:hide()
    self:cleanup()
    if tonumber(setData:getMusicIsCLose()) == 1 then
        gameAudio.setMusicVolume(0)
    else
        gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
    end
end

function VoiceQiPao:playVoiceAnim(duration, isHide)
    self:show()
    self.isPlaying_ = true
    self.startTime_ = gailun.utils.getTime()
    self.duration_ = duration
    gameAudio.setMusicVolume(0)
    local actions = {}
    for i = 1, duration / (STEP_SECONDS * 1000) + 3 do
        table.insert(actions, cc.CallFunc:create(function ()
            self:update_()
            self:updateVoiceAnim_()
        end))
        table.insert(actions, cc.DelayTime:create(STEP_SECONDS))
    end
    table.insert(actions, cc.CallFunc:create(function ()
        if isHide ~= false then
            self:hide()
        end
        self.isPlaying_ = false
        if tonumber(setData:getMusicIsCLose()) == 1 then
            gameAudio.setMusicVolume(0)
        else
            gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
        end
        gameAudio.playSound("sounds/common/play_completed.mp3")
        self:setStatus(duration)
    end))

    self:runAction(transition.sequence(actions))
end

return VoiceQiPao 
