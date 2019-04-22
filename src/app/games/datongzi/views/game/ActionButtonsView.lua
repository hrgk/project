local BUTTON_L_X, BUTTON_R_X, BUTTON_Y = 402, 854, 380
local BUTTON_PLAY_L_X, BUTTON_PLAY_R_X = 350, 1000
local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
            {type = TYPES.NODE, var = "nodePlay_", visible = false, children = {
                {type = TYPES.BUTTON, var = "buttonChuPai_", normal = "res/images/game/chupai.png", disabled = "res/images/game/chupai_hui.png", px = BUTTON_PLAY_R_X, py = BUTTON_Y, autoScale = 0.9},
                {type = TYPES.BUTTON, var = "buttonTips_", normal = "res/images/game/tishi.png", disabled = "res/images/common/gameButton/btn_tishi.png", px = BUTTON_PLAY_L_X + (BUTTON_PLAY_R_X - BUTTON_PLAY_L_X) / 2, py = BUTTON_Y, autoScale = 0.9},
                {type = TYPES.BUTTON, var = "buttonPass_", normal = "res/images/common/gameButton/btn_buyao.png", disabled = "res/images/common/gameButton/btn_buyao_hui.png", px = BUTTON_PLAY_L_X, py = BUTTON_Y, autoScale = 0.9},
            }},
        }},
        {type = TYPES.BUTTON, visible = false, var = "buttonSort_", normal = "res/images/datongzi/actions/paixu.png", disabled = "images/actions/paixu.png", ap = {1, 0}, x = display.right, ppy = display.bottom, autoScale = 0.9},
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
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- self.buttonPass_:setAutoGray(true)
end

function ActionButtonsView:onEnter()
    self.buttonPass_:onButtonClicked(handler(self, self.onPassClicked_))
    self.buttonChuPai_:onButtonClicked(handler(self, self.onChuPaiClicked_))
    self.buttonTips_:onButtonClicked(handler(self, self.onTipsClicked_))
    self.buttonSort_:onButtonClicked(handler(self, self.onSort_))
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
    self.buttonChuPai_:hide()
    self.buttonTips_:hide()
    self.buttonPass_:hide()
    for i=1,3 do
        local action = cc.Sequence:create({
            -- cc.MoveBy:create(0, cc.p(0, -200)),
            cc.MoveBy:create(0.2, cc.p(0, 200)),
        })
        if i == 1 then
            self.buttonChuPai_:setPositionY(180)
            self.buttonChuPai_:runAction(action)
        elseif i == 2 then
            self.buttonPass_:setPositionY(180)
            self.buttonPass_:runAction(action)
        elseif i == 3 then
            self.buttonTips_:setPositionY(180)
            self.buttonTips_:runAction(action)
        end
    end
    self:performWithDelay(function()
        if yaoDeQi == false then
            self.buttonChuPai_:hide()
            self.buttonTips_:hide()
            self.buttonPass_:hide()
        else
            self.buttonChuPai_:show()
            self.buttonTips_:show()
            self.buttonPass_:show()
            -- self.buttonChuPai_:setButtonEnabled(false)
        end
        print(display:getRunningScene():getTable():getMustDenny())
        if display:getRunningScene():getTable():getMustDenny() == 0 then
            self.buttonPass_:show()
        else
            self.buttonPass_:hide()
            self.buttonChuPai_:setPositionX(display.cx+200)
            self.buttonTips_:setPositionX(display.cx-200)
        end
    end,0.1)
    self.nodePlay_:show()
    local pokerTable = display:getRunningScene():getTable()
    local cards = pokerTable:getCurCards()
    -- dump(cards)
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
    end
end

function ActionButtonsView:setPassBtnStatus(isCanClicked_)
    self:performWithDelay(function()
        if display:getRunningScene():getTable():getMustDenny() == 0 then
            self.buttonPass_:setButtonEnabled(isCanClicked_)
            self.buttonPass_:setVisible(isCanClicked_)
        end
    end,0.1)
end


return ActionButtonsView
