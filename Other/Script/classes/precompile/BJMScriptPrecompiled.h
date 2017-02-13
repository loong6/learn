#pragma once

#include "core/BJMPlatformConfig.h"

#include "core/BJMConfig.h"

#if BJM_TARGET_PLATFORM == BJM_PLATFORM_WIN32
#include "core/win32/BJMPrecompiled.h"
#include "core/BJMFoundationHeaders.h"
extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}
//#include "CCLuaEngine.h"
//#include "CCLuaStack.h"
//#include "tolua_fix.h"
//#include "BJMSerializationPrecompiled.h"
//#include "gui/BJMNode.h"
//#include "logic/BJMLogic.h"
#elif BJM_TARGET_PLATFORM == BJM_PLATFORM_ANDROID
#include "core/android/BJMPrecompiled.h"
#elif BJM_TARGET_PLATFORM == BJM_PLATFORM_IOS
#include "core/ios/BJMPrecompiled.h"
#else
#error "BJMPrecompiled.h not implemented on this platform"
#endif

