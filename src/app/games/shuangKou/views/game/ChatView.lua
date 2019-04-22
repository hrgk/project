local BaseLayer = import("app.views.base.BaseDialog")
local ChatView = class("ChatView", BaseLayer)

local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.NODE, var = "chartMainLayer_", size = {display.width, display.height}, ap = {0, 0}, children = {
            {type = TYPES.SPRITE, var = "chartBg_", filename = "#bq_db.png", ppx = 0.5, ppy = 0.5, scale = display.height / DESIGN_HEIGHT},
        }},
        {type = TYPES.SPRITE, var = "spriteMask_", filename = "#xd_white2.png", scale9 = true, size = {display.width, display.height}, ap = {0, 0}},
    },
}

local faceIconSprite = {type = TYPES.SPRITE, filename = "#tong/mj_b_9.png", x = 200, y = display.height * 0.4, ppx = 0.15, ppy = 0.7}

local labelNode = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, var = "labelNodeIndex_1_", filename = "#labelbg.png", scale9 = true, size = {display.width / 3.3, 55}, ppx = 0.5, ppy = 0.76, children = {
            {type = TYPES.LABEL, options = {text = "今天这高兴", size = 32, font = DEFAULT_FONT, color = cc.c3b(77, 36, 21)}, ppx = 0.5, ppy = 0.5, ap = {0.5, 0.5}},
        }}
    }
}

