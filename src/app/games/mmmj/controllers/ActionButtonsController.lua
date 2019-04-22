local BaseController = import("app.controllers.BaseController")
local ActionButtonsController = class("ActionButtonsController", BaseController)
local ZZAlgorithm = require("app.games.mmmj.utils.ZZAlgorithm")

function ActionButtonsController:ctor(gameType)
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)
    self.gameType_ = gameType
    self.chiView_ = app:createConcreteView("game.ChiView"):addTo(self):pos(display.cx, display.cy)
    self.operateCardView_ = app:createConcreteView("game.OperateCardView"):addTo(self):pos(display.cx, display.cy)
    self.operates = {}
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
        {self.view_.ON_QIANG_GANG_HU_CLICKED, handler(self, self.onQiangGangHuClicked_)},
        {self.view_.ON_BU_ZHANG_CLICKED, handler(self, self.onBuClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)

    local handlers = dataCenter:s2cCommandToNames {
        {COMMANDS.MMMJ_CHU_PAI, handler(self, self.onPlayerChuPai_)},  -- 某人出牌
        {COMMANDS.MMMJ_ROUND_START, handler(self, self.onRoundStart_)},
        {COMMANDS.MMMJ_ROUND_OVER, handler(self, self.onRoundOver_)},
        -- {COMMANDS.MMMJ_PLAY_ACTION, handler(self, self.onPlayAction_)},
    }
    gailun.EventUtils.create(self, dataCenter, self, handlers)
end

function ActionButtonsController:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsController:hideSelf()
    self:removeOperateView()
    self:hide()
end

function ActionButtonsController:removeOperateView()
    self.chiView_:hideSelf()
    self.operateCardView_:hideSelf()
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
    self:removeOperateView()
    local card = self.table_:getLastCard()
    local handCards = self.player_:getCards()
    local chidata = {}
    for k,v in pairs(self.data) do
        if v.operate == CSMJ_ACTIONS.CHI then
            chidata = v.operate_info
        end
    end

    if #chidata == 1 then
        local operateCards = chidata[1].operateCards
        if #operateCards == 1 then
            local data = {card = chidata[1].card, operateCards = chidata[1].operateCards[1]}
            print("chi send card:")
            dump(data)
            dataCenter:sendOverSocket(COMMANDS.MMMJ_USER_CHI, data)
            self.player_:stopZhuanQuanAction()
            return
        end
    end
    self.chiView_:showChoise(card, chidata, handler(self, self.onChiClose))
end

function ActionButtonsController:onChiClose(chi_path)
    if chi_path then
        --直接发送吃命令
        local data = chi_path
        dataCenter:sendOverSocket(COMMANDS.MMMJ_USER_CHI, data)
    end 
    self:onActionEnd()
end

function ActionButtonsController:onActionEnd()
    self:removeOperateView()
end

function ActionButtonsController:showNormal()
end

function ActionButtonsController:onPengClicked_(event)
    self:removeOperateView()
    local cards = {}
    local types = {}
    local pengdata= {}
    dump(self.data,7,7)
     for k,v in pairs(self.data) do
        if v.operate == CSMJ_ACTIONS.PENG then
            print("peng operates")
            pengdata = v.operate_info
        end
    end
    if #pengdata == 1 then
        local data = {card = pengdata[1].card, operateCards = {pengdata[1].card, pengdata[1].card}}
        dataCenter:sendOverSocket(COMMANDS.MMMJ_USER_PENG, data)
        self.player_:stopZhuanQuanAction()
        return
    end
    for k,v in pairs(pengdata) do
        table.insert(cards, v.card)
        table.insert(types, CSMJ_ACTIONS.PENG)
    end
    self.operateCardView_:showChoise(cards, handler(self, self.onPengClose), types)
end

function ActionButtonsController:onPengClose(card, type)
    if card then
        local data = {card = card, operateCards = {card, card}}
        dataCenter:sendOverSocket(COMMANDS.MMMJ_USER_PENG, data)
        self.player_:stopZhuanQuanAction()
    end 
    self:onActionEnd()
end

function ActionButtonsController:onAnGangClicked_(event)
    self:removeOperateView()
    local cards = {}
    local types= {}
    dump(self.data,7,7)
     for k,v in pairs(self.data) do
        print(v.operate)
        if v.operate == CSMJ_ACTIONS.CHI_GANG then
            local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
        if v.operate == CSMJ_ACTIONS.BU_GANG then
            local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
        if v.operate == CSMJ_ACTIONS.AN_GANG then
            local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
    end
      if #cards == 1 then
        local data = {card = cards[1], operateCards = {cards[1], cards[1]}}
        local command = COMMANDS.MMMJ_USER_AN_GANG
        if types[1] == CSMJ_ACTIONS.CHI_GANG then
            command = COMMANDS.MMMJ_USER_GONG_GANG
        end
        if types[1] == CSMJ_ACTIONS.BU_GANG then
            command = COMMANDS.MMMJ_USER_MING_GANG
        end
        dataCenter:sendOverSocket(command, data)
        self.player_:stopZhuanQuanAction()
        return
    end
    self.operateCardView_:showChoise(cards, handler(self, self.onAnGangClose), types)
end

function ActionButtonsController:onAnGangClose(card, types)
    if card then   
        local data = {card = card, operateCards = {card, card, card}}
        local command = COMMANDS.MMMJ_USER_AN_GANG
        if types == CSMJ_ACTIONS.CHI_GANG then
            command = COMMANDS.MMMJ_USER_GONG_GANG
        end
        if types == CSMJ_ACTIONS.BU_GANG then
            command = COMMANDS.MMMJ_USER_MING_GANG
        end
        dataCenter:sendOverSocket(command, data)
        self.player_:stopZhuanQuanAction()
    end 
    self:onActionEnd()
end


function ActionButtonsController:onBuClicked_(event)
    self:removeOperateView()
    local cards = {}
    local types= {}
    dump(self.data,7,7)
     for k,v in pairs(self.data) do
        print(v.operate)
        if v.operate == CSMJ_ACTIONS.GONG_BU then
            local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
        if v.operate == CSMJ_ACTIONS.AN_BU then
            local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
        if v.operate == CSMJ_ACTIONS.MING_BU then
         local operate_info  = v.operate_info
            for k,t in pairs(operate_info) do
                table.insert(cards, t.card)
                table.insert(types, v.operate)
            end
        end
    end
    if #cards == 1 then
        local data = {card = cards[1], operateCards = {cards[1], cards[1]}}
        local command = COMMANDS.MMMJ_USER_BU_CARD
        if types[1] == CSMJ_ACTIONS.GONG_BU then
            command = COMMANDS.MMMJ_USER_GONG_BU
        end
        if types[1] == CSMJ_ACTIONS.MING_BU then
            command = COMMANDS.MMMJ_USER_MING_BU
        end
        dataCenter:sendOverSocket(command, data)
        self.player_:stopZhuanQuanAction()
        return
    end
    self.operateCardView_:showChoise(cards, handler(self, self.onBuClose), types)
end

function ActionButtonsController:onBuClose(card, types)
    dump(types)
    if card then   
        local data = {card = card, operateCards = {card, card, card}}
        local command = COMMANDS.MMMJ_USER_BU_CARD
        if types == CSMJ_ACTIONS.GONG_BU then
            command = COMMANDS.MMMJ_USER_GONG_BU
        end
        if types == CSMJ_ACTIONS.MING_BU then
            command = COMMANDS.MMMJ_USER_MING_BU
        end
        dataCenter:sendOverSocket(command, data)
        self.player_:stopZhuanQuanAction()
    end 
    self:onActionEnd()
end

function ActionButtonsController:onChiHuClicked_(event)
    self:sendPlayAction_(CSMJ_ACTIONS.CHI_HU)
end

function ActionButtonsController:onZiMouClicked_(event)
    print("onHU8Clicked_:")
    local data = {}
    dataCenter:sendOverSocket(COMMANDS.MMMJ_USER_HU, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onQiangGangHuClicked_(event)
    self:sendPlayAction_(CSMJ_ACTIONS.QIANG_GANG_HU)
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
    self.view_:showActions(self.gameType_)
end

function ActionButtonsController:showOperates(operates, gameType, isQiangZhiHu)
    -- self.operates = {CSMJ_ACTIONS.CHI, CSMJ_ACTIONS.PENG, CSMJ_ACTIONS.CHI_GANG, CSMJ_ACTIONS.CHI_HU}
    self.data = clone(operates)
    self.operates = {}
    local operateCards = {}
    for k,v in ipairs(self.data) do
        table.insert(self.operates, v.operate)
    end

    local isShowPass = true
    if isQiangZhiHu == 1 and
    (
        table.indexof(self.operates, CSMJ_ACTIONS.ZI_MO) ~= false or
        table.indexof(self.operates, CSMJ_ACTIONS.CHI_HU) ~= false or
        table.indexof(self.operates, CSMJ_ACTIONS.QIANG_GANG_HU) ~= false
    ) then
        isShowPass = false
    end
    -- self.data = operates
    self.gameType_ = gameType
    self:show()
    self.view_:showOperates(self.operates, self.data, isShowPass)
end

function ActionButtonsController:sendPlayAction_(action, params)
    print("sendPlayAction_(action, params)")
    local data = {actType = action}
    table.merge(data, params or {})
    dataCenter:sendOverSocket(COMMANDS.MMMJ_PLAY_ACTION, data)
    self.player_:stopZhuanQuanAction()
end

function ActionButtonsController:onPassClicked_(event)
    print("sendPlayAction_(action, params)")
    -- self:sendPlayAction_(CSMJ_ACTIONS.GUO)
    local card = self.table_:getLastCard()

    local data = {cards = card}
    dataCenter:sendOverSocket(COMMANDS.MMMJ_PLAYER_PASS, data)
    self.player_:stopZhuanQuanAction()
    if event.actions and table.indexof(event.actions, CSMJ_ACTIONS.CHI_HU) ~= false then
        local publicCard = self.table_:getLastCard()  -- 能胡不胡，进漏牌
        self.player_:addLouHu(publicCard)
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
