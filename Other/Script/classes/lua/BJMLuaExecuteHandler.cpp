/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaExecuteHandler.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMLuaExecuteHandler.h"
#include "CCLuaEngine.h"

namespace BJMScript
{

using namespace cocos2d;
using namespace BJMUtil;

////------------------------------------------------------------------------------
///**
//*/
int BJMLuaExecuteHandler::ExecuteLuaFuncRetUserdata(const int nHandler, const BJMString & strClassName)
{
	n_assert(LuaEngine::getInstance()->getLuaStack());

	LuaStack * pStack = LuaEngine::getInstance()->getLuaStack();
	if (!pStack) return NULL;

	pStack->pushString(strClassName.AsCharPtr(), strClassName.Length());
	return pStack->executeFunctionByHandler(nHandler, 1);
}


}