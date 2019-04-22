LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := bugly_crashreport_cocos_static

LOCAL_MODULE_FILENAME := libcrashreport

LOCAL_CPP_EXTENSION := .mm .cpp .cc
LOCAL_CFLAGS += -x c++

LOCAL_SRC_FILES := CrashReport.mm 

LOCAL_C_INCLUDES := $(LOCAL_PATH)\
$(LOCAL_PATH)/../ \
$(COCOS2DX_ROOT)\
$(COCOS2DX_ROOT)/ \
$(COCOS2DX_ROOT)/cocos/base \
$(COCOS2DX_ROOT)/cocos \
$(COCOS2DX_ROOT)/cocos/2d \
$(COCOS2DX_ROOT)/cocos/2d/platform/android \
$(COCOS2DX_ROOT)/cocos/platform/android \
$(COCOS2DX_ROOT)/cocos/math/kazmath \
$(COCOS2DX_ROOT)/cocos/physics \
$(COCOS2DX_ROOT)/cocos2dx \
$(COCOS2DX_ROOT)/cocos2dx/include \
$(COCOS2DX_ROOT)/cocos2dx/platform/android \
$(COCOS2DX_ROOT)/cocos2dx/kazmath/include \
$(COCOS2DX_ROOT)/external

include $(BUILD_STATIC_LIBRARY)