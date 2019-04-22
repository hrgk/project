local SystemBroadcastController = class("SystemBroadcastController", nil)

function SystemBroadcastController:ctor(target)
    self.target_ = target
    self.list_ = {}
    self.hongBaoZhongJiangView_ = app:createConcreteView("game.HongBaoZhongJiangView"):addTo(target)
    self.hongBaoZhongJiangView_:setCallback(handler(self, self.run))
end

function SystemBroadcastController:addBroadcast(obj)
    self.list_[#self.list_+1] = obj
end

function SystemBroadcastController:isRunning()
    return self.hongBaoZhongJiangView_:isRunning()
end

function SystemBroadcastController:run()
    if #self.list_ == 0 then 
        self.hongBaoZhongJiangView_:setRunning(false)
        return 
    end
    local obj = self:popBroadcast_()
    local holdTime = obj.long_time
    if #self.list_ > 0 then
        holdTime = obj.short_time
    end
    local message = "恭喜用户ID：" .. obj.uid .. "昵称：" .. obj.nickname .. "的牌友开房抽奖喜获钻石" .. obj.diamond .. "个"
    self.hongBaoZhongJiangView_:update(message, holdTime)
end

function SystemBroadcastController:popBroadcast_()
    local obj = {}
    if #self.list_ ~= 0 then
        obj = self.list_[1]
        table.remove(self.list_, 1)
    end
    return obj
end

return SystemBroadcastController 
