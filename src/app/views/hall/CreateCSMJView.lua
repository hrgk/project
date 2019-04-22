local BaseCreateView = import(".BaseCreateView")
local CreateCSMJView = class("CreateCSMJView", BaseCreateView)

function CreateCSMJView:ctor(showZFType)
    CreateCSMJView.super.ctor(self)
    self.jushuConf = {8,16}
    self.renShuConf = {3,4,2}

    self.niaoFenList_ = {}
    self.niaoFenList_[1] = self.niaoFen1_
    self.niaoFenList_[2] = self.niaoFen2_
    self.niaoFenList_[3] = self.niaoFen3_
    self.niaoFenList_[4] = self.niaoFen4_

    self.zhuangTypeList_ = {}
    self.zhuangTypeList_[1] = self.zhuang1_
    self.zhuangTypeList_[2] = self.zhuang2_

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

    self.zhiFuList_ = {}
    self.zhiFuList_[1] = self.zhifu1_
    self.zhiFuList_[2] = self.zhifu2_
    self.zhiFuList_[3] = self.zhifu3_

    self.pf_ = {}
    self.pf_[1] = self.piao0_
    self.pf_[2] = self.piao1_
    self.pf_[3] = self.piao2_
    self.pf_[4] = self.piao3_

    self.paiTypeList_ = {}
    self.paiTypeList_[1] = self.paiType1_
    self.paiTypeList_[2] = self.paiType2_

    self:initZhiFuType_()
    self:initJuShu_()
    self:initGang_()
    self:initQiShouHu_()
    self:initMiddleHu_()
    self:initZhaNiao_()
    self:initPF()
    self:initZhuangType_()
    self:initZhongNiao_()
    self:initRenShu_()
    self:initpaiType_()
    createRoomData:setGameIndex(GAME_MJCHANGSHA)
    self:setShowZFType(showZFType)
    self.csbNode_:setScale(1,0.94)
    self:setScale(0.75)
end

function CreateCSMJView:setData(data)
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
    if data.birdScoreType == 2 then --鸟分
        self:updateZhaNiaoList_(1)
    elseif data.birdScoreType == 0 then --鸟倍
        self:updateZhaNiaoList_(2)
    end
    self:updatePF(data.piao_type+2)
    if data.birdCount == 1 then
        self:updateNiaoFenList_(4)
    else
        self:updateNiaoFenList_(data.birdCount/2)
    end
    if data.ruleDetails.fullPai and data.ruleDetails.fullPai > 0 then
        self:updatepaiTypeList_(data.ruleDetails.fullPai)
    end
    self:updateGangList_(data.ruleDetails.afterGangCardsCount/2)
    self.csbNode_:setPositionY(self.csbNodePosY+60)
    local zType = data.ruleDetails.zhuangType
    self:updateZhuangList_(zType == 0 and 2 or 1)
    self.qhhzn_:setSelected(data.ruleDetails.beginHuBird == 1)
    self.niaoCount_ = data.birdCount
    self.birdScoreType_ = data.birdScoreType
    self.gang_ = data.ruleDetails.afterGangCardsCount
    self.playerCount_ = data.ruleDetails.totalSeat
    self.zhuangType_ = data.ruleDetails.zhuangType
    self.piao = data.piao_type
    self.juShu_ = data.juShu
    self.zhiFuType_ = data.consumeType
    self.paiType_ = data.ruleDetails.fullPai or 0 
end

function CreateCSMJView:initpaiType_()
    local index = tonumber(xtcmData:getpaiType())
    self:updatepaiTypeList_(index)
    if self.paiTypeList_[index] then
        self.paiTypeList_[index]:setSelected(true)
        self.paiType_ = index
    else
        self.paiTypeList_[1]:setSelected(true)
        self.paiType_ = 1
    end
end

function CreateCSMJView:paiType1Handler_()
    xtcmData:setpaiType(1)
    self:updatepaiTypeList_(1)
    self.paiType_ = 1
end

function CreateCSMJView:paiType2Handler_()
    xtcmData:setpaiType(2)
    self:updatepaiTypeList_(2)
    self.paiType_ = 2
end

function CreateCSMJView:updatepaiTypeList_(index)
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

function CreateCSMJView:initZhiFuType_()
    local index = tonumber(xtcmData:getZhiFu())
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

function CreateCSMJView:updateZhiFuList_(index)
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

function CreateCSMJView:initQiShouHu_()
    local str = xtcmData:getQiShouHu()
    self.qiShouHuList_ = string.split(str, ",")
    self:showQiShouHu()
    self.qhhzn_:setSelected(tonumber(xtcmData:getQiShouNiao()) == 1)
