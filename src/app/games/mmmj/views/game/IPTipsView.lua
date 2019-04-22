local IPTipsView = class("IPTipsView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
    {type = TYPES.NODE, var = "ipTipLayer_", size = {display.width, display.height}, ap = {0, 0}, children = {
        {type = TYPES.SPRITE, filename = "res/images/sz_bg.png", scale9 = true, size = {740, 500}, capInsets = cc.rect(100, 100,468, 261), x = display.cx, y = display.cy, children = {
            -- {type = TYPES.SPRITE, filename = "res/images/common/grxx_title.png", ppx = 0.51, ppy = 0.920, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "ts_word_", filename = "res/images/majiang/game/tsk_fzzb.png", ppx = 0.5, ppy = 0.97, ap = {0.5, 1}},
            -- {type = TYPES.LABEL, options = {text = "防作弊提示", size = 48, font = DEFAULT_FONT, color = cc.c4b(177, 66, 37, 255)}, ppx = 0.5, ppy = 0.82, ap = {0.5, 0.5}},
            {type = TYPES.LABEL, var = "labelIP_", options = {text = "", 
                size = 30, font = DEFAULT_FONT, color = cc.c4b(77, 36, 21, 255), dimensions = cc.size(600, 0)}, ppx = 0.5, ppy = 0.52, ap = {0.5, 0.5}},
            {type = TYPES.BUTTON, var = "buttonQuit_", normal = "res/images/majiang/game/quit_room.png", y = 90, x = 240,},
            {type = TYPES.BUTTON, var = "buttonContinue_", normal = "res/images/majiang/game/button_continue_game.png", y = 90, x = 510},
        }},
    }
    }}
}


function IPTipsView:ctor(showlist)
    gailun.uihelper.render(self, nodes)
    -- self.labelIP_:setLineHeight(55)
    self.isIdle_ = dataCenter:getPokerTable():isIdle()
    -- if self.isIdle_ then
    if not dataCenter:getPokerTable():isOwner(dataCenter:getHostPlayer():getUid()) then
        self.buttonQuit_:setButtonImage('pressed', "res/images/majiang/game/quit_room.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/majiang/game/quit_room.png")
    else
        self.buttonQuit_:setButtonImage('pressed', "res/images/majiang/game/button_dismiss2.png")
        self.buttonQuit_:setButtonImage('normal', "res/images/majiang/game/button_dismiss2.png")
    end

    self.buttonQuit_:onButtonClicked(handler(self, self.onQuitClicked_))
    self.buttonContinue_:onButtonClicked(handler(self, self.onContinueClicked_))
    self.ipTipLayer_:setTouchEnabled(true)
    self.ipTipLayer_:setTouchSwallowEnabled(true)
    self:updateTips_(showlist)
end

-- 【ssssss你是谁】、【城有要有有】IP相同【ssssss你是谁】、【城有要有有】IP相同
function IPTipsView:updateTips_(showList)
    for i,v in ipairs(showList) do
        showList[i] = gailun.utf8.split_human(v, 42)
        showList[i] = string.gsub(showList[i], '\n', '')
    end
    local showStr = table.concat(showList, "\n")
    self.labelIP_:setString(showStr)
end

function IPTipsView:onQuitClicked_(event)
    if self.isIdle_ then
        dataCenter:sendOverSocket(COMMANDS.MMMJ_LEAVE_ROOM)
    else
        dataCenter:sendOverSocket(COMMANDS.MMMJ_REQUEST_DISMISS, {agree = true})
    end
    self:doClose()
end

function IPTipsView:onContinueClicked_(event)
    dataCenter:sendOverSocket(COMMANDS.MMMJ_READY)
    self:doClose()
end

function IPTipsView:doClose()
    self:removeFromParent()
end

return IPTipsView
