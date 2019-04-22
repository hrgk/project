local TYPES = import(".types")
local uihelper = {}

-- 根据原设计稿中的比例计算坐标
function uihelper.percentX(x)
    return x / DESIGN_WIDTH
end

-- 根据原设计稿中的比例计算坐标
function uihelper.percentY(y)
    return y / DESIGN_HEIGHT
end

function uihelper.setMask(node, opacity)
    opacity = opacity or 0
    local maskLayer = display.newColorLayer(cc.c4b(0, 0, 0, opacity))
    node:addChild(maskLayer, -99999)
    node:performWithDelay(function()
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(display.width, display.height))
        layout:setTouchEnabled(true)
        layout:setSwallowTouches(true)
        node:addChild(layout, -99999)
        end, 0)
end

function uihelper.loadTextures(textures)
    for _,v in pairs(textures) do
        display.addSpriteFrames(unpack(v))
    end
end

function uihelper.render(root, data, parent)
    if not data then
        printError("data empty.")
        return
    end
    if data.textures then
        uihelper.loadTextures(data.textures)
    end
    if data.type ~= TYPES.ROOT then
        printError("node isnt ROOT")
        return
    end
    if data.children then
        uihelper.appendChildren(root, parent or root, data.children, true)
        return
    end
end

function uihelper.appendChildren(root, parent, children)
    for _,v in pairs(checktable(children)) do
        uihelper.appendChild(root, parent, v)
    end
end

function uihelper.appendChild(root, parent, data)
    local obj = uihelper.createObjectByParams_(parent, data)
    if not obj then
        printError("create object fail " .. tostring(data.type))
        return
    end
    if data.var then
        root[data.var] = obj
    end
    if data.parentVar then
        parent[data.parentVar] = obj
    end
    
    uihelper.setCommonProperties(obj, data)
    if data.ppx then
        local parentSize = parent:getContentSize()
        obj:setPositionX(parentSize.width * data.ppx)
    end
    if data.ppy then
        local parentSize = parent:getContentSize()
        obj:setPositionY(parentSize.height * data.ppy)
    end
    if data.psize then
        local parentSize = parent:getContentSize()
        local width, height = unpack(data.psize)
        obj:setContentSize(width * parentSize.width, height * parentSize.height)
    end
    if data.pheight then
        local parentSize = parent:getContentSize()
        local nowSize = obj:getContentSize()
        obj:setContentSize(nowSize.width, data.pheight * parentSize.height)
    end
    if data.pwidth then
        local parentSize = parent:getContentSize()
        local nowSize = obj:getContentSize()
        obj:setContentSize(parentSize.width * data.pwidth, nowSize.height)
    end
    
    uihelper.appendChildren(root, obj, data.children)
end

function uihelper.createObject(data)
    local obj = uihelper.createObjectByParams_(nil, data)
    if not obj then
        printError("create object fail " .. tostring(data.type))
        return
    end
    uihelper.setCommonProperties(obj, data)
    uihelper.appendChildren({}, obj, data.children)
    return obj
end

function uihelper.findHandlerByType_(type)
    assert(uihelper.handlers[type], "handler is nil of " .. tostring(type))
    return uihelper.handlers[type]
end

function uihelper.createObjectByParams_(parent, params)
    if not params or not params.type then
        return
    end
    local func = uihelper.findHandlerByType_(params.type)
    local obj = func(params)
    if parent and obj then
        parent:addChild(obj)
    end
    return obj
end

function uihelper.calcPx(px)
    if px > -2 and px < 2 then
        return px
    end
    return uihelper.percentX(px)
end

function uihelper.calcPy(py)
    if py > -2 and py < 2 then
        return py
    end
    return uihelper.percentY(py)
end

