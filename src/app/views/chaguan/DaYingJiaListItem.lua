local BaseElement = import("app.views.BaseElement")
local DaYingJiaListItem = class("DuiZhanItem", BaseElement)
local ChaGuanData = import("app.data.ChaGuanData")

function DaYingJiaListItem:ctor()
    DaYingJiaListItem.super.ctor(self)
    self.jiFen_ = cc.LabelBMFont:create("", "fonts/win_score.fnt")
    self.jiFen_ :setPosition(245,-20)
    self.csbNode_:addChild(self.jiFen_ )
end

function DaYingJiaListItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/dayingjiaItem.csb"):addTo(self)
end

function DaYingJiaListItem:update(data, clubID)
    dump(data)
    self.data_ = data
    -- local roomInfo ="房间号：" .. data.roomID .. "    游戏时间" .. os.date("%y-%m-%d  %H:%M", data.time)
    local roomInfo ="游戏时间：" .. os.date("%y-%m-%d  %H:%M", data.time)
    -- roomInfo = roomInfo .. "    "..GAMES_NAME[data.game_type]
    self.msg_:setString(roomInfo)
    local players = json.decode(data.players)
    local names = ""
    for i,v in ipairs(players) do
        local name = gailun.utf8.formatNickName(v.nickname, 8, '...')
        names = names .. name ..","
    end
    self.gameName_:setString(GAMES_NAME[data.game_type])
    self.nickName_:setString(names)
    self.jiFen_:setString(data.score)
    if ChaGuanData.isMyClub() then
        self.qingKong_:show()
    else
        self.qingKong_:hide()
    end
end

function DaYingJiaListItem:qingKongHandler_()
    display.getRunningScene():clearDaYingJia(self.data_.id)
end

return DaYingJiaListItem
