local BaseElement = import("app.views.BaseElement")
local ChaGuanListItem = class("ChaGuanListItem", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")
function ChaGuanListItem:ctor()
    ChaGuanListItem.super.ctor(self)
end

function ChaGuanListItem:initHead_()
    local head = PlayerHead.new(nil, true)
    head:setNode(self.head_)
    head:showWithUrl(self.data_.avatar)
end

function ChaGuanListItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/chaGuanListItem.csb"):addTo(self)
end

function ChaGuanListItem:enterHandler_(item)
    app:showLoading("正在进入社区")
    local params = {}
    params.clubID = self.data_.clubID
    params.floor = gameData:getClubFloor()

    ChaGuanData.setGameType(self.data_.game_type)
    httpMessage.requestClubHttp(params, httpMessage.GET_CLUB_INFO)
end

function ChaGuanListItem:showJoinRed()
    if self.data_.permission == 1 or self.data_.permission == 0 then 
        self.joinRed_:show()
    end
end

function ChaGuanListItem:update(data)
    self.data_ = data
    self:initHead_()
    self.playerCount_:setString(self.data_.nowPlayerCount)
    self.roomCount_:setString(self.data_.roomCount)
    self.nickName_:setString(self.data_.name)
    self.ID_:setString(self.data_.clubID)
    self.wxInfo_:setString("微信号：".. self.data_.wet_chat)
    self.userName_:setString(self.data_.nick_name)
    self.userID_:setString(self.data_.uid)
    local str = "已有玩法:"
    local only = {}
    for key,val in pairs(self.data_.game_type) do 
        local gameType = val
        if val.game_type then
            gameType = val.game_type
        end
        only[gameType]=1 
    end 
    for key,val in pairs(only) do
        str = str .. " " .. (GAMES_NAME[key] or "未知")
    end
    self.clubInfo_:setString(str)
    if self.data_.uid == selfData:getUid() then
        self.userTag_:show()
    end
    self.enter_:setSwallowTouches(false)  
    if self.data_.review == 1 then
        self:showJoinRed()
    end
end

return ChaGuanListItem 
 
