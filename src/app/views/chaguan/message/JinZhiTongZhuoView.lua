local BaseView = import("app.views.BaseView")
local JinZhiTongZhuoView = class("JinZhiTongZhuoView", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function JinZhiTongZhuoView:ctor()
    JinZhiTongZhuoView.super.ctor(self)
end

function JinZhiTongZhuoView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/message/jinZhiTongZhuoView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy + 20)
end

function JinZhiTongZhuoView:user1Handler_()
    display.getRunningScene():initGameInput(function (str, isChange)
        if isChange then
            if string.len(str) > 6 then
                app:showTips("无效的用户ID")
                return string.sub(str,1,6)
            end
            return str
        end
        self.user1Uid_:setString(str)
    end)
end

function JinZhiTongZhuoView:user2Handler_()
    display.getRunningScene():initGameInput(function (str, isChange)
        if isChange then
            if string.len(str) > 6 then
                app:showTips("无效的用户ID")
                return string.sub(str,1,6)
            end
            return str
        end
        self.user2Uid_:setString(str)
    end)
end

function JinZhiTongZhuoView:blockHandler_()
    local uid1 = tonumber(self.user1Uid_:getString())
    local uid2 = tonumber(self.user2Uid_:getString())

    local clubID = ChaGuanData.getClubInfo().clubID

    httpMessage.requestClubHttp({
        clubID = clubID,
        uid1 = uid1,
        uid2 = uid2,
        status = 1
    }, httpMessage.SET_CLUB_BLOCK)
end

function JinZhiTongZhuoView:freeHandler_()
    local uid1 = tonumber(self.user1Uid_:getString())
    local uid2 = tonumber(self.user2Uid_:getString())

    local clubID = ChaGuanData.getClubInfo().clubID

    httpMessage.requestClubHttp({
        clubID = clubID,
        uid1 = uid1,
        uid2 = uid2,
        status = 0
    }, httpMessage.SET_CLUB_BLOCK)
end

return JinZhiTongZhuoView 
