local BaseItem = import("app.views.BaseItem")
local RoundOverItem = class("RoundOverItem", BaseItem)
local PokerView = import("app.views.game.PokerView")
local ShuangKouAlgorithm = import("app.games.shuangKou.utils.ShuangKouAlgorithm")

function RoundOverItem:ctor()
	RoundOverItem.super.ctor(self)
end

function RoundOverItem:setNode(node)
    self.csbNode_ = node
    self:initElement_()
end

function RoundOverItem:updateView(data, i, rankList)
    dump(data, "roundOverItem")
    if data == nil then
        self.csbNode_:hide()
        return
    end
    self.contributionLabel_:setString(string.format("%+d", data.contributionTotalScore))
    -- self.scoreLabel_:setString(data.score)

    local path = data.score >= 0 and "views/games/shuangkou/fonts/pzyn.fnt" or "views/games/shuangkou/fonts/pzsn.fnt"
    self.scoreLabel_:removeAllChildren()
    self.scoreLabel_:addChild(cc.LabelBMFont:create(string.format("%+d", data.score), path))
    self.nicknameLabel_:setString(data.nickName)
    if data.maxRatio > 0 then
        self.ratioLabel_:setString(math.pow(2, data.maxRatio))
    else
        self.ratioLabel_:setString(0)
    end

    if i%2 == 0 then
        self.tagSpr_:loadTexture("views/games/shuangkou/roundOver/y.png")
    end

    local index = table.indexof(rankList, data.seatID)

    if index then
        self.pm_:loadTexture("views/games/shuangkou/roundOver/".. index ..".png")
    else
        if #rankList == 0 then
            self.pm_:hide()
        else
            if #rankList == 3 then
                self.pm_:loadTexture("views/games/shuangkou/roundOver/4.png")
            elseif #rankList == 2 then
                self.pm_:loadTexture("views/games/shuangkou/roundOver/3.png")
            end
        end
    end


    if data.shuangkouType ~= 0 then
        local map = {
            "shuangKou", "danKou", "pingKou"
        }
        if data.isWin then
            display.newSprite("views/games/shuangkou/roundOver/" .. map[data.shuangKouType] .. ".png"):addTo(self.csbNode_):pos(540, 0)
        end
    end

    local config = display:getRunningScene():getTable():getConfigData()

    local startX = -520
    local interval = 20
    for k, cards in pairs(data.turnCards) do
        if ShuangKouAlgorithm.isZha(cards, config.bianPai) then
            for _, card in pairs(cards) do
                local poker = PokerView.new(card, false):addTo(self.csbNode_):pos(startX, 20)
                poker:setScale(0.3)
                poker:fanPai()
                startX = startX + interval
            end

            startX = startX + interval * 2
        end
    end
end

return RoundOverItem 
