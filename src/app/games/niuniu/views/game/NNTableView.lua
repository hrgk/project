local TableView = import("app.views.game.TableView")
local NNTableView = class("NNTableView", TableView)
local PlayController = import("app.games.niuniu.views.game.PlayController")
local NNPlayerView = import(".NNPlayerView")
local GameTipMsg = import(".GameTipMsg")
local VoiceChatButton = import("app.views.game.VoiceChatButton")
local VoiceRecordView = import("app.views.game.VoiceRecordView")
local HOST = 1
local LEFT_UP = 4
local RIGHT_UP = 3
local RIGHT_DOWN = 2
local LEFT_DOWN = 5
function NNTableView:ctor(model, totalSeat)
    self.totalSeat = totalSeat or 10
    NNTableView.super.ctor(self, model)
    self.setting_:setCMD(COMMANDS.NIUNIU_LEAVE_ROOM, COMMANDS.NIUNIU_OWNER_DISMISS, GAME_BCNIUNIU)
    self.liangPai_:hide()
    self.zhuang_:hide()
    self.fanPai_:hide()
    self.ready_:hide()
    self.sitdown_:hide()
    self.startGame_:hide()
    self.cuoPai_:hide()
    self:initGameTips_()
end

function NNTableView:isShowJieSanOrTuiChu_()
    NNTableView.super.isShowJieSanOrTuiChu_(self)
    self.ready_:hide()
end

function NNTableView:initGameTips_()
    self.gameTipsController_ = GameTipMsg.new()
    self.gameTipsController_:setNode(self.gameTips_)
end

function NNTableView:initEventListeners()
    NNTableView.super.initEventListeners(self)
    cc.EventProxy.new(self.table_, self.csbNode_, true)
    :addEventListener(self.table_.DEALER_FOUND, handler(self, self.onDealerHandler_))
    :addEventListener(self.table_.FLOW, handler(self, self.onFlowHandler_))
    :addEventListener(self.table_.SHOU_GAME_START_BTN, handler(self, self.showGameStartBtn_))
    :addEventListener(self.table_.GAME_TIPS_EVENT, handler(self, self.showGameTips_))
end

-- function NNTableView:onGameStart_(event)
--     self.inGame_ = true
--     self.yaoQing_:hide()
--     if not display.getRunningScene().tableController_:isStanding() then
--         self.sitdown_:hide()
--     end
-- end

function NNTableView:showGameTips_(event)
    self.gameTipsController_:showMsg(event.tipsType)
end

function NNTableView:showGameStartBtn_(event)
    self.startGame_:setVisible(event.isShow)
    self.startGame_:setBright(event.isShow)
    self.startGame_:setEnabled(event.isShow)
end

function NNTableView:onGameStart_(event)
    NNTableView.super.onGameStart_(self, event)
    self.startGame_:hide()
    self.ready_:hide()
    if not display.getRunningScene().tableController_:isStanding() then
        self.sitdown_:hide()
    end
    self.yaoQing_:hide()
end

function NNTableView:onRoundStart_(event)
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
    self.caozuo_:hide()
    if self.liangPai_ then
        self.liangPai_:hide()
    end
    self.startGame_:hide()
    self.ready_:hide()
    gameAudio.playSound("sounds/niuniu/sound_gamestart.mp3")
end

function NNTableView:onTableInfoHandler_(event)
    NNTableView.super.onTableInfoHandler_(self, event)
    local ruleType = self.table_:getConfig().ruleType
    local titlePath = "res/images/niuniu/niuniu_tilte.png"
    if ruleType == 6 then
        titlePath = "res/images/niuniu/niuniu_bc_tilte.png"
    end
    local texture = cc.Director:getInstance():getTextureCache():addImage(titlePath)
    self.tilte_:setTexture(texture)
end

function NNTableView:initPlayController_()
    if self.caozuo_ then
        self.playController_ = PlayController.new(self.table_)
        self.playController_:setNode(self.caozuo_)
        self.caozuo_:hide()
    end
end

