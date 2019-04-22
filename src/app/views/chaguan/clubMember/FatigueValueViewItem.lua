local BaseElement = import("app.views.BaseElement")
local FatigueValueViewItem = class("FatigueValueViewItem", BaseElement)

function FatigueValueViewItem:ctor(data)
    FatigueValueViewItem.super.ctor(self)
end

function FatigueValueViewItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/club/members/FatigueValuebersItem.csb"):addTo(self)
    self.csbNode_ = self.csbNode_:getChildByName("Panel_item")
end

function FatigueValueViewItem:update(data)
    local gameName ={[GAME_LDFPF] = "娄底放炮罚",[GAME_PAODEKUAI] = "跑得快",[GAME_MJZHUANZHUAN] = "转转麻将",[GAME_MJHONGZHONG] = "红中麻将"}
    self.data_ = data
    self.name_:setString(data.tid)
    self.id_:setString(gameName[data.game_type])
    self.zf_:setString(self:getYMD(data.time))
    self.js_:setString(tostring(data.commission))
    self.xhxz_:setString(tostring(data.score_snapshot))
end

function FatigueValueViewItem:getYMD(time)
    if time then
        local aimTime = os.date("*t",time)
        return aimTime.year .. "/" .. aimTime.month .. "/" .. aimTime.day
    else
        return "无"
    end
end

return FatigueValueViewItem  