local RoundOverItemView = class("RoundOverItemView", gailun.BaseView)
local DtzAlgorithm = require("app.games.datongzi.utils.DtzAlgorithm")


local COLOR_XIAN = cc.c4b(255, 255, 255, 255)
local BG_WIDTH, BG_HEIGHT = 1068, 182
local csbPath = "views/games/datongzi/roundOver/roundOverItem.csb"
function RoundOverItemView:ctor(params)
    RoundOverItemView.super.ctor(self)
    self.csbNode = cc.uiloader:load(csbPath)
    self:addChild(self.csbNode,1000)
    self:initUI(params)
end

function RoundOverItemView:initUI(data)
    self:setMemberVariable_()
    self:initHeadImg_(data.avatar, data.nickName)
    self:initRank_(data.rank, data.isLiangRen)
    self:initScore_(data)
    self:createHandCards_(data.handCards)
end

function RoundOverItemView:setMemberVariable_()
    local nodeName = {"score_","textScore5_", "textScore5_1","textScore10_", "textScore10_1",
                        "textScoreK_", "textScoreK_1","textScoreTong_","textScoreTong_1","textScoreXi_","textScoreXi_1",
                        "textScoreZha_","textScoreZha_1", "scoreMingXi_"}
    for k,v in pairs(nodeName) do
        self[v]= UIHelp.seekNodeByNameEx(self.csbNode, v)
    end
end

--创建手牌
function RoundOverItemView:createHandCards_(handCards)
    local SmallPokerView = import("app.views.game.SmallPokerView")
    -- local PokerView = require("app.views.game.PokerView")
    local spaceX = 15
    local startX = 830
    local startY = 110
    local startY1 = 70
    local startY2 = 30
    local scale_ = 0.8
    local tempCards = {}
    if handCards and #handCards > 0 then
        tempCards  = DtzAlgorithm.sort(1,handCards)
    end
     
    for i=1,#tempCards do
        -- local poker = PokerView.new(handCards[i])
        local poker = SmallPokerView.new(handCards[i])
        poker:setScale(scale_)
        if i <= 15 then
            UIHelp.seekNodeByNameEx(self.csbNode, "bg_"):addChild(poker, 1)
            poker:setPosition(cc.p(startX+(i-1)*spaceX, startY))
        elseif i <= 30 then
            UIHelp.seekNodeByNameEx(self.csbNode, "bg_"):addChild(poker, 2)
            poker:setPosition(cc.p(startX+(i-16)*spaceX, startY1))
        else
            UIHelp.seekNodeByNameEx(self.csbNode, "bg_"):addChild(poker, 3)
            poker:setPosition(cc.p(startX+(i-31)*spaceX, startY2))
        end

    end
end

--分数
function RoundOverItemView:initScore_(data)
    self.score_:setString(data.totalScore)
    self.textScore5_:setString("x"..data.card5Count)
    self.textScore5_1:setString(data.card5Score)
    self.textScore10_:setString("x"..data.card10Count)
    self.textScore10_1:setString(data.card10Score)
    self.textScoreK_:setString("x"..data.cardKCount)
    self.textScoreK_1:setString(data.cardKScore)
    self.textScoreTong_:setString("x"..data.tongPaiCount)
    self.textScoreTong_1:setString(data.tongPaiScore)
    self.textScoreXi_:setString("x"..data.xiPaiCount)
    self.textScoreXi_1:setString(data.xiPaiScore)
    self.textScoreZha_:setString("x"..data.zhaPaiCount)
    self.textScoreZha_1:setString(data.zhaPaiScore)
    if data.score > 0 then
        self.scoreMingXi_:setString("+"..data.score)
    else
        self.scoreMingXi_:setString(data.score)
    end
end

--排名
function RoundOverItemView:initRank_(rank, isLiangRen)
    local path_ = ""
    if rank == 1  then
        path_ = "res/images/datongzi/game/flag_shang_you.png"
    elseif rank == 2 then
        path_ = "res/images/datongzi/game/flag_zhong_you.png"
        if isLiangRen then
            path_ = "res/images/datongzi/game/flag_xia_you.png"
        end
    elseif rank == 3 then
        path_ = "res/images/datongzi/game/flag_xia_you.png"
    end
    if path_~= "" then
        local spriteRank_ = display.newSprite(path_):addTo(self.csbNode):pos(67, 67)
    end
end

--头像
function RoundOverItemView:initHeadImg_(avatar, nickName)
    local txkPath = "res/images/common/smallTouXiangKuang.png"
    local maskPath = "res/images/common/samllMengCeng.png"
    local avatar_ = require("app.views.AvatarView").new(nil, txkPath, maskPath, 0.5)
    UIHelp.seekNodeByNameEx(self.csbNode, "bg_"):addChild(avatar_, 100)
    avatar_:setPosition(cc.p(145, 55))
    avatar_:showWithUrl(avatar)
    -- local spriteNickName_ = display.newSprite("res/images/common/nichengtiao.png")
    -- :addTo(avatar_):pos(0, -50)
    local label_ = display.newTTFLabel({
        text = gailun.utf8.formatNickName(nickName, 8, '...'),
        size = 24,
        x = 155,
        y = 105,
        color = cc.c3b(122,69,16),
        align = cc.ui.TEXT_ALIGN_CENTER,
        })
    :addTo(self.csbNode)
end

function RoundOverItemView:initWinFlag_(params)
     local juFlag
    if params.score == 0 then
        juFlag = display.newSprite("res/images/datongzi/round_over/shengli.png")
    elseif params.score > 0 then
        juFlag = display.newSprite("res/images/datongzi/round_over/shengli.png")
    elseif params.score < 0 then
        juFlag = display.newSprite("res/images/datongzi/round_over/shiba.png")
        if params.score <= 16 then
            self.spriteGuanlong_:show()
        end
    end
    juFlag:setPositionX(1100)
    self.juStatus_:addChild(juFlag)
end

return RoundOverItemView
