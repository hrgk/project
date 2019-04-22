local TableView = import("app.views.game.TableView")
local ZMZTableView = class("ZMZTableView", TableView)
local ZMZPlayerView = import(".ZMZPlayerView")
local HOST = 1
local LEFT = 3
local RIGHT = 2

function ZMZTableView:ctor(model)
    ZMZTableView.super.ctor(self, model)
    self.setting_:setCMD(COMMANDS.ZMZ_LEAVE_ROOM, COMMANDS.ZMZ_OWNER_DISMISS, GAME_FHLMZ)
    self.naoZhongController_:setVisible(false)
    self:initTGAnim()
end

-- function ZMZTableView:initLayerTouch_()
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

function ZMZTableView:onShowPlayHandler_(event)
    self.playController_:showButsByType(event.isShow, event.cType)
end

function ZMZTableView:onGoldFlyHandler_(event)
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

function ZMZTableView:initEventListeners()
    ZMZTableView.super.initEventListeners(self)
    cc.EventProxy.new(self.table_, self, true)
    :addEventListener(self.table_.SHOW_TUO_GUAN_ANIMA, handler(self, self.onShowTuoGuanAnima_))
    :addEventListener(self.table_.SHOW_TUO_GUAN_BTN, handler(self, self.onShowTuoGuanBtn_))
end

function ZMZTableView:onShowTuoGuanBtn_(event)
    self.tuoguan_:setVisible(event.bool)
end

function ZMZTableView:onShowTuoGuanAnima_(event)
    self:showTGAnim(event.bool)
    self.tuoguan_:setSelected(event.bool)
end

function ZMZTableView:initPlayerSeats()
    self.players_ = {}
    for i=1,3 do
        local playerView = ZMZPlayerView.new(i)
        local player = "player" .. i .."_"
        if self[player] then
            playerView:setNode(self[player])
            playerView:setBombLayer(self.csbNode_)
            self.players_[i] = playerView
            self[player]:hide()
        end
    end
end

function ZMZTableView:onTurnToHandler_(event)
    self.naoZhongController_:stop()
    if event.index == -1 then
        self.naoZhongController_:setPos(1500, 1000)
        return 
    end
    local view = self.players_[event.index]
    local x, y = view:getPos()
    if event.index == HOST then
        x = x + 580
        y = y + 350
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

function ZMZTableView:onTableInfoHandler_(event)
    ZMZTableView.super.onTableInfoHandler_(self, event)
end

function ZMZTableView:queDingHandler_()
    display.getRunningScene():continueTask()
    self.queDing_:hide()
end

function ZMZTableView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/nxlmz/tableView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ZMZTableView:showReady(event)
    self.kaiShi_:show()
end

function ZMZTableView:kaiShiHandler_(event)
    self.kaiShi_:hide()
    dataCenter:sendOverSocket(COMMANDS.ZMZ_READY)
end

function ZMZTableView:yaoQingHandler_(event)
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
    display.getRunningScene():shareWeiXin(title, description, 0,callback)
end

function ZMZTableView:getGameInfo_()
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

function ZMZTableView:chaKanHandler_()
    self.chaKan_:hide()
    self.jiXv_:hide()
    display.getRunningScene():showRoundOver()
end

function ZMZTableView:jiXvHandler_()
    display.getRunningScene():continueTask()
    dataCenter:sendOverSocket(COMMANDS.ZMZ_READY)
    self.chaKan_:hide()
    self.jiXv_:hide()
end

function ZMZTableView:wanFaHandler_()
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_FHLMZ,date)
end

function ZMZTableView:tuoguanHandler_(item)
    local isSelect = item:isSelected()
    self:showTGAnim(isSelect)
    dataCenter:sendOverSocket(COMMANDS.ZMZ_TUO_GUAN,{isTuoGuan = isSelect})
    self.table_:setTuoGuan(isSelect)
end

function ZMZTableView:showTGAnim(isShow)
    if isShow then
        self.tgIndex = 1
    end
    self.tgFontBg_:setVisible(isShow)
    self.tgFont_:setVisible(isShow)
end

function ZMZTableView:initTGAnim()
            -- {type = TYPES.SPRITE, var = "tgFontBg_", filename = "res/images/majiang/game/tgfont/bg.png", px = 0.5, py = 0.25},
--         {type = TYPES.SPRITE, var = "tgFont_", filename = "res/images/majiang/game/tgfont/1.png", px = 0.5, py = 0.25},

    self.tgFontBg_ = display.newSprite("res/images/majiang/game/tgfont/bg.png"):addTo(self.csbNode_)
    self.tgFont_ = display.newSprite("res/images/majiang/game/tgfont/1.png"):addTo(self.csbNode_)
    self.tgIndex = 1
    local sequence =
        transition.sequence(
        {
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self.tgIndex = self.tgIndex + 1
                    if self.tgIndex > 3 then
                        self.tgIndex = 1
                    end
                    local frameName = string.format("res/images/majiang/game/tgfont/%d.png", self.tgIndex)
                    local texture = cc.Director:getInstance():getTextureCache():addImage(frameName)
                    self.tgFont_:setTexture(texture)
                end
            )
        }
    )
    self.tgFont_:runAction(cc.RepeatForever:create(sequence))
    self.tgFontBg_:hide()
    self.tgFont_:hide()
end

return ZMZTableView 
