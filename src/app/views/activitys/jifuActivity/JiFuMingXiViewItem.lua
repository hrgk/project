local JiFuMingXiViewItem = class("JiFuMingXiViewItem", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", scale9 = true, size = {860, 50} ,children = {
            {type = gailun.TYPES.LABEL, var = "labelNum_", options = {text = "1", size = 28, color = cc.c4b(177, 66, 37, 0), font = DEFAULT_FONT} ,ppx = 0.03, ppy = 0.5, ap = {0.5,0.5}},
            {type = gailun.TYPES.LABEL, var = "userID_", options = {text = "100001", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.16, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "nickName_", options = {text = "停不下来", font = DEFAULT_FONT,  size = 28, color = cc.c4b(177, 66, 37, 0), } ,ppx = 0.32, ppy = 0.5, ap = {0.5, 0.5}, scale = 0.8},
            {type = gailun.TYPES.LABEL, var = "registerJiFu_", options = {text = "1", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(0, 0, 0, 0), align = display.CENTER} ,ppx = 0.5, ppy = 0.5 ,ap = {0.5 ,0.5}},
            {type = gailun.TYPES.LABEL, var = "playJiFu_", options = {text = "2", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.634, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "tuiguangJiFu_", options = {text = "2", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.767, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "totalJiFu_", options = {text = "5", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.908, ppy = 0.5 ,ap = {0.5, 0.5}},
        }, ap = {0.5, 0.5}}
    }
}
function JiFuMingXiViewItem:ctor(data)
    gailun.uihelper.render(self, nodes)
end

function JiFuMingXiViewItem:update(data, index)
    self.labelNum_:setString(index)
    local text = gailun.utf8.formatNickName(data[2], 12, '')
    self.nickName_:setString(text)
    self.userID_:setString(data[1])
    self.registerJiFu_:setString("已注册")
    if data[3] == 1 then
        self.playJiFu_:setString("已开房")
        self.playJiFu_:setColor(cc.c4b(0, 0, 0, 0))
    else
        self.playJiFu_:setString("未开房")
    end
    if data[4] == 1 then
        self.tuiguangJiFu_:setString("已推广")
        self.tuiguangJiFu_:setColor(cc.c4b(0, 0, 0, 0))
    else
        self.tuiguangJiFu_:setString("未推广")
    end
    self.totalJiFu_:setString(data[5])
end

return JiFuMingXiViewItem 
