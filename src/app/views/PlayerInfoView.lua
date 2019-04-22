local BaseView = import("app.views.BaseView")
local PlayerInfoView = class("PlayerInfoView", BaseView)
local PlayerHead = import("app.views.PlayerHead")
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local FaceAnimationViewItem = import("app.views.FaceAnimationViewItem")

function PlayerInfoView:ctor(data, gameType)
    dump(data,"PlayerInfoView:ctor")
    self.data_ = data
    self.gameType_ = gameType
    PlayerInfoView.super.ctor(self)
    self:initHead_()
    self.ID_:setString(data.uid)
    self.IP_:setString(data.IP)
    self.timer_:setString(os.date("%Y-%m-%d",data.loginTime))
    if data.roundCount then
        self.juShu_:setString("对战局数："..data.roundCount)
    else
        self.juShu_:setString("")
    end
    if data.sex == 1 then
        self.female_:hide()
        self.male_:show()
    else
        self.male_:hide()
        self.female_:show()
    end
    if data.address then
        self.addr_:show()
        self.Adr_:show()
        self.Adr_:setString(data.address)
    end
    if data.gameType == 1 then
        local score =  data.playerContriller:getClubScore()
        self.clubScoreText_:setString(tostring(score))
    else
        self.clubScoreText_:setString("_")
    end
end

function PlayerInfoView:showInGameScenes()
    self:initFaceList_()
end

function PlayerInfoView:initFaceList_()
    for i,v in ipairs(FaceAnimationsData.getFaceAnimations()) do
        local item = FaceAnimationViewItem.new(self.gameType_)
        item:update(v, self.data_.seatID,self.data_.uid)
        item:setCallback(handler(self, self.closeHandler_))
        local x = (i - 1) * 100 - 250
        local y =  -110
        item:setPosition(x, y)  
        self.csbNode_:addChild(item)  
    end
end

function PlayerInfoView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gamePlayerInfo/gamePlayerInfo.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function PlayerInfoView:initHead_()
    local view = PlayerHead.new(nil, true)
    view:setNode(self.head_)
    view:showWithUrl(self.data_.avatar)
end

return PlayerInfoView 
