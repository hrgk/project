local BaseCreateView = import(".BaseCreateView")
local CreateHZMJView = class("CreateHZMJView", BaseCreateView)

function CreateHZMJView:ctor(isHongZhong,showZFType)
    self.isHongZhong_ = isHongZhong
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}
    CreateHZMJView.super.ctor(self)
    self.huType_ = 0
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

    self.nfList_ = {}
    self.nfList_[1] = self.nf1_
    self.nfList_[2] = self.nf2_

    self.addNiaoList_ = {}
    self.addNiaoList_[1] = self.addNiao1_
    self.addNiaoList_[2] = self.addNiao2_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.qggzList_ = {}
    self.qggzList_[1] = self.qggz1_
    self.qggzList_[2] = self.qggz2_
    self.qggzList_[3] = self.qggz3_

    self:initZhiFuType_()

    self.price1_:setString("x24")
    self.price2_:setString("x48")
    -- self.price3_:setString("x36")
    self:initNF_()
    self:initJuShu_()
    self:initNiao_()
    self:initWanFa_()
    self:initZhongNiao_()
    self:initAddNiao_()
    self:initqggz_()
    self:initRenShu_()
    self:initpaiType_()
    createRoomData:setGameIndex(GAME_MJHONGZHONG)
    self:setShowZFType(showZFType)
    self.sfsn_:setSelected(hzmjData:getSFN()+0== 1)
    self.csbNode_:setScale(1,0.94)
    self:setScale(0.85)
    self.price1_:setString("12")
    self.price2_:setString("24")
end

function CreateHZMJView:setData(data)
    self.csbNode_:setPositionY(self.csbNodePosY+50)
    dump(data,"datadatadatadatadata")
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
    self:updateZhongNiaoList_(data.ruleDetails.birdType+1)
    self:showInitWanFa_(data.ruleDetails.wanFa)
    self.qggz_ = 1
    if data.ruleDetails.canQiangGangHu then
        if data.ruleDetails.canQiangGangHu == 1 then
            self.qggz_ = 1
        elseif data.ruleDetails.canQiangGangHu == 0 then 
            self.qggz_ = 2
        elseif data.ruleDetails.canQiangGangHu == 2 then 
            self.qggz_ = 3
        end
        self:updateqggzList_(self.qggz_)
    end
    if data.ruleDetails.addBirdsCount then
        self:updateAddNiaoList_(data.ruleDetails.addBirdsCount)
    end
    if data.ruleDetails.birdScore then
        self:updatenfList_(data.ruleDetails.birdScore)
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
    self.playerCount_ = data.ruleDetails.totalSeat
    self.niaoCount_ = data.ruleDetails.birdCount
    self.wanFaObj_ = data.ruleDetails.wanFa
    self.zhongNiaoType_ = data.ruleDetails.birdType
    self.juShuCount_ = data.juShu
    self.zhiFuType_ = data.consumeType
    self.paiType_ = data.ruleDetails.fullPai or 0
    self.addNiao_ = data.ruleDetails.addBirdsCount or 1
    self.birdScore_ = data.ruleDetails.birdScore or 1
    if data.ruleDetails.siFangNiao then
        self.sfsn_:setSelected(data.ruleDetails.siFangNiao == 1)
    end
end

