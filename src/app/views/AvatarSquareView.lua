-- AvatarSquareView.lua
local AvatarSquareView = class("AvatarSquareView", gailun.BaseView)

function AvatarSquareView:ctor(avatar, border, mask, scale, isShowTxk)
    self.BORDER = "res/images/common/touxiangkuang.png"  -- 头像的边框
    self.MASK = "res/images/common/headmask1.png"  -- 剪切的模板
    self.SCALE = 0.5  -- 实际显示头像时所需要缩放的比例
    if isShowTxk ~= nil then
        self.isShowTxk = isShowTxk
    else
        self.isShowTxk = true
    end
    if border then
        self.BORDER = border
    end
    if mask then
        self.MASK = mask
    end
    if scale then
        self.SCALE = scale
    end
    self:setCascadeOpacityEnabled(true)
    if avatar == nil or string.len(avatar) == 0 then
        self:showAvatar_("res/images/common/defaulthead.png")
    else
        self:showAvatar_(avatar)
    end
end

function AvatarSquareView:showWithUrl(url)
    if not url then
        printInfo("show with url fail by no url")
        return
    end
    if url == nil or string.len(url) == 0 or string.lower(string.sub(url, 1, 4)) ~= 'http' then
        self:showAvatar_("res/images/common/defaulthead.png")
    else
        if string.lower(string.sub(url, 1, 4)) == 'http' then
            -- return self:showAvatar_(url)
            self:displayNetImage_(url)
        end
        -- self:displayNetImage_(url)
    end
end

function AvatarSquareView:showAvatar_(image)
    if tolua.isnull(self) then return end
    if self.avatar_ then
        self:removeAllChildren()
        self.avatar_ = nil
    end
    self.avatar_ = gailun.uihelper.makeImageWithMask(image, self.MASK):addTo(self)
    self.avatar_:setScale(self.SCALE)
    if self.BORDER and string.len(self.BORDER) > 0 and self.isShowTxk then
        display.newSprite(self.BORDER):addTo(self)
    end
    return self
end

function AvatarSquareView:setAvatarScale(scale)
    self.avatar_:setScale(scale or self.SCALE)
end

function AvatarSquareView:getIconPath_()
    return DATA_PATH_HEADICON
end

function AvatarSquareView:makeIconPath_(url)
    return self:getIconPath_() .. crypto.md5(url)
end

function AvatarSquareView:downloadIcon_(url, path)
    jw.HTTP.download(url, path, handler(self, self.showAvatar_))
end

-- 此方法还没测试的，别用
function AvatarSquareView:displayNetImage_(url)
    if not io.exists(self:getIconPath_()) then
        jw.utils.mkdir(self:getIconPath_())
    end
    local path = self:makeIconPath_(url)
    if not io.exists(path) then
        return self:downloadIcon_(url, path)
    else
        return self:showAvatar_(path)
    end
end

return AvatarSquareView
