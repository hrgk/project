-- 上行命令列表, key 与 value 均不能重复
DTZ_COMMANDS = {
    DTZ_ENTER_ROOM = 2201,  -- 进入房间
    DTZ_LEAVE_ROOM = 2202,  -- 退出房间
    DTZ_ROOM_INFO = 2203,  -- 房间配置数据
    DTZ_PLAYER_ENTER_ROOM = 2204,  -- 玩家进入房间
    DTZ_OWNER_DISMISS = 2205, -- 房主解散房间
    DTZ_GAME_START = 2206,  -- 游戏开始
    DTZ_GAME_OVER = 2207,  -- 游戏结束
    DTZ_ROUND_START = 2208,  -- 一局开始
    DTZ_ROUND_OVER = 2209,  -- 一局结束
    DTZ_REQUEST_DISMISS = 2210,  -- 申请解散房间
    DTZ_READY = 2211,
    DTZ_TURN_TO = 2212,  -- 轮到某人
    DTZ_CHU_PAI = 2213,  -- 出牌
    DTZ_PLAYER_PASS = 2214,  -- 过
    DTZ_TURN_START = 2215,  -- 一轮开始
    DTZ_TURN_END = 2216,  -- 一轮结束
    DTZ_DEAL_CARD = 2218,  -- 发牌
    DTZ_ROUND_FLOW = 2223,  -- 游戏流程通知
    DTZ_ONLINE_STATE = 2224,  -- 在线事件广播   在线 离线
    DTZ_ZHA_DAN_DE_FEN = 2222,  -- 炸弹等分
    DTZ_GAME_BROADCAST = 2225,  -- 客户端请求房间内广播
    DTZ_KICK = 2243, -- 踢人的回应
    DTZ_CHECK_CHOU_JIANG = 2230, -- 通知抽奖
    DTZ_CHOU_JIANG = 2231, -- 抽奖
    DTZ_NOTIFY_LOCATION = 2277,
    DTZ_REQUEST_LOCATION = 2278,
    DTZ_CLUB_DISMISSROOM = 2283, -- 抽奖 
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
table.merge(COMMANDS, DTZ_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))
