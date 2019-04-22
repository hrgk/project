
COLOR_RED = 1  -- 红字牌
COLOR_BLACK = 2  -- 黑字牌

SUIT_SMALL = 1  -- 小字牌
SUIT_BIG = 2  -- 大字牌

-- 各种牌型的对应数字
CTYPE_NONE = -1  --  啥也不是的组合
CTYPE_PAIR = 0  --  对子
CTYPE_SHUN = 1  -- 一句话顺子
CTYPE_2710 = 2  --  2,7,10搭
CTYPE_DA_XIAO_DA = 3  --  大小搭
CTYPE_PENG = 4  -- 碰牌
CTYPE_CHOU_WEI = 5  -- 臭偎 臭歪
CTYPE_WEI = 6  -- 偎牌 歪
CTYPE_PAO = 7  -- 跑牌 坎
CTYPE_TI = 8  -- 提牌 溜
CTYPE_KAN_LIU = 9 -- 坎溜

-- 胡牌类型
PING_HU = 0  -- 平胡
HONG_HU = 1  -- 红胡 红字=4只 红字=7只 红字>10只且<13只，均为红胡
ZHEN_DIAN_HU = 2  -- 真点胡，红字仅有一只
JIA_DIAN_HU = 3  -- 假点胡, 红字=10只
HONG_WU_HU = 4  -- 红乌 红字大于等于13只
WU_HU = 5  -- 全黑字胡
DUI_DUI_HU = 6  -- 对对胡，7方门子中全部是碰、提、跑、臭偎、对子组成
DA_ZI_HU = 7  -- 大字>=18只
XIAO_ZI_HU = 8  -- 小字>=16只
HAI_DI_HU = 9  -- 所胡牌是最后一只牌
ZI_MO_HU = 10  -- 所胡牌是自己摸上来的
TIAN_HU = 11  -- 3提或5坎 亮张胡牌
DI_HU = 12
SHUA_HOU =13 
TUANYUAN = 14
HANGHANGXI = 15
TINGHU = 16
YI_KUAI_BIAN = 20 --#一块扁
KA_20 = 21  --#卡20胡息
KA_30 = 22  --#卡30胡息

HU_METHOD_STRING = {
    [PING_HU] = '平胡',
    [HONG_HU] = '红胡',
    [ZHEN_DIAN_HU] = '点胡',
    [JIA_DIAN_HU] = '假点胡',
    [HONG_WU_HU] = '红乌',
    [WU_HU] = '乌胡',
    [DUI_DUI_HU] = '对对胡',
    [DA_ZI_HU] = '大字胡',
    [XIAO_ZI_HU] = '小字胡',
    [HAI_DI_HU] = '海底',
    [ZI_MO_HU] = '自摸',
    [TIAN_HU] = '天胡',
    [DI_HU] = '地胡',
    [SHUA_HOU] = '耍猴',
    [TUANYUAN] = '团圆',
    [HANGHANGXI] = '行行息',
    [TINGHU] = '听胡',
    [YI_KUAI_BIAN] = "一块扁",
    [KA_20] = "卡20胡息",
    [KA_30] = "卡30胡息",
}

-- 胡息点数规则
HX_TI_DA = 12  -- 大提
HX_TI_XIAO = 9  -- 小提
HX_PAO_DA = 9  -- 大跑
HX_PAO_XIAO = 6  -- 小跑
HX_WEI_DA = 6  -- 大偎 
HX_WEI_XIAO = 3  -- 小偎
HX_PENG_DA = 3  -- 大碰
HX_PENG_XIAO = 1  -- 小碰
HX_2710_DA = 6  -- 2710大
HX_2710_XIAO = 3  -- 2710小
HX_123_DA = 6  -- 123大
HX_123_XIAO = 3  -- 123小

HU_XI_MIN = 15  -- 要达到15胡息方可胡牌
PIAO_HU = 0 --是否可以飘胡

