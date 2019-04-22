local BaseCreateView = import(".BaseCreateView")
local CreateHSMJView = class("CreateHSMJView", BaseCreateView)

function CreateHSMJView:ctor(isHongZhong,showZFType)
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}
    self.xyNum = 0
    CreateHSMJView.super.ctor(self)
    self.huType_ = 1
    self.juShuList_ = {}
    self.juShuList_[1] = self.ju1_
    self.juShuList_[2] = self.ju2_
    self.juShuList_[3] = self.ju3_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renShu1_
    self.renshuList_[2] = self.renShu2_
    self.renshuList_[3] = self.renShu3_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_
    
    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_
    
    self.hutypeList_ = {}
    self.hutypeList_[1] = self.hutype1_
    self.hutypeList_[2] = self.hutype2_

    self.fpList_ = {}
    self.fpList_[1] = self.fp1_
    self.fpList_[2] = self.fp2_

    self.zbList_ = {}
    self.zbList_[1] = self.zb1_
    self.zbList_[2] = self.zb2_

    self:initZhiFuType_()
    self:initJuShu_()
    self:initXY_()
    self:initHutype_()
    self:initFP_()
    self:initZB_()
    self:initRenShu_()
    self:initpaiType_()
    self.ksc_:setSelected(hsmjData:getSKC()+0 == 1)
    self.hztf_:setSelected(hsmjData:getHZTF()+0 == 0)
    self.yp3x_:setSelected(hsmjData:getYP3X()+0 == 1)
    self.pph_:setSelected(hsmjData:getPPH()+0 == 1)
    self.gzxj_:setSelected(hsmjData:getGZXJ()+0 == 1)
    self.hzxj_:setSelected(hsmjData:getHZXJ()+0 == 1)
    self.bh_:setSelected(hsmjData:getBH()+0 == 1)
    createRoomData:setGameIndex(GAME_MJZHUANZHUAN)
    self:setShowZFType(showZFType)
end

function CreateHSMJView:setData(data,needCZ)
    dump(data,"CreateHSMJView:setData")
    self:updateZhiFuList_(data.consumeType+1)
    for key,value in pairs(self.jushuConf) do
        if value == data.juShu then
            self:updateJuShuList_(key)
            break
        end
    end
    for key,value in pairs(self.renShuConf) do
        if value == data.ruleDetails.totalSeat then
            self:updateRenShuList_(key)
            break
        end
    end
    if data.ruleDetails.fullPai and data.ruleDetails.fullPai > 0 then
        self:updatepaiTypeList_(data.ruleDetails.fullPai)
    end
    if not needCZ then
        self.yzAdd_:hide()
        self.yzReduce_:hide()
    end
 
    self.yzNum_:setString(data.ruleDetails.piaoScore)
    self:updatehutypeList_(data.ruleDetails.huType == 1 and 1 or 2)
    self:updatezbList_(data.ruleDetails.autoReady == 1 and 1 or 2)
    self.ksc_:setSelected(data.ruleDetails.paiType == 1)
    self.hztf_:setSelected(data.ruleDetails.tuiGangFen == 0)
    self.yp3x_:setSelected(data.ruleDetails.yiPaoSanXiang == 1)
    self.pph_:setSelected(data.ruleDetails.pengPengHu == 1)
    self.gzxj_:setSelected(data.ruleDetails.genZhuang == 1)
    self.hzxj_:setSelected(data.ruleDetails.huangZhuang == 1)
    self.bh_:setSelected(data.ruleDetails.biHu == 1)
    self.csbNode_:setPositionY(self.csbNodePosY+60)
    self.xyNum = data.ruleDetails.piaoScore
end

function CreateHSMJView:zb1Handler_()
    self:updatezbList_(1)
end

function CreateHSMJView:zb2Handler_()
    self:updatezbList_(2)
end

