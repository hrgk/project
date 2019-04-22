local ActionButtonsController = class("ActionButtonsController",  function()
    local node = display.newNode()
    node:setNodeEventEnabled(true)
    return node
end)
local ZZAlgorithm = require("app.games.hzmajiang.utils.ZZAlgorithm")

function ActionButtonsController:ctor(gameType)
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)
    self.gameType_ = gameType
    self.chiView_ = app:createConcreteView("game.ChiView"):addTo(self):pos(display.cx, display.cy)
end

function ActionButtonsController:setTable(model)
    self.table_ = model
end

function ActionButtonsController:setHostPlayer(player)
    self.player_ = player
end

function ActionButtonsController:onEnter()
    local handlers = {  -- UI上的事件监听
        {self.view_.ON_PASS_CLICKED, handler(self, self.onPassClicked_)},
        {self.view_.ON_CHI_CLICKED, handler(self, self.onChiClicked_)},
        {self.view_.ON_PENG_CLICKED, handler(self, self.onPengClicked_)},
        {self.view_.ON_CHI_HU_CLICKED, handler(self, self.onChiHuClicked_)},
        {self.view_.ON_ZI_MO_CLICKED, handler(self, self.onZiMouClicked_)},
        {self.view_.ON_AN_GANG_CLICKED, handler(self, self.onAnGangClicked_)},
        {self.view_.ON_CHI_GANG_CLICKED, handler(self, self.onChiGangClicked_)},
        {self.view_.ON_QIANG_GANG_HU_CLICKED, handler(self, self.onQiangGangHuClicked_)},
        {self.view_.ON_BU_GANG_CLICKED, handler(self, self.onBuGangClicked_)},
        {self.view_.ON_BU_ZHANG_CLICKED, handler(self, self.onBuClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)

    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.HZMJ_CHU_PAI, handler(self, self.onPlayerChuPai_)},  -- 某人出牌
        {COMMANDS.HZMJ_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.HZMJ_ROUND_OVER, handler(self, self.onRoundOver_)},
        {COMMANDS.HZMJ_PLAY_ACTION, handler(self, self.onPlayAction_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function ActionButtonsController:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsController:hideSelf()
    self:removeChiView()

    self:hide()
end

function ActionButtonsController:removeChiView()
    self.chiView_:hideSelf()
end

function ActionButtonsController:onPlayAction_(event)
    if event.data.code ~= 0 then
        return
    end
    self:hide()
end

function ActionButtonsController:inShowActions()
    return self.view_:inShowActions()
end

function ActionButtonsController:onChiClicked_(event)
    local card = self.table_:getLastCard()
    local handCards = self.player_:getCards()    

    -- card = 13
    -- local chiList = ZZAlgorithm.searchChi({11,12,13 ,14,15,16,17,18,27,27,19},card)
    local chiList = ZZAlgorithm.searchChi(handCards, card)
    self.chiView_:showChoise(card, chiList, handler(self, self.onChiClose))
end

function ActionButtonsController:onChiClose(chi_path)
    if chi_path then
        --直接发送吃命令
        
        local data = {cards = chi_path}
        dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_CHI, data)
    end 
    self:onActionEnd()
end

function ActionButtonsController:onActionEnd()
    self.chiView_:hideSelf()
    if self.action_end_func then
        self.action_end_func(seconds)
    end
end

function ActionButtonsController:showNormal()
end

function ActionButtonsController:onPengClicked_(event)
    local card = display.getRunningScene():getTable():getLastCard()

    local data = {cards = card}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_PENG, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onAnGangClicked_(event)
    print("onAnGangClicked_:")
    local data = {}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_GANG, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onChiGangClicked_(event)
    print("onChiGangClicked_:")
    local data = {actType = MJ_ACTIONS.CHI_GANG}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_GANG, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onBuGangClicked_(event)
    print("onBuGangClicked_:")
    local data = {actType = MJ_ACTIONS.BU_GANG}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_GANG, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onBuClicked_(event)
    print("onBuClicked_:")
    local data = {actType = MJ_ACTIONS.BU_ZHANG}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_BU_CARD, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onChiHuClicked_(event)
    self:sendPlayAction_(MJ_ACTIONS.CHI_HU)
end

function ActionButtonsController:onZiMouClicked_(event)
    print("onHU8Clicked_:")
    local data = {}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_USER_HU, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onQiangGangHuClicked_(event)
    self:sendPlayAction_(MJ_ACTIONS.QIANG_GANG_HU)
end

function ActionButtonsController:onPlayerChuPai_(event)
    self:hide()
end

function ActionButtonsController:onRoundStart_(event)
    if event.data.dealerSeatID ~= self.player_:getSeatID() then
        self:hide()
        return
    end
    self:showActions()
end

function ActionButtonsController:onRoundOver_(event)
    self:hide()
end

function ActionButtonsController:calcCanDoActions(...)
    return self.view_:calcCanDoActions(...)
end

function ActionButtonsController:showActions()
    self:show()
    print("============Controller:showOperate============")
    self.view_:showActions(self.gameType_)
end

function ActionButtonsController:showOperates(operates, gameType,needAuto,isCanTing)
    self.gameType_ = gameType
    self:show()
    self.view_:showOperates(operates, gameType,needAuto,isCanTing)
end

function ActionButtonsController:sendPlayAction_(action, params)
    print("sendPlayAction_(action, params)")
    local data = {actType = action}
    table.merge(data, params or {})
    dataCenter:sendOverSocket(COMMANDS.HZMJ_PLAY_ACTION, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onPassClicked_(event)
    print("sendPlayAction_(action, params)")
    -- self:sendPlayAction_(MJ_ACTIONS.GUO)
    local card = display.getRunningScene():getTable():getLastCard()

    local data = {cards = card}
    dataCenter:sendOverSocket(COMMANDS.HZMJ_PLAYER_PASS, data)
    self.player_:stopZhuanQuanAction()
    if event.actions and table.indexof(event.actions, MJ_ACTIONS.CHI_HU) ~= false then
        local publicCard = display.getRunningScene():getTable():getLastCard()  -- 能胡不胡，进漏牌
        display.getRunningScene():getHostPlayer():addLouHu(publicCard)
    end
    self:hide()
end

function ActionButtonsController:setReViewEnable(v)
    self.view_:setReViewEnable(v)
    self.isReView = true
end

function ActionButtonsController:show()
    local visible = true
    if self.isReView  then
        visible = false
    end
    self:setVisible(visible)
end

return ActionButtonsController
