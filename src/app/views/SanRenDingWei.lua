local BaseView = import(".BaseView")
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
games[GAME_13DAO] = COMMANDS.DAO13_READY
games[GAME_HSMJ] = COMMANDS.HS_MJ_READY
games[GAME_MMMJ] = COMMANDS.MMMJ_READY
games[GAME_FHHZMJ] = COMMANDS.FHHZMJ_READY
games[GAME_FHLMZ] = COMMANDS.ZMZ_READY
games[GAME_HHQMT] = COMMANDS.HHQMT_READY
games[GAME_SYBP] = COMMANDS.SYBP_READY
games[GAME_LDFPF] = COMMANDS.LDFPF_READY

function SanRenDingWei:ctor(params,distances,iskaiju,gameType)
    self.isOpen = true
    self.gameType_ = gameType
    SanRenDingWei.super.ctor(self)
    self:setUserInfos_(params)
    self:setDistances_(distances) 
    if not iskaiju then
        self.play_:hide()
        self.quitGame_:hide()
        self.jiesan_:hide()
    else
        if display.getRunningScene():getTable():getClubID() > 0 then
            self.quitGame_:show()
            self.jiesan_:hide()
            self.close_:hide()
            return 
        end
        if display.getRunningScene():isMyTable() then
            self.quitGame_:hide()
            self.jiesan_:show()
        else
            self.quitGame_:show()
            self.jiesan_:hide()
        end 
        self.close_:hide()
    end
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
    for i,v in ipairs(distances) do
        if self["juLi" .. i .."_"] then
            self["juLi" .. i .."_"]:setString(self:juLiHuanSuan_(distances[i]))
        end
    end
end

function SanRenDingWei:setUserInfos_(params)
    for i = 1, 3 do
        local v = params[i]
        if v then
            self["name" .. i .."_"]:setString(v.name)
            self["ip" .. i .."_"]:setString("IP："..v.ip)
            self:initHead_(self["player" .. i .. "_"], v.avatar)
        else
            self["name" .. i .."_"]:setString("")
            self["ip" .. i .."_"]:setString("")
        end
    end
end

function SanRenDingWei:initHead_(node, avatar)
    local view = PlayerHead.new()
    view:setNode(node)
    view:showWithUrl(avatar)
end

function SanRenDingWei:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/location/sanRenDingWei.csb"):addTo(self)
    self.csbNode_:setPosition(display.cx, display.cy)
end

function SanRenDingWei:playHandler_()
    dataCenter:sendOverSocket(games[self.gameType_])
    display.getRunningScene():closeDingWeiView()
end

function SanRenDingWei:quitGameHandler_()
    display.getRunningScene():sendTuiChuCMD()
    display.getRunningScene():closeDingWeiView()
end

function SanRenDingWei:jiesanHandler_()
    display.getRunningScene():sendJieSanCMD()
    display.getRunningScene():closeDingWeiView()
end

return SanRenDingWei 
