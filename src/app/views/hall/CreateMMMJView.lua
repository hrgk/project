local BaseCreateView = import(".BaseCreateView")
local CreateMMMJView = class("CreateMMMJView", BaseCreateView)

function CreateMMMJView:ctor(showZFType)
    CreateMMMJView.super.ctor(self)
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}

    self.niaoFenList_ = {}
    self.niaoFenList_[1] = self.niaoFen1_
    self.niaoFenList_[2] = self.niaoFen2_
    self.niaoFenList_[3] = self.niaoFen3_

    self.qiShouHuList_ = {}
    self.middleHuList_ = {}
    self.juShuList_ = {}

    self.juShuList_[1] = self.juShu1_
    self.juShuList_[2] = self.juShu2_
    self.juShuList_[3] = self.juShu3_

    self.niaoList_ = {}
    self.niaoList_[1] = self.niao1_
    self.niaoList_[2] = self.niao2_
    self.niaoList_[3] = self.niao3_

    self.zhaNiaoList_ = {}
    self.zhaNiaoList_[1] = self.zhaNiao1_
    self.zhaNiaoList_[2] = self.zhaNiao2_

    self.zhongNiaoList_ = {}
    self.zhongNiaoList_[1] = self.zhongNiao1_
    self.zhongNiaoList_[2] = self.zhongNiao2_

    self.renshuList_ = {}
    self.renshuList_[1] = self.renShu1_
    self.renshuList_[2] = self.renShu2_
    self.renshuList_[3] = self.renShu3_

    self.gangList_ = {}
    self.gangList_[1] = self.gang1_
    self.gangList_[2] = self.gang2_
    self.gangList_[3] = self.gang3_

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_

    self.douQiTypeList_ = {}
    self.douQiTypeList_[1] = self.douQi1_
    self.douQiTypeList_[2] = self.douQi2_

    self.bbhTypeList_ = {}
    self.bbhTypeList_[1] = self.banBanHuRoundOver1_
    self.bbhTypeList_[2] = self.banBanHuRoundOver2_

    self:initZhiFuType_()
    self:initJuShu_()
    self:initGang_()
    self:initQiShouHu_()
    self:initMiddleHu_()
    self:initZhaNiao_()
    self:initRenShu_()
    self:initPaiType_()
    self:initDouQiType_()
    self:initBBHRoundOverType_()
    createRoomData:setGameIndex(GAME_MMMJ)
    self:setShowZFType(showZFType)

    self.baoPei_:setSelected(tonumber(mmmjData:getBaoPei()) ~= 0)
    if tonumber(mmmjData:getBaoPei()) ~= 0 then
        self.baoPeiType_ = 1
    else
        self.baoPeiType_ = 0
    end
    self.qiangZhiHu_:setSelected(tonumber(mmmjData:getQiangZhiHu()) ~= 0)
    if tonumber(mmmjData:getQiangZhiHu()) ~= 0 then
        self.qiangZhiHuType_ = 1
    else
        self.qiangZhiHuType_ = 0
    end

    self.csbNode_:setScale(1,0.94)
    self:setScale(0.75)
end