function CreateHZMJView:initpaiType_()
    local index = tonumber(hzmjData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateHZMJView:paiType1Handler_()
    hzmjData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateHZMJView:paiType2Handler_()
    hzmjData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateHZMJView:qymHandler_(item)
    hzmjData:setpaiType(3)
    self.paiType_ = 1
    self:updatepaiTypeList_(3)
end

function CreateHZMJView:updatepaiTypeList_(index)
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

function CreateHZMJView:initqggz_()
    local index = tonumber(hzmjData:getqggz())
    self:updateqggzList_(index)
    if self.qggzList_[index] then
        self.qggzList_[index]:setSelected(true)
        self.qggz_ = index
    else
        self.qggzList_[1]:setSelected(true)
        self.qggz_ = 1
    end
end

function CreateHZMJView:qggz1Handler_()
    hzmjData:setqggz(1)
    self:updateqggzList_(1)
    self.qggz_ = 1
end

function CreateHZMJView:qggz2Handler_()
    hzmjData:setqggz(2)
    self:updateqggzList_(2)
    self.qggz_ = 2
end

function CreateHZMJView:qggz3Handler_()
    hzmjData:setqggz(3)
    self:updateqggzList_(3)
    self.qggz_ = 3
end

function CreateHZMJView:updateqggzList_(index)
    for i,v in ipairs(self.qggzList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHZMJView:updateAddNiaoList_(index)
    for i,v in ipairs(self.addNiaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHZMJView:initAddNiao_()
    local index = tonumber(hzmjData:getAddNiao())
    self:updateAddNiaoList_(index)
    if self.addNiaoList_[index] then
        self.addNiaoList_[index]:setSelected(true)
        self.addNiao_ = index
    else
        self.addNiaoList_[1]:setSelected(true)
        self.addNiao_ = 1
    end
end

function CreateHZMJView:addNiao1Handler_()
    hzmjData:setAddNiao(1)
    self:updateAddNiaoList_(1)
    self.addNiao_ = 1
end

function CreateHZMJView:addNiao2Handler_()
    hzmjData:setAddNiao(2)
    self:updateAddNiaoList_(2)
    self.addNiao_ = 2
end

function CreateHZMJView:initNF_()
    local index = tonumber(hzmjData:getNF())
    self:updatenfList_(index)
    if self.nfList_[index] then
        self.nfList_[index]:setSelected(true)
        self.birdScore_ = index
    else
        self.nfList_[1]:setSelected(true)
        self.birdScore_ = 1
    end
end

function CreateHZMJView:nf1Handler_()
    hzmjData:setNF(1)
    self:updatenfList_(1)
    self.birdScore_ = 1
end

function CreateHZMJView:nf2Handler_()
    hzmjData:setNF(2)
    self:updatenfList_(2)
    self.birdScore_ = 2
end

function CreateHZMJView:updatenfList_(index)
    for i,v in ipairs(self.nfList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateHZMJView:initZhiFuType_()
    local index = tonumber(hzmjData:getZhiFu())
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

function CreateHZMJView:updateZhiFuList_(index)
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

function CreateHZMJView:initJuShu_()
    local index = tonumber(hzmjData:getJuShu())
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

function CreateHZMJView:initRenShu_()
    local index = tonumber(hzmjData:getRenShu())
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

function CreateHZMJView:initNiao_()
    local index = tonumber(hzmjData:getNiao())
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

function CreateHZMJView:initZhongNiao_()
    local index = tonumber(hzmjData:getZhongNiao())
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

function CreateHZMJView:initWanFa_()
    local objstr = hzmjData:getWanFa()
    self:showInitWanFa_(json.decode(objstr))
    self.hqxd_:setSelected(self.wanFaObj_.hqxd == 1)
    self.pph_:setSelected(self.wanFaObj_.pph == 1)
    self.qqr_:setSelected(self.wanFaObj_.qqr == 1)
    self.qxd_:setSelected(self.wanFaObj_.qxd == 1)
    self.qys_:setSelected(self.wanFaObj_.qys == 1)
    self.shqxd_:setSelected(self.wanFaObj_.shqxd == 1)
    self.wdw_:setSelected(self.wanFaObj_.wdw == 1)
    self.yh_:setSelected(self.wanFaObj_.yh == 1)
end

function CreateHZMJView:showInitWanFa_(info)
    self.wanFaObj_ = info 
    if self.wanFaObj_ == nil then
        return
    end
    self.hqxd_:setSelected(self.wanFaObj_.hqxd == 1)
    self.pph_:setSelected(self.wanFaObj_.pph == 1)
    self.qqr_:setSelected(self.wanFaObj_.qqr == 1)
    self.qxd_:setSelected(self.wanFaObj_.qxd == 1)
    self.qys_:setSelected(self.wanFaObj_.qys == 1)
    self.shqxd_:setSelected(self.wanFaObj_.shqxd == 1)
    self.wdw_:setSelected(self.wanFaObj_.wdw == 1)
    self.yh_:setSelected(self.wanFaObj_.yh == 1)
end

function CreateHZMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createHZMJ.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreateHZMJView:updateJuShuList_(index)
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

function CreateHZMJView:updateNiaoList_(index)
    for i,v in ipairs(self.niaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.nf1_:setVisible(index ~= 4)
    self.nf2_:setVisible(index ~= 4)
    self.nf1Tip_:setVisible(index ~= 4)
    self.nf2Tip_:setVisible(index ~= 4)
end

function CreateHZMJView:updateZhongNiaoList_(index)
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

function CreateHZMJView:updateRenShuList_(index)
    for i,v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.paiTypePic_:setVisible((index == 3))
    for i = 1,2 do
        self["paiType" .. i .. "_"]:setVisible((index == 3))
        self["paiTypeTip" .. i .. "_"]:setVisible((index == 3))
    end
    self.qym_:setVisible((index == 3))
    self.qymFont_:setVisible((index == 3))
    self.sfsn_:setVisible((index == 3))
    self.sfsnFont_:setVisible((index == 3))
    if index ~= 3 then
        self.paiType_ = 0
    end
end

function CreateHZMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    hzmjData:setZhiFu(1)
end

function CreateHZMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    hzmjData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateHZMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    hzmjData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateHZMJView:ju1Handler_()
    hzmjData:setJuShu(1)
    self:updateJuShuList_(1)
    self.juShuCount_ = 8
end

function CreateHZMJView:ju2Handler_()
    hzmjData:setJuShu(2)
    self:updateJuShuList_(2)
    self.juShuCount_ = 16
end

function CreateHZMJView:ju3Handler_()
    hzmjData:setJuShu(3)
    self:updateJuShuList_(3)
    self.juShuCount_ = 24
end

function CreateHZMJView:niao1Handler_()
    hzmjData:setNiao(1)
    self:updateNiaoList_(1)
    self.niaoCount_ = 2
    self.yiMaQuanZhong_ = false
end

function CreateHZMJView:niao2Handler_()
    hzmjData:setNiao(2)
    self:updateNiaoList_(2)
    self.niaoCount_ = 4
    self.yiMaQuanZhong_ = false
end

function CreateHZMJView:niao3Handler_()
    hzmjData:setNiao(3)
    self:updateNiaoList_(3)
    self.niaoCount_ = 6
    self.yiMaQuanZhong_ = false
end

function CreateHZMJView:niao4Handler_()
    hzmjData:setNiao(4)
    self:updateNiaoList_(4)
    self.niaoCount_ = 1
    self.yiMaQuanZhong_ = true
end

function CreateHZMJView:renShu1Handler_()
    hzmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateHZMJView:renShu2Handler_()
    hzmjData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateHZMJView:renShu3Handler_()
    hzmjData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end


function CreateHZMJView:zhongNiao1Handler_(item)
    if item:isSelected() then
        hzmjData:setZhongNiao(0)
        self.zhongNiaoType_ = 0
    else
        hzmjData:setZhongNiao(1)
        self.zhongNiaoType_ = -1
    end
   
end

function CreateHZMJView:zhongNiao2Handler_()
    hzmjData:setZhongNiao(1)
    self:updateZhongNiaoList_(2)
    self.zhongNiaoType_ = 1
end

function CreateHZMJView:hqxdHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.hqxd = 1
    else
        self.wanFaObj_.hqxd = 0
    end
end

function CreateHZMJView:pphHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.pph = 1
    else
        self.wanFaObj_.pph = 0
    end
end

function CreateHZMJView:qqrHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.qqr = 1
    else
        self.wanFaObj_.qqr = 0
    end
end

function CreateHZMJView:qxdHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.qxd = 1
    else
        self.wanFaObj_.qxd = 0
    end
end

function CreateHZMJView:qysHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.qys = 1
    else
        self.wanFaObj_.qys = 0
    end
end

function CreateHZMJView:shqxdHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.shqxd = 1
    else
        self.wanFaObj_.shqxd = 0
    end
end

function CreateHZMJView:wdwHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.wdw = 1
    else
        self.wanFaObj_.wdw = 0
    end
end

function CreateHZMJView:yhHandler_(item)
    if item:isSelected() then
        self.wanFaObj_.yh = 1
    else
        self.wanFaObj_.yh = 0
    end
end

function CreateHZMJView:zxsfHandler_(item)
    if item:isSelected() then
        self.zxsf = 1 
    else
        self.zxsf = 0 
    end
    hzmjData:setZX(self.zxsf)
end

function CreateHZMJView:calcCreateRoomParams()
    local ruleDetails = {
                            huType = 0,  -- 胡牌类型 1 可接炮 0  自摸胡
                            limitScore = 0,  -- 单局得分上限
                            qiangZhiHu = self.qiangZhiHu_,
                            totalSeat = self.playerCount_,
                            birdCount = self.niaoCount_,  -- 抓几鸟
                            yiMaQuanZhong = self.yiMaQuanZhong_,--一码全中
                            isSevenPairs = self.buHuQiDui_,  -- 可胡七对
                            isHongZhong = self.isHongZhong_,  -- 是否带红中
                            zhuangXian = self.zxsf,  -- 是否庄闲算分
                            wanFa = self.wanFaObj_, -- 玩法
                            birdScore = self.birdScore_, -- 中鸟时一个鸟多少分
                            fixedBird = 0, -- 预留鸟牌
                            canQiangGangHu = self.qggz_ == 1 and 1 or 0, -- 抢杠胡
                            piaoScore = 0,  -- 飘几分
                            birdType = self.zhongNiaoType_,  -- 是否时顺序鸟 0为159中鸟 1为顺序鸟
                            fullPai = self.paiType_,
                            addBirdsCount = self.addNiao_,
                            queYiMen = self.qym_:isSelected() and 1 or 0,
                            siFangNiao = self.sfsn_:isSelected() and 1 or 0,
                        }
    hzmjData:setQYM(ruleDetails.queYiMen)
    hzmjData:setSFN(ruleDetails.siFangNiao)
    if self.qggz_ == 1 then
        ruleDetails.canQiangGangHu = 1
    elseif self.qggz_ == 2 then 
        ruleDetails.canQiangGangHu = 0
    elseif self.qggz_ == 3 then 
        ruleDetails.canQiangGangHu = 2
    end
    if self.playerCount_ ~= 2 then
        ruleDetails.fullPai = 0
        ruleDetails.queYiMen = 0
        ruleDetails.siFangNiao = 0
    end   
    dump(ruleDetails,"ruleDetails")
    local mjHuType = 0
    local params = {
        gameType = GAME_MJHONGZHONG, -- 游戏服务类型
        totalRound = self.juShuCount_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = ruleDetails -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(self.wanFaObj_,"self.wanFaObj_self.wanFaObj_")
    hzmjData:setWanFa(json.encode(self.wanFaObj_))
    return params
end

return CreateHZMJView 
