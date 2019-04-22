local BaseView = import("app.views.BaseView")
local RoundOverView = class("RoundOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local TaskQueue = require("app.controllers.TaskQueue")

function RoundOverView:ctor(data)
    dump(data)
	RoundOverView.super.ctor(self)
	self:initJiFens_()
	self:initNames_()
	self:initZhaDans_()
    self:initCardCount_()
    self:initUserBg_()
    self:initData_(data.seats)
    self.gameDifen_:setString("游戏底分："..tostring(data.gameDifen))
    self.matchDifen_:setString("比赛底分："..tostring(data.matchDifen))
end

function RoundOverView:initData_(seats)
    for i=1, 3 do
        if seats[i] then
            self.names_[i]:setString(seats[i].nickName)
            self.zhaDans_[i]:setString(seats[i].bomb)
            self.cardNums_[i]:setString(seats[i].cards)
            self.jifens_[i]:setString(seats[i].score)
            if seats[i].uid == selfData:getUid() then
                self.userBg_[i]:loadTexture("res/images/paodekuai/roundOver/my.png")
                self.names_[i]:setColor(cc.c3b(246, 225, 148))
                self.zhaDans_[i]:setColor(cc.c3b(246, 225, 148))
                self.cardNums_[i]:setColor(cc.c3b(246, 225, 148))
                self.jifens_[i]:setColor(cc.c3b(246, 225, 148))
            end
        else
            self.names_[i]:hide()
            self.zhaDans_[i]:hide()
            self.cardNums_[i]:hide()
            self.jifens_[i]:hide()
            self.userBg_[i]:hide()
        end
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

function RoundOverView:initUserBg_()
    self.userBg_ = {}
    self.userBg_[1] = self.user1_
    self.userBg_[2] = self.user2_
    self.userBg_[3] = self.user3_
end

return RoundOverView 
