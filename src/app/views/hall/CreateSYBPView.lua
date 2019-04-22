local BaseCreateView = import(".BaseCreateView")
local CreateSYBPView = class("CreateSYBPView", BaseCreateView)

function CreateSYBPView:ctor(showZFType)
    CreateSYBPView.super.ctor(self)

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self:initShow()
    createRoomData:setGameIndex(GAME_SYBP)
    self:setShowZFType(showZFType)
end

function CreateSYBPView:setData(data)
    self:updateZFList_(data.consumeType+1)
end

function CreateSYBPView:initShow()
    local guiZe = sybpData:getRuleInfo()
    self:updateZFList_(guiZe.zhifu)
end

function CreateSYBPView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateSYBPView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateSYBPView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateSYBPView:updateZFList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateSYBPView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createSYBP.csb"):addTo(self)
end

function CreateSYBPView:getRuleInfo()
    local guiZe = {}
    for i = 1,3 do
        local item = self.zhiFuList_[i]
        if item:isSelected() then
            guiZe.zhifu = i
            break
        end
    end
    return guiZe
end

function CreateSYBPView:getAimGuiZe(guiZe)
    local aimGuiZe = {}
    aimGuiZe.totalSeat = 3
    return aimGuiZe
end

function CreateSYBPView:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local str = json.encode(guiZe)
    sybpData:setRuleInfo(str)
    local aimGuiZe = self:getAimGuiZe(guiZe)
    local params = {
        gameType = GAME_SYBP, -- 游戏服务类型
        totalRound = 8,-- 游戏局数
        consumeType = guiZe["zhifu"] - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = aimGuiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateSYBPView 
