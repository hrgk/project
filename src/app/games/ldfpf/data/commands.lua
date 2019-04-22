-- 上行命令列表, key 与 value 均不能重复
local LDFPF_COMMANDS = {
	LDFPF_ENTER_ROOM = 4201,  -- 进入房间
	LDFPF_LEAVE_ROOM = 4202,  -- 退出房间
	LDFPF_ROOM_INFO = 4203,  -- 房间配置数据
	LDFPF_PLAYER_ENTER_ROOM = 4204,  -- 玩家进入房间
	LDFPF_OWNER_DISMISS = 4205, -- 房主解散房间
	LDFPF_GAME_START = 4206,  -- 游戏开始
	LDFPF_GAME_OVER = 4207,  -- 游戏结束
	LDFPF_ROUND_START = 4208,  -- 一局开始
	LDFPF_ROUND_OVER = 4209,  -- 一局结束
	LDFPF_REQUEST_DISMISS = 4210,  -- 申请解散房间
	LDFPF_READY = 4211,
	LDFPF_UNREADY = 4281,
	LDFPF_TURN_TO = 4212,  -- 轮到某人
	LDFPF_CHU_PAI = 4213,  -- 出牌
	LDFPF_PLAYER_PASS = 4214,  -- 过
	LDFPF_TIAN_HU_START = 4215 , --天胡时间到
	LDFPF_TIAN_HU_END = 4216 , --天胡结束
	LDFPF_USER_TI = 4217 , --玩家提牌
	LDFPF_DEAL_CARD = 4218, -- 发牌 
	LDFPF_USER_WEI = 4219 , --玩家偎牌
	LDFPF_USER_MO_PAI = 4220 , -- 玩家摸牌公示
	LDFPF_USER_PAO = 4221 , --玩家跑牌
	LDFPF_USER_PENG = 4222 , -- 碰
	LDFPF_USER_CHI = 4223 , -- 吃 
	LDFPF_ALL_PASS = 4228 , -- 所有人都过牌
	LDFPF_ONLINE_STATE = 4224,  -- 在线事件广播   在线 离线
	LDFPF_BROADCAST = 4225,  -- 客户端请求房间内广播
	LDFPF_USER_HU = 4226 ,-- 胡牌 
	LDFPF_NOTIFY_HU = 4227 ,-- 通知玩家选择是否胡牌
	LDFPF_DEBUG_CONFIG_CARD = 4229,  -- 调试设牌命令
	LDFPF_FIRST_HAND_TI = 4230,  -- 起手提
	LDFPF_NOTIFY_LOCATION = 4231,  -- 通知位置
	LDFPF_REQUEST_LOCATION = 4232,  -- 通知位置
	LDFPF_HU_PASS = 4233,  -- 胡德时候过
	LDFPF_QI_PAI = 4240,	--弃牌
	LDFPF_CLUB_DISMISSROOM = 4283, -- 抽奖 
    LDFPF_CONFIRM_DA_NIAO = 4241, --确认打鸟
}

T_IN_IDLE = 0  --# 无状态
T_IN_TIAN_HU = 1  --# 天胡中
T_IN_CHU_PAI = 2  --# 在出牌中
T_IN_CHU_PAI_CALL = 3  --# 在出牌后的呼叫中
T_IN_MO_PAI = 4  --# 在摸牌中 暗(未公示)
T_IN_MO_PAI_CALL = 5  --# 在摸牌后的呼叫中
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, LDFPF_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))


