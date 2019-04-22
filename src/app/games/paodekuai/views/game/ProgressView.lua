local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LABEL, var = "labelTableID_", x = -500, y = 370, options = {text="", size=24, font = DEFAULT_FONT, color=cc.c3b(81, 136, 183)}, ap = {0, 0.5}},
        {type = TYPES.LABEL, var = "labelProgress_", x = -310, y = 370, options = {text="", font=DEFAULT_FONT, size=24, color=cc.c3b(81, 136, 183)}, ap = {0, 0.5}},
        {type = TYPES.LABEL, var = "labelRoomInfo_", x = -180, y = 370, options = {text="", font=DEFAULT_FONT, size=24, color=cc.c3b(81, 136, 183)}, ap = {0, 0.5}},
    }
}

local ProgressView = class("ProgressView", gailun.BaseView)

function ProgressView:ctor(table)
    gailun.uihelper.render(self, nodes)
end

function ProgressView:showRoomConfig()
    local playerTable = dataCenter:getPokerTable()
    local zhaDanInfo = playerTable:getZhaDanInfo() .. "  "
    local paiZhang = playerTable:getPaiZhangInfo() .. "  "
    local weiPai = playerTable:getWeiPaiInfo().."  "
    local xianShiPai = playerTable:getXianPaiInfo() .. "  "
    local zhaDanKeChai = playerTable:getZhaDanKeChaiInfo() .. "  "
    local baoShuang = playerTable:getBaoShuangInfo() .. "  "
    local msg = paiZhang .. zhaDanInfo .. xianShiPai .. zhaDanKeChai .. weiPai .. baoShuang

    self.labelRoomInfo_:setString(msg)
    self.currRound_ = dataCenter:getPokerTable():getFinishRound()
    self:setRoundState(dataCenter:getPokerTable():getConfigData().juShu, self.currRound_)
end

function ProgressView:addRound()
    self.currRound_ = self.currRound_ + 1
    dataCenter:getPokerTable():setFinishRound(self.currRound_)
    self:setRoundState(dataCenter:getPokerTable():getConfigData().juShu, self.currRound_)
end

function ProgressView:getRound()
    return self.currRound_
end

function ProgressView:setRoundState(total, current)
    self.labelProgress_:setString("局数：" .. current .. "/" .. total)
end

function ProgressView:updateTableID_(tid)
    self.labelTableID_:setString(string.format("房间号：%06d", tid or 0))
end

return ProgressView
