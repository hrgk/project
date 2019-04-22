local BaseCreateView = import(".BaseCreateView")
local CreateZZMJView = class("CreateZZMJView", BaseCreateView)

function CreateZZMJView:ctor(isHongZhong,showZFType)
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}
    CreateZZMJView.super.ctor(self)
    self.huType_ = 1
    self.juShuList_ = {}
    self.juShuList_[1] = self.ju1_
    self.juShuList_[2] = self.ju2_
    self.juShuList_[3] = self.ju3_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renShu1_
    self.renshuList_[2] = self.renShu2_
    self.renshuList_[3] = self.renShu3_

    self.niaoList_ = {}
    self.niaoList_[1] = self.niao1_
    self.niaoList_[2] = self.niao2_
    self.niaoList_[3] = self.niao3_
    self.niaoList_[4] = self.niao4_

    self.zhongNiaoList_ = {}
    self.zhongNiaoList_[1] = self.zhongNiao1_
    self.zhongNiaoList_[2] = self.zhongNiao2_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_
    self.paiTypeList_[3] = self.qym_
    
    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self:initZhiFuType_()

    self.price1_:setString("x24")
    self.price2_:setString("x48")
    -- self.price3_:setString("x36")

    self:initJuShu_()
    self:initNiao_()
    self:initWanFa_()
    self:initZhongNiao_()
    self:initHuPai_()
    self:initZXSF_()
    self:initHuType_()
    self:initRenShu_()
    self:initpaiType_()
    createRoomData:setGameIndex(GAME_MJZHUANZHUAN)
    self:setShowZFType(showZFType)
    self.sfsn_:setSelected(zzmjData:getSFN()+0== 1)
    self.price1_:setString("12")
    self.price2_:setString("24")
end

function CreateZZMJView:setData(data)
    dump(data,"CreateZZMJView:setData")
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
    if data.ruleDetails.birdCount ~= 1 then
        self:updateNiaoList_(data.ruleDetails.birdCount/2)
    else
        self:updateNiaoList_(4)
    end
    if data.ruleDetails.fullPai and data.ruleDetails.fullPai > 0 then
        if data.ruleDetails.queYiMen then
            if data.ruleDetails.queYiMen == 1 then
                self:updatepaiTypeList_(3)
            else
                self:updatepaiTypeList_(data.ruleDetails.fullPai)
            end
        else
            self:updatepaiTypeList_(data.ruleDetails.fullPai)
        end
    end
    self:updateZhongNiaoList_(data.ruleDetails.birdType+1)
    self.buKeQiDui_:setSelected(data.ruleDetails.isSevenPairs == 1)
    self.zxsf_:setSelected(data.ruleDetails.zhuangXian == 1)
    self.keJiePao_:setSelected(data.ruleDetails.huType == 1)
    self.huType_ = data.ruleDetails.huType
    self.qiangZhiHu_ = data.ruleDetails.qiangZhiHu
    self.playerCount_ = data.ruleDetails.totalSeat
    self.niaoCount_ = data.ruleDetails.birdCount
    self.yiMaQuanZhong_ = data.ruleDetails.yiMaQuanZhong
    self.buHuQiDui_ = data.ruleDetails.isSevenPairs
    self.isHongZhong_ = data.ruleDetails.isHongZhong
    self.zxsf = data.ruleDetails.zhuangXian
    self.zhongNiaoType_ = data.ruleDetails.birdType
    self.juShuCount_ = data.juShu
    self.zhiFuType_ = data.consumeType
    self.yiMaQuanZhong_ = true
    self.paiType_ = data.ruleDetails.fullPai or 0
    if self.niaoCount_ == 2 or self.niaoCount_ == 4 or self.niaoCount_ == 6 then
        self.yiMaQuanZhong_ = false
    end
    if data.ruleDetails.siFangNiao then
        self.sfsn_:setSelected(data.ruleDetails.siFangNiao == 1)
    end
end

