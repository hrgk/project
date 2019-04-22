local data = {
{
    cards = {
        {108,108,108,202,207,210,209,209,109,109,206,106,106,205,105,103,202,101,107,107},
        {204,104,204,205,105,207,107,106,110,208,108,101,102,103,202,207,210,201,202,203},
        {102,107,110,210,210,110,209,209,109,207,206,206,105,204,104,203,103,102,201,201},
        {105,203,101,106,110,205,102,206,104},
    },
    dealer =2,
},

--  2 偎胡
{
    cards = {
        {209,209,209,202,207,210,109,208,108,206,206,106,105,104,104,203,202,102,101,101},
        {204,204,204,204,210,210,109,208,208,108,108,207,107,107,206,106,106,105,203,201},
        {201,201,202,202,203,203,210,110,110,209,109,107,206,106,205,205,105,103,103,101},
        {104,208,102,101,205},
    },
    dealer = 2,
},

--  3 4提+一坎
{
    cards = {
        {101,101,101,101,102,102,102,102,103,103,103,103},  -- 三提
        {201,201,201,201,202,202,202,203,203,203,204,204,204,205,205,205},  -- 五坎
        {104,104,105,105,106,106,107,107,108,108,109,109,207,207,207,208,208,208,209,209},  -- 自然胡
        {209},
    },
    dealer = 1,
},

--  4 测试偎胡
{
    cards = {
        {},
        {},
        {104,104,105,105,106,106,107,107,108,108,109,109,207,207,207,208,208,208,209,209},
        {210,209},
    },
    dealer = 2,
},

-- 5 测试三个玩家都有一到三提的情况 庄家随机
{
    cards = {
        {101,101,101,101},
        {102,102,102,102,103,103,103,103},
        {104,104,104,104,105,105,105,105,201,201,201,201},
        {},
    },
    dealer = 0,
},

-- 6 测试钻洞胡牌的情况
{
    cards = {
        {},
        {107,107,107},
        {110,110,205,205,208,208,210,210,207,207,209,209,106,105,204,204,109,108,108,106},
        {104,110,205,208,210,207,209,107,204,204,108,108},
    },
    dealer = 3,
},
--1 庄天胡 
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,104,104,104,105,106,107,109,109,109,201,202,203,204,205,206,207,208},
        {},
        {},
        {209},
    },
    dealer = 1,
},

-- 2  闲1地胡
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {101,101,101,104,104,104,105,106,107,109,109,109,201,202,203,204,205,206,207,208},
        {},
        {209},
    },
    dealer = 1,
},
-- 3  闲2地胡
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,104,104,104,105,106,107,109,109,109,201,202,203,204,205,206,207,208},
        {209},
    },
    dealer = 1,
},

--  4 三家天地胡
--适用类型： 68番、8-10番
{
    cards = {
        {101,102,103,104,104,104,104,107,108,109,201,202,203,204,204,204,207,207,207,210}, 
        {101,102,103,105,105,105,105,107,108,109,201,202,203,205,205,205,208,208,208,210},  
        {101,102,103,106,106,106,106,107,108,109,201,202,203,206,206,206,209,209,209,210},  
        {210},
    },
    dealer = 1,
},

--  5 庄+闲1天地胡
--适用类型： 68番、8-10番
{
    cards = {
        {101,102,103,104,104,104,104,107,108,109,201,202,203,204,204,204,207,207,207,210},
        {101,102,103,105,105,105,105,107,108,109,201,202,203,205,205,205,208,208,208,210},
        {},
        {210},
    },
    dealer = 1,
},

-- 6 庄+闲2天地胡
--适用类型： 68番、8-10番
{
    cards = {
        {101,102,103,104,104,104,104,107,108,109,201,202,203,204,204,204,207,207,207,210},
        {},
        {101,102,103,105,105,105,105,107,108,109,201,202,203,205,205,205,208,208,208,210},
        {210},
    },
    dealer = 1,
},

-- 7 闲1+闲2天地胡
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {101,102,103,104,104,104,104,107,108,109,201,202,203,204,204,204,207,207,207,210},
        {101,102,103,105,105,105,105,107,108,109,201,202,203,205,205,205,208,208,208,210},
        {},
    },
    dealer = 1,
},

-- 8 3提 庄家
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {},
        {},
    },
    dealer = 1,
},

