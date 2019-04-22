local BaseItem = import("app.views.BaseItem")
local GameOverItem = class("GameOverItem",BaseItem)
local PlayerHead = import("app.views.PlayerHead")

function GameOverItem:ctor(data, roomInfo)
    self.data_ = data
    self.roomInfo_ = roomInfo
    GameOverItem.super.ctor(self)
end

function GameOverItem:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

function GameOverItem:setNode(node)
    GameOverItem.super.setNode(self, node)
    self.nick_:setString(self.data_.nickName)
    local clockScore = self.roomInfo_.config.matchConfig.score or 0
    -- self.bombCount_:setString(self.data_.bombCount)
    -- self.winCount_:setString(self.data_.winCount)
    if self.data_.totalScore > 0 then
        self.winbg_:show()
        self.losebg_:hide()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/jiesuanying.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-35)
        self.matchScore_:setColor(cc.c3b(128, 59, 13))
    else
        self.winbg_:hide()
        self.losebg_:show()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/jiesuanshu.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-35)
        self.matchScore_:setColor(cc.c3b(17, 94, 159))
    end
    self.dayingjia_:setVisible(self.data_.isDaYingJia)
    self:initHead_()
    if clockScore > 0 then
        self.matchScore_:setString("总积分:" .. (clockScore + self.data_.totalScore))
    end
end

return GameOverItem 
