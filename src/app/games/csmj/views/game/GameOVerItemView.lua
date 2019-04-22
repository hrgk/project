local GameOverItemView = class("GameOverItemView", gailun.BaseView)
local TYPES = gailun.TYPES

local colors = {
    cc.c3b(84, 32, 1),
    cc.c3b(133, 29, 5),
    cc.c3b(41, 67, 88),
    cc.c3b(185, 251, 255),
}

local la_px1 = 0.2
local la_px2 = 0.72

local la_py = 0.6
local la_py_ = 0.09

local la_pys = {
    la_py - 0 * la_py_,
    la_py - 1 * la_py_,
    la_py - 2 * la_py_,
    la_py - 3 * la_py_,
    la_py - 4 * la_py_,
    la_py - 10 * la_py_,
}

local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, var = "bg_", filename = "res/images/paohuzi/gameOver/sp_win.png", children = {
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView", ppx = 0.5, ppy = 0.83, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/common/avatar_border.png", ppx = 0.5, ppy = 0.83, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "fangzhuName_", filename = "res/images/majiang/game_over/fangzhu.png", ppx = 0.12, ppy = 0.945, ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelPlayerName_", options = {text = "", size = 24, font = DEFAULT_FONT, color = colors[1]} ,ppx = 0.5, ppy = 0.685, ap = {0.5, 0.5}},
            -- {type = gailun.TYPES.LABEL, var = "labelPlayerID_", options = {text = "", size = 24, font = DEFAULT_FONT, color = colors[2]} ,ppx = 0.5, ppy = 0.62, ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelPlayerName1_", options = {text = "", size = 24, font = DEFAULT_FONT, color = colors[3]} ,ppx = 0.5, ppy = 0.685, ap = {0.5, 0.5}},
            -- {type = gailun.TYPES.LABEL, var = "labelPlayerID1_", options = {text = "", size = 24, font = DEFAULT_FONT, color = colors[4]} ,ppx = 0.5, ppy = 0.62, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/paohuzi/gameOver/sp_wenziDi.png", ppx = 0.5, ppy = la_pys[1], ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/paohuzi/gameOver/sp_wenziDi.png", ppx = 0.5, ppy = la_pys[2], ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/paohuzi/gameOver/sp_wenziDi.png", ppx = 0.5, ppy = la_pys[3], ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/paohuzi/gameOver/sp_wenziDi.png", ppx = 0.5, ppy = la_pys[4], ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, filename = "res/images/paohuzi/gameOver/sp_wenziDi.png", ppx = 0.5, ppy = la_pys[5], ap = {0.5, 0.5}},


            {type = gailun.TYPES.LABEL, options = {text = "自摸次数", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px1, ppy = la_pys[1], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, options = {text = "接炮次数", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px1, ppy = la_pys[2], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, options = {text = "放炮次数", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px1, ppy = la_pys[3], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, options = {text = "暗杠条数", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px1, ppy = la_pys[4], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, options = {text = "明杠条数", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px1, ppy = la_pys[5], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelZMNum_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px2, ppy = la_pys[1], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelJPNum_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px2, ppy = la_pys[2], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelDPNum_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px2, ppy = la_pys[3], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelAGNum_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px2, ppy = la_pys[4], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "labelMGNum_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = la_px2, ppy = la_pys[5], ap = {0, 0.5}},
            {type = gailun.TYPES.LABEL, var = "matchScore_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)} ,ppx = 0.5, ppy = -0.02, ap = {0.5, 0.5}},
            
            
            {type = gailun.TYPES.LABEL, var = "labelScroeNum_", options = {text = "", size = 40, font = DEFAULT_FONT, color = cc.c3b(255, 215, 73)} ,ppx = 0.50, ppy = 0.07, ap = {0,0.5}},
            {type = TYPES.LABEL_ATLAS, var = "labelScroeNum1_", filename = "fonts/totalscorenumlose.png", options = {text= "1", w = 25, h = 42, startChar = "+"}, ppx = 0.58, ppy = 0.05, ap = {0, 0}},
            {type = TYPES.LABEL_ATLAS, var = "labelScroeNum2_", filename = "fonts/totalscorenumwin.png", options = {text= "1", w = 25, h = 42, startChar = "+"}, ppx = 0.58, ppy = 0.05, ap = {0, 0}},
            {type = TYPES.SPRITE, var = "totalwin_", filename = "res/images/paohuzi/gameOver/sp_zongchengjiWin.png", ppx = 0.15, ppy = 0.07, ap = {0, 0}},
            {type = TYPES.SPRITE, var = "totallose_", filename = "res/images/paohuzi/gameOver/sp_zongchengjiLose.png", ppx = 0.15, ppy = 0.07, ap = {0, 0} },
        }},
    },
}

function GameOverItemView:ctor(params, roomInfo)
    GameOverItemView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self:updateInfo_(params, roomInfo)
end

function GameOverItemView:updateInfo_(params, roomInfo)
    self.fangzhuName_:setVisible(params.isFangZhu)
    self.labelPlayerName_:setString(params.nickName)
    self.labelPlayerName1_:setString(params.nickName)
    self.labelZMNum_:setString(params.ziMoCount)
    self.labelJPNum_:setString(params.chiHuCount)
    self.labelDPNum_:setString(params.dianPaoCount)
    self.labelAGNum_:setString(params.anGangCount)
    self.labelMGNum_:setString(params.mingGangCount)

    self.labelZMNum_:zorder(1)
    self.labelJPNum_:zorder(1)
    self.labelDPNum_:zorder(1)
    self.labelAGNum_:zorder(1)
    self.labelMGNum_:zorder(1)

    self.avatar_:showWithUrl(params.avatar)

    self.labelScroeNum1_:hide()
    self.labelScroeNum2_:hide()
    local clockScore = roomInfo.config.matchConfig.score or 0
    if params.totalScore >= 0 then
        self.labelScroeNum2_:setString("+" .. params.totalScore)
        self.labelScroeNum2_:show()
        self.totalwin_:show()
        self.totallose_:hide()

        self.labelPlayerName1_:hide()
        -- self.labelPlayerID1_:hide()
    else
        self.labelScroeNum1_:setString(params.totalScore)
        self.labelScroeNum1_:show()
        self.totalwin_:hide()
        self.totallose_:show()
        self.bg_:setTexture("res/images/paohuzi/gameOver/sp_lose.png")

        self.labelPlayerName_:hide()
        -- self.labelPlayerID_:hide()
    end

    local tmpTable = {}
    if params.isDaYingJia then
        table.insert(tmpTable, "res/images/paohuzi/gameOver/sp_dayingjia.png")
    end
    local size = self.bg_:getContentSize()
    for i = 1, #tmpTable do
        local sprite = display.newSprite(tmpTable[i]):addTo(self.bg_)
        sprite:setAnchorPoint(cc.p(0.5, 1))
        local x = 0.87 * size.width
        local y = ( 0.98 - (i - 1) * 0.21) * size.height
        sprite:pos(x, y)
    end
    if clockScore > 0 then
        self.matchScore_:setString("总积分:" .. (params.matchScore+params.totalScore))
        self.matchScore_:setColor(cc.c3b(224, 217, 177))
    end
end

return GameOverItemView
