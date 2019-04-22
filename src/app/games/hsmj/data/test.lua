local data = {
{
    cards = {
        {11,11,11,13,13,13,15,15,19,19,21,22,23},
        {11,11,12,12,13,13,15,15,19,19,21,22,23},
        {11,11,12,12,13,13,15,15,19,19,21,22,23},
        {11,11,12,12,13,13,15,15,19,19,21,22,23},
        {31,34,35,32,33}
    },
    dealer =1,
},

-- 2暗杠
{
    cards = {
        {11,11,11,11},
        {},
        {},
        {},
        {}
    },
    dealer =1,
},

-- 3明杠
{
    cards = {
        {11,11},
        {11},
        {},
        {},
        {13, 14, 15, 16, 17, 11}
    },
    dealer =1,
},

-- 4胡牌 自摸
{
    cards = {
        {11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15},
        {},
        {},
        {},
        {15}
    },
    dealer =1,
},

-- 5胡牌 放炮
{
    cards = {
        {11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15},
        {15},
        {},
        {},
        {}
    },
    dealer =1,
},

-- 6放杠
{
    cards = {
        {11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15},
        {11},
        {},
        {},
        {}
    },
    dealer =1,
},

-- 7抢杠胡
{
    cards = {
        {11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15},
        {11},
        {12, 13, 31, 31, 31, 32, 32, 32, 33, 33, 33, 34, 34},
        {},
        {15, 22, 22, 22, 22, 11}
    },
    dealer =1,
},

-- 8 七小对
{
    cards = {
        {11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17},
        {11},
        {12, 13, 31, 31, 31, 32, 32, 32, 33, 33, 33, 34, 34},
        {},
        {17, 22, 22, 22, 22, 11}
    },
    dealer =1,
},

-- 9 1红中胡
{
    cards = {
        {51, 11, 13, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15},
        {},
        {},
        {},
        {15}
    },
    dealer =1,
},

-- 10 2红中胡
{
    cards = {
        {51, 11, 51, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15},
        {11},
        {12, 13, 31, 31, 31, 32, 32, 32, 33, 33, 33, 34, 34},
        {},
        {15, 22, 22, 22, 22, 11}
    },
    dealer =1,
},

    -- 长沙麻将测试用例
    -- 11 听牌杠
    {
        cards = {
            {11,11,11,12,12,12,13,13,13,14,14,14,15},
            {},
            {},
            {},
            {11, 33, 34}
        },
        dealer =1,
    },
        -- 长沙麻将测试用例
    -- 12 听牌杠
    {
        cards = {
            {11,11,11,12,12,12,13,13,13,14,24,14,15},
            {},
            {},
            {},
            {11, 33, 34,25,12,15}
        },
        dealer =1,
    },
    -- 13 缺一色
    {
        cards = {
            {11,11,11,22,22,22,13,13,13,14,24,14,15},
            {},
            {},
            {},
            {11, 33, 34,25,12,15}
        },
        dealer =1,
    },

}
return data
