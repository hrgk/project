local BaseCreateView = import(".BaseCreateView")
local CreateJY15View = class("CreateJY15View", BaseCreateView)

function CreateJY15View:ctor(showZFType)
    CreateJY15View.super.ctor(self)
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

function CreateJY15View:setData(data)
    dump(data,"CreateJY15View:setData")
    self:updateZFList_(data.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.totalRound then
            self:updateJuShuList_(key)
            break
        end
    end
    for key,value in pairs(self.renShuConf) do
        if value == data.rules.totalSeat then
            print("keykeykeykeykey",key)
            self:updateRSList_(key)
            break
        end
    end
    self.fd_:setSelected(data.rules.limitScore > 0)
    self:updatexhList_(data.rules.huType == 3 and 1 or 2)
    self:updatewfList_(data.rules.xingType)
end

function CreateJY15View:initShow()
    local guiZe = xtyzchzData:getRuleInfo()
    self:updateJuShuList_(guiZe.jushu)
    self:updateRSList_(guiZe.rs)
    self:updateZFList_(guiZe.zhifu)
    self:updatexhList_(guiZe.xh)
    self:updatewfList_(guiZe.wf)
    self.fd_:setSelected(guiZe.fd == 1)
end

function CreateJY15View:initElement_()
    CreateJY15View.super.initElement_(self)
end

function CreateJY15View:xh1Handler_()
    self:updatexhList_(1)
end

function CreateJY15View:xh2Handler_()
    self:updatexhList_(2)
end

function CreateJY15View:updatexhList_(index)
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

function CreateJY15View:wf1Handler_()
    self:updatewfList_(1)
end

function CreateJY15View:wf2Handler_()
    self:updatewfList_(2)
end

function CreateJY15View:updatewfList_(index)
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

function CreateJY15View:ren3Handler_()
    self:updateRSList_(1)
end

function CreateJY15View:ren2Handler_()
    self:updateRSList_(2)
end

function CreateJY15View:ren4Handler_()
    self:updateRSList_(3)
end

function CreateJY15View:zhifu1Handler_()
    self:updateZFList_(1)
end

function CreateJY15View:zhifu2Handler_()
    self:updateZFList_(2)
end

function CreateJY15View:zhifu3Handler_()
    self:updateZFList_(3)
end

function CreateJY15View:updateRSList_(index)
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

function CreateJY15View:juShu1Handler_()
    self:updateJuShuList_(1)
end

function CreateJY15View:juShu2Handler_()
    self:updateJuShuList_(2)
end

function CreateJY15View:updateJuShuList_(index)
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

function CreateJY15View:updateZFList_(index)
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

function CreateJY15View:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createJY15.csb"):addTo(self)
end

function CreateJY15View:getRuleInfo()
    local guiZe = {
        ["jushu"] = self.jsIdex_,
        ["wf"] = self.wfIdex_,
        ["rs"] = self.rsIdex_,
        ["zhifu"] = self.zfIdex_,
        ["xh"] = self.xhIdex_,
        ["wNum"] = 1,
        ["fd"] = self.fd_:isSelected() and 1 or 0,
        ["hzzh"] = 0,
    }
    local str = json.encode(guiZe)
    xtyzchzData:setRuleInfo(str)
    local ruleDetails = {}
    ruleDetails.wangCount = 0
    ruleDetails.xingType = self.wfIdex_
    ruleDetails.huType = 1
    ruleDetails.totalSeat = self.renShuConf[self.rsIdex_]
    ruleDetails.limitScore = guiZe.fd == 1 and 300 or 0
    ruleDetails.redBlack = 0
    ruleDetails.minHuXi = 6
    ruleDetails.xiTunCalc = 1
    ruleDetails.wuWangBiHu = 1
    return ruleDetails
end

function CreateJY15View:calcCreateRoomParams(daiKai)
    local guiZe = self:getRuleInfo()
    local params = {
        gameType = GAME_YZCHZ, -- 游戏服务类型
        totalRound = self.jushuConf[self.jsIdex_], -- 游戏局数
        consumeType = self.zfIdex_ - 1,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 5, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateJY15View 
