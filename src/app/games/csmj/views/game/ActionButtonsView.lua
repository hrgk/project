local actionPosList = {
    {0.841, 0.299},
    {0.697, 0.299},
    {0.553, 0.299},
    {0.409, 0.299},
    {0.265, 0.299},
    {0.121, 0.299},
}
local TYPES = gailun.TYPES
local nodeTree = {
    type = TYPES.ROOT,
    children = {
        {type = TYPES.LAYER, children = {
            {type = TYPES.BUTTON, var = "buttonPass_", normal = "res/images/majiang/game/button_pass.png", px = actionPosList[1][1], py = actionPosList[1][2]},
            {type = TYPES.BUTTON, var = "buttonHu_", normal = "res/images/majiang/game/button_hu.png", px = actionPosList[2][1], py = actionPosList[2][2]},
            {type = TYPES.BUTTON, var = "buttonGang_", normal = "res/images/majiang/game/button_gang.png", px = actionPosList[3][1], py = actionPosList[3][2]},
            {type = TYPES.BUTTON, var = "buttonPeng_", normal = "res/images/majiang/game/button_peng.png", px = actionPosList[4][1], py = actionPosList[4][2]},
            {type = TYPES.BUTTON, var = "buttonChi_", normal = "res/images/majiang/game/button_chi.png", px = actionPosList[5][1], py = actionPosList[5][2]},
            {type = TYPES.BUTTON, var = "buttonBu_", normal = "res/images/majiang/game/button_bu.png", px = actionPosList[6][1], py = actionPosList[6][2]},
        }},
        {type = TYPES.NODE, children = {
            {type = TYPES.SPRITE, var = "chooseBg_", touchEnabled = true, filename = "res/images/majiang/game/device_info_bg.png", scale9 = true, size = {20, 96}, ap = {1, 0.5}, px = 0.88, py = 0.432, opacity = 255 * 0.7},
        }},
        {type = TYPES.NODE, var = "nodeChooseMaJiangs_"},  -- 存放选择麻将牌的容器
        {type = TYPES.NODE, var = "nodeTmpMaJiangs_"},
    },
}

local ActionButtonsView = class("ActionButtonsView", gailun.BaseView)

ActionButtonsView.ON_PASS_CLICKED = "ON_PASS_CLICKED"
ActionButtonsView.ON_ZI_MO_CLICKED = "ON_ZI_MO_CLICKED"
ActionButtonsView.ON_CHI_HU_CLICKED = "ON_CHI_HU_CLICKED"
ActionButtonsView.ON_CHI_CLICKED = "ON_CHI_CLICKED"
ActionButtonsView.ON_QIANG_GANG_HU_CLICKED = "ON_QIANG_GANG_HU_CLICKED"
ActionButtonsView.ON_PENG_CLICKED = "ON_PENG_CLICKED"
ActionButtonsView.ON_AN_GANG_CLICKED = "ON_AN_GANG_CLICKED"
ActionButtonsView.ON_CHI_GANG_CLICKED = "ON_CHI_GANG_CLICKED"
ActionButtonsView.ON_BU_GANG_CLICKED = "ON_BU_GANG_CLICKED"
ActionButtonsView.ON_BU_ZHANG_CLICKED = "ON_BU_ZHANG_CLICKED"

function ActionButtonsView:ctor(table)
    display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    
    gailun.uihelper.render(self, nodeTree)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function ActionButtonsView:onEnter()
    self.buttonPass_:onButtonClicked(handler(self, self.onPassClicked_))
    self.buttonGang_:onButtonClicked(handler(self, self.onGangClicked_))
    self.buttonHu_:onButtonClicked(handler(self, self.onHuClicked_))
    self.buttonChi_:onButtonClicked(handler(self, self.onChiClicked_))
    self.buttonPeng_:onButtonClicked(handler(self, self.onPengClicked_))
    self.buttonBu_:onButtonClicked(handler(self, self.onBuClicked_))
end

function ActionButtonsView:onExit()
    gailun.EventUtils.clear(self)
end

