local PresentDiamondsMingXiViewItem = class("PresentDiamondsMingXiViewItem", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/hall/hall_bg9.png", scale9 = true, size = {860, 50} ,children = {
            {type = gailun.TYPES.LABEL, var = "labelNum_", options = {text = "1", size = 28, color = cc.c4b(177, 66, 37, 0), font = DEFAULT_FONT} ,ppx = 0.03, ppy = 0.5, ap = {0.5,0.5}},
            {type = gailun.TYPES.LABEL, var = "userID_", options = {text = "100001", font = DEFAULT_FONT,  size = 28,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.13, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "nickName_", options = {text = "停不下来", font = DEFAULT_FONT,  size = 28, color = cc.c4b(177, 66, 37, 0), } ,ppx = 0.28, ppy = 0.5, ap = {0.5, 0.5}, scale = 0.8},
            {type = gailun.TYPES.LABEL, var = "registerJiFu_", options = {text = "1", font = DEFAULT_FONT,  size = 24,  color = cc.c4b(0, 0, 0, 0), align = display.CENTER} ,ppx = 0.44, ppy = 0.5 ,ap = {0.5 ,0.5}},
            {type = gailun.TYPES.LABEL, var = "playJiFu_", options = {text = "2", font = DEFAULT_FONT,  size = 24,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.62, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "tuiguangJiFu_", options = {text = "2", font = DEFAULT_FONT,  size = 24,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.79, ppy = 0.5 ,ap = {0.5, 0.5}},
            {type = gailun.TYPES.LABEL, var = "totalJiFu_", options = {text = "5", font = DEFAULT_FONT,  size = 24,  color = cc.c4b(196, 31, 1, 0), align = display.CENTER} ,ppx = 0.93, ppy = 0.5 ,ap = {0.5, 0.5}},
        }, ap = {0.5, 0.5}}
    }
}
local TWENTY_ZUAN = 20 
local TEN_ZUAN = 10 

function PresentDiamondsMingXiViewItem:ctor(data)
    gailun.uihelper.render(self, nodes)
end

function PresentDiamondsMingXiViewItem:update(data, index)
    self.labelNum_:setString(index)
    local text = gailun.utf8.formatNickName(data[2], 10, '')
    self.nickName_:setString(text)
    self.userID_:setString(data[1])
    self.registerJiFu_:setString("完成(奖".. TWENTY_ZUAN .."钻)")
    if data[3] == 1 then
        self.playJiFu_:setString("完成(奖".. TEN_ZUAN .."钻)")
        self.playJiFu_:setColor(cc.c4b(0, 0, 0, 0))
    else
        self.playJiFu_:setString("未开房")
    end
    if data[4] > 0 then
        local totalZuan = data[4] * TEN_ZUAN
        local totalRen = data[4]
        self.tuiguangJiFu_:setString(totalRen .. "人(奖".. totalZuan .."钻)")
        self.tuiguangJiFu_:setColor(cc.c4b(0, 0, 0, 0))
    else
        self.tuiguangJiFu_:setString("0人(奖0钻)")
    end
    self.totalJiFu_:setString(data[5])
end

return PresentDiamondsMingXiViewItem 
