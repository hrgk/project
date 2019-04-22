local BaseView = import("..BaseView")
local JoinRoom = class("JoinRoom", BaseView)

function JoinRoom:ctor(inputType)
    self.inputType_ = inputType
    JoinRoom.super.ctor(self)
    self.numberList_ = {}
    self:clearNumber_()
    self:initTitle_()
end

function JoinRoom:initTitle_()
    self.jiaRuFangJian_:hide()
    self.huiFangMa_:hide()
    self.julebu_:hide()
    if self.inputType_ == 1 then
        self.jiaRuFangJian_:show()
        self.msg_:setString("请输入房间号")
    elseif self.inputType_ == 2 then
        self.huiFangMa_:show()
        self.msg_:setString("请输入回放码")
    elseif self.inputType_ == 3 then
        self.julebu_:show()
        self.msg_:setString("请输入社区ID")
    end
end

function JoinRoom:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/joinRoom.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function JoinRoom:enterRoom_(list)
    local roomID = ""
    for i,v in ipairs(list) do
        roomID = roomID .. tostring(v)
    end
    if self.inputType_ == 1 then
        dataCenter:sendEnterRoom(tonumber(roomID))
    elseif self.inputType_ == 3 then
        local params = {}
        params.clubID = tonumber(roomID)
        httpMessage.requestClubHttp(params, httpMessage.JOIN_CLUB)
    elseif self.inputType_ == 2 then
        HttpApi.getRoundInfo(tonumber(roomID), handler(self,self.sucHandler_), handler(self,self.failHandler_))
    end
end

function JoinRoom:sucHandler_(data)
    local info = json.decode(data)
    if info.status == 1 then
        if self.callfunc_ then
            self.callfunc_(info.data)
        end
        self:removeSelf()
    end
end

function JoinRoom:setCallback(callfunc)
    self.callfunc_ = callfunc
end

function JoinRoom:failHandler_(data)
end

function JoinRoom:setNumberTxt_(num)
    table.insert(self.numberList_,num)
    if #self.numberList_ > 6 then
        table.removebyvalue(self.numberList_, self.numberList_[6])
    end
    self["label" .. #self.numberList_ .. "_"]:setString(num)
    if #self.numberList_ == 6 then
        self:enterRoom_(self.numberList_)
    end
end

function JoinRoom:num1Handler_()
    self:setNumberTxt_(1)
end

function JoinRoom:num2Handler_()
    self:setNumberTxt_(2)
end

function JoinRoom:num3Handler_()
    self:setNumberTxt_(3)
end

function JoinRoom:num4Handler_()
    self:setNumberTxt_(4)
end

function JoinRoom:num5Handler_()
    self:setNumberTxt_(5)
end

function JoinRoom:num6Handler_()
    self:setNumberTxt_(6)
end

function JoinRoom:num7Handler_()
    self:setNumberTxt_(7)
end

function JoinRoom:num8Handler_()
    self:setNumberTxt_(8)
end

function JoinRoom:num9Handler_()
    self:setNumberTxt_(9)
end

function JoinRoom:num0Handler_()
    self:setNumberTxt_(0)
end

function JoinRoom:clearHandler_()
    self:clearNumber_()
end

function JoinRoom:delHandler_()
    self:delOneNumber_()
end

function JoinRoom:clearNumber_()
    self.numberList_ = {}
    for i=1,6 do
        self["label" .. i .. "_"]:setString("")
    end
end

function JoinRoom:delOneNumber_()
    if #self.numberList_ == 0 then return end
    self["label" .. #self.numberList_ .. "_"]:setString("")
    table.remove(self.numberList_, #self.numberList_)
end

return JoinRoom 
