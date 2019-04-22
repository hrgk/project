local BaseView = import("app.views.BaseView")
local NaoZhong = import("app.views.game.NaoZhong")

local DismissRoomView = class("DismissRoomView", BaseView)
function DismissRoomView:ctor()
    DismissRoomView.super.ctor(self)
    self:initNaoZhong_()
    self.close_:hide()
end

function DismissRoomView:setUserNames(yesNames, noNames, myIsAgree, myIsRefuse)
    local msg = "玩家："
    for i,v in ipairs(yesNames) do
        if i ~= #yesNames then
            msg = msg .. "【" .. v .. "】" .. "、"
        else
            msg = msg .. "【" .. v .. "】"
        end
    end
    msg = msg .. "同意解散游戏\n\n"
    for i,v in ipairs(noNames) do
        if i ~= #noNames then
            msg = msg .. "【" .. v .. "】" .. "、"
        else
            msg = msg .. "【" .. v .. "】"
        end
    end
    if #noNames > 0 then
        msg = msg .. "玩家："
        msg = msg .. "不同意解散游戏\n\n"
    end
    if myIsAgree then
        self.agree_:hide()
        self.refuse_:hide()
        msg = msg .. "您已同意，请等待其他玩家选择"
    elseif myIsRefuse then
        self.agree_:hide()
        self.refuse_:hide()
        msg = msg .. "您已拒绝，请等待其他玩家选择"
    else
        msg = msg .. "请选择是否同意解散游戏"
    end
    self.names_:setString(msg)
end

function DismissRoomView:startTime(num)
    self.naoZhongController_:setTimer(num)
end

function DismissRoomView:initNaoZhong_()
    if self.naoZhong_ then
        self.naoZhongController_ = NaoZhong.new()
        self.naoZhongController_:setNode(self.naoZhong_)
    end
end

function DismissRoomView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/dismissRoom.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function DismissRoomView:agreeHandler_()
    display.getRunningScene():sendDismissRoomCMD(true)
end

function DismissRoomView:refuseHandler_()
    display.getRunningScene():sendDismissRoomCMD(false)
end

return DismissRoomView 
