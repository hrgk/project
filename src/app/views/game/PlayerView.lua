local BaseItem = import("app.views.BaseItem")
local PlayerView = class("PlayerView",BaseItem)
local PlayerHead = import("app.views.PlayerHead")

local PokerList = import(".PokerList")
local FaceAnimationsData = require("app.data.FaceAnimationsData")

PlayerView.RIGHT = 2
PlayerView.LEFT = 3
PlayerView.HOST = 1

function PlayerView:ctor(index)
    self.index_ = index
    PlayerView.super.ctor(self)
    self.zhuanQContent_ = display.newSprite()
    self.downCount_ = 0
end

function PlayerView:addEventListeners_()
    cc.EventProxy.new(self.player_, self.csbNode_, true)
    :addEventListener(self.player_.READY_GAME, handler(self, self.onReadyHandler_))
    :addEventListener(self.player_.TURN_TO, handler(self, self.onTurnTo_))
    :addEventListener(self.player_.LEVEL_ROOM, handler(self, self.onLevelRoom_))
    :addEventListener(self.player_.SCORE_CHANGE, handler(self, self.onScoreChange_))
    :addEventListener(self.player_.SET_SCORE, handler(self, self.onSetScore_))
    :addEventListener(self.player_.PLAY_VOICE, handler(self, self.onPlayerVoice_))
    :addEventListener(self.player_.SET_OFFLINE_STATUS, handler(self, self.onOfflineStatus_))
    :addEventListener(self.player_.SET_DOU_ZI, handler(self, self.onSetDouZi_))
    :addEventListener(self.player_.QUICK_YU_YIN, handler(self, self.onQuickYuYin_))
    :addEventListener(self.player_.QUICK_BIAO_QING, handler(self, self.onQuickBiaoQing_))
    :addEventListener(self.player_.ROOM_INFO, handler(self, self.onRoomInfo_))
end

function PlayerView:onRoomInfo_(event)
end

function PlayerView:onQuickBiaoQing_(event)
    local path = string.format("views/yuyinwenzi/face%d.png", event.info.wordID)
    local x,y = self:getAddPos()
    local sprite = display.newSprite(path):addTo(self.csbNode_):pos(x,y)
    local moveBy = cc.MoveBy:create(0.4, cc.p(0, 10))
    local seq = transition.sequence({
        moveBy,
        moveBy:reverse(),
        moveBy,
        moveBy:reverse(),
        cc.DelayTime:create(0.8),
        cc.FadeOut:create(0.5),
        cc.RemoveSelf:create()
    })
    sprite:runAction(seq)
end

function PlayerView:onQuickYuYin_(event)
    local id = checkint(event.info.wordID)
    local sound = string.format("%d.mp3", id)
    gameAudio.playQuickChat(sound, self.player_:getSex())
    self:showText_(event.info.wordID)
end

function PlayerView:showText_(wordID)
    local node = display.newNode():addTo(self.csbNode_)
    local sprite = display.newSprite("res/images/yuyinwenzi/quickChatbg.png"):addTo(node)
    sprite:setCascadeOpacityEnabled(true)
    sprite:setAnchorPoint(ap)
    if self.index_ == 1 then
        local x,y = self:getAddPos()
        if x and y then
            node:pos(220+x,30+y)
        else
            node:pos(220,30)
        end
    elseif self.index_ == 2 then
        node:pos(-220,30)
        sprite:setScaleX(-1)
    elseif self.index_ == 3 then
        node:pos(220,30)
    elseif self.index_ == 4 then
        node:pos(220,480)
    end
    local word = display.newSprite("res/images/yuyinwenzi/word" .. wordID .. ".png"):addTo(node)
    :pos(0,10)
    local seq = transition.sequence({cc.FadeIn:create(0.5), 
        cc.DelayTime:create(3), 
        cc.FadeOut:create(0.5), 
        cc.CallFunc:create(function ()
            node:removeAllChildren()
            node:removeSelf()
        end)
        })
    node:runAction(seq)
end

function PlayerView:onSetDouZi_(event)
    self.douZiLable_:setString(event.num)
    self.douzi_:show()
    self.doubg_:show()
    self.douZiLable_:show()
end

function PlayerView:onOfflineStatus_(event)
    if event.offline then
        self.offLine_:show()
    else
        self.offLine_:hide()
    end
end

function PlayerView:onPlayerVoice_(event)
    local params = event.info
    local fileName =  params.uid .. "_".. params.time .. ".aac"
    local path = gailun.native.getSDCardPath() .. "/" .. fileName
    gailun.HTTP.download(params.url, path, function (fileName)
        self:downloadVoiceSuceess_(fileName, params)
    end, 
    function (reason)
        self:downloadVoiceFail(reason, params)
    end, 10)
end

function PlayerView:downloadVoiceSuceess_(fileName, params)
    chatRecordData:addGameRecord(fileName, params)
    gailun.native.playSound(fileName, handler(self, self.onPlaySoundReturn_))
end

function PlayerView:onPlaySoundReturn_(data)
    if data.flag == 1 then
        self.yuYinContent_:show()
        self.csbNode_:performWithDelay(function()
            self.yuYinContent_:hide()
        end, math.ceil(data.duration/1000))
    else
        app:showTips("播放失败！")
        self.yuYinContent_:show()
    end
end

