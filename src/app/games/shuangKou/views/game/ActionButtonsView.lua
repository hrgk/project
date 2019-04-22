local BUTTON_L_X, BUTTON_R_X, BUTTON_Y = 402, 854, 260
local BUTTON_PLAY_L_X, BUTTON_PLAY_R_X = 350, 1000
local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
            {type = TYPES.NODE, var = "nodePlay_", visible = false, children = {
                {type = TYPES.BUTTON, var = "buttonChuPai_", normal = "res/images/game/chupai.png", disabled = "res/images/game/chupai_hui.png", px = BUTTON_PLAY_R_X, py = BUTTON_Y, autoScale = 0.9, children = { }},
                {type = gailun.TYPES.SPRITE, var = "nodeSpeak_", filename = "res/images/shuangKou/game/choiceBg.png", x = -100, y = 50, ap = {0.5, 0}, scale9 = true, capInsets = cc.rect(20, 20, 20, 20), children = { }},
                {type = TYPES.BUTTON, var = "buttonTips_", normal = "res/images/game/tishi.png", disabled = "res/images/common/gameButton/btn_tishi.png", px = BUTTON_PLAY_L_X + (BUTTON_PLAY_R_X - BUTTON_PLAY_L_X) / 2, py = BUTTON_Y, autoScale = 0.9},
                {type = TYPES.BUTTON, var = "buttonPass_", normal = "res/images/common/gameButton/btn_buyao.png", disabled = "res/images/common/gameButton/btn_buyao_hui.png", px = BUTTON_PLAY_L_X, py = BUTTON_Y, autoScale = 0.9},
            }},
        }},
        {type = TYPES.BUTTON, visible = true, var = "buttonSort_", normal = "res/images/shuangKou/actions/paixu.png", disabled = "images/actions/paixu.png", ap = {1, 0}, x = display.right, ppy = display.bottom, autoScale = 0.9},
    },
}

local ActionButtonsView = class("ActionButtonsView", gailun.BaseView)

ActionButtonsView.ON_XUAN_HAO_YOU_CLICKED = "ON_XUAN_HAO_YOU_CLICKED"
ActionButtonsView.ON_SORT_CLICKED = "ON_SORT_CLICKED"
ActionButtonsView.ON_CHUPAI_CLICKED = "ON_CHUPAI_CLICKED"
ActionButtonsView.ON_TIPS_CLICKED = "ON_TIPS_CLICKED"
ActionButtonsView.ON_QIANG_CLICKED = "ON_QIANG_CLICKED"
ActionButtonsView.ON_BUQIANG_CLICKED = "ON_BUQIANG_CLICKED"
ActionButtonsView.ON_PASS_CLICKED = "ON_PASS_CLICKED"

function ActionButtonsView:ctor(table)
    display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    gailun.uihelper.render(self, nodeTree)

    self.speakBtnList_ = {}
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.buttonPass_:setAutoGray(true)

    -- self:showHanFen()
end

function ActionButtonsView:onEnter()
    self.buttonPass_:onButtonClicked(handler(self, self.onPassClicked_))
    self.buttonChuPai_:onButtonClicked(handler(self, self.onChuPaiClicked_))
    self.buttonTips_:onButtonClicked(handler(self, self.onTipsClicked_))
    self.buttonSort_:onButtonClicked(handler(self, self.onSort_))
end

function ActionButtonsView:showHanFen(list)
    -- list = {{4, 4, 4}, {5,5}, {4, 5, 5},{4, 4, 4}, {5,5}, {4, 5, 5},{4, 4, 4}, {5,5}, {4, 5, 5},{4, 4, 4}, {5,5}, {4, 5, 5},}
    if #list == 0 then
        self.nodeSpeak_:setVisible(false)
        return
    end
    self.nodeSpeak_:setVisible(true)
    local pos = cc.p(self.buttonTips_:getPosition())
    pos.x = pos.x
    pos.y = pos.y + 45
    self.nodeSpeak_:setPosition(pos)

    for _, v in ipairs(self.speakBtnList_) do
        v:removeFromParent()
    end
    self.speakBtnList_ = {}

    for _, v in pairs(list) do
        local name = table.concat(v)
        local resPath = "res/images/shuangKou/game/" .. name .. ".png"
        local btn = ccui.Button:create(resPath, resPath)
        btn:setAnchorPoint(0,0)
        btn:setSwallowTouches(true)
        btn:setName(name)
        btn:addTouchEventListener(gailun.utils.bind(self.onSpeakClick_, self, v))
        self.nodeSpeak_:addChild(btn)

        table.insert(self.speakBtnList_, 1, btn)
    end

    for k, v in pairs(self.speakBtnList_) do
        local index = (k - 1) % 4
        local line = math.ceil(k / 4) - 1

        v:setPosition(index * 160 + 30, line * 65 + 30)
    end

    local line = math.ceil(#self.speakBtnList_ / 4)
    local width = #self.speakBtnList_
    if line > 1 then
        width = 4
    end

    print(width * 70 + 80, line * 160 + 40)
    self.nodeSpeak_:setContentSize(width * 160 + 40, line * 65 + 40)
end

function ActionButtonsView:onSpeakClick_(speakData, sender, eventType)
    if eventType == 2 then
        self:dispatchEvent({name = ActionButtonsView.ON_CHUPAI_CLICKED, bombCount = speakData})
    end
end

function ActionButtonsView:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsView:onSort_()
    self:dispatchEvent({name = ActionButtonsView.ON_SORT_CLICKED})
end

function ActionButtonsView:onTipsClicked_()
    self:dispatchEvent({name = ActionButtonsView.ON_TIPS_CLICKED})
end

function ActionButtonsView:onPassClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_PASS_CLICKED})
end

function ActionButtonsView:onChuPaiClicked_()
    self:dispatchEvent({name = ActionButtonsView.ON_CHUPAI_CLICKED})
end

function ActionButtonsView:setVisibleAction(isVisible)
    self.nodePlay_:setVisible(isVisible)
end

function ActionButtonsView:isVisibleAction()
    self.nodePlay_:isVisible()
end

function ActionButtonsView:showActions(inFlow, yaoDeQi)
    if yaoDeQi == false then
        self.buttonChuPai_:hide()
        self.buttonTips_:hide()
        self.buttonPass_:hide()
    else
        self.buttonChuPai_:show()
        self.buttonTips_:show()
        self.buttonPass_:show()
    end
    local pokerTable = display:getRunningScene():getTable()
    local cards = pokerTable:getCurCards()
    dump(cards)
end

function ActionButtonsView:calcCanDoActions(player)
    local player = player or dataCenter:getHostPlayer()
    return actions
end

function ActionButtonsView:setChuPaiBtnStatus(isCanChuPai_)
    if isCanChuPai_ then
        self.buttonChuPai_:setButtonEnabled(true)
    else
        self.buttonChuPai_:setButtonEnabled(false)
        self:showHanFen({})
    end
end

function ActionButtonsView:setPassBtnStatus(isCanClicked_)
    self:performWithDelay(function()
        if display:getRunningScene():getTable():getMustDenny() == 0 then
            self.buttonPass_:setButtonEnabled(isCanClicked_)
        end
    end,0.1)
end


return ActionButtonsView
