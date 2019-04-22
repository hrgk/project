local GameOverItemView = class("GameOVerItemView", gailun.BaseView)
local csbPath =  "views/games/datongzi/roundOver/gameOverItem.csb"

function GameOverItemView:ctor(data)
    self.csbNode = cc.uiloader:load(csbPath)
    self:addChild(self.csbNode,1000)
    self:setMemberVariable_()
    self:initHeadImg_(data.avatar, data.nickName)
    self:initLabel(data)
end

function GameOverItemView:setMemberVariable_()
    local nodeName = {"juShuNum_","kTongZiCount_", "ATongZiCount_","TongZi2Count_", "TongZi2Score_",
                        "ATongZiScore_", "KTongZiScore_","diZhaScore_","paiMianScore_","zongScore_","shengFuScore_"}
    for k,v in pairs(nodeName) do
        self[v]= UIHelp.seekNodeByNameEx(self.csbNode, v)
    end
end

--分数等label
function GameOverItemView:initLabel(data)
    local juShuNum_ = display.newBMFontLabel({
                text = display:getRunningScene():getTable():getRoundId().."局",
                font = "fonts/dtzjf.fnt",
                })
    self.juShuNum_:addChild(juShuNum_)
    local juShuNum_ = display.newBMFontLabel({
                text = data.cardK,
                font = "fonts/dtzx.fnt",
                })
    self.kTongZiCount_:addChild(juShuNum_)

    local juShuNum_ = display.newBMFontLabel({
                text = data.cardA,
                font = "fonts/dtzx.fnt",
                })
    self.ATongZiCount_:addChild(juShuNum_)

    local juShuNum_ = display.newBMFontLabel({
                text = data.card2,
                font = "fonts/dtzx.fnt",
                })
    self.TongZi2Count_:addChild(juShuNum_)

    self.KTongZiScore_:setString(data.cardKScore)
    self.ATongZiScore_:setString(data.cardAScore)
    self.TongZi2Score_:setString(data.card2Score)


    local juShuNum_ = display.newBMFontLabel({
                text = data.bombScore,
                font = "fonts/dtzy.fnt",
                })
    self.diZhaScore_:addChild(juShuNum_)
    local juShuNum_ = display.newBMFontLabel({
                text = data.score,
                font = "fonts/dtzy.fnt",
                })

    self.paiMianScore_:addChild(juShuNum_)

    if data.totalScore >= 0 then
        local zongScore_ = display.newBMFontLabel({
                    text = "+"..data.totalScore,
                    font = "fonts/dtzzy.fnt",
                    })
        zongScore_:setAnchorPoint(cc.p(0.5, 0.5))
        self.zongScore_:getParent():addChild(zongScore_)
        zongScore_:setPosition(cc.p(self.zongScore_:getPositionX(),self.zongScore_:getPositionY()+20))
        if data.overBonus > 0 then
            local zhongjuScore = display.newBMFontLabel({
                    text = "+"..data.overBonus,
                    font = "fonts/dtzzy.fnt",
                        })
            zhongjuScore:setAnchorPoint(cc.p(0.5, 0.5))
            self.zongScore_:getParent():addChild(zhongjuScore)
            zhongjuScore:setPosition(cc.p(self.zongScore_:getPositionX()-10,self.zongScore_:getPositionY()-20))
            zhongjuScore:setScale(0.5)
        end

    else
        local zongScore_ = display.newBMFontLabel({
                    text = ""..data.totalScore,
                    font = "fonts/dtzzs.fnt",
                    })
        zongScore_:setAnchorPoint(cc.p(0.5, 0.5))
        self.zongScore_:getParent():addChild(zongScore_)
        zongScore_:setPosition(self.zongScore_:getPosition())
    end
    if data.victoryScore > 0 then
        local shengFuScore_ = display.newBMFontLabel({
                    text = "+"..data.victoryScore,
                    font = "fonts/dtzzy.fnt",
                    })
        shengFuScore_:setAnchorPoint(cc.p(0.5, 0.5))
        self.shengFuScore_:getParent():addChild(shengFuScore_)
        shengFuScore_:setPosition(cc.p(self.shengFuScore_:getPositionX(),self.shengFuScore_:getPositionY() + 20))

        local score_ = "(正"..data.victoryScore / 100 .. "级)"
        local labelInfo_ = display.newTTFLabel({
            text = score_,
            size = 32,
            x = 0,
            y = -20,
            color = cc.c3b(77,36,21),
            align = cc.ui.TEXT_ALIGN_LEFT,})
        :addTo(self.shengFuScore_)
    else
        local shengFuScore_ = display.newBMFontLabel({
                    text = ""..data.victoryScore,
                    font = "fonts/dtzzs.fnt",
                    })
        shengFuScore_:setAnchorPoint(cc.p(0.5, 0.5))
        self.shengFuScore_:getParent():addChild(shengFuScore_)
        shengFuScore_:setPosition(cc.p(self.shengFuScore_:getPositionX(),self.shengFuScore_:getPositionY() + 20))

        local score_ = "(负"..data.victoryScore / 100 .. "级)"
        local labelInfo_ = display.newTTFLabel({
            text = score_,
            size = 32,
            x = 0,
            y = -20,
            color = cc.c3b(77,36,21),
            align = cc.ui.TEXT_ALIGN_LEFT,})
        :addTo(self.shengFuScore_)
    end

end

--头像
function GameOverItemView:initHeadImg_(avatar, nickName)
    local txkPath = "res/images/common/smallTouXiangKuang.png"
    local maskPath = "res/images/common/samllMengCeng.png"
    local avatar_ = require("app.views.AvatarView").new(nil, txkPath, maskPath, 0.5)
    self.csbNode:addChild(avatar_,100)
    avatar_:setPosition(cc.p(75,85))
    avatar_:showWithUrl(avatar)
    -- local spriteNickName_ = display.newSprite("res/images/common/zuanshi_bg.png")
    --     :addTo(avatar_):pos(0, -50)
    local label_ = display.newTTFLabel({
        text = gailun.utf8.formatNickName(nickName, 8, '...'),
        size = 24,
        x = 75,
        y = 30,
        color = cc.c3b(122,69,16),
        align = cc.ui.TEXT_ALIGN_CENTER,
        })
    :addTo(self.csbNode)
    -- label_:pos()
end

return GameOverItemView