--[[
{
    {
        cards = {11, 11, 11},  -- 牌组
        action = "chiGang",     -- 动作
        highLight = 3,          -- 高亮的张
    },
    ...
}
]]
function ActionButtonsView:showMultiGroupInChooseArea_(list)
    self.chooseBg_:show()
    local item_space = 12
    local right_margin = 8
    local majiang_width = 54
    local x, y = self.chooseBg_:getPosition()
    local x = x + (-majiang_width / 2 - right_margin)
    local startX = x
    for i1,item in ipairs(list) do
        local x2 = x
        for i2,v in ipairs(item.cards) do
            x2 = x - (#item.cards - i2) * majiang_width
            local maJiang = app:createConcreteView("MaJiangView", v, MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeChooseMaJiangs_):pos(x2, y)
            if i2 == item.highLight then
                maJiang:highLight()
            end
            gailun.uihelper.setTouchHandler(maJiang, function ()
                self:onChooseTouched_(item)
            end)
        end
        x = x - #item.cards * majiang_width
        x = x - right_margin
    end
    self:setChooseWidth_(startX - x + right_margin)
end

function ActionButtonsView:onChooseTouched_(item)
    if CSMJ_ACTIONS.AN_GANG == item.action then
        self:dispatchEvent({name = ActionButtonsView.ON_AN_GANG_CLICKED, card = item.cards[1]})
    elseif CSMJ_ACTIONS.BU_GANG == item.action then
        self:dispatchEvent({name = ActionButtonsView.ON_BU_GANG_CLICKED, card = item.cards[1]})
    elseif CSMJ_ACTIONS.CHI_GANG == item.action then
        self:dispatchEvent({name = ActionButtonsView.ON_CHI_GANG_CLICKED, card = item.cards[1]})
    elseif CSMJ_ACTIONS.CHI == item.action then

    else
        printInfo("ActionButtonsView:onChooseTouched_(item)")
        dump(item)
    end
end

function ActionButtonsView:setChooseWidth_(width)
    self.chooseBg_:setContentSize(cc.size(width, 96))
end

function ActionButtonsView:onPengClicked_(event)
    self:dispatchEvent({name = self.ON_PENG_CLICKED})
end

function ActionButtonsView:onChiClicked_(event)
    self:dispatchEvent({name = self.ON_CHI_CLICKED})
end

function ActionButtonsView:onHuClicked_(event)
    self:dispatchEvent({name = self.ON_ZI_MO_CLICKED})
end

function ActionButtonsView:onGangClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_AN_GANG_CLICKED})
end

function ActionButtonsView:onBuClicked_(event)
    self:dispatchEvent({name = ActionButtonsView.ON_BU_ZHANG_CLICKED})
end

function ActionButtonsView:getMultiChoose_(action, publicCard)
    local player = display.getRunningScene():getHostPlayer()
    if CSMJ_ACTIONS.AN_GANG == action then
        return player:calcAnGang()
    elseif CSMJ_ACTIONS.BU_GANG == action then
        return player:calcBuGang()
    elseif CSMJ_ACTIONS.CHI_GANG == action then
        return player:calcChiGang(publicCard)
    end
end

function ActionButtonsView:onPassClicked_(event)
    local actions = self:calcCanDoActions()
    -- if table.indexof(actions, CSMJ_ACTIONS.ZI_MO) ~= false then
    if self.buttonHu_:isVisible() then
        app:confirm("您确定不胡吗？", function (isOK)
            if not isOK then
                return
            end
            self:dispatchEvent({name = self.ON_PASS_CLICKED, actions = actions})
        end)
        return
    end
    self:dispatchEvent({name = self.ON_PASS_CLICKED, actions = actions})
end

function ActionButtonsView:hideMultiChoose_()
    self.nodeChooseMaJiangs_:removeAllChildren()
    self.chooseBg_:hide()
end

