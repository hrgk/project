local BanBanHuViewItemView = class("BanBanHuViewItemView", gailun.BaseView)
local TYPES = gailun.TYPES

local colors = {
    cc.c3b(84, 32, 1),
    cc.c3b(133, 29, 5),
    cc.c3b(41, 67, 88),
    cc.c3b(185, 251, 255),
}
local cardScale = 0.6

local la_px1 = 0.2
local la_px2 = 0.72

local la_py = 0.56
local la_py_ = 0.08

local la_pys = {
    la_py - 0 * la_py_,
    la_py - 1 * la_py_,
    la_py - 2 * la_py_,
    la_py - 3 * la_py_,
    la_py - 4 * la_py_,
}
local adjust_x =  40 * display.width / DESIGN_WIDTH
local head_x = (display.width - 1106) / 4 + adjust_x / 2 - 50
local cardScale = 0.6

local nodes = {
    type = TYPES.ROOT, children = {
            {type = TYPES.CUSTOM, var = "avatar_", class = "app.views.AvatarView", x = head_x, y = 0},
        
            {type = TYPES.LABEL, var = "labelNickName_", options = {text = "", size = 22, font = DEFAULT_FONT, lign = cc.TEXT_ALIGNMENT_CENTER, color = cc.c3b(84, 32, 1)}, x = head_x, y = 68, ap = {0.5, 0.5}},
            {type = TYPES.SPRITE, var = "spriteZhuang_", filename = "res/images/majiang/game/banker_flag.png", x = head_x - 35, y = 35,},
            {type = gailun.TYPES.LABEL_ATLAS, var = "labelWinScore_", filename = "fonts/js_ying.png", options = {w = 19, h = 26, startChar = "0"}, x = 800, ppy = 0.7, ap = {0, 1}},
            {type = gailun.TYPES.LABEL_ATLAS, var = "labelLoseScore_", filename = "fonts/js_shu.png", options = {w = 18, h = 26, startChar = "-"}, x = 800, ppy = 0.7, ap = {0, 1}},
            
            {type = TYPES.LABEL, var = "labelHuName_", options = {text = "", size = 24, font = DEFAULT_FONT, color = cc.c3b(84, 32, 1)},
                    x = 85, y = 60, ap = {0, 0.5}},
           },
}

function BanBanHuViewItemView:ctor(params)
    BanBanHuViewItemView.super.ctor(self)
    gailun.uihelper.render(self, nodes)
    self:updateInfo_(params)
end

local banbanshowList = {
    ziMo = "自摸%+s",
    jiePao = "接炮%+s",
    qiangGangHu = "抢杠胡%+s",
    fangPao = "放炮%+s",
    anGang = "暗杠%+s",
    mingGang = "明杠%+s",
    jieGang = "接杠%+s",
    fangGang = "放杠%+s",
    haveGang = "杠底%+s",
    zhuangXian = "庄闲%+s",
    zhongNiao = "抓鸟%+s",
    piaoScore = "飘%+s",
    qingYiSe = "清一色%+s",
    sevenPairs = "七小对%+s",
    _13Yao = "十三幺%+s",
    pengPengHu = "碰碰胡%+s",
    jiangJiangHu = "将将胡%+s",
    gangShangPao = "杠上炮%+s",
    gangShangHua = "杠上花%+s",
    danSeYiZhiHua = "单色一枝花%+s",
    jiangYiZhiHua = "将一枝花%+s",
    yiZhiNiao = "一只鸟%+s",
    sanTong = "三同%+s",
    jieJieGao = "节节高%+s",
    qiShouSiZhang = "起手四喜%+s",
    zhongTuSiZhang = "中途四喜%+s",
    zhongTuLiuLiuShun = "中途六六顺%+s",
    quanQiuRen = "全求人%+s",
    tianHu = "天胡%+s",
    diHu = "地胡%+s",
    haiDi = "海底%+s",
    liuLiuShun = "六六顺%+s",
    queYiSe = "缺一色%+s",
    banBanHu = "板板胡%+s",
    longQiDui = "龙七对%+s",
    piao = "飘分%+s",

}
function BanBanHuViewItemView:updateInfo_(params)
    dump(params.ming_tang,"BanBanHuViewItemView:updateInfo_")
    self.labelNickName_:setString(params.nickName)
    self.avatar_:showWithUrl(params.avatar)
    self.spriteZhuang_:hide()
    if params.isDealer == true then
        self.spriteZhuang_:show()
    end
    if checknumber(params.score) >= 0 then
        self.labelWinScore_:setVisible(true)
        self.labelLoseScore_:setVisible(false)
        self.labelWinScore_:setString(checknumber(params.score))
    else
        self.labelWinScore_:setVisible(false)
        self.labelLoseScore_:setVisible(true)
        self.labelLoseScore_:setString(checknumber(params.score))
    end
    local list = {}
    for k,v in pairs(params.ming_tang) do
        local key = v[1]
        local score = v[2]
        print(key)
        print(score)
        print(banbanshowList[key])
        if banbanshowList[key] ~= nil then
            table.insert(list, string.format(banbanshowList[key], score))
        end
    end

    self.labelHuName_:setString(table.concat(list, "  "))
    -- end
    local huCards = params.huCards or {}
    self.startX_ = 50
    self.startX_ = self.startX_ + 65
    for i=1, #huCards do
        app:createConcreteView("MaJiangView", huCards[i], MJ_TABLE_DIRECTION.BOTTOM, false):pos(self.startX_, 0):addTo(self):scale(0.6)
        self.startX_ = self.startX_ + 50
    end
    self.startX_ = self.startX_ + 20
    for i=#huCards+1, 13 do
        app:createConcreteView("MaJiangView", 0, MJ_TABLE_DIRECTION.BOTTOM, true):pos(self.startX_, 0):addTo(self):scale(0.9)
        self.startX_ = self.startX_ + 52
    end


end

return BanBanHuViewItemView