-- 设置目标对象的通用属性，像大小、锚点、坐标、百分比坐标等。
-- 如果对象的 px, py 属性未在 [-2, 2] 的范围内，则被认为是自动用坐标计算百分比
function uihelper.setCommonProperties(obj, data)
    if data.size and data.type ~= TYPES.BUTTON and data.type ~= TYPES.SLIDER and obj.setContentSize then
        obj:setContentSize(unpack(data.size))
    end
    if data.ap and #data.ap == 2 then
        obj:setAnchorPoint(cc.p(unpack(data.ap)))
    end
    if data.x then
        obj:setPositionX(data.x)
    end
    if data.y then
        obj:setPositionY(data.y)
    end
    if data.px then
        obj:setPositionX(display.width * uihelper.calcPx(data.px))
    end
    if data.py then
        obj:setPositionY(display.height * uihelper.calcPy(data.py))
    end
    if data.scale then
        obj:setScale(data.scale)
    end
    if data.scaleX then
        obj:setScaleX(data.scaleX)
    end
    if data.scaleY then
        obj:setScaleY(data.scaleY)
    end
    if data.flipX then
        obj:setFlippedX(data.flipX)
    end
    if data.flipY then
        obj:setFlippedY(data.flipY)
    end
    if data.rotate then
        obj:setRotation(data.rotate)
    end
    if data.align and #data.align == 3 then
        obj:align(unpack(data.align))
    end
    if data.visible ~= nil then
        obj:setVisible(data.visible)
    end
    if data.opacity ~= nil then
        obj:setCascadeOpacityEnabled(true)
        obj:setOpacity(data.opacity)
    end
    if data.touchEnabled ~= nil then
        obj:setTouchEnabled(data.touchEnabled)
    end
end

-- 根据父对象的x坐标、宽度、锚点以及子对象与父对象的左侧x轴偏移量来计算子对象所处的全局x坐标
function uihelper.calcLeftX(x, w, offset, anchorX)
    local anchorX = anchorX or 0.5
    return x - w * anchorX + offset or 0
end

-- 根据父对象的x坐标、宽度、锚点以及子对象与父对象的右侧x轴偏移量来计算子对象所处的全局x坐标
function uihelper.calcRightX(x, w, offset, anchorX)
    local anchorX = anchorX or 0.5
    return x + w * anchorX - offset or 0
end

-- 根据父对象的y坐标、高度、锚点以及子对象与父对象的底部y轴偏移量来计算子对象所处的全局y坐标
function uihelper.calcLeftY(y, h, offset, anchorY)
    local anchorY = anchorY or 0.5
    return y - h * anchorY + offset or 0
end

-- 根据父对象的y坐标、高度、锚点以及子对象与父对象的顶部y轴偏移量来计算子对象所处的全局y坐标
function uihelper.calcRightY(y, h, offset, anchorY)
    local anchorY = anchorY or 0.5
    return y + h * anchorY - offset or 0
end

-- 根据当前的定位信息来计算对象左下角的位置
function uihelper.calcLeftBottomPosition(posInfo, w, h, offsetX, offsetY, anchorX, anchorY)
    local x = posInfo.x or 0
    if posInfo.px then
        x = uihelper.calcPx(posInfo.px) * display.width
    end
    local y = posInfo.y or 0
    if posInfo.py then
        y = uihelper.calcPy(posInfo.py) * display.height
    end
    local x = uihelper.calcLeftX(x, w, offsetX, anchorX)
    local y = uihelper.calcLeftY(y, h, offsetY, anchorY)
    return x, y
end

-- 计算滑动区域的rect, 根据其父对象或想象的父对象的位置信息来计算
-- x,y,w,h => 父对象的x,y坐标及父对象的宽高
-- leftMargin, bottomMargin, rightMargin, topMargin => 子对象的左侧间距、底部间隔、右侧间隔、顶部间隔
-- anchorX, anchorY => 父对象的x,y轴锚点
-- return => 返回滑动对象所处的rect区域
function uihelper.calcScrollRect(x, y, w, h, leftMargin, bottomMargin, rightMargin, topMargin, anchorX, anchorY)
    assert(x and y and w and h)
    local leftMargin = leftMargin or 0
    local bottomMargin = bottomMargin or 0
    local rightMargin = rightMargin or leftMargin
    local topMargin = topMargin or bottomMargin
    local anchorX = anchorX or 0.5
    local anchorY = anchorY or 0.5
    local lx = uihelper.calcLeftX(x, w, leftMargin, anchorX)
    local ly = uihelper.calcLeftY(y, h, bottomMargin, anchorY)
    local rx = uihelper.calcRightX(x, w, rightMargin, anchorX)
    local ry = uihelper.calcRightY(y, h, topMargin, anchorY)
    return cc.rect(lx, ly, rx - lx, ry - ly)
end

