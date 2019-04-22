local BaseView = import("app.views.BaseView")
local PokerView = import("app.views.game.PokerView")
local XuanPaiView = class("XuanPaiView", BaseView)
function XuanPaiView:ctor(data)
    self.data_ = data
    XuanPaiView.super.ctor(self)
    self.pokerIndex_ = 1
    self.totalCount_ = 5
    self:initDaoJiShi_()
end

function XuanPaiView:initDaoJiShi_()
    local actions = {}
    for i=1,5 do
        table.insert(actions, cc.CallFunc:create(function ()
            self.time_:setString(self.totalCount_)
            self.totalCount_ = self.totalCount_ - 1
        end))
        table.insert(actions, cc.DelayTime:create(1))
    end
    table.insert(actions, cc.CallFunc:create(function ()
        self.time_:setString(self.totalCount_)
        display.getRunningScene():sendXuanPaiCMD()
        end))
    self:runAction(transition.sequence(actions))
end

function XuanPaiView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/pdk/xuanPaiView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function XuanPaiView:update(data)
    local card = data.card
    local view = PokerView.new(card):addTo(self.csbNode_)
    local tablePoker = PokerView.new(card)
    local x,y = 0,0
    if self.pokerIndex_ == 1 then
        x = self.poker1_:getPositionX()
        y = self.poker1_:getPositionY()
        self.poker1_:hide()
    elseif self.pokerIndex_ == 2 then
        x = self.poker2_:getPositionX()
        y = self.poker2_:getPositionY()
        self.poker2_:hide()
    elseif self.pokerIndex_ == 3 then
        x = self.poker3_:getPositionX()
        y = self.poker3_:getPositionY()
        self.poker3_:hide()
    elseif self.pokerIndex_ == 4 then
        x = self.poker4_:getPositionX()
        y = self.poker4_:getPositionY()
        self.poker4_:hide()
    elseif self.pokerIndex_ == 5 then
        x = self.poker5_:getPositionX()
        y = self.poker5_:getPositionY()
        self.poker5_:hide()
    end
    view:setScale(0.85)
    view:fanPai()
    view:setPosition(x, y)
    tablePoker:fanPai()
    tablePoker:setScale(0.85)
    local worldPoint = self.csbNode_:convertToWorldSpaceAR(cc.p(x,y))
    display.getRunningScene():addPokerToTable(data.seatID, tablePoker, worldPoint.x,worldPoint.y)
    self:performWithDelay(function()
        self:hide()
        end, 0.5)
end

function XuanPaiView:poker1Handler_(item)
    self.pokerIndex_ = 1
    display.getRunningScene():sendXuanPaiCMD()
end

function XuanPaiView:poker2Handler_()
    self.pokerIndex_ = 2
    display.getRunningScene():sendXuanPaiCMD()
end

function XuanPaiView:poker3Handler_()
    self.pokerIndex_ = 3
    display.getRunningScene():sendXuanPaiCMD()
end

function XuanPaiView:poker4Handler_()
    self.pokerIndex_ = 4
    display.getRunningScene():sendXuanPaiCMD()
end

function XuanPaiView:poker5Handler_()
    self.pokerIndex_ = 5
    display.getRunningScene():sendXuanPaiCMD()
end

return XuanPaiView 
