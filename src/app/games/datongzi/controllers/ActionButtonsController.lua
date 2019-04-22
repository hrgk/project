local BaseController = import(".BaseController")
local ActionButtonsController = class("ActionButtonsController", BaseController)

function ActionButtonsController:ctor()
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)
    self:initEvents_()
end

function ActionButtonsController:getPlayer()
    return display:getRunningScene():getHostPlayer()
end

function ActionButtonsController:initEvents_()
    local handlers = {  -- UI上的事件监听
        {self.view_.ON_PASS_CLICKED, handler(self, self.onPassClicked_)},
        {self.view_.ON_CHUPAI_CLICKED, handler(self, self.onChuPaiClicked_)},
        {self.view_.ON_TIPS_CLICKED, handler(self, self.onTipsClicked_)},
        {self.view_.ON_SORT_CLICKED, handler(self, self.onSort_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)
    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.DTZ_CHU_PAI, handler(self, self.onPlayerChuPai_)},  -- 某人出牌
        {COMMANDS.DTZ_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.DTZ_TURN_END, handler(self, self.onTurnEnd_)},
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
    local pokerTable = display:getRunningScene():getTable()
    local isZhuang = pokerTable:getDealerSeatID() == self:getPlayer():getSeatID()
    if data.flow == T_IN_QIANG_ZHUANG then
        return isZhuang
    end
    return false
end

function ActionButtonsController:doRoundFlow(data)
    local pokerTable = display:getRunningScene():getTable()
    if data.flow == T_IN_QIANG_ZHUANG then
        if pokerTable:getDealerSeatID() ~= self:getPlayer():getSeatID() then
            self:hide()
            return
        end
    end
    if data.flow == T_IN_XUAN_HAO_YOU then
        if pokerTable:getDealerSeatID() == self:getPlayer():getSeatID() then
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
    self.view_:setVisibleAction(false)
end

function ActionButtonsController:inShowActions()
    return self.view_:isVisibleAction()
end

function ActionButtonsController:setChuPaiBtnStatus(isCanChuPai_)
    self.view_:setChuPaiBtnStatus(isCanChuPai_)
end

function ActionButtonsController:setPassBtnStatus(isCanClicked_)
    self.view_:setPassBtnStatus(isCanClicked_)
end

function ActionButtonsController:onPlayerChuPai_(event)
end

function ActionButtonsController:onRoundOver_(event)
    self:hide()
end

function ActionButtonsController:setVisibleAction(isVisible)
    self.view_:setVisibleAction(isVisible)
end

function ActionButtonsController:onTurnEnd_(event)
    self.view_:setVisibleAction(false)
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
    dataCenter:sendOverSocket(COMMANDS.DTZ_PLAY_ACTION, data)
end

function ActionButtonsController:onPassClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.DTZ_PLAYER_PASS)
    self:getPlayer():passEvent()
end

function ActionButtonsController:onChuPaiClicked_(event)
    self:getPlayer():dispatchChuPaiEvent()
end

function ActionButtonsController:onTipsClicked_(event)
    self:getPlayer():tishi()
end

function ActionButtonsController:onSort_(event)
    self:getPlayer():sortCards()
end

function ActionButtonsController:onTipsClicked_(event)
    self:getPlayer():tishi()
end

-- function ActionButtonsController:onPassSprite_(event)
--     self:getPlayer():passEvent()
-- end

return ActionButtonsController