function uihelper.createLayer(options)
    local layer = display.newLayer()
    if options.touchEnabled == nil then  -- 将layer作为容器，默认关闭touch
        layer:setTouchEnabled(false)
    end
    return layer
end

--[[
生成一个带颜色的层，接收一个参数 color 
options.color: 颜色值, 4个变量的数组
]]
function uihelper.createLayerColor(options)
    assert(options.color and #options.color == 4)
    local layer = display.newColorLayer(cc.c4b(unpack(options.color)))
    return layer
end

function uihelper.createNode(options)
    return display.newNode()
end

function uihelper.createClippingNode(options)
    return display.newClippingRegionNode(options.rect)
end

function uihelper.createSprite(options)
    if options.isGray then
        return display.newGraySprite(options.filename, options.options)
    end
    return cc.ui.UIImage.new(options.filename, options):align(display.CENTER)
end

function uihelper.getButtonStateImages(options)
    local images = {}
    if options.normal then
        images.normal = options.normal
    end
    if options.pressed then
        images.pressed = options.pressed
    end
    if options.disabled then
        images.disabled = options.disabled
    end

    return images
end

-- 为按钮，包括 PushButton 和 Checkbox 设置标签的辅助函数
function uihelper.setButtonLabel_(button, labels, offset)
    assert(button, "button and labels can't be nil")
    if not labels then
        return
    end
    for state, data in pairs(labels) do
        local label = cc.ui.UILabel.new(data)
        button:setButtonLabel(state, label)
    end
    local offset = offset or {0, 0}
    button:setButtonLabelOffset(unpack(offset))
end

-- 添加自定义按钮的支持
function uihelper.createButton(options)
    local button
    if options.autoGray or options.autoScale or options.autoOpacity or options.soundEffect then
        button = gailun.JWPushButton.new(uihelper.getButtonStateImages(options), options.options)
        button:setAutoGray(options.autoGray)
        button:setAutoScale(options.autoScale)
        button:setAutoOpacity(options.autoOpacity)
        if uihelper.defaultClickSound_ then
            button:setSoundEffect(uihelper.defaultClickSound_)
        end
        if options.soundEffect then
            button:setSoundEffect(options.soundEffect)
        end
    else
        button = cc.ui.UIPushButton.new(uihelper.getButtonStateImages(options), options.options)
    end
    
    if options.size then
        button:setButtonSize(unpack(options.size))
    end

    uihelper.setButtonLabel_(button, options.labels, options.offset)
    return button
end

function uihelper.createLoadingBar(options)
    local node = cc.ui.UILoadingBar.new(options.options)

    local direction = options.options.direction or cc.ui.UILoadingBar.DIRECTION_LEFT_TO_RIGHT
    node:setDirction(options.options.direction)
    return node
end

function uihelper.createSlider(options)
    local direction = options.direction or display.LEFT_TO_RIGHT
    local node = cc.ui.UISlider.new(direction, options.images, options.options)

    if options.size then
        node:setSliderSize(unpack(options.size))
    end
    node:setSliderValue(options.options.percent or 0)
    return node
end

function uihelper.createCheckBoxGroup(options)
    local node = cc.ui.UICheckBoxButtonGroup.new(options.direction or display.LEFT_TO_RIGHT)
    for k,v in pairs(options.buttons or {}) do
        if v then
            local b = uihelper.createCheckBox(v)
            node:addButton(b)
        end
    end
    if options.margin and #options.margin == 4 then
        node:setButtonsLayoutMargin(unpack(options.margin))
        node:getLayout():apply(node)
    end
    return node
end

function uihelper.createCheckBox(options)
    local node = cc.ui.UICheckBoxButton.new(options.images, options.options)
    uihelper.setCommonProperties(node, options)
    uihelper.setButtonLabel_(node, options.labels, options.offset)
    return node
end

function uihelper.createBMFontLabel(options)
    local node = cc.ui.UILabel.new(options.options)
    return node
end

function uihelper.createLabel(options)
    local node = cc.ui.UILabel.new(options.options)
    return node
end

-- 说明一下options的细节
-- text: 要显示的字符串
-- w: 单个字符的宽
-- h: 单个字符的高
-- startChar: 开始字符
function uihelper.createLabelAtlas(options)
    local labelAtlas
    local params = options.options
    if "function" == type(cc.LabelAtlas._create) then
        labelAtlas = cc.LabelAtlas:_create()
        labelAtlas:initWithString(params.text, options.filename, params.w, params.h, string.byte(params.startChar))
    else
        labelAtlas = cc.LabelAtlas:create(params.text, options.filename, params.w, params.h, string.byte(params.startChar))
    end
    return labelAtlas
end

-- 说明一下参数，本身c2dx有两种输入框，这里只选了editbox, 没有添加textfield的相关内容
-- placeHolder: 占位符号
-- font: 字体
-- fontSize: 字号
-- text: 默认文本
-- isPassword: 是否为密码框
-- maxLength: 最多输入字符
-- options: 请参考 UIInput 里面的构造参数, 注意 image 选项是必有的，如果不需要的话要设置一个透明空图片
function uihelper.createEditBox(options)
    local params = options.options
    assert(params and params.image)
    local editBox = cc.ui.UIInput.new(params)
    editBox:setPlaceHolder(options.placeHolder or '')
    if options.font then
        editBox:setFontName(options.font)
    end
    editBox:setFontSize(options.fontSize or 20)
    editBox:setText(options.text or '')
    if options.isPassword then
        editBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    editBox:setMaxLength(options.maxLength or 100)
    return editBox
end

-- 参考QUICK的参数说明，这里只添加了一个，bounceable，是否开启回弹，默认开启
function uihelper.createScrollView(options)
    local node = cc.ui.UIScrollView.new(options.options)
    node:setBounceable(options.options.bounceable or true)
    return node
end

-- 参考QUICK的参数说明，这里只添加了一个，bounceable，是否开启回弹，默认开启
function uihelper.createListView(options)
    local node = cc.ui.UIListView.new(options.options)
    node:setBounceable(options.bounceable or true)
    local params = options.itemParams
    if params and params.class and params.data then
        params.width = params.width or options.viewRect.width
        params.height = params.height or options.viewRect.height
        uihelper.appendListItems(node, params, params.data)
    end
    return node
end

-- 为listView添加item，无返回值
function uihelper.appendListItems(listView, params, data, ...)
    assert(params and params.class and data and type(data) == 'table', "appendListItems class and data needed!")
    local class = require(params.class)
    local top, right, bottom, left = unpack(params.margin or {0, 0, 0, 0})
    local margin = {top = top, right = right, bottom = bottom, left = left}
    local function __addItem(v, ...)
        local item = listView:newItem()
        item:setMargin(margin)
        local content = class.new(v, ...)
        item:addContent(content)
        item:setItemSize(params.width, params.height)
        listView:addItem(item)
    end
    if data[0] then
        __addItem(data[0], ...)
    end
    for k,v in pairs(data) do
        if 0 ~= k then
            __addItem(v, ...)
        end
    end
    listView:reload()
end

function uihelper.createPageView(options)
    local node = cc.ui.UIPageView.new(options.options)
    return node
end

function uihelper.createCustomClass(options)
    local class = require(options.class)
    return class.new(unpack(options.classParams or {}))
end

local directionData = {
    [display.LEFT_TO_RIGHT] = {{0, 0.5}, {1, 0}}, --left to right
    [display.RIGHT_TO_LEFT] = {{1, 0.5}, {1, 0}}, --right to left
    [display.TOP_TO_BOTTOM] = {{0.5, 1}, {0, 1}}, --top to bottom
    [display.BOTTOM_TO_TOP] = {{0.5, 0}, {0, 1}}, --bottom to top
}
--[[
这里记录一个遇到的很怪异的BUG，当进度条是圆形时，如果预先 setPercentage，则会导致开始的20%左右移动时进度条不动
]]
function uihelper.createProgressTimer(options)
    local progressType = options.progressType or display.PROGRESS_TIMER_BAR
    local s = display.newSprite(options.bar)
    local node = display.newProgressTimer(s, progressType)
    local direction = options.direction or display.LEFT_TO_RIGHT
    if node then
        if progressType == display.PROGRESS_TIMER_BAR then
            local midpoint, changerate = unpack(directionData[direction])
            node:setMidpoint(cc.p(unpack(midpoint)))
            node:setBarChangeRate(cc.p(unpack(changerate)))
            node:setPercentage(options.percent or 100)
        end
        
        if options.reverse == true then
            node:setReverseDirection(true)
        end
    end
    return node
end

function uihelper.createJWSlider(options)
    return gailun.JWSlider.new(options)
end

function uihelper.checkSupportFormat(filename)
    if string.byte(filename) == 35 then -- first char is #
        return true
    end
    return true
    -- return cc.ccHelper:checkSupportFormat(filename)
end

-- 不加是否在范围内的快速设置触摸回调
-- 回调的event里面，在moved和ended事件里面加上了 rawTouchInside 变量，标示
-- 触摸是否在元素范围内
function uihelper.setRawTouchHandler(node, onEnded, onBegan, onMoved)
    assert(node)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)  -- 吞噬
    local listener = node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y = event.name, event.x, event.y
        if name == "began" then
            if onBegan then
                onBegan(event)
            end
            return true
        end
        local touchInside = cc.rectContainsPoint(node:getCascadeBoundingBox(), cc.p(x, y))
        event.rawTouchInside = touchInside
        if name == "moved" then
            if onMoved then
                onMoved(event)
            end
            return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
        else
            if onEnded then
                onEnded(event)
            end
        end
    end)
    return listener
