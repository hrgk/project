local TaskQueue = {}

local instance_ = nil
local queue_ = gailun.JWQueue.new()
local inRunning_ = false
local target_ = nil
local nowTask = nil

function TaskQueue.init(target)
    assert(target_ == nil)
    assert(target and type(target.performWithDelay) == "function", "target must has performWithDelay function.")
    assert(queue_:length() == 0)
    target_ = target
end

function TaskQueue.add(task, delaySeconds, afterSeconds, ...)
    assert(type(task) == "function", "task must be function.")
    assert(target_ ~= nil, "must call init to set target!")
    local delaySeconds = delaySeconds or 0
    local afterSeconds = afterSeconds or 0
    local traceback = debug.traceback()
    queue_:push({
        task = task,
        delay = delaySeconds,
        after = afterSeconds,
        params = {...},
        traceback = traceback,
        isRun = false
    })
    
    if nowTask == nil then
        TaskQueue.updateNowTask()
    end
end

function TaskQueue.check()
    if tolua.isnull(target_) then
        TaskQueue.clear()
        return false
    end

    return true
end

function TaskQueue.ticket(nowTime, interval)
    if not TaskQueue.check() then
        return
    end
    if nowTask == nil then
        return
    end

    if nowTask.isRun then
        if nowTask.after == -1 then
            return
        end

        if nowTask.after < interval then
            return TaskQueue.updateNowTask()
        else
            nowTask.after = nowTask.after - interval
            return
        end
    else
        if nowTask.delay == -1 then
            return
        end

        if nowTask.delay < interval then
            nowTask.isRun = true
            TaskQueue.doTask_(nowTask.task, nowTask.params)

            -- 如果after为0，则立即刷新Task
            if nowTask.after == 0 then
                return TaskQueue.updateNowTask()
            end
        else
            nowTask.delay = nowTask.delay - interval
            return
        end
    end
end

function TaskQueue.updateNowTask()
    if TaskQueue.getTaskLength() == 0 then
        nowTask = nil
        return
    end

    nowTask = unpack(queue_:pop())
    -- 如果当前延迟和延后都为0，则立即执行Task
    if nowTask.delay == 0 and nowTask.after == 0 then
        nowTask.isRun = true
        TaskQueue.doTask_(nowTask.task, nowTask.params)
        return TaskQueue.updateNowTask()
    end
end

function TaskQueue.getTaskLength()
    return queue_:length()
end

function TaskQueue.getQueueTrackback()
    dump(nowTask)
    local queueList = queue_:getQueue()
    for i = 1, TaskQueue.getTaskLength() do
        dump(queueList[i])
    end
end

function TaskQueue.removeAll()
    nowTask = nil
    queue_:clear()
end

function TaskQueue.clear()
    TaskQueue.removeAll()
    target_ = nil
end

function TaskQueue.continue()
    if nowTask == nil then
        return
    end

    if nowTask.isRun then
        nowTask.after = 0
    else
        nowTask.delay = 0
    end
end

function TaskQueue.doTask_(task, params)
    -- task(unpack(params))
    local ok, err = pcall(task, unpack(params))
    if not ok then
        printError(err)
        if buglyReportLuaException ~= nil then
            buglyReportLuaException("TaskQueue:" .. err, params[5])
        end
    end
end

return TaskQueue
