local BaseController = import(".BaseController")
local ActionButtonsController = class("ActionButtonsController", BaseController)

function ActionButtonsController:ctor()
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)
    self.player_ = dataCenter:getHostPlayer()
    self:initEvents_()
end

function ActionButtonsController:initEvents_()
    local handlers = {  -- UI上的事件监听
        {self.view_.ON_PASS_CLICKED, handler(self, self.onPassClicked_)},
        {self.view_.ON_CHUPAI_CLICKED, handler(self, self.onChuPaiClicked_)},
        {self.view_.ON_TIPS_CLICKED, handler(self, self.onTipsClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.ZMZ_CHU_PAI, handler(self, self.onPlayerChuPai_)},  -- 某人出牌
        {COMMANDS.ZMZ_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.ZMZ_TURN_END, handler(self, self.onTurnEnd_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

-- 判断是否需要显示前置操作
function ActionButtonsController:isNeedShowFlow(data)
    if table.indexof({T_IN_QIANG_ZHUANG, T_IN_XUAN_HAO_YOU}, data.flow) == false then
        return false
    end
    if T_IN_CHUI == data.flow then
        return true
    end
    local pokerTable = dataCenter:getPokerTable()
    local isZhuang = pokerTable:getDealerSeatID() == self.player_:getSeatID()
    if data.flow == T_IN_QIANG_ZHUANG then
        return isZhuang
    end
    return false
end

function ActionButtonsController:doRoundFlow(data)
    local pokerTable = dataCenter:getPokerTable()
    if data.flow == T_IN_QIANG_ZHUANG then
        if pokerTable:getDealerSeatID() ~= self.player_:getSeatID() then
            self:hide()
            return
        end
    end
    if data.flow == T_IN_XUAN_HAO_YOU then
        if pokerTable:getDealerSeatID() == self.player_:getSeatID() then
            self:hide()
            return
        end
    end
end

function ActionButtonsController:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsController:onPlayAction_(event)
    if event.data.code ~= 0 then
        return
    end
    self:hide()
end

function ActionButtonsController:inShowActions()
    return self:isVisible()
end

function ActionButtonsController:onPlayerChuPai_(event)
end

function ActionButtonsController:onRoundOver_(event)
    self:hide()
end

function ActionButtonsController:onTurnEnd_(event)
    self:hide()
end

function ActionButtonsController:calcCanDoActions(...)
    return self.view_:calcCanDoActions(...)
end

function ActionButtonsController:showActions(inFlow, yaoDeQi)
    self:show()
    self.view_:showActions(inFlow, yaoDeQi)
end

function ActionButtonsController:sendPlayAction_(action, params)
    local data = {actType = action}
    table.merge(data, params or {})
    dataCenter:sendOverSocket(COMMANDS.ZMZ_PLAY_ACTION, data)
end

function ActionButtonsController:onPassClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.ZMZ_PLAYER_PASS)
end

function ActionButtonsController:onChuPaiClicked_(event)
    self.player_:dispatchChuPaiEvent()
end

function ActionButtonsController:onTipsClicked_(event)
    self.player_:tishi()
end

return ActionButtonsController
