local BaseElement = import("app.views.BaseElement")
local ZongSongView = class("ZongSongView", BaseElement)

function ZongSongView:ctor()
    ZongSongView.super.ctor(self)
    self.zuanShiShuLiang_:setString(selfData:getDiamond())
end

function ZongSongView:shuliangBtnHandler_()
    local function callfunc(count)
        self.shuLiang_:setString(count)
    end
    display.getRunningScene():initGameInput(callfunc)
end

function ZongSongView:getUserInfo_(uid)
    local function sucFunc(data)
        local info = json.decode(data)
        if info.status == 1 then
            self.id_:setString(info.data.uid)
            self.nickName_ = info.data.nickName
            self.userInfo_:setString(info.data.nickName..",剩余钻石：" .. info.data.diamond)
        end
    end
    local function failFunc()
    end
    HttpApi.getQueryUid(uid, sucFunc, failFunc)
end

function ZongSongView:idBtnHandler_()
    display.getRunningScene():initGameInput(handler(self,self.getUserInfo_))
end

function ZongSongView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/daili/zengSongView.csb"):addTo(self)
end

function ZongSongView:zengSongHandler_()
    if self.id_:getString() == "0" then
        app:showTips("用户ID不能为0")
        return
    end
    if self.shuLiang_:getString() == "0" then
        app:showTips("钻石数量不能为0")
        return
    end
    local msg = "确定赠送" .. self.shuLiang_:getString() .."颗钻石"..self.nickName_ .."吗？"
    app:confirm(msg, handler(self, self.songZuanShi_))
end

function ZongSongView:songZuanShi_()
    local function sucFunc(data)
        local info = json.decode(data)
        if info.status == 1 then
            selfData:setDiamond(info.data.leftDiamonds)
            self.zuanShiShuLiang_:setString(selfData:getDiamond())
            display.getRunningScene():setZuanShi(selfData:getDiamond())
        end
    end
    local function failFunc()
    end
    HttpApi.giveDiamonds(tonumber(self.id_:getString()), tonumber(self.shuLiang_:getString()), sucFunc, failFunc)
end

return ZongSongView 
