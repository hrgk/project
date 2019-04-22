local ChaGuanListView = class("ChaGuanListView", gailun.BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function ChaGuanListView:ctor(data)
    self.data_ = data
    dump(data)
    self:initView()
end

function ChaGuanListView:update(data)
    if #data > 0 then 
        self.di_:hide()
        self.list_:update(data)
        self.labelTitle_:hide()
    else
        self.di_:show()
        self.labelTitle_:show()
    end
end

function ChaGuanListView:onCreateChaGuanClicked_(event)
    local diamond = selfData:getDiamond()
    local needDiamond = 50
    if diamond < needDiamond then
        app:alert(string.format("钻石不足,创建社区需大于%d", needDiamond))
        return
    end
    display.getRunningScene():createChaGaunView()
end

function ChaGuanListView:onJoinClicked_(event)
    self:initInputView("请输入茶馆ID")
end

function ChaGuanListView:initInputView(msg)
    self.inputView_ = app:createView("chaguan.JoinClub", msg):addTo(self.content_):pos(display.cx, display.cy)
    self.inputView_:initTitle("res/images/clubs/game_title_jrjlb.png")
    self.inputView_:setCallback(handler(self, self.inputNumberOver_))
end

function ChaGuanListView:removeInput()
    self.inputView_:removeSelf()
    self.inputView_ = nil
end

function ChaGuanListView:inputNumberOver_(num)
    local params = {}
    params.clubID = num
    httpMessage.requestClubHttp(params, httpMessage.JOIN_CLUB)
end

function ChaGuanListView:onReturnClicked_(event)
    app:enterHallScene()
end

return ChaGuanListView 
