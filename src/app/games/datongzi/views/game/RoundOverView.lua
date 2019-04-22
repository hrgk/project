local BaseLayer = import("app.views.BaseView")
local BaseAlgorithm = require("app.games.datongzi.utils.BaseAlgorithm")
local TaskQueue = require("app.controllers.TaskQueue")
-- local RoundOverView = class("RoundOverView", BaseLayer)
local RoundOverView = class("RoundOverView", function()
    return display.newColorLayer(cc.c4b(0,0,0,125))
end)

local TIQIANJIESHU_TOUXIANG = 1
local TIQIANJIESHU_JIESAN = 2

local csbPath =  "views/games/datongzi/roundOver/roundOverView.csb"
function RoundOverView:ctor(params, isGameOver)
    -- dump(params,"pargs",10)
    self.csbNode = cc.uiloader:load(csbPath)
    self.csbNode:setAnchorPoint(cc.p(0, 0))
    self.csbNode:setPosition(display.cx, display.cy)
    self:addChild(self.csbNode, 1000)
    self:initButtonEvents_()
    --创建底牌
    local SmallPokerView = import("app.views.game.SmallPokerView")
    -- local PokerView = require("app.views.game.PokerView")
    local spaceX = 30
    local startX = 90
    local startY = 50
    local playerCount = display:getRunningScene():getTable():getMaxPlayer()
    for i=1,math.min(#params.cards, 66) do
        local poker = SmallPokerView.new(params.cards[i])
        -- local poker = PokerView.new(params.cards[i])
        :addTo(UIHelp.seekNodeByNameEx(self.csbNode, "paiKu_"))
        -- poker:fanPai()
        -- poker:setScale(0.4)
        if playerCount == 3 then
            poker:setPosition(cc.p(startX+(i-1)*spaceX,startY - 10))
        elseif playerCount == 2 then
            UIHelp.seekNodeByNameEx(self.csbNode, "paiKu_"):setPositionY(-180)
            if i <= 33 then
                poker:setPosition(cc.p(startX+(i-1)*spaceX,startY+35))
            else
                poker:setPosition(cc.p(startX+(i-34)*spaceX,startY-35))
            end
        end
    end
    --创建item
    local isLiangRen = false
    if #params.seats == 2 then
        isLiangRen = true
    end
    for i,v in ipairs(params.seats) do
        v.isLiangRen = isLiangRen
        local overItem = require("app.games.datongzi.views.game.RoundOverItemView").new(v)
        :addTo(UIHelp.seekNodeByNameEx(self.csbNode, "bg_2"))
        overItem:setAnchorPoint(cc.p(0,1))
        overItem:setPosition(cc.p(-2,310 - (i-1)*150))
    end
    local playerTable = display:getRunningScene():getTable()
    playerTable:setRoundId(params.seq)
end

function RoundOverView:initButtonEvents_()
    local buttonContinue_= UIHelp.seekNodeByNameEx(self.csbNode, "continueBtn_")
    UIHelp.addTouchEventListenerToBtnWithScale(buttonContinue_, function() self:onContinueClicked_() end)
    local buttonClose_ = UIHelp.seekNodeByNameEx(self.csbNode, "closeBtn_")
    UIHelp.addTouchEventListenerToBtnWithScale(buttonClose_, function() self:onContinueClicked_() end)
    buttonContinue_:hide()
    buttonClose_:hide()
end

function RoundOverView:initEvents_()

end

function RoundOverView:endInMiddleHandler_()
    self.liuJuTtitle_:show()
    self.liuJuTtitle_:zorder(100)
end

function RoundOverView:setRoomLabel_(params)
    local tableId = display.getRunningScene():getTable():getTid()
    self.tableIdLabel_:setString(string.format("房间号：%d", tableId))
end

function RoundOverView:setRoundInfo_(currRound, totalRound)
    self.roundInfo_:setString("局数：" .. currRound .. "/" .. totalRound)
end

function RoundOverView:setTimeLable_(params)
    local overTime = "结束时间："
    if params.finishTime then
        overTime = overTime .. params.finishTime
    else
        overTime = overTime .. os.date("%Y-%m-%d %H:%M:%S")
    end
    self.timeLabel_:setString(overTime)
end

function RoundOverView:createRoundOverItem_(params, zhuangfen, xianfen, isGameOver)
    local maxX = 0
    for i,v in ipairs(checktable(params.seats)) do
        local index = i
        if v.score > 0 then
            v.isWin_ = true
            if v.seatID == dataCenter:getHostPlayer():getSeatID() then
                gameAudio.playSound("sounds/common/shengli.mp3")
                self.win_:show()
                self.lose_:hide()
            end
        else
            v.isWin_ = false
            if v.seatID == dataCenter:getHostPlayer():getSeatID() then
                gameAudio.playSound("sounds/common/shibai.mp3")
                self.win_:hide()
                self.lose_:show()
            end
        end
        v.isTiQianJieSan = self.isTiQianJieSan_
        v.finishType = params.finishType
        v.isGameOver = isGameOver
        local showData = params.seats[v.seatID]
        local scale = display.height / DESIGN_HEIGHT
        local y = (125 * index + 120) * scale
        local item = app:createConcreteView("game.RoundOverItemView", v, showData):addTo(self.itemContent_):pos(display.cx, y)
        -- item:scale(scale)
        table.insert(self.items_, item)
        -- maxX = math.max(item:getMaJiangX(), maxX)
    end
end

function RoundOverView:setItemPosBySelf_(params)
    local index = 3
    local player  = nil
    for i,v in ipairs(params.seats) do
        if v.isHost then
            player = v
            v.index = 3
            break
        end
    end
    for _,p in ipairs(params.seats) do
        if p.seatID ~= params.hostSeatID then
            if player.isZhuang then
                index = index - 1
                p.index = index
            else
                if p.isZhuang then
                    p.index = 1
                else
                    p.index = 2
                end
            end
        end
    end
end

function RoundOverView:setCloseHandler(callback)
    self.closeHandler_ = callback
end

function RoundOverView:setIsGameOver(isGameOver)
    if display:getRunningScene():getTable():getIsDismiss() then
        isGameOver = true
    end
    -- self.buttonGameOver_:setVisible(isGameOver)
    self.buttonContinue_:setVisible(not isGameOver)
end

function RoundOverView:onContinueClicked_()
    print("RoundOverView:onContinueClicked_()")
    dataCenter:sendOverSocket(COMMANDS.DTZ_READY)
    self:onClose_()
    display.getRunningScene():getTable():setFirstHand(false)
    display.getRunningScene():finishRound()
end

function RoundOverView:onGameOverClicked_(event)
    self:onClose_()
end

function RoundOverView:onClose_()
    TaskQueue.continue()
    if self.closeHandler_ then
        self.closeHandler_()
    end
    self:removeFromParent(true)
end

function RoundOverView:onShareClicked_(event)
    -- display.captureScreen(function (bSuc, filePath)
    --     --bSuc 截屏是否成功
    --     --filePath 文件保存所在的绝对路径
    --     if not bSuc then
    --         return
    --     end
    --     local params = {
    --         type = "img",
    --         tagName = "",
    --         title = "雅阁打筒子",
    --         description = "",
    --         imagePath = filePath,
    --         url = "",
    --         inScene = 0,
    --         smallWidth = 128,
    --         smallHeight= 72,
    --         bigWidth = 1280,
    --         bigHeight = 720
    --     }
    --     gailun.native.shareWeChat(params)
    -- end, cc.FileUtils:getInstance():getWritablePath() .. "/screen.jpg")
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("打筒子","",callback,display.getRunningScene():getTable():getTid())
end

return RoundOverView
