-- 这不是一个真正的XML库，只是一个简易的用正则匹配来解析XML的工具
local XML = {}

local function subXMLString(XMLString, attrName)
    local pattern = string.format("<%s>(.-)</%s>", attrName, attrName)
    for v in string.gmatch(XMLString, pattern) do
        return v
    end
end

local function getAllChildrenString(XMLString, attrName)
    local pattern = string.format("<%s>(.-)</%s>", attrName, attrName)
    local ret = {}
    for v in string.gmatch(XMLString, pattern) do
        table.insert(ret, v)
    end
    return ret
end

-- 将XML中的LIST解析为table并返回
-- XMLSting：待解析的XML字符串
-- searchPath: 搜索的路径，这里假定最后一项为LIST所保存在的标签名字，将最终在此项中匹配其内容
function XML.ListToTable(XMLString, searchPath)
    local childStrings = XMLString
    for i=1, #searchPath - 1 do
        childStrings = subXMLString(childStrings, searchPath[i])
    end
    if not childStrings then
        return
    end

    local children = getAllChildrenString(childStrings, searchPath[#searchPath])
    if not children or #children <= 0 then
        return
    end

    local pattern = "<(%w+)>(.-)</%w+>"
    local ret = {}
    for _,v in pairs(children) do
        local tmp = {}
        for k1, v1 in string.gmatch(v, pattern) do
            tmp[k1] = v1
        end
        table.insert(ret, tmp)
    end

    return ret
end

function XML.parseOldAccountInfo(s)
    local result = {}
    local pattern = "<acc(.-)/>"
    for v in string.gmatch (s, pattern) do
        v = string.gsub(s, '"', '')
        local tmp = string.split(v, ' ')
        for _, col in pairs(tmp) do
            local _item = string.split(col, '=')
            if #_item == 2 then
                result[_item[1]] = _item[2]
            end
        end
        break
    end
    return result
end

return XML
