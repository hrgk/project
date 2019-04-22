local ZhanJiListViewItem = class("ZhanJiListViewItem", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {type = TYPES.ROOT, 
            children = {
            {type = TYPES.SPRITE, filename = "res/images/zhanji_di.png",
                 children = {
                {type = TYPES.LABEL_ATLAS, var = "labelNumber_", filename = "fonts/js_sz.png", options = {text= "1", w = 57, h = 79, startChar = "0"}, ppx = -0.05, ppy = 0.5, ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "labelRoomID_", options = {text = "45121房间号", font = DEFAULT_FONT, size = 28, color = cc.c4b(161, 76, 22, 0)} ,ppx = 0.1, ppy = 1.2, ap = {0,0.5}},
                {type = gailun.TYPES.LABEL, var = "labelFightTime_", options = {text = "对战时间192.168.0.1", font = DEFAULT_FONT, size = 28, color = cc.c4b(161, 76, 22, 0)} ,ppx = 0.5, ppy = 1.2 ,ap = {0,0.5}},
            
                {type = gailun.TYPES.LABEL, var = "userName1_", options = {text = "玩家昵称1", size = 32, font = DEFAULT_FONT, --[[dimensions = cc.size(display.width/10,32),]] color = cc.c4b(123, 48, 27, 0)} ,ppx = 0.12, ppy = 0.7 ,ap = {0.5 ,0.5}},
                {type = gailun.TYPES.LABEL, var = "userScore1_", options = {text = "45121房间号", font = DEFAULT_FONT, size = 32, color = cc.c4b(170, 28, 37, 0)} ,ppx = 0.12, ppy = 0.26 ,ap = {0.5, 0.5}},

                {type = gailun.TYPES.LABEL, var = "userName2_",options = {text = "玩家昵称2", font = DEFAULT_FONT, size = 32, --[[dimensions = cc.size(display.width/10,32),]] color = cc.c4b(123, 48, 27, 0)} ,ppx = 0.37, ppy = 0.7 ,ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "userScore2_", options = {text = "对战时间", font = DEFAULT_FONT, size = 32, color = cc.c4b(170, 28, 37, 0)} ,ppx = 0.37, ppy = 0.26 ,ap = {0.5, 0.5}},
            
                {type = gailun.TYPES.LABEL, var = "userName3_",options = {text = "玩家昵称3", font = DEFAULT_FONT, size = 32, --[[dimensions = cc.size(display.width/10,32),]] color = cc.c4b(123, 48, 27, 0)} ,ppx = 0.62, ppy = 0.7 ,ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "userScore3_", options = {text = "1", size = 32, font = DEFAULT_FONT, color = cc.c4b(170, 28, 37, 0)} ,ppx = 0.65, ppy = 0.26 ,ap = {0.5, 0.5}},          
                
                {type = gailun.TYPES.LABEL, var = "userName4_",options = {text = "玩家昵称3", font = DEFAULT_FONT, size = 32, --[[dimensions = cc.size(display.width/10,32),]] color = cc.c4b(123, 48, 27, 0)} ,ppx = 0.87, ppy = 0.7 ,ap = {0.5, 0.5}},
                {type = gailun.TYPES.LABEL, var = "userScore4_", options = {text = "1", size = 32, font = DEFAULT_FONT, color = cc.c4b(170, 28, 37, 0)} ,ppx = 0.87, ppy = 0.26 ,ap = {0.5, 0.5}},          
                }
            },
    }
}

function ZhanJiListViewItem:ctor(data)
    gailun.uihelper.render(self, nodes)
    -- self:setContentSize(display.width * 0.85, display.height /6) -- 设置根节点的大小 否则根节点为整个屏幕大小 导致滑动出问题
    self:pos(200, 0)
    self:setTouchEnabled(false)
    self:updateItemInfo_(data)
end

function ZhanJiListViewItem:updateItemInfo_(data)
    self.recordID_ = data.recordID
    self.index_ = data.index
    self["labelNumber_"]:setString(data.index)
    self["labelRoomID_"]:setString("房间号：" .. data.roomID)
    local timeStr = os.date("%Y-%m-%d %H:%M:%S", data.time)
    self["labelFightTime_"]:setString("对战时间：" .. timeStr)
    for i,v in ipairs(data.users) do
        local text = gailun.utf8.formatNickName(v[1], 10, '..')
        self["userName" .. i .. "_"]:setString(text)
        self["userScore" .. i .. "_"]:setString(tostring(v[2]))
    end
end

function ZhanJiListViewItem:getIndex()
    return self.index_
end

function ZhanJiListViewItem:getRecordID()
    return self.recordID_ 
end

return ZhanJiListViewItem 
