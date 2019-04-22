local BaseElement = import("app.views.BaseElement")
local ChaGuanData = import("app.data.ChaGuanData")

local JiChuSet = class("JiChuSet", BaseElement)

function JiChuSet:ctor(data)
    JiChuSet.super.ctor(self)
    self.weekJuShu_:setString(data.weekRound)
    self.todayJuShu_:setString(data.dayRound)
    self.input1_:setString(ChaGuanData.getClubInfo().name)
    self.input2_:setString(ChaGuanData.getClubInfo().notice)
end

function JiChuSet:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/jichuSet.csb"):addTo(self)
end

function JiChuSet:xiuGai1Handler_()
    display.getRunningScene():editChaGuanName(self.input1_:getString())
end

function JiChuSet:xiuGai2Handler_()
    display.getRunningScene():editChaGuanGongGao(self.input2_:getString())
end

function JiChuSet:jiesanHandler_()
    display.getRunningScene():jieSanClub()
end

return JiChuSet 
