local CreateNNView = import(".CreateNNView")
local CreateYiYangNiuNiuView = class("CreateYiYangNiuNiuView", CreateNNView)

function CreateYiYangNiuNiuView:ctor()
    CreateYiYangNiuNiuView.super.ctor(self)
    -- self.renShu1_:hide()
    self.renShu2_:hide()
    self.renShu3_:hide()
    self.lable8_:hide()
    self.lable10_:hide()
    self.tui10_:hide()
    self.tuiZhu2_:hide()
    self.teShuLable1_:setString("顺子牛x5，五花牛x5，葫芦牛x7，炸弹牛x8")
    self.teShuLable2_:setString("五小牛x10，五大牛x10，同花顺x10")
    createRoomData:setGameIndex(GAME_YIYANG_NIUNIU)
end

function CreateYiYangNiuNiuView:calcCreateRoomParams(daiKai)
    local ipLimit = 0
    local guiZe = {}
    guiZe.playerCount = self.renShu_
    guiZe.zhuangType = self.zhuangType_
    guiZe.score = self.xiaZhu_
    guiZe.tuiZhu = self.tuiZhu_
    guiZe.maxQiang = self.beiType_
    guiZe.specType = self.specType_
    guiZe.detailType = 2
    local params = {
        gameType = GAME_BCNIUNIU, -- 游戏服务类型
        totalRound = self.juShu_, -- 游戏局数
        isAgent = 0,  -- 代开 0为否 1为是
        ipLimit = 0,  -- 是否禁止相同IP入坐，1为禁止，0为不禁止
        ruleType = 1,  -- 游戏小规则类型 默认为1, 可由不同游戏自己定义
        ruleDetails = guiZe -- 任意定义的规则选项, 参考下面的各游戏详细规则说明 -- 规则详情
    }
    return params
end

return CreateYiYangNiuNiuView 
