local BaseView = import("app.views.BaseView")
local UserInfoView = class("UserInfoView", BaseView)
local PlayerHead = import("app.views.PlayerHead")

function UserInfoView:ctor(data, gameType)
    self.data_ = data
    self.gameType_ = gameType
    UserInfoView.super.ctor(self)
    self:initHead_()
    self.name_:setString(data.nickName)
    self.ID_:setString(data.uid)
    self.JF_:setString(selfData:getScore())
    self.IP_:setString(selfData:getIP())
    self.Adr_:setString("未知")
    self.JS_:setString(selfData:getRoundCount())
    self.Time_:setString(os.date("%Y-%m-%d",selfData:getLoginTime()))
    for i = 1,selfData:getRateScore() do
        self["star" .. i .. "_"]:show()
    end
    if data.sex == 1 then
        self.female_:hide()
        self.male_:show()
    else
        self.male_:hide()
        self.female_:show()
    end
    -- self:getAddr()
    self.Adr_:setString(selfData:getAddress())
end

-- function UserInfoView:getAddr()
--     local inf = dataCenter:getLocationInfo()
--     if inf[1] == "181" and inf[2] == "91" then
--         return 
--     end
  
--     local url = string.format("https://apis.map.qq.com/ws/geocoder/v1/?location=%s,%s&key=YUMBZ-ZLUWI-DLMGN-5WYKA-PLAKO-44B4J&get_poi=1",inf[2],inf[1])
--     local http = require "loader.http"
--     http.get(
--         url,
--         function (event)
--             local info = json.decode(event)
--             if info.status ~= 0 then
--                 return
--             end
--             self.Adr_:setString(info.result.address)
--         end,
--         function ()
--         end
--     )
-- end

function UserInfoView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/userInfo/userInfoView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function UserInfoView:initHead_()
    local view = PlayerHead.new(nil, true)
    view:setNode(self.head_)
    if self.data_ == nil then
        return
    end
    view:showWithUrl(self.data_.avatar)
end

function UserInfoView:erweimaHandler_()
    local Sing = crypto.encodeBase64(json.encode(selfData:getUid()))
    local url = "http://yt.jingangdp.com/Login/UploadQcode?Sing=" .. Sing
    device.openURL(url)
end


return UserInfoView 