end

function CreateCSMJView:showQiShouHu()
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

function CreateCSMJView:initMiddleHu_()
    local str = xtcmData:getMiddleHu()
    dump(str)
    self.middleHuList_ = string.split(str, ",")
    self:showMiddleHu()
end

function CreateCSMJView:showMiddleHu()
    for i=1,2 do
        self["middle" .. i .. "_"]:setSelected(false)
    end
    for i,v in ipairs(self.middleHuList_) do
        if v == "zhongTuSiZhang" then
            self.middle1_:setSelected(true)
        elseif v == "zhongTuLiuLiuShun" then
            self.middle2_:setSelected(true)
        end
    end
end

function CreateCSMJView:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/createRoom/createCSMJ.csb"):addTo(self)
    self.csbNodePosY = self.csbNode_:getPositionY()
end

function CreateCSMJView:initZhuangType_()
    local index = tonumber(xtcmData:getZhuangType())
    self:updateZhuangList_(index)
    if self.zhuangTypeList_[index] then
        self.zhuangTypeList_[index]:setSelected(true)
    else
        self.zhuangTypeList_[1]:setSelected(true)
    end
    if index == 1 then
        self.zhuangType_ = index
    else
        self.zhuangType_ = 0
    end
end

function CreateCSMJView:initRenShu_()
    local index = tonumber(xtcmData:getRenShu())
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

function CreateCSMJView:initJuShu_()
    local index = tonumber(xtcmData:getJuShu())
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

function CreateCSMJView:initZhaNiao_()
    local index = tonumber(xtcmData:getZhaNiao())
    self:updateZhaNiaoList_(index)
    if self.zhaNiaoList_[index] then
        self.zhaNiaoList_[index]:setSelected(true)
    else
        self.zhaNiaoList_[1]:setSelected(true)
    end
    if index == 1 then
        self.birdScoreType_ = 2  
    elseif index == 2 then
        self.birdScoreType_ = 0
    else
        self.birdScoreType_ = 2
    end
    local pIndex = tonumber(xtcmData:getNiaoFen())
    self:updateNiaoFenList_(pIndex)
end

function CreateCSMJView:initGang_()
    local index = tonumber(xtcmData:getGang())
    self:updateGangList_(index)
    if self.gangList_[index] then
        self.gangList_[index]:setSelected(true)
    else
        self.gangList_[1]:setSelected(true)
    end
    if index == 1 then
        self.gang_ = 2
    elseif index == 2 then
        self.gang_ = 4
    else
        self.gang_ = 2
    end
end

function CreateCSMJView:initZhongNiao_()
    local index = tonumber(xtcmData:getZhongNiao())
    self:updateZhongNiaoList_(index+1)
    self.zhongNiaoType_ = index
    if self.zhongNiaoList_[index+1] then
        self.zhongNiaoList_[index+1]:setSelected(true)
    else
        self.zhongNiaoList_[1]:setSelected(true)
        self.zhongNiaoType_ = 0
    end
end

