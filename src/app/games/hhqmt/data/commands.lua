-- 上行命令列表, key 与 value 均不能重复
local HHQMT_COMMANDS = {
	HHQMT_ENTER_ROOM = 4001,  -- 进入房间
	HHQMT_LEAVE_ROOM = 4002,  -- 退出房间
	HHQMT_ROOM_INFO = 4003,  -- 房间配置数据
	HHQMT_PLAYER_ENTER_ROOM = 4004,  -- 玩家进入房间
	HHQMT_OWNER_DISMISS = 4005, -- 房主解散房间
	HHQMT_GAME_START = 4006,  -- 游戏开始
	HHQMT_GAME_OVER = 4007,  -- 游戏结束
	HHQMT_ROUND_START = 4008,  -- 一局开始
	HHQMT_ROUND_OVER = 4009,  -- 一局结束
	HHQMT_REQUEST_DISMISS = 4010,  -- 申请解散房间
	HHQMT_READY = 4011,
	HHQMT_UNREADY = 4081,
	HHQMT_TURN_TO = 4012,  -- 轮到某人
	HHQMT_CHU_PAI = 4013,  -- 出牌
	HHQMT_PLAYER_PASS = 4014,  -- 过
	HHQMT_TIAN_HU_START = 4015 , --天胡时间到
	HHQMT_TIAN_HU_END = 4016 , --天胡结束
	HHQMT_USER_TI = 4017 , --玩家提牌
	HHQMT_DEAL_CARD = 4018, -- 发牌 
	HHQMT_USER_WEI = 4019 , --玩家偎牌
	HHQMT_USER_MO_PAI = 4020 , -- 玩家摸牌公示
	HHQMT_USER_PAO = 4021 , --玩家跑牌
	HHQMT_USER_PENG = 4022 , -- 碰
	HHQMT_USER_CHI = 4023 , -- 吃 
	HHQMT_ALL_PASS = 4028 , -- 所有人都过牌
	HHQMT_ONLINE_STATE = 4024,  -- 在线事件广播   在线 离线
	HHQMT_BROADCAST = 4025,  -- 客户端请求房间内广播
	HHQMT_USER_HU = 4026 ,-- 胡牌 
	HHQMT_NOTIFY_HU = 4027 ,-- 通知玩家选择是否胡牌
	HHQMT_DEBUG_CONFIG_CARD = 4029,  -- 调试设牌命令
	HHQMT_FIRST_HAND_TI = 4030,  -- 起手提
	HHQMT_NOTIFY_LOCATION = 4031,  -- 通知位置
	HHQMT_REQUEST_LOCATION = 4032,  -- 通知位置
	HHQMT_HU_PASS = 4033,  -- 胡德时候过
	HHQMT_CLUB_DISMISSROOM = 4083, -- 抽奖 
}

T_IN_IDLE = 0  --# 无状态
T_IN_TIAN_HU = 1  --# 天胡中
T_IN_CHU_PAI = 2  --# 在出牌中
T_IN_CHU_PAI_CALL = 3  --# 在出牌后的呼叫中
T_IN_MO_PAI = 4  --# 在摸牌中 暗(未公示)
T_IN_MO_PAI_CALL = 5  --# 在摸牌后的呼叫中
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, HHQMT_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))


