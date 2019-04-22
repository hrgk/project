local RoundOverZXView = class("RoundOverZXView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.SPRITE, var = "spriteZXBG_", filename = "#zhuangxianbg.png", align = {display.CENTER, 1050 / DESIGN_WIDTH * display.width + 180 / DESIGN_WIDTH * display.width / 2 + 20, display.height * 0.493}, children = {
            {type = TYPES.SPRITE, filename = "#js_fgx2.png", ppx = 0.5, ppy = 0.5},

            {type = TYPES.NODE, var = "nodeZhuangWin_", children = {
                {type = TYPES.SPRITE, filename = "#js_win.png", x = 163, y = 490},
                {type = TYPES.BUTTON, normal = "#zhuangwin.png", x = 85, y = 481,},
                {type = TYPES.SPRITE, filename = "#js_jfwin.png", x = 56, y = 426},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangWinJianFen_", filename = "fonts/js_fenwin1.png", options = {w = 18, h = 32, startChar = "+", text = "322"}, x = 160,  y = 424, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_cfwin.png", x = 56, y = 376},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangWinChaoFen_", filename = "fonts/js_fenwin1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 373, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_fen2.png", x = 56, y = 316},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangWinScore_", filename = "fonts/js_fenwin2.png", options = {w = 24, h = 43, startChar = "+"}, x = 160, y = 313, ap = {1, 0.5}},
            }},
            
            {type = TYPES.NODE, var = "nodeZhuangLose_", children = {
                {type = TYPES.SPRITE, filename = "#js_lose.png", x = 163, y = 490},
                {type = TYPES.BUTTON, normal = "#zhuanglose.png", x = 85, y = 481,},
                {type = TYPES.SPRITE, filename = "#js_jflose.png", x = 56, y = 426},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangLoseJianFen_", filename = "fonts/js_fenlose1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 424, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_cflose.png", x = 56, y = 376},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangLoseChaoFen_", filename = "fonts/js_fenlose1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 373, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_fen1.png", x = 56, y = 316},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelZhuangLoseScore_", filename = "fonts/js_fenlose2.png", options = {w = 24, h = 43, startChar = "+"}, x = 160, y = 313, ap = {1, 0.5}},
            }},

            {type = TYPES.NODE, var = "nodeXianWin_", children = {
                {type = TYPES.SPRITE, filename = "#js_win.png", x = 163, y = 230},
                {type = TYPES.BUTTON, normal = "#xianwin.png", x = 85, y = 221},
                {type = TYPES.SPRITE, filename = "#js_jfwin.png", x = 56, y = 166},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianWinJianFen_", filename = "fonts/js_fenwin1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 164, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_cfwin.png", x = 56, y = 116},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianWinChaoFen_", filename = "fonts/js_fenwin1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 114, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_fen2.png", x = 56, y = 56},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianWinScore_", filename = "fonts/js_fenwin2.png", options = {w = 24, h = 43, startChar = "+"}, x = 160, y = 53, ap = {1, 0.5}},
            }},

            {type = TYPES.NODE, var = "nodeXianLose_", children = {
                {type = TYPES.SPRITE, filename = "#js_lose.png", x = 163, y = 230},
                {type = TYPES.BUTTON, normal = "#xianlose.png", x = 85, y = 221,},
                {type = TYPES.SPRITE, filename = "#js_jflose.png", x = 56, y = 166},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianLoseJianFen_", filename = "fonts/js_fenlose1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 164, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_cflose.png", x = 56, y = 116},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianLoseChaoFen_", filename = "fonts/js_fenlose1.png", options = {w = 18, h = 32, startChar = "+"}, x = 160, y = 114, ap = {1, 0.5}},
                {type = TYPES.SPRITE, filename = "#js_fen1.png", x = 56, y = 56},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelXianLoseScore_", filename = "fonts/js_fenlose2.png", options = {w = 24, h = 43, startChar = "+"}, x = 160, y = 53, ap = {1, 0.5}},
            }},
        }}, 
    }
}

function RoundOverZXView:ctor()
    RoundOverZXView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
end

function RoundOverZXView:showResult(params)
    self:setWinOrLose_(params.zhuangWin)
    self:setScores_(params.zhuangJian, params.zhuangChao, params.zhuangScore, 
        params.xianJian, params.xianChao, params.xianScore)
end

function RoundOverZXView:formatChaoFen_(score)
    if score > 0 then
        return string.format("+%d", score)
    else
        return string.format("%d", score)
    end
end

function RoundOverZXView:setScores_(zhuangJian, zhuangChao, zhuangScore, xianJian, xianChao, xianScore)
    self.labelZhuangWinJianFen_:setString(zhuangJian)
    self.labelZhuangWinChaoFen_:setString(self:formatChaoFen_(zhuangChao))
    self.labelZhuangWinScore_:setString(zhuangScore)
    self.labelZhuangLoseJianFen_:setString(zhuangJian)
    self.labelZhuangLoseChaoFen_:setString(self:formatChaoFen_(zhuangChao))
    self.labelZhuangLoseScore_:setString(zhuangScore)

    self.labelXianWinJianFen_:setString(xianJian)
    self.labelXianWinChaoFen_:setString(self:formatChaoFen_(xianChao))
    self.labelXianWinScore_:setString(xianScore)
    self.labelXianLoseJianFen_:setString(xianJian)
    self.labelXianLoseChaoFen_:setString(self:formatChaoFen_(xianChao))
    self.labelXianLoseScore_:setString(xianScore)
end

function RoundOverZXView:setWinOrLose_(zhuangWin)
    self.nodeZhuangWin_:setVisible(zhuangWin)
    self.nodeZhuangLose_:setVisible(not zhuangWin)
    self.nodeXianWin_:setVisible(not zhuangWin)
    self.nodeXianLose_:setVisible(zhuangWin)
end

return RoundOverZXView
