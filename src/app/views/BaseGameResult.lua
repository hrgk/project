local BaseGameResult = class("BaseGameResult", gailun.BaseView)
local TYPES = gailun.TYPES
local nodes = {
	type = TYPES.ROOT,
	children = {
		{type = TYPES.LAYER_COLOR, color = {0, 0, 0, 200}},
		{type = TYPES.SPRITE, var = "spriteBg_", filename = "images/game/js_fkd.png", x = display.cx, y = display.cy,  scale9 = true, size = {100, 100}, ap = {0.5, 0.5}},
	}
}

function BaseGameResult:ctor(param)
	gailun.uihelper.render(self, nodes)
	gailun.uihelper.setTouchHandler(self.spriteBg_)
end

return BaseGameResult
