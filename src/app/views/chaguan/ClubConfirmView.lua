local BaseView = import("app.views.BaseView")
local ClubConfirmView = class("ClubConfirmView", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")
local dismissRoomCMD = 92
function ClubConfirmView:ctor(data,isOwner)
    ClubConfirmView.super.ctor(self)
    self.data_ = data
    self:inIt_(isOwner)
end

function ClubConfirmView:inIt_(isOwner)
    self.setRule_:setVisible(isOwner == 1)
end

function ClubConfirmView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/confirmWindow.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ClubConfirmView:joinRoomHandler_()
    if self.data_.roomid == 0 then
        app:showTips("您的钻石不足，请及时充值!")
        return
    end
    app:showLoading("正在加入房间")
    dataCenter:sendEnterRoom(self.data_.roomid)
    self:closeHandler_()
end

function ClubConfirmView:yaoQingHandler_()
    local queRenMsg = "就缺你了"
    local playerCount = #self.data_.players
    if self.data_.ruleDetails.totalSeat == 4 then
        if playerCount == 1 then
            queRenMsg = "一缺三"
        elseif playerCount == 2 then
            queRenMsg = "二缺二"
        elseif playerCount == 3 then
            queRenMsg = "三缺一"
        end
    elseif self.data_.ruleDetails.totalSeat == 3 then
        if playerCount == 1 then
            queRenMsg = "一缺二"
        elseif playerCount == 2 then
            queRenMsg = "二缺一"
        end
    elseif self.data_.ruleDetails.totalSeat == 2 then
        if playerCount == 1 then
            queRenMsg = "缺一"
        end
    end
    local title ="速来！！" .. GAMES_NAME[self.data_.gameType] .. " 房间号【" .. self.data_.roomid .. "】"..queRenMsg
    local description = ""
    local function callback()
    end
    display.getRunningScene():shareWeiXin(title, description, 0,callback,self.data_.roomid,self.data_.owner)
end

function ClubConfirmView:dismissRoomHandler_()
    local function callback(bool)
        if bool then
            local obj = {}
            obj.roomID = self.data_.roomid
            dataCenter:sendOverSocket(dismissRoomCMD, obj)
            self:closeHandler_()
        end
    end
    app:confirm("您确定要解散房间吗？", callback)
end

function ClubConfirmView:setRuleHandler_()
    if #self.data_.playerList > 0 then
        app:showTips("正在游戏中,请稍后修改")
    elseif ChaGuanData.getSwitchModel() == 1 then
        app:showTips("大厅模式下,不可修改游戏配置.请切换至包厢模式后修改玩法")
    else
        local floorConfig = ChaGuanData.getNowFloorInfo()
        local matchType = ChaGuanData.getMatchType()
        local subFloor = self.data_.subFloor
        local clubId = ChaGuanData.getClubID()
        display.getRunningScene().layerContent_:showClubGameSetting(floorConfig, matchType, subFloor, false)
        self:closeHandler_()
    end
    
end 

return ClubConfirmView  