-- 9 5坎庄
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
        {},
        {210},
    },
    dealer = 1,
},

-- 10 闲1 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {},
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {},
    },
    dealer = 1,
},

-- 11 5坎 闲1
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {},
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
        {210},
    },
    dealer = 1,
},

-- 12 闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {},
        {},
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 13 5坎 闲2
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {},
        {},
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
    },
    dealer = 1,
},

-- 14  庄3提+闲1 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {103,103,103,103,105,105,105,105,108,108,108,108},
        {},
        {},
    },
    dealer = 1,
},

-- 15 庄3提+闲1 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
        {},
    },
    dealer = 1,
},

-- 16 庄3提+闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {103,103,103,103,105,105,105,105,108,108,108,108},
        {},
    },
    dealer = 1,
},

-- 17 庄3提+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
    },
    dealer = 1,
},

-- 18 庄5 闲1 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {},
    },
    dealer = 1,
},

-- 19 庄5坎 +闲1 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {201,201,201,203,203,203,205,205,205,208,208,208,210,210,210},
        {},
        {},
    },
    dealer = 1,
},

-- 20 庄5 闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 21 庄5 闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
        {201,201,201,203,203,203,205,205,205,208,208,208,210,210,210},
        {},
    },
    dealer = 1,
},

-- 22 庄3提+闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {103,103,103,103,105,105,105,105,108,108,108,108},
        {},
    },
    dealer = 1,
},

-- 23 庄3提+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
    },
    dealer = 1,
},

-- 24 闲1 5坎   闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {},
        {107,107,107,102,102,102,103,103,103,104,104,104,105,105,105},
        {101,101,101,101,201,201,201,201,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 25 闲1 5坎   闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {},
        {201,201,201,203,203,203,205,205,205,208,208,208,210,210,210},
        {101,101,101,102,102,102,103,103,103,104,104,104,105,105,105},
        {},
    },
    dealer = 1,
},

-- 26 全3提
--适用类型： 68番选用规则、8-10番选用规则
{
     cards = {
        {101,101,101,101,103,103,103,103,201,201,201,201},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {105,105,105,105,108,108,108,108,206,206,206,206},
        {},
    },
    dealer = 1,
},

-- 27 庄家3提+闲1 3提+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,103,103,103,103,201,201,201,201},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {},
    },
    dealer = 1,
},

-- 28 庄家3提+闲1 5坎+闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,103,103,103,103,201,201,201,201},
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 29 庄家3提+闲1 5坎+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,101,103,103,103,103,201,201,201,201},
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {102,102,102,104,104,104,204,204,204,107,107,107,209,209,209},
        {},
    },
    dealer = 1,
},

-- 30 庄家5坎+闲1 3提+闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {101,101,101,101,103,103,103,103,201,201,201,201},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 31 庄家5坎+闲1 3提+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {101,101,101,103,103,103,201,201,201,206,206,206,109,109,109},
        {},
    },
    dealer = 1,
},

-- 32 庄家5坎+闲1 5坎+闲2 3提
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {106,106,106,108,108,108,110,110,110,205,205,205,208,208,208},
        {101,101,101,103,103,103,201,201,201,206,206,206,109,109,109},
        {102,102,102,102,104,104,104,104,204,204,204,204},
        {},
    },
    dealer = 1,
},

-- 33 庄家5坎+闲1 5坎+闲2 5坎
--适用类型： 68番选用规则、8-10番选用规则
{
    cards = {
        {101,101,101,104,104,104,107,107,107,201,201,201,204,204,204},
        {102,102,102,105,105,105,108,108,108,202,202,202,205,205,205},
        {103,103,103,106,106,106,109,109,109,203,203,203,206,206,206},
        {},
    },
    dealer = 1,
},

-- 34 庄家乌胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {101,101,101,101,103,103,104,104,105,105,209,209,209,208,208,208,206,206,206,106},
        {},
        {},
        {102,102,107,106
},
    },
    dealer = 1,
},

-- 35 闲1乌胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {101,101,101,101,103,103,104,104,105,105,209,209,209,208,208,208,206,206,206,106},
        {},
        {102,102,107,106
},
    },
    dealer = 1,
},

-- 36 闲2乌胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,101,103,103,104,104,105,105,209,209,209,208,208,208,206,206,206,106},
        {102,102,107,106
},
    },
    dealer = 1,
},

