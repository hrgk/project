-- 上行命令列表, key 与 value 均不能重复
local YZCHZ_COMMANDS = {
	YZCHZ_ENTER_ROOM = 3401,  -- 进入房间
	YZCHZ_LEAVE_ROOM = 3402,  -- 退出房间
	YZCHZ_ROOM_INFO = 3403,  -- 房间配置数据
	YZCHZ_PLAYER_ENTER_ROOM = 3404,  -- 玩家进入房间
	YZCHZ_OWNER_DISMISS = 3405, -- 房主解散房间
	YZCHZ_GAME_START = 3406,  -- 游戏开始
	YZCHZ_GAME_OVER = 3407,  -- 游戏结束
	YZCHZ_ROUND_START = 3408,  -- 一局开始
	YZCHZ_ROUND_OVER = 3409,  -- 一局结束
	YZCHZ_REQUEST_DISMISS = 3410,  -- 申请解散房间
	YZCHZ_READY = 3411,
	YZCHZ_TURN_TO = 3412,  -- 轮到某人
	YZCHZ_CHU_PAI = 3413,  -- 出牌
	YZCHZ_PLAYER_PASS = 3414,  -- 过
	YZCHZ_TIAN_HU_START = 3415 , --天胡时间到
	YZCHZ_TIAN_HU_END = 3416 , --天胡结束
	YZCHZ_USER_TI = 3417 , --玩家提牌
	YZCHZ_DEAL_CARD = 3418, -- 发牌 
	YZCHZ_USER_WEI = 3419 , --玩家偎牌
	YZCHZ_USER_MO_PAI = 3420 , -- 玩家摸牌公示
	YZCHZ_USER_PAO = 3421 , --玩家跑牌
	YZCHZ_USER_PENG = 3422 , -- 碰
	YZCHZ_USER_CHI = 3423 , -- 吃 
	YZCHZ_ALL_PASS = 3428 , -- 所有人都过牌
	YZCHZ_ONLINE_STATE = 3424,  -- 在线事件广播   在线 离线
	YZCHZ_BROADCAST = 3425,  -- 客户端请求房间内广播
	YZCHZ_USER_HU = 3426 ,-- 胡牌 
	YZCHZ_NOTIFY_HU = 3427 ,-- 通知玩家选择是否胡牌
	YZCHZ_DEBUG_CONFIG_CARD = 3429,  -- 调试设牌命令
	YZCHZ_FIRST_HAND_TI = 3430,  -- 起手提
	YZCHZ_NOTIFY_LOCATION = 3431,  -- 通知位置
	YZCHZ_REQUEST_LOCATION = 3432,  -- 通知位置
	YZCHZ_HU_PASS = 3433,  -- 胡德时候过
	YZCHZ_CLUB_DISMISSROOM = 3483, -- 抽奖 
	YZCHZ_USER_SI_SHOU = 3440,  -- 死手
}

T_IN_IDLE = 0  --# 无状态
T_IN_TIAN_HU = 1  --# 天胡中
T_IN_CHU_PAI = 2  --# 在出牌中
T_IN_CHU_PAI_CALL = 3  --# 在出牌后的呼叫中
T_IN_MO_PAI = 4  --# 在摸牌中 暗(未公示)
T_IN_MO_PAI_CALL = 5  --# 在摸牌后的呼叫中
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性
COMMANDS = COMMANDS or {}
table.merge(COMMANDS, YZCHZ_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))


