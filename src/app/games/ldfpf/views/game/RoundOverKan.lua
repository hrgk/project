local RoundOverKan = class("RoundOverKan", function()
    return display.newSprite()
end)
local PaoHuZiAlgorithm = require("app.games.ldfpf.utils.PaoHuZiAlgorithm")


local kanList = {}
kanList[CTYPE_PENG] = {"res/images/paohuzi/roundOver/flagPeng.png"}
kanList[CTYPE_WEI] = {"res/images/paohuzi/roundOver/flagWei.png"}
kanList[CTYPE_PAO] = {"res/images/paohuzi/roundOver/flagPao.png"}
kanList[CTYPE_TI] = {"res/images/paohuzi/roundOver/flagTi.png"}
kanList[CTYPE_KAN_LIU] = {"res/images/paohuzi/roundOver/hongHu.png"}
kanList[0] = {"res/images/paohuzi/roundOver/flagJiang.png"}
kanList[100] = {"res/images/paohuzi/roundOver/flagKan.png"}

local fanFnt = {type = gailun.TYPES.BM_FONT_LABEL, options={text="10",UILabelType = 1,font = "res/images/paohuzi/roundOver/pjx.fnt",} , ap = {0.5, 0.5}}


function RoundOverKan:ctor(data, isHuCan)
    if not isHuCan then
        local flag
        if kanList[data[1]] then
            flag = display.newSprite(kanList[data[1]][1]):addTo(self)
        else
            flag = display.newSprite(kanList[100][1]):addTo(self)
        end
        flag:setPositionY(30)
    end
    self.cards_ = {}
    self.items_ = {}
    for i,v in ipairs(data) do
        if i ~= 1 then
            local tmp = app:createConcreteView("PaperCardView", v, 3, false, nil):addTo(self)
            tmp:setPositionY((i-1)*(-36))
            tmp:fanPai() 
            table.insert(self.cards_, v)
            table.insert(self.items_, tmp)
        end
    end

    self.huXi_ = PaoHuZiAlgorithm.calcHuXiByCtypeAndCards(data[1], self.cards_)
    self.fan_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self)
    self.fan_:setAnchorPoint(0.5,0.5)
    self.fan_:setString(self.huXi_)
    self.fan_:pos(0,-170)
end

function RoundOverKan:setHuCard(card)
    for i,v in ipairs(self.items_) do
        if card == v.card then
            local kuang = display.newSprite("res/images/paohuzi/roundOver/huaPaiXuan.png"):addTo(self)
            kuang:setPosition(v:getPosition())
            break
        end
    end
    local hu = display.newSprite("res/images/paohuzi/roundOver/shuying.png"):addTo(self)
    hu:setPosition(0, 30)
end

function RoundOverKan:getHuXi()
    return self.huXi_
end

return RoundOverKan 
