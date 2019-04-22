local BaseView = import("app.views.BaseView")
local RoundOverMingTangItem = import("app.games.yzchz.views.game.RoundOverMingTangItem")
local RoundOverKan = import("app.games.yzchz.views.game.RoundOverKan")
local PaperCardGroup = require("app.games.yzchz.utils.PaperCardGroup")
local AvatarView  = import("app.views.AvatarView")
local TaskQueue = require("app.controllers.TaskQueue")

local CDPHZRoundOver = class("CDPHZRoundOver", BaseView)

local fanFnt = {type = gailun.TYPES.BM_FONT_LABEL, options={text="0",UILabelType = 1,font = "res/images/paohuzi/roundOver/pjx.fnt",} , ap = {0.5, 0.5}}


function CDPHZRoundOver:ctor(data)
    dump(data,"CDPHZRoundOver:ctor")
    CDPHZRoundOver.super.ctor(self)
    self.totalFan_ = 0
    -- self:showAgainOrOver_(data.hasNextRound)
    if data.finishType == 1 then
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/hBack.png')
        self.winbg_:setTexture(texture)
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/jieSanTitle.png')
        self.winTitle_:setTexture(texture)
        self.benjuHuXi_:hide()
        self.fanShu_:hide()
        self.tunShu_:hide()
        self.jiFen_:hide()
        self.flagDiPai_:hide()
        self.xingType_:hide()
        local sprite = display.newSprite("res/images/paohuzi/roundOver/jieSanWord.png"):addTo(self.csbNode_)
        return
    end
    if data.isHuangZhuang == 1 then
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/hBack.png')
        self.winbg_:setTexture(texture)
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/hTitle.png')
        self.winTitle_:setTexture(texture)
        self.benjuHuXi_:hide()
        self.fanShu_:hide()
        self.tunShu_:hide()
        self.jiFen_:hide()
        self.flagDiPai_:hide()
        self.xingType_:hide()
        local sprite = display.newSprite("res/images/paohuzi/roundOver/huangWord.png"):addTo(self.csbNode_)
        sprite:setPosition(0,150)
        local line = display.newSprite("res/images/paohuzi/roundOver/line.png"):addTo(self.csbNode_)
        line:setScale(0.98,1)
        line:setPosition(0,-40)
        self:setHuangZhuangPlayerHead_(data.seats,data)
        return
    end
    self:initBg_(data.winType)
    self:initMingTang_(data.winInfo, data.winType)
    self.winner_ = data.seats[data.winInfo.winner]
    self:initHuPaiKan_(data.winInfo)
    self:initHaiDiCard_(data.leftCards)
    self:initLabelInfo_(data)
    self:setPlayerHead_(data.seats)
    self:initKingCard_(data)
end

