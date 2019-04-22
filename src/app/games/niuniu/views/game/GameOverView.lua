local BaseView = import("app.views.BaseView")
local GameOverView = class("GameOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local GameOverItem = import(".GameOverItem")
local ShareView = import("app.views.game.ShareView")
function GameOverView:ctor(data, closeHandler)
    GameOverView.super.ctor(self)
    self.players_ = {}
    self.players_[1] = self.item1_
    self.players_[2] = self.item2_
    self.players_[3] = self.item3_
    self.players_[4] = self.item4_
    self.players_[5] = self.item5_
    self.players_[6] = self.item6_
    self.players_[7] = self.item7_
    self.players_[8] = self.item8_
    self.players_[9] = self.item9_
    self.players_[10] = self.item10_
    self:initGameItem_(data.seats, data.roomInfo)
    self.isShare_ = false
    self.closeHandler = closeHandler
    self.return_:setPositionX(self.return_:getPositionX()*-1)
    local fxPosx = self.fenXiang_:getPositionX()
    local fxPosImagex = self.fenXiangImage_:getPositionX()
    self.fenXiang_:setPositionX(fxPosImagex)
    self.fenXiangImage_:setPositionX(fxPosx)

    self.recordId = gameLocalData:getGameRecordID()
    gameLocalData:setGameRecordID("")
end

function GameOverView:initGameItem_(seats, roomInfo)
    for i=1,10 do
        if seats[i] then
            local item = GameOverItem.new(seats[i], roomInfo)
            item:setNode(self.players_[i])
        else
            self.players_[i]:hide()
        end
    end
end

function GameOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/niuniu/GameOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function GameOverView:returnHandler_()
    if self.closeHandler ~= nil then
        self:removeFromParent()
        return self.closeHandler()
    end
    display.getRunningScene():enterQianScene()
end

function GameOverView:fenXiangHandler_()
    local function callback()
       
    end
    display.getRunningScene():gameShareWeiXin("冰城拼十","",callback,display.getRunningScene():getTable():getTid(),selfData:getUid(), self.recordId)
end

function GameOverView:fenXiangImageHandler_()
    local function callback()
       
    end
    display.captureScreen(function (bSuc, filePath)
        --bSuc 截屏是否成功
        --filePath 文件保存所在的绝对路径
        if not bSuc then
            print("bSuc = false")
            return
        end
        display.getRunningScene():shareImage(2,"冰城拼十","",0, callback, filePath)
    end, gailun.native.getSDCardPath() .. "/screen.jpg")
end

return GameOverView 
