local UserData = class("UserData", nil)

function UserData:ctor()
    self.uid_ = 0
    self.nowRoomId_ = 0
end

function UserData:setUserData(data)
    dump(data,"UserData:setUserData")
    self.uid_ = data.uid
    self.nickName_ = data.nickName
    self.biSaiKa_ = data.laJiaoDou
    self.token_ = data.token
    self.avatar_ = data.avatar
    self.diamond_ = checkint(data.diamond)
    self.sex_ = checkint(data.sex)
    self.IP_ = data.IP or ''
    self.allowMatch_ = data.allowMatch
    self.allowNiuNiu_ = data.allowNiuNiu
    self.phone_ = data.phone or ''
    self.fatherId_ = checkint(data.fatherId)
    self.customType_ = checkint(data.customType)
    self.loginTime_ = checkint(data.loginTime)
    self.roundCount_ = checkint(data.roundCount)
    self.rateScore_ = checkint(data.rateScore)
    self.score_ = checkint(data.score)
    self.yuanBao_ = checkint(data.yuanBao)
    self.signCount_ = checkint(data.signCount)
    self.signTime_ = checkint(data.signTime)
    self.address_ = "未知"
    self:updateChannelConfig()
end

function UserData:setAddress(address)
    self.address_ = address
end

function UserData:getAddress()
    return self.address_
end

function UserData:updateChannelConfig()
    CHANNEL_CONFIGS.BING_CHENG_NIU_NIU = self.allowNiuNiu_ == 1
end

function UserData:getYuanBao() 
    return self.yuanBao_
end

function UserData:setYuanBao(num) 
    self.yuanBao_ = num
end

function UserData:addYuanBao(num) 
    self.yuanBao_ = self.yuanBao_ + num
end

function UserData:subYuanBao(num) 
    self.yuanBao_ = self.yuanBao_ - num
end

function UserData:setNowRoomID(isInGane)
    self.nowRoomId_ = isInGane
end

function UserData:isInGame()
    return self.nowRoomId_ ~= 0
end

function UserData:getNowRoomID()
    return self.nowRoomId_
end

function UserData:getSignData()
    return self.signCount_, self.signTime_
end

function UserData:updateSignData()
    self.signCount_ = self.signCount_ + 1
    self.signTime_ = gailun.utils.getTime()
end

function UserData:setScore(value)
    self.score_ = value
end

function UserData:getIP()
    return self.IP_
end

function UserData:getScore()
    return self.score_  
end

function UserData:getRateScore()
    return self.rateScore_  
end

function UserData:getRoundCount()
    return self.roundCount_  
end

function UserData:getLoginTime()
    return self.loginTime_  
end

function UserData:getCustomType()
    return self.customType_   --customType : 0 用户 1 代理 3 运营
end

function UserData:setFatherId(fatherId)
    self.fatherId_ = fatherId
end

function UserData:getFatherId()
    return self.fatherId_
end

function UserData:setBiSaiKa(num)
    self.biSaiKa_ = num
end

function UserData:getBiSaiKa()
    return self.biSaiKa_
end

function UserData:getShowParams()
    local params = {
        uid = self.uid_,
        nickName = self.nickName_,
        IP = self.IP_,
        avatar = self.avatar_,
        sex = self.sex_,
        loginTime = self.loginTime_,
        roundCount = self.roundCount_,
        address = self.address_ ,
    }
    return params
end

function UserData:getAllowMatch(num)
    return self.allowMatch_
end

function UserData:setDiamond(num)
    self.diamond_ = num
end

function UserData:getDiamond()
    return self.diamond_
end

function UserData:getSex()
    return self.sex_
end

function UserData:getAvatar()
    return self.avatar_
    -- return "http://thirdwx.qlogo.cn/mmopen/vi_32/rOuz8dAOumCl2Fv3YF9EIeNsAxmicsEq8NZHKkXjvrIWE7gL0kiav4wZowlBTE23W5b6v5E8sYTNWyotPJvbn8yw/132"
end

function UserData:getNickName()
    return self.nickName_
end

function UserData:getToken()
    return self.token_
end

function UserData:setUid(id)
    self.uid_ = id
end

function UserData:getUid()
    return self.uid_
end

function UserData:setAppIsOpen(bool)
    self.isOpened_ = bool
end

function UserData:appIsOpen()
    return self.isOpened_
end

return UserData 
