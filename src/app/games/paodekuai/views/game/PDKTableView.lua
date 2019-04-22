local TableView = import("app.views.game.TableView")
local PDKTableView = class("PDKTableView", TableView)
local PDKPlayerView = import(".PDKPlayerView")
local HOST = 1
local LEFT = 3
local RIGHT = 2

function PDKTableView:ctor(model)
    PDKTableView.super.ctor(self, model)
    self.setting_:setCMD(COMMANDS.PDK_LEAVE_ROOM, COMMANDS.PDK_OWNER_DISMISS, GAME_PAODEKUAI)
    self.naoZhongController_:setVisible(false)
end

-- function PDKTableView:initLayerTouch_()
--     local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, 0))
--     self:addChild(maskLayer)
--     maskLayer:setTouchEnabled(true)
--     maskLayer:setTouchSwallowEnabled(false)  -- 吞噬
--     maskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
--         display.getRunningScene():clickTable()
--         display.getRunningScene():hideWenYuYin()
--         self.isShowMenu_ = false
--         self.setting_:setVisible(self.isShowMenu_)
--         end)
-- end

function PDKTableView:onGoldFlyHandler_(event)
    local winner = self["player" .. event.winner .. "_"]
    local toX, toY = winner:getPosition()
    local actions = {}
    for i,v in ipairs(event.loses) do
         table.insert(actions, cc.CallFunc:create(function ()
            local loser = self["player" .. v .. "_"]
            local fromX, fromY = loser:getPosition()
            if v == 1 and setData:getPDKPMTYPE()+0 == 1 then
                self:goldFly_(toX,toY,fromX,fromY+240)
            else
                self:goldFly_(toX,toY,fromX,fromY)
            end
        end))
        table.insert(actions, cc.DelayTime:create(0.5))
    end
    self.csbNode_:runAction(transition.sequence(actions))
end

function PDKTableView:initEventListeners()
    PDKTableView.super.initEventListeners(self)
end

function PDKTableView:initPlayerSeats()
    self.players_ = {}
    for i=1,3 do
        local playerView = PDKPlayerView.new(i)
        local player = "player" .. i .."_"
        if self[player] then
            playerView:setNode(self[player])
            playerView:setBombLayer(self.csbNode_)
            self.players_[i] = playerView
            self[player]:hide()
        end
    end
end

function PDKTableView:onTurnToHandler_(event)
    self.naoZhongController_:stop()
    if event.index == -1 then
        self.naoZhongController_:setPos(1500, 1000)
        return 
    end
    local view = self.players_[event.index]
    local x, y = view:getPos()
    if event.index == HOST then
        x = x + 580
        y = y + 250
    elseif event.index == LEFT then
        x = x + 200
        y = y 
    elseif event.index == RIGHT then
        x = x - 200
        y = y 
    end
    self.naoZhongController_:setVisible(true)
    self.naoZhongController_:setPos(x, y)
    self.naoZhongController_:setTimer(event.seconds or 5)
end

function PDKTableView:onTableInfoHandler_(event)
    PDKTableView.super.onTableInfoHandler_(self, event)
end

function PDKTableView:queDingHandler_()
    display.getRunningScene():continueTask()
    self.queDing_:hide()
end

function PDKTableView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/pdk/tableView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function PDKTableView:showReady(event)
    self.kaiShi_:show()
end

function PDKTableView:kaiShiHandler_(event)
    self.kaiShi_:hide()
    dataCenter:sendOverSocket(COMMANDS.PDK_READY)
end

function PDKTableView:yaoQingHandler_(event)
    local data = self.table_:getRuleDetails()
    local roomId = self.table_:getTid()
    local round = self.table_:getTotalRound()
    local houzi = "无猴子，"
    if data.red10 == 1 then
        houzi = "有猴子，"
    end
    local queRenMsg = ""
    if data.playerCount == 3 then
        if self.table_:getCurrPlayerCount() == 1 then
            queRenMsg = "一缺二，"
        elseif self.table_:getCurrPlayerCount() == 2 then
            queRenMsg = "二缺一，"
        end
    elseif data.playerCount == 2 then
        if self.table_:getCurrPlayerCount() == 1 then
            queRenMsg = "缺一，"
        end
    end
    local title = "激情跑得快 房间号【" .. roomId .. "】"
    local description = "<" .. data.cardCount.. "张牌> " .. round .."局，" ..houzi ..queRenMsg .. "速度来玩！"
    local function callback()
        
    end
    display.getRunningScene():shareWeiXin(title, description, 0,callback,roomId,selfData:getUid())
end

function PDKTableView:getGameInfo_()
    local data = self.table_:getRuleDetails()
    local info = data.playerCount .. "人\n"
    info = info .. data.cardCount .. "张牌\n"
    info = info .. self.table_:getTotalRound() .. "局\n"
    local houzi = "无猴子\n"
    if data.red10 == 1 then
        houzi = "有猴子\n"
    end
    info = info .. houzi
    return info
end

function PDKTableView:chaKanHandler_()
    self.chaKan_:hide()
    self.jiXv_:hide()
    display.getRunningScene():showRoundOver()
end

function PDKTableView:jiXvHandler_()
    display.getRunningScene():continueTask()
    dataCenter:sendOverSocket(COMMANDS.PDK_READY)
    self.chaKan_:hide()
    self.jiXv_:hide()
end

function PDKTableView:wanFaHandler_()
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_PAODEKUAI,date)
end

return PDKTableView 
