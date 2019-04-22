local BaseAlgorithm = require("app.games.mmmj.utils.BaseAlgorithm")
local GameResultItemView = class("GameResultItemView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodeSize = {display.width, display.height / 5}
local adjust_x =  40 * display.width / DESIGN_WIDTH
local head_x = (display.width - 1106) / 4 + adjust_x / 2
local cardScale = 0.55
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.NODE, var = "nodeRoot_", children = {
            {type = TYPES.SPRITE, var = "bg_", filename = "res/images/majiang/round_over/item_back.png", children = {

                -- {type = TYPES.SPRITE, var = "spriteZhuang_", filename = "res/images/majiang/game/banker_flag.png", ppx = 0.28, ppy = 0.78},
                -- {type = TYPES.LABEL, var = "labelNickName_", options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}, ppx = 0.3, ppy = 0.78, ap = {0, 0.5}},
                {type = TYPES.LABEL, var = "labelFan_", options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)}, ppx = 0.78, ppy = 0.4, ap = {1, 0.5}},
                {type = TYPES.LABEL, var = "labelFanNum_", options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c3b(255, 215, 73)}, ppx = 0.83, ppy = 0.4, ap = {1, 0.5}},

                {type = TYPES.LABEL, var = "labelHuName_", options = {text = "", size = 28, font = DEFAULT_FONT, color = cc.c3b(255, 255, 255)},
                    x = 45, ppy = 0.78, ap = {0, 0.5}},
                {type = TYPES.SPRITE, var = "spriteHu_", filename = "res/images/majiang/round_over/jiepao.png", ppx = 0.75, ppy = 0.5, scale = 1},
                {type = TYPES.NODE, var = "nodeCards_", ppy = 0.4},
                {type = TYPES.SPRITE, var = "spriteDeFen_", filename = "res/images/majiang/round_over/bjdf_ying.png", ppx = 0.84, ppy = 0.73, ap = {0, 1}},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelWinScore_", filename = "fonts/js_ying.png", options = {w = 19, h = 26, startChar = "0"}, ppx = 0.91, ppy = 0.7, ap = {0, 1}},
                {type = gailun.TYPES.LABEL_ATLAS, var = "labelLoseScore_", filename = "fonts/js_shu.png", options = {w = 18, h = 26, startChar = "-"}, ppx = 0.91, ppy = 0.7, ap = {0, 1}},
                {type = TYPES.SPRITE, var = "spriteZhongNiao_", filename = "res/images/majiang/round_over/zhongniao2.png", ppx = 0.79, ppy = 0.26, ap = {0, 0.5}},
                }, 
                x = display.cx + adjust_x, y = display.cy
            },
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView", x = head_x, y = display.cy},
            {type = TYPES.SPRITE, var = "spriteChipsBg_", filename = "res/images/majiang/game/score-bg.png", x = head_x + 2, y = display.cy - 54, scale9 = true, size = {116, 30}, children = {
                {type = TYPES.SPRITE, filename = "res/images/majiang/game/score-bg1.png", x = 10, ppy = 0.5},
                {type = TYPES.LABEL_ATLAS, var = "labelScore_", filename = "fonts/game_score.png", options = {text="", w = 14, h = 35, startChar = "-"}, ppy = 0.34, ppx = 0.5, ap = {0.5, 0.5}},
                {type = TYPES.LABEL, var = "niaoShu_",  options = {text = "12", size = 22, font = DEFAULT_FONT, lign = cc.TEXT_ALIGNMENT_CENTER, color = cc.c3b(255, 255, 255)}, x = display.width - 100, ppy = 0.5, ap = {0.5, 0.5}},

            },scale = 1.2},
            {type = TYPES.LABEL, var = "labelNickName_", options = {text = "", size = 22, font = DEFAULT_FONT, lign = cc.TEXT_ALIGNMENT_CENTER, color = cc.c3b(255, 255, 255)}, x = head_x, y = display.cy + 60, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteZhuang_", filename = "res/images/majiang/game/banker_flag.png", x = head_x - 38, y = display.cy + 30,},
            {type = TYPES.SPRITE, var = "spriteChui_", x = head_x + 58, y = display.cy + 30,},
        }, size = nodeSize, ap = {0.5, 0.5} , x = 0, y = 0 }
    }
}

