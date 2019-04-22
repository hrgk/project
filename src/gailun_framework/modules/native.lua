local utils = import("..utils.utils")
local native = {}

--封装设备与游戏之间的互相调用接口，比如IOS获得设备的信息
local isAndroid = string.lower(device.platform) == "android"
local isIOS = string.lower(device.platform) == "ios"

native.java_class_name_ = nil
native.oc_class_name_ = nil

function native.setClassName(java_class_name, oc_class_name)
	assert(java_class_name and oc_class_name)
	native.java_class_name_ = java_class_name
	native.oc_class_name_ = oc_class_name
end

local function callNativeAndroid(method_name, params, method_sig, class_name)
	local class_name = class_name or native.java_class_name_
    if DEBUG and DEBUG > 0 then
        printInfo("callNativeAndroid(%s, %s, %s, %s)", class_name, method_name, type(params), method_sig)
    end
    local ok, result = luaj.callStaticMethod(class_name, method_name, params, method_sig)
    if ok then
        return result
    end
end

local function callNativeIOS(method_name, params)
    if DEBUG and DEBUG > 0 then
        printInfo("callNativeIOS(%s, %s, %s)", native.oc_class_name_, method_name, type(params))
    end
    local ok, result = luaoc.callStaticMethod(native.oc_class_name_, method_name, params)
    if ok then
        return result
    end
end

-- 获得环境ID
function native.getEnvId()
	if DEBUG and DEBUG > 0 then
        printInfo("native.getEnvId")
    end
    if isAndroid then
        return callNativeAndroid("getMetaData", {"VerType"}, "(Ljava/lang/String;)Ljava/lang/String;")
    elseif isIOS then
    	return callNativeIOS("getNativeInfo", {key = "VerType"})
    end
end

-- 获得软件版本
function native.getVersionName()
	if isAndroid then
		return callNativeAndroid("getVersionName", {}, "()Ljava/lang/String;")
	elseif isIOS then
		return callNativeIOS("getNativeInfo", {key = "CFBundleVersion"})
	end
end

-- 获得软件版本
function native.getShortVersionName()
	if isAndroid then
		return callNativeAndroid("getVersionName", {}, "()Ljava/lang/String;")
	elseif isIOS then
		return callNativeIOS("getNativeInfo", {key = "CFBundleShortVersionString"})
	end
end

-- 获得系统版本号
function native.getSystemVersionName()
	
end

-- 获得设备型号
function native.getDeviceModel()
	if isAndroid then
		return callNativeAndroid("getDeviceModel", {}, "()Ljava/lang/String;")
	elseif isIOS then
		return device.model
	end
	return "nomobile"
end

-- 获得渠道ID
function native.getChannelId()
	if isAndroid then
		return callNativeAndroid("getChannelId", {}, "()I")
	end
	if isIOS then
		local result = callNativeIOS("getNativeInfo", {key = "ChannelID"})
		if result then
			return checkint(result)
		end
	end
	return 0
end

-- 震动
function native.vibrate(microSeconds)
	if isAndroid then
		return callNativeAndroid("vibrate", {microSeconds or 200}, "(F)V")
	elseif isIOS then
		return callNativeIOS("deviceVibrate")
	end
end

-- 获得电量百分比信息
function native.getBattery()
	if isAndroid then
		return callNativeAndroid("getBattery", {}, "()I")
	elseif isIOS then
		return callNativeIOS("getBatteryInfo")
	end
	return 90
end

function native.copy(str)
	if isAndroid then
		return callNativeAndroid("copy", {str}, "(Ljava/lang/String;)V")
	end
	if isIOS then
		return callNativeIOS("copyToPasteBoard", {content = str or ''})
	end
end

-- 获得SD卡目录
local sdCardPath = nil
function native.getSDCardPath()
	if not isAndroid then
		return device.writablePath
	end
	if sdCardPath then
        return sdCardPath
    end
    sdCardPath = callNativeAndroid("getExternalStorageDirectory", {}, "()Ljava/lang/String;")
    return sdCardPath
end

-- 安装APK文件
function native.installAPK(path)
	if not isAndroid then
		return
	end
	return callNativeAndroid("installAPK", {path}, "(Ljava/lang/String;)V")
end

function native.makeRandomStringInKeyChain_(length, keyName)
	local data = callNativeIOS("getDataInKeyChain", {key = keyName})
	if data and string.len(data) > 0 then
		return data
	end

	local newData = utils.randomString(length)
	callNativeIOS("setDataInKeyChain", {key = keyName, value = newData})
	return newData
end

function native.getIMEI()
	if isAndroid then
		return callNativeAndroid("getImei", {}, "()Ljava/lang/String;")
	elseif isIOS then
		return native.makeRandomStringInKeyChain_(15, "IOS_IMEI")
	end
	return utils.randomString(15)
end

function native.getIMSI()
	if isAndroid then
		return callNativeAndroid("getImsi", {}, "()Ljava/lang/String;")
	elseif isIOS then
		return native.makeRandomStringInKeyChain_(15, "IOS_IMSI")
	end
	return utils.randomString(15)
end

function native.getMAC()
	if isAndroid then
		local str = callNativeAndroid("getMacAddr", {}, "()Ljava/lang/String;")
		if not str or string.len(str) < 1 then
			utils.randomString(15)
		else
			return str
		end
	elseif isIOS then
		return native.makeRandomStringInKeyChain_(15, "IOS_MAC")
	end
	return utils.randomString(15)
