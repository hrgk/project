local BaseView = import("app.views.BaseView")
local RoundOverView = class("RoundOverView", BaseView)
local FaceAnimationsData = require("app.data.FaceAnimationsData")
local TaskQueue = require("app.controllers.TaskQueue")
local PokerListView = import("app.games.dao13.views.game.PokerListView")

function RoundOverView:ctor(data,ruleInfo)
    dump(data,"RoundOverView:ctor")
    RoundOverView.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self:initData_(data.seats,ruleInfo)
end

function RoundOverView:initData_(seats,ruleInfo)
    self.typeInfo = {"散牌","对子","两对","三条","顺子","同花",
        "葫芦","炸弹","同花顺","三顺子","三同花","半小","六对半",
        "五对三条","四套三条","凑一色","全小","全大","三套炸弹",
        "三同花顺","十二皇族","十三道","至尊青龙"
    }
    local showBiCard = true
    for i = 1,4 do
        if seats[i] then
            local showCards = clone(seats[i].cards)
            if #showCards ~= 13 then
                showBiCard = false
                break
            end
        end
    end
    local date = nil
    if ruleInfo and type(ruleInfo) == "table" then
        date = ruleInfo
    else
        date = display.getRunningScene():getTable():getConfigData()
    end
    local needTipCard = -99
    if date.config.rules.maPai == 1 then
        needTipCard = 410
    end
    dump(needTipCard,"self.needTipCardself.needTipCard")
    self.ztjsTip_:setVisible(not showBiCard)
    for i= 1, 4 do
        if seats[i] then
            dump(seats[i],"seats[i]seats[i]seats[i]")
            local showCards = clone(seats[i].cards)
            if showBiCard then
                local handPokerList_ = PokerListView.new(needTipCard):addTo(self["user" .. i .. "_"])
                handPokerList_:pos(230,40)
                handPokerList_:setScale(0.45)
                table.insert(showCards,4,-1)
                table.insert(showCards,4,-1)
                table.insert(showCards,4,-1)
                table.insert(showCards,4,-1)
                table.insert(showCards,13,-1)
                table.insert(showCards,13,-1)
                table.insert(showCards,13,-1)
                table.insert(showCards,13,-1)
                handPokerList_:showPokersWithoutAnim_(showCards,false)
                if seats[i].specialType > 0 then
                    self["user" .. i .. "tsFont_"]:setString(self.typeInfo[seats[i].specialType]):show()
                else
                    if seats[i].type[1] then
                        self["user" .. i .. "daoFont1_"]:setString(self.typeInfo[seats[i].type[2].first[1]]):show()
                        self["user" .. i .. "daoFont2_"]:setString(self.typeInfo[seats[i].type[2].second[1]]):show()
                        self["user" .. i .. "daoFont3_"]:setString(self.typeInfo[seats[i].type[2].third[1]]):show()
                    end
                end
            end
            self["user" .. i .. "_"]:show()
            self["user" .. i .. "nick_"]:setString(seats[i].nickName)
            if seats[i].xiaoFen > 0 then
                self["user" .. i .. "xFen_"]:setString("+" .. seats[i].xiaoFen)
                self["user" .. i .. "xFen_"]:setColor(cc.c3b(216, 116, 66))
            else
                self["user" .. i .. "xFen_"]:setString(seats[i].xiaoFen)
            end
            local tsScore = seats[i].score - seats[i].xiaoFen
            if tsScore > 0 then
                self["user" .. i .. "tsFen_"]:setString("+" .. tsScore)
                self["user" .. i .. "tsFen_"]:setColor(cc.c3b(216, 116, 66))
            else
                self["user" .. i .. "tsFen_"]:setString(tsScore)
            end
            if seats[i].score > 0 then
                local jiFen = cc.LabelBMFont:create("+" .. seats[i].score, "fonts/pzyn.fnt")
                self["user" .. i .. "_"]:addChild(jiFen)
                jiFen:setPosition(1030,65)
            else
                local jiFen = cc.LabelBMFont:create(seats[i].score, "fonts/pzsn.fnt")
                self["user" .. i .. "_"]:addChild(jiFen)
                jiFen:setPosition(1030,65)
            end
            if seats[i].isZhuang then
                self["user" .. i .. "zhang_"]:show()
            end
        else
            self["user" .. i .. "_"]:hide()
        end
    end
end

function RoundOverView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/d13/roundOver.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

return RoundOverView 
