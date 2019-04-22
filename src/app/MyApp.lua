require("app.init")
local zip = require("zlib")   
local v,mv,pv=zip.version()
print(v .. "  " .. mv .. "  " .. pv)
HttpApi = require("app.utils.HttpApi")

local MyApp = class("MyApp", cc.mvc.AppBase)

dataCenter = nil -- 数据中心的全局实例
gameAudio = nil -- 音乐模块
gameConfig = nil -- 配置模块
gameCache  = nil -- 缓存模块

MyApp.BACK_GROUND_EVENT = "BACK_GROUND_EVENT"

function MyApp:ctor()
    MyApp.super.ctor(self)
    math.newrandomseed()
    cc.Director:getInstance():setAnimationInterval(1 / (CONFIG_FPS_NUMBERS or 30))
    self:init_()
    -- self:testSproto()
end

function MyApp:init_()
    if dataCenter then return end
    assert(dataCenter == nil)  -- 不允许多次创建
    assert(gameAudio == nil)
    assert(gameConfig == nil)
    assert(gameCache == nil)
    assert(gameAnim == nil)
    dataCenter = require("app.models.DataCenter").new()
    gameAnim = require("app.utils.GameAnimation")
    gameAudio = require("app.utils.GameAudio")
    httpMessage = require("app.utils.HttpMessage")
    gameConfig = gailun.LocalStorage.new(DATA_PATH, CONFIG_FILE_NAME, true, nil):setDefaults(DEFAULT_CONFIGS)
    gameCache = gailun.DiskCache.new(DATA_PATH, CACHE_FILE_NAME, true, nil):setDefaults({})
    
    self:initConfig_()
    self:initAudio_()

    gailun.native.weChatInit("wx9d7bdec129fef3d1", "乐途互娱")
    self.path = gailun.native.getSDCardPath() .. "/aaa.aac"
    gailun.native.initRecorder(self.path, 10)
    dataCenter:IAPInit()
end

-- 这里hack掉了系统默认的音效播放函数
function MyApp:initAudio_()
    local realPlay = audio.playSound
    audio.playSound = function (filename, isLoop)
        if gameConfig:get(CONFIG_SOUND_ON) then
            realPlay(filename, isLoop)
        end
    end

    if DEFAULT_CLICK_SOUND then  -- 设置全部音效的默认点击
        gailun.uihelper.setDefaultSoundEffect(DEFAULT_CLICK_SOUND)
        audio.preloadSound(DEFAULT_CLICK_SOUND)
    end
end

function MyApp:initConfig_()
    assert(gameConfig and gameAudio)
    local soundVolume = gameConfig:get(CONFIG_SOUND_VOLUME)
    local musicVolume = gameConfig:get(CONFIG_MUSIC_VOLUME)
    gameAudio.setMusicVolume(musicVolume)
    gameAudio.setSoundsVolume(soundVolume)
    StaticConfig:loadConfig()
end

function MyApp:run()

    -- display.addSpriteFrames("textures/actions.plist", "textures/actions.png")
    -- display.addSpriteFrames("textures/game_face.plist", "textures/game_face.png")
    -- display.addSpriteFrames("textures/game_anims.plist", "textures/game_anims.png")
    -- display.addSpriteFrames("textures/majiang.plist", "textures/majiang.png")
    -- display.addSpriteFrames("textures/pokers.plist", "textures/pokers.png")
    -- display.addSpriteFrames("textures/paper_cards.plist", "textures/paper_cards.png")
    -- HttpApi.download(url, filename, sucFunc, failFunc, 30, progressFunc)
    display.newSprite("res/images/common/bg3.png")
    display.newSprite("animations/coscosjiazai2/coscosjiazai20.png")
    self:enterScene("LoadScene")
    self:initSoundState_()
    self:initMusicState_()
end

function MyApp:initSoundState_()
    if tonumber(setData:getSoundIsCLose()) == 1 then
        gameAudio.setSoundsVolume(0)
    else
        gameAudio.setSoundsVolume(tonumber(setData:getSoundState())/100)
    end
end

