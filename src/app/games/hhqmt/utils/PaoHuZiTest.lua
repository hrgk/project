local BaseAlgorithm = import(".BaseAlgorithm")
local PaoHuZiAlgorithm = import(".PaoHuZiAlgorithm")

assert(BaseAlgorithm.isCard() == false)
assert(BaseAlgorithm.isCard(109) == true)


local __tt = {104, 106, 204, 105}
table.sort(__tt, BaseAlgorithm.sortCardFuncSmallToBig)
assert(__tt[1] == 204)
assert(__tt[2] == 104)
assert(__tt[3] == 105)
assert(__tt[4] == 106)


assert(#(BaseAlgorithm.getAllCards()) == 20)


assert('红胡' == BaseAlgorithm.getHuString(HONG_HU))


assert(BaseAlgorithm.getCtypeOfThree() == 0)
assert(BaseAlgorithm.getCtypeOfThree("fda") == 0)
assert(BaseAlgorithm.getCtypeOfThree({304, 204, 204}) == 0)
assert(BaseAlgorithm.getCtypeOfThree({104, 211, 204}) == 0)
assert(BaseAlgorithm.getCtypeOfThree({104, 211, 504}) == 0)
assert(BaseAlgorithm.getCtypeOfThree({204, 204, 204, 304}) == 0)
assert(BaseAlgorithm.getCtypeOfThree({204, 204, 204}) == CTYPE_WEI)
assert(BaseAlgorithm.getCtypeOfThree({103, 101, 102}) == CTYPE_SHUN)
assert(BaseAlgorithm.getCtypeOfThree({204, 202, 203}) == CTYPE_SHUN)
assert(BaseAlgorithm.getCtypeOfThree({207, 202, 210}) == CTYPE_2710)
assert(BaseAlgorithm.getCtypeOfThree({207, 202, 110}) ~= CTYPE_2710)
assert(BaseAlgorithm.getCtypeOfThree({202, 202, 102}) == CTYPE_DA_XIAO_DA)
assert(BaseAlgorithm.getCtypeOfThree({102, 202, 102}) == CTYPE_DA_XIAO_DA)
assert(BaseAlgorithm.getCtypeOfThree({204, 102, 203}) ~= CTYPE_SHUN)


assert(BaseAlgorithm.isFour() == false)
assert(BaseAlgorithm.isFour('fdss') == false)
assert(BaseAlgorithm.isFour({3,3,3,3}) == false)
assert(BaseAlgorithm.isFour({103, 103, 103, 103, 103}) == false)
assert(BaseAlgorithm.isFour({103, 103, 103, 103}) == true)


assert(PaoHuZiAlgorithm.calcHuXiTi({}) == 0)
assert(PaoHuZiAlgorithm.calcHuXiTi({102, 102, 102, 101}) == 0)
assert(PaoHuZiAlgorithm.calcHuXiTi({102, 102, 102, 102}) == HX_TI_XIAO)
assert(PaoHuZiAlgorithm.calcHuXiTi({201,201,201,201}) == HX_TI_DA)


assert(PaoHuZiAlgorithm.calcHuXiPao({}) == 0)
assert(PaoHuZiAlgorithm.calcHuXiPao({102, 102, 102, 101}) == 0)
assert(PaoHuZiAlgorithm.calcHuXiPao({102, 102, 102, 102}) == HX_PAO_XIAO)
assert(PaoHuZiAlgorithm.calcHuXiPao({201,201,201,201}) == HX_PAO_DA)


assert(BaseAlgorithm.isThree() == false)
assert(BaseAlgorithm.isThree('fdss') == false)
assert(BaseAlgorithm.isThree({3,3,3}) == false)
assert(BaseAlgorithm.isThree({103, 103, 103, 103}) == false)
assert(BaseAlgorithm.isThree({103, 103, 103}) == true)


assert(PaoHuZiAlgorithm.calcHuXiWei() == 0)
assert(PaoHuZiAlgorithm.calcHuXiWei({102, 102, 102}) == HX_WEI_XIAO)
assert(PaoHuZiAlgorithm.calcHuXiWei({201,201,201}) == HX_WEI_DA)


assert(PaoHuZiAlgorithm.calcHuXiPeng() == 0)
assert(PaoHuZiAlgorithm.calcHuXiPeng({102, 102, 102}) == HX_PENG_XIAO)
assert(PaoHuZiAlgorithm.calcHuXiPeng({201,201,201}) == HX_PENG_DA)


assert(PaoHuZiAlgorithm.calcHuXiShun() == 0)
assert(PaoHuZiAlgorithm.calcHuXiShun({103, 101, 102}) == HX_123_XIAO)
assert(PaoHuZiAlgorithm.calcHuXiShun({103, 104, 102}) == 0)
assert(PaoHuZiAlgorithm.calcHuXiShun({203, 201, 202}) == HX_123_DA)


assert(PaoHuZiAlgorithm.calcHuXi2710() == 0)
assert(PaoHuZiAlgorithm.calcHuXi2710({110, 102, 107}) == HX_2710_XIAO)
assert(PaoHuZiAlgorithm.calcHuXi2710({110, 202, 107}) == 0)
assert(PaoHuZiAlgorithm.calcHuXi2710({210, 202, 207}) == HX_2710_DA)


assert(0 == PaoHuZiAlgorithm.calcTableHuXi())
assert(0 == PaoHuZiAlgorithm.calcTableHuXi({}))
assert(21 == PaoHuZiAlgorithm.calcTableHuXi({{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}))



local __tt = {102, 107, 108, 109, 110, 110}
local __tt = BaseAlgorithm.statCards(__tt)
local __ret = {}
PaoHuZiAlgorithm.searchBiPai2710(__tt, 107, __ret)
assert(#__ret == 1)



local __tt = {102, 107, 108, 109, 110, 110}
local __tt = BaseAlgorithm.statCards(__tt)
local __ret = PaoHuZiAlgorithm.calcMatchCombination(__tt, 107)
assert(#__ret == 2)


local __tt = {110, 110, 109, 109, 108, 108, 107, 107, 207, 207, 106, 106, 105, 105, 102, 102}
local __ret = PaoHuZiAlgorithm.searchChi(__tt, 107)
assert(#__ret == 104) --  根据人工确认数据OK，返回结果条数应为104条

local __tt = {108, 107, 106, 106, 105, 102, 102}
local __ret = PaoHuZiAlgorithm.searchChi(__tt, 107)
assert(#__ret == 2) --  根据人工确认数据OK，返回结果条数应为2条

local __tt = {110, 110, 109, 109, 108, 107, 107, 207, 207, 106, 106, 105, 105, 102, 102}
local __ret = PaoHuZiAlgorithm.searchChi(__tt, 107)
assert(#__ret == 71) --  根据人工确认数据OK，返回结果条数应为71条

local __tt = {105, 106, 105, 106, 106, 107}
local __ret = PaoHuZiAlgorithm.searchChi(__tt, 107)
assert(#__ret == 0) --  根据人工确认不能吃的牌型

local __tt = {105, 106, 105, 106, 107, 107, 107}
local __ret = PaoHuZiAlgorithm.searchChi(__tt, 107)
assert(#__ret == 0) --  根据人工确认不能吃的牌型



local __tt = {102, 107, 108, 109, 110, 110, 201, 202, 203}
local __tt = BaseAlgorithm.statCards(__tt)
local __tc = {{103, 103,103}}
local __ret = PaoHuZiAlgorithm.matchCombinationFromMinCard(__tt, __ret, {})
assert(#__ret == 1)





--  胡牌测试
local __tt = {102,107,110,206, 206}
local __tc = {{CTYPE_PAO, 105, 105, 105, 105},{CTYPE_PAO, 108, 108, 108, 108}, {CTYPE_WEI, 203, 203, 203}, {CTYPE_PENG, 104,104,104}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 206, true)
--  人工对结果进行判断，可胡牌，并且有27点胡息
-- dump(__ret)
-- assert(#__ret == 1)
-- assert(__ret[1][1] == 25)

local __tt = {103, 104, 105, 203, 204, 205, 102, 107, 110, 207, 208}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 209)
--  人工对结果进行判断，可胡牌，并且有24点胡息
assert(#__ret == 1)
assert(__ret[1][1] == 24)

local __tt = {103, 104, 105, 208, 208}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 208, true)
--  人工对结果进行判断，可胡牌，并且有27点胡息
assert(#__ret == 1)
assert(__ret[1][1] == 27)

local __tt = {103}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 103, false)
--  人工对结果进行判断，可胡牌，并且有21点胡息
assert(#__ret == 1)
assert(__ret[1][1] == 21)

local __tt = {103}
local __tc = {{CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 103, false)
--  不可胡牌，相公牌
assert(#__ret == 0)

local __tt = {103}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 103, false)
--  不可胡牌，胡息不够
assert(#__ret == 0)

local __tt = {103, 104, 105, 208, 208, 109, 109, 109}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 208, true)
--  人工对结果进行判断，可胡牌，并且有30点胡息
assert(#__ret == 1)
assert(__ret[1][1] == 30)

--  人工判断不能胡牌
local __tt = {210,210,210,209,109,108,207,206,106,205,105,105,204,104,203,203,103,103,102,201}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, {}, 102)
assert(#__ret == 0)

--  测试碰胡
local __tt = {103, 104, 105, 203, 204, 205, 107, 107, 209, 209}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 209)
assert(#__ret == 1)
assert(__ret[1][1] == 24) --  人工对结果进行判断，可胡牌，并且有24点胡息

--  测试偎胡
local __tt = {103, 104, 105, 203, 204, 205, 107, 107, 209, 209}
local __tc = {{CTYPE_TI, 210, 210, 210, 210}, {CTYPE_WEI, 102, 102, 102}, {CTYPE_SHUN, 201, 202, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 209, true)
assert(#__ret == 1)
assert(__ret[1][1] == 27)--  人工对结果进行判断，可胡牌，并且有27点胡息

local __tt = {110, 107, 106, 106, 205, 105, 103, 103, 103, 202, 202, 202, 102}
local __tc = {{CTYPE_PAO, 101, 101, 101, 101}, {CTYPE_DA_XIAO_DA, 208, 108, 108}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 205)
assert(#__ret == 1)
assert(__ret[1][1] == 18)--  人工对结果进行判断，可胡牌，并且有18点胡息

local __tt = {104, 104, 204, 103, 103, 102, 102, 102}
local __tc = {{CTYPE_TI, 101, 101, 101, 101}, {CTYPE_WEI, 208, 208, 208}, {CTYPE_PENG, 108, 108, 108}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 102)
assert(#__ret == 1) -- 这种方案可跑胡
assert(__ret[1][1] == 22) --  人工对结果进行判断，可胡牌，并且有22点胡息

local __tt = {104, 104, 204, 103, 103, 102, 102, 102}
local __tc = {{CTYPE_TI, 101, 101, 101, 101}, {CTYPE_WEI, 208, 208, 208}, {CTYPE_PENG, 108, 108, 108}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 102, true)
assert(#__ret == 1) -- 这种方案可提胡
assert(__ret[1][1] == 25) --  人工对结果进行判断，可胡牌，并且有25点胡息

local __tt = {210, 210, 210, 209, 209, 209, 107, 106, 108, 106, 105, 104, 204, 205, 206, 203, 103, 103, 102, 102}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, {}, 102, true)
assert(#__ret == 1) -- 这种方案可偎胡
assert(__ret[1][1] == 15) --  人工对结果进行判断，可胡牌，并且有15点胡息

local __tt = {210, 210, 210, 209, 209, 209, 107, 102, 110, 106, 105, 104,
              204, 205, 206, 203, 103, 103, 102, 202}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, {}, 102)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 15) --  人工对结果进行判断，可胡牌，并且有15点胡息

local __tt = {201,202,203,102,107,110,109,208,108,206,103,103,110}
local __tc = {{CTYPE_PAO, 101, 101, 101, 101}, {CTYPE_CHI, 209, 109, 209}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 207, true)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 15) --  人工对结果进行判断，可胡牌，并且有15点胡息

local __tt = {202,207,210,110,109,108,209,208,210,204,204,103,103}
local __tc = {{CTYPE_PAO, 102, 102, 102, 102}, {CTYPE_PENG, 203, 203, 203}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 204, false)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 18) --  人工对结果进行判断，可胡牌，并且有18点胡息

local __tt = {207,207,205,105,105,204,204,104,102,102}
local __tc = {{CTYPE_PAO, 103, 103, 103, 103}, {CTYPE_PAO, 209, 209, 209, 209}, {CTYPE_PENG, 106, 106, 106}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 202, false)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 16) --  人工对结果进行判断，可胡牌，并且有18点胡息

local __tt = {102,107,110,209,109,204,204,104,103,102}
local __tc = {{CTYPE_PAO, 101, 101, 101, 101}, {CTYPE_PAO, 210, 210, 210, 210}, {CTYPE_WEI, 208, 208, 208}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 109, false)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 24) --  人工对结果进行判断，可胡牌，并且有18点胡息

local __tt = {102, 107, 110, 209, 109, 109, 204, 204, 104, 103, 102}
local __tc = {{CTYPE_WEI, 101, 101, 101}, {CTYPE_WEI, 210, 210, 210}, {CTYPE_WEI, 208, 208, 208}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 208, false)
assert(#__ret == 1) -- 这种方案可胡牌
assert(__ret[1][1] == 21) --  人工对结果进行判断，可胡牌，并且有21点胡息

local __tt = {210, 210, 210, 210, 209, 209, 209, 208, 208, 208, 
        106, 105, 104, 204, 205, 206, 203, 103, 103, 101}
local __tc = {}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 101, false)
assert(#__ret == 1)
assert(__ret[1][1] == 24) --  天胡，单吊胡，人工对结果进行判断，可胡牌，并且有24点胡息

local __tt = {204,204,204,208,208,108,206,206}
local __tc = {{CTYPE_DA_XIAO_DA,107,207,207}, {CTYPE_PENG,106,106,106}, 
      {CTYPE_PENG,110,110,110}, {CTYPE_WEI,209,209,209} }
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 110, false)
assert(#__ret == 1)
assert(__ret[1][1] == 19) --  天胡，桌面跑胡，人工对结果进行判断，可胡牌，并且有19点胡息

local __tt = {104, 104, 204, 107, 110, 102, 102, 102}
local __tc = {{CTYPE_TI, 101, 101, 101, 101}, {
    CTYPE_WEI, 208, 208, 208}, {CTYPE_PENG, 108, 108, 108}}
local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 102, false)
assert(#__ret == 1)  --  这种方案可破跑胡
assert(__ret[1][1] == 22)  --  人工对结果进行判断，可胡牌，并且有22点胡息

local __tt = {104, 104, 204, 107, 110, 102, 102}
local __tc = {{CTYPE_TI, 101, 101, 101, 101}, {
    CTYPE_WEI, 208, 208, 208}, {CTYPE_PENG, 108, 108, 108}}
local __ret = PaoHuZiAlgorithm.getTingPai({102, 110, 202, 203, 209}, __tt, __tc)
assert(__ret[1] == 102)

local __handlerCards = {{206, 206, 206, 106}}
local __qiPaiCards = {{106}}
local __waiPai = {
    {
        {CTYPE_TI, 209, 209, 209, 209},
        {CTYPE_PENG, 108, 108, 108},
        {CTYPE_PENG, 202, 202, 202},
        {CTYPE_PENG, 103, 103, 103},
        {CTYPE_PENG, 208, 208, 208},
    },
    {
        {CTYPE_PENG, 205, 205, 205},
        {CTYPE_PENG, 203, 203, 203},
        {CTYPE_PENG, 101, 101, 101},
        {CTYPE_PENG, 207, 207, 207},
        {CTYPE_PENG, 201, 201, 201},
    },
    {
        {CTYPE_DA_XIAO_DA, 102, 202, 102},
        {CTYPE_PENG, 104, 104, 104},
        {CTYPE_PENG, 105, 105, 105},
    }
}

local cards = PaoHuZiAlgorithm.getRemainCards(__handlerCards, __qiPaiCards, __waiPai)
table.sort(cards)

local __handlerCards = {{101, 101, 210, 210, 106, 107, 108, 204, 205, 206, 201}}
local __qiPaiCards = {{108, 110}, {201, 207, 104}}
local __waiPai = {
    {
        {CTYPE_TI, 105, 105, 105, 105},
        {CTYPE_WEI, 109, 109, 109},
        {CTYPE_PENG, 102, 102, 102},
    },
    {
        {CTYPE_TI, 202, 202, 202},
        {CTYPE_PENG, 103, 103, 103},
        {CTYPE_PENG, 209, 209, 209},
    },
}

local cards = PaoHuZiAlgorithm.getRemainCards(__handlerCards, __qiPaiCards, __waiPai)

local __tt = {101, 101, 210, 210, 106, 107, 108, 204, 205, 206, 201}
local __tc = {
        {CTYPE_TI, 105, 105, 105, 105},
        {CTYPE_WEI, 109, 109, 109},
        {CTYPE_PENG, 102, 102, 102},
    }
local __ret = PaoHuZiAlgorithm.getTingPai(cards, __tt, __tc)
dump(__ret)

local __ret = PaoHuZiAlgorithm.canHu(__tt, __tc, 102, true)
dump(__ret)

local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 102, true)
dump(__ret[1][2])


local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 102, true)
dump(__ret[1][2])

local __tt = {101, 101, 201, 201}
local __tc = {
        {CTYPE_TI, 204, 204, 204, 204},
    }

local __ret = PaoHuZiAlgorithm.searchHu(__tt, __tc, 201, true)
assert(#__ret > 0) 

local __ret = PaoHuZiAlgorithm.getTingPai(PaoHuZiAlgorithm.getRemainCards(), __tt, __tc)

local __tt = {101, 101, 201, 103, 103, 207, 208, 209}
local __tc = {
        {CTYPE_TI, 204, 204, 204, 204},
    }

local __ret = PaoHuZiAlgorithm.getTingPai(PaoHuZiAlgorithm.getRemainCards(), __tt, __tc)
assert(__ret[1] == 103)

local __tt = {203, 204, 205, 206}
local __tc = {
        {CTYPE_TI, 207, 207, 207, 207},
        {CTYPE_TI, 208, 208, 208, 208},
    }

local __ret = PaoHuZiAlgorithm.getTingPai(PaoHuZiAlgorithm.getRemainCards(), __tt, __tc)
dump(table.indexof(__ret, {203}))
dump(table.indexof(__ret, {206}))

local __tt = {204, 204, 206, 206, 104, 105, 106}
local __tc = {
        {CTYPE_TI, 207, 207, 207, 207},
        {CTYPE_TI, 208, 208, 208, 208},
    }

local __ret = PaoHuZiAlgorithm.getTingPai(PaoHuZiAlgorithm.getRemainCards(), __tt, __tc)
dump(__ret)


-- 测试五坎天胡
local __tt = {110, 110, 110, 107, 107, 107, 105, 105, 105, 102, 102, 102, 210, 210, 210, 104, 104, 104, 204, 106}
assert(true == PaoHuZiAlgorithm.canQiShouTianHu(__tt))
assert(false == PaoHuZiAlgorithm.canQiShouTianHu({110, 110, 107, 107, 107, 105, 105, 105, 102, 102, 102, 210, 210, 210, 104, 104, 106}))
-- 测试三提天胡
local __tt = {110, 110, 110, 110, 105, 105, 105, 105, 102, 102, 102, 102, 210, 210, 210, 104, 104, 104, 204, 106}
assert(true == PaoHuZiAlgorithm.canQiShouTianHu(__tt))
assert(false == PaoHuZiAlgorithm.canQiShouTianHu({110, 110, 105, 105, 105, 105, 102, 102, 210, 210, 210, 210, 104, 104, 204, 106}))
local __tt = {101, 101, 101, 102, 102, 102, 102, 202, 202, 202, 203, 203, 203, 204, 204, 204, 110, 210, 209, 208}
assert(true == PaoHuZiAlgorithm.canQiShouTianHu(__tt))



local __tt = {103, 104, 105, 208, 208}
local __tc = {{CTYPE_PAO, 210, 210, 210, 210}, }
assert(PaoHuZiAlgorithm.canHu(__tt, __tc, 208, true)) --  人工对结果进行判断，可胡牌
assert(not PaoHuZiAlgorithm.canHu(__tt, __tc, 208, false)) --  人工对结果进行判断，不可胡牌，胡息不够

local __tt = {108, 104, 201, 101}
local __tc = {}
assert(not PaoHuZiAlgorithm.canHu(__tt, __tc, 101, true)) --  人工对结果进行判断，不可胡牌
assert(not PaoHuZiAlgorithm.canHu(__tt, __tc, 208, false)) --  人工对结果进行判断，不可胡牌

local __tt = {108}
local __tc = {
    {CTYPE_PAO, 210, 210, 210, 210},
    {CTYPE_PAO, 209, 209, 209, 209},
}
assert(PaoHuZiAlgorithm.canHu(__tt, __tc, 108, true)) --  人工对结果进行判断，不可胡牌

local __tt = {103, 203, 204, 204, 109, 109, 209}

-- local __ret = PaoHuZiAlgorithm.getTingPai(PaoHuZiAlgorithm.getRemainCards(), __tt, __tc)
-- dump(__ret)
-- assert(false)