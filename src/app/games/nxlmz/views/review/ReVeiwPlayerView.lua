local PDKPlayerView = import("app.games.nxlmz.views.game.PDKPlayerView")
local ReVeiwPlayerView = class("ReVeiwPlayerView", PDKPlayerView)
local PokerListView = import("app.games.nxlmz.views.game.PokerListView")
local PokerList = import("app.views.game.PokerList")
function ReVeiwPlayerView:ctor(index)
    ReVeiwPlayerView.super.ctor(self, index)
end

function ReVeiwPlayerView:onRemoveHandCards_(event)
    if event.cards == nil or #event.cards == 0 then
        return
    end
    self.pokerList_:removePokers(event.cards)
end

function ReVeiwPlayerView:initHandCards_(event)
    if self.pokerList_ == nil then 
        self.pokerList_ = PokerListView.new(self.player_):addTo(self.csbNode_)
        self:clacHandCardPos_()
    end
    self.pokerList_:removeAllPokers()
    self.pokerList_:showPokers(event.cards,not event.isReConnect)
    if self.index_ ~= 1 then
        self.pokerList_:setScale(0.5)
    end
    if self.index_ == 2 then
        self.pokerList_:setPosition(-200, -100)
    elseif self.index_ == 3 then
        self.pokerList_:setPosition(200, -100)
    end
    self.chuPaiContent_:zorder(5)
end

function ReVeiwPlayerView:onScoreChange_(event)
    
end

return ReVeiwPlayerView 
