/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptFix.h
Description: 
****************************************************************************/

#pragma once

#include "logic/BJMMoveLogic.h"
#include "logic/BJMScrollLogic.h"
#include "logic/BJMMultiplexLogic.h"
#include "logic/BJMLogic.h"
#include "tolua++.h"
#include "CCGeometry.h"
#include "util/BJMArray.h"
#include "util/BJMString.h"
#include "ccTypes.h"
#include "features/update/BJMUpdateLogic.h"
#include "features/http/BJMHttpLogic.h"

using namespace cocos2d;
using namespace BJMGui;
using namespace BJMUtil;

#define DECLARE_TO_USER_TYPE_FUNC(class_name)\
TOLUA_API void * toluafix_tousertype_##class_name(lua_State* L, int narg, void* def);

#define DECLARE_TO_USER_TYPE_FUNC2(class_name)\
TOLUA_API class_name toluafix_tousertype_##class_name(lua_State* L, int narg, void* def);

#define DECLARE_TO_USER_TYPE_FUNC3(class_name, return_type)\
TOLUA_API return_type toluafix_tousertype_##class_name(lua_State* L, int narg, void* def);

#define DECLARE_FIX_RET(class_name)\
TOLUA_API void toluafix_ret_##class_name(lua_State* L, const class_name & ret);

DECLARE_FIX_RET(Point)
DECLARE_FIX_RET(Size)
DECLARE_FIX_RET(Rect)
DECLARE_FIX_RET(Color4F)
DECLARE_FIX_RET(Color3B)

TOLUA_API void toluafix_ret_table(lua_State* L, const int ref);

TOLUA_API int toluafix_BJM_totable(lua_State* L, int lo, int def);

TOLUA_API int toluafix_get_totable(lua_State* L, int lo, int def);

TOLUA_API void toluafix_unref_table(lua_State* L, const int ref);

TOLUA_API void toluafix_ret_ArrayString(lua_State* L, const BJMArray<BJMString> & arr);

DECLARE_TO_USER_TYPE_FUNC(BJMLogic)
DECLARE_TO_USER_TYPE_FUNC(BJMMoveLogic)
DECLARE_TO_USER_TYPE_FUNC(BJMMultiplexLogic)
DECLARE_TO_USER_TYPE_FUNC(BJMScrollLogic)
DECLARE_TO_USER_TYPE_FUNC(BJMUpdateLogic)
DECLARE_TO_USER_TYPE_FUNC(BJMHttpLogic)
DECLARE_TO_USER_TYPE_FUNC2(Point)
DECLARE_TO_USER_TYPE_FUNC2(Size)
DECLARE_TO_USER_TYPE_FUNC2(Rect)
DECLARE_TO_USER_TYPE_FUNC2(Color4F)
DECLARE_TO_USER_TYPE_FUNC2(Color3B)

DECLARE_TO_USER_TYPE_FUNC3(ArrayString, BJMArray<BJMString>)