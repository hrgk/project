local BaseElement = import("app.views.BaseElement")
local ZhuoZi = class("ZhuoZi", BaseElement)
local PlayerHead = import("app.views.PlayerHead")
local ChaGuanData = import("app.data.ChaGuanData")

function ZhuoZi:ctor(data)
    self.data_ = data
    ZhuoZi.super.ctor(self)
    self:initZhuoZi_()

    -- self.zhuoZi_:removeSelf()
    self.zhuoZi_:setSwallowTouches(false)
end

function ZhuoZi:getTid()
    return self.data_.tid
end

function ZhuoZi:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/siRenZhuo.csb"):addTo(self)
end

function ZhuoZi:upodateZhuoZiSkin_(count)
    if count == 4 then
        self.zhuoZi_:loadTexture("res/images/julebu/sp_zhuozi4.png")
    else
        self.zhuoZi_:loadTexture("res/images/julebu/sp_zhuozi.png")
    end
end

function ZhuoZi:update(info)
    if info == nil then
        self.ide_:show()
        self.roundIndex_:hide()
        self.roomID_:setString("")
        return
    end
    self.data_ = info
    self.roomID_:setString("房间号："..info.tid)
    if info.status == 0 then
        self.ide_:show()
        self.roundIndex_:hide()
    else
        self.ide_:hide()
        self.roundIndex_:show()
        self.roundIndex_:setString(info.roundIndex.."/"..info.totalRound)
    end
    self:updatePlayerHead_()
end

function ZhuoZi:updatePlayerHead_()
    for i,v in ipairs(self.headList_) do
        local obj = self.data_.players[i]
        if obj then
            v.playerName:setString(obj.nickName)
            v.playerHead:showWithUrl(obj.avatar)
            v.playerHead:show()
        else
            v.playerName:setString("")
            v.playerHead:showWithUrl("")
            v.playerHead:hide()
        end
    end
    local data = json.decode(self.data_.ruleDetails)
    self:upodateZhuoZiSkin_(data.totalSeat)
end

function ZhuoZi:addPlayer(data)
end

function ZhuoZi:deleplayer(data)
end

function ZhuoZi:initZhuoZi_()
    self.headList_ = {}
    for i=1,4 do
        local head = "head"..i.."_"
        local nameLable = self["nickName" .. i .."_"]
        nameLable:setString("")
        local obj = {}
        obj.playerHead = self:initHead_(self[head])
        obj.playerName = nameLable
        obj.playerHead:hide()
        table.insert(self.headList_, obj)
    end
end

function ZhuoZi:hide()
    self.csbNode_:hide()
end

function ZhuoZi:show()
    self.csbNode_:show()
end

function ZhuoZi:zhuoZiHandler_()
    if CHANNEL_CONFIGS.DOU then
        if not ChaGuanData.isMyClub() and ChaGuanData.getClubInfo().dou < ChaGuanData.getClubInfo().lowestScore then
            app:showTips("豆子不够")
            return
        end
    end
    if self.data_ == nil then
        app:showTips("请先设置游戏玩法")
        return 
    end
    if self.data_.tid then
        display.getRunningScene():enterGameRoom(self.data_.tid)
    end
end

function ZhuoZi:initHead_(node)
    local head = PlayerHead.new(nil, true)
    head:setNode(node)
    head:showWithUrl("")
    return head
end

return ZhuoZi 
