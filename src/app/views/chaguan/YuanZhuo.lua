local ZhuoZi = import(".ZhuoZi")
local YuanZhuo = class("YuanZhuo",ZhuoZi)

function YuanZhuo:ctor(data)
    YuanZhuo.super.ctor(self, data)
end

function YuanZhuo:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/julebu/yuanZhuo.csb"):addTo(self)
end

function YuanZhuo:initZhuoZi_()
    self.headList_ = {}
    for i=1,10 do
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

return YuanZhuo 
