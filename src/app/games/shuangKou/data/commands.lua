-- 上行命令列表, key 与 value 均不能重复
SHUANGKOU_COMMANDS = {
    SHUANGKOU_ENTER_ROOM = 3201,  -- 进入房间
    SHUANGKOU_LEAVE_ROOM = 3202,  -- 退出房间
    SHUANGKOU_ROOM_INFO = 3203,  -- 房间配置数据
    SHUANGKOU_PLAYER_ENTER_ROOM = 3204,  -- 玩家进入房间
    SHUANGKOU_OWNER_DISMISS = 3205, -- 房主解散房间
    SHUANGKOU_GAME_START = 3206,  -- 游戏开始
    SHUANGKOU_GAME_OVER = 3207,  -- 游戏结束
    SHUANGKOU_ROUND_START = 3208,  -- 一局开始
    SHUANGKOU_ROUND_OVER = 3209,  -- 一局结束
    SHUANGKOU_REQUEST_DISMISS = 3210,  -- 申请解散房间
    SHUANGKOU_READY = 3211,
    SHUANGKOU_TURN_TO = 3212,  -- 轮到某人
    SHUANGKOU_CHU_PAI = 3213,  -- 出牌
    SHUANGKOU_PLAYER_PASS = 3214,  -- 过
    SHUANGKOU_TURN_START = 3215,  -- 一轮开始
    SHUANGKOU_TURN_END = 3216,  -- 一轮结束
    SHUANGKOU_DEAL_CARD = 3218,  -- 发牌
    SHUANGKOU_ROUND_FLOW = 3223,  -- 游戏流程通知
    SHUANGKOU_ONLINE_STATE = 3224,  -- 在线事件广播   在线 离线
    SHUANGKOU_CONTRIBUTION_DE_FEN = 3222,  -- 炸弹等分
    SHUANGKOU_GAME_BROADCAST = 3225,  -- 客户端请求房间内广播
    SHUANGKOU_KICK = 3243, -- 踢人的回应
    SHUANGKOU_GET_PLAYER_CARDS = 3226, -- 踢人的回应
    SHUANGKOU_CHECK_CHOU_JIANG = 3230, -- 通知抽奖
    SHUANGKOU_CHOU_JIANG = 3231, -- 抽奖
    SHUANGKOU_NOTIFY_LOCATION = 3277,
    SHUANGKOU_REQUEST_LOCATION = 3278,
}

-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性
local function reverseCommands(source)
    local result = {}
    for k,v in pairs(source) do
        assert(result[v] == nil, v)
        result[v] = k
    end
    return result
end

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, SHUANGKOU_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))