local atlas_win = {type = gailun.TYPES.LABEL_ATLAS, filename = "fonts/scorewin.png", options = {w = 20, h = 27, startChar = "+"}, ap = {0, 1}}
local atlas_lose = {type = gailun.TYPES.LABEL_ATLAS, filename = "fonts/scorelose.png", options = {w = 20, h = 27, startChar = "+"}, ap = {0, 1}}

local COLOR_ZHUANG = cc.c4b(255, 215, 73, 255)
local COLOR_XIAN = cc.c4b(255, 255, 255, 255)

function GameResultItemView:ctor(params, showData)
    GameResultItemView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self:initView_(params, showData)
        local resources = {
        {"textures/game_anims.plist", "textures/game_anims.png", },
    }
    gailun.AsyncLoader.loadRes(resources)
end

function GameResultItemView:initView_(params, showData)
    self.startX_ = 20
    -- self.labelFan_:setString(string.format("%d番", params.score))
    self.labelFanNum_:setString(params.score)
    self.labelFanNum_:setVisible(false)
    self.avatar_:showWithUrl(params.avatar)
    if params.chui == 2 then
        self.spriteChui_:show()
    else
        self.spriteChui_:hide()
    end
    local tmpLabel = nil
    if checknumber(params.scoreFrom.score) >= 0 then
        self.labelWinScore_:setVisible(true)
        self.labelLoseScore_:setVisible(false)
        self.labelWinScore_:setString(checknumber(params.scoreFrom.score))
        tmpLabel = self.labelWinScore_
    else
        self.labelWinScore_:setVisible(false)
        self.labelLoseScore_:setVisible(true)
        self.labelLoseScore_:setString(checknumber(params.scoreFrom.score))
        self.spriteDeFen_:setTexture("res/images/majiang/round_over/bjdf_shu.png")
        tmpLabel = self.labelLoseScore_
    end
    local size0 = self.bg_:getContentSize()
    local size1 = self.spriteDeFen_:getContentSize()
    local size2 = tmpLabel:getContentSize()
    local w = size1.width + size2.width + 5
    local ax = (236 - w) / 2

    -- self.spriteDeFen_:setPositionX(size0.width * 0.785)
    -- tmpLabel:setPositionX(size0.width * 0.94)
    -- local x1, y1 = self.spriteDeFen_:getPosition()
    -- self.spriteDeFen_:setPositionX(x1 + ax)
    -- tmpLabel:setPositionX(size1.width + x1 + ax + 5)


    -- self.spriteHu_:setVisible(params.huType ~= nil)
    self.spriteZhuang_:setVisible(params.isZhuang == true)
    if params.isZhuang then
        self.labelNickName_:setTextColor(COLOR_ZHUANG)
    else
        self.labelNickName_:setTextColor(COLOR_XIAN)
    end

    local winner = checktable(showData.winner)
    local isWin = false
    for i=1,#winner do
        if winner[i] == params.seatID then
            isWin = true
            break
        end
    end

    self:showWaiPai_(params.tableCards)

    self.labelHuName_:setPositionX(45)
    self:initHuName_(params.scoreFrom)
    self:showHandCards_(params, showData)
    self.labelNickName_:setString(params.nickName or '')
    self.labelScore_:setString(params.totalScore)

    self:showHuType_(params, showData)
    self:showBirds_(params, showData, isWin)
end

-- mingGang = 1,
-- anGang = 2,
-- fangGang = -1,
-- jieGang = 1,
-- fangPao = 1,
-- jiePao = 1,
local showList = {
    ziMo = "自摸%+d",
    jiePao = "接炮%+d",
    qiangGangHu = "抢杠胡%+d",
    fangPao = "放炮%+d",
    anGang = "暗杠%+d",
    mingGang = "明杠%+d",
    jieGang = "接杠%+d",
    fangGang = "放杠%+d",
    haveGang = "杠底%+d",
    zhuangXian = "庄闲%+d",
    zhongNiao = "抓鸟%+d",
    piaoScore = "飘%+d",
    qingYiSe = "清一色%+d",
    sevenPairs = "七小对%+d",
    _13Yao = "十三幺%+d",
    pengPengHu = "碰碰胡%+d",
    jiangJiangHu = "将将胡%+d",
    gangShangPao = "杠上炮%+d",
    gangShangHua = "杠上花%+d",
    danSeYiZhiHua = "单色一枝花%+d",
    jiangYiZhiHua = "将一枝花%+d",
    yiZhiNiao = "一只鸟%+d",
    sanTong = "三同%+d",
    jieJieGao = "节节高%+d",
    qiShouSiZhang = "起手四喜%+d",
    zhongTuSiZhang = "中途四喜%+d",
    zhongTuLiuLiuShun = "中途六六顺%+d",
    quanQiuRen = "全求人%+d",
    tianHu = "天胡%+d",
    diHu = "地胡%+d",
    haiDi = "海底%+d",
    liuLiuShun = "六六顺%+d",
    queYiSe = "缺一色%+d",
    banBanHu = "板板胡%+d",
    longQiDui = "龙七对%+d",
    piao = "飘分%+d",
    men_qing = "门清%+d"
    -- piao = "飘分%+d",
}