end

-- 设置全部按钮的默认点击音效，只对JWPushButton有效
function uihelper.setDefaultSoundEffect(sound)
    uihelper.defaultClickSound_ = sound
end

-- 快速设置元素的自定义触摸事件
-- 回调函数只有在范围内时才会收到 onEnded 和 onMoved 事件
function uihelper.setTouchHandler(node, onEnded, onBegan, onMoved)
    assert(node)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(true)  -- 吞噬
    local listener = node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y = event.name, event.x, event.y
        if name == "began" then
            if onBegan then
                onBegan(event)
            end
            return true
        end
        local touchInside = cc.rectContainsPoint(node:getCascadeBoundingBox(), cc.p(x, y))
        if name == "moved" then
            if touchInside then
                if onMoved then
                    onMoved(event)
                end
            end
            return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
        else
            if touchInside then
                if onEnded then
                    onEnded(event)
                end
            end
        end
    end)
    return listener
end

function uihelper.makeImageWithMask(imageName, maskName)
    local stencil = display.newSprite(maskName)
    local stencilSize = stencil:getContentSize()
    local clipper = cc.ClippingNode:create()
    clipper:setStencil(stencil) -- 设置裁剪模板
    clipper:setAlphaThreshold(0) -- 设置绘制底板的Alpha阀值为0
    if not uihelper.checkSupportFormat(imageName) then -- 判断是否引擎支持的文件
        printError("unsupport image format with: " .. imageName)
        return clipper, display.newNode()
    end
    local content = display.newSprite(imageName) -- 被裁剪的内容
    local contentSize = content:getContentSize()
    content:setScale(stencilSize.width / math.min(contentSize.width, contentSize.height))
    clipper:addChild(content)
    clipper:setCascadeOpacityEnabled(true)
    return clipper
