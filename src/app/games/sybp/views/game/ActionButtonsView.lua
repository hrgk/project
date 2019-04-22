local BUTTON_L_X1,BUTTON_L_X2,BUTTON_L_X3,BUTTON_L_X4 = 100, 260, 420, 580
local BUTTON_Y = display.cy + 30
local BUTTON_Y1 = display.cy - 130
local BUTTON_X1 = display.cx + display.cx / 2

local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
            {type = TYPES.NODE, var = "nodePlay_", children = {
                -- {type = TYPES.SPRITE, var = "bg_", filename = "res/images/game/actionbutton_bg.png", x = BUTTON_X1, y = BUTTON_Y, ap = {0.5, 0.5}},                
                {type = TYPES.NODE, var = "bg_", x = display.cx, y = display.cy + 30, ap = {0.5, 0.5}},                
                -- {type = TYPES.BUTTON, var = "buttonChi_", normal = "res/images/paohuzi/game/button_chi.png",px = BUTTON_L_X1, py = BUTTON_Y, autoScale = 0.9},
                -- {type = TYPES.BUTTON, var = "buttonPeng_", normal = "res/images/paohuzi/game/button_peng.png", px = BUTTON_L_X2  , py = BUTTON_Y, autoScale = 0.9},
                -- {type = TYPES.BUTTON, var = "buttonHu_", normal = "res/images/paohuzi/game/button_hu.png", px = BUTTON_L_X3, py = BUTTON_Y, autoScale = 0.9},
                -- {type = TYPES.BUTTON, var = "buttonGuo_", normal = "res/images/paohuzi/game/button_guo.png",  px = BUTTON_L_X4, py = BUTTON_Y, autoScale = 0.9},
            }},
        }},
    },
}

local ActionButtonsView = class("ActionButtonsView", gailun.BaseView)
 
ActionButtonsView.ON_CHI_CLICKED = "ON_CHI_CLICKED"
ActionButtonsView.ON_PENG_CLICKED = "ON_PENG_CLICKED"
ActionButtonsView.ON_HU_CLICKED = "ON_HU_CLICKED" 
ActionButtonsView.ON_GUO_CLICKED = "ON_GUO_CLICKED"

local images = {"res/images/paohuzi/game/button_chi.png", "res/images/paohuzi/game/button_peng.png", "res/images/paohuzi/game/button_hu.png", "res/images/paohuzi/game/button_guo.png",}

function ActionButtonsView:ctor(table)
    -- display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    gailun.uihelper.render(self, nodeTree)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    -- self.buttonChi_:setAutoGray(true)
    -- self.buttonPeng_:setAutoGray(true)
    -- self.buttonHu_:setAutoGray(true)
end

function ActionButtonsView:onEnter()

    self.buttonChi_ = gailun.JWPushButton.new({normal = "res/images/paohuzi/game/button_chi.png"}, {autoScale = 0.9})
    self.buttonPeng_ = gailun.JWPushButton.new({normal = "res/images/paohuzi/game/button_peng.png"}, {autoScale = 0.9})
    self.buttonHu_ = gailun.JWPushButton.new({normal = "res/images/paohuzi/game/button_hu.png"}, {autoScale = 0.9})
    self.buttonGuo_ = gailun.JWPushButton.new({normal = "res/images/paohuzi/game/button_guo.png"}, {autoScale = 0.9})

    local buttons = {self.buttonChi_, self.buttonPeng_, self.buttonHu_,  self.buttonGuo_}
    local posxs = {BUTTON_L_X1, BUTTON_L_X2, BUTTON_L_X3, BUTTON_L_X4}
    local functions = {
                        function(sender) self:dispatchEvent({name = ActionButtonsView.ON_CHI_CLICKED}) end,
                        function(sender) self:dispatchEvent({name = ActionButtonsView.ON_PENG_CLICKED}) end,
                        function(sender) self:dispatchEvent({name = ActionButtonsView.ON_HU_CLICKED}) end,
                        -- function(sender) self:dispatchEvent({name = ActionButtonsView.ON_GUO_CLICKED}) end,
                        function(sender) dataCenter:sendOverSocket(COMMANDS.SYBP_PLAYER_PASS, {}) end,
                      }

    for i=1, #buttons do
        self.bg_:addChild(buttons[i])
        local x = posxs[i]
        buttons[i]:setPosition(cc.p(0 , 0))
        buttons[i]:onButtonClicked(functions[i])
        -- UIHelp.addTouchEventListenerToBtnWithScale(buttons[i], functions[i])
    end
end

function ActionButtonsView:onExit()
    gailun.EventUtils.clear(self)
end
  
function ActionButtonsView:onChiClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_CHI_CLICKED})
end 

function ActionButtonsView:onPengClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_PENG_CLICKED})
end 

function ActionButtonsView:onHuClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_HU_CLICKED})
end 

function ActionButtonsView:onGuoClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_GUO_CLICKED})
end   

function ActionButtonsView:showActions(chi,peng,hu)
    -- UIHelp.setEnabled(self.buttonChi_, chi, images[1])
    -- UIHelp.setEnabled(self.buttonPeng_, peng, images[2])
    -- UIHelp.setEnabled(self.buttonHu_, hu, images[3])
    local canGuo = true
    if hu and not chi and not peng then
        canGuo = display.getRunningScene().tableController_:cheakOutCard()
    end
    print("canGuocanGuocanGuo",canGuo)
    local isEnabledList = {chi, peng, hu, canGuo}
    local btnList = {}
    for k, v in ipairs({self.buttonChi_, self.buttonPeng_, self.buttonHu_, self.buttonGuo_}) do
        if isEnabledList[k] then
            table.insert(btnList, v)
            v:setVisible(true)
        else
            v:setVisible(false)
        end
    end

    local interval = 140
    if #btnList == 2 then
        interval = 185
    end
    local width = (#btnList - 1) * interval
    for k, v in ipairs(btnList) do
        v:setPositionX(interval * (k - 1) - width / 2)
    end
end

function ActionButtonsView:calcCanDoActions(player)
    local player = player or dataCenter:getHostPlayer()
    return actions
end

return ActionButtonsView
