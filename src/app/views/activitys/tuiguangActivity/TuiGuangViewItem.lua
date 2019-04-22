local TuiGuangViewItem = class("TuiGuangViewItem", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", scale9 = true, size = {830, 50} ,children = {
            {type = gailun.TYPES.LABEL, var = "labelNum_", options = {text = "1", size = 28, color = cc.c4b(104, 29, 29, 0), font = DEFAULT_FONT} ,ppx = 0.06, ppy = 0.5, ap = {0.5,0.5}},
            {type = gailun.TYPES.LABEL, var = "userID_", options = {text = "100001", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(104, 29, 29, 0), align = display.CENTER} ,ppx = 0.185, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "nickName_", options = {text = "停不下来", font = DEFAULT_FONT,  size = 28, color = cc.c4b(104, 29, 29, 0), } ,ppx = 0.37, ppy = 0.5, ap = {0.5, 0.5}, scale = 0.8},
            {type = gailun.TYPES.LABEL, var = "tuiGuang_", options = {text = "1", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(104, 29, 29, 0), align = display.CENTER} ,ppx = 0.6, ppy = 0.5 ,ap = {0.5 ,0.5}},
            {type = gailun.TYPES.LABEL, var = "time_", options = {text = "2", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(104, 29, 29, 0), align = display.CENTER} ,ppx = 0.86, ppy = 0.5 ,ap = {0.5, 0.5}},
        }, ap = {0.5, 0.5}}
    }
}
function TuiGuangViewItem:ctor(data)
    gailun.uihelper.render(self, nodes)
end

function TuiGuangViewItem:update(data, index)
    local time = os.date("%Y-%m-%d", data[4])

    self.labelNum_:setString(index)
    local text = gailun.utf8.formatNickName(data[2], 12, '')
    self.nickName_:setString(text)
    self.userID_:setString(data[1])
    self.time_:setString(time)
    self.tuiGuang_:setString(data[5])
end

return TuiGuangViewItem 
