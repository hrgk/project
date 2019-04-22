local BaseView = import("app.views.BaseView")
local ChaGuanPlayerInfo = class("ChaGuanPlayerInfo", BaseView)
local ChaGuanHead = import(".ChaGuanHead")
local ChaGuanData = import("app.data.ChaGuanData")
local ZengSongView = import("app.views.chaguan.ZengSongView")


function ChaGuanPlayerInfo:ctor(data)
    self.isOpen = false
    self.data_ = data or {name = "刘道猴",remark = "(卵痛)", uid = 123456, weekJuShu = 1000, todayJuShu = 900}
    ChaGuanPlayerInfo.super.ctor(self)
    self:initHead_(data)
    self.nickName_:setString(self.data_.name .. "("..self.data_.remark..")")
    self.ID_:setString("ID："..self.data_.uid)
    self.weekCount_:setString("本周局数：0")--..self.data_.weekJuShu or 0)
    self.todayCount_:setString("今日局数：0")--..self.data_.todayJuShu or 0)
    self.tiChu_:setScale(1.3)
    display.getRunningScene():getPlayerClubInfo(self.data_.uid)
    self.guanLiMiaoShu_:setString("提携管理员")
    if ChaGuanData.isMyClub() then
        if data.uid == selfData:getUid() then
            self.tiChu_:hide()
            self.beiZhu_:hide()
            self.zengSong_:hide()
            self.shengzhi_:hide()
            self.jiangzhi_:hide()
        elseif data.permission == 1 then
            -- self.jiangzhi_:show()
            self.shengzhi_:show()
            self.guanLiMiaoShu_:setString("降为普通牌友")
        elseif data.permission == 99 then
            self.shengzhi_:show()
            self.guanLiMiaoShu_:setString("提携管理员")
            -- self.jiangzhi_:hide()
        end
    else
        if data.uid == selfData:getUid() then
            self.tiChu_:hide()
            self.beiZhu_:hide()
            self.zengSong_:hide()
            self.shengzhi_:hide()
            self.jiangzhi_:hide()
        elseif ChaGuanData.getClubInfo().permission == 1 then
            if self.data_.permission == 0 or self.data_.permission == 1 then
                self.jiangzhi_:hide()
                self.shengzhi_:hide()
                self.tiChu_:hide()
            elseif self.data_.permission == 99 then
                self.shengzhi_:show()
                self.jiangzhi_:hide()
            end
        elseif ChaGuanData.getClubInfo().permission == 99 then
            self.tiChu_:hide()
            self.beiZhu_:hide()
            self.zengSong_:hide()
            self.shengzhi_:hide()
            self.jiangzhi_:hide()
        end
    end
    self.zengSong_:hide()
end

function ChaGuanPlayerInfo:initHead_(data)
    local head = ChaGuanHead.new(data, true)
    head:setNode(self.head_)
    head:showWithUrl(data.avatar)
end

function ChaGuanPlayerInfo:setMask(operate)
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, operate))
    self:addChild(maskLayer, -1)

    self.layout_ = ccui.Layout:create()
    self.layout_:setContentSize(cc.size(DESIGN_WIDTH, DESIGN_HEIGHT))
    self.layout_:setTouchEnabled(true)
    self.layout_:addTouchEventListener(handler(self, self.onLayoutTouchHandler_))
    self:addChild(self.layout_, -1)
end

function ChaGuanPlayerInfo:onLayoutTouchHandler_(event)
    self:closeHandler_()
end

function ChaGuanPlayerInfo:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/memberInfo.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function ChaGuanPlayerInfo:update(data)
    self.weekCount_:setString("本周局数：" .. data.weekRound)--..self.data_.weekJuShu or 0)
    self.todayCount_:setString("今日局数："..data.dayRound)--..self.data_.todayJuShu or 0)
    if ChaGuanData.isMyClub() then
        dump(data)
        -- self.douCount_:setString("成员豆子："..data.dou)
    else
        self.douCount_:setString("")
    end
end

function ChaGuanPlayerInfo:tiChuHandler_()
    if not ChaGuanData.isMyClub() then
        app:showTips("只有群主可以踢出玩家！")
        return
    end
    display.getRunningScene():initTiRen(self.data_.name, self.data_.uid)
    self:closeHandler_()
end

function ChaGuanPlayerInfo:beiZhuHandler_()
    if not ChaGuanData.isMyClub() then
        app:showTips("只有群主可以备注群员！")
        return
    end
    display.getRunningScene():markPlayer("请输入玩家备注信息", self.data_.uid)
end

function ChaGuanPlayerInfo:shengzhiHandler_()
    local params = {}
    params.uid = self.data_.uid
    if self.data_.permission == 99 then
        display.getRunningScene():shengPlayer(params)
    else
        display.getRunningScene():jiangPlayer(params)
    end
end

function ChaGuanPlayerInfo:jiangzhiHandler_()
    local params = {}
    params.uid = self.data_.uid
    display.getRunningScene():jiangPlayer(params)
end

function ChaGuanPlayerInfo:tuiChuHandler_()
    display.getRunningScene():tuiChuClub()
end

function ChaGuanPlayerInfo:zhuanrangHandler_()
    local params = {}
    params.uid = self.data_.uid
    display.getRunningScene():zhuanRangPlayer(params)
end

function ChaGuanPlayerInfo:moveToLeft()
    transition.moveTo(self.csbNode_, {x=display.cx - 300, time = 0.2})
end

function ChaGuanPlayerInfo:moveToCenter()
    transition.moveTo(self.csbNode_, {x=display.cx, time = 0.2})
end

function ChaGuanPlayerInfo:zengSongHandler_()
    self.zengSong_ = ZengSongView.new(self.data_, handler(self, self.moveToCenter)):addTo(self)
    self:moveToLeft()
    self.zengSong_:moveToRight()
end

return ChaGuanPlayerInfo 