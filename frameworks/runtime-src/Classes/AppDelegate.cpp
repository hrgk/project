#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "lua_module_register.h"


// extra lua module
#include "cocos2dx_extra.h"
#include "lua_extensions/lua_extensions_more.h"
#include "luabinding/lua_cocos2dx_extension_filter_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_manual.hpp"
#include "luabinding/cocos2dx_extra_luabinding.h"
#include "luabinding/HelperFunc_luabinding.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "luabinding/cocos2dx_extra_ios_iap_luabinding.h"
#endif

// 导入头文件 CrashReport.h 和 BuglyLuaAgent.h
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CrashReport.h"
#include "BuglyLuaAgent.h"
#endif

#if ANYSDK_DEFINE > 0
#include "anysdkbindings.h"
#include "anysdk_manual_bindings.h"
#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

static const char* getKey(char cType)
{
    // "YYPHres20180414", "RSA";
    // "YYPHsrc20180414", "RSA";
    static char buf[100] = {0};
    if (cType == 0) {
        sprintf(buf, "%c%c%c", 82, 83, 65);
    }else if(cType == 1){
        sprintf(buf, "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c", 89, 89, 80, 72, 114, 101, 115, 50,
        48, 49, 56, 48, 52, 49, 52);
    }else if(cType == 2){
        sprintf(buf, "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c", 89, 89, 80, 72, 115, 114, 99, 50,
        48, 49, 56, 48, 52, 49, 52);
    }
    // CCLOG("key=%s", buf);
    return buf;
}

static void quick_module_register(lua_State *L)
{
    luaopen_lua_extensions_more(L);

    lua_getglobal(L, "_G");
    if (lua_istable(L, -1))//stack:...,_G,
    {
        register_all_quick_manual(L);
        // extra
        luaopen_cocos2dx_extra_luabinding(L);
        register_all_cocos2dx_extension_filter(L);
        register_all_cocos2dx_extension_nanovg(L);
        register_all_cocos2dx_extension_nanovg_manual(L);
        luaopen_HelperFunc_luabinding(L);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        luaopen_cocos2dx_extra_ios_iap_luabinding(L);
#endif
    }
    lua_pop(L, 1);
}

//
AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        string title = "paohuzi";
        glview = cocos2d::GLViewImpl::create(title.c_str());
        director->setOpenGLView(glview);
        director->startAnimation();
    }
   
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

    // use Quick-Cocos2d-X
    quick_module_register(L);
    
    

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//    CrashReport::initCrashReport("Your AppID", false);
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CrashReport::initCrashReport("a97a2a8303", false);
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
#endif
    // register lua exception handler with lua engine

    LuaStack* stack = engine->getLuaStack();
#if ANYSDK_DEFINE > 0
    lua_getglobal(stack->getLuaState(), "_G");
    tolua_anysdk_open(stack->getLuaState());
    tolua_anysdk_manual_open(stack->getLuaState());
    lua_pop(stack->getLuaState(), 1);
#endif

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());
    char buf1[100] = {0};
    char buf2[100] = {0};
    FileUtils::getInstance()->setResourceEncryptKeyAndSign(getKey(1), getKey(0));
#if 1
    // use luajit bytecode package
    strcpy(buf1, getKey(2));
    strcpy(buf2, getKey(0));
    stack->setXXTEAKeyAndSign(buf1, buf2);
    
#ifdef CC_TARGET_OS_IPHONE
    if (sizeof(long) == 4) {
        stack->loadChunksFromZIP("res/init32.zip");
    } else {
        stack->loadChunksFromZIP("res/init64.zip");
    }
#else
    // android, mac, win32, etc
    stack->loadChunksFromZIP("res/init32.zip");
#endif
    stack->executeString("require 'main'");
#else // #if 0
    // use discrete files
    engine->executeScriptFile("src/main.lua");
#endif

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();
    Director::getInstance()->pause();

//    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
//    SimpleAudioEngine::getInstance()->pauseAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->resume();
    Director::getInstance()->startAnimation();

//    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
//    SimpleAudioEngine::getInstance()->resumeAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
}