function MyApp:initMusicState_()
    if tonumber(setData:getMusicIsCLose()) == 1 then
        gameAudio.setMusicVolume(0)
    else
        gameAudio.setMusicVolume(tonumber(setData:getMusicState())/100)
    end
end

function MyApp:enterLoadScene()
    self:enterScene("LoadScene", nil)--, 'fade', 0.5)
end

function MyApp:enterMallScene()
    self:enterScene("MallScene")--, 'fade', 0.5)
end

function MyApp:enterHallScene()
    -- dataCenter:setCurGammeType(GAME_DEFAULT)
    -- local area = dataCenter:getCurGammeArea()
    -- local areaHallScene = GAME_AREAS_HALLSCENE[area] or GAME_AREAS_HALLSCENE[GAME_AREA_DEFAULT]
    self:enterScene("DaTingScene", nil)--, 'fade', 0.5)
end

function MyApp:enterBoxScene()
    -- dataCenter:setCurGammeType(GAME_DEFAULT)
    self:enterScene("BoxScene", nil)--, 'fade', 0.5)
end

function MyApp:enterGameScene(gameType,totalSeats)
    local gType = gameType
    local name = GAMES_PACKAGENAME[gType]
    self:setConcretePackageName(name, gType)
    local GameSceneType = "GameScene"
    if (gType == GAME_MJZHUANZHUAN or gType == GAME_MJHONGZHONG or gType == GAME_HSMJ or gType == GAME_FHHZMJ) and setData:getMJHMTYPE()+0  == 1 then
        GameSceneType = "Game2DScene"
    end
    print("GameSceneType",GameSceneType)
    self:enterConcreteScene(GameSceneType,totalSeats, nil)
end

function MyApp:enterReviewScene(gameType, arg)
    local name = GAMES_PACKAGENAME[gameType]
    self:setConcretePackageName(name, gameType)
    local scene = self:createNewScene("ReviewScene", arg)
    cc.Director:getInstance():pushScene(scene)
end

function MyApp:popScene()
    cc.Director:getInstance():popScene()
end

function MyApp:enterLoginScene()
    self:enterScene("LoginScene", nil)--, 'fade', 0.5)
end

function MyApp:enterActivityScene()
    self:enterScene("ActivityScene", nil)--, 'fade', 0.5)
end

function MyApp:alert(...)
    local str = {...}
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if string.find(str[1], "钻石不足") ~= nil then
        app:confirm(str[1], function (isOK)
            if not isOK then
                return
            end
            if scene.shopHandler_ then
                scene:shopHandler_()
            end
        end)
        return
    else
        if self.alertWindow_ and not tolua.isnull(self.alertWindow_) then
            self.alertWindow_:removeFromParent()
            self.alertWindow_ = nil
        end
        self.alertWindow_ = self:createView("AlertWindow", ...):addTo(scene,100)
        self.alertWindow_:tanChuang(150)
    end
end

function MyApp:confirm(...)
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if self.confirmWindow_ and not tolua.isnull(self.confirmWindow_) then
        self.confirmWindow_:removeFromParent()
        self.confirmWindow_ = nil
    end
    self.confirmWindow_ = self:createView("ConfirmWindow", ...):addTo(scene,999)
    self.confirmWindow_:tanChuang(150)
end

function MyApp:confirmNotQuick(...)
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if self.confirmWindow_ and not tolua.isnull(self.confirmWindow_) then
        self.confirmWindow_:removeFromParent()
        self.confirmWindow_ = nil
    end
    self.confirmWindow_ = self:createView("ConfirmWindowNotQuick", ...):addTo(scene)
end

function MyApp:clearLoading()
    if self.loadingView_ and not tolua.isnull(self.loadingView_) then
        self.loadingView_:removeFromParent()
        self.loadingView_ = nil
    end
end

function MyApp:showLoading(...)
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    self:clearLoading()
    self.loadingView_ = self:createView("LoadingView", ...):addTo(scene)
end

