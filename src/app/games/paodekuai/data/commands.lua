-- 上行命令列表, key 与 value 均不能重复
PDK_COMMANDS = {
    PDK_ENTER_ROOM = 2101,  -- 进入房间
    PDK_LEAVE_ROOM = 2102,  -- 退出房间
    PDK_ROOM_INFO = 2103,  -- 房间配置数据
    PDK_PLAYER_ENTER_ROOM = 2104,  -- 玩家进入房间
    PDK_OWNER_DISMISS = 2105, -- 房主解散房间

    PDK_GAME_START = 2106,  -- 游戏开始
    PDK_GAME_OVER = 2107,  -- 游戏结束

    PDK_ROUND_START = 2108,  -- 一局开始
    PDK_ROUND_OVER = 2109,  -- 一局结束
    PDK_REQUEST_DISMISS = 2110,  -- 申请解散房间

    PDK_READY = 2111,
    PDK_TURN_TO = 2112,  -- 轮到某人
    PDK_CHU_PAI = 2113,  -- 出牌
    PDK_PLAYER_PASS = 2114,  -- 过

    PDK_TURN_START = 2115,  -- 一轮开始
    PDK_TURN_END = 2116,  -- 一轮结束
    PDK_XUAN_PAI = 2117,  -- 选牌命令

    PDK_DEAL_CARD = 2118,  -- 发牌
    PDK_ROUND_FLOW = 2123,  -- 游戏流程通知
    PDK_ONLINE_STATE = 2124,  -- 在线事件广播   在线 离线
    PDK_ZHA_DAN_DE_FEN = 2122,  -- 在线事件广播   在线 离线
    PDK_BROADCAST = 2125,  -- 客户端请求房间内广播

    PDK_KICK = 2143, -- 踢人的回应
    PDK_CHECK_CHOU_JIANG = 2130, -- 通知抽奖
    PDK_CHOU_JIANG = 2131, -- 抽奖 
    PDK_CLUB_DISMISSROOM = 2183, -- 抽奖 

    PDK_NOTIFY_LOCATION = 2177, 
    PDK_REQUEST_LOCATION = 2178,
}

-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性
local function reverseCommands(source)
    local result = {}
    for k,v in pairs(source) do
        assert(result[v] == nil)
        result[v] = k
    end
    return result
end

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, PDK_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))
