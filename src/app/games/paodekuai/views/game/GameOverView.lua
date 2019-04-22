local BaseView = import("app.views.BaseView")
local GameOverView = class("GameOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local GameOverItem = import(".GameOverItem")
local ShareView = import("app.views.game.ShareView")
function GameOverView:ctor(data)
    GameOverView.super.ctor(self)
    self.players_ = {}
    self.players_[1] = self.player1_
    self.players_[2] = self.player2_
    self.players_[3] = self.player3_
    self:initGameItem_(data.seats)
    self.isShare_ = false
    self.return_:setPositionX(self.return_:getPositionX()*-1)
    local fxPosx = self.fenxiang_:getPositionX()
    local fxPosImagex = self.fenxiangImage_:getPositionX()
    self.fenxiang_:setPositionX(fxPosImagex)
    self.fenxiangImage_:setPositionX(fxPosx)
    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
    self.gameDifen_:setVisible(true)
    self.matchDifen_:setVisible(true)
    self.gameDifen_:setString("游戏底分："..tostring(data.gameDifen))
    self.matchDifen_:setString("比赛底分："..tostring(data.matchDifen))
end

function GameOverView:initGameItem_(seats)
    for i=1,3 do
        if seats[i] then
            local item = GameOverItem.new(seats[i])
            item:setNode(self.players_[i])
        else
            self.players_[i]:hide()
        end
    end
end

function GameOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/gameOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function GameOverView:returnHandler_()
    display.getRunningScene():enterQianScene()
end

function GameOverView:fenxiangHandler_()
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("跑得快","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(),self.recordId)
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
        display.getRunningScene():shareImage(2,"跑得快","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView 