function CreateCSMJView:updateZhongNiaoList_(index)
    for i,v in ipairs(self.zhongNiaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
end

function CreateCSMJView:zhongNiao1Handler_()
    xtcmData:setZhongNiao(0)
    self:updateZhongNiaoList_(1)
    self.zhongNiaoType_ = 0
end

function CreateCSMJView:zhongNiao2Handler_()
    xtcmData:setZhongNiao(1)
    self:updateZhongNiaoList_(2)
    self.zhongNiaoType_ = 1
end

function CreateCSMJView:updateZhuangList_(index)
    for i,v in ipairs(self.zhuangTypeList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    if index == 1 then
        self.zhuangType_ = 0
    else
        self.zhuangType_ = 1
    end
end

function CreateCSMJView:updateNiaoFenList_(index)
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
        self.niaoCount_ = 2
    elseif index == 2 then
        self.niaoCount_ = 4
    elseif index == 3 then
        self.niaoCount_ = 6
    elseif index == 4 then
        self.niaoCount_ = 1
    end
end

function CreateCSMJView:updateRenShuList_(index)
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
    if index ~= 3 then
        self.paiType_ = 0
    else

    end
end

function CreateCSMJView:updateJuShuList_(index)
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

function CreateCSMJView:updateNiaoList_(index)
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

function CreateCSMJView:updateGangList_(index)
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

function CreateCSMJView:updateZhaNiaoList_(index)
    for i,v in ipairs(self.zhaNiaoList_) do
        if index ~= i then
            v:setSelected(false)
            v:setEnabled(true)
        else
            v:setSelected(true)
            v:setEnabled(false)
        end
    end
    self.niaoFen4_:setVisible(index == 1)
    self.niaoFenLable4_:setVisible(index == 1)
end

function CreateCSMJView:renShu1Handler_()
    xtcmData:setRenShu(1)
    self:updateRenShuList_(1)
    self.playerCount_ = 3
end

function CreateCSMJView:renShu2Handler_()
    xtcmData:setRenShu(2)
    self:updateRenShuList_(2)
    self.playerCount_ = 4
end

function CreateCSMJView:renShu3Handler_()
    xtcmData:setRenShu(3)
    self:updateRenShuList_(3)
    self.playerCount_ = 2
end

function CreateCSMJView:zhifu1Handler_()
    self:updateZhiFuList_(1)
    self.zhiFuType_ = 0
    xtcmData:setZhiFu(1)
end

function CreateCSMJView:zhifu2Handler_()
    self:updateZhiFuList_(2)
    xtcmData:setZhiFu(2)
    self.zhiFuType_ = 1
end

function CreateCSMJView:initPF()
    local index = tonumber(xtcmData:getPF())
    if index == 3 or index == 4 then
        self:updatePF(1)
        self:updatePF(index)
        self.piao = index - 2
    elseif index == 1 or index == 2 then
        self:updatePF(3)
        self:updatePF(index)
        if index == 1 then
            self.piao = 1
        else
            self.piao = 0
        end
    end
end

function CreateCSMJView:updatePF(index)
    xtcmData:setPF(index)
    self.piao2_:setVisible(index ~= 2)
    self.piao2Tip_:setVisible(index ~= 2)
    self.piao3_:setVisible(index ~= 2)
    self.piao3Tip_:setVisible(index ~= 2)
    if index == 1 or index == 2 then
        for i =1,2 do
            if index ~= i then
                self.pf_[i]:setSelected(false)
            else
                self.pf_[i]:setSelected(true)
            end
        end
    end
    if index == 1 then
        index = 3
    end
    if index == 3 or index == 4 then
        for i =3,4 do
            if index ~= i then
                self.pf_[i]:setSelected(false)
            else
                self.pf_[i]:setSelected(true)
            end
        end
    end
end


function CreateCSMJView:piao0Handler_()
    self.piao = 1
    self:updatePF(1)
end

function CreateCSMJView:piao1Handler_()
    self.piao2_:setVisible(true)
    self.piao2Tip_:setVisible(true)
    self.piao3_:setVisible(true)
    self.piao3Tip_:setVisible(true)
    self.piao = 0
    self:updatePF(2)
end

function CreateCSMJView:piao2Handler_()
    self.piao = 1
    self:updatePF(3)
end

function CreateCSMJView:piao3Handler_()
    self.piao = 2
    self:updatePF(4)
end

function CreateCSMJView:zhifu3Handler_()
    self:updateZhiFuList_(3)
    xtcmData:setZhiFu(3)
    self.zhiFuType_ = 2
end

function CreateCSMJView:juShu1Handler_()
    self:updateJuShuList_(1)
    self.juShu_ = 8
    xtcmData:setJuShu(1)
end

function CreateCSMJView:juShu2Handler_()
    self:updateJuShuList_(2)
    xtcmData:setJuShu(2)
    self.juShu_ = 16
end


function CreateCSMJView:zhaNiao1Handler_()
    self.birdScoreType_ = 2
    xtcmData:setZhaNiao(1)
    self:niaoFen1Handler_()
    self:updateZhaNiaoList_(1)
end

function CreateCSMJView:zhaNiao2Handler_()
    self.birdScoreType_ = 0
    xtcmData:setZhaNiao(2)
    self:niaoFen1Handler_()
    self:updateZhaNiaoList_(2)
end

function CreateCSMJView:niaoFen1Handler_()
    self:updateNiaoFenList_(1)
    self.niaoCount_ = 2
    xtcmData:setNiaoFen(1)
end

function CreateCSMJView:niaoFen2Handler_()
    self:updateNiaoFenList_(2)
    self.niaoCount_ = 4
    xtcmData:setNiaoFen(2)
end

function CreateCSMJView:niaoFen3Handler_()
    self:updateNiaoFenList_(3)
    self.niaoCount_ = 6
    xtcmData:setNiaoFen(3)
end

function CreateCSMJView:niaoFen4Handler_()
    self:updateNiaoFenList_(4)
    self.niaoCount_ = 1
    xtcmData:setNiaoFen(4)
end

function CreateCSMJView:gang1Handler_()
    self:updateGangList_(1)
    self.gang_ = 2
    xtcmData:setGang(1)
end

function CreateCSMJView:gang2Handler_()
    self:updateGangList_(2)
    self.gang_ = 4
    xtcmData:setGang(2)
end

function CreateCSMJView:zhuang1Handler_()
    self:updateZhuangList_(1)
    self.zhuangType_ = 1
    xtcmData:setZhuangType(1)
end

function CreateCSMJView:zhuang2Handler_()
    self:updateZhuangList_(2)
    self.zhuangType_ = 0
    xtcmData:setZhuangType(2)
end

function CreateCSMJView:qiShou1Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "qiShouSiZhang")
    else
        table.removebyvalue(self.qiShouHuList_,"qiShouSiZhang")
    end
end

function CreateCSMJView:qiShou2Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "liuLiuShun")
    else
        table.removebyvalue(self.qiShouHuList_,"liuLiuShun")
    end
    dump(self.qiShouHuList_,"self.qiShouHuList_")
    
