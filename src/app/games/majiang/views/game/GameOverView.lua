local BaseView = import("app.views.BaseGameResult")
local GameOverView = class("GameOverView", BaseView)
local ShareView = import("app.views.game.ShareView")
local TYPES = gailun.TYPES

local nodes = {
    type = TYPES.ROOT,
    children = {
        
        {type = TYPES.SPRITE, filename = "res/images/gameOver/boliDi.png", px = 0.5, py = 0.5, ap = {0.5, 0.5}},
        {type = TYPES.SPRITE, var = "titlePng_", filename = "res/images/paohuzi/gameOver/sp_gameOver.png", px = 0.5, py = 0.85, ap = {0.5, 0.5}},
        {type = TYPES.BUTTON, var = "buttonBack_", autoScale = 0.9, normal = "res/images/common/back.png", options = {}, px = 1-0.065, py = 0.925},
        {type = TYPES.BUTTON, var = "buttonShare_", autoScale = 0.9, normal = "res/images/gameOver/btn_fenxiang1.png", options = {}, px = 0.9, py = 0.07},
        {type = TYPES.BUTTON, var = "buttonShareImage_", autoScale = 0.9, normal = "res/images/gameOver/btn_fenxiang2.png", options = {}, px = 0.7, py = 0.07},
        {type = TYPES.LABEL, var  = "leftTip_", ap = {0, 0.5}, x = 60, y = 110, options={text="游戏结果仅作娱乐用途,禁止用于赌博行为!", 
        size = 20, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var  = "tableIdLabel_", ap = {0, 0.5}, x = 10, y = 70, options={text="", 
        size = 16, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var  = "infoLabel_", ap = {0, 0.5}, x = 10, y = 50, options={text="", 
        size = 16, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
        {type = TYPES.LABEL, var  = "timeLabel_", ap = {0, 0.5}, x = 10, y = 30, options={text="",size = 16, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}},
    }
}

function GameOverView:ctor(data)
    GameOverView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.buttonBack_:onButtonClicked(handler(self, self.onBackClicked_))
    self.buttonShare_:onButtonClicked(handler(self, self.onShareClicked_))
    self.buttonShareImage_:onButtonClicked(handler(self, self.onShareImageClicked_))
    local tableId = display.getRunningScene():getTable():getTid()
    self.tableIdLabel_:setString(string.format("房号 %d", tableId))
    self.infoLabel_:setString(data.ruleString)
    self.timeLabel_:setString(data.finishTime or os.date("%Y-%m-%d %H:%M:%S"))

    local space = 309 / DESIGN_WIDTH * display.width
    for _,v in pairs(checktable(data.seats)) do
        local x = display.cx + (v.seatID - 2) * space - space / 2
        app:createConcreteView("game.GameOVerItemView", v):addTo(self):pos(x, display.cy - 40)
    end
    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
end

function GameOverView:onBackClicked_()
    dataCenter:setRoomID(0)
    if display.getRunningScene():getTable():getClubID() > 0 then
        local params = {}
        params.clubID = display.getRunningScene():getTable():getClubID()
        params.floor = gameData:getClubFloor()
        httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
        return
    end
    app:enterHallScene()
end

function GameOverView:onShareClicked_(event)
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("转转麻将","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(), self.recordId)
end

function GameOverView:onShareImageClicked_()
    local function callback()
       
    end
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        display.getRunningScene():shareImage(2,"转转麻将","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView
