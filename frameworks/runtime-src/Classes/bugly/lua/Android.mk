LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := bugly_agent_cocos_static_lua

LOCAL_MODULE_FILENAME := libbuglyagentlua

LOCAL_SRC_FILES := BuglyLuaAgent.cpp

# Maybe you need modify the head files according to the version of cocos engine be used
# This head files Cocos/frameworks/cocos2d-x-3.6
#
LOCAL_C_INCLUDES := $(LOCAL_PATH)\
$(LOCAL_PATH)/../ \
$(LOCAL_PATH)/../../ \
$(LOCAL_PATH)/../../../ \
$(COCOS2DX_ROOT)/cocos \
$(COCOS2DX_ROOT)/cocos/base \
$(COCOS2DX_ROOT)/cocos/platform/android \
$(COCOS2DX_ROOT)/cocos/scripting/lua-bindings/manual \
$(COCOS2DX_ROOT)/cocos/math/kazmath \
$(COCOS2DX_ROOT)/cocos/physics \
$(COCOS2DX_ROOT)/external \
$(COCOS2DX_ROOT)/external/lua/luajit/include\
$(COCOS2DX_ROOT)/external/lua/tolua\
$(COCOS2DX_ROOT)/cocos2dx \
$(COCOS2DX_ROOT)/cocos2dx/include \
$(COCOS2DX_ROOT)/cocos2dx/platform/android \
$(COCOS2DX_ROOT)/cocos2dx/kazmath/include \
$(COCOS2DX_ROOT)/cocos/2d \
$(COCOS2DX_ROOT)/cocos/2d/platform/android \
$(COCOS2DX_ROOT)/scripting/lua/cocos2dx_support \
$(COCOS2DX_ROOT)/scripting/lua/lua \
$(COCOS2DX_ROOT)/scripting/lua/tolua \

                                  
include $(BUILD_STATIC_LIBRARY)