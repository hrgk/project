local BaseItem = import("app.views.BaseItem")
local GameTipMsg = class("GameTipMsg",BaseItem)

function GameTipMsg:ctor(model)
    self.table_ = model
    GameTipMsg.super.ctor(self)
    self.timeCount_ = 0
end

function GameTipMsg:setNode(node)
    GameTipMsg.super.setNode(self, node)
    self.csbNode_:hide()
end

function GameTipMsg:show()
    self.csbNode_:hide()
end

function GameTipMsg:hide()
    self.csbNode_:hide()
end

function GameTipMsg:showMsg(msgType)
    if msgType == 1 then
        self:startBiPai()
    elseif msgType == -1 then
        self.csbNode_:hide()
    elseif msgType == 2 then
        self:qiangZhuang()
    elseif msgType == 3 then
        self:waitOtherQiangZhuang()
    elseif msgType == 4 then
        self:waitOtherXiaZhu()
    elseif msgType == 5 then
        self:fanPaiTips()
    elseif msgType == 6 then
        self:liangPaiTips()
    elseif msgType == 7 then
        self:waitOtherLiangPai()
    elseif msgType == 8 then
        self:waitStartGame()
    end
end

function GameTipMsg:startBiPai()
    self.csbNode_:show()
    self.timeCount_ = 30
    self.msg_:setString("比牌中：")
    self.timeMsg_:setString(self.timeCount_)
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:qiangZhuang()
    self.csbNode_:show()
    self.msg_:setString("请抢庄：")
    self.timeCount_ = 15
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:waitOtherQiangZhuang()
    self.csbNode_:show()
    self.msg_:setString("请等待他人抢庄：")
    self.timeCount_ = 15
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:xiaZhuTips()
    self.csbNode_:show()
    self.timeCount_ = 15
    self.msg_:setString("请选择下注分数：")
    if display.getRunningScene().tableController_:isStanding() then
        display.getRunningScene().tableController_:showCard_()
    end
    self.timeMsg_:setString(self.timeCount_)
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:waitOtherXiaZhu(isZhuang)
   
    if not display.getRunningScene().tableController_:isStanding() then
        self.csbNode_:show()
        self.msg_:setString("请等待他人下注：")
        if 1000 == tonumber(self.timeMsg_:getString()) or isZhuang then
            self.timeCount_ = 15
            self:timeActions_(self.timeCount_)
        end 
    end
end

function GameTipMsg:fanPaiTips()
    self.csbNode_:show()
    self.timeCount_ = 10
    self.msg_:setString("请翻牌或搓牌：")
    self.timeMsg_:setString(self.timeCount_)
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:liangPaiTips()
    self.csbNode_:show()
    self.timeCount_ = 10
    self.msg_:setString("请亮牌：")
    self.timeMsg_:setString(self.timeCount_)
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:waitOtherLiangPai()
    self.csbNode_:show()
    self.msg_:setString("请等待他人亮牌：")
    if 1000 == tonumber(self.timeMsg_:getString()) then
        self.timeCount_ = 10
        self:timeActions_(self.timeCount_)
    end
end

function GameTipMsg:waitStartGame()
    self.csbNode_:show()
    self.timeCount_ = 10
    self.msg_:setString("即将开始：")
    self.timeMsg_:setString(self.timeCount_)
    self:timeActions_(self.timeCount_)
end

function GameTipMsg:timeActions_(count)
    self.csbNode_:stopAllActions()
    local actions = {}
    for i=1,count do
        table.insert(actions, cc.CallFunc:create(function ()
            self.timeCount_ =self.timeCount_-1
            self.timeMsg_:setString(self.timeCount_)
        end))
        table.insert(actions, cc.DelayTime:create(1))
    end
    table.insert(actions, cc.CallFunc:create(function ()
            self.timeMsg_:setString("")
            self.csbNode_:hide()
        end))
    self.csbNode_:runAction(transition.sequence(actions))
   
end

return GameTipMsg 