function ChatView:ctor()
    display.addSpriteFrames("textures/game_face.plist", "textures/game_face.png")
    ChatView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self.touchIndex = 26
    -- self:initConstLabel_()
    self:loadPlist_()
    -- self.group = {}
    -- self.chatInput_:registerScriptEditBoxHandler(handler(self, self.onEditBoxEvent_))
    -- self.chatInput_:setFontColor(cc.c3b(77, 36, 21))
    -- self.buttonBiaoqing_:onButtonClicked(handler(self, self.onButtonBiaoqingClicked_))
    -- self.buttonDuanyu_:onButtonClicked(handler(self, self.onButtonDuanyuClicked_))
    -- self.group[#self.group+1] = self.chartBg_
    -- self.group[#self.group+1] = self.constLabelBg_
    gailun.uihelper.setTouchHandler(self.chartBg_)
    gailun.uihelper.setTouchHandler(self.chartMainLayer_, function (event)
        self:onClose_()
    end)

    -- if "ios" == device.platform then
    --  gailun.uihelper.setTouchHandler(self.spriteMask_, function (event)
    --      self.spriteMask_:setTouchEnabled(false)
    --  end)
    --  self.spriteMask_:setTouchEnabled(false)
    -- end

    -- self:performWithDelay(function ()
    --  self.chatInput_:setMaxLength(CHAT_TEXT_LIMIT)
 --        self.chatInput_:setPlaceholderFontSize(32)
 --        self.chatInput_:setPlaceHolder(string.format("最多输入%d个字", CHAT_TEXT_LIMIT))
 --    end, 0.1)
    self:androidBack()
    self.rootLayer:hide()
end

function ChatView:onButtonBiaoqingClicked_( event )
    for k,v in pairs(self.group) do
        v:setVisible(false)
    end
    self.constLabelBg_:setVisible(true)
end

function ChatView:onButtonDuanyuClicked_( event )
    for k,v in pairs(self.group) do
        v:setVisible(false)
    end
    self.chartBg_:setVisible(true)
end

function ChatView:loadPlist_()
    self:initFaceIcon_()
end

function ChatView:onExit()
    collectgarbage("collect")
end

function ChatView:getScrollSize_(node) 
    if not node then return nil end 
    local size = node:getContentSize()
    if size.width == 0 and size.height == 0 then
        local w,h = node:getLayoutSize()
        return cc.size(w,h)
    else 
        return size
    end
end

function ChatView:initConstLabel_()
    local longest = 1
    self.listView = cc.ui.UIListView.new({direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, 
        viewRect = cc.rect(0, 0,display.width /3.3, display.height /1.6-90),}):pos(20,15)
        :addTo(self.constLabelBg_):onTouch(handler(self, self.touchListener))
    
    for i = 1, #QUICK_CHAT_MESSAGE do
        if longest < QUICK_CHAT_MESSAGE[i].utf8len(QUICK_CHAT_MESSAGE[i]) then
            longest = QUICK_CHAT_MESSAGE[i].utf8len(QUICK_CHAT_MESSAGE[i])
        end
        
    end 

    for i = 1 , #QUICK_CHAT_MESSAGE do  
        local margin = {top = 5, right = 0, bottom = 0, left = 0}
        local sprite = self:createSpLabel_(QUICK_CHAT_MESSAGE[i],longest)
        local item = self.listView:newItem()
        item:setMargin(margin)
        item:setItemSize(display.width / 3.3, 55)
        item:addContent(sprite)
        self.listView:addItem(item)
    end
    self.listView:reload()
end

function ChatView:touchListener(event)
    if "clicked" == event.name then
        if event.itemPos then
            self:sendChatMessage_(CHAT_QUICK, event.itemPos)
            self:onClose_()
        end
    elseif "moved" == event.name then
    elseif "ended" == event.name then
    else
    end
end

function ChatView:onClose_(event)
    display.getRunningScene():closeWindow()
    self:removeFromParent(true)
end

function ChatView:createSpLabel_(infoString, longest)
    local distance = 35      --单位距离
    local length = infoString.utf8len(infoString)
    local sprite = display.newScale9Sprite("#labelbg.png", 0, 0, cc.size(display.width / 3.3, 55))
    local labelInfo_ = display.newTTFLabel({text = infoString, size = 32, x = 10, y = sprite:getContentSize().height/2 - 20, color = cc.c3b(77,36,21),align = cc.ui.TEXT_ALIGN_LEFT,}):addTo(sprite)
    labelInfo_:setAnchorPoint({0,0.5})

    if length > 11 then
        local senconds = 0
        local moveSteps = 0
        for i = 1,length - 11 do
            moveSteps = i * distance
            senconds = senconds + distance * 0.01
        end

        local calcTime = (longest -length) * distance * 0.01 * 2 + 2  --来回路程要乘以2倍的时间差值 加上偏移值 2
        local leftMoveTo = cc.MoveBy:create(senconds, cc.p(-moveSteps, 0)) --移动
        local rightMoveTo =  cc.MoveBy:create(senconds, cc.p(moveSteps, 0)) --移动
        local delayTime = cc.DelayTime:create(3)
        local calcDelayTime = cc.DelayTime:create(calcTime)
        local sequence = transition.sequence({leftMoveTo,delayTime,rightMoveTo,calcDelayTime,})
        labelInfo_:runAction(cc.RepeatForever:create(sequence))
    end

    return sprite 
end

function ChatView:initFaceIcon_()
    local size = self.chartBg_:getContentSize()
    for i = 1 , 8 do
        faceIconSprite.filename = "#game_face" .. tostring(i) ..".png"
        local offsetX = 0
        local offsetY = 0
        -- if i % 4 == 0 then
        --  offsetX = 4
        --  offsetY = math.floor(i/4) - 1
        -- else
        --  offsetX = i % 4
        --  offsetY = math.floor(i/4)
        -- end
        faceIconSprite.x = size.width * (0.065 +  (i - 1) * 0.125)
        faceIconSprite.y = size.height * 0.5
        local newSprite = gailun.uihelper.createObject(faceIconSprite)
        self.chartBg_:addChild(newSprite)

        local function onTouchEnded()
            self:onFaceIconTouched_(i)
        end
        gailun.uihelper.setTouchHandler(newSprite, onTouchEnded)
    end
end

-- 聊天类型 1-> 表情 2-> 常用语 3->普通文字
function ChatView:sendChatMessage_(messageType, messageData)
    local params = {
        action = "chat", 
        messageType = messageType, 
        messageData = messageData,
    }
    dataCenter:clientBroadcast(params)
end

function ChatView:onFaceIconTouched_(index)
    self:sendChatMessage_(CHAT_FACE, index)
    self:onClose_()
end

function ChatView:checkInputString_(str)
    local str = string.trim(str)
    if gailun.utf8.display_len(str) > CHAT_TEXT_LIMIT * 2 then
        str = gailun.utf8.sub_human(str, 1, CHAT_TEXT_LIMIT * 2)
    end
    return str
end

function ChatView:onEditBoxEvent_(event)
    if event == "began" then -- 开始输入
        if "ios" == device.platform then
            self.spriteMask_:setTouchEnabled(true)
        end
    elseif event == "changed" then
        -- 输入框内容发生变
        --正确，不会造成死循环
        local _text = self.chatInput_:getText()
        local _trimed = self:checkInputString_(_text)
        if _trimed ~= _text then
            self.chatInput_:setText(_trimed)
        end
    elseif event == "return" or event == "ended" then
        -- self.spriteMask_:setTouchEnabled(true)
        -- 从输入框返回
        -- self.labelInput_:hide()
        -- self.chatInput_:hide()
        -- self.labelInput_:setString(self.chatInput_:getText())
        -- self.chatInput_:setText("")
    end
end

function ChatView:onButtonSendClicked_(event)
    local text = self.chatInput_:getText()
    if string.len(text) < 1 then
        return
    end
    self:sendChatMessage_(CHAT_TEXT, text)
    self:onClose_()
end

return ChatView
