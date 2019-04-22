local TableView = import("app.games.shuangKou.views.game.TableView")
local ReViewTableView = class("ReViewTableView", TableView)

local TYPES = gailun.TYPES
local tableNodes = {}
tableNodes.normal = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            {type = TYPES.LABEL, var = "viewProgress_", type = TYPES.CUSTOM, class = "app.games.shuangKou.views.game.ProgressView"},
            {type = TYPES.LABEL, var = "labelTableRules_", options = {text="", font=DEFAULT_FONT, size=38, color=cc.c3b(5, 67, 103)}, x = display.cx - 150, y = 700, ap = {0.5, 0.5}},
        }},
        -- {type = TYPES.CUSTOM, var = "scoreNode_", class = "app.games.shuangKou.views.game.CountingScoreView"}, --计分面板
        {type = TYPES.NODE, var = "nodePublicPokers_"}, --公共牌容器
        {type = TYPES.NODE, var = "nodePlayers_",}, --玩家容器
        {type = TYPES.NODE, var = "nodePokerContent_"}, -- 主玩家的手牌容器，需要最高等级的显示
        {type = TYPES.SPRITE, var = "spriteDealer_", filename = "res/images/game/flag_zhuang.png", x = display.cx, y = display.cy},
        {type = TYPES.NODE, var = "nodeJianFenQu_", x = DAI_JIAN_FEN_X, y = DAI_JIAN_FEN_Y},
        {type = TYPES.NODE, var = "nodeChat1_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat2_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat3_"}, -- 玩家3聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat4_"}, -- 玩家4聊天气泡容器
        {type = TYPES.CUSTOM, var = "directorController_", class = "app.games.shuangKou.controllers.DirectorController"},

        {type = TYPES.NODE, var = "nodeAnim_"}, -- 打牌动画容器
        {type = TYPES.NODE, var = "nodeFaceAnim_"}, -- 表情动画容器


        {type = TYPES.SPRITE, visible = false, var = "nodeGroupInfo_", filename = "res/images/shuangKou/game/groupBg.png", ap = {0, 0.5}, x = display.left, y = display.top - 80, children = {
            {type = TYPES.LABEL, options = {text = "分组:", size = 28, color = cc.c3b(216,209,95), font = DEFAULT_FONT}, x = 10, ppy = 0.5, ap = {0, 0.5}},
            {type = TYPES.SPRITE, var = "cardType_", filename = "res/images/shuangKou/game/meihua.png", ppx = 0.46, ppy = 0.55, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "cardValue_", options = {text = "3", size = 28, color = cc.c3b(11,11,11), font = DEFAULT_FONT}, x = 132, ppy = 0.55, ap = {0.5, 0.5}},
        }}, -- 分组展示
    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatString(POOL_PREFIX)
NumberRoller:setFormatHandler(gailun.utils.formatChips)

local POSITION_OF_DEALER_4 = {
    -- {-35, 35},
    -- {-35, 35},
    -- {-35, 35},
}

local NODE_FAPAI_POS = {
    -- {200, 200},
    -- {1050, 500},
    -- {200, 500},
}

local PUBLIC_CARD_SPACE = 68  -- 公共牌间距
local PASS_POINT_Y = 750

local ALARM_POSITION = {
    -- {200, 250},
    -- {1050 / DESIGN_WIDTH * display.width, 550},
    -- {260 / DESIGN_WIDTH * display.width, 550}
}

function ReViewTableView:ctor(table)
    self.table_ = table
    ReViewTableView.super.dealData(self)
    local data = tableNodes.normal
    gailun.uihelper.render(self, data)
end

function ReViewTableView:onStatePlaying_(event)

end

return ReViewTableView
