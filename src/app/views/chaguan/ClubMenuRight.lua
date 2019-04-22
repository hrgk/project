local BaseElement = import("app.views.BaseElement")
local ChaGuanData = import("app.data.ChaGuanData")
local ClubMenuRight = class("ClubMenuRight", BaseElement)

function ClubMenuRight:ctor()
    ClubMenuRight.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
end

function ClubMenuRight:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/playerOperate.csb"):addTo(self)
end

function ClubMenuRight:setRolePermission(permission)
    if permission ~= 1 and permission ~= 0 then
        self.member_:setPositionY(self.setting_:getPositionY())
        self.setting_:hide()
        self.playConfig_:hide()
        self.memberManager_:hide()
        self.memberInfo_:hide()
        self.rank_:hide()
        self.xiaox_:hide()
        self.yqlj_:hide()
    else
        self:outHandler_()
    end
end

function ClubMenuRight:switchTop(tag)
    if tag == 0 then
        self.xiaox_:setVisible(true)
        self.memberManager_:setVisible(false)
        self.memberInfo_:setVisible(false)
        self.yqlj_:setVisible(true)
    elseif tag == 1 then
        self.memberManager_:setVisible(true)
        self.memberInfo_:setVisible(true)
        self.yqlj_:setVisible(false)
    end

    self:setRolePermission(ChaGuanData.getClubInfo().permission)
end

function ClubMenuRight:inHandler_()
    self.in_:setVisible(false)
    self.out_:setVisible(true)
    self.csbNode_:stopAllActions()
    self.csbNode_:runAction(cc.MoveTo:create(0.2, cc.p(0, 0)))
end

function ClubMenuRight:outHandler_()
    self.in_:setVisible(true)
    self.out_:setVisible(false)
    local x, y = self.csbNode_:getPosition()
    self.csbNode_:stopAllActions()
    self.csbNode_:runAction(cc.MoveTo:create(0.2, cc.p(-105, y)))
end

function ClubMenuRight:setVisibleJoinLisyRed(visible)
    self.joinRed_:setVisible(visible)
    self.outRed_:setVisible(visible)
end

function ClubMenuRight:getVisibleJoinLisyRed()
    return self.joinRed_:isVisible()
end

function ClubMenuRight:memberManagerHandler_()
    display.getRunningScene():requestClubUserDouLogs_()
end

function ClubMenuRight:memberHandler_()
    display.getRunningScene():showMMMView_()
    --display.getRunningScene():requestClubUserList_()
end

function ClubMenuRight:memberInfoHandler_()
    display.getRunningScene():requestClubUserDetailDouLogs_()
end

function ClubMenuRight:settingHandler_()
    display.getRunningScene():guanLiHandler_()
end

function ClubMenuRight:rankHandler_()
    display.getRunningScene():rankHandler_()
end

function ClubMenuRight:historyHandler_()
    display.getRunningScene():zhanjiHandler_()
end

function ClubMenuRight:shenQingHandler_()
    display.getRunningScene():cksqHandler_()
end

function ClubMenuRight:xiaoxHandler_()
    display.getRunningScene():getMessageList(0)
end

function ClubMenuRight:setPlayConfigCallback(callback)
    self.playConfigCallback = callback
end

function ClubMenuRight:playConfigHandler_()
    self.playConfigCallback()
end

function ClubMenuRight:yqljHandler_()
    local function callback()
    end
    display.getRunningScene():clubInvitation("俱乐部邀请",selfData:getNickName() .. "邀请您加入" .. ChaGuanData.getClubName(),callback,selfData:getUid(),ChaGuanData.getClubID())
end

return ClubMenuRight