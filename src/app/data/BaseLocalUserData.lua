local BaseLocalUserData = class("BaseLocalUserData", nil)

function BaseLocalUserData:ctor(data)
    self.userDefault_ = cc.UserDefault:getInstance()
end

function BaseLocalUserData:setUserLocalData(key, info)
    self.userDefault_:setStringForKey(key,tostring(info))
end

function BaseLocalUserData:getUserLocalData(key)
    return self.userDefault_:getStringForKey(key)
end

return BaseLocalUserData 
