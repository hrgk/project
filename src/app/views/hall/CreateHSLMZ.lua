local BaseCreateView = import(".BaseCreateView")
local CreateHSLMZ = class("CreateHSLMZ", BaseCreateView)

function CreateHSLMZ:ctor()
    CreateHSLMZ.super.ctor(self)
    self.jushuConf = {10,20,30}
    self.renShuConf = {2,3}
    self.juShuList_ = {}
    self.juShuList_[1] = self.jushu1_
    self.juShuList_[2] = self.jushu2_
    self.juShuList_[3] = self.jushu3_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renshu1_
    self.renshuList_[2] = self.renshu2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.fzbList_ = {}
    self.fzbList_[1] = self.fzb1_
    self.fzbList_[2] = self.fzb2_
    self.fzbList_[3] = self.fzb3_


    self.xianShouList_ = {}
    self.xianShouList_[1] = self.xianshou1_
    self.xianShouList_[2] = self.xianshou2_


    self.siDaiList_ = {}
    self.siDaiList_[1] = self.siDai1_
    self.siDaiList_[2] = self.siDai2_

    self:updateJuShuList_(tonumber(nxData:getJuShu()))
    self:updateRenShuList_(tonumber(nxData:getRenShu()))
    self:updateZhiFuList_(tonumber(nxData:getZhiFu()))
    local fzbIndex = tonumber(nxData:getFZBINDEX())
    if fzbIndex == 1 then
        self.fangZuoBi_  = 0
        self.simpleFangZuoBi_ = 0 
    elseif fzbIndex == 2 then
        self.fangZuoBi_  = 1
        self.simpleFangZuoBi_ = 1 
    elseif fzbIndex == 3 then
        self.fangZuoBi_  = 1
        self.simpleFangZuoBi_ = 0 
    end
    self:updateFZBList_(fzbIndex)

    self:updateXianShouList_(tonumber(nxData:getXianShou()) or 1)
    self:updateSiDaiList_(tonumber(nxData:get4dai()) or 1)


    self.cardNum_:setSelected(tonumber(nxData:getCardNum()) == 1)
    self.a3d1_:setSelected(tonumber(nxData:get3ad1()) == 1)
    self.bizha_:setSelected(tonumber(nxData:getBiZha()) == 1)
    self.danchu_:setSelected(tonumber(nxData:getDan2()) == 1)

    self.biZha_ = tonumber(nxData:getBiZha())
    self.sanADaiYi_ = tonumber(nxData:get3ad1())
    self.xianPai_ = tonumber(nxData:getCardNum())
    self.danChu2_ = tonumber(nxData:getDan2())
end

function CreateHSLMZ:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createLMZ.csb"):addTo(self)
end

function CreateHSLMZ:zhifu1Handler_()
    self:updateZhiFuList_(1)
end

function CreateHSLMZ:zhifu2Handler_()
    self:updateZhiFuList_(2)
end

function CreateHSLMZ:zhifu3Handler_()
    self:updateZhiFuList_(3)
end

function CreateHSLMZ:jushu1Handler_()
    self:updateJuShuList_(1)
end

function CreateHSLMZ:jushu2Handler_()
    self:updateJuShuList_(2)
end

function CreateHSLMZ:jushu3Handler_()
    self:updateJuShuList_(3)
end

function CreateHSLMZ:renshu1Handler_()
    self:updateRenShuList_(1)
end

function CreateHSLMZ:renshu2Handler_()
    self:updateRenShuList_(2)
end

function CreateHSLMZ:xianshou1Handler_()
    self:updateXianShouList_(1)
end

function CreateHSLMZ:xianshou2Handler_()
    self:updateXianShouList_(2)
end

function CreateHSLMZ:siDai1Handler_()
    self:updateSiDaiList_(1)
end

function CreateHSLMZ:siDai2Handler_()
    self:updateSiDaiList_(2)
end

function CreateHSLMZ:fzb1Handler_()
    self:updateFZBList_(1)
    self.fangZuoBi_  = 0
    self.simpleFangZuoBi_ = 0 
end

function CreateHSLMZ:fzb2Handler_()
    self:updateFZBList_(2)
    self.fangZuoBi_  = 1
    self.simpleFangZuoBi_ = 1 
end

