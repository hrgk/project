-- 上行命令列表, key 与 value 均不能重复
ZMZ_COMMANDS = {
    ZMZ_ENTER_ROOM = 3901,  -- 进入房间
    ZMZ_LEAVE_ROOM = 3902,  -- 退出房间
    ZMZ_ROOM_INFO = 3903,  -- 房间配置数据
    ZMZ_PLAYER_ENTER_ROOM = 3904,  -- 玩家进入房间
    ZMZ_OWNER_DISMISS = 3905, -- 房主解散房间

    ZMZ_GAME_START = 3906,  -- 游戏开始
    ZMZ_GAME_OVER = 3907,  -- 游戏结束

    ZMZ_ROUND_START = 3908,  -- 一局开始
    ZMZ_ROUND_OVER = 3909,  -- 一局结束
    ZMZ_REQUEST_DISMISS = 3910,  -- 申请解散房间

    ZMZ_READY = 3911,
    ZMZ_TURN_TO = 3912,  -- 轮到某人
    ZMZ_CHU_PAI = 3913,  -- 出牌
    ZMZ_PLAYER_PASS = 3914,  -- 过

    ZMZ_TURN_START = 3915,  -- 一轮开始
    ZMZ_TURN_END = 3916,  -- 一轮结束
    ZMZ_XUAN_PAI = 3917,  -- 选牌命令

    ZMZ_DEAL_CARD = 3918,  -- 发牌
    ZMZ_ROUND_FLOW = 3923,  -- 游戏流程通知
    ZMZ_ONLINE_STATE = 3924,  -- 在线事件广播   在线 离线
    ZMZ_ZHA_DAN_DE_FEN = 3922,  -- 在线事件广播   在线 离线
    ZMZ_BROADCAST = 3925,  -- 客户端请求房间内广播

    ZMZ_KICK = 3943, -- 踢人的回应
    ZMZ_CHECK_CHOU_JIANG = 3930, -- 通知抽奖
    ZMZ_CHOU_JIANG = 3931, -- 抽奖 
    ZMZ_CLUB_DISMISSROOM = 3983, -- 抽奖 

    ZMZ_NOTIFY_LOCATION = 3977, 
    ZMZ_REQUEST_LOCATION = 3978,
    ZMZ_TUO_GUAN = 3993, --托管
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
table.merge(COMMANDS, ZMZ_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))
