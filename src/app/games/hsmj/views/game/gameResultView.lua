local BaseAlgorithm = require("app.games.hsmj.utils.BaseAlgorithm")
local BaseGameResult = import("app.views.BaseGameResult")
local GameResultView = class("GameResultView", BaseGameResult)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "spriteWin_", filename = "res/images/paohuzi/roundOver/benJuJieSuan.png", px = 0.5, py = 0.93, ap = {0.5, 0.5}},
         {type = TYPES.LABEL, var  = "tableIdLabel_", ap = {1, 0.5}, x = display.width - 10, y = 70, options={text="", 
        size = 16, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var  = "infoLabel_", ap = {1, 0.5}, x = display.width - 10, y = 50, options={text="", 
        size = 16, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var  = "timeLabel_", ap = {1, 0.5}, x = display.width - 10, y = 30, options={text="",size = 16,
         font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var = "labelRoomInfo_", options = {text="", font=DEFAULT_FONT, size=20, color=cc.c3b(255, 255, 255)}, x = 10, y = display.height - 10, ap = {0, 1}},
        {type = TYPES.LABEL, var = "labelTableRules_", options = {text="", font=DEFAULT_FONT, size=20, color=cc.c3b(255, 255, 255)}, x = 10, y = display.height - 10, ap = {0, 1}},
        }
}

function GameResultView:ctor(params, birds, isGameOver)
    display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    
    birds = {}
    if params.winInfo and params.winInfo[1]then
        birds =checktable(params.winInfo[1].birdList)
    end
    
    GameResultView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    local winner = clone(params.winner)
    winner = checktable(winner)
    local isWin = false
    for i=1,#winner do
        if winner[i] == params.hostSeatID then
            isWin = true
            break
        end
    end


    local isHuangZhuang = (params.isHuangZhuang > 0)

    local maxX = 0
    local items = {}
    local function comp(v1, v2)
        return v1.score > v2.score
    end
    table.sort(params.seats, comp)

    local action = MJ_ACTIONS.CHI_HU
    -- qiangGangHu = 0,
 --    zhuangXian = 2,
 --    zhongNiao = 3,
 --    ziMo = 1,
 --    dianPao = 0,
    for i, v in ipairs(checktable(params.seats)) do
        if v.scoreFrom then
            if v.scoreFrom.ziMo and v.scoreFrom.ziMo > 0 then
                action = MJ_ACTIONS.ZI_MO
            elseif v.scoreFrom.qiangGangHu and v.scoreFrom.qiangGangHu > 0  then
                action = MJ_ACTIONS.QIANG_GANG_HU
             elseif v.scoreFrom.jiePao and v.scoreFrom.jiePao > 0  then
                action = MJ_ACTIONS.CHI_HU
            end
        end
    end

    for i,v in ipairs(checktable(params.seats)) do
        if v.seatID == params.hostSeatID then
            -- isWin = (v.score > 0)
        end
        v.isPrevGenZhuang = params.isPrevGenZhuang
        v.isPrevHuangZhuang = params.isPrevHuangZhuang
        local showData = params.seats[i]
        showData.winInfo = params.winInfo or {}
        showData.action = action
        showData.winner = winner
        showData.birds = birds
        showData.oneBrid = params.oneBrid
        showData.tableController_ = params.tableController_
        local item = app:createConcreteView("game.GameResultItemView", v, showData):addTo(self):pos(display.cx+10, 135 * (5 - i) - display.cy + 125)
        table.insert(items, item)
        maxX = math.max(item:getMaJiangX(), maxX)
        item:setScale(0.9)
    end
    -- for _,v in ipairs(items) do
    --  v:adjustByX(maxX)
    -- end

    -- self.spriteWin_:setVisible(not isHuangZhuang and isWin)
    -- self.spriteLose_:setVisible(not isHuangZhuang and not isWin)
    -- self.spriteWinLose_:setVisible(isHuangZhuang)

    -- if params.finishType == 1 then
    --     self.spriteWin_:setVisible(false)
    --     self.spriteLose_:setVisible(false)
    --     self.spriteWinLose_:setVisible(true)
    -- end

    if isWin then
        gameAudio.playSound("sounds/common/sound_win.mp3")
    else
        gameAudio.playSound("sounds/common/sound_lose.mp3")
    end

    -- self:showBirds_(birds)
    self:setIsGameOver(not params.hasNextRound)

    -- self.labelRoomInfo_:setString(params.tableController_:getRoomInfo())
    self.labelTableRules_:setString(params.tableController_:makeRuleString(" "))
    

    local tableId = display.getRunningScene():getTable():getTid()
    self.tableIdLabel_:setString(string.format("房号: %d", tableId))
    self.infoLabel_:setString(params.ruleString)
    self.timeLabel_:setString(params.finishTime or os.date("%Y-%m-%d %H:%M:%S"))

end

function GameResultView:setCloseHandler(callback)
    self.closeHandler_ = callback
end

function GameResultView:setIsGameOver(isGameOver)

end

-- birds = {11, 24, 33, 21, 32, 31, 33, 22}
local isZiMo = false
local isSortBird = true
local isTongPao = false
local jiePaoIndex = {3, 1}
local fangPaoIndex = 4

function GameResultView:showBirds_(birds)
    if not birds or #birds < 1 then
        -- self.labelBird_:hide()
        return
    end
    -- self.labelBird_:hide()
    local space = 37
    local y = 0.05 * display.height
    isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex = BaseAlgorithm.getZhongNiaoParams(params.tableController_:getHuInfo())
    for i,v in ipairs(birds) do
        local x = 100 + i * space
        local maJiang = app:createConcreteView("MaJiangView", v, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self):pos(x, y)
        maJiang:scale(0.7)
        local ret, birdShunXu = BaseAlgorithm.isBird(bird, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex)
        if ret then
            -- maJiang:focusOn():slideBy(4)
            maJiang:focusOn()
        else
            -- maJiang:focusOff():slideBy(-4)
            maJiang:focusOff()
        end
    end
end

function GameResultView:onGameOverClicked_(event)
    self:close()
end

function GameResultView:onShareClicked_(event)
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        local params = {
            type = "img",
            tagName = "",
            title = "雅阁湖南麻将",
            description = "",
            imagePath = filePath,
            url = "",
            inScene = 0,
            smallWidth = 128,
            smallHeight= 72,
            bigWidth = 1280,
            bigHeight = 720
        }
        gailun.native.shareWeChat(params)
    end, cc.FileUtils:getInstance():getWritablePath() .. "/screen.jpg")
end

function GameResultView:close()
    self:removeFromParent()
end

function GameResultView:onExit()
    if self.closeHandler_ then
        self.closeHandler_()
    end
end

return GameResultView
