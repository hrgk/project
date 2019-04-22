local BaseView = import("app.views.BaseView")
local GameInputView = class("GameInputView", BaseView)

function GameInputView:ctor()
    GameInputView.super.ctor(self)
    self.numberList_ = {}
    self.sprBg_:setContentSize(display.width * 1.3, 400)
end

function GameInputView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/gameInputView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.bottom)
end

function GameInputView:setNumberTxt_(num)
    local numberStr = ""
    table.insert(self.numberList_,num)
    for i,v in ipairs(self.numberList_) do
        numberStr = numberStr .. tostring(v)
    end
    self:setString(numberStr)
end

function GameInputView:number0Handler_()
    self:setNumberTxt_(0)
end

function GameInputView:number1Handler_()
    self:setNumberTxt_(1)
end
function GameInputView:number2Handler_()
    self:setNumberTxt_(2)
end
function GameInputView:number3Handler_()
    self:setNumberTxt_(3)
end
function GameInputView:number4Handler_()
    self:setNumberTxt_(4)
end
function GameInputView:number5Handler_()
    self:setNumberTxt_(5)
end
function GameInputView:number6Handler_()
    self:setNumberTxt_(6)
end
function GameInputView:number7Handler_()
    self:setNumberTxt_(7)
end
function GameInputView:number8Handler_()
    self:setNumberTxt_(8)
end
function GameInputView:number9Handler_()
    self:setNumberTxt_(9)
end

--function GameInputView:resetHandler_()
--    self.numberList_ = {}
--    self:setString("")
--end

--现在这个函数改成了 输入小数点。原来这个是重置=》就是上面注释的同名函数
function GameInputView:resetHandler_()
    self:setNumberTxt_(".")
end

function GameInputView:delHandler_()
    if #self.numberList_ == 0 then return end
    local numberStr = ""
    table.remove(self.numberList_, #self.numberList_)
    for i,v in ipairs(self.numberList_) do
        numberStr = numberStr .. tostring(v)
    end
    self:setString(numberStr)
end

function GameInputView:setString(str)
    if self.callfunc_ then
        if  tonumber(string.sub(str,-1,-1)) then 
            str = self.callfunc_(tonumber(str) or 0,true) .. ""
        end
        self.numberList_ = {}
        for i = 1,string.len(str) do
            if tonumber(string.sub(str,i,i)) then
                self.numberList_[i] = tonumber(string.sub(str,i,i))
            else
                self.numberList_[i] = string.sub(str,i,i)
            end
        end
    end
    self.inputLable_:setString(str)
end

function GameInputView:setCallback(callfunc)
    self.callfunc_ = callfunc
    self:setString(0)
end

function GameInputView:quxiaoHandler_()
    self:closeHandler_()
end

function GameInputView:quedingHandler_()
    if self.callfunc_ then
        self.callfunc_(tonumber(self.inputLable_:getString()))
    end
    self:closeHandler_()
end

return GameInputView 
