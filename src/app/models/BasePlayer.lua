local BasePlayer = class("BasePlayer", cc.mvc.ModelBase)
BasePlayer.READY_GAME = "READY_GAME"
BasePlayer.PLAYER_CHUPAI = "PLAYER_CHUPAI"
BasePlayer.TURN_TO = "TURN_TO"
BasePlayer.LEVEL_ROOM = "LEVEL_ROOM"
BasePlayer.PASS = "PASS"
BasePlayer.ROUND_START = "ROUND_START"
BasePlayer.ROUND_OVER = "ROUND_OVER"
BasePlayer.SCORE_CHANGE = "SCORE_CHANGE"
BasePlayer.SET_SCORE = "SET_SCORE"
BasePlayer.SCORE_ACTION = "SCORE_ACTION"
BasePlayer.START_VOICE = "START_VOICE"
BasePlayer.PLAY_VOICE = "PLAY_VOICE"
BasePlayer.SET_OFFLINE_STATUS = "SET_OFFLINE_STATUS"
BasePlayer.ON_STOP_RECORD_VOICE = "ON_STOP_RECORD_VOICE" 
BasePlayer.ON_PLAY_RECORD_VOICE = "ON_PLAY_RECORD_VOICE"
BasePlayer.SET_DOU_ZI = "SET_DOU_ZI"
BasePlayer.QUICK_YU_YIN = "QUICK_YU_YIN"
BasePlayer.QUICK_BIAO_QING = "QUICK_BIAO_QING"
BasePlayer.ROOM_INFO = "ROOM_INFO"
function BasePlayer:ctor()  
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function BasePlayer:setOffline(offline)
    local event = {name = BasePlayer.SET_OFFLINE_STATUS, offline = offline}
    self:dispatchEvent(event)
end

function BasePlayer:setRoomInfo(info)
    local event = {name = BasePlayer.ROOM_INFO, info = info}
    self:dispatchEvent(event)
end

function BasePlayer:setDouzi(num)
    self.douzi_ = num
end

function BasePlayer:setCards(cards)
    self.cards_ = cards
end

function BasePlayer:getCards()
    return self.cards_
end

function BasePlayer:showDouZi(num)
    if self.douzi_ == nil then return end
    self.douzi_ = self.douzi_ + (num or 0)
    self:dispatchEvent({name = BasePlayer.SET_DOU_ZI, num = self.douzi_})
end

function BasePlayer:playRecordVoice(time)
    self:dispatchEvent({name = BasePlayer.ON_PLAY_RECORD_VOICE, time = time})
end

function BasePlayer:stopRecordVoice()
    self:dispatchEvent({name = BasePlayer.ON_STOP_RECORD_VOICE})
end


function BasePlayer:pass()
    local event = {name = BasePlayer.PASS}
    self:dispatchEvent(event)
end

function BasePlayer:playVoice(info)
    local event = {name = BasePlayer.PLAY_VOICE, info = info}
    self:dispatchEvent(event)
end

function BasePlayer:roundStart()
    self:setIsReady(false)
end

function BasePlayer:roundOver()
    self:setIsReady(false)
end

function BasePlayer:levelRoom()
    local event = {name = BasePlayer.LEVEL_ROOM}
    self:dispatchEvent(event)
end

function BasePlayer:setIsReady(flag)
    self.isReady_ = flag
    local event = {name = BasePlayer.READY_GAME, isReady = flag}
    self:dispatchEvent(event)
end

function BasePlayer:isReady()
    return self.isReady_
end

function BasePlayer:setChuPai(cards, isReConnect)
    local event = {name = BasePlayer.PLAYER_CHUPAI, isReConnect = isReConnect, cards = cards}
    self:dispatchEvent(event)
end

function BasePlayer:setTurnTo(isBeTurnTo)
    local event = {name = BasePlayer.TURN_TO, isBeTurnTo = isBeTurnTo}
    self:dispatchEvent(event)
end

function BasePlayer:setScore(num, distScore)
    local lockScore = display.getRunningScene():getLockScore()
    self.score_ = num
    local event = {name = BasePlayer.SCORE_CHANGE, num = num+lockScore, distScore = distScore+lockScore}
    self:dispatchEvent(event)
end

function BasePlayer:setAnlyScore(num)
    local lockScore = display.getRunningScene():getLockScore()
    self.score_ = num
    local event = {name = BasePlayer.SET_SCORE, num = num+lockScore}
    self:dispatchEvent(event)
end


function BasePlayer:getScore()
    local lockScore = display.getRunningScene():getLockScore() 
    return self.score_+lockScore
end

function BasePlayer:setData(data)
    for k,v in pairs(data) do
        local name = k .. "_"
        self[name] = v
    end
end

function BasePlayer:getShowParams()
    local params = {
        uid = self.uid_,
        nickName = self.nickName_,
        IP = self.IP_,
        avatar = self.avatar_,
        sex = self.sex_,
        roundCount = self.roundCount_,
        loginTime = self.loginTime_,
        seatID = self.seatID_,
        address = self.address_
    }
    return params
end

function BasePlayer:getAvatar()
    return self.avatar_
end

function BasePlayer:isHost()
    return self.uid_ == selfData:getUid()
end

function BasePlayer:getUid()
    return self.uid_
end

function BasePlayer:getNickName()
    return self.nickName_
end

function BasePlayer:getSeatID()
    return self.seatID_
end

function BasePlayer:getIP()
    return self.IP_
end

function BasePlayer:getSex()
    return self.sex_
end

function BasePlayer:startRecordVoice()
    local event = {name = BasePlayer.START_VOICE, isLuYin = true}
    self:dispatchEvent(event)
end

function BasePlayer:stopRecordVoice()
    local event = {name = BasePlayer.START_VOICE, isLuYin = false}
    self:dispatchEvent(event)
end

function BasePlayer:quickYuYin(info)
    local event = {name = BasePlayer.QUICK_YU_YIN, info = info}
    self:dispatchEvent(event)
end

function BasePlayer:quickBiaoQing(info)
    local event = {name = BasePlayer.QUICK_BIAO_QING, info = info}
    self:dispatchEvent(event)
end

return BasePlayer