--[[
-- 玩家动作
ACTIONS = {
    GUO = 'guo',    -- 过
    CHI = 'chi',    -- 吃
    PENG = 'peng',   -- 碰
    CHI_GANG = 'chiGang',   -- 吃杠
    BU_GANG = 'buGang', -- 补杠
    AN_GANG = 'anGang', -- 暗杠
    CHI_HU =  'chiHu',    -- 吃胡
    ZI_MO = 'ziMo',    -- 自摸
    ZHUA_NIAO = 'zhuaNiao',  -- 抓鸟
    QIANG_GANG_HU = 'qiangGangHu',  -- 抢杠胡
}
]]
function ActionButtonsView:showActions(operatesInfo)
    self.nodeTmpMaJiangs_:removeAllChildren()
    self:hideMultiChoose_()
    local actions = self:calcCanDoActions()
    dump(actions)
    local buttons = {self.buttonPass_, self.buttonChi_, self.buttonPeng_, self.buttonGang_, self.buttonBu_, self.buttonHu_}
    local hides = {}
    self:show()
    if table.indexof(actions, CSMJ_ACTIONS.CHI) == false then
        table.removebyvalue(buttons, self.buttonChi_)
        table.insert(hides, self.buttonChi_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.PENG) == false then
        table.removebyvalue(buttons, self.buttonPeng_)
        table.insert(hides, self.buttonPeng_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.ZI_MO) == false and
        table.indexof(actions, CSMJ_ACTIONS.CHI_HU) == false and
        table.indexof(actions, CSMJ_ACTIONS.QIANG_GANG_HU) == false then
        table.removebyvalue(buttons, self.buttonHu_)
        table.insert(hides, self.buttonHu_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.CHI_GANG) == false and
        table.indexof(actions, CSMJ_ACTIONS.AN_GANG) == false and
        table.indexof(actions, CSMJ_ACTIONS.BU_GANG) == false then
        table.removebyvalue(buttons, self.buttonGang_)
        table.insert(hides, self.buttonGang_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.GONG_BU) == false  and
        table.indexof(actions, CSMJ_ACTIONS.AN_BU) == false and
        table.indexof(actions, CSMJ_ACTIONS.MING_BU) == false then
        table.removebyvalue(buttons, self.buttonBu_)
        table.insert(hides, self.buttonBu_)
    end

    if 1 == #buttons and buttons[1] == self.buttonPass_ then
        table.removebyvalue(buttons, self.buttonPass_)
        table.insert(hides, self.buttonPass_)
    end
    
    for i,v in ipairs(buttons) do
        local percentPos = actionPosList[i]
        v:show()
        v:pos(percentPos[1] * display.width, percentPos[2] * display.height)
    end

    for _,v in ipairs(hides) do
        v:hide()
    end

    self:showCardAfterButtons_(actions, operatesInfo)
end
function ActionButtonsView:showOperates(operates, operatesInfo)
    dump(operates, "showOperates")
    self.nodeTmpMaJiangs_:removeAllChildren()
    self:hideMultiChoose_()
    local actions = operates
    local buttons = {self.buttonPass_, self.buttonChi_, self.buttonPeng_, self.buttonGang_, self.buttonBu_, self.buttonHu_}
    local hides = {}
    
    if table.indexof(actions, CSMJ_ACTIONS.CHI) == false then
        table.removebyvalue(buttons, self.buttonChi_)
        table.insert(hides, self.buttonChi_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.PENG) == false then
        table.removebyvalue(buttons, self.buttonPeng_)
        table.insert(hides, self.buttonPeng_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.ZI_MO) == false and
        table.indexof(actions, CSMJ_ACTIONS.CHI_HU) == false and
        table.indexof(actions, CSMJ_ACTIONS.QIANG_GANG_HU) == false then
        table.removebyvalue(buttons, self.buttonHu_)
        table.insert(hides, self.buttonHu_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.CHI_GANG) == false and
        table.indexof(actions, CSMJ_ACTIONS.AN_GANG) == false and
        table.indexof(actions, CSMJ_ACTIONS.BU_GANG) == false then
        table.removebyvalue(buttons, self.buttonGang_)
        table.insert(hides, self.buttonGang_)
    end

    if table.indexof(actions, CSMJ_ACTIONS.GONG_BU) == false  and
        table.indexof(actions, CSMJ_ACTIONS.AN_BU) == false and
        table.indexof(actions, CSMJ_ACTIONS.MING_BU) == false then
        table.removebyvalue(buttons, self.buttonBu_)
        table.insert(hides, self.buttonBu_)
    end

    if 1 == #buttons and buttons[1] == self.buttonPass_ then
        table.removebyvalue(buttons, self.buttonPass_)
        table.insert(hides, self.buttonPass_)
    end
    
    for i,v in ipairs(buttons) do
        local percentPos = actionPosList[i]
        v:show()
        v:pos(percentPos[1] * display.width, percentPos[2] * display.height)
    end

    for _,v in ipairs(hides) do
        v:hide()
    end

    self:showCardAfterButtons_(actions, operatesInfo)
end

