local TableView = import("app.views.game.TableView")
local NNTableView = class("NNTableView", TableView)
local PlayController = import("app.games.dao13.views.game.PlayController")
local YZController = import("app.games.dao13.views.game.YZController")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local NNPlayerView = import(".NNPlayerView")
local GameTipMsg = import(".GameTipMsg")
local VoiceChatButton = import("app.views.game.VoiceChatButton")
local VoiceRecordView = import("app.views.game.VoiceRecordView")
local PokerView = import("app.views.game.PokerView")
local HOST = 1
local LEFT_UP = 4
local RIGHT_UP = 3
local RIGHT_DOWN = 2
local LEFT_DOWN = 5
function NNTableView:ctor(model, totalSeat)
    self.totalSeat = totalSeat or 4
    NNTableView.super.ctor(self, model)
    self.setting_:setCMD(COMMANDS.DAO13_LEAVE_ROOM, COMMANDS.DAO13_OWNER_DISMISS, GAME_13DAO)
    self.zhuang_:hide()
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
    :addEventListener(self.table_.SHOW_ROUND_ANI, handler(self, self.showRoundAni_))
end

function NNTableView:showAnimations(data, parent, ratation,needFan)
    local manager = ccs.ArmatureDataManager:getInstance()
    local function animationPlayOver(arm, eventType, movmentID)
        if data.isLoop then return end
        manager:removeArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation ..".ExportJson")
        parent:removeChild(arm)
    end
    manager:addArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation .. ".ExportJson")
    local armature = ccs.Armature:create(data.animation)
    armature:setAnchorPoint(cc.p(0.5, 0.5))
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(animationPlayOver)
    armature:setPosition(cc.p(data.x, data.y))
    if needFan then
        print("XXXXXXXXXXXXXXXXX1")
        armature:setScaleX(-1)
    end
    if ratation then
        if needFan then
            print("XXXXXXXXXXXXXXXXX2222222222")
            armature:setRotation(ratation+180)
        else
            armature:setRotation(ratation)
        end
    end
    parent:addChild(armature)
    if data.sound ~= "" then
        parent:performWithDelay(function()
            gameAudio.playSound(data.sound)
        end, data.soundDelaySeconds)
    end

    return armature
end

function NNTableView:getAngleByPos(p1,p2)
    local p = {}
    p.x = p2.x - p1.x
    p.y = p2.y - p1.y
    local r = math.atan2(p.y,p.x)*180/math.pi
    return -r
end

function NNTableView:getDaoCardPos_(index,type)
    local player = self["player" .. index .. "_"]
    local x, y = player:getPosition()
    print("index",index)
    if type == 2 then
        if index == 1 then
            x = x + 600
        elseif index == 3 or self.totalSeat == 2 then
            x = x - 250
            y = y - 100
        elseif index == 2 then
            x = x - 150
            y = y - 100
        elseif index == 4 then
            x = x + 200
            y = y - 100
        end
    elseif type == 1 then
        if index == 1 then
            x = x + 550
            y = y + 50
        elseif index == 3 or self.totalSeat == 2 then
            x = x - 250
            y = y - 100
        elseif index == 2 then
            x = x - 150
            y = y - 100
        elseif index == 4 then
            x = x + 250
            y = y - 50
        end
    else
        if index == 1 then
            x = x + 580
            y = y + 100
        elseif index == 3 or self.totalSeat == 2 then
            x = x - 270
            y = y 
        elseif index == 2 then
            x = x - 150+20
            y = y 
        elseif index == 4 then
            x = x + 250-20
            y = y
        end
    end
    return x,y
end

function NNTableView:showRoundAni_(event)
    if event.info.type == 1 then
        local fromData = FaceAnimationsData.getCocosAnimation(33)
        fromData.x,fromData.y = self:getDaoCardPos_(event.info.fromIndex,1)
        local needFan = false
        local toInfo = event.info.toIndex
        if (event.info.fromIndex == 1 or event.info.fromIndex == 3) and toInfo[1] == 4 then
            needFan = true
        elseif event.info.fromIndex == 2 then
            needFan = true
        end
        local toData = FaceAnimationsData.getCocosAnimation(34)
        toData.x,toData.y = self:getDaoCardPos_(toInfo[1],2) 
        self:showAnimations(fromData, self.csbNode_,self:getAngleByPos(fromData,toData),needFan) 
        for i = 1, #toInfo do
            local toData = FaceAnimationsData.getCocosAnimation(34)
            toData.x,toData.y = self:getDaoCardPos_(toInfo[i],2) 
            self:showAnimations(toData, self.csbNode_)
        end
    elseif event.info.type == 2 then
        local fromData = FaceAnimationsData.getCocosAnimation(35)
        fromData.x,fromData.y = self:getDaoCardPos_(event.info.fromIndex,3)
        self:showAnimations(fromData, self.csbNode_)   
    elseif event.info.type == 3 then
        local fromData = FaceAnimationsData.getCocosAnimation(36)
        fromData.x,fromData.y = self:getDaoCardPos_(event.info.fromIndex,1)
        self:showAnimations(fromData, self.csbNode_)   
    end
end

function NNTableView:showReady()
    self.ready_:show()
end

function NNTableView:onGameStart_(event)
    self.inGame_ = true
    self.yaoQing_:hide()
end

function NNTableView:showGameTips_(event)
    self.gameTipsController_:showMsg(event.tipsType)
end

function NNTableView:showGameStartBtn_(event)
  
end

function NNTableView:onGameStart_(event)
    NNTableView.super.onGameStart_(self, event)
    self.ready_:hide()
    self.yaoQing_:hide()
