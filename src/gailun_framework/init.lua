--
--                       _oo0oo_
--                      o8888888o
--                      88" . "88
--                      (| -_- |)
--                      0\  =  /0
--                    ___/`---'\___
--                  .' \\|     |-- '.
--                 / \\|||  :  |||-- \
--                / _||||| -:- |||||- \
--               |   | \\\  -  --/ |   |
--               | \_|  ''\---/''  |_/ |
--               \  .-\__  '-'  ___/-. /
--             ___'. .'  /--.--\  `. .'___
--          ."" '<  `.___\_<|>_/___.' >' "".
--         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--         \  \ `_.   \_ __\ /__ _/   .-` /  /
--     =====`-.____`.___ \_____/___.-`___.-'=====
--                       `=---='
--
--
--     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
--               佛祖保佑         永无BUG
--
--
--


gailun = {}

gailun.scriptId = 1

-- 小补丁，因为不用CURL库的话这几个变量不会被导出
if not kCCNetworkStatusNotReachable then
    kCCNetworkStatusNotReachable = 0
end
if not kCCNetworkStatusReachableViaWiFi then
    kCCNetworkStatusReachableViaWiFi = 1
end
if not kCCNetworkStatusReachableViaWWAN then
    kCCNetworkStatusReachableViaWWAN = 2
end

gailun.TYPES = import(".ui.types")
gailun.uihelper = import(".ui.uihelper")
gailun.utils = import(".utils.utils")
gailun.xml = import(".utils.xml")
gailun.utf8 = import(".utils.utf8")
gailun.BaseSocket = import(".net.BaseSocket")
gailun.LineSocket = import(".net.LineSocket")
gailun.HTTP = import(".net.HTTP")
gailun.NumberRoller = import(".utils.NumberRoller")
gailun.LocalStorage = import(".modules.LocalStorage")
gailun.DiskCache = import(".modules.DiskCache")
gailun.JWQueue = import(".modules.Queue")
gailun.JWSlider = import(".ui.JWSlider")
gailun.JWPushButton = import(".ui.JWPushButton")
gailun.BaseView = import(".ui.BaseView")
gailun.EventUtils = import(".utils.EventUtils")
gailun.JWModelBase = import(".utils.JWModelBase")
gailun.log = import(".utils.log")
gailun.AsyncLoader = import(".modules.AsyncLoader")
gailun.native = import(".modules.native")
