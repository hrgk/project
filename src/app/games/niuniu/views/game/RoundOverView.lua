local BaseView = import("app.views.BaseView")
local RoundOverView = class("RoundOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local TaskQueue = require("app.controllers.TaskQueue")

function RoundOverView:ctor(data)
	RoundOverView.super.ctor(self)
	self:initJiFens_()
	self:initNames_()
	self:initZhaDans_()
	self:initCardCount_()
	self:initData_(data.seats)
    if data.hasNextRound then
        self.jixuGame_:show()
        self.zongJieSuan_:hide()
    else
        self.jixuGame_:hide()
        self.zongJieSuan_:show()
    end
end

function RoundOverView:initData_(seats)
    for i,v in ipairs(seats) do
        self.names_[i]:setString(v.nickName)
        self.zhaDans_[i]:setString(v.bomb)
        self.cardNums_[i]:setString(v.cards)
        self.jifens_[i]:setString(v.score)
    end
end

function RoundOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/pdk/roundOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function RoundOverView:initNames_()
    self.names_ = {}
    self.names_[1] = self.nick1_
    self.names_[2] = self.nick2_
    self.names_[3] = self.nick3_
end

function RoundOverView:initZhaDans_()
    self.zhaDans_ = {}
    self.zhaDans_[1] = self.zhaDanNum1_
    self.zhaDans_[2] = self.zhaDanNum2_
    self.zhaDans_[3] = self.zhaDanNum3_
end

function RoundOverView:initCardCount_()
    self.cardNums_ = {}
    self.cardNums_[1] = self.cardNum1_
    self.cardNums_[2] = self.cardNum2_
    self.cardNums_[3] = self.cardNum3_
end

function RoundOverView:initJiFens_()
    self.jifens_ = {}
    self.jifens_[1] = self.jiFen1_
    self.jifens_[2] = self.jiFen2_
    self.jifens_[3] = self.jiFen3_
end

function RoundOverView:jixuGameHandler_()
    TaskQueue.continue()
    dataCenter:sendOverSocket(COMMANDS.PDK_READY)
    self:removeSelf()
end

function RoundOverView:zongJieSuanHandler_()
    TaskQueue.continue()
    self:removeSelf()
end

return RoundOverView 
