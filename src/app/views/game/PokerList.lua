local PokerView = import(".PokerView")
local PdkAlgorithm = import("app.games.paodekuai.utils.PdkAlgorithm")
local PokerList = class("PokerList", function()
    return display.newSprite()
end)
local POKER_WIDTH = 124
local SELECTED_HEIGHT = 40
function PokerList:ctor(isHost)
    self.isHost_ = isHost
    if not self.isHost_ then
        self.margin_ = 70
    else
        self.margin_ = 160
    end
    self.isTiShi_ = false
    self.tipCards_ = {}
    self.tsIndex_ = 1
end

function PokerList:setNiuNiuMask(bool)
    self.niuniuMask_ = bool
end

function PokerList:removeAllPokers()
    self:removeAllChildren()
end

function PokerList:showPokers(cards, isFaPai)
    self.pokerList_ = {}
    self:removeAllPokers()
    self:showPokersWithAnim_(cards, isFaPai)
end

function PokerList:addPokers(card)
    self.pokerList_[5]:setCard(card)
    self.pokerList_[5]:fanPai()
end

function PokerList:showPokersWithAnim_(pokers, isFaPai)
    if pokers == nil then return end
    local cards = pokers
    local setup = 0
    local timers = 0
    if isFaPai then
        timers = 0.1
    end
    local actions = {}
    for i,v in ipairs(cards) do
        table.insert(actions, cc.CallFunc:create(function ()
            local x, y, z = self:calcPokerPos_(#cards, i)
            local poker = PokerView.new(v):addTo(self):pos(x, y)
            if v ~= -1 then
                poker:showBack(false)
                poker:fanPai()
            end
            if self.niuniuMask_ and i <= 3 then
                poker:setHighLight(true)
            end
            self.pokerList_[#self.pokerList_+1] = poker
        end))
        table.insert(actions, cc.DelayTime:create(timers))
    end
    if #actions > 0 then
        self:runAction(transition.sequence(actions))
    end
end

function PokerList:calcPokerPos_(total, index)
    local offset = (index - (total - 1) / 2 - 1) * self.margin_
    local x = offset
    local y = 0
    return x, y, index
end

return PokerList 
