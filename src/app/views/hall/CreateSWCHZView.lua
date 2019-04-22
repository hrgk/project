local BaseCreateView = import(".BaseCreateView")
local CreateSWCHZView = class("CreateSWCHZView", BaseCreateView)

function CreateSWCHZView:ctor(showZFType)
    CreateSWCHZView.super.ctor(self)
    self.jushuConf = {8,16}
    self.renShuConf = {3,2}
    self.juShuList_ = {}
    self.juShuList_[1] = self.juShu1_
    self.juShuList_[2] = self.juShu2_

    self.rsList_ = {}
    self.rsList_[1] = self.ren3_
    self.rsList_[2] = self.ren2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.wfList_ = {}
    self.wfList_[1] = self.wf1_
    self.wfList_[2] = self.wf2_

    self.xhList_ = {}
    self.xhList_[1] = self.xh1_
    self.xhList_[2] = self.xh2_

    self:initShow()
    createRoomData:setGameIndex(GAME_YZCHZ)
    self:setShowZFType(showZFType)
end

function CreateSWCHZView:setData(data)
    self:updateZFList_(data.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.totalRound then
            self:updateJuShuList_(key)
            break
        end
    end
    for key,value in pairs(self.renShuConf) do
        if value == data.rules.totalSeat then
            self:updateRSList_(key)
            break
        end
    end
    self.fd_:setSelected(data.rules.limitScore > 0)
    self:updatexhList_(data.rules.huType == 3 and 1 or 2)
    self:updatewfList_(data.rules.xingType)
end

function CreateSWCHZView:initShow()
    local guiZe = xtyzchzData:getRuleInfo()
    self:updateJuShuList_(guiZe.jushu)
    self:updateRSList_(guiZe.rs)
    self:updateZFList_(guiZe.zhifu)
    self:updatexhList_(guiZe.xh)
    self:updatewfList_(guiZe.wf)
    self.fd_:setSelected(guiZe.fd == 1)
end

function CreateSWCHZView:initElement_()
    CreateSWCHZView.super.initElement_(self)
end

function CreateSWCHZView:xh1Handler_()
    self:updatexhList_(1)
end

function CreateSWCHZView:xh2Handler_()
    self:updatexhList_(2)
end

function CreateSWCHZView:updatexhList_(index)
    for i, v in ipairs(self.xhList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.xhIdex_ = index
end

function CreateSWCHZView:wf1Handler_()
    self:updatewfList_(1)
end

function CreateSWCHZView:wf2Handler_()
    self:updatewfList_(2)
end

function CreateSWCHZView:updatewfList_(index)
    for i, v in ipairs(self.wfList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.wfIdex_ = index
end

function CreateSWCHZView:ren3Handler_()
    self:updateRSList_(1)
end

function CreateSWCHZView:ren2Handler_()
    self:updateRSList_(2)
end

function CreateSWCHZView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateSWCHZView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateSWCHZView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateSWCHZView:updateRSList_(index)
    for i, v in ipairs(self.rsList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.rsIdex_ = index
end

function CreateSWCHZView:juShu1Handler_()
    self:updateJuShuList_(1)
end

function CreateSWCHZView:juShu2Handler_()
    self:updateJuShuList_(2)
end

function CreateSWCHZView:updateJuShuList_(index)
    for i, v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.jsIdex_ = index
end

function CreateSWCHZView:updateZFList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.zfIdex_ = index
end

function CreateSWCHZView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createSWCHZ.csb"):addTo(self)
end

function CreateSWCHZView:getRuleInfo()
    local guiZe = {
        ["jushu"] = self.jsIdex_,
        ["wf"] = self.wfIdex_,
        ["rs"] = self.rsIdex_,
        ["zhifu"] = self.zfIdex_,
        ["xh"] = self.xhIdex_,
        ["wNum"] = 3,
        ["fd"] = self.fd_:isSelected() and 1 or 0,
        ["hzzh"] = 0,
    }
    local str = json.encode(guiZe)
    xtyzchzData:setRuleInfo(str)
    local ruleDetails = {}
    ruleDetails.wangCount = 2
    ruleDetails.xingType = self.wfIdex_
    ruleDetails.huType = 1
    ruleDetails.totalSeat = self.renShuConf[self.rsIdex_]
    ruleDetails.limitScore = guiZe.fd == 1 and 300 or 0
    ruleDetails.redBlack = 0
    ruleDetails.minHuXi = 15
    ruleDetails.xiTunCalc = 3
    ruleDetails.wuWangBiHu = 0
    return ruleDetails
end

function CreateSWCHZView:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local params = {
        gameType = GAME_YZCHZ, -- 游戏服务类型
        totalRound = self.jushuConf[self.jsIdex_], -- 游戏局数
        consumeType = self.zfIdex_ - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 3, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateSWCHZView 
