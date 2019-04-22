local BaseElement = import("app.views.BaseElement")
local RoundOverMingTangItem = class("RoundOverMingTangItem", BaseElement)
local HUFILE_LIST = {}
HUFILE_LIST[DA_ZI_HU] = {"res/images/paohuzi/roundOver/huType/daZihu.png",8}
HUFILE_LIST[ZHEN_DIAN_HU] = {"res/images/paohuzi/roundOver/huType/zhenDianHu.png",6}
HUFILE_LIST[JIA_DIAN_HU] = {"res/images/paohuzi/roundOver/huType/jiaDianHu.png",1}
HUFILE_LIST[DI_HU] = {"res/images/paohuzi/roundOver/huType/diHu.png",8}
HUFILE_LIST[DUI_DUI_HU] = {"res/images/paohuzi/roundOver/huType/duiDuiHu.png",8}
HUFILE_LIST[HAI_DI_HU] = {"res/images/paohuzi/roundOver/huType/haiDiHu.png",8}
HUFILE_LIST[HAND_HANG_XI_HU] = {"res/images/paohuzi/roundOver/huType/hangHangXi.png",8}
HUFILE_LIST[JIA_HAND_HANG_XI_HU] = {"res/images/paohuzi/roundOver/huType/jiaHangHangXi.png",4}
HUFILE_LIST[SI_QI_HU] = {"res/images/paohuzi/roundOver/huType/siQiHu.png",2}
HUFILE_LIST[HONG_HU] = {"res/images/paohuzi/roundOver/huType/hongHu.png",3}
HUFILE_LIST[HONG_WU_HU] = {"res/images/paohuzi/roundOver/huType/hongWuHu.png",1}
HUFILE_LIST[SHUA_HOU_HU] = {"res/images/paohuzi/roundOver/huType/shuaHou.png",8}
HUFILE_LIST[SAN_TI_WU_KAN] = {"res/images/paohuzi/roundOver/huType/sanTi5Kan.png",1}
HUFILE_LIST[TIAN_HU] = {"res/images/paohuzi/roundOver/huType/tianHu.png",10}
HUFILE_LIST[TUAN_HU] = {"res/images/paohuzi/roundOver/huType/tuanHu.png",8}
HUFILE_LIST[WU_HU] = {"res/images/paohuzi/roundOver/huType/wuHu.png",8}
HUFILE_LIST[XIAO_ZI_HU] = {"res/images/paohuzi/roundOver/huType/xiaoZiHu.png",10}
HUFILE_LIST[ZI_MO_HU] = {"res/images/paohuzi/roundOver/huType/ziMoHu.png",1}
HUFILE_LIST[PING_HU] = {"res/images/paohuzi/roundOver/huType/pingHu.png",1}
HUFILE_LIST[TING_HU] = {"res/images/paohuzi/roundOver/huType/tingHu.png",8}
HUFILE_LIST[YI_KUAI_BIAN] = {"res/images/paohuzi/roundOver/huType/yikuaibian.png",8}
HUFILE_LIST[KA_20] = {"res/images/paohuzi/roundOver/huType/ka20hu.png",8}
HUFILE_LIST[KA_30] = {"res/images/paohuzi/roundOver/huType/ka30hu.png",8}

HUFILE_LIST[50] = {"res/images/paohuzi/roundOver/huType/huangFan.png",0}
HUFILE_LIST[51] = {"res/images/paohuzi/roundOver/huType/ziMoHu.png",0}
HUFILE_LIST[52] = {"res/images/paohuzi/roundOver/huType/chongTun.png",0}

local FILE_CHONG_TUNS = {}
FILE_CHONG_TUNS[1] = "res/images/paohuzi/roundOver/jia1Tun.png"
FILE_CHONG_TUNS[2] = "res/images/paohuzi/roundOver/jia2Tun.png"
FILE_CHONG_TUNS[3] = "res/images/paohuzi/roundOver/jia3Tun.png"

