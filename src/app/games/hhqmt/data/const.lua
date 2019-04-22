-- 翻数
HONG_HU = 1  -- # 红胡 红字=4只 红字=7只 红字>10只且<13只，均为红胡
ZHEN_DIAN_HU = 2  -- # 真点胡，红字仅有一只
JIA_DIAN_HU = 3  -- # 假点胡, 红字=10只
HONG_WU_HU = 4  -- # 红乌 红字大于等于13只
WU_HU = 5  -- # 全黑字胡
DUI_DUI_HU = 6  -- # 对对胡，7方门子中全部是碰、提、跑、臭偎、对子组成
DA_ZI_HU = 7  -- # 大字>=18只
XIAO_ZI_HU = 8  -- # 小字>=16只
HAI_DI_HU = 9  -- # 所胡牌是最后一只牌
ZI_MO_HU = 10  -- # 所胡牌是自己摸上来的
TIAN_HU = 11  -- # 3提或5坎 亮张胡牌
DI_HU = 12  -- # 地胡
SHUA_HOU_HU = 13  -- # 耍猴胡
TUAN_HU = 14  -- # 团胡(某数字的8张均在手里)
HAND_HANG_XI_HU = 15  -- # 行行息胡
TING_HU = 16  -- # 听胡
JIA_HAND_HANG_XI_HU = 17  -- # 假行行息胡
SI_QI_HU = 18  -- # 四七胡
HUANG_ZHUANG = 19  -- #黄庄
PING_HU = 100  -- # 平胡


CONSUMER_HANDCARDS = "CONSUMER_HANDCARDS"
-- 渠道配置信息，由后台来总控制这些变量来控制各种开关和环境信息

TABLE_HHQMT_DIRECTION = {  -- 客户端方向定义，逆时针方向
    BOTTOM = 1,
    RIGHT = 2,
    LEFT = 3,
}

SMALL_POKER_MARGIN = 22
SMALL_CARD_WIDTH = 30 * 1
SMALL_CARD_HEIGHT = 20

-- 玩家动作
ACTIONS = {
    GUO = 'guo',    -- 过
    CHI = 'chi',    -- 吃
    PENG = 'peng',   -- 碰
    CHI_GANG = 'chiGang',   -- 吃杠
    BU_GANG = 'buGang', -- 补杠
    AN_GANG = 'anGang', -- 暗杠
    CHI_HU =  'chiHu',    -- 吃胡
    ZI_MO = 'ziMo',    -- 自摸
    QIANG_GANG_HU = "qiangGangHu",  -- 抢杠胡
    ZHUA_NIAO = 'zhuaNiao',  -- 抓鸟
}

HUANIFILE = 
{
    [1] = "honghu",
    [2] = "dianhu",
    [3] = "dianhu",
    [4] = "hongwu",
    [5] = "wuhu",
    [6] = "duiduihu",
    [7] = "dazihu",
    [8] = "xiaozihu",
    [9] = "haidihu",
    [10] = "zimo",
    [11] = "tianhu",
    [12] = "dihu",
    [13] = "shuahou",
    [14] = "tuanyuan",
    [15] = "hanghangxi",
    [16] = "tinghu",
    [17] = "jiahanghangxi",
    [18] = "siqihu",
    [100] = "pinghu",
}

ANIM_LIST = {
    chi = "res/images/paohuzi/ani/chi.png",
    peng = "res/images/paohuzi/ani/peng.png",
    wei = "res/images/paohuzi/ani/wei.png",
    pao = "res/images/paohuzi/ani/pao.png",
    ti = "res/images/paohuzi/ani/ti.png",
    dazihu = "res/images/paohuzi/ani/dazihu.png",
    dianhu = "res/images/paohuzi/ani/dianhu.png",
    dihu = "res/images/paohuzi/ani/dihu.png",
    duiduihu = "res/images/paohuzi/ani/duiduihu.png",
    haidihu = "res/images/paohuzi/ani/haidihu.png",
    hanghangxi = "res/images/paohuzi/ani/hanghangxi.png",
    honghu = "res/images/paohuzi/ani/honghu.png",
    chaohong = "res/images/paohuzi/ani/chaohong.png",
    hongwu = "res/images/paohuzi/ani/hongwu.png",
    huangzhuang = "res/images/paohuzi/ani/huangzhuang.png",
    shuahou = "res/images/paohuzi/ani/shuahou.png",
    threetifivekan = "res/images/paohuzi/ani/threetifivekan.png",
    tianhu = "res/images/paohuzi/ani/tianhu.png",
    tuanyuan = "res/images/paohuzi/ani/tuanyuan.png",
    wanhu = "res/images/paohuzi/ani/wanhu.png",
    wuhu = "res/images/paohuzi/ani/wuhu.png",
    xiaozihu = "res/images/paohuzi/ani/xiaozihu.png",
    zimo = "res/images/paohuzi/ani/zimo.png",
    tinghu = "res/images/paohuzi/ani/tinghuzi.png",
    pinghu = "res/images/paohuzi/ani/hu.png",
}

HUTYPE_LIST = {
    chi = "res/images/paohuzi/hutype/chi.png",
    peng = "res/images/paohuzi/hutype/peng.png",
    wei = "res/images/paohuzi/hutype/wei.png",
    pao = "res/images/paohuzi/hutype/pao.png",
    ti = "res/images/paohuzi/hutype/ti.png",
    dazihu = "res/images/paohuzi/hutype/dazihu.png",
    dianhu = "res/images/paohuzi/hutype/dianhu.png",
    dihu = "res/images/paohuzi/hutype/dihu.png",
    duiduihu = "res/images/paohuzi/hutype/duiduihu.png",
    haidihu = "res/images/paohuzi/hutype/haidihu.png",
    hanghangxi = "res/images/paohuzi/hutype/hanghangxi.png",
    honghu = "res/images/paohuzi/hutype/honghu.png",
    chaohong = "res/images/paohuzi/hutype/chaohong.png",
    hongwu = "res/images/paohuzi/hutype/hongwu.png",
    huangzhuang = "res/images/paohuzi/hutype/huangzhuang.png",
    shuahou = "res/images/paohuzi/hutype/shuahou.png",
    threetifivekan = "res/images/paohuzi/hutype/threetifivekan.png",
    tianhu = "res/images/paohuzi/hutype/tianhu.png",
    tuanyuan = "res/images/paohuzi/hutype/tuanyuan.png",
    wanhu = "res/images/paohuzi/hutype/wanhu.png",
    wuhu = "res/images/paohuzi/hutype/wuhu.png",
    xiaozihu = "res/images/paohuzi/hutype/xiaozihu.png",
    zimo = "res/images/paohuzi/hutype/zimo.png",
    pinghu = "res/images/paohuzi/hutype/pinghu.png",
    tinghu = "res/images/paohuzi/hutype/tinghuzi.png",
    siqihu = "res/images/paohuzi/hutype/siqihu.png",
}



import(".pao_hu_zi")
