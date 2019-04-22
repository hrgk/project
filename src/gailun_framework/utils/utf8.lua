-- utf8.lua
local utf8 = {}
-- 判断utf8字符byte长度
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
local function chsize(char)
    if not char then
        print("not char")
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如utf8 len("1你好") => 3
function utf8.len(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        len = len + 1
    end
    return len
end

-- 字母数字0.5 
function utf8.length(str)
    local len = 0
    local currentIndex = 1
    local function chsize(char)
        
        if not char then
            print("not char")
            return 0
        elseif char > 240 then
            return 4
        elseif char > 225 then
            return 3
        elseif char > 192 then
            return 2
        else
            return 0.5
        end
    end
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + 1
        len = len + chsize(char)
    end
    return len 
end

-- 截取utf8 字符串
-- str:         要截取的字符串
-- startChar:   开始字符下标,从1开始
-- numChars:    要截取的字符长度
function utf8.sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars - 1
    end
    return str:sub(startIndex, currentIndex - 1)
end

-- 人性化截取 utf8 字符串，中文算两字节，数字英文算1字节
-- str:         要截取的字符串
-- startChar:   开始字符下标,从1开始
-- numChars:    要截取的字符长度
function utf8.sub_human(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        if chsize(char) > 1 then
            numChars = numChars - 2
        else
            numChars = numChars - 1
        end
    end
    return str:sub(startIndex, currentIndex - 1)
end

function utf8.split_human(str, lineLength)
    local function sub__(str, lineLength, tmpList)
        local tmpList = tmpList or {}
        if not str or string.len(str) < 1 then
            return tmpList
        end
        if utf8.display_len(str) <= lineLength then
            table.insert(tmpList, str)
            return tmpList
        end
        local lineStr = utf8.sub_human(str, 1, lineLength)
        local leftStr = string.sub(str, string.len(lineStr) + 1)
        table.insert(tmpList, lineStr)
        return sub__(leftStr, lineLength, tmpList)
    end
    local list = sub__(str, lineLength)
    return table.concat(list, "\n")
end

-- 计算utf8字符串字符数, 数字英文算一个字符，中文算两个字符
-- 例如utf8 display_len("1你好") => 5
function utf8.display_len(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        if chsize(char) > 1 then
            len = len + 2
        else
            len = len + 1
        end
    end
    return len
end

utf8.formatNickName = function(nickName, length, surFix)
    if utf8.display_len(nickName) > length then
        return utf8.sub_human(nickName, 1, length) .. surFix    
    end
    return nickName
end

return utf8