local HONGHEIHUTYPE_LIST = {}
HONGHEIHUTYPE_LIST[HONG_HU] = {"res/images/paohuzi/roundOver/huType/tuanHu.png",2}
HONGHEIHUTYPE_LIST[WU_HU] = {"res/images/paohuzi/roundOver/huType/wuHu.png",5}
HONGHEIHUTYPE_LIST[DUI_DUI_HU] = {"res/images/paohuzi/roundOver/huType/xiaoZiHu.png",5}
HONGHEIHUTYPE_LIST[ZI_MO_HU] = {"res/images/paohuzi/roundOver/huType/ziMoHu.png",1}
HONGHEIHUTYPE_LIST[ZHEN_DIAN_HU] = {"res/images/paohuzi/roundOver/huType/zhenDianHu.png",2}
HONGHEIHUTYPE_LIST[HONG_HU] = {"res/images/paohuzi/roundOver/huType/hongHu.png",3}
HONGHEIHUTYPE_LIST[YI_KUAI_BIAN] = {"res/images/paohuzi/roundOver/huType/yikuaibian.png",8}
HONGHEIHUTYPE_LIST[KA_20] = {"res/images/paohuzi/roundOver/huType/ka20hu.png",8}
HONGHEIHUTYPE_LIST[KA_30] = {"res/images/paohuzi/roundOver/huType/ka30hu.png",8}
HONGHEIHUTYPE_LIST[50] = {"res/images/paohuzi/roundOver/huType/huangFan.png",0}

local fanFnt = {type = gailun.TYPES.BM_FONT_LABEL, options={text="10",UILabelType = 1,font = "res/images/paohuzi/roundOver/pjx.fnt",} , ap = {1, 0.5}}
-- self.xianQian_ = jw.uihelper.createBMFontLabel(xianJin)

local HU_ADDHUXI = {WU_HU,HONG_WU_HU,KA_30,TIAN_HU,DI_HU}

function RoundOverMingTangItem:ctor(data, winType)
    self.data_ = data
    RoundOverMingTangItem.super.ctor(self)
    if winType == 1 then
        local texture = cc.Director:getInstance():getTextureCache():addImage('res/images/paohuzi/roundOver/winKanBg.png')
        self.loseKanBg_:setTexture(texture)
    end
    local texture = cc.Director:getInstance():getTextureCache():addImage(HUFILE_LIST[data][1])
    self.huXi_:setTexture(texture)
    self.flagFan_:ignoreContentAdaptWithSize(true)
    self.fan_ = gailun.uihelper.createBMFontLabel(fanFnt):addTo(self.csbNode_)
    self.fan_:setAnchorPoint(1,0.5)
    self.fan_:pos(60,2)
    for i,v in ipairs(HU_ADDHUXI) do
       if data == HU_ADDHUXI[i] then
           self:addHuXi()
       end
    end
end

function RoundOverMingTangItem:setFan(fan)
    self.fanCount_ = fan
    self.fan_:setString(fan)
end

function RoundOverMingTangItem:getFanCount()
    return self.fanCount_

end

function RoundOverMingTangItem:chongTun(tun)
    self.flagFan_:loadTexture(FILE_CHONG_TUNS[tun])
    self.flagFan_:setPositionX(self.flagFan_:getPositionX() - 8)
    self.fan_:hide()
end

function RoundOverMingTangItem:ziMoHu()
    self.flagFan_:loadTexture('res/images/paohuzi/roundOver/jia10HuXi.png')
    self.flagFan_:setPositionX(self.flagFan_:getPositionX() - 12)
    self.flagFan_:setScale(0.8)
    self.fan_:hide()
end

function RoundOverMingTangItem:addHuXi()
    self.flagFan_:loadTexture('res/images/paohuzi/roundOver/flagHuXi.png')
    self.flagFan_:setPositionX(self.flagFan_:getPositionX() + 10)
    self.flagFan_:setScale(0.8)
    --self.fan_:hide()
end

function RoundOverMingTangItem:changFanWord(count)
    self.flagFan_:loadTexture('res/images/paohuzi/roundOver/flagX.png')
    self.flagFan_:setPositionX(self.flagFan_:getPositionX() - 30)
    self.fan_:setPositionX(self.fan_:getPositionX() + 30)
    self.fan_:setString(count)
end

function RoundOverMingTangItem:getFanCount()
    return self.fanCount_
end

function RoundOverMingTangItem:loaderCsb()
    self.csbNode_ = cc.uiloader:load("views/games/sybp/MingTangItem.csb"):addTo(self)
end

return RoundOverMingTangItem