function MyApp:showTips(...)
    local str = {...}
    local scene = display.getRunningScene()
    if not scene then
        return
    end
    if string.find(str[1], "钻石不足") ~= nil then
        app:confirm(str[1], function (isOK)
            if not isOK then
                return
            end
            if scene.shopHandler_ then
                scene:shopHandler_()
            end
        end)
        return
    else
        self:createView("TipsView", ...):addTo(scene,1001)
    end
end

function MyApp:onEnterBackground()
    local data = {}
    data.offline = 1 
    dataCenter:sendOverSocket(COMMANDS.PLAYER_ONLINE_STATE, data)
    self:dispatchEvent({name = MyApp.BACK_GROUND_EVENT, isBackground = true})
    display.pause()
end

function MyApp:onEnterForeground()
    local data = {}
    data.offline = 0 
    dataCenter:sendOverSocket(COMMANDS.PLAYER_ONLINE_STATE, data)
    self:dispatchEvent({name = MyApp.BACK_GROUND_EVENT, isBackground = false})
    display.resume()
    app:initMusicState_()

    if selfData:getUid() ~= 0 then
        dataCenter:heartBeat()
        logger.Debug("selfData:getUid()",selfData:getUid())
        dataCenter:checkUpdate()

        -- 加入房间判断
        display.getRunningScene():checkRoom()

        local scene = display.getRunningScene()
        if scene and scene.updateDiamonds then
            scene:updateDiamonds()
        end
    end
end

function MyApp:createGrid(scene)
    -- display.newColorLayer(cc.c4b(255, 255, 255, 255)):addTo(scene)
    for y = display.bottom, display.top, 40 do
        display.newLine(
            {{display.left, y}, {display.right, y}},
            {borderColor = cc.c4f(0.9, 0.9, 0.9, 0.8)})
        :addTo(scene)
    end

    for x = display.left, display.right, 40 do
        display.newLine(
            {{x, display.top}, {x, display.bottom}},
            {borderColor = cc.c4f(0.9, 0.9, 0.9, 0.8)})
        :addTo(scene)
    end

    display.newLine(
        {{display.left, display.cy + 1}, {display.right, display.cy + 1}},
        {borderColor = cc.c4f(1.0, 0.75, 0.75, 0.8)})
    :addTo(scene)

    display.newLine(
        {{display.cx, display.top}, {display.cx, display.bottom}},
        {borderColor = cc.c4f(1.0, 0.75, 0.75, 0.8)})
    :addTo(scene)
end

function MyApp:soundPath()
    return self.path
end

-- function MyApp:testSproto()
--     local zip = require("zlib")
--     local v,mv,pv=zip.version()
--     print(v.."  "..mv.."  "..pv)
--     local t = {1,2,3,a=3,b=4,c=5}
--     local data = gailun.utils.zip(json.encode(t))
--     print("========== string len: ", string.len(data))
--     print(gailun.utils.unzip(data))
-- end

function MyApp:setConcretePackageName(concretePackageName, gameType)
    self.concretePackageName_ = concretePackageName or ""
    if  gameType then
        dataCenter:setCurGammeType(gameType)
    end
end

function MyApp:enterConcreteScene(sceneName,totalSeats,args, transitionType, time, more)
    local scenePackageName = self.packageRoot .. self.concretePackageName_ .. ".scenes." .. sceneName
    local a = require("app.games.sybp.scenes.GameScene")
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)),totalSeats)
    display.replaceScene(scene, transitionType, time, more)
end

function MyApp:createNewScene(sceneName, args, transitionType, time, more)
    local scenePackageName = self.packageRoot .. self.concretePackageName_ .. ".scenes." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    -- display.replaceScene(scene, transitionType, time, more)
    return scene
end

function MyApp:createConcreteView(viewName, ...)
    local viewPackageName = self.packageRoot .. self.concretePackageName_ .. ".views." .. viewName
    local viewClass = require(viewPackageName)
    return viewClass.new(...)
end

function MyApp:createConcreteController(controllerName, ...)
    local controllerPackageName = self.packageRoot .. self.concretePackageName_ .. ".controllers." .. controllerName
    local controllerClass = require(controllerPackageName)
    return controllerClass.new(...)
end

return MyApp
