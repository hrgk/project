-- AvatarView.lua
local AvatarView = class("AvatarView", gailun.BaseView)

AvatarView.BORDER = "res/images/common/avatar_border.png"  -- 头像的边框
AvatarView.MASK = "res/images/common/headmask.png"  -- 剪切的模板
AvatarView.SCALE = 0.46 -- 实际显示头像时所需要缩放的比例

function AvatarView:ctor(avatar)
    self:setCascadeOpacityEnabled(true)
    self:showAvatar_(avatar or "res/images/common/defaulthead.png")
end

function AvatarView:showWithUrl(url)
    if not url then
        printInfo("show with url fail by no url")
        return
    end
    if string.lower(string.sub(url, 1, 4)) ~= 'http' then
        if url == "" then
            url = "res/images/common/defaulthead.png"
        end
        return self:showAvatar_(url)
    end
    self:displayNetImage_(url)
end

function AvatarView:showAvatar_(image)
    if tolua.isnull(self) then return end
    if self.avatar_ then
        self:removeAllChildren()
        self.avatar_ = nil
    end
    -- self.avatar_ = gailun.uihelper.makeImageWithMask(image, AvatarView.MASK):addTo(self)
    self.avatar_ = display.newSprite(image):addTo(self)
    self.avatar_:setScale(AvatarView.SCALE)
    if AvatarView.BORDER and string.len(AvatarView.BORDER) > 0 then
        display.newSprite(AvatarView.BORDER):addTo(self)
    end
    return self
end

function AvatarView:setAvatarScale(scale)
    self.avatar_:setScale(scale or AvatarView.SCALE)
end

function AvatarView:getIconPath_()
    return DATA_PATH_HEADICON 
end

function AvatarView:makeIconPath_(url)
    return self:getIconPath_() .. crypto.md5(url)
end

function AvatarView:downloadIcon_(url, path)
    gailun.HTTP.download(url, path, handler(self, self.showAvatar_))
end

-- 此方法还没测试的，别用
function AvatarView:displayNetImage_(url)
    if not io.exists(self:getIconPath_()) then
        gailun.utils.mkdir(self:getIconPath_())
    end
    local path = self:makeIconPath_(url)
    if not io.exists(path) then
        return self:downloadIcon_(url, path)
    else
        return self:showAvatar_(path)
    end
end

return AvatarView