function NNTableView:onFlowHandler_(event)
    -- 0,1,2,3 4 无状态   待叫分  待开牌   待选择庄  翻牌
    if event.flow == 0 then
        self.caozuo_:hide()
        self.liangPai_:hide()
        self.ready_:hide()
        self.startGame_:hide()
    elseif event.flow == 1 then
        self.caozuo_:show()
        self.liangPai_:hide()
        self.playController_:showFlow(event.flow, event.callList)
    elseif event.flow == 2 then
        self.caozuo_:hide()
        if not display.getRunningScene().tableController_:isStanding() then
            self.liangPai_:show()
        end
        self.fanPai_:hide()
    elseif event.flow == 3 then
        self.playController_:showFlow(event.flow)
        self.liangPai_:hide()
        self.ready_:hide()
        self.startGame_:hide()
        self.fanPai_:hide()
        self.cuoPai_:hide()
    elseif event.flow == 4 then
        self.fanPai_:show()
        self.caozuo_:hide()
        if self.table_:getRuleDetails().prohibitFanCard and self.table_:getRuleDetails().prohibitFanCard == 1 then
            self.cuoPai_:hide()
        else
            self.cuoPai_:show()
        end
    elseif event.flow == -1 then
        self.caozuo_:hide()
        self.liangPai_:hide()
        self.fanPai_:hide()
        self.cuoPai_:hide()
    end

    print("是否为观战模式", display.getRunningScene().tableController_:isStanding(), event.flow)
    if display.getRunningScene().tableController_:isStanding() then
        self.fanPai_:hide()
        self.ready_:hide()
    end
end

function NNTableView:onDealerHandler_(event)
    self.zhuang_:show()
    local px = -30
    local py = 30
    local x, y = self.players_[event.index]:getPos()
    if index == RIGHT_DOWN or index == RIGHT_UP then
        px = -px
    end
    transition.moveTo(self.zhuang_, {x = x + px, y = y + py, time = 0.5})
end

function NNTableView:initPlayerSeats()
    self.players_ = {}
    for i=1,self.totalSeat do
        local playerView = NNPlayerView.new(i)
        local player = "player" .. i .."_"
        if self[player] then
            playerView:setNode(self[player])
            playerView:setBombLayer(self.csbNode_)
            self.players_[i] = playerView
            self[player]:hide()
        end
    end
end

function NNTableView:loaderCsb()
    print("views/games/niuniu/tableView" .. self.totalSeat .. ".csb")
    self.csbNode_ = cc.uiloader:load("views/games/niuniu/tableView" .. self.totalSeat .. ".csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function NNTableView:liangPaiHandler_()
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_KAI_PAI)
end

function NNTableView:readyHandler_()
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_READY)
    self.ready_:hide()
    local x,y = self.liangPai_:getPosition()
    self.ready_:setPosition(x, y)
end

function NNTableView:startGameHandler_()
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_GAME_START)
    self.startGame_:hide()
    self.ready_:hide()
    self.yaoQing_:hide()
end

function NNTableView:yaoQingHandler_()
    local index = math.random(1, 7)
    local title = "激情拼十分" .. FENXIANGNEIRONG[index]
    local msg = "激情拼十分，快快来战！"
    msg = msg .. "房间号：".. self.table_:getTid()..","
    msg = msg .. self.table_:getRuleDetails().playerCount.."人,"
    msg = msg .. self.table_:getTotalRound().."局,"
    local function callback()
    end
    display.getRunningScene():shareWeiXin(title,msg,0,callback)
end

function NNTableView:wanFaHandler_()
    local date = display.getRunningScene():getTable():getConfigData()
    display.getRunningScene():initWanFa(GAME_BCNIUNIU,date)
end

function NNTableView:onRoundOver_(event)
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
    self.caozuo_:hide()
    if self.liangPai_ then
        self.liangPai_:hide()
    end

    local hostPlayer = display.getRunningScene().tableController_:getHostPlayer()
    if not hostPlayer.isReady_ then
        self.ready_:show()
    end

    if display.getRunningScene().tableController_:isStanding() then
        self.ready_:hide()
        self.sitdown_:show()
    end
end

function NNTableView:sitDownHide()
    if display.getRunningScene().tableController_:isStanding() and self.table_:getRuleDetails().prohibitEnter == 1 then
        self.sitdown_:hide()
    end
end

function NNTableView:sitDownShow()
    self.sitdown_:show()
end

function NNTableView:sitdownHandler_()
    self.sitdown_:hide()
    if display.getRunningScene().tableController_:isStanding() then
        if self.table_:getRuleDetails().playerCount <= display.getRunningScene().tableController_:getUserCount() then
            self.sitdown_:show()
            app:showTips("人数已满，无法坐下")
        else
            display.getRunningScene().tableController_:clearSeats()
            display.getRunningScene().tableController_:showNewPos() 
            dataCenter:sendOverSocket(COMMANDS.NIUNIU_READY)
        end
    else
        dataCenter:sendOverSocket(COMMANDS.NIUNIU_READY)
    end
    
end

function NNTableView:fanPaiHandler_()
    -- self.liangPai_:show()
    self.fanPai_:hide()
    self.cuoPai_:hide()
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_PLAYER_FAN_PAI)
end

function NNTableView:cuoPaiHandler_()
    self.fanPai_:hide()
    self.cuoPai_:hide()
    dataCenter:sendOverSocket(COMMANDS.NIUNIU_PLAYER_FAN_PAI)
    display.getRunningScene().isCuoPai = true
end

return NNTableView 
