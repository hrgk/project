local BaseView = import("app.views.BaseView")
local GameOverView = class("GameOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local GameOVerItemView = import(".GameOVerItemView")
local ShareView = import("app.views.game.ShareView")
function GameOverView:ctor(data)
    dump(data,"GameOverView:ctor")
    GameOverView.super.ctor(self)
    self.players_ = {}
    self.players_[1] = self.player1_
    self.players_[2] = self.player2_
    self.players_[3] = self.player3_
    self.players_[4] = self.player4_
    self:initGameItem_(data.seats)
    self.isShare_ = false
    local tableId = display.getRunningScene():getTable():getTid()
    local str = string.format("房号 %d", tableId)
    str = str .."\n" .. data.ruleString .."\n" ..(data.finishTime or os.date("%Y-%m-%d %H:%M:%S"))
    self.roomInfo_:setString(str)
    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
end

function GameOverView:initGameItem_(seats)
    for i=1,4 do
        if seats[i] then
            local item = GameOVerItemView.new(seats[i])
            item:setNode(self.players_[i])
        else
            self.players_[i]:hide()
        end
    end
end

function GameOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/shuangkou/gameOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function GameOverView:returnHandler_()
    display.getRunningScene():enterQianScene()
end

function GameOverView:fenxiangHandler_()
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("金华双扣","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(),self.recordId)
end

function GameOverView:fenxiangImageHandler_()
    local function callback()
       
    end
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        display.getRunningScene():shareImage(2,"金华双扣","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView 