end

uihelper.handlers = {
    [TYPES.LAYER] = uihelper.createLayer,
    [TYPES.NODE] = uihelper.createNode,
    [TYPES.SPRITE] = uihelper.createSprite,
    [TYPES.BUTTON] = uihelper.createButton,
    [TYPES.LOADING_BAR] = uihelper.createLoadingBar,
    [TYPES.SLIDER] = uihelper.createSlider,
    [TYPES.CHECK_BOX] = uihelper.createCheckBox,
    [TYPES.BM_FONT_LABEL] = uihelper.createBMFontLabel,
    [TYPES.LABEL] = uihelper.createLabel,
    [TYPES.LABEL_ATLAS] = uihelper.createLabelAtlas,
    [TYPES.EDIT_BOX] = uihelper.createEditBox,
    [TYPES.SCROLL_VIEW] = uihelper.createScrollView,
    [TYPES.LIST_VIEW] = uihelper.createListView,
    [TYPES.PAGE_VIEW] = uihelper.createPageView,
    [TYPES.CHECK_BOX_GROUP] = uihelper.createCheckBoxGroup,
    [TYPES.CUSTOM] = uihelper.createCustomClass,
    [TYPES.PROGRESS_TIMER] = uihelper.createProgressTimer,
    [TYPES.JW_SLIDER] = uihelper.createJWSlider,
    [TYPES.LAYER_COLOR] = uihelper.createLayerColor,
    [TYPES.CLIPPING_NODE] = uihelper.createClippingNode,
}

return uihelper
