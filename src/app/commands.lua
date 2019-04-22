-- 上行命令列表, key 与 value 均不能重复
COMMANDS = {
    HEART_BEAT = 101,
    KEEP_ALIVE = 104,  -- 服务端消息
    CHANGE_SERVER = 105,  -- 换服接口
    LOGIN = 201,
    ENTER_ROOM = 202,  -- 进入房间
    KICK = 43, -- 踢人的回应】
    ALL_BROADCAST = 107, -- 广播消息
    PLAYER_ONLINE_STATE = 168,
}

-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性
function reverseCommands(source)
    local result = {}
    for k,v in pairs(source) do
        assert(result[v] == nil)
        result[v] = k
    end
    return result
end

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))
