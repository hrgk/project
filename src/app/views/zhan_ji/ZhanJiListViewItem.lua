local BaseElement = import("app.views.BaseElement")
local ZhanJiListViewItem = class("ZhanJiListViewItem", BaseElement)

function ZhanJiListViewItem:ctor()
    ZhanJiListViewItem.super.ctor(self)
end

function ZhanJiListViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/zhanji/zhanJiItem.csb"):addTo(self)
end

function ZhanJiListViewItem:lookHandler_()
    display.getRunningScene():initZhanJuList(self.data_)
end

function ZhanJiListViewItem:update(data, index)
    self.data_ = data
    self.roomID_:setString("房间号："..data.roomID)
    self.rank_:setString(index)
    self.time_:setString("对战时间：".. os.date("%Y-%m-%d  %H:%M:%S", data.time))
    self.gameName_:setString(GAMES_NAME[data.gameType])
    for i,v in ipairs(data.users) do
        if selfData:getUid() == v[3] then
            self.userName_:setString(v[1])
            if self.jiFen_ then
                self.jiFen_:removeSelf()
                self.jiFen_ = nil
            end
            if v[2] > 0 then
                self.jiFen_ = cc.LabelBMFont:create(v[2], "fonts/jiesuanying.fnt")
            else
                self.jiFen_ = cc.LabelBMFont:create(v[2], "fonts/jiesuanshu.fnt")
            end
            self.csbNode_:addChild(self.jiFen_)
            self.jiFen_:setPosition(215, -20)
            break
        end
    end
end

return ZhanJiListViewItem  
