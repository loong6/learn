LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := bjmscript_static
LOCAL_MODULE_FILENAME := libbjmscript

LOCAL_SRC_FILES := \
BJMScriptFactory.cpp \
BJMScriptServer.cpp \
lua/BJMLuaExecuteHandler.cpp \
lua/BJMLuaFactory.cpp \
lua/BJMLuaLoader.cpp \
lua/BJMLuaServer.cpp \
lua/BJMLuaUtil.cpp \
lua/BJMScriptFix.cpp \
lua/BJMScriptTypeConversion.cpp \
precompile/BJMScriptPrecompiled.cpp \

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
$(EngineRoot)cocos \
 $(EngineRoot)cocos/base \
 $(EngineRoot)cocos/editor-support \
 $(EngineRoot)cocos/editor-support/cocosbuilder \
 $(EngineRoot)cocos/editor-support/cocostudio \
 $(EngineRoot)cocos/editor-support/cocostudio/WidgetReader \
 $(EngineRoot)cocos/editor-support/spine \
 $(EngineRoot)cocos/network \
 $(EngineRoot)cocos/scripting \
 $(EngineRoot)cocos/scripting/lua-bindings \
 $(EngineRoot)cocos/scripting/lua-bindings/auto \
 $(EngineRoot)cocos/scripting/lua-bindings/manual \
 $(EngineRoot)cocos/storage/local-storage \
 $(EngineRoot)cocos/ui \
 $(EngineRoot)cocos/math \
 $(EngineRoot)cocos/2d \
 $(EngineRoot)cocos/3d \
 $(EngineRoot)external \
 $(EngineRoot)external/ConvertUTF \
 $(EngineRoot)external/edtaa \
 $(EngineRoot)external/tinyxml2 \
 $(EngineRoot)external/unzip \
 $(EngineRoot)external/xxhash \
 $(EngineRoot)cocos/physics \
 $(EngineRoot)cocos/renderer \
 $(EngineRoot)cocos/platform/android \
 $(EngineRoot)cocos/platform/desktop \
 $(EngineRoot)external/glfw3/include/android \
 $(EngineRoot)external/android-specific/gles/include/OGLES \
 $(EngineRoot)external/lua/luajit/include \
 $(EngineRoot)external/lua/tolua \
 $(EngineRoot)external/lua/luasocket \
$(COCOS2D_HOME_3)/BJMEngine/BJMFoundation/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMSerialization/classes \
 $(COCOS2D_HOME_3)/; \
 $(COCOS2D_HOME_3)/BJMEngine/BJMApp/classes \
 $(COCOS2D_HOME_3)/BJMSDK/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMPublish/classes \
 $(COCOS2D_HOME_3)/BJMPackage/BJMPackageTool/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMGui/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMScript/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMGame/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMExtLibs/classes \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/OpenAL32/Include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/mob/Include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/build_android \
 $(COCOS2D_HOME_3)/BJMEngine/BJMResource/classes \
 $(COCOS2D_HOME_3)/BJMPackage/stormlib/src \
 $(COCOS2D_HOME_3)/BJMEngine/BJMProfile/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMSound/classes \
 $(COCOS2D_HOME_3)/cocos2d/external/curl/include/android \
 $(COCOS2D_HOME_3)/BJMCommon


LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH) \
$(COCOS2D_HOME_3)/BJMEngine/BJMFoundation/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMSerialization/classes \
 $(COCOS2D_HOME_3)/; \
 $(COCOS2D_HOME_3)/BJMEngine/BJMApp/classes \
 $(COCOS2D_HOME_3)/BJMSDK/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMPublish/classes \
 $(COCOS2D_HOME_3)/BJMPackage/BJMPackageTool/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMGui/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMScript/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMGame/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMExtLibs/classes \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/OpenAL32/Include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/mob/Include \
 $(COCOS2D_HOME_3)/BJMEngine/OpenAL_Mob/build_android \
 $(COCOS2D_HOME_3)/BJMEngine/BJMResource/classes \
 $(COCOS2D_HOME_3)/BJMPackage/stormlib/src \
 $(COCOS2D_HOME_3)/BJMEngine/BJMProfile/classes \
 $(COCOS2D_HOME_3)/BJMEngine/BJMSound/classes \
 $(COCOS2D_HOME_3)/cocos2d/external/curl/include/android \
 $(COCOS2D_HOME_3)/BJMCommon


include $(BUILD_STATIC_LIBRARY)
