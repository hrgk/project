local ZhanJiListView =class("ZhanJiListView", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {type = TYPES.ROOT, 
            children = 
                {
                    {type = TYPES.LIST_VIEW, 
                        var = "zhanJiList_",
                        options = {
                                    direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, 
                                    viewRect = cc.rect(30, 100, display.width * 0.95 * WIDTH_SCALE, display.height * 0.6 * HEIGHT_SCALE),
                                  },
                        itemParams = {
                                        width = display.width,
                                        height = display.height /4.6,
                                        class = "app.views.zhan_ji.ZhanJiListViewItem",
                                        data = {1, 2, 3 , 4},
                                    },
                    }
                }
            }

function ZhanJiListView:ctor(data)
    nodes.children[1].itemParams.data = data
    gailun.uihelper.render(self, nodes)
    self.zhanJiList_:onTouch(handler(self, self.onListViewItemClicked_))
end

function ZhanJiListView:onListViewItemClicked_(event)
    if event.name == "clicked" then
        local item = event.item:getContent()
        display.getRunningScene():initZhanJuInFoList(item:getRecordID(), item:getIndex())
    end
end

return ZhanJiListView 
