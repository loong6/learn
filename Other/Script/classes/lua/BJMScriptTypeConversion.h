/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptTypeConversion.h
Description: 
****************************************************************************/

#pragma once

#include "util/BJMArray.h"
#include "util/BJMString.h"

#include "tolua++.h"

#include <list>

namespace BJMGui
{
class BJMNode;
}

namespace BJMScript
{
using namespace BJMUtil;
using namespace BJMGui;

extern bool luaval_to_BJMArray_BJMString(lua_State* L, int lo, BJMArray<BJMString> & ary);
extern bool list_BJMNode_to_lua_table(lua_State* L, const std::list<BJMNode *> & listNodes);


} // namespace BJMScript