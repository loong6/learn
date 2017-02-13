/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptTypeConversion.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMScriptTypeConversion.h"
#include "LuaBasicConversions.h"
#include "gui/BJMNode.h"

namespace BJMScript
{

bool luaval_to_BJMArray_BJMString(lua_State* L, int lo, BJMArray<BJMString> & ary)
{
	if (NULL == L)
		return false;

	tolua_Error tolua_err;

	if (!tolua_istable(L, lo, 0, &tolua_err) )
	{
#if BJM_DEBUG >=1
		luaval_to_native_err(L,"#ferror:",&tolua_err);
#endif
		lua_pop(L, 1);
		return false;
	}

	size_t len = lua_objlen(L, lo);
	if (len > 0)
	{
		for (uint32_t i = 0; i < len; ++i)
		{
			lua_pushnumber(L,i + 1);
			lua_gettable(L,lo);
			if (!tolua_isstring(L,-1, 0, &tolua_err))
			{
#if BJM_DEBUG >=1
				luaval_to_native_err(L,"#ferror:",&tolua_err);
#endif
				lua_pop(L, 1);
				return false;
			}

			const char * szVal = tolua_tostring(L, -1, NULL);
			ary.Append(szVal);
			lua_pop(L, 1);
		}
	}

	return true;
}

//------------------------------------------------------------------------------
/**
*/
bool list_BJMNode_to_lua_table(lua_State* L, const std::list<BJMNode *> & listNodes)
{
	lua_newtable(L);

	int nIndex = 1;
	for (auto iter = listNodes.begin(); iter != listNodes.end(); ++iter)
	{
		lua_pushnumber(L, (lua_Number)nIndex);   
		cocos2d::Ref * pRef = dynamic_cast<cocos2d::Ref *>(*iter);
		int nID = (pRef) ? (int)pRef->_ID : -1;
		int* pLuaID = (pRef) ? &pRef->_luaID : NULL;
		toluafix_pushusertype_ccobject(L, nID, pLuaID, (void*)pRef, "BJMNode");
		lua_rawset(L, -3);
		++nIndex;
	}

	return true;
}

} // namespace BJMScript