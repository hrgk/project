local BaseView = import("app.views.BaseView")
local WenZiYuYin = class("WenZiYuYin", BaseView)
local SelectedView = import("app.views.SelectedView")
local HistoryItem = import("app.views.HistoryItem")

function WenZiYuYin:ctor()
    self.isSendQuickChat_ = false
    self.islt = false
    WenZiYuYin.super.ctor(self)
    self:initElementRecursive_(self.csbNode_)
    self:LTHandler_()
end

function WenZiYuYin:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/yuyinwenzi/wenZiYuYinView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx + 320, display.cy)
end

function WenZiYuYin:tanChuang(num)
    self.csbNode_:scale(0)
    transition.scaleTo(self.csbNode_, {scale = 1, time = 0.5, easing = "backOut"})
end

function WenZiYuYin:sendChatMessage_(wordID, faceCMD)
    if self.isSendQuickChat_ then
        app:showTips("您发消息太频繁，请先休息")
        return 
    end
    self.isSendQuickChat_ = true
    local params = {
        action = "chat", 
        messageData = wordID,
        messageType = faceCMD, 
        seatID = display.getRunningScene():getHostPlayer():getSeatID(),
        wordID = wordID,
    }
    dataCenter:clientBroadcast(params)
    self:hide()
    self:performWithDelay(function()
        self.isSendQuickChat_ = false
    end, 5)
end

function WenZiYuYin:BQHandler_()
    self.ltShow_:setVisible(false)
    self.ltHide_:setVisible(true)
    self.historyShow_:setVisible(false)
    self.historyHide_:setVisible(true)
    self.bqShow_:setVisible(true)
    self.bqHide_:setVisible(false)
    self.word_:setVisible(false)
    self.history_:setVisible(false)
    self.face_:setVisible(true)
end

function WenZiYuYin:LTHandler_()
    self.ltShow_:setVisible(true)
    self.ltHide_:setVisible(false)
    self.historyShow_:setVisible(false)
    self.historyHide_:setVisible(true)
    self.bqShow_:setVisible(false)
    self.bqHide_:setVisible(true)
    self.word_:setVisible(true)
    self.face_:setVisible(false)
    self.history_:setVisible(false)
end

function WenZiYuYin:JLHandler_()
    self.ltShow_:setVisible(false)
    self.ltHide_:setVisible(true)
    self.historyShow_:setVisible(true)
    self.historyHide_:setVisible(false)
    self.bqShow_:setVisible(false)
    self.bqHide_:setVisible(true)
    self.word_:setVisible(false)
    self.face_:setVisible(false)
    self.history_:setVisible(true)

    local history = chatRecordData:getGameRecord()
    self:updateHistory(history)
end

function WenZiYuYin:show()
    self:setVisible(true)
    local history = chatRecordData:getGameRecord()
    self:updateHistory(history)
end

function WenZiYuYin:updateHistory(history)
    self.historyList_:removeAllItems()

    for k, v in ipairs(history) do
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(300, 60))
        local item = HistoryItem.new()
        item:update(v.fileName, v.params)
        layout:addChild(item)

        self.historyList_:pushBackCustomItem(layout)
    end
end

function WenZiYuYin:word1Handler_( ... )
    self:sendChatMessage_(1, CHAT_QUICK)
end

function WenZiYuYin:word2Handler_( ... )
    self:sendChatMessage_(2, CHAT_QUICK)
end

function WenZiYuYin:word3Handler_( ... )
    self:sendChatMessage_(3, CHAT_QUICK)
end

function WenZiYuYin:word4Handler_( ... )
    self:sendChatMessage_(4, CHAT_QUICK)
end

function WenZiYuYin:word5Handler_( ... )
    self:sendChatMessage_(5, CHAT_QUICK)
end

function WenZiYuYin:word6Handler_( ... )
    self:sendChatMessage_(6, CHAT_QUICK)
end

function WenZiYuYin:word7Handler_( ... )
    self:sendChatMessage_(7, CHAT_QUICK)
end

function WenZiYuYin:word8Handler_( ... )
    self:sendChatMessage_(8, CHAT_QUICK)
end

function WenZiYuYin:face1Handler_( ... )
    self:sendChatMessage_(1, CHAT_FACE_BQ)
end

function WenZiYuYin:face2Handler_( ... )
    self:sendChatMessage_(2, CHAT_FACE_BQ)
end

function WenZiYuYin:face3Handler_( ... )
    self:sendChatMessage_(3, CHAT_FACE_BQ)
end

function WenZiYuYin:face4Handler_( ... )
    self:sendChatMessage_(4, CHAT_FACE_BQ)
end

function WenZiYuYin:face5Handler_( ... )
    self:sendChatMessage_(5, CHAT_FACE_BQ)
end

function WenZiYuYin:face6Handler_( ... )
    self:sendChatMessage_(6, CHAT_FACE_BQ)
end

function WenZiYuYin:face7Handler_( ... )
    self:sendChatMessage_(7, CHAT_FACE_BQ)
end

function WenZiYuYin:face8Handler_( ... )
    self:sendChatMessage_(8, CHAT_FACE_BQ)
end

function WenZiYuYin:face9Handler_( ... )
    self:sendChatMessage_(9, CHAT_FACE_BQ)
end

function WenZiYuYin:face10Handler_( ... )
    self:sendChatMessage_(10, CHAT_FACE_BQ)
end

function WenZiYuYin:face11Handler_( ... )
    self:sendChatMessage_(11, CHAT_FACE_BQ)
end

function WenZiYuYin:face12Handler_( ... )
    self:sendChatMessage_(12, CHAT_FACE_BQ)
end

return WenZiYuYin 
