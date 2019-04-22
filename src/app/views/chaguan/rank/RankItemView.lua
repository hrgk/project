local BaseView = import("app.views.BaseView")
local RankItemView = class("RankItemView", BaseView)
local Avatar = import("app.views.AvatarView")

function RankItemView:ctor()
    RankItemView.super.ctor(self)

    local view = Avatar.new()
    self.avatar_:addChild(view)

    self.view = view

    -- self.numberFnt_ = gailun.uihelper.createBMFontLabel("fonts/jiesuanying.fnt")
    self.numberFnt_ = cc.LabelBMFont:create("", "fonts/jiesuanying.fnt")
    self.number_:addChild(self.numberFnt_)
end

function RankItemView:updateView(data, index)
    self.nickname_:setString(data.nick_name)

    if data.game_count ~= nil then
        self.roundCount_:setString(data.game_count)
        self.typeLabel_:setString("游戏局数：")
    elseif data.count ~= nil then
        self.roundCount_:setString(data.count)
        self.typeLabel_:setString("大赢家次数：")
    end
    self.id_:setString(data.uid)

    self.view:showWithUrl(data.avatar)

    if index > 3 then
        self.one_:setVisible(false)
        self.two_:setVisible(false)
        self.three_:setVisible(false)
        self.numberFnt_:setString(index)
    elseif index == 3 then
        self.one_:setVisible(false)
        self.two_:setVisible(false)
        self.three_:setVisible(true)
        self.numberFnt_:setString("")
    elseif index == 2 then
        self.one_:setVisible(false)
        self.two_:setVisible(true)
        self.three_:setVisible(false)
        self.numberFnt_:setString("")
    elseif index == 1 then
        self.one_:setVisible(true)
        self.two_:setVisible(false)
        self.three_:setVisible(false)
        self.numberFnt_:setString("")
    end
end

function RankItemView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/rank/rankItem.csb"):addTo(self)
    self.csbNode_:setPosition(0, 0)
end

return RankItemView 