-- 计算公共时间的可以进行的动作
function ActionButtonsView:calcActionsInPublicTime_(player, allowChiHu, allowSevenPairs)
    local publicCard = display.getRunningScene():getTable():getLastCard()
    local isBuGang = display.getRunningScene():getTable():getIsBuGang()
    local lastSeatID = display.getRunningScene():getTable():getLastSeatID()
    local actions = {}
    
    dump({publicCard, isBuGang, lastSeatID, player:getSeatID()}, "ActionButtonsView:calcActionsInPublicTime_")
    if isBuGang then
        if allowChiHu and player:canChiHu(publicCard, allowSevenPairs) then
            table.insert(actions, CSMJ_ACTIONS.QIANG_GANG_HU)
        end
        return actions
    end
    if lastSeatID == player:getSeatID() then
        return actions
    end
    if allowChiHu and player:canChiHu(publicCard, allowSevenPairs) then
        table.insert(actions, CSMJ_ACTIONS.CHI_HU)
    end
    if player:canPeng(publicCard) then
        table.insert(actions, CSMJ_ACTIONS.PENG)
    end
    if player:canChiGang(publicCard) then
        table.insert(actions, CSMJ_ACTIONS.CHI_GANG)
    end
    return actions
end

-- 计算摸牌时间可以进行的动作
function ActionButtonsView:calcActionsInMoPaiTime_(player, allowChiHu, allowSevenPairs)
    local actions = {}
    if player:canZiMoHu(allowSevenPairs) then
        table.insert(actions, CSMJ_ACTIONS.ZI_MO)
    end
    if player:canAnGang() then
        table.insert(actions, CSMJ_ACTIONS.AN_GANG)
    end
    if player:canBuGang() then
        table.insert(actions, CSMJ_ACTIONS.BU_GANG)
    end
    return actions
end

function ActionButtonsView:inShowActions()
    local actions = self:calcCanDoActions()
    return actions and #actions > 0
end

function ActionButtonsView:calcCanDoActions(player)
    local player = player or display.getRunningScene():getHostPlayer()
    local allowChiHu = true
    local allowSevenPairs = true
    local actions
    local inPublicTime = display.getRunningScene():getTable():getInPublicTime()
    print("inPublicTime = ", inPublicTime, allowChiHu, allowSevenPairs)
    if inPublicTime then
        actions = self:calcActionsInPublicTime_(player, allowChiHu, allowSevenPairs)
    else
        actions = self:calcActionsInMoPaiTime_(player, allowChiHu, allowSevenPairs)
    end
    return actions
end

function ActionButtonsView:showCardAfterButtons_(actions, operatesInfo)
    local showCards ={}
    dump(operatesInfo)
    if operatesInfo ~= 1 then
        for _,v in pairs(operatesInfo) do
            for k,p in ipairs(v.operate_info) do
                table.insert(showCards, p.card)
            end
        end
    end
    -- local cards = display.getRunningScene():getTable():getLastCard()
    if self.buttonChi_:isVisible() and #showCards >= 1 then
        local x1, y1 = self.buttonChi_:getPosition()
        app:createConcreteView("MaJiangView", showCards[1], MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeTmpMaJiangs_):pos(x1 + 90, y1)
    end
    if self.buttonPeng_:isVisible() then
        local x2, y2 = self.buttonPeng_:getPosition()
        app:createConcreteView("MaJiangView", showCards[1], MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeTmpMaJiangs_):pos(x2 + 90, y2)
    end
    
    if not self.buttonGang_:isVisible() then  -- 没有杠
        return
    end

    local withChiGang = table.indexof(actions, CSMJ_ACTIONS.CHI_GANG) ~= false
    local withAnGang = table.indexof(actions, CSMJ_ACTIONS.AN_GANG) ~= false
    local withBuGang = table.indexof(actions, CSMJ_ACTIONS.BU_GANG) ~= false
    if withAnGang and withBuGang then  -- 补杠与暗杠同时存在，不显示要杠的牌
        return
    end

    -- if withChiGang then  -- 吃杠
    --     card = showCards[1]
    -- elseif withBuGang then  -- 补杠
    --     card = showCards[1]
    -- elseif withAnGang then  -- 暗杠
    --     card = showCards[1]
    -- end
    local x3, y3 = self.buttonGang_:getPosition()
    app:createConcreteView("MaJiangView", showCards[1], MJ_TABLE_DIRECTION.BOTTOM, true):addTo(self.nodeTmpMaJiangs_):pos(x3 + 90, y3)
end

function ActionButtonsView:setReViewEnable(v)
    local buttons = {self.buttonPass_, self.buttonChi_, self.buttonPeng_, self.buttonGang_, self.buttonBu_, self.buttonHu_}
    for i=1,#buttons do
        buttons[i]:setTouchEnabled(v)
    end
end

return ActionButtonsView
