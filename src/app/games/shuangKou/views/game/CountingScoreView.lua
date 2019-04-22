local BaseAlgorithm = require("app.games.shuangKou.utils.BaseAlgorithm")
local TYPES = gailun.TYPES

local node = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            {
                type = gailun.TYPES.SPRITE, scale = display.width / DESIGN_WIDTH, filename = "res/images/shuangKou/counting_panel/zuoshangjifendi.png", x = display.left + 5, y = display.top - 5, ap = {0, 1},
                children = {
                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/wanjia.png", x = 60, y = 110},
                    {type = TYPES.LABEL, var = "nickNameLabel1",visible = false, options = {text="", size=18, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 72, x = 60, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "nickNameLabel2",visible = false, options = {text="", size=18, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 45, x = 60, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "nickNameLabel3",visible = false, options = {text="", size=18, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 17, x = 60, ap = {0.5, 0.5}},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/lishizongfen.png", x = 175, y = 110},
                    {type = TYPES.LABEL, var = "historyScoreLabel1",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 72, x = 175, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "historyScoreLabel2",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 45, x = 175, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "historyScoreLabel3",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 17, x = 175, ap = {0.5, 0.5}},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/benjufenshu.png", x = 300, y = 110},
                    {type = TYPES.LABEL, var = "nowRoundScoreLabel1",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 72, x = 300, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "nowRoundScoreLabel2",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 45, x = 300, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "nowRoundScoreLabel3",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 17, x = 300, ap = {0.5, 0.5}},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/dizhatongfen.png", x = 425, y = 110},
                    {type = TYPES.LABEL, var = "tongziScoreLabel1",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 72, x = 425, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "tongziScoreLabel2",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 45, x = 425, ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "tongziScoreLabel3",visible = false, options = {text="0", size=24, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 17, x = 425, ap = {0.5, 0.5}},

                },
            },

            {
                type = gailun.TYPES.SPRITE, scale = display.width / DESIGN_WIDTH, filename = "res/images/shuangKou/counting_panel/jifendi.png", x = display.left + display.width / DESIGN_WIDTH * 670, y = display.top - 5, ap = {0.5, 1},
                children = {
                    -- {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/dangqianpaimianfen.png", x = 100, y = 80},
                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/gongji.png", x = 305, y = 100},

                    -- {type = TYPES.LABEL, var = "circleScore5Label", options = {text="5", size=30, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(164, 207, 143)}, y = 50, x = 32, ap = {0.5, 0.5}},
                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/dangedi.png", x = 40, y = 65, children = {
                        {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/5.png", x = 35, y = 70},
                        {type = TYPES.LABEL, var = "nowCircleScore5Label", options = {text="999", size=28, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 17, x = 35, ap = {0.5, 0.5}},
                    }},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/dangedi.png", x = 130, y = 65, children = {
                        {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/10.png", x = 35, y = 70},
                        {type = TYPES.LABEL, var = "nowCircleScore10Label", options = {text="999", size=28, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 17, x = 35, ap = {0.5, 0.5}},
                    }},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/dangedi.png", x = 220, y = 65, children = {
                        {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/K.png", x = 35, y = 70},
                        {type = TYPES.LABEL, var = "nowCircleScoreKLabel", options = {text="999", size=28, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(118, 234, 255)}, y = 17, x = 35, ap = {0.5, 0.5}},
                    }},

                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/add.png", x = 85, y = 65},
                    {type = gailun.TYPES.SPRITE, filename = "res/images/shuangKou/counting_panel/add.png", x = 175, y = 65},

                    {type = TYPES.LABEL, var = "nowCircleTotalScoreLabel", options = {text="999", size=40, font = DEFAULT_FONT, align=cc.TEXT_ALIGNMENT_CENTER, color=cc.c3b(255, 247, 118)}, y = 65, x = 260, ap = {0, 0.5}},

                },
            },
        },},
    }
}

local CountingScoreView = class("CountingScoreView", gailun.BaseView)

function CountingScoreView:ctor()
    gailun.uihelper.render(self, node)
    self.nowCircleCards = {}
    self:updateCircleScore()

    printInfo("CountingScoreView:ctor")
end

function CountingScoreView:bindPlayer(player)
    gailun.EventUtils.clear(self)
    local cls = player.class
    local events = {
        {cls.ROUND_SCORE_CHANGED, handler(self, self.onRoundScoreChange_)},
        {cls.TONG_SCORE_CHANGED, handler(self, self.onTongScoreChange_)},
        {cls.SCORE_CHANGED, handler(self, self.onHistoryScoreChange_)},
        {cls.SIT_DOWN_EVENT, handler(self, self.onSitDownChange_)},
        {cls.STAND_UP_EVENT, handler(self, self.onStandUpChange_)},
    }

    gailun.EventUtils.create(self, player, self, events)
end

function CountingScoreView:onRoundScoreChange_(data)
    self["nowRoundScoreLabel" .. data.seatID]:setString(data.score)
end

function CountingScoreView:onHistoryScoreChange_(data)
    if data.seatID == nil then
        return
    end
    self["historyScoreLabel" .. data.seatID]:setString(data.score)
end

function CountingScoreView:onTongScoreChange_(data)
    self["tongziScoreLabel" .. data.seatID]:setString(data.score)
end

function CountingScoreView:onSitDownChange_(data)
    self["nickNameLabel" .. data.seatID]:setString(gailun.utf8.formatNickName(data.nickName, 8, '...'))--对名字过长进行处理
    self["nickNameLabel" .. data.seatID]:show()
    self["historyScoreLabel" .. data.seatID]:show()
    self["nowRoundScoreLabel" .. data.seatID]:show()
    self["tongziScoreLabel" .. data.seatID]:show()
end

function CountingScoreView:onStandUpChange_(data)
    self["nickNameLabel" .. data.seatID]:setString("")
    self["nickNameLabel" .. data.seatID]:hide()
    self["historyScoreLabel" .. data.seatID]:hide()
    self["nowRoundScoreLabel" .. data.seatID]:hide()
    self["tongziScoreLabel" .. data.seatID]:hide()
end

function CountingScoreView:addCircleCards(cards)
    cards = cards or {}
    for _, v in ipairs(cards) do
        table.insert(self.nowCircleCards, v)
    end

    self:updateCircleScore(self.nowCircleCards)
end

function CountingScoreView:resetCircleCards()
    self.nowCircleCards = {}
    self:updateCircleScore()
end

function CountingScoreView:onExit()
    gailun.EventUtils.clear(self)
end

-- [{seatID: 2, score: 10, tongScore: 20}]
function CountingScoreView:updateRoundScore()
    for seatID = 1, 3 do
        self["nowRoundScoreLabel" .. seatID]:setString(0)
    end
end

function CountingScoreView:updateCircleScore(cards)
    cards = cards or {}
    local map = {
        [5] = 0,
        [10] = 0,
        [13] = 0,
    }
    for _, card in ipairs(cards) do
        local value = BaseAlgorithm.getValue(card)
        if map[value] ~= nil then
            map[value] = map[value] + 1
        end
    end

    self.nowCircleScore5Label:setString(map[5])
    self.nowCircleScore10Label:setString(map[10])
    self.nowCircleScoreKLabel:setString(map[13])

    self.nowCircleTotalScoreLabel:setString("= " .. (map[5] * 5 + map[10] * 10 + map[13] * 10))
end

return CountingScoreView