-- 37 庄点胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {101,101,101,101,103,203,203,104,105,105,106,106,106,108,108,108,105,109,109,109},
        {},
        {},
        {201,102,110},
    },
    dealer = 1,
},

-- 38 闲1点胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {101,101,101,101,103,203,203,104,105,105,106,106,106,108,108,108,105,109,109,109},
        {},
        {201,102,110},
    },
    dealer = 1,
},

-- 39 闲2点胡
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,101,103,203,203,104,105,105,106,106,106,108,108,108,105,109,109,109},
        {201,102,110},
    },
    dealer = 1,
},

-- 40 庄 超红（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,201,202,203,204,205,206,103,104,105,104,105},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 41 闲1超红（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {102,102,102,107,107,107,110,110,110,201,202,203,204,205,206,103,104,105,104,105},
        {},
        {105,204,103,201,204},
    },
    dealer = 1,
},

-- 42 闲2超红（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {},
        {},
        {102,102,102,107,107,107,110,110,110,201,202,203,204,205,206,103,104,105,104,105},
        {105,204,103,201,204},
    },
    dealer = 1,
},


-- 43 超红10张（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,202,203,204,205,206,103,104,105,104,105,106},
        {},
        {},
        {101,201,204,201,204},
    },
    dealer = 1,
},

-- 44 超红11张（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,201,202,203,201,202,203,103,104,105,104,105},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 45 超红12张（普跑为红胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,201,202,203,201,202,203,205,206,207,104,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 46 超红13张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,201,202,203,202,207,210,204,205,206,104,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 47 超红14张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,201,202,203,202,207,210,207,205,206,104,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 48 超红15张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,202,207,210,202,207,210,204,205,206,104,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 49 超红16张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,102,107,107,107,110,110,110,202,207,210,202,207,210,204,205,206,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 50 超红17张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,102,107,107,107,110,110,110,202,202,202,210,210,210,210,205,206,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 51 超红18张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,202,202,202,207,207,207,210,210,210,104,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 52 超红19张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,202,202,202,207,207,207,210,210,210,102,104},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 53 超红20张（普跑为弯胡）
--适用类型：普跑、 68番、8-10番
{
    cards = {
        {102,102,102,107,107,107,110,110,110,202,202,202,207,207,207,210,210,210,102,210},
        {},
        {},
        {105,104,103,201,204},
    },
    dealer = 1,
},

-- 54 对对胡 庄
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,102,102,102,103,103,104,104,201,201,202,202,203,203,204,204,205,205},
        {},
        {},
        {107,108,204,205,103,102},
    },
    dealer = 1,
},

-- 55 对对胡 闲1
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {101,101,101,102,102,102,103,103,104,104,201,201,202,202,203,203,204,204,205,205},
        {},
        {107,108,204,205,103,102},
    },
    dealer = 1,
},

-- 56 对对胡 闲2
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,102,102,102,103,103,104,104,201,201,202,202,203,203,204,204,205,205},
        {107,108,204,205,103,102},
    },
    dealer = 1,
},

-- 57 小字 庄16张
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,208,202,203,201},
        {},
        {},
        {},
    },
    dealer = 1,
},

-- 58 小字 闲1 16张
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,208,202,203,201},
        {},
        {},
    },
    dealer = 1,
},

-- 59 小字 闲2 16张
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,208,202,203,201},
        {},
    },
    dealer = 1,
},

-- 60 小字 17张
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {},
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,208,202,203,201},
        {},
    },
    dealer = 1,
},

-- 61 小字 18张
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,208,202,203,201},
        {},
        {},
        {101,201,202,102},
    },
    dealer = 1,
},

-- 62 小字 19张
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,108,202,203,201},
        {},
        {},
        {101,201,202,102,204,207,106},
    },
    dealer = 1,
},

-- 63 小字 20张
--适用类型： 68番、8-10番
{
    cards = {
        {101,101,101,102,103,104,105,106,107,108,109,110,110,110,110,109,108,102,203,201},
        {},
        {},
        {101,201,202,102,204,207,106},
    },
    dealer = 1,
},

-- 64 庄大字 18张
--适用类型： 68番、8-10番
{
    cards = {
        {201,201,201,202,203,204,205,206,207,208,209,210,210,210,210,209,208,109,106,104},
        {},
        {},
        {201,207,207,202,206,207,106},
    },
    dealer = 1,
},

