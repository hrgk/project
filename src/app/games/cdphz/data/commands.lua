-- 上行命令列表, key 与 value 均不能重复
local CDPHZ_COMMANDS = {
	CDPHZ_ENTER_ROOM = 801,  -- 进入房间
	CDPHZ_LEAVE_ROOM = 802,  -- 退出房间
	CDPHZ_ROOM_INFO = 803,  -- 房间配置数据
	CDPHZ_PLAYER_ENTER_ROOM = 804,  -- 玩家进入房间
	CDPHZ_OWNER_DISMISS = 805, -- 房主解散房间
	CDPHZ_GAME_START = 806,  -- 游戏开始
	CDPHZ_GAME_OVER = 807,  -- 游戏结束
	CDPHZ_ROUND_START = 808,  -- 一局开始
	CDPHZ_ROUND_OVER = 809,  -- 一局结束
	CDPHZ_REQUEST_DISMISS = 810,  -- 申请解散房间
	CDPHZ_READY = 811,
	CDPHZ_UNREADY = 881,
	CDPHZ_TURN_TO = 812,  -- 轮到某人
	CDPHZ_CHU_PAI = 813,  -- 出牌
	CDPHZ_PLAYER_PASS = 814,  -- 过
	CDPHZ_TIAN_HU_START = 815 , --天胡时间到
	CDPHZ_TIAN_HU_END = 816 , --天胡结束
	CDPHZ_USER_TI = 817 , --玩家提牌
	CDPHZ_DEAL_CARD = 818, -- 发牌 
	CDPHZ_USER_WEI = 819 , --玩家偎牌
	CDPHZ_USER_MO_PAI = 820 , -- 玩家摸牌公示
	CDPHZ_USER_PAO = 821 , --玩家跑牌
	CDPHZ_USER_PENG = 822 , -- 碰
	CDPHZ_USER_CHI = 823 , -- 吃 
	CDPHZ_ALL_PASS = 828 , -- 所有人都过牌
	CDPHZ_ONLINE_STATE = 824,  -- 在线事件广播   在线 离线
	CDPHZ_BROADCAST = 825,  -- 客户端请求房间内广播
	CDPHZ_USER_HU = 826 ,-- 胡牌 
	CDPHZ_NOTIFY_HU = 827 ,-- 通知玩家选择是否胡牌
	CDPHZ_DEBUG_CONFIG_CARD = 829,  -- 调试设牌命令
	CDPHZ_FIRST_HAND_TI = 830,  -- 起手提
	CDPHZ_NOTIFY_LOCATION = 831,  -- 通知位置
	CDPHZ_REQUEST_LOCATION = 832,  -- 通知位置
	CDPHZ_HU_PASS = 833,  -- 胡德时候过
	CDPHZ_CLUB_DISMISSROOM = 883, -- 抽奖 
}

T_IN_IDLE = 0  --# 无状态
T_IN_TIAN_HU = 1  --# 天胡中
T_IN_CHU_PAI = 2  --# 在出牌中
T_IN_CHU_PAI_CALL = 3  --# 在出牌后的呼叫中
T_IN_MO_PAI = 4  --# 在摸牌中 暗(未公示)
T_IN_MO_PAI_CALL = 5  --# 在摸牌后的呼叫中
-- 反转命令列表得到的命令的字符串列表，反转时要保证命令的唯一性

COMMANDS = COMMANDS or {}
table.merge(COMMANDS, CDPHZ_COMMANDS)

COMMAND_NAMES = COMMAND_NAMES or {}
table.merge(COMMAND_NAMES, reverseCommands(COMMANDS))


