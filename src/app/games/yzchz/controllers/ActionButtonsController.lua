local BaseController = import("app.controllers.BaseController")
local ActionButtonsController = class("ActionButtonsController", BaseController)
local PaoHuZiAlgorithm = require("app.games.yzchz.utils.PaoHuZiAlgorithm")
local BaseAlgorithm = require("app.games.yzchz.utils.BaseAlgorithm")
function ActionButtonsController:ctor()
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)

    print("display.height = " .. display.height)
    self.chiView_ = app:createConcreteView("game.ChiView"):addTo(self):pos(display.cx, display.cy)
    gailun.uihelper.setTouchHandler(self, handler(self, self.onBgClicked_))
	self:setTouchSwallowEnabled(false)
    self.currCard_ = 0
    self.canhu_ = false
end

function ActionButtonsController:setTable(model)
    self.table_ = model
end

function ActionButtonsController:setHostPlayer(player)
    self.player_ = player
end

function ActionButtonsController:onBgClicked_(event)
    self.chiView_:bgClick()
end

function ActionButtonsController:onEnter()
    local handlers = {  -- UI上的事件监听
        {self.view_.ON_CHI_CLICKED, handler(self, self.onChiClicked_)},
        {self.view_.ON_PENG_CLICKED, handler(self, self.onPengClicked_)},
        {self.view_.ON_HU_CLICKED, handler(self, self.onHuClicked_)},
        {self.view_.ON_WC_CLICKED, handler(self, self.onWCClicked_)},
        {self.view_.ON_WD_CLICKED, handler(self, self.onWDClicked_)},
        {self.view_.ON_WZ_CLICKED, handler(self, self.onWZClicked_)},
        -- {self.view_.ON_GUO_CLICKED, handler(self, self.onGuoClicked_)},
    }
    gailun.EventUtils.create(self, self.view_, self, handlers)

    -- local handlers = dataCenter:s2cCommandToNames {
    --     {COMMANDS.CHU_PAI, handler(self, self.onPlayerChuPai_)},  -- 某人出牌
    --     {COMMANDS.ROUND_OVER, handler(self, self.onRoundOver_)}, 
    --     {COMMANDS.TURN_END, handler(self, self.onTurnEnd_)},
    -- }
    -- gailun.EventUtils.create(self, dataCenter, self, handlers)
end
 
-- 判断是否需要显示前置操作
function ActionButtonsController:isNeedShowFlow(data)
    return false
end

function ActionButtonsController:doRoundFlow(data)
end

function ActionButtonsController:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsController:onPlayAction_(event)
    if event.data.code ~= 0 then
        return
    end
    -- self:hide()
end

function ActionButtonsController:inShowActions()
    return self:isVisible()
end

function ActionButtonsController:onPlayerChuPai_(event)
end

function ActionButtonsController:onRoundOver_(event)
    -- self:hide()
end 
function ActionButtonsController:onTurnEnd_(event)
    -- self:hide()

end

function ActionButtonsController:calcCanDoActions(...)
    return self.view_:calcCanDoActions(...)
end

function ActionButtonsController:hideSelf()
    self:removeChiView()
    self:hide()
end

function ActionButtonsController:removeChiView()
    self.chiView_:hideSelf()
end

function ActionButtonsController:showCanActions(operates)
    local chi,peng,hu,wc,wd,wz = false, false, false, false,false,false
    if #operates == 0 then
        self:hideSelf()
        return
    end
    for i,v in ipairs(operates) do
        if v == 1 then
            chi = true
        elseif v == 2 then
            peng = true
        elseif v == 3 then
            hu = true
        elseif v == 4 then
            wd = true
        elseif v == 5 then
            wc = true
        elseif v == 6 then
            wz = true
        end
    end
    self:show()
    self.view_:showActions(chi,peng,hu,wc,wd,wz)    
    self:removeChiView()
    self.canhu_ = hu
end
function ActionButtonsController:showActions(chi,peng,hu,wc,wd,wz)
    self.chiView_:hideSelf()
    self:show()
    self.view_:removeFromParent()
    self.view_ = app:createConcreteView("game.ActionButtonsView"):addTo(self)
    self.view_:showActions(chi,peng,hu,wc,wd,wz)
    self.canhu_ = hu
end

function ActionButtonsController:sendPlayAction_(action, params)
    local data = {actType = action}
    table.merge(data, params or {})
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_PLAY_ACTION, data)
end

function ActionButtonsController:onGuoClicked_(event)
    local data = {}
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_PLAYER_PASS, data)
end

function ActionButtonsController:doHuPass(data)
    local function doPass(isOK)    
        if isOK then
            local data = {}
            dataCenter:sendOverSocket(COMMANDS.YZCHZ_HU_PASS, data)
        end
    end
    app:confirm("您确定要过吗？当前可胡", doPass)
end

function ActionButtonsController:setChilist(chiList)
    self.chiList_ = chiList
end

function ActionButtonsController:onChiClicked_(event)
    local card = self.table_:getCurCards()
    local handCards = self.player_:getCards()    
    local chiList = PaoHuZiAlgorithm.searchChi(handCards,card,false)
    -- local testcard = 107
    -- local testchilist = PaoHuZiAlgorithm.searchChi({102,107,110 ,105,106,106,107,108,207,207,109},testcard,false)
    -- self.chiView_:showChoise(testcard,testchilist, handler(self,self.onChiClose))
    self.chiView_:showChoise(card,chiList, handler(self,self.onChiClose))
end

function ActionButtonsController:onChiClose(chi_path)
    if chi_path then
        --直接发送吃命令
        local chiPai = chi_path[1]
        local biPai = clone(chi_path)
        table.remove(biPai,1)
        local data = {chiPai = chiPai, biPai = biPai}
        dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_CHI, data)
    end 
    self:onActionEnd()
end

function ActionButtonsController:onPengClicked_(event)
    local data = {}
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_PENG, data)
end

function ActionButtonsController:onHuClicked_(event)
    local data = {}
    data.wType = -1
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_HU, data)
end

function ActionButtonsController:onWCClicked_(event)
    dump("onWCClicked_")
    local data = {}
    data.wType = 5
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_HU, data)
end

function ActionButtonsController:onWDClicked_(event)
    dump("onWDClicked_")
    local data = {}
    data.wType = 4
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_HU, data)
end

function ActionButtonsController:onWZClicked_(event)
    dump("onWZClicked_")
    local data = {}
    data.wType = 6
    dataCenter:sendOverSocket(COMMANDS.YZCHZ_USER_HU, data)
end

function ActionButtonsController:onActionEnd()
    self:removeChiView()
    if self.action_end_func then
        self.action_end_func(seconds)
    end
end
return ActionButtonsController