function CreateMMMJView:setData(data)
    self:updateZhiFuList_(data.consumeType+1)
    self.qiShouHuList_ = data.beginHuList
    self:showQiShouHu()
    self.middleHuList_ = data.ruleDetails.middleHuList
    self:showMiddleHu()
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
    if data.birdScoreType == 0 then 
        self:updateZhaNiaoList_(2) -- 加倍
    else
        self:updateZhaNiaoList_(1) -- 加番
    end
    self:updateNiaoFenList_(data.birdCount)
    if data.ruleDetails.fullPai and data.ruleDetails.fullPai > 0 then
        self:updatepaiTypeList_(data.ruleDetails.fullPai)
    end
    if data.ruleDetails.diceCount == 1 then
        self:updateGangList_(1)
    elseif data.ruleDetails.huCount == 1 then
        self:updateGangList_(2)
    elseif data.ruleDetails.huCount == 2 then
        self:updateGangList_(3)
    end
    self.csbNode_:setPositionY(self.csbNodePosY+60)

    self.baoPei_:setSelected(data.ruleDetails.baoPei == 1)
    dump(data, "setData")
    self.qiangZhiHu_:setSelected(data.ruleDetails.qiangZhiHuPai == 1)
    self:updateList_(self.bbhTypeList_, data.ruleDetails.banBanHuRoundOver == 1 and 1 or 2)
    self:updateList_(self.douQiTypeList_, data.ruleDetails.douQiType == 0 and 1 or 2)

    self.niaoCount_ = data.ruleDetails.birdCount
    self.bbhRoundOverType_ = data.ruleDetails.banBanHuRoundOver
    self.qiangZhiHuType_ = data.ruleDetails.qiangZhiHuPai
    self.baoPeiType_ = data.ruleDetails.baoPei
    self.huCount_ = data.ruleDetails.huCount
    self.douQiType_ = data.ruleDetails.douQiType
    self.birdScoreType_ = data.ruleDetails.birdScoreType
    self.gang_ = data.ruleDetails.diceCount
    self.playerCount_ = data.ruleDetails.totalSeat
    self.juShu_ = data.juShu
    self.zhiFuType_ = data.consumeType
    self.paiType_ = data.ruleDetails.fullPai or 0 
end

function CreateMMMJView:douQi1Handler_()
    mmmjData:setDouQi(1)
    self:updateList_(self.douQiTypeList_, 1)
    self.douQiType_ = 0
end

function CreateMMMJView:douQi2Handler_()
    mmmjData:setDouQi(2)
    self:updateList_(self.douQiTypeList_, 2)
    self.douQiType_ = 1
end

function CreateMMMJView:banBanHuRoundOver1Handler_()
    mmmjData:setBBHRoundOver(1)
    self:updateList_(self.bbhTypeList_, 1)
    self.bbhRoundOverType_ = 1
end

function CreateMMMJView:banBanHuRoundOver2Handler_()
    mmmjData:setBBHRoundOver(2)
    self:updateList_(self.bbhTypeList_, 2)
    self.bbhRoundOverType_ = 0
end

