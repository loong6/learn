/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptFix.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMScriptFix.h"
#include "LuaBasicConversions.h"
#include "BJMScriptTypeConversion.h"

#define IMPL_TO_USER_TYPE_FUNC(class_name)\
TOLUA_API void * toluafix_tousertype_##class_name(lua_State* L, int narg, void* def)\
{\
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);\
	return dynamic_cast< ##class_name *>(pRef);\
}

TOLUA_API void * toluafix_tousertype_BJMLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMLogic *>(pRef);
}

TOLUA_API void * toluafix_tousertype_BJMUpdateLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMApp::BJMUpdateLogic *>(pRef);
}

TOLUA_API void * toluafix_tousertype_BJMHttpLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMApp::BJMHttpLogic *>(pRef);
}

TOLUA_API void * toluafix_tousertype_BJMMoveLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMMoveLogic *>(pRef);
}

TOLUA_API void * toluafix_tousertype_BJMScrollLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMScrollLogic *>(pRef);
}

TOLUA_API void * toluafix_tousertype_BJMMultiplexLogic(lua_State* L, int narg, void* def)
{
	cocos2d::Ref * pRef = (cocos2d::Ref *)tolua_tousertype(L, narg, def);
	return dynamic_cast< BJMMultiplexLogic *>(pRef);
}

TOLUA_API Point toluafix_tousertype_Point(lua_State* L, int narg, void* def)
{
	Point point;
	luaval_to_vec2(L,narg,&point);
	return point;
}

TOLUA_API Size toluafix_tousertype_Size(lua_State* L, int narg, void* def)
{
	Size size;
	luaval_to_size(L,narg,&size);
	return size;
}

TOLUA_API Rect toluafix_tousertype_Rect(lua_State* L, int narg, void* def)
{
	Rect rect;
	luaval_to_rect(L,narg,&rect);
	return rect;
}

TOLUA_API Color3B toluafix_tousertype_Color3B(lua_State* L, int narg, void* def)
{
	Color3B color;
	luaval_to_color3b(L,narg,&color);
	return color;
}

TOLUA_API Color4F toluafix_tousertype_Color4F(lua_State* L, int narg, void* def)
{
	Color4F color;
	luaval_to_color4f(L,narg,&color);
	return color;
}

TOLUA_API BJMArray<BJMString> toluafix_tousertype_ArrayString(lua_State* L, int narg, void* def)
{
	BJMArray<BJMString> ary;	
	BJMScript::luaval_to_BJMArray_BJMString(L, narg, ary);
	return ary;
}

TOLUA_API void toluafix_ret_ArrayString(lua_State* L, const BJMArray<BJMString> & arr)
{
	if (NULL  == L)
		return;
	lua_newtable(L);
	for (int i = 1; i <= arr.Size(); ++i)
	{
		lua_pushnumber(L, i);
		lua_pushstring(L, arr[i - 1].AsCharPtr());
		lua_rawset(L, -3);
	}
}

TOLUA_API void toluafix_ret_Point(lua_State* L, const Point & point)
{
	vec2_to_luaval(L, point);
}

TOLUA_API void toluafix_ret_Size(lua_State* L, const Size & size)
{
	size_to_luaval(L, size);
}

TOLUA_API void toluafix_ret_Rect(lua_State* L, const Rect & rect)
{
	rect_to_luaval(L, rect);
}

TOLUA_API void toluafix_ret_Color4F(lua_State* L, const Color4F & color4f)
{
	color4f_to_luaval(L, color4f);
}

TOLUA_API void toluafix_ret_Color3B(lua_State* L, const Color3B & color3b)
{
	color3b_to_luaval(L, color3b);
}

TOLUA_API int toluafix_BJM_totable(lua_State* L, int lo, int def)
{
	n_assert(lua_istable(L, lo));
	lua_pushvalue(L, lo);						// lo ... lo
	int ref = luaL_ref(L, LUA_REGISTRYINDEX);	
	lua_pushnumber(L, ref);						// lo ... ref
	lua_insert(L, lo);							// ref lo ...
	lua_remove(L, lo + 1);						// ref ...
	return ref;
}

TOLUA_API int toluafix_get_totable(lua_State* L, int lo, int def)
{
	n_assert(lua_istable(L, lo));
	
	return lo;
}

TOLUA_API void toluafix_ret_table(lua_State* L, const int ref)
{
	//lua_pop(L, 1);								// empty
	lua_rawgeti(L, LUA_REGISTRYINDEX, ref);		// table
	n_assert(lua_istable(L, -1));
}

TOLUA_API void toluafix_unref_table(lua_State* L, const int ref)
{
	luaL_unref(L, LUA_REGISTRYINDEX, ref);
}
