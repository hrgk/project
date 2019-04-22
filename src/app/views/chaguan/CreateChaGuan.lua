local BaseView = require("app.views.BaseView")
local CreateChaGuan = class("CreateChaGuan", BaseView)
local ChaGuanData = import("app.data.ChaGuanData")

function CreateChaGuan:ctor()
    CreateChaGuan.super.ctor(self)    
    self.clubConfig_ = ChaGuanData.getConfig()
    self.clubCount_ = ChaGuanData.myClubCount()
end

function CreateChaGuan:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/createClubView.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function CreateChaGuan:createClubHandler_(event)
    local diamond = selfData:getDiamond()
    local needDiamond = 50
    if diamond < needDiamond then
        app:alert(string.format("钻石不足,创建社区需大于%d", needDiamond))
        return
    end
    if self.clubConfig_.max_club_count == self.clubCount_ then
       app:showTips("社区已达上限")
       return
    end
    if self.input_:getString() == "" then
        app:alert("社区名字不能为空")
        return
    end
    if self.inputWX_:getString() == "" then
        app:alert("微信号不能为空")
        return
    end
    if string.utf8len(self.input_:getString()) > 8 then
        app:alert("社区名字最长为8个字符")
        return
    end
    local params = {}
    params.text = self.input_:getString()
    params.wet_chat = self.inputWX_:getString()
    httpMessage.requestClubHttp(params, httpMessage.CREATE_CLUB)
    self:removeSelf()
end

function CreateChaGuan:canCelClick_(event)
    self:removeSelf()
end

return CreateChaGuan 
