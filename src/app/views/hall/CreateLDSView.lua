local BaseCreateView = import(".BaseCreateView")
local CreateLDSView = class("CreateLDSView", BaseCreateView)

function CreateLDSView:ctor(showZFType)
    CreateLDSView.super.ctor(self)
    self.jushuConf = {8,16}
    self.renShuConf = {3,2,4}
    self.juShuList_ = {}
    self.juShuList_[1] = self.juShu1_
    self.juShuList_[2] = self.juShu2_

    self.rsList_ = {}
    self.rsList_[1] = self.ren3_
    self.rsList_[2] = self.ren2_
    self.rsList_[3] = self.ren4_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.wNumList_ = {}
    self.wNumList_[1] = self.wNum1_
    self.wNumList_[2] = self.wNum2_
    self.wNumList_[3] = self.wNum3_

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

function CreateLDSView:setData(data)
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
    self:updatewfList_(data.rules.xingType)
    self:updatewNumList_(data.rules.wangCount + 1)
end

function CreateLDSView:initShow()
    local guiZe = xtyzchzData:getRuleInfo()
    self:updateJuShuList_(guiZe.jushu)
    self:updateRSList_(guiZe.rs)
    self:updateZFList_(guiZe.zhifu)
    self:updatewfList_(guiZe.wf)
    self:updatewNumList_(guiZe.wNum)
    self.fd_:setSelected(guiZe.fd == 1)
end

function CreateLDSView:initElement_()
    CreateLDSView.super.initElement_(self)
end

function CreateLDSView:wf1Handler_()
    self:updatewfList_(1)
end

function CreateLDSView:wf2Handler_()
    self:updatewfList_(2)
end

function CreateLDSView:updatewfList_(index)
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

function CreateLDSView:wNum1Handler_()
    self:updatewNumList_(1)
end

function CreateLDSView:wNum2Handler_()
    self:updatewNumList_(2)
end

function CreateLDSView:wNum3Handler_()
    self:updatewNumList_(3)
end

function CreateLDSView:updatewNumList_(index)
    for i, v in ipairs(self.wNumList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.wNumIdex_ = index
end

function CreateLDSView:ren3Handler_()
    self:updateRSList_(1)
end

function CreateLDSView:ren2Handler_()
    self:updateRSList_(2)
end

function CreateLDSView:ren4Handler_()
    self:updateRSList_(3)
end

function CreateLDSView:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateLDSView:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateLDSView:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateLDSView:updateRSList_(index)
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

function CreateLDSView:juShu1Handler_()
    self:updateJuShuList_(1)
end

function CreateLDSView:juShu2Handler_()
    self:updateJuShuList_(2)
end

function CreateLDSView:updateJuShuList_(index)
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

function CreateLDSView:updateZFList_(index)
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

function CreateLDSView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createLDS.csb"):addTo(self)
end

function CreateLDSView:getRuleInfo()
    local guiZe = {
        ["jushu"] = self.jsIdex_,
        ["wf"] = self.wfIdex_,
        ["rs"] = self.rsIdex_,
        ["zhifu"] = self.zfIdex_,
        ["xh"] = 1,
        ["wNum"] = self.wNumIdex_,
        ["fd"] = self.fd_:isSelected() and 1 or 0,
        ["hzzh"] = 0,
    }
    local str = json.encode(guiZe)
    xtyzchzData:setRuleInfo(str)
    local ruleDetails = {}
    ruleDetails.wangCount = self.wNumIdex_ - 1
    ruleDetails.xingType = self.wfIdex_
    ruleDetails.huType = 1
    ruleDetails.totalSeat = self.renShuConf[self.rsIdex_]
    ruleDetails.limitScore = guiZe.fd == 1 and 300 or 0
    ruleDetails.redBlack = 0
    ruleDetails.minHuXi = 15
    ruleDetails.xiTunCalc = 3
    ruleDetails.wuWangBiHu = 0
    if ruleDetails.totalSeat == 4 then
        ruleDetails.minHuXi = 6
        ruleDetails.xiTunCalc = 1
    end
    return ruleDetails
end

function CreateLDSView:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local params = {
        gameType = GAME_YZCHZ, -- 游戏服务类型
        totalRound = self.jushuConf[self.jsIdex_], -- 游戏局数
        consumeType = self.zfIdex_ - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 4, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"paramsparamsparamsparams")
    return params
end

return CreateLDSView 