function PlayerView:downloadVoiceFail(data, params)
    self.downCount_ = self.downCount_ + 1
    if self.downCount_ > 2 then
        self.downCount_ = 0
        return
    end
    local fileName =  params.uid .. "_".. params.time .. ".aac"
    local path = gailun.native.getSDCardPath() .. "/" .. fileName
    gailun.HTTP.download(self.soundUrl_, path, function (fileName)
        self.downloadVoiceSuceess_(fileName, params)
    end, 
    function (reason)
        self:downloadVoiceFail(reason, params)
    end, 10)
end

function PlayerView:onSetScore_(event)
    self.score_:setString(event.num)
end

function PlayerView:onScoreChange_(event)
    if event.distScore == 0 then return end
    local function callback()
        self.score_:setString(event.num)
    end
    local params = {}
    if event.distScore > 0 then
        params.text = "+" .. event.distScore
        params.font = "fonts/win_score.fnt"
    elseif event.distScore < 0 then
        params.text = event.distScore
        params.font = "fonts/gray_score.fnt"
    end
    params.align = cc.TEXT_ALIGNMENT_RIGHT
    local jiFen = display.newBMFontLabel(params)
    self.csbNode_:addChild(jiFen)
    local x,y = self:getAddPos()
    if x and y then
        jiFen:setPosition(jiFen:getPositionX()+x,jiFen:getPositionY()+y)
    end
    self:socreAnimation_(jiFen, callback)
end

function PlayerView:getAddPos()
    return 0,0
end

function PlayerView:socreAnimation_(sprite, callback)
    local actions = {}
    table.insert(actions, cc.CallFunc:create(function ()
        transition.scaleTo(sprite, {scale = 4, time = 0.2, easing = "bounceOut"})
        end))
    table.insert(actions, cc.DelayTime:create(0.2))
    table.insert(actions, cc.CallFunc:create(function ()
        transition.scaleTo(sprite, {scale = 1, time = 0.2, easing = "bounceOut"})
    end))
    table.insert(actions, cc.CallFunc:create(function ()
        transition.moveTo(sprite, { y = sprite:getPositionY()+80, time = 2})
        transition.fadeTo(sprite, {opacity = 0, time = 2})
        self.csbNode_:performWithDelay(function()
            sprite:removeSelf()
            sprite = nil
        if callback then
            callback()
        end
            end, 1)
    end))
    self.csbNode_:runAction(transition.sequence(actions))
end

function PlayerView:onLevelRoom_(event)
    self:unBindPlayer()
end

function PlayerView:onTurnTo_(event)
    if event.isBeTurnTo then
	   self.zhuanQContent_:show()
    else
        self.zhuanQContent_:hide()
    end
end

function PlayerView:getPos()
    local x, y = self.csbNode_:getPosition()
    return x, y
end

function PlayerView:onReadyHandler_(event)
    self.readyFlag_:setVisible(event.isReady)
    if event.isReady then
        gameAudio.playSound("sounds/sound_ready.mp3")
    end
end

function PlayerView:bindPlayer(player)
    if self.player_ then return end
	self.player_ = player
	self.name_:setString(player:getNickName())
    self.score_:setString(player:getScore())
	self.csbNode_:show()
	self:addEventListeners_()
	self:initTiShiAnimation_()
    self:initHead_()
end

function PlayerView:initTiShiAnimation_()
	local animaData = FaceAnimationsData.getCocosAnimation(6)
    gameAnim.createCocosAnimations(animaData, self.zhuanQContent_)
end

function PlayerView:unBindPlayer()
    self.player_ = nil
    self.csbNode_:hide()
end

function PlayerView:setNode(node)
    self.csbNode_ = node
    self:initElement_()
    self:updateRightPlayer_()
    self:hide_()
    self.csbNode_:addChild(self.zhuanQContent_)
    self.zhuanQContent_:hide()
    self:initYuYinAnimation_()
end

function PlayerView:initYuYinAnimation_()
    self.yuYinContent_ = display.newSprite():addTo(self.csbNode_)
    local animaData = FaceAnimationsData.getCocosAnimation(25)
    gameAnim.createCocosAnimations(animaData, self.yuYinContent_)
    if self.index_ == 1 or self.index_ == 3 then
        self.yuYinContent_:setPositionX(110)
    elseif self.index_ == 2 then
        self.yuYinContent_:setPositionX(-110)
        self.yuYinContent_:setScaleX(-1)
    end
    self.yuYinContent_:hide()
end

function PlayerView:hide_()
    if self.xianshou_ then
        self.xianshou_:hide()
    end
    self.readyFlag_:hide()
end

function PlayerView:updateChuPaiList(view)
    if self.index_ == PlayerView.RIGHT or self.index_ == PlayerView.LEFT then
        view:setScale(0.5)
    else
        view:setScale(0.8)
    end
end

function PlayerView:updateRightPlayer_()
    
end


function PlayerView:initHead_()
    local data = {}
    -- data.nickName = self.player_:getNickName()
    -- data.avatar = self.player_:getAvatar()
    -- data.sex = self.player_:getSex()
    -- data.uid = self.player_:getUid()
    -- data.seatID = self.player_:getSeatID()
    local view = PlayerHead.new(self.player_:getShowParams())
    view:setNode(self.head_)
    view:showWithUrl(self.player_:getAvatar())
end

return PlayerView 
