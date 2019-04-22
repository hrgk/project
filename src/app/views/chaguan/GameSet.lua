local BaseElement = import("app.views.BaseElement")
local GameSet = class("GameSet", BaseElement)
local ChaGuanData = import("app.data.ChaGuanData")

function GameSet:ctor()
    GameSet.super.ctor(self)
    self.input1_:setString(ChaGuanData.getClubInfo().lowestScore)
    self.input2_:setString(ChaGuanData.getClubInfo().overScore)
    self.input3_:setString(ChaGuanData.getClubInfo().reduceScore)
end

function GameSet:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/gameSet.csb"):addTo(self)
end


function GameSet:xiuGai1Handler_()
    ChaGuanData.getClubInfo().lowestScore = self.input1_:getString()
    display.getRunningScene():setLowestScore(tonumber(self.input1_:getString()))
end

function GameSet:xiuGai2Handler_()
    ChaGuanData.getClubInfo().overScore = tonumber(self.input2_:getString())
    ChaGuanData.getClubInfo().reduceScore = tonumber(self.input3_:getString())
    display.getRunningScene():setOverScoreReduceScore(tonumber(self.input2_:getString()),tonumber(self.input3_:getString()))
end

return GameSet  
