local TableView = import("app.games.paodekuai.views.game.TableView")
local ReViewTableView = class("ReViewTableView", TableView)

local TYPES = gailun.TYPES
local tableNodes = {}
tableNodes.normal = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.NODE, var = "nodeTableInfo_", children = {  -- 桌子信息容器
            {type = TYPES.LABEL, var = "viewProgress_", type = TYPES.CUSTOM, class = "app.games.paodekuai.views.game.ProgressView", x = display.cx, y = display.cy},
            {type = TYPES.LABEL, var = "labelTableRules_", options = {text="", font=DEFAULT_FONT, size=24, color=cc.c3b(124, 229, 114)}, x = display.cx - 150, y = 700, ap = {0.5, 0.5}},
        }},
        {type = TYPES.BUTTON, var = "buttonRank_", normal = "res/images/game/yxz_px_btn.png", autoScale = 0.9, x =  display.right - 40, y = display.bottom + 40,},

        {type = TYPES.NODE, var = "nodePublicPokers_"}, --公共牌容器
        {type = TYPES.NODE, var = "nodePlayers_",}, --玩家容器
        -- {type = TYPES.SPRITE, var = "spriteDealer_", filename = "res/images/game/flag_zhuang.png", x = display.cx, y = display.cy},
        {type = TYPES.NODE, var = "nodeJianFenQu_", x = DAI_JIAN_FEN_X, y = DAI_JIAN_FEN_Y},
        {type = TYPES.NODE, var = "nodeChat1_"}, -- 玩家1聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat2_"}, -- 玩家2聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat3_"}, -- 玩家3聊天气泡容器
        {type = TYPES.NODE, var = "nodeChat4_"}, -- 玩家4聊天气泡容器       
        {type = TYPES.CUSTOM, var = "directorController_", class = "app.games.paodekuai.controllers.DirectorController"},

        {type = TYPES.NODE, var = "nodePokerContent_"}, -- 主玩家的手牌容器，需要最高等级的显示
        {type = TYPES.NODE, var = "nodeAnim_"}, -- 打牌动画容器
        {type = TYPES.NODE, var = "nodeFaceAnim_"}, -- 表情动画容器
    }
}

local NumberRoller = gailun.NumberRoller.new()
NumberRoller:setFormatString(POOL_PREFIX)
NumberRoller:setFormatHandler(gailun.utils.formatChips)

local POSITION_OF_DEALER_4 = {
    {-35, 35},
    {-35, 35},
    {-35, 35},
}

local NODE_FAPAI_POS = {
    {200, 200},
    {1050, 500},
    {200, 500},
}

local PUBLIC_CARD_SPACE = 68  -- 公共牌间距
local PASS_POINT_Y = 750

local ALARM_POSITION = {
    {200, 250},
    {1050 / DESIGN_WIDTH * display.width, 550},
    {260 / DESIGN_WIDTH * display.width, 550}
}

function ReViewTableView:ctor(table)
    self.table_ = table
    local data = tableNodes.normal
    gailun.uihelper.render(self, data)
    self.buttonRank_:hide()
end

function ReViewTableView:onStatePlaying_(event)
    
end

return ReViewTableView 
