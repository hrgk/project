local ZhanJuListView =class("ZhanJuListView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {type = TYPES.ROOT, children = {
                    {type = TYPES.LIST_VIEW, 
                        var = "zhanJuList_",
                        options = {
                                    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, 
                                    viewRect = cc.rect(30, 60, display.width * 0.95 * WIDTH_SCALE, display.height * 0.58 * HEIGHT_SCALE),
                                  },
                        itemParams = {
                                        width = display.width,
                                        height = display.height /6,
                                        class = "app.views.zhan_ji.ZhanJuListViewItem",
                                        data = {1, 2, 3 , 4},
                                    },
                    },

                    -- {type = TYPES.SPRITE, filename = "#hall_bg9.png", px = 0.5, py = 0.7 ,scale9 = true, size = {1100, 46}}, 
                    {type = TYPES.LABEL, options = {text = "序号", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, px = 0.2, py = 0.70 ,ap = {0.5 ,0.5}},
                    {type = TYPES.LABEL, options = {text = "对战时间", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, px = 0.3, py = 0.70 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "paiJuUserName1_", options = {text = "玩家昵称1", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, px = 0.42, py = 0.70 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "paiJuUserName2_",options = {text = "玩家昵称2", size = 28, color = cc.c4b(142, 70, 0, 0), font = DEFAULT_FONT}, px = 0.53, py = 0.70 ,ap = {0.5, 0.5}},
                    {type = TYPES.LABEL, var = "paiJuUserName3_",options = {text = "玩家昵称3", size = 28, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,px = 0.64, py = 0.70 ,ap = {0.5, 0.5}}, 
                    {type = TYPES.LABEL, var = "paiJuUserName4_",options = {text = "玩家昵称4", size = 28, font = DEFAULT_FONT, color = cc.c4b(142, 70, 0, 0)} ,px = 0.75, py = 0.70 ,ap = {0.5, 0.5}}, 
    
                }
            }

function ZhanJuListView:ctor(data)
    nodes.children[1].itemParams.data = data.rounds
    gailun.uihelper.render(self, nodes)
    local users = display.getRunningScene():getCorrectUserList()
    for i,v in ipairs(users) do
        local text = gailun.utf8.formatNickName(v[1], 10, '..')
        self["paiJuUserName" .. i .. "_"]:setString(text)
    end
end

return ZhanJuListView 