end

function CreateCSMJView:qiShou3Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "queYiSe")
    else
        table.removebyvalue(self.qiShouHuList_,"queYiSe")
    end
end

function CreateCSMJView:qiShou4Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "banBanHu")
    else
        table.removebyvalue(self.qiShouHuList_,"banBanHu")
    end
end

function CreateCSMJView:qiShou5Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "sanTong")
    else
        table.removebyvalue(self.qiShouHuList_,"sanTong")
    end
end

function CreateCSMJView:qhhznHandler_(item)
    if item:isSelected() then
        xtcmData:setQiShouNiao(1)
    else
        xtcmData:setQiShouNiao(0)
    end
end

function CreateCSMJView:qiShou6Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "jieJieGao")
    else
        table.removebyvalue(self.qiShouHuList_,"jieJieGao")
    end
end

function CreateCSMJView:qiShou7Handler_(item)
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "danSeYiZhiHua")
    else
        table.removebyvalue(self.qiShouHuList_,"danSeYiZhiHua")
    end
end

function CreateCSMJView:qiShou8Handler_(item)
    print("qiShou8Handler_",item:isSelected())
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "jiangYiZhiHua")
    else
        table.removebyvalue(self.qiShouHuList_,"jiangYiZhiHua")
    end
end

function CreateCSMJView:qiShou9Handler_(item)
    print("qiShou9Handler_",item:isSelected())
    if item:isSelected() then
        table.insert(self.qiShouHuList_, "yiZhiNiao")
    else
        table.removebyvalue(self.qiShouHuList_,"yiZhiNiao")
    end
end

function CreateCSMJView:middle2Handler_(item)
    if item:isSelected() then
        table.insert(self.middleHuList_, "zhongTuLiuLiuShun")
    else
        table.removebyvalue(self.middleHuList_,"zhongTuLiuLiuShun")
    end

    xtcmData:setMiddleHu(table.concat(self.middleHuList_, ","))
end

function CreateCSMJView:middle1Handler_(item)
    if item:isSelected() then
        table.insert(self.middleHuList_, "zhongTuSiZhang")
    else
        table.removebyvalue(self.middleHuList_,"zhongTuSiZhang")
    end

    xtcmData:setMiddleHu(table.concat(self.middleHuList_, ","))
end

function CreateCSMJView:calcCreateRoomParams(daiKai)
    local ipLimit = 0
    local guiZe = {}
    guiZe.birdCount = self.niaoCount_  -- 抓鸟个数
    guiZe.birdScoreType = self.birdScoreType_ -- 抓鸟翻倍还是加分
    guiZe.afterGangCardsCount = self.gang_ -- 杠后2个还是4个
    guiZe.birdType = self.zhongNiaoType_
    guiZe.totalSeat = self.playerCount_
    guiZe.lockCardsType = 1
    guiZe.beginHuList = self.qiShouHuList_
    guiZe.middleHuList = self.middleHuList_
    guiZe.zhuangType = self.zhuangType_
    guiZe.piao_type = self.piao
    guiZe.fullPai = self.paiType_
    guiZe.beginHuBird= tonumber(xtcmData:getQiShouNiao())
    if self.playerCount_ ~= 2 then
        guiZe.fullPai = 0
    end    
    local params = {
        gameType = GAME_MJCHANGSHA, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        consumeType = self.zhiFuType_,
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    dump(guiZe,"CreateCSMJView:calcCreateRoomParams")
    return params
end

return CreateCSMJView 
