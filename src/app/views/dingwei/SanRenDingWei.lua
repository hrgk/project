local BaseView = import("app.views.BaseView")
local PlayerHead = import("app.views.PlayerHead")

local SanRenDingWei = class("SanRenDingWei", BaseView)
local games = {}
games[GAME_PAODEKUAI] = COMMANDS.PDK_READY
games[GAME_BCNIUNIU] = COMMANDS.NIUNIU_READY
games[GAME_MJZHUANZHUAN] = COMMANDS.MJ_READY
games[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_READY
games[GAME_DA_TONG_ZI] = COMMANDS.DTZ_READY
games[GAME_CDPHZ] = COMMANDS.CDPHZ_READY
games[GAME_MJHONGZHONG] = COMMANDS.HZMJ_READY
games[GAME_YZCHZ] = COMMANDS.YZCHZ_READY

function SanRenDingWei:ctor(params,distances,iskaiju,gameType)
    self.isOpen = true
    self.gameType_ = gameType
    SanRenDingWei.super.ctor(self)
    self:setUserInfos_(params)
    self:setDistances_(distances) 
    -- self.ready_:hide()
end

function SanRenDingWei:showBg(bool)
    self.bg_:setVisible(bool)
    self.close_:setVisible(bool)
end

function SanRenDingWei:hideMySelf_()
    self:hide()
end

function SanRenDingWei:juLiHuanSuan_(dist)
    local juli = ""
    if dist == - 1 then
        return "未知"
    end
    if dist > 1000 then
        juli = dist / 1000 .. "千米"
    else
        juli = dist .. "米"
    end
    return juli
end

function SanRenDingWei:setDistances_(distances)
    for i = 1, 3 do
        self["juLi" .. i .."_"]:setString(self:juLiHuanSuan_(distances[i]))
    end
end

function SanRenDingWei:setUserInfos_(params)
    for i = 1, 3 do
        local v = params[i]
        if v then
            self["name" .. i .."_"]:setString(v.name)
        else
            self["name" .. i .."_"]:setString("")
        end
    end
end

function SanRenDingWei:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/locationNew/sanRenDingWei.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy+200)
end

function SanRenDingWei:readyHandler_()
    self.ready_:hide()
    dataCenter:sendOverSocket(games[self.gameType_])
end

return SanRenDingWei 
