require("lfs")
local utils = {}

function utils.mkdir(path, r)
    if io.exists(path) then
        return true
    end
    if not r then
        return lfs.mkdir(path)
    end
    local arr = string.split(path, '/')
    if not arr then
        return false
    end
    local rPath = '/'
    local ok, err = false, nil
    for i,v in ipairs(arr) do
        if string.len(v) > 0 then
            rPath = rPath .. v .. '/'
            print(rPath)
            ok, err = utils.mkdir(rPath)
        end
    end
    return ok
end

function utils.getTime()
    local socket = require "socket"
    return socket.gettime()
end

function utils.invert(tab)
    local map = {}
    for k, v in pairs(tab) do
        map[v] = k
    end

    return map
end

function utils.getList(map)
    local result = {}
    for k, v in pairs(map) do
        table.insert(result, v)
    end

    return result
end

function utils.extends(t1, t2)
    for _, v in ipairs(t2 or {}) do
        table.insert(t1, v)
    end
end

function utils.merge(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
end

function utils.reverse(list)
    local result = {}
    for i = #list, 1, -1 do
        table.insert(result, list[i])
    end

    return result
end

function utils.map(t1, func)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = func(v)
    end

    return result
end

function utils.intercept(list, arg1, arg2)
    if #list == 0 then
        return
    end

    local begin, ended = 1, #list
    if arg2 == nil then
        ended = arg1
    else
        begin = arg1
        ended = arg2
    end

    if ended == 0 then
        return {}
    end
    
    local result = {}
    for i = math.max(begin, 1), math.min(ended, #list) do
        table.insert(result, list[i])
    end

    return result
end

function utils.multiUnitList(t1, count)
    local result = {}
    for i = 1, count, 1 do
        for _,v in ipairs(t1) do
            table.insert(result, v)
        end
    end

    return result
end

function utils.distance(p1, p2)
    return math.sqrt(cc.pDistanceSQ(p1, p2))
end

function utils.filterHTML(str)
    local str = string.gsub(str, "<.->", "")
    str = string.gsub(str, '\r\n', "")
    return str
end

-- 小于1万的直接返回原数
-- 小于1亿的返回 XXX.XX万，如果能整除则没有小数点
-- 大于1亿的返回 XXX.XX亿，如果能整除则没有小数点
function utils.formatChips(chips)
    if not chips or type(chips) ~= "number" then
        return 0
    end
    if math.abs(chips) < 10000 then
        return chips
    end
    if math.abs(chips) < 100000000 then
        local s = "%.2f万"
        if 0 == chips % 10000 then
            s = "%d万"
        end
        return string.format(s, chips / 10000)
    end

    local s = "%.2f亿"
    if 0 == chips % 100000000 then
        s = "%d亿"
    end
    return string.format(s, chips / 100000000)
end

local _string_table = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 
    'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 
    'u', 'v', 'w', 'x', 'y', 'z'}

-- 获得随机字符串，包括字母和数字
function utils.randomString(byte, dict)
    local dict = dict or _string_table
    local byte = byte or 12
    local ret = ""
    for i = 1, byte do
        ret = ret .. dict[math.random(1, #dict)]
    end
    return ret
end

local _string_table_easy = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'k', 'm'}
function utils.randomEasyString(byte)
    return utils.randomString(byte, _string_table_easy)
end

-- 过滤敏感词
function utils.filterKeyWords(str, keyWords)
    keyWords = nil or app.dataManager.keyWords
    local function replaceByRange(tb, m, n)
        for i=1,#tb do
            if i >= m and i<= n then
                tb[i] = "*"
            end
        end
    end
    
    local orin_chars = {}
    local cleanedChars = {}
    local cnt = 0
    -- print('orin:', str)
    -- print(str, cnt)
    for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do --
       -- print('char:', uchar)
       table.insert(orin_chars, uchar)
    end
    for i=1,#orin_chars do
        for j=i,#orin_chars do
            local subStr = table.concat(orin_chars, '', i, j)
            local str = subStr
            str, cnt = string.gsub(str, " ", "") -- punctuations
            -- print(str)
            -- str, cnt = string.gsub(str, "([%s+])", "") -- blanks
            -- print(str)
            if keyWords[str] ~= nil then
                replaceByRange(orin_chars, i, j)
            end    
        end
    end
    -- print("result:" .. table.concat(orin_chars))
    return table.concat(orin_chars)
end

function utils.getClassName(obj)
    local t = type(obj)
    local mt
    if t == "table" then
        mt = getmetatable(obj)
    elseif t == "userdata" then
        mt = tolua.getpeer(obj)
    end

    while mt do
        if mt.__cname  then
            return mt.__cname
        end
        mt = mt.super
    end
    return nil
end

-- 将全局变量设置为只读
function utils.dennyGlobalVariable()
    setmetatable(_G, {
        __newindex = function(_, name, value)
            local msg = "GLOBAL VARIABLE CAN'T BE USED."
            print(msg, name, value)
            error(string.format(msg, name), 0)
        end,

        __index = function(_, name)
            return rawget(_G, name)
        end
    })
end

function utils.zip(str)
    assert(str and type(str) == 'string')
    local zip = require("zlib")
    local compress = zip.deflate()
    return compress(str, "finish")
end

function utils.unzip(str)
    assert(str and type(str) == 'string')
    local zip = require("zlib")
    local uncompress = zip.inflate()
    return uncompress(str, "finish")
end

function utils.bind(func, ...)
    local params = {...}
    return function (...)
        local params = clone(params)
        for k,v in pairs({...}) do
            table.insert(params, v)
        end
        return func(unpack(params))
    end
end

function utils.findChild(node, name)
    return UIHelp.seekNodeByNameEx(node, name)
end

return utils