function CreateMMMJView:initPaiType_()
    local index = tonumber(mmmjData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateMMMJView:paiType1Handler_()
    mmmjData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateMMMJView:paiType2Handler_()
    mmmjData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateMMMJView:updatepaiTypeList_(index)
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

function CreateMMMJView:initDouQiType_()
    local index = tonumber(mmmjData:getDouQi())
    self:updateList_(self.douQiTypeList_, index)
    if self.douQiTypeList_[index] then
        self.douQiTypeList_[index]:setSelected(true)
    else
        self.douQiTypeList_[1]:setSelected(true)
    end
    if index == 1 then
        self.douQiType_ = 0
    elseif index == 2 then
        self.douQiType_ = 1
    end
end

function CreateMMMJView:initBBHRoundOverType_()
    local index = tonumber(mmmjData:getBBHRoundOver())
    local list =self.bbhTypeList_ 
    self:updateList_(list, index)
    if list[index] then
        list[index]:setSelected(true)
    else
        list[1]:setSelected(true)
    end
    if index == 1 then
        self.bbhRoundOverType_ = 1
    elseif index == 2 then
        self.bbhRoundOverType_ = 0
    else
        self.bbhRoundOverType_ = 0
    end
end

function CreateMMMJView:initZhiFuType_()
    local index = tonumber(mmmjData:getZhiFu())
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

function CreateMMMJView:updateList_(list, index)
    for i, v in ipairs(list) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateMMMJView:updateZhiFuList_(index)
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

function CreateMMMJView:initQiShouHu_()
    local str = mmmjData:getQiShouHu()
    self.qiShouHuList_ = string.split(str, ",")
    self:showQiShouHu()
end

function CreateMMMJView:showQiShouHu()
    for i=1,9 do
        self["qiShou" .. i .. "_"]:setSelected(false)
    end
    for i,v in ipairs(self.qiShouHuList_) do
        if v == "qiShouSiZhang" then
            self.qiShou1_:setSelected(true)
        elseif v == "liuLiuShun" then
            self.qiShou2_:setSelected(true)
        elseif v == "queYiSe" then
            self.qiShou3_:setSelected(true)
        elseif v == "banBanHu" then
            self.qiShou4_:setSelected(true)
        elseif v == "sanTong" then
            self.qiShou5_:setSelected(true)
        elseif v == "jieJieGao" then
            self.qiShou6_:setSelected(true)
        elseif v == "danSeYiZhiHua" then
            self.qiShou7_:setSelected(true)
        elseif v == "jiangYiZhiHua" then
            self.qiShou8_:setSelected(true)
        elseif v == "yiZhiNiao" then
            self.qiShou9_:setSelected(true)
        end
    end
end

function CreateMMMJView:initMiddleHu_()
    local str = mmmjData:getMiddleHu()
    dump(str)
    self.middleHuList_ = string.split(str, ",")
    self:showMiddleHu()
end

function CreateMMMJView:showMiddleHu()
    for i=1,2 do
        self["middle" .. i .. "_"]:setSelected(false)
    end
    for i,v in ipairs(self.middleHuList_) do
        if v == "zhongTuSiZhang" then
            self.middle2_:setSelected(true)
        elseif v == "zhongTuLiuLiuShun" then
            self.middle1_:setSelected(true)
        end
    end
end

function CreateMMMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createMMMJ.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreateMMMJView:initRenShu_()
    local index = tonumber(mmmjData:getRenShu())
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

function CreateMMMJView:initJuShu_()
    local index = tonumber(mmmjData:getJuShu())
    self:updateJuShuList_(index)
    if self.juShuList_[index] then
        self.juShuList_[index]:setSelected(true)
    else
        self.juShuList_[1]:setSelected(true)
    end
    if index == 1 then
        self.juShu_ = 8
    elseif index == 2 then
        self.juShu_ = 16
    end
end

function CreateMMMJView:initZhaNiao_()
    local index = tonumber(mmmjData:getZhaNiao())
    self:updateZhaNiaoList_(index)
    if self.zhaNiaoList_[index] then
        self.zhaNiaoList_[index]:setSelected(true)
    else
        self.zhaNiaoList_[1]:setSelected(true)
    end
    if index == 1 then
        self.birdScoreType_ = 1
    elseif index == 2 then
        self.birdScoreType_ = 0
    else
        self.birdScoreType_ = 1
    end
    local pIndex = tonumber(mmmjData:getNiaoFen())
    self:updateNiaoFenList_(pIndex)
end

function CreateMMMJView:initGang_()
    local index = tonumber(mmmjData:getGang())
    self:updateGangList_(index)
    if self.gangList_[index] then
        self.gangList_[index]:setSelected(true)
    else
        self.gangList_[1]:setSelected(true)
    end
    if index == 1 then
        self.gang_ = 1
        self.huCount_ = 1
    elseif index == 2 then
        self.gang_ = 2
        self.huCount_ = 1
    elseif index == 3 then
        self.gang_ = 2
        self.huCount_ = 2
    else
        self.gang_ = 2
        self.huCount_ = 2
    end
end

function CreateMMMJView:updateNiaoFenList_(index)
    for i,v in ipairs(self.niaoFenList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.niaoCount_ = 1
    elseif index == 2 then
        self.niaoCount_ = 2
    elseif index == 3 then
        self.niaoCount_ = 3
    end
end

function CreateMMMJView:updateRenShuList_(index)
    for i,v in ipairs(self.renshuList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    -- self.paiTypePic_:setVisible(index == 3)
    for i = 1,2 do
        self["paiType" .. i .. "_"]:setVisible(index == 3)
        self["paiTypeTip" .. i .. "_"]:setVisible(index == 3)
    end
    if index ~= 3 then
        self.paiType_ = 0
    else

    end
end

function CreateMMMJView:updateJuShuList_(index)
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

function CreateMMMJView:updateNiaoList_(index)
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

function CreateMMMJView:updateGangList_(index)
    for i,v in ipairs(self.gangList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateMMMJView:updateZhaNiaoList_(index)
    for i,v in ipairs(self.zhaNiaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateMMMJView:renShu1Handler_()
    mmmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateMMMJView:renShu1Handler_()
    mmmjData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateMMMJView:renShu2Handler_()
    mmmjData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateMMMJView:renShu3Handler_()
    mmmjData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end

function CreateMMMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    mmmjData:setZhiFu(1)
end

function CreateMMMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    mmmjData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateMMMJView:piao0Handler_()
    self.piao = 1
    self:updatePF(1)
end

function CreateMMMJView:piao1Handler_()
    self.piao2_:setVisible(true)
    self.piao2Tip_:setVisible(true)
    self.piao3_:setVisible(true)
    self.piao3Tip_:setVisible(true)
    self.piao = 0
    self:updatePF(2)
end

function CreateMMMJView:piao2Handler_()
    self.piao = 1
    self:updatePF(3)
end

function CreateMMMJView:piao3Handler_()
    self.piao = 2
    self:updatePF(4)
end

function CreateMMMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    mmmjData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateMMMJView:juShu1Handler_()
    self:updateJuShuList_(1)
    self.juShu_ = 8
    mmmjData:setJuShu(1)
end

function CreateMMMJView:juShu2Handler_()
    self:updateJuShuList_(2)
    mmmjData:setJuShu(2)
    self.juShu_ = 16
end


function CreateMMMJView:zhaNiao1Handler_()
    self.birdScoreType_ = 1
    mmmjData:setZhaNiao(1)
    self:niaoFen1Handler_()
    self:updateZhaNiaoList_(1)
end

function CreateMMMJView:zhaNiao2Handler_()
    self.birdScoreType_ = 0
    mmmjData:setZhaNiao(2)
    self:niaoFen1Handler_()
    self:updateZhaNiaoList_(2)
end

function CreateMMMJView:niaoFen1Handler_()
    self:updateNiaoFenList_(1)
    self.niaoCount_ = 2
    mmmjData:setNiaoFen(1)
end

function CreateMMMJView:niaoFen2Handler_()
    self:updateNiaoFenList_(2)
    self.niaoCount_ = 4
    mmmjData:setNiaoFen(2)
end

function CreateMMMJView:niaoFen3Handler_()
    self:updateNiaoFenList_(3)
    self.niaoCount_ = 6
    mmmjData:setNiaoFen(3)
end

function CreateMMMJView:niaoFen4Handler_()
    self:updateNiaoFenList_(4)
    self.niaoCount_ = 1
    mmmjData:setNiaoFen(4)
end

function CreateMMMJView:gang1Handler_()
    self:updateGangList_(1)
    self.gang_ = 1
    self.huCount_ = 1
    mmmjData:setGang(1)
end

function CreateMMMJView:gang2Handler_()
    self:updateGangList_(2)
    self.gang_ = 2
    self.huCount_ = 1
    mmmjData:setGang(2)
end

function CreateMMMJView:gang3Handler_()
    self:updateGangList_(3)
    self.gang_ = 2
    self.huCount_ = 2
    mmmjData:setGang(3)
end

function CreateMMMJView:zhuang1Handler_()
    self:updateZhuangList_(1)
    self.zhuangType_ = 1
    mmmjData:setZhuangType(1)
end

function CreateMMMJView:zhuang2Handler_()
    self:updateZhuangList_(2)
    self.zhuangType_ = 0
    mmmjData:setZhuangType(2)
end

function CreateMMMJView:baoPeiHandler_(item)
    if item:isSelected() then
        mmmjData:setBaoPei(1)
        self.baoPeiType_ = 1
    else
        mmmjData:setBaoPei(0)
        self.baoPeiType_ = 0
    end
end

function CreateMMMJView:qiangZhiHuHandler_(item)
    if item:isSelected() then
        mmmjData:setQiangZhiHu(1)
        self.qiangZhiHuType_ = 1
    else
        mmmjData:setQiangZhiHu(0)
        self.qiangZhiHuType_ = 0
    end
end

function CreateMMMJView:qiShou1Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "qiShouSiZhang")
    else
        table.removebyvalue(self.qiShouHuList_,"qiShouSiZhang")
    end
end

function CreateMMMJView:qiShou2Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "liuLiuShun")
    else
        table.removebyvalue(self.qiShouHuList_,"liuLiuShun")
    end
    dump(self.qiShouHuList_,"self.qiShouHuList_")
    
end

function CreateMMMJView:qiShou3Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "queYiSe")
    else
        table.removebyvalue(self.qiShouHuList_,"queYiSe")
    end
end

function CreateMMMJView:qiShou4Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "banBanHu")
    else
        table.removebyvalue(self.qiShouHuList_,"banBanHu")
    end
end

function CreateMMMJView:qiShou5Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "sanTong")
    else
        table.removebyvalue(self.qiShouHuList_,"sanTong")
    end
