local HttpApi = import(".HttpApi")
local UserProtocol = class("UserProtocol", cc.Component)

function UserProtocol:ctor()
    UserProtocol.super.ctor(self, "UserProtocol")
end

function UserProtocol:sendLoginData(socket, tokenData)
    local data = {token = tokenData}
    socket:send({COMMANDS.LOGIN, data})
end

function UserProtocol:exportMethods()
    self:exportMethods_({
        "socketLogin",
        "httpLogin",
    })
    return self.target_
end

function UserProtocol:httpLogin(userName, pwd, onSuc, onFail)
    local userName = userName or dataCenter.playerData.USERNAME
    local pwd = pwd or dataCenter.playerData.PWD
    if not userName or not pwd or string.len(userName) < 1 or string.len(pwd) < 1 then
        return HttpApi.guestLogin(onSuc, onFail)
    end
    
    return HttpApi.login(userName, pwd, onSuc, onFail)
end

function UserProtocol:socketLogin(token)
    assert(token and string.len(token) > 10)
end

function UserProtocol:bindPhone()
    
end

function UserProtocol:onRegFail_()
    printError("register request fail")
end

function UserProtocol:onBind_()
end

function UserProtocol:onUnbind_()
end

return UserProtocol