function GameResultItemView:initHuName_(params)
    if not params then
        return self.labelHuName_:setString("")
    end
    local list = {}

    if params.ming_tang then
        for _,v in pairs(params.ming_tang) do
            local key = v[1]
            local score = v[2]
            if showList[key] ~= nil then
                if key == "fangPao" and score > 0 then
                    key = "jiePao"
                end
                table.insert(list, string.format(showList[key], score))
            end
        end
    else
        for k,str in pairs(showList) do
            if params[k] ~= nil then
                local tmp = tostring(params[k])
                if params[k] > 0 then
                    tmp = "+" .. tostring(params[k])
                end
                table.insert(list, string.format(str, tmp))
            end
        end
    end
    if #list < 1 then
        return
    end

    if params.is_dian_zhuang then
        table.insert(list, 1, "点庄")
    end

    self.labelHuName_:setString(table.concat(list, "  "))
end

function GameResultItemView:showWaiPai_(data)
    if not data then
        return
    end
    if #data > 0 then
        self.startX_ = self.startX_ + 8
    end
    local startX_ = self.startX_
    for i,v in ipairs(data) do
        local x, y = startX_, -5
        local ty = data[i][1]
        table.remove(data[i], 1)
        for j, card in ipairs(data[i]) do
            local tmpX
            local tmpY =  y
            if j < 4 then
                x = x + 42
                tmpX = x
            else
                tmpX = x - 42
                tmpY = tmpY + 16
            end
            
            if ty == CSMJ_ACTIONS.AN_GANG and j <= 3 then
                card = 0
            end

            app:createConcreteView("MaJiangView", card, MJ_TABLE_DIRECTION.BOTTOM, true):pos(tmpX, tmpY):addTo(self.nodeCards_):scale(0.7)
        end
        startX_ = x + 20
    end
    if #data > 0 then
        startX_ = startX_ - 5
    end
    self.startX_ = startX_
end

function GameResultItemView:showHandCards_(params, showData)
    local data = params.handCards
    local huCards
    local num = -1
    local tmpTb = {}
    for i = 1, #showData.winInfo do
        if showData.winInfo[i].winner == params.seatID then
            huCards = checktable(clone(showData.winInfo[i].huCards))
            if #huCards == 0 or (huCards and huCards[1] == 0) then
                huCards = nil
            end
            data = checktable(clone(showData.winInfo[i].handCards))
            break
        end
    end
    if not data then
        return
    end

    -- if not huCards then
    BaseAlgorithm.sort(data)
    -- end


    for i = 1, #data do
        local v = data[i]
        if i == num + 1 then
            self.startX_ = self.startX_ + 65
        else
            self.startX_ = self.startX_ + 49
        end
        
        app:createConcreteView("MaJiangView", v, MJ_TABLE_DIRECTION.BOTTOM, false):pos(self.startX_, 0):addTo(self.nodeCards_):scale(cardScale)
    end
    if huCards and #huCards >0 then
        self.startX_ = self.startX_ + 65
        for i=1, #huCards do
            app:createConcreteView("MaJiangView", huCards[i], MJ_TABLE_DIRECTION.BOTTOM, false):pos(self.startX_, 0):addTo(self.nodeCards_):scale(cardScale)
            self.startX_ = self.startX_ + 49
        end
    end
end

function GameResultItemView:adjustByX(x)
    local x = x + 120
    self.labelFan_:setPositionX(x)
    self.labelFanNum_:setPositionX(x + 60)
    self.spriteHu_:setPositionX(x + 150)
end

function GameResultItemView:getMaJiangX()
    return self.startX_
end

