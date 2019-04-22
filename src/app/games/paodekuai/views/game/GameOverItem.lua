local BaseItem = import("app.views.BaseItem")
local GameOverItem = class("GameOverItem",BaseItem)
local PlayerHead = import("app.views.PlayerHead")

function GameOverItem:ctor(data)
    self.data_ = data
    dump(data)
    GameOverItem.super.ctor(self)
end

function GameOverItem:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

function GameOverItem:setNode(csbNode)
    self.csbNode_ = csbNode
    self:initElement_()
    self.name_:setString(self.data_.nickName)
    self.bombCount_:setString(self.data_.bombCount)
    self.winCount_:setString(self.data_.winCount)
    self:initDeFen_(self.data_.totalScore,self.data_.matchScore)
    self.dayingjia_:setVisible(self.data_.isDaYingJia)
    self.fangzhu_:setVisible(self.data_.isFangZhu)
    self.uid_:setString("ID:"..self.data_.uid)
    self:initHead_()
end

function GameOverItem:initDeFen_(score,matchScore)
    local lockScore = display.getRunningScene():getLockScore() 
    if score > 0 then
        self.lose_:hide()
        self.win_:show()
        local params = {}
        params.filename = "fonts/paodekuai_ying.png"
        params.options = {text= "+" .. score, w = 53, h = 75, startChar = "+"}
        self.cardNumber_ = gailun.uihelper.createLabelAtlas(params)
        :addTo(self.csbNode_)
        :pos(0,-130+26)
        :setAnchorPoint(0.5,0.5)
        self.matchScore_:setColor(cc.c3b(128, 59, 13))
    elseif score <= 0 then
        self.lose_:show()
        self.win_:hide()
        local params = {}
        params.filename = "fonts/paodekuai_shu.png"
        params.options = {text= score, w = 53, h = 75, startChar = "+"}
        self.cardNumber_ = gailun.uihelper.createLabelAtlas(params)
        :addTo(self.csbNode_)
        :pos(0,-130+26)
        :setAnchorPoint(0.5,0.5)
        self.matchScore_:setColor(cc.c3b(17, 94, 159))
    end
    if lockScore > 0 then
        self.matchScore_:setPositionY(self.matchScore_:getPositionY()-10)
        self.matchScore_:setString("总积分:" .. (score+matchScore))
    end
end

return GameOverItem 