function CreateHSMJView:updatezbList_(index)
    for i,v in ipairs(self.zbList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.zb_ = index
    hsmjData:setAutoReady(index)
end

function CreateHSMJView:initZB_()
    local index = tonumber(hsmjData:getAutoReady())
    self:updatezbList_(index)
    if self.zbList_[index] then
        self.zbList_[index]:setSelected(true)
        self.zb_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.zb_ = 1
    end
end

function CreateHSMJView:fp1Handler_()
    self:updatefpList_(1)
end

function CreateHSMJView:fp2Handler_()
    self:updatefpList_(2)
end

function CreateHSMJView:updatefpList_(index)
    for i,v in ipairs(self.fpList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.fp_ = index
    hsmjData:setFP(index)
end

function CreateHSMJView:initFP_()
    local index = tonumber(hsmjData:getFP())
    self:updatefpList_(index)
    if self.fpList_[index] then
        self.fpList_[index]:setSelected(true)
        self.fp_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.fp_ = 1
    end
end

function CreateHSMJView:hutype1Handler_()
    self:updatehutypeList_(1)
end

function CreateHSMJView:hutype2Handler_()
    self:updatehutypeList_(2)
end

function CreateHSMJView:updatehutypeList_(index)
    for i,v in ipairs(self.hutypeList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.hutype_ = index
    hsmjData:setHuPai(index)
end

function CreateHSMJView:initHutype_()
    local index = tonumber(hsmjData:getHuPai())
    self:updatehutypeList_(index)
    if self.hutypeList_[index] then
        self.hutypeList_[index]:setSelected(true)
        self.hutype_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.hutype_ = 1
    end
end

function CreateHSMJView:initXY_()
    self.xyNum = tonumber(hsmjData:getXYNuM())
    self.yzNum_:setString(self.xyNum)
end

function CreateHSMJView:yzAddHandler_()
    if self.xyNum < 20 then
        self.xyNum = self.xyNum + 1
    end
    self.yzNum_:setString(self.xyNum)
end

function CreateHSMJView:yzReduceHandler_()
    if self.xyNum > 0 then
        self.xyNum = self.xyNum - 1
    end
    self.yzNum_:setString(self.xyNum)
end

function CreateHSMJView:initpaiType_()
    local index = tonumber(hsmjData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateHSMJView:paiType1Handler_()
    hsmjData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateHSMJView:paiType2Handler_()
    hsmjData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateHSMJView:updatepaiTypeList_(index)
    for i,v in ipairs(self.paiTypeList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHSMJView:initZhiFuType_()
    local index = tonumber(hsmjData:getZhiFu())
    self:updateZhiFuList_(index)
    if self.zhiFuList_[index] then
        self.zhiFuList_[index]:setSelected(true)
    else
        self.zhiFuList_[1]:setSelected(true)
    end
end

function CreateHSMJView:updateZhiFuList_(index)
    for i, v in ipairs(self.zhiFuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.zhiFuType_ = 0
    elseif index == 2 then
        self.zhiFuType_ = 1
    else
        self.zhiFuType_ = 2
    end
end

function CreateHSMJView:initJuShu_()
    local index = tonumber(hsmjData:getJuShu())
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
end

function CreateHSMJView:initRenShu_()
    local index = tonumber(hsmjData:getRenShu())
    self:updateRenShuList_(index)
    if self.renshuList_[index] then
        self.renshuList_[index]:setSelected(true)
    else
        self.renshuList_[1]:setSelected(true)
    end
end

function CreateHSMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createHSMJ.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreateHSMJView:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.juShuCount_ = 8 
    elseif index == 2 then 
        self.juShuCount_ = 16
    else
        self.juShuCount_ = 24
    end
end

function CreateHSMJView:updateRenShuList_(index)
    for i,v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    for i = 1,2 do
        self["paiType" .. i .. "_"]:setVisible(index == 3)
        self["paiTypeTip" .. i .. "_"]:setVisible(index == 3)
    end
    self.gzxj_:setVisible(index ~= 3)
    self.gzxjFont_:setVisible(index ~= 3)
    if index ~= 3 then
        self.paiType_ = 0
    end
    self.price1_:setString("x" .. 8 * self.renShuConf[index])
    self.price2_:setString("x" .. 16 * self.renShuConf[index])
    if index == 1 then
        self.playerCount_ = 3 
    elseif index == 2 then 
        self.playerCount_ = 4
    elseif index == 3 then
        self.playerCount_ = 2 
    end
end

function CreateHSMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    hsmjData:setZhiFu(1)
end

function CreateHSMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    hsmjData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateHSMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    hsmjData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateHSMJView:ju1Handler_()
    hsmjData:setJuShu(1)
    self:updateJuShuList_(1)
    self.juShuCount_ = 8
end

function CreateHSMJView:ju2Handler_()
    hsmjData:setJuShu(2)
    self:updateJuShuList_(2)
    self.juShuCount_ = 16
end

function CreateHSMJView:ju3Handler_()
    hsmjData:setJuShu(3)
    self:updateJuShuList_(3)
    self.juShuCount_ = 24
end

function CreateHSMJView:renShu1Handler_()
    hsmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateHSMJView:renShu2Handler_()
    hsmjData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateHSMJView:renShu3Handler_()
    hsmjData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end

function CreateHSMJView:calcCreateRoomParams()
    local ruleDetails = {
                            huType = self.hutype_ == 1 and 1 or 0,  -- 胡牌类型 1 可接炮 0  自摸胡
                            limitScore = 0,  -- 单局得分上限
                            totalSeat = self.playerCount_,
                            piaoScore = self.xyNum,  -- 几条鱼
                            fullPai = tonumber(hsmjData:getpaiType()),
                            fengPai = self.fp_ == 1 and 1 or 0,
                            autoReady = self.zb_ == 1 and 1 or 0,
                            paiType = self.ksc_:isSelected() and 1 or 0,
                            tuiGangFen = self.hztf_:isSelected() and 0 or 1,
                            yiPaoSanXiang = self.yp3x_:isSelected() and 1 or 0,
                            pengPengHu = self.pph_:isSelected() and 1 or 0,
                            genZhuang = self.gzxj_:isSelected() and 1 or 0,
                            huangZhuang = self.hzxj_:isSelected() and 1 or 0,
                            biHu = self.bh_:isSelected() and 1 or 0,
                        }
    if self.playerCount_ ~= 2 then
        ruleDetails.fullPai = 0
    end
    hsmjData:setXYNuM(self.xyNum)
    hsmjData:setSKC(ruleDetails.paiType)
    hsmjData:setHZTF(ruleDetails.tuiGangFen)
    hsmjData:setYP3X(ruleDetails.yiPaoSanXiang)
    hsmjData:setPPH(ruleDetails.pengPengHu)
    hsmjData:setGZXJ(ruleDetails.genZhuang)
    hsmjData:setHZXJ(ruleDetails.huangZhuang)
    hsmjData:setBH(ruleDetails.biHu)
    if self.playerCount_ == 2 then
        ruleDetails.genZhuang = 0
    end
    local mjHuType = 0
    local params = {
        gameType = GAME_HSMJ, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = ruleDetails -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(params,"CreateHSMJView:calcCreateRoomParams")
    return params
end

return CreateHSMJView 
