local BaseElement = import("app.views.BaseElement")
local GameOverItemView = class("GameOverItemView", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
function GameOverItemView:ctor()
    GameOverItemView.super.ctor(self)
end

function GameOverItemView:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

function GameOverItemView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/ldfpf/gameOverItem.csb"):addTo(self)
end

function GameOverItemView:update(data,dismissSeat,matchDifen,gameDifen)
    self.data_ = data
    dump(self.data_,"GameOverItemView:update")
    self:initHead_()
    self.fangzhu_:setVisible(data.isFangZhu)
    self.dayingjia_:setVisible(data.isDaYingJia)
    local clockScore = display.getRunningScene():getLockScore()
    if data.seatID == dismissSeat then
        self.jsfTag_:show()
    end
   

    if data.totalScore > 0 then
        self.winbg_:show()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/pzy.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-200)
        self.matchScore_:setColor(cc.c3b(128, 59, 13))
        self.title1_:setColor(cc.c3b(130, 99, 60))
        self.title2_:setColor(cc.c3b(130, 99, 60))
        self.title3_:setColor(cc.c3b(130, 99, 60))
        self.title4_:setColor(cc.c3b(130, 99, 60))
        self.title5_:setColor(cc.c3b(130, 99, 60))
        self.title6_:setColor(cc.c3b(130, 99, 60))
        self.Num1_:setColor(cc.c3b(134, 67, 22))
        self.Num2_:setColor(cc.c3b(134, 67, 22))
        self.Num3_:setColor(cc.c3b(134, 67, 22))
        self.Num4_:setColor(cc.c3b(134, 67, 22))
        self.Num5_:setColor(cc.c3b(134, 67, 22))
        self.Num6_:setColor(cc.c3b(134, 67, 22))
    elseif data.totalScore <=0 then
        self.losebg_:show()
        local jiFen = cc.LabelBMFont:create(self.data_.totalScore, "fonts/pzs.fnt")
        self.csbNode_:addChild(jiFen)
        jiFen:setPosition(0,-200)
        self.matchScore_:setColor(cc.c3b(17, 94, 159))
        self.title1_:setColor(cc.c3b(57, 94, 76))
        self.title2_:setColor(cc.c3b(57, 94, 76))
        self.title3_:setColor(cc.c3b(57, 94, 76))
        self.title4_:setColor(cc.c3b(57, 94, 76))
        self.title5_:setColor(cc.c3b(57, 94, 76))
        self.title6_:setColor(cc.c3b(57, 94, 76))
        self.Num1_:setColor(cc.c3b(45, 108, 165))
        self.Num2_:setColor(cc.c3b(45, 108, 165))
        self.Num3_:setColor(cc.c3b(45, 108, 165))
        self.Num4_:setColor(cc.c3b(45, 108, 165))
        self.Num5_:setColor(cc.c3b(45, 108, 165))
        self.Num6_:setColor(cc.c3b(45, 108, 165))
    end

    local roundScores = data.roundScores
    if #roundScores < 7 then
         for i =1,6 do
             if roundScores[i] then
                 self["Num"..tostring(i).."_"]:setString(tostring(roundScores[i]))
             else
                 self["Num"..tostring(i).."_"]:setString("---")
             end
         end
    else
        local length = #roundScores
        for i =6,1,-1 do
            self["title"..tostring(i).."_"]:setString("第"..tostring(length).."局")
            self["Num"..tostring(i).."_"]:setString(tostring(roundScores[length]))
            length = length - 1
        end
    end

    if clockScore > 0 then
        self.matchScore_:setString("总积分:" .. (data.matchScore+self.data_.totalScore))
    end
    self.name_:setString(data.nickName)
    self.totalHuXi_:setString("总胡息："..data.totalHuxi)
    self.id_:setString(data.uid)
end

return GameOverItemView