end

function NNTableView:onRoundStart_(event)
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
    self.ready_:hide()
    gameAudio.playSound("sounds/niuniu/sound_gamestart.mp3")
end

function NNTableView:onTableInfoHandler_(event)
    NNTableView.super.onTableInfoHandler_(self, event)
    local titlePath = "res/images/dao13/logo.png"
    local texture = cc.Director:getInstance():getTextureCache():addImage(titlePath)
    self.tilte_:setTexture(texture)
end

function NNTableView:initPlayController_()
    if self.caozuo_ then
        self.playController_ = PlayController.new(self.table_)
        self.playController_:setNode(self.caozuo_)
        self.caozuo_:hide()
    end
    self:initYZController_()
end

function NNTableView:initYZController_()
    if self.yazhu_ then
        self.yzController_ = YZController.new(self.table_)
        self.yzController_:setNode(self.yazhu_)
        self.yazhu_:hide()
    end
end

function NNTableView:hideYZ()
    self.yazhu_:hide()
end

function NNTableView:showYZ()
    self.yazhu_:show()
end

function NNTableView:showCaoZu(date)
    dump(date,"datedate")
    self.caozuo_:show()
    self.playController_:initHandCards_(date)
end

function NNTableView:hideCaoZu()
    self.playController_:clearHandCards_()
end

function NNTableView:onFlowHandler_(event)
    -- 0,1,2,3 4 无状态   待叫分  待开牌   待选择庄  翻牌
    if event.flow == 0 then
       
    elseif event.flow == 1 then
      
    elseif event.flow == 2 then
       
    elseif event.flow == 3 then
      
    elseif event.flow == 4 then
    elseif event.flow == -1 then
       
    end
end

function NNTableView:onDealerHandler_(event)
    local px = -30
    local py = 30
    local x, y = self.players_[event.index]:getPos()
    if index == RIGHT_DOWN or index == RIGHT_UP then
        px = -px
    end
    local function showZhuang()
        self.zhuang_:show()
        transition.moveTo(self.zhuang_, {x = x + px, y = y + py, time = 0.3})
        local seq = transition.sequence({
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(function ()
                if event.callBack then
                    event.callBack()
                end
            end)
        })
        self:runAction(seq)
    end
    if event.hideAni then
        self.zhuang_:show()
        self.zhuang_:setPosition(x + px,y + py)
        if event.callBack then
            event.callBack()
        end
    else
        if event.randomPoker and event.randomPoker > 0 then
            local poker = PokerView.new(event.randomPoker):addTo(self.csbNode_):pos(0, 0)
            poker:fanPai()
            local moveBy = cc.MoveBy:create(0.2, cc.p(0, 10))
            local seq = transition.sequence({
                moveBy,
                moveBy:reverse(),
                moveBy,
                moveBy:reverse(),
                cc.DelayTime:create(0.2),
                cc.FadeOut:create(0.3),
                cc.RemoveSelf:create(),
                cc.CallFunc:create(function ()
                    showZhuang()
                end)
            })
            poker:runAction(seq)
        else
            showZhuang()
        end
    end
end

function NNTableView:initPlayerSeats()
    self.players_ = {}
    for i=1,4 do
        local playerView = NNPlayerView.new(i,self.totalSeat)
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
    print("views/games/d13/tableView" .. self.totalSeat .. ".csb")
    self.csbNode_ = cc.uiloader:load("views/games/d13/tableView" .. self.totalSeat .. ".csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function NNTableView:liangPaiHandler_()
    dataCenter:sendOverSocket(COMMANDS.DAO13_KAI_PAI)
end

function NNTableView:readyHandler_()
    dataCenter:sendOverSocket(COMMANDS.DAO13_READY)
    self.ready_:hide()
    display.getRunningScene().tableController_:clearAll()
end

function NNTableView:startGameHandler_()
    dataCenter:sendOverSocket(COMMANDS.DAO13_GAME_START)
    self.startGame_:hide()
    self.ready_:hide()
    self.yaoQing_:hide()
end

function NNTableView:yaoQingHandler_()
    local index = math.random(1, 7)
    local title = "激情十三道" .. FENXIANGNEIRONG[index]
    local msg = "激情十三道，快快来战！"
    msg = msg .. "房间号：".. self.table_:getTid()..","
    msg = msg .. self.table_:getRuleDetails().playerCount.."人,"
    msg = msg .. self.table_:getTotalRound().."局,"
    local function callback()
    end
    display.getRunningScene():shareWeiXin(title,msg,0,callback)
end

function NNTableView:wanFaHandler_()
    local date = display.getRunningScene():getTable():getConfigData()
    dump(date,"wanFaHandler_")
    display.getRunningScene():initWanFa(GAME_13DAO,date)
end

function NNTableView:onRoundOver_(event)
    self.yaoQing_:hide()
    if self.naoZhong_ then
        self.naoZhong_:hide()
    end
end

function NNTableView:sitDownHide()

end

function NNTableView:sitDownShow()

end

function NNTableView:sitdownHandler_()
    
end

function NNTableView:fanPaiHandler_()
    dataCenter:sendOverSocket(COMMANDS.DAO13_PLAYER_FAN_PAI)
end

function NNTableView:cuoPaiHandler_()
    dataCenter:sendOverSocket(COMMANDS.DAO13_PLAYER_FAN_PAI)
    display.getRunningScene().isCuoPai = true
end

function NNTableView:showMPTip(isShow)
    self.mp_:setVisible(isShow)
end

return NNTableView 
