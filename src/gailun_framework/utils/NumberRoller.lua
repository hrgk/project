local NumberRoller = class("NumberRoller")

local function calcSmallNumberTable(from, to)
    local ret = {from}
    local num = to - from
    local abs = math.abs(num)
    local flag = abs / num
    local t = from
    while abs > 0 do
        t = t + 1 * flag
        table.insert(ret, t)
        abs = abs - 1
    end
    return ret
end

local function calcFloatTable(from, to)
    local ret = {from}
    table.insert(ret, to)
    return ret
end

function NumberRoller:ctor()
    self.total_times = 17  -- 数字调整的基本步骤
    self.slow_steps = 4  -- 数字调整的最后步骤数量
    self.step_time = 0.05  -- 数字调整的时间差
    self.formatString_ = '%s'  -- 格式化字符串
    self.format_handler = string.formatnumberthousands  -- 格式化数字的handler
end

function NumberRoller:calcNumberTable_(from, to)
    local num = to - from
    local abs = math.abs(num)
    local flag = abs / num
    local number , float = math.modf(to)
    if math.abs(float) > 0 then
        return calcFloatTable(from,to)
    end
    if abs <= self.total_times then
        return calcSmallNumberTable(from, to)
    end

    local ret = {from}
    local t = from
    local delta = num / self.total_times
    local do_times = self.total_times
    while do_times > 1 do
        t = t + delta
        table.insert(ret, math.floor(t))
        do_times = do_times - 1
    end

    if math.abs(delta) > self.slow_steps then
        t = t + delta - flag * self.slow_steps
        table.insert(ret, math.floor(t))
    end

    t = math.floor(t)
    for i = t, to, abs/num do
        table.insert(ret, i)
    end

    return ret
end

function NumberRoller:setSlowSteps(number)
    local number = number or self.slow_steps
    self.slow_steps = number
    return self
end

function NumberRoller:setStepTime(seconds)
    local seconds = seconds or self.step_time
    self.step_time = seconds
    return self
end

function NumberRoller:setTotalTimes(times)
    local times = times or self.total_times
    self.total_times = times
    return self
end

function NumberRoller:setFormatString(str)
    local str = str or self.formatString_
    self.formatString_ = str
    return self
end

function NumberRoller:setFormatHandler(handler)
    if not handler then
        return self
    end
    self.format_handler = handler
    return self
end

-- 滚动数字的方法
function NumberRoller:run(label, from, to)
    local from = from or 0
    local to = to or 0
    if not label then
        return
    end
    local ret = self:calcNumberTable_(from, to)
    if not ret or #ret < 1 then
        return
    end
    
    local actions = {}
    for i = 1, #ret do
        local tmp = cc.CallFunc:create(function()
            label:setString(string.format(self.formatString_, self.format_handler(ret[i])))
        end)
        table.insert(actions, tmp)
        table.insert(actions, cc.DelayTime:create(self.step_time))
    end
    transition.stopTarget(label)
    label:runAction(transition.sequence(actions))
end

return NumberRoller
