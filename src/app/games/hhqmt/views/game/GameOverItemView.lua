local BaseElement = import("app.views.BaseElement")
local GameOverItemView = class("GameOverItemView", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
function GameOverItemView:ctor()
    GameOverItemView.super.ctor(self)
end

function GameOverItemView:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

function GameOverItemView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/hhqmt/gameOverItem.csb"):addTo(self)
end

function GameOverItemView:update(data,dismissSeat)
    self.data_ = data
    self:initHead_()
    self.fangzhu_:setVisible(data.isFangZhu)
    self.dayingjia_:setVisible(data.isDaYingJia)
    local clockScore = display.getRunningScene():getLockScore()
    if data.seatID == dismissSeat then
        self.jsfTag_:show()
    end
    if data.totalScore > 0 then
        self.winbg_:show()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/pzy.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-100)
        self.matchScore_:setColor(cc.c3b(128, 59, 13))
    elseif data.totalScore <=0 then
        self.losebg_:show()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/pzs.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-100)
        self.matchScore_:setColor(cc.c3b(17, 94, 159))
    end
    if clockScore > 0 then
        self.matchScore_:setString("总积分:" .. (data.matchScore+self.data_.totalScore))
    end
    self.name_:setString(data.nickName)
    self.id_:setString(data.uid)
end

return GameOverItemView
