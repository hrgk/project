local GameAnimation = {}

function GameAnimation.formatAnimData(animName, fileFormat, startIndex, totalFrames, totalSeconds, isLoop)
    assert(fileFormat, "fileFormat needed")
    assert(totalFrames, "totalFrames needed")
    assert(totalSeconds, "totalSeconds needed")
    local data = {
        animName = animName or "",
        fileFormat = fileFormat,
        startIndex = startIndex or 1,
        totalFrames = totalFrames,
        totalSeconds = totalSeconds,
        isLoop = isLoop or false,
        delaySeconds = 0,
        autoRemove = true,
        sound = nil,
        onComplete = nil,
        soundDelaySeconds = 0
    }
    return data
end

function GameAnimation.appendAnimAttrs(data, sound, autoRemove, delaySeconds, soundDelaySeconds)
    assert(data, "must call formatAnimData first.")
    if autoRemove ~= nil then
        data.autoRemove = autoRemove
    end
    if sound ~= nil then
        data.sound = sound or nil
    end
    if delaySeconds ~= nil then
        data.delaySeconds = delaySeconds or 0
    end
    if soundDelaySeconds ~= nil then
        data.soundDelaySeconds = soundDelaySeconds or 0
    end
    return data
end

function GameAnimation.play(container, params, onComplete)
    assert(container, "container cant be empty")
    assert(params, "params cant be empty")
    if type(onComplete) == "function" then
        params.onComplete = onComplete
    end
    GameAnimation.createAnimation_(container, params)
end

function GameAnimation.createAnimation_(target, params)
    local animation = display.getAnimationCache(params.animName)
    dump(params,"createAnimation_")
    if animation == nil then
        local frames = display.newFrames(params.fileFormat, params.startIndex, params.totalFrames)
        animation = display.newAnimation(frames, params.totalSeconds / params.totalFrames)
        display.setAnimationCache(params.animName, animation)
    end
    if params.isLoop then
        transition.playAnimationForever(target, animation, params.delaySeconds)
    else
        transition.playAnimationOnce(target, animation, params.autoRemove, params.onComplete, params.delaySeconds)
    end

    if params.sound then
        target:performWithDelay(function()
            gameAudio.playSound(params.sound)
        end, params.soundDelaySeconds)
    end
end

function GameAnimation.createPaoHuZiAnimations(data, parent, callfunc)
    local manager = ccs.ArmatureDataManager:getInstance()
    local function animationPlayOver(arm, eventType, movmentID)
        if data.isLoop then return end
        if data.isHold then return end
        manager:removeArmatureFileInfo("animations/paohuzi/" .. data.animation .. "/" .. data.animation ..".ExportJson")
        parent:removeChild(arm)
        if callfunc  and type(callfunc) == "function" then 
            callfunc()
        end
    end
    manager:addArmatureFileInfo("animations/paohuzi/" .. data.animation .. "/" .. data.animation .. ".ExportJson")
    local armature = ccs.Armature:create(data.animation)
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(animationPlayOver)
    armature:setPosition(cc.p(data.x, data.y))
    if data.scale then
        armature:setScale(data.scale)
    end
    parent:addChild(armature,100)
    if data.sound ~= "" then
        parent:performWithDelay(function()
            gameAudio.playSound(data.sound)
        end, data.soundDelaySeconds)
    end
    return armature
end


function GameAnimation.createCocosAnimations(data, parent, callfunc)
    local manager = ccs.ArmatureDataManager:getInstance()
    local function animationPlayOver(arm, eventType, movmentID)
        if data.isLoop then return end
        if data.isHold then return end
        manager:removeArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation ..".ExportJson")
        parent:removeChild(arm)
        if callfunc  and type(callfunc) == "function" then 
            callfunc()
        end
    end
    manager:addArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation .. ".ExportJson")
    local armature = ccs.Armature:create(data.animation)
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(animationPlayOver)
    armature:setPosition(cc.p(data.x, data.y))
    if data.scale then
        armature:setScale(data.scale)
    end
    parent:addChild(armature,100)
    if data.sound ~= "" then
        parent:performWithDelay(function()
            gameAudio.playSound(data.sound)
        end, data.soundDelaySeconds)
    end
    return armature
end

function GameAnimation.createCocosAnimationsTeams(data, parent, callfunc)
    local manager = ccs.ArmatureDataManager:getInstance()
    local function animationPlayOver(arm, eventType, movmentID)
        if data.isLoop then return end
        if data.isHold then return end
        manager:removeArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation ..".ExportJson")
        parent:removeChild(arm)
        if callfunc  and type(callfunc) == "function" then 
            callfunc()
        end
    end
    manager:addArmatureFileInfo("animations/" .. data.animation .. "/" .. data.animation .. ".ExportJson")
    local armature = ccs.Armature:create(data.animation)
    armature:getAnimation():setMovementEventCallFunc(animationPlayOver)
    armature:setPosition(cc.p(data.x, data.y))
    if data.scale then
        armature:setScale(data.scale)
    end
    parent:addChild(armature,100)
    if data.sound ~= "" then
        parent:performWithDelay(function()
            gameAudio.playSound(data.sound)
        end, data.soundDelaySeconds)
    end
    return armature
end


return GameAnimation 