local M = {}

--[[
异步加载资源的工具
加载会按列表的元素顺序一个个加载
加载完成后如果指定了回调函数就会回调这个函数
如果没有指定则继续下一个，直到全部元素加载完成
如果想在全部元素加载完成后执行回调，则只需要指定最后一项元素的回调函数就可以了
list的元素的格式有两种: 
1.['单个图片名', {此资源加载完成后的回调函数[可选]}]
2.['plist', 'png', {此资源加载完成后的回调函数[可选]}]
]]
function M.loadRes(list)
    M.loadItem_(list, list[1], 1)
end

function M.loadItem_(list, item, index)
    if not item or type(item) ~= 'table' or #item < 1 then
        M.loadItemEnd_(list, index)
        return
    end

    local isSingleImage_ = false
    if #item == 1 then
        isSingleImage_ = true
    elseif #item == 2 then
        if type(item[1]) == 'string' and type(item[2]) == 'function' then
            isSingleImage_ = true
        end
    end

    if isSingleImage_ then
        display.addImageAsync(item[1], function (...)
            M.loadItemEnd_(list, index, item[2], ...)
        end)
    else
        display.addSpriteFrames(item[1], item[2], function (...)
            M.loadItemEnd_(list, index, item[3], ...)
        end)
    end
end

function M.loadItemEnd_(list, index, callback, ...)
    if callback then
        callback(...)
    end
    local index = index + 1
    if index <= #list then
        M.loadItem_(list, list[index], index)
    end
end

return M
