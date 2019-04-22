local BUTTON_L_X, BUTTON_R_X, BUTTON_Y = 402, 854, 280
local BUTTON_PLAY_L_X, BUTTON_PLAY_R_X = 395, 992
local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
            {type = TYPES.NODE, var = "nodePlay_", children = {
                {type = TYPES.BUTTON, var = "buttonChuPai_", normal = "res/images/paodekuai/actions/action_chu_pai.png", disabled = "res/images/actions/action_chu_paihuise.png", px = BUTTON_PLAY_R_X, py = BUTTON_Y, autoScale = 0.9},
                {type = TYPES.BUTTON, var = "buttonTips_", normal = "res/images/paodekuai/actions/action_ti_shi.png", disabled = "res/images/actions/action_ti_shihuise.png", px = BUTTON_PLAY_L_X + (BUTTON_PLAY_R_X - BUTTON_PLAY_L_X) / 2, py = BUTTON_Y, autoScale = 0.9},
                -- {type = TYPES.BUTTON, var = "buttonPass_", normal = "res/images/paodekuai/actions/action_bu_yao.png", disabled = "res/images/actions/action_bu_yaohui.png", px = BUTTON_PLAY_L_X, py = BUTTON_Y, autoScale = 0.9},
            }},
        }},
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
end

function ActionButtonsView:onEnter()
    self.buttonChuPai_:onButtonClicked(handler(self, self.onChuPaiClicked_))
    self.buttonTips_:onButtonClicked(handler(self, self.onTipsClicked_))
end

function ActionButtonsView:onExit()
    gailun.EventUtils.clear(self)
end

function ActionButtonsView:onTipsClicked_()
    self:dispatchEvent({name = ActionButtonsView.ON_TIPS_CLICKED})
end

function ActionButtonsView:onChuPaiClicked_()
    self:dispatchEvent({name = ActionButtonsView.ON_CHUPAI_CLICKED})
end

function ActionButtonsView:showActions(inFlow, yaoDeQi)
    if yaoDeQi == false then
        self.buttonChuPai_:hide()
        self.buttonTips_:hide()
    else
        self.buttonChuPai_:show()
        self.buttonTips_:show()
    end
    self.nodePlay_:show()
    local pokerTable = dataCenter:getPokerTable()
    local cards = pokerTable:getCurCards()
end

function ActionButtonsView:calcCanDoActions(player)
    local player = player or dataCenter:getHostPlayer()
    return actions
end

return ActionButtonsView