-- 65 闲1 大字 18张
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {201,201,201,202,203,204,205,206,207,208,209,210,210,210,210,209,208,109,106,104},
        {},
        {201,207,207,202,206,207,106},
    },
    dealer = 1,
},

-- 66 闲2 大字 18张
--适用类型： 68番、8-10番
{
    cards = {
        {},
        {},
        {201,201,201,202,203,204,205,206,207,208,209,210,210,210,210,209,208,109,106,104},
        {201,207,207,202,206,207,106},
    },
    dealer = 1,
},

-- 67 庄大字 19张
--适用类型： 68番、8-10番
{
    cards = {
        {201,201,201,202,203,204,205,206,207,208,209,210,210,210,210,209,208,109,106,104},
        {},
        {},
        {201,207,207,202,206,207,106},
    },
    dealer = 1,
},

-- 68 庄大字 20张
--适用类型： 68番、8-10番
{
    cards = {
        {201,201,201,202,203,204,205,206,207,208,209,210,210,210,210,209,208,209,206,205},
        {},
        {},
        {101,107,107,206,207,208},
    },
    dealer = 1,
},

-- 69 团圆 1团
--适用类型：8-10番
{
    cards = {
        {101,101,101,101,201,201,201,201,102,103,104,105,106,107,108,109,110,207,208,209},
        {},
        {},
        {103,107,107,206,207,208},
    },
    dealer = 1,
},

-- 70 团圆 2团
--适用类型：8-10番
{
    cards = {
        {101,101,101,101,201,201,201,201,102,102,102,102,202,202,202,202},
        {},
        {},
        {103,107,107,206,207,208},
    },
    dealer = 1,
},


--71 行行息
{
    cards = {
        {101,102,103,101,102,103,202,207,210,202,207,210,203,203,203,206,206,206,107,107},
        {},
        {},
        {105,206,203,107,207,208},
    },
    dealer = 1,
},

-- 72 测试能跑能胡点过，要能直接跑起，玩家3为庄，起手直接出大九，玩家1碰起，再出小八，则情景再现
{
    cards = {
        {201,201,201,102,102,102,209,209,202,207,210,204,205,206,104,104,203,204,205,108},
        {103,103,103,103,107,108,109,210,208,106,106,106,207,205,105,104,201,101,101,102},
        {209,},
        {108,209},
    },
    dealer = 3,
},

{ -- 73　测试碰加吃 解决禅道里面的BUG
    cards = {
        {204, 208, 203, 203, 110, 202, 204, 204, 107, 109, 103, 206, 208, 204, 105, 105, 208, 210, 103, 103},
        {205, 105, 202, 107, 209, 203, 206, 104, 107, 109, 210, 102, 106, 202, 207, 110, 102, 108, 110, 109},
        {109, 102, 205, 102, 207, 108, 210, 108, 210, 101, 201, 208, 205, 106, 104, 201, 105, 207, 206, 101},
        {205, 108, 106, 110, 209, 104, 106, 104, 209, 202, 203, 209, 207, 107, 206, 101, 101, 201, 201, 103},
    },
    dealer = 1,
},

{ -- 74　测试海底胡直接胡，先打大9，再碰大一，忍一手牌不出，其它情况都不要，别的玩家不点胡就可以测到底
    cards = {
        {101,101,101,101,102,102,102,102,103,104,105,106,107,108,203,204,205,206,201,201},
        {206,206,203},
        {203,203,201},
        {209, 201, 108, 106, 110, 209, 104, 106, 104, 209, 202, 208, 209, 207, 107, 208, 105, 105, 208, 206},
    },
    dealer = 1,
},

{ -- 75　测试海底胡的偎胡
    cards = {
        {101,101,101,101,102,102,102,103,104,105,106,107,108,203,204,205,207,207,201,201},
        {206,206,203,102,207,207},
        {203,203,201},
        {209, 206, 108, 106, 110, 209, 104, 106, 104, 209, 202, 208, 209, 206, 107, 208, 105, 105, 208, 201},
    },
    dealer = 1,
},

{ -- 76　测试天胡＋听胡
    cards = {
        {101,102,103,201,202,203,210,210,210,104,105,106,107,108,109,201,202,203,204,205},
        {},
        {},
        {206},
    },
    dealer = 1,
},