function CreateHSLMZ:fzb3Handler_()
    self:updateFZBList_(3)
    self.fangZuoBi_  = 1
    self.simpleFangZuoBi_ = 0 
end

function CreateHSLMZ:cardNumHandler_(item)
    if item:isSelected() then
        self.xianPai_ = 1
    else
        self.xianPai_ = 0
    end
    nxData:setCardNum(self.xianPai_)
end

function CreateHSLMZ:a3d1Handler_(item)
    if item:isSelected() then
        self.sanADaiYi_ = 1
    else
        self.sanADaiYi_ = 0
    end
    nxData:set3ad1(self.sanADaiYi_)
end

function CreateHSLMZ:danchuHandler_(item)
    if item:isSelected() then
        self.danChu2_ = 1
    else
        self.danChu2_ = 0
    end
    nxData:setDan2(self.danChu2_)
end

function CreateHSLMZ:bizhaHandler_(item)
    if item:isSelected() then
        self.biZha_ = 1
    else
        self.biZha_ = 0
    end
    nxData:setBiZha(self.biZha_)
end

function CreateHSLMZ:updateXianShouList_(index)
    self.xianShouType_ = index - 1
    nxData:setXianShou(index)
    for i, v in ipairs(self.xianShouList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSLMZ:updateSiDaiList_(index)
    self.siDaiType_ = index - 1
    nxData:set4dai(index)
    for i, v in ipairs(self.siDaiList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSLMZ:updateJuShuList_(index)
    nxData:setJuShu(index)
    self.juShuCount_ = self.jushuConf[index]
    for i, v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSLMZ:updateRenShuList_(index)
    nxData:setRenShu(index)
    self.playerCount_ = self.renShuConf[index]
    for i, v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSLMZ:updateZhiFuList_(index)
    nxData:setZhiFu(index)
    self.zhiFuType_ = index - 1
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

function CreateHSLMZ:updateFZBList_(index)
    nxData:setFZBINDEX(index)
    self.zhiFuType_ = index
    for i, v in ipairs(self.fzbList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSLMZ:setData(data)
    dump(data)
    local config = data.config
    local rules = config.rules
    if config.juShu == 10 then
        self:updateJuShuList_(1)
    elseif config.juShu == 20 then
        self:updateJuShuList_(2)
    elseif config.juShu == 30 then
        self:updateJuShuList_(3)
    end
    if rules.playerCount == 2 then
        self:updateRenShuList_(1)
    else
        self:updateRenShuList_(2)
    end
    self:updateZhiFuList_(config.consumeType+1)
    if rules.fang_zuo_bi == 0 and rules.simple_fang_zuo_bi == 0 then
        self:updateFZBList_(1)
    elseif rules.fang_zuo_bi == 1 and rules.simple_fang_zuo_bi == 1 then
        self:updateFZBList_(2)
    elseif rules.fang_zuo_bi == 1 and rules.simple_fang_zuo_bi == 1 then
        self:updateFZBList_(3)
    end

    self:updateXianShouList_(rules.xian_chu_type + 1)
    self:updateSiDaiList_(rules.siDaiType + 1)
    self.cardNum_:setSelected(rules.xianPai == 1)
    self.a3d1_:setSelected(rules.sanADaiYi == 1)
    self.bizha_:setSelected(rules.youZhaBiZha == 1)
    self.danchu_:setSelected(rules.singleAttack2 == 1)
end

function CreateHSLMZ:calcCreateRoomParams(daiKai)
    local guiZe = {}
    guiZe.cardCount = self.paiCount_
    guiZe.xianPai = self.xianPai_
    guiZe.playerCount = self.playerCount_
    guiZe.youZhaBiZha = self.biZha_
    guiZe.cardCount = 16
    guiZe.bao_dan_type = 1
    guiZe.xian_chu_type = self.xianShouType_
    guiZe.siDaiType = self.siDaiType_
    guiZe.singleAttack2 = self.danChu2_
    guiZe.fang_zuo_bi = self.fangZuoBi_ 
    guiZe.simple_fang_zuo_bi = self.simpleFangZuoBi_ 
    guiZe.sanADaiYi = self.sanADaiYi_
    local params = {
        gameType = GAME_FHLMZ, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0, -- 代开 0为否 1为是
        ipLimit = 0, -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1, -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"paramsparamsparams")
    return params
end

return CreateHSLMZ 