end

function native.pressHomeButton()
	if isAndroid then
	    return callNativeAndroid("pressHomeButton", {}, "()V")
	end
	app:exit()
end

function native.weChatInit(appID, appName)
	if isAndroid then
		return callNativeAndroid("weChatInit", {appID}, "(Ljava/lang/String;)V")
	end
	if isIOS then
		return callNativeIOS("initWeChat", {app_id = appID, app_name = appName})
	end
end

function native.weChatPay(params, callback)
	if isAndroid then
		return callNativeAndroid("wxPay", {json.encode(params), callback}, "(Ljava/lang/String;I)V")
	end
	if isIOS then
		return callNativeIOS("initWeChat", {app_id = appID, app_name = appName})
	end
end

--调用微信第三方分享
--[[
    params 为table
    type == 分享类型（"text"（文字）、"img"（图片）、"url"（链接））
    tagName: "", 分享的标签名称
    title: "", 分享的标题
    description: "", 分享的描述
    imagePath: "", 图片路径，分享图片是是主要内容，分享链接时是缩略图
    inScene: int（0 为会话 1为朋友圈）
    url: 链接地址（链接分享类型特有）
]]
function native.shareWeChat(params, callback)
	if isAndroid then
		return callNativeAndroid("weChatShare", {json.encode(params), callback}, "(Ljava/lang/String;I)V")
	end
	if isIOS then
		params.callfunc = callback
		if params.type == "img" then
			return native.shareIOSWeChatImage_(params)
		end
		if params.type == "url" then
			return native.shareIOSWeChatLink_(params)
		end
	end
end

function native.shareIOSWeChatImage_(params)
	if not isIOS then
		return
	end
	return callNativeIOS("sendImageToWeChat", params)
end

function native.shareIOSWeChatLink_(params)
	if not isIOS then
		return
	end
	return callNativeIOS("sendLinkURLToWeChat", params)
end

function native.startWeChatAuth(params)
	if isIOS then
		return callNativeIOS("startWeChatAuth", params)
	end
	if isAndroid then
		return callNativeAndroid("weChatLogin", {params.callback}, "(I)V")
	end
end

function native.getLocation(params)
	if isIOS then
		return callNativeIOS("getLocation", params)
	end
	if isAndroid then
		return callNativeAndroid("getLocation", {params.callback}, "(I)V")
	end
end

function native.getLocationString(params)
	if isIOS then
		return callNativeIOS("getLocationString", params)
	end
	if isAndroid then
		return ""
	end
end

function native.initRecorder(savePath, seconds)
	if isIOS then
		return callNativeIOS("initRecorder", {savePath = savePath, seconds = seconds})
	end
	if isAndroid then
		return callNativeAndroid("initRecorder", {savePath, seconds}, "(Ljava/lang/String;I)V")
	end
end

--[[
callback: 录音结束后的回调函数, 它接受一个LUA table的返回值，如：{flag = 1, progress = 0}

progress: 0|1
0: 表示当前操作为开始录音 
1: 表示当前回调点为录音结束

flag: 按progress的情况来分析，当进度为开始录音时，表示如下：
1: 录音成功开始
-1: 没有录音权限
-2: 正在录音中
-3: IO错误
-4: 创建录音器失败
-5: 未知错误

当progress为录音结束的时候，表示如下：
1: 录音成功
-1: 录音失败
]]
function native.startRecorder(callback)
	if isIOS then
		local function ios_callback(result)
			if callback and type(callback) == 'function' then
				callback(result)
			end
		end
		return callNativeIOS("startRecorder", {callback = ios_callback})
	end
	if isAndroid then
		local function android_callback(data)
			local result = json.decode(data)
			printInfo(data)
			if callback and type(callback) == 'function' then
				callback(result)
			end
		end
		return callNativeAndroid("startRecorder", {android_callback}, "(I)V")
	end
	return -4
end

function native.stopRecorder()
	if isIOS then
		return callNativeIOS("stopRecorder", {})
	end
	if isAndroid then
		return callNativeAndroid("stopRecorder", {}, "()V")
	end
end

--[[
播放语音聊天的声音
callback 是LUA函数，它接受一个LUA Table的返回值，如：{duration = 1393, flag = 1}
flag: 播放结果 -1: 文件打开失败 -2: 播放失败 1：播放成功
duration: 声音的毫秒数
]]
function native.playSound(filePath, callback)
	if isIOS then
		local function ios_callback(result)
			if callback and type(callback) == 'function' then
				callback(result)
			end
		end
		return callNativeIOS("playSound", {filePath = filePath, callback = ios_callback})
	end
	if isAndroid then
		local function android_callback(data)
			local result = json.decode(data)
			if not result then
				printInfo(result)
			end
			if callback and type(callback) == 'function' then
				callback(result)
			end
		end
		return callNativeAndroid("playSound", {filePath, android_callback}, "(Ljava/lang/String;I)V")
	end
end

function native.enterApp(params)
	if isIOS then
		return callNativeIOS("enterApp", params)
	end
	if isAndroid then
		return callNativeAndroid("enterApp", {params.packageName}, "(Ljava/lang/String;)V")
	end
end

function native.changeOrientation(iOrientation)
	if isIOS then
		return callNativeIOS("changeOrientation", {iOrientation = iOrientation})
	end
	if isAndroid then
		return callNativeAndroid("changeOrientation", {iOrientation}, "(I)V")
	end
end

return native