{ -- 77　测试地胡＋听胡
    cards = {
        {101,102,103,201,202,203,210,210,210,104,105,106,107,108,109,201,202,203,204,205},
        {},
        {},
        {206},
    },
    dealer = 2,
},

{ -- 78　测试 庄家打一张牌出去，并听胡
    cards = {
        {101,102,103,201,202,203,210,210,210,104,105,106,107,108,109,201,202,203,204,205},
        {},
        {},
        {109,206},
    },
    dealer = 1,
},

{ -- 79　测试 庄起手提，并打一张牌出去，并听胡
    cards = {
        {101,101,101,101,201,202,203,210,210,210,104,105,106,107,108,109,201,202,203,204},
        {},
        {},
        {109,204},
    },
    dealer = 1,
},

{ -- 80　测试 闲起手提，并听胡
    cards = {
        {101,101,101,101,201,202,203,210,210,210,104,105,106,107,108,109,201,202,203,204},
        {},
        {},
        {109,204},
    },
    dealer = 2,
},

{ -- 81　测试 闲听胡
    cards = {
        {101,101,101,210,210,210,201,202,203,104,105,106,107,108,109,202,203,204,205,206},
        {},
        {},
        {109,207,207},
    },
    dealer = 2,
},

{ -- 82
    cards = {
        {201,201,201,203,203,203,204,204,204,205,205,205,206,206,206,208,208,208,209,209}, 
        {},  
        {},  
        {209},
    },
    dealer = 1,
},
{ -- 83
    cards = {
        {204,204,204,101,101,101,104,104,104,109,109,109,201,202,203,208,208,203,103}, 
        {},  
        {},  
        {205,101,110,203},
    },
    dealer = 1,
},
{ -- 84  对对+红
    cards = {
        {202,202,202,107,107,107,102,102,102,109,109,103,210,210,210,208,208,203,203}, 
        {},  
        {},  
        {205,101,110,203},
    },
    dealer = 1,
},
{ -- 85 +6=91  对对+超红
    cards = {
        {202,202,202,107,107,107,102,102,102,109,109,103,210,210,210,103,207,207,207,103}, 
        {},  
        {},  
        {103,101,110,203},
    },
    dealer = 1,
},
{ -- 86 +6=92  测试提胡
    cards = {
        {202,202,202,108,109,110,101,101,101,207,207,207,203,203,103,205,105,105,206,206}, 
        {},  
        {},  
        {108,108,108,202},
    },
    dealer = 1,
},

{ -- 87 +6=93  测试提胡
    cards = {
        {107,208, 201, 108, 104, 106, 109, 203, 103, 102, 110, 206, 104, 101, 107 , 201, 110, 204, 205, 102}, 


        {109, 207, 110, 209, 108, 210, 106, 107, 105, 209, 208, 210, 105, 103, 102, 103, 204, 209, 107, 102},  

        {207, 203, 203, 108, 101, 201, 109, 207, 205, 210, 209, 202, 206, 104,103,202,105,101, 206, 104},  
        {105,202,110,204,106,208,101,106,207,205,202},
    },
    dealer = 3,
},


{ -- 88 +6=94  测试胡
    cards = {
        {207, 207, 105, 107, 103,210,203,209,203,109,209,208,107,205,206,201,205,110,103,102}, 
        {106,106,206,104,203,102,202,108,109,206,210,110,206,107,108,208,203,108,105,104},  
        {101,102,108,209,210,205,204,103,104,110,202,202,201,204,207,101,105,101,105,103},  
        {210,106,101,109,204,109,104,207,208,201},
    },
    dealer = 2,
},
{ -- 95  48番红胡
    cards = {
        {202, 207, 210, 202, 207, 208,209,107,107,107,103,103,203,204,205,105,105}, 
        {},  
        {},  
        {107,101,101,210,103,103,207},
    },
    dealer = 1,
},

{ -- 96  tinghu
    cards = {
        {207, 107, 107, 202, 207, 210,209,109,108,202,201,203,204,204,204,204,101,101,101,101}, 
        {},  
        {},  
        {104,109,105,210,108},
    },
    dealer = 3,
},
{ -- 97  tinghu
    cards = {
        {209, 209, 209, 103, 103, 103,201,202,203,108,108,206,101,101,201,104,105,106,204,206}, 
        {},  
        {},  
        {209,109,105,205,108},
    },
    dealer = 1,
},

}
return data
