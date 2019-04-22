local UIHelp = {}

function UIHelp.addTouchEventListenerToBtnWithScale(btn, func)
    --增加防止按钮多次点击
    local scale = btn:getScale()
    local  function buttonFunc (sender,eventType)
        if eventType == 0 then
            btn:stopAllActions()
            btn:setScale(1)
            btn:runAction(cc.ScaleTo:create(0.08, 0.9))
            if DEFAULT_CLICK_SOUND and string.len(DEFAULT_CLICK_SOUND) > 0 then
                gameAudio.playSound(DEFAULT_CLICK_SOUND, false)
            end
        elseif eventType == 2 then 
            btn:stopAllActions()
            btn:setScale(0.9)
            btn:runAction(cc.ScaleTo:create(0.04, 1))
            if func then 
                func(sender)
            end 
        elseif eventType == 3 then
            btn:stopAllActions()
            btn:setScale(0.9)
            btn:runAction(cc.ScaleTo:create(0.04, 1))
        end
    end    
    btn:setTouchEnabled(true)
    btn:addTouchEventListener(buttonFunc)
end

function UIHelp.seekNodeByNameEx(parent, name)
    if not parent then
        return
    end
    
    if name == parent:getName() then
        return parent
    end

    local findNode
    local children = parent:getChildren()
    local childCount = parent:getChildrenCount()
    if childCount < 1 then
        return
    end
    for i=1, childCount do
        if "table" == type(children) then
            parent = children[i]
        elseif "userdata" == type(children) then
            parent = children:objectAtIndex(i - 1)
        end

        if parent then
            if name == parent:getName() then
                return parent
            end
        end
    end

    for i=1, childCount do
        if "table" == type(children) then
            parent = children[i]
        elseif "userdata" == type(children) then
            parent = children:objectAtIndex(i - 1)
        end

        if parent then
            findNode = UIHelp.seekNodeByNameEx(parent, name)
            if findNode then
                return findNode
            end
        end
    end

    return
end

-- 根据原设计稿中的比例计算坐标
function UIHelp.percentX(x)
    return x / DESIGN_WIDTH
end

-- 根据原设计稿中的比例计算坐标
function UIHelp.percentY(y)
    return y / DESIGN_HEIGHT
end

function UIHelp.setEnabled(btn, value, image)
    btn:setEnabled(value)

    if not image then
        return
    end

    btn:removeAllChildren()
    local sprite
    if not value then
        sprite = display.newGraySprite(image)
        btn:addChild(sprite, 1)
        sprite:setAnchorPoint(cc.p(0, 0))
        sprite:setPosition(0, 0)
    end
end

function UIHelp.setQuickEnabled(btn, value, image)
    btn:setButtonEnabled(value)

    if not image then
        return
    end

    btn:removeAllChildren()
    local sprite
    if not value then
        sprite = display.newGraySprite(image)
        btn:addChild(sprite, 1)
        sprite:setAnchorPoint(cc.p(0.5, 0.5))
        sprite:setPosition(0, 0)
    end
end


return UIHelp