function CreateZZMJView:initpaiType_()
    local index = tonumber(zzmjData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateZZMJView:paiType1Handler_()
    zzmjData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateZZMJView:paiType2Handler_()
    zzmjData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateZZMJView:qymHandler_(item)
    zzmjData:setpaiType(3)
    self.paiType_ = 1
    self:updatepaiTypeList_(3)
end


function CreateZZMJView:updatepaiTypeList_(index)
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

function CreateZZMJView:initZhiFuType_()
    local index = tonumber(zzmjData:getZhiFu())
    self:updateZhiFuList_(index)
    if self.zhiFuList_[index] then
        self.zhiFuList_[index]:setSelected(true)
    else
        self.zhiFuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.zhiFuType_ = 0
    elseif index == 2 then
        self.zhiFuType_ = 1
    else
        self.zhiFuType_ = 2
    end
end

function CreateZZMJView:updateZhiFuList_(index)
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

function CreateZZMJView:initHuPai_()
    local index = tonumber(zzmjData:getHuPai())
    self.qiangZhiHu_ = 1
end

function CreateZZMJView:initHuType_()
    local index = tonumber(zzmjData:getKeJiePao())
    if index == 1 then
        self.keJiePao_:setSelected(true)
    else
        self.keJiePao_:setSelected(false)
    end
    self.huType_ = index
end

function CreateZZMJView:initJuShu_()
    local index = tonumber(zzmjData:getJuShu())
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.juShuCount_ = 8 
    elseif index == 2 then 
        self.juShuCount_ = 16
    else
        self.juShuCount_ = 24
    end
end

function CreateZZMJView:initRenShu_()
    local index = tonumber(zzmjData:getRenShu())
    self:updateRenShuList_(index)
    if self.renshuList_[index] then
        self.renshuList_[index]:setSelected(true)
    else
        self.renshuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.playerCount_ = 3 
    elseif index == 2 then 
        self.playerCount_ = 4
    elseif index == 3 then
        self.playerCount_ = 2 
    end
end

function CreateZZMJView:initNiao_()
    local index = tonumber(zzmjData:getNiao())
    self:updateNiaoList_(index)
    if self.niaoList_[index] then
        self.niaoList_[index]:setSelected(true)
    else
        self.niaoList_[1]:setSelected(true)
    end
    self.yiMaQuanZhong_ = false
    if index == 1 then
        self.niaoCount_ = 2 
    elseif index == 2 then 
        self.niaoCount_ = 4
    elseif index == 3 then 
        self.niaoCount_ = 6
    else
        self.niaoCount_ = 1
        self.yiMaQuanZhong_ = true
    end
end

function CreateZZMJView:initZhongNiao_()
    local index = tonumber(zzmjData:getZhongNiao())
    self.zhongNiao1_:setSelected(index == 0)
--    self:updateZhongNiaoList_(index+1)
--    if self.zhongNiaoList_[index+1] then
--        self.zhongNiaoList_[index+1]:setSelected(true)
--        self.zhongNiaoType_ = index
--    else
--        self.zhongNiaoList_[1]:setSelected(true)
--        self.zhongNiaoType_ = 0
--    end
end

function CreateZZMJView:initWanFa_()
    local index = tonumber(zzmjData:getWanFa())
    if index == 1 then
        self.buKeQiDui_:setSelected(true)
    else
        self.buKeQiDui_:setSelected(false)
    end
    self.buHuQiDui_ = index
end

function CreateZZMJView:initZXSF_()
    local index = tonumber(zzmjData:getZX())
    if index == 1 then
        self.zxsf_:setSelected(true)
    else
        self.zxsf_:setSelected(false)
    end
    self.zxsf = index
end


function CreateZZMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createZZMJ.csb"):addTo(self)
end

function CreateZZMJView:updateJuShuList_(index)
    for i,v in ipairs(self.juShuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateZZMJView:updateNiaoList_(index)
    for i,v in ipairs(self.niaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateZZMJView:updateZhongNiaoList_(index)
--    for i,v in ipairs(self.zhongNiaoList_) do
--        if index ~= i then
--            v:setSelected(false)
--            v:setEnabled(true)
--        else
--            v:setSelected(true)
--            v:setEnabled(false)
--        end
--    end
end

function CreateZZMJView:updateRenShuList_(index)
    for i,v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.paiTypePic_:setVisible(index == 3)
    for i = 1,2 do
        self["paiType" .. i .. "_"]:setVisible(index == 3)
        self["paiTypeTip" .. i .. "_"]:setVisible(index == 3)
    end
    self.qym_:setVisible((index == 3))
    self.qymFont_:setVisible((index == 3))
    self.sfsn_:setVisible((index == 3))
    self.sfsnFont_:setVisible((index == 3))
    if index ~= 3 then
        self.paiType_ = 0
    end
end

function CreateZZMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    zzmjData:setZhiFu(1)
end

function CreateZZMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    zzmjData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateZZMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    zzmjData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateZZMJView:ju1Handler_()
    zzmjData:setJuShu(1)
    self:updateJuShuList_(1)
    self.juShuCount_ = 8
end

function CreateZZMJView:ju2Handler_()
    zzmjData:setJuShu(2)
    self:updateJuShuList_(2)
    self.juShuCount_ = 16
end

function CreateZZMJView:ju3Handler_()
    zzmjData:setJuShu(3)
    self:updateJuShuList_(3)
    self.juShuCount_ = 24
end

function CreateZZMJView:niao1Handler_()
    zzmjData:setNiao(1)
    self:updateNiaoList_(1)
    self.niaoCount_ = 2
    self.yiMaQuanZhong_ = false
end

function CreateZZMJView:niao2Handler_()
    zzmjData:setNiao(2)
    self:updateNiaoList_(2)
    self.niaoCount_ = 4
    self.yiMaQuanZhong_ = false
end

function CreateZZMJView:niao3Handler_()
    zzmjData:setNiao(3)
    self:updateNiaoList_(3)
    self.niaoCount_ = 6
    self.yiMaQuanZhong_ = false
end

function CreateZZMJView:niao4Handler_()
    zzmjData:setNiao(4)
    self:updateNiaoList_(4)
    self.niaoCount_ = 1
    self.yiMaQuanZhong_ = true
end

function CreateZZMJView:renShu1Handler_()
    zzmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateZZMJView:renShu2Handler_()
    zzmjData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateZZMJView:renShu3Handler_()
    zzmjData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end

function CreateZZMJView:zhongNiao1Handler_(item)
--    zzmjData:setZhongNiao(0)
--    self:updateZhongNiaoList_(1)
--    self.zhongNiaoType_ = 0
    if item:isSelected() then
        zzmjData:setZhongNiao(0)
        self.zhongNiaoType_ = 0
    else
        zzmjData:setZhongNiao(1)
        self.zhongNiaoType_ = -1
    end
end

function CreateZZMJView:zhongNiao2Handler_()
    zzmjData:setZhongNiao(1)
    self:updateZhongNiaoList_(2)
    self.zhongNiaoType_ = 1
end

function CreateZZMJView:buKeQiDuiHandler_(item)
    if item:isSelected() then
        self.buHuQiDui_ = 1 
    else
        self.buHuQiDui_ = 0 
    end
    zzmjData:setWanFa(self.buHuQiDui_)
end

function CreateZZMJView:keJiePaoHandler_(item)
    if item:isSelected() then
        self.huType_ = 1 
    else
        self.huType_ = 0 
    end
    zzmjData:setKeJiePao(self.huType_)
end

function CreateZZMJView:zxsfHandler_(item)
    if item:isSelected() then
        self.zxsf = 1 
    else
        self.zxsf = 0 
    end
    zzmjData:setZX(self.zxsf)
end

function CreateZZMJView:huPaiHandler_(item)
    if item:isSelected() then
        self.qiangZhiHu_ = 1 
    else
        self.qiangZhiHu_ = 0 
    end
    zzmjData:setHuPai(self.qiangZhiHu_)
end

function CreateZZMJView:calcCreateRoomParams()
    local ruleDetails = {
                            huType = self.huType_,  -- 胡牌类型 1 可接炮 0  自摸胡
                            limitScore = 0,  -- 单局得分上限
                            qiangZhiHu = self.qiangZhiHu_,
                            totalSeat = self.playerCount_,
                            birdCount = self.niaoCount_,  -- 抓几鸟
                            yiMaQuanZhong = self.yiMaQuanZhong_,--一码全中
                            isSevenPairs = self.buHuQiDui_,  -- 可胡七对
                            isHongZhong = 0,  -- 是否带红中
                            zhuangXian = self.zxsf,  -- 是否庄闲算分
                            birdScore = 1, -- 中鸟时一个鸟多少分
                            fixedBird = 0, -- 预留鸟牌
                            canQiangGangHu = 1, -- 抢杠胡
                            piaoScore = 0,  -- 飘几分
                            birdType = self.zhongNiaoType_,  -- 是否时顺序鸟 0为159中鸟 1为顺序鸟
                            fullPai = self.paiType_,
                            queYiMen = self.qym_:isSelected() and 1 or 0,
                            siFangNiao = self.sfsn_:isSelected() and 1 or 0,
                        }
                        zzmjData:setQYM(ruleDetails.queYiMen)
                        zzmjData:setSFN(ruleDetails.siFangNiao)
    if self.playerCount_ ~= 2 then
        ruleDetails.fullPai = 0
        ruleDetails.queYiMen = 0
        ruleDetails.siFangNiao = 0
    end                        
    local mjHuType = 0
    local params = {
        gameType = GAME_MJZHUANZHUAN, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = ruleDetails -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }

    dump(params)
    return params
end

return CreateZZMJView 