end

function CreateMMMJView:qiShou6Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "jieJieGao")
    else
        table.removebyvalue(self.qiShouHuList_,"jieJieGao")
    end
end

function CreateMMMJView:qiShou7Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "danSeYiZhiHua")
    else
        table.removebyvalue(self.qiShouHuList_,"danSeYiZhiHua")
    end
end

function CreateMMMJView:qiShou8Handler_(item)
    print("qiShou8Handler_",item:isSelected())
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "jiangYiZhiHua")
    else
        table.removebyvalue(self.qiShouHuList_,"jiangYiZhiHua")
    end
end

function CreateMMMJView:qiShou9Handler_(item)
    print("qiShou9Handler_",item:isSelected())
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "yiZhiNiao")
    else
        table.removebyvalue(self.qiShouHuList_,"yiZhiNiao")
    end
end

function CreateMMMJView:middle1Handler_(item)
    if item:isSelected() then
        table.insert(self.middleHuList_, "zhongTuLiuLiuShun")
    else
        table.removebyvalue(self.middleHuList_,"zhongTuLiuLiuShun")
    end

    mmmjData:setMiddleHu(table.concat(self.middleHuList_, ","))
end

function CreateMMMJView:middle2Handler_(item)
    if item:isSelected() then
        table.insert(self.middleHuList_, "zhongTuSiZhang")
    else
        table.removebyvalue(self.middleHuList_,"zhongTuSiZhang")
    end

    mmmjData:setMiddleHu(table.concat(self.middleHuList_, ","))
end

function CreateMMMJView:calcCreateRoomParams(daiKai)
    local ipLimit = 0
    local guiZe = {
        birdCount = self.niaoCount_,  -- 抓鸟个数
        birdScoreType = self.birdScoreType_, -- 抓鸟翻倍还是加分
        totalSeat = self.playerCount_,
        lockCardsType = 1,
        beginHuList = self.qiShouHuList_,
        middleHuList = self.middleHuList_,
        zhuangType = 0,
        fullPai = self.paiType_,
        baoPei = self.baoPeiType_,
        diceCount = self.gang_,
        huCount = self.huCount_,
        qiangZhiHuPai = self.qiangZhiHuType_,
        douQiType = self.douQiType_,
        banBanHuRoundOver = self.bbhRoundOverType_,
    }

    if self.playerCount_ ~= 2 then
        guiZe.fullPai = 0
    end    
    local params = {
        gameType = GAME_MMMJ, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(guiZe,"CreateMMMJView:calcCreateRoomParams")
    return params
end

return CreateMMMJView 
