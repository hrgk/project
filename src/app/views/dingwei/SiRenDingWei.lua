local BaseView = import("app.views.BaseView")
local PlayerHead = import("app.views.PlayerHead")

local SiRenDingWei = class("SiRenDingWei", BaseView)
local games = {}
games[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_READY
games[GAME_MJZHUANZHUAN] = COMMANDS.MJ_READY
games[GAME_MJHONGZHONG] = COMMANDS.HZMJ_READY
games[GAME_MJCHANGSHA] = COMMANDS.CS_MJ_READY
games[GAME_DA_TONG_ZI] = COMMANDS.DTZ_READY
games[GAME_SHUANGKOU] = COMMANDS.SHUANGKOU_READY
games[GAME_13DAO] = COMMANDS.DAO13_READY

function SiRenDingWei:ctor(params, distances, iskaiju, gameType)
    self.isOpen = true
    self.gameType_ = gameType
    SiRenDingWei.super.ctor(self)
    self:setUserInfos_(params)
    self:setDistances_(distances) 

    -- if display.getRunningScene():getHostPlayer():isReady() or display.getRunningScene():isGamePlaying_() then
    --     self.ready_:hide()
    -- end
end

function SiRenDingWei:showBg(bool)
    self.bg_:setVisible(bool)
    self.close_:setVisible(bool)
end

function SiRenDingWei:hideMySelf_()
    -- if display.getRunningScene():getHostPlayer():isReady() or display.getRunningScene():isGamePlaying_() then
        self:hide()
    -- end
end

function SiRenDingWei:juLiHuanSuan_(dist)
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

function SiRenDingWei:setDistances_(distances)
    for i,v in ipairs(distances) do
        self["juli" .. i .."_"]:setString(self:juLiHuanSuan_(v))
    end
end

function SiRenDingWei:setUserInfos_(params)
    for i = 1, 4 do
        local v = params[i]
        if v then
            self["name" .. i .."_"]:setString(v.name)
        else
            self["name" .. i .."_"]:setString("")
        end
    end
end

function SiRenDingWei:initHead_(node, avatar)
    local view = PlayerHead.new()
    view:setNode(node)
    view:showWithUrl(avatar)
end

function SiRenDingWei:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/locationNew/siRenDingWei.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy+100)
end

function SiRenDingWei:readyHandler_()
    self.ready_:hide()
    dataCenter:sendOverSocket(games[self.gameType_])
end

return SiRenDingWei  