function GameResultItemView:showHuType_(params, showData)
    if showData.action == CSMJ_ACTIONS.ZI_MO then
        if params.scoreFrom.ziMo and params.scoreFrom.ziMo > 0 then
            self.spriteHu_:setTexture("res/images/majiang/round_over/zimo.png")
        else
            self.spriteHu_:hide()
        end
    elseif showData.action == CSMJ_ACTIONS.QIANG_GANG_HU then
        if params.scoreFrom.qiangGangHu and params.scoreFrom.qiangGangHu > 0 then
            self.spriteHu_:setTexture("res/images/majiang/round_over/qiangganghu.png")
        else
            self.spriteHu_:hide()
        end
    elseif showData.action == CSMJ_ACTIONS.CHI_HU then
        if params.scoreFrom and params.scoreFrom.fangPao then
            if params.scoreFrom.fangPao < 0 then
                self.spriteHu_:setTexture("res/images/majiang/round_over/fangpao.png")
            elseif params.scoreFrom.fangPao == 0 then
                self.spriteHu_:hide()
            end
        elseif params.scoreFrom and params.scoreFrom.jiePao then
            if params.scoreFrom.jiePao > 0 then
            else
                self.spriteHu_:hide()
            end
        else
            self.spriteHu_:hide()
        end
    else
        self.spriteHu_:hide()
    end
end

local isZiMo = true
local isSortBird = true
local isTongPao = true
local jiePaoIndex = {2, 1}
local fangPaoIndex = 4

function GameResultItemView:showBirds_(params, showData, isWin) 
    local configdata = showData.tableController_:getTable():getConfigData()
    local zhuangIndex = showData.zhuangIndex
    local zhuangType = configdata.ruleDetails.zhuangType
    local fixDealer = params.fixDealer
    isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex = BaseAlgorithm.getZhongNiaoParams(showData.tableController_:getHuInfo())
    local index1
    local player = showData.tableController_:getPlayerBySeatID(params.seatID)

    local fixDealerIndex = params.fixDealerIndex

    if player then
        index1 = player:getIndex()
    end
    local space = 32
    local size = self.bg_:getContentSize()
    local y = 0.25 * size.height
    local index = 1
    local maJiangs = {}
    local playerCount = configdata.ruleDetails.totalSeat
    -- local isSortBird = true
    if not isSortBird then
        playerCount = 4
    end
    if showData.oneBrid then
        for i,v in ipairs(showData.winInfo) do
            if showData.seatID == v.winner then
                local maJiang
                for i,v in ipairs(showData.birds) do
                    local index = showData.tableController_:getPlayerBySeatID(showData.seatID):getIndex()
                    local x = 0.83 * size.width
                    maJiang = app:createConcreteView("MaJiangView", v, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.bg_):pos(x, y)
                    maJiang:scale(0.6)
                    table.insert(maJiangs, maJiang)
                    maJiang:focusOn()
                    self.spriteZhongNiao_:setTexture("res/images/majiang/round_over/zhongniao1.png")
                end
            end
        end
    else
        for i,v in ipairs(showData.birds) do
            local ret, birdShunXu, startSeatID = BaseAlgorithm.isBird(v, isZiMo, isSortBird, isTongPao, jiePaoIndex, fangPaoIndex, zhuangIndex, zhuangType,playerCount)
            local tmpIndex
            for j=1, #birdShunXu do
                if birdShunXu[j](v, startSeatID, playerCount) then
                    local index = showData.tableController_:getPlayerBySeatID(j):getIndex()
                    tmpIndex = index
                    break
                end
            end
    
            local maJiang
            if tmpIndex == index1 then
                local x = 0.83 * size.width + (index - 1) * space
                index = index + 1
                maJiang = app:createConcreteView("MaJiangView", v, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.bg_):pos(x, y)
                maJiang:scale(0.6)
                table.insert(maJiangs, maJiang)
            end
    
            if maJiang then
                if ret then
                    maJiang:focusOn()
                    self.spriteZhongNiao_:setTexture("res/images/majiang/round_over/zhongniao1.png")
                else
                    maJiang:focusOff()
                end
            end
        end
    end
    if #maJiangs > 0 then
        local w = #maJiangs * space
        local ax = (195 - w) / 2
        for i = 1,#maJiangs do
            local x, y = maJiangs[i]:getPosition()
            maJiangs[i]:pos(x + ax, y)
        end
    end
end

return GameResultItemView