function CDPHZRoundOver:setHuangZhuangPlayerHead_(list,data)
    dump(data,"datadata")
    for i,v in ipairs(list) do
        local x,y = self:calcHZHeadPos_(#list,i)
        local avatar = AvatarView.new():addTo(self.csbNode_):pos(x,y)
        avatar:showWithUrl(v.avatar)
        local txt = gailun.utf8.formatNickName(v.nickName, 6, '..')
        local name = cc.ui.UILabel.new({text = txt}):addTo(self.csbNode_):pos(x-40,y+40)
        name:setAnchorPoint(0,0.5)
        name:setColor(cc.c3b(133, 91, 51))
        local scoreLabel = cc.ui.UILabel.new({text = ""}):addTo(self.csbNode_):pos(x+35,y)
        scoreLabel:setAnchorPoint(0,0.5)
        scoreLabel:setColor(cc.c3b(133, 91, 51))
        scoreLabel:setString("王霸:" .. data.huangZhuangScore[i..""])
    end
end

function CDPHZRoundOver:setPlayerHead_(list)
    for i,v in ipairs(list) do
        local x,y = self:calcHeadPos_(#list,i)
        local avatar = AvatarView.new():addTo(self.csbNode_):pos(x,y)
        avatar:showWithUrl(v.avatar)
        local txt = gailun.utf8.formatNickName(v.nickName, 6, '..')
        local name = cc.ui.UILabel.new({text = txt}):addTo(self.csbNode_):pos(x+40,y+20)
        name:setAnchorPoint(0,0.5)
        name:setColor(cc.c3b(133, 91, 51))
        local scoreLabel = cc.ui.UILabel.new({text = v.score}):addTo(self.csbNode_):pos(x+100,y-20)
        scoreLabel:setAnchorPoint(1,0.5)
        scoreLabel:setColor(cc.c3b(133, 91, 51))
        if v.isWinner then
            local winFlag = display.newSprite("res/images/paohuzi/roundOver/shuying.png"):addTo(self.csbNode_)
            :pos(x+25,y+25)
        end
    end
end

function CDPHZRoundOver:calcHeadPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * 180 - 50
    local x = offset
    local y = -200
    return x, y, index
end

function CDPHZRoundOver:calcHZHeadPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * 280 - 50
    local x = offset
    local y = -150
    return x, y, index
end

function CDPHZRoundOver:setIsGameOver(isGameOver)
    -- self:showAgainOrOver_(not isGameOver)
end

function CDPHZRoundOver:initLabelInfo_(data)
    self.huXi_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
    self.huXi_:setAnchorPoint(0.5,0.5)
    self.huXi_:setString(data.winInfo.totalHuXi)
    self.huXi_:pos(495,214.55)
    local fan = 0
    self.fan_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
    if data.winInfo.fanList and #data.winInfo.fanList > 0 then
        for i,v in ipairs(data.winInfo.fanList) do
            fan = fan+v
        end
    else
        fan = 1
    end
    self.fan_:setAnchorPoint(0.5,0.5)
    self.fan_:pos(495,115.36)
    self.fan_:setString(fan)

    if data.winInfo.totalTun and data.winInfo.totalTun > 0 then
        self.tun_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
        self.tun_:setAnchorPoint(0.5,0.5)
        self.tun_:setString(data.winInfo.totalTun)
        self.tun_:pos(495,18.67)
    end

    self.jiFen_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
    self.jiFen_:setAnchorPoint(0.5,0.5)
    if self.winner_ then
        self.jiFen_:setString(self.winner_.score)
    end
    self.jiFen_:pos(495,-78.02)
    if data.winInfo.xingCard and data.winInfo.xingCard > 0 then
        self.xingFen_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
        self.xingFen_:setAnchorPoint(0.5,0.5)
        self.xingFen_:pos(495+10,-174.71)
        self.xingFen_:setString(data.winInfo.xingCount)
        self.xingCard_ = app:createConcreteView("PaperCardView", data.winInfo.xingCard, 3, false, nil):addTo(self.csbNode_)
        self.xingCard_:setAnchorPoint(0.5,0.5)
        self.xingCard_:pos(455+15,-174.71)
        if display.getRunningScene():getTable():getConfigData().rules.xingType == 1 then
            self.xingType_:loadTexture("res/images/paohuzi/roundOver/genx.png")
        end
    else
        self.xingType_:hide()
    end
  
end

function CDPHZRoundOver:initKingCard_(data)
    if data.winInfo.kingRealValue then
        for i = 1,#data.winInfo.kingRealValue do
            local hx = ccui.ImageView:create("res/images/paohuzi/roundOver/xia.png"):addTo(self.csbNode_)
            hx:setAnchorPoint(0.5,0.5)
            hx:pos(-205,200-(i-1)*60)
            hx:setScale(0.8)
            local card1 = app:createConcreteView("PaperCardView", data.winInfo.kingRealValue[i], 3, false, nil):addTo(self.csbNode_)
            card1:setAnchorPoint(0.5,0.5)
            card1:pos(-180+30,200-(i-1)*60)
            local card2 = app:createConcreteView("PaperCardView", 301, 3, false, nil):addTo(self.csbNode_)
            card2:setAnchorPoint(0.5,0.5)
            card2:pos(-260,200-(i-1)*60)
        end
    end
end

function CDPHZRoundOver:initHaiDiCard_(cards)
    local count = 0
    local ceng = 0
    for i,v in ipairs(cards) do
        local card = app:createConcreteView("PaperCardView", v, 3, false, nil):addTo(self.diPaiContent_)
        count = count + 1
        card:pos(30*count - 40,35+ceng*(-34))
        if i%15 == 0 then
            count = 0
            ceng = ceng + 1
        end
    end
end

function CDPHZRoundOver:initHuPaiKan_(info)
    if info.huPath == nil then
        return
    end
    local count = 0
    local huData = {}
    for i,v in ipairs(info.huPath) do
        if i == info.huCardIndex then
            huData = v
        else
            count = count + 1
            local item = RoundOverKan.new(v, false):addTo(self.kanContent_)
            item:setPosition(count*50 - 200+50,50)
        end
    end
    count = count + 1
    local item = RoundOverKan.new(huData, true):addTo(self.kanContent_)
    item:setPosition(count*50 - 200+50,50)
    item:setHuCard(info.huCard)
end

function CDPHZRoundOver:initMingTang_(info, winType)
    local items = {}
    if info.huList and #info.huList == 0 then
        local item = RoundOverMingTangItem.new(PING_HU, winType):addTo(self.fanContent_)
        item:setFan(1)
        table.insert(items, item)
    else
        for i,v in ipairs(info.huList) do
            local item = RoundOverMingTangItem.new(v, winType):addTo(self.fanContent_)
            item:setFan(info.fanList[i])
            table.insert(items, item)
        end
        local function compare(a,b)
            return a:getFanCount() > b:getFanCount() 
        end
        table.sort(items, compare)
    end
    
    local chongTun = display.getRunningScene():getTable():getConfigData().rules.baseTun
    if chongTun > 1 then
        local item = RoundOverMingTangItem.new(52, winType):addTo(self.fanContent_)
        item:chongTun(chongTun-1)
        table.insert(items, item)
    end
    for i,v in ipairs(items) do
        local x,y = self:calcMingTangPos_(#items, i)
        v:setPosition(x,y)
    end
end

function CDPHZRoundOver:calcMingTangPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * -60
    local y = offset
    local x = 0
    return x, y, index
end

function CDPHZRoundOver:showAgainOrOver_(isOver)
    -- self.gameOver_:setVisible(not isOver)
    -- self.again_:setVisible(isOver)
end

function CDPHZRoundOver:initBg_(winType)
    if winType == 2 then
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/losebg.png')
        self.winbg_:setTexture(texture)
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/xiaWinTitle.png')
        self.winTitle_:setTexture(texture)
    elseif winType == 3 then
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/losebg.png')
        self.winbg_:setTexture(texture)
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/shangWinTitle.png')
        self.winTitle_:setTexture(texture)
    end
end

function CDPHZRoundOver:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/yzchz/RoundOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function CDPHZRoundOver:againHandler_()
    display.getRunningScene():nextRound()
end

function CDPHZRoundOver:gameOverHandler_()
    display.getRunningScene():showJieSuanSelectView(false)
    TaskQueue.continue()
    self:removeFromParent()
end

function CDPHZRoundOver:jieSanHandler_()
    display.getRunningScene():sendDismissRoomCMD(true)
end

return CDPHZRoundOver 
