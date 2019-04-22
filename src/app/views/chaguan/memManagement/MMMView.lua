local BaseView = import("app.views.BaseView")
local ChaGuanData = import("app.data.ChaGuanData")
local ChengYuanListView = import("app.views.chaguan.ChengYuanListView")
local ApplyView = import("app.views.chaguan.shenQing.ApplyView")
local RecordView = import("app.views.chaguan.memManagement.RecordView")
local PartnerView = import("app.views.chaguan.memManagement.PartnerView")
local ClubZhanJi = import("app.views.chaguan.ClubZhanJi")
local MMMView = class("MMMView", BaseView)

function MMMView:ctor(clubId,clubName)
    MMMView.super.ctor(self)
    self.selecIndex = -1
    self.showIndex = -1
    self.showViewP = {}
    self.confList = 
    {
        [1] = {
            spr = {"views/club/memManagement/main/btn_cy_n.png", "views/club/memManagement/main/btn_cy_o.png"},
            --成员
        },
        [2] = {
            spr = {"views/club/memManagement/main/btn_cksq_n.png", "views/club/memManagement/main/btn_cksq_o.png"},
            --申请
        },
        [3] = {
            spr = {"views/club/memManagement/main/btn_wjzj_n.png", "views/club/memManagement/main/btn_wjzj_o.png"},
            --玩家战绩
        },
        [4] = {
            spr = {"views/club/memManagement/main/btn_zj_n.png", "views/club/memManagement/main/btn_zj_o.png"},
            --亲友圈战绩
        },
        [5] = {
            spr = {"views/club/memManagement/main/btn_hhrtj_n.png", "views/club/memManagement/main/btn_hhrtj_o.png"},
            --管理员
        },
    }
    self.changeHander = {1,4,5,3,2}
    self.confList[2].red = true 
    if ChaGuanData.getClubInfo().permission == 99 then
        self.confList[2].hide = true
        self.confList[3].hide = true
        self.confList[5].hide = true
    end

    self:addBtnToListView_()
    for i,v in ipairs(self.btnList_) do
        if i == 1 then
            v:setEnabled(false)
            v:setBright(false)
        else
            v:setEnabled(true)
            v:setBright(true)
        end
    end
    self:onButtonClick_(self.btnList_[1], 2)
    self.tip_:setString("亲友圈：" .. gailun.utf8.formatNickName(clubName, 8, '..') .. "\n" .. "亲友圈ID：" .. clubId)
end

function MMMView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/memManagement/main/mainView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function MMMView:addBtnToListView_()
    self.listView_:removeAllChildren()
    self.btnList_ = {}
    for i,value in ipairs(self.changeHander) do
        local v = self.confList[value]
        if not v.hide then
            local listItemLayout = ccui.Layout:create()
            listItemLayout:setContentSize(260,124)
            local btn =ccui.Button:create(v.spr[1], v.spr[1], v.spr[2])
            btn:addTouchEventListener(handler(self, self.onButtonClick_))
            btn:pos(120,62)
            btn.index = i
            listItemLayout:addChild(btn,1,12)
            table.insert(self.btnList_, btn)
            if v.red then
                self.redTag = ccui.ImageView:create("res/images/julebu/chengyuanInHao.png")
                btn:addChild(self.redTag)
                self.redTag:setAnchorPoint(cc.p(1, 1))
                self.redTag:pos(230-5,130-5)
                self.redTag:hide()
            end
            self.listView_:pushBackCustomItem(listItemLayout)
        end
    end
end

function MMMView:onButtonClick_(sender, eventType)
    if eventType == 0 then
        gameAudio.playSound("sounds/common/sound_button_click.mp3")
    elseif eventType == 2 then
        for i,v in ipairs(self.btnList_) do
            if v == sender then
                v:setEnabled(false)
                v:setBright(false)
                self:updateView_(v.index)
            else
                v:setEnabled(true)
                v:setBright(true)
            end
        end
    end
end

function MMMView:cheackHaveView(index)
    for i = 1,#self.confList do
        if i ~= index then
            if self.showViewP[i] then
                self.showViewP[i]:hide()
            end
        end
    end
    return false
end

function MMMView:updateView_(i)
    if self.selecIndex == self.changeHander[i] then
        return 
    end
    self.selecIndex = self.changeHander[i]
    if self.selecIndex == 1 then
        display.getRunningScene():requestClubUserList_()
    elseif self.selecIndex == 2 then
        self:showView(2)
    elseif self.selecIndex == 3 then
        self:showView(3)
    elseif self.selecIndex == 4 then
        self:showView(4)
        --display.getRunningScene():zhanjiHandler_()
    elseif self.selecIndex == 5 then
        self:showView(5)
    end
end

function MMMView:showView(i,data)
    self.showIndex = i
    print("self.showIndex",self.showIndex)
    self:cheackHaveView(self.showIndex)
    if self.showIndex == 1 then
        self:initChengYuanView_(data)
        self.userInfo = self.showViewP[1]:getUserInfo()
        self.userInfoTag,self.userDataInfo = self.showViewP[1]:getUserTreeData()
    elseif self.showIndex == 2 then
        self:showApplyView_(data)
    elseif self.showIndex == 3 then
        self:showRecordView_(data)
    elseif self.showIndex == 4 then
        self:showClubZhanJiView_(data)
    elseif self.showIndex == 5 then
        print("self.selecIndex",self.selecIndex)
        if self.selecIndex == 3 then
            self:showRecordView_(data)
        elseif self.selecIndex == 5 then
            self:showPartnerView_(data)
        end
        
    end
end

function MMMView:setVisibleJoinLisyRed(show)
    if self.redTag and not tolua.isnull(self.redTag) then
        self.redTag:setVisible(show)
    end 
end

function MMMView:showPartnerView_(data)
    if data then
        if self.showViewP[5] then
            self.showViewP[5]:updateView(data)
        end
        return
    end
    if self.showViewP[5] then
        self.showViewP[5]:show()
    else
        self.showViewP[5] = PartnerView.new(self.userInfoTag,self.userDataInfo):addTo(self.showItem_):pos(175,-140)
    end
end

function MMMView:showClubZhanJiView_(data)
    if data then
        if self.showViewP[4] then
            self.showViewP[4]:updateShowView(data,self.userInfo)
            self.showViewP[4]:show()
            return
        end
    end
    if self.showViewP[4] then
        self.showViewP[4]:show()
    else
        self.showViewP[4] = ClubZhanJi.new():addTo(self.showItem_):pos(175,-140)
    end
    
end

function MMMView:showRecordView_(data)
    if data then
        if self.showViewP[3] then
            self.showViewP[3]:show()
            self.showViewP[3]:updateView(data,self.userInfo)
        end
        return
    end
    if self.showViewP[3] then
        self.showViewP[3]:show()
    else
        self.showViewP[3] = RecordView.new():addTo(self.showItem_):pos(175,-140)
    end
end

function MMMView:showApplyView_(data)
    if data then
        if self.showViewP[2] then
            self.showViewP[2]:updateView(data)
        end
        return
    end
    if self.showViewP[2] then
        self.showViewP[2]:show()
    else
        self.showViewP[2] = ApplyView.new(self.redTag):addTo(self.showItem_):pos(175,-140)
    end
    
end


function MMMView:initChengYuanView_(data)
    if self.showViewP[1] then
        self.showViewP[1]:updateMemberList(data)
        self.showViewP[1]:show()
        return
    end
    self.showViewP[1] = ChengYuanListView.new(data):addTo(self.showItem_):pos(20,-20)
end

function MMMView:onExit()
end

return MMMView
