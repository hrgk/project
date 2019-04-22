local BaseView = import("app.views.BaseView")
local SetMemberInfo = class("SetMemberInfo", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function SetMemberInfo:ctor(data)
    self.data_ = data
    dump(self.data_,"self.data_")
    SetMemberInfo.super.ctor(self)
    self:clear()
    self.name_:setString(data.nickName)
    self.nowScore_:setString(data.score)
    if data.type == 1 then
        self.tip_:setString("增加")
    end
end

function SetMemberInfo:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/changeScore.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SetMemberInfo:setNumberTxt_(num)
    self.inputInfo = self.inputInfo .. num
    self.changeNum_:setString(self.inputInfo)
end

function SetMemberInfo:num1Handler_()
    self:setNumberTxt_(1)
end

function SetMemberInfo:num2Handler_()
    self:setNumberTxt_(2)
end

function SetMemberInfo:num3Handler_()
    self:setNumberTxt_(3)
end

function SetMemberInfo:num4Handler_()
    self:setNumberTxt_(4)
end

function SetMemberInfo:num5Handler_()
    self:setNumberTxt_(5)
end

function SetMemberInfo:num6Handler_()
    self:setNumberTxt_(6)
end

function SetMemberInfo:num7Handler_()
    self:setNumberTxt_(7)
end

function SetMemberInfo:num8Handler_()
    self:setNumberTxt_(8)
end

function SetMemberInfo:num9Handler_()
    self:setNumberTxt_(9)
end

function SetMemberInfo:num0Handler_()
    self:setNumberTxt_(0)
end

function SetMemberInfo:clear()
    self.inputInfo = ""
    self.changeNum_:setString(self.inputInfo)
end

function SetMemberInfo:clearHandler_()
    self:setNumberTxt_(".")
end

function SetMemberInfo:sendHandler_()
    local uid = self.data_.uid 
    local count = tonumber(self.inputInfo)
    local number,float = math.modf(count)
    if math.abs(float) > 0 then
        local str = tostring(count)
        str = string.format("%.1f", str)
        count = tonumber(str)
    end
    if self.data_.type == 1 then
        display.getRunningScene():increaseDou(uid,count)
    else
        display.getRunningScene():reduceDou(uid,count)
    end
    self:closeHandler_()
end

return SetMemberInfo 