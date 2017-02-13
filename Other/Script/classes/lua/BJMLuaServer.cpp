/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaServer.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMLuaServer.h"
#include "BJMLuaFactory.h"
#include "lua/BJMScriptFix.h"
#include "LuaBasicConversions.h"
#include "BJMLuaLoader.h"
#include "BJMLuaUtil.h"
//#include "io/BJMIOServer.h"
#include "io/BJMIOInterfaceUtil.h"
#include "io/BJMLog.h"

namespace BJMScript
{
using namespace cocos2d;

//------------------------------------------------------------------------------
/**
*/
BJMLuaServer::BJMLuaServer()
:m_bIsOpen(false)
{
	m_pScriptFactory = n_new(BJMLuaFactory);

	LuaEngine* pEngine = LuaEngine::getInstance();
	ScriptEngineManager::getInstance()->setScriptEngine(pEngine);

	// add lua loader
	LuaStack * pStack = pEngine->getLuaStack();
	if (pStack)
	{
		pStack->addLuaLoader(BJMLuaLoader);
	}
}

//------------------------------------------------------------------------------
/**
*/
BJMLuaServer::~BJMLuaServer()
{
	if (m_pScriptFactory)
	{
		n_delete(m_pScriptFactory);
	}

	ScriptEngineManager::destroyInstance();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaServer::ExecuteScriptFile(const BJMURI & uri)
{
	BJMString strFilePath = uri.GetOriginalPath();
	
	unsigned long ulFileSize = 0;
	void * szBuf = BJMIO::BJMIoInterfaceUtil::ReadFile(strFilePath.AsCharPtr(), ulFileSize);
	lua_State * L = GetLuaState();
	if (szBuf && L)
	{
		if (luaL_loadbuffer(L, (char*)szBuf, ulFileSize, strFilePath.AsCharPtr()) 
			|| lua_pcall(L, 0, LUA_MULTRET, 0) != 0)
		{
			n_warning("error loading module %s from file %s :\n\t%s",
				lua_tostring(L, 1), strFilePath.AsCharPtr(), lua_tostring(L, -1));
			if (szBuf)
			{
				free(szBuf);
			}
			return false;
		}
	}
	if (szBuf)
	{
		free(szBuf);
	}
	return true;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::Open(OpenLibFunc func)
{
	n_assert(!m_bIsOpen);

	if (m_bIsOpen) return;

	if (func)
	{
		func();
	}
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::Close(void)
{
	n_assert(m_bIsOpen);

	if (!m_bIsOpen) return;
}

//------------------------------------------------------------------------------
/**
*/
lua_State * BJMLuaServer::GetLuaState()
{
	LuaStack * pStack = LuaEngine::getInstance()->getLuaStack();
	if (!pStack) return NULL;
	return pStack->getLuaState();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::AddPath(const BJMURI & uri)
{
	LuaEngine::getInstance()->addSearchPath(uri.GetHostAndLocalPath().AsCharPtr());
}

//------------------------------------------------------------------------------
/**
*/
long BJMLuaServer::CreateScriptObjectByClassName(const BJMString & strClassName)
{
	n_assert(m_pScriptFactory);
	if (!m_pScriptFactory) return NULL;
	return m_pScriptFactory->CreateObj(strClassName);
}

//------------------------------------------------------------------------------
/**
*/
BJMScriptFactory * BJMLuaServer::GetScriptFactory()
{
	return m_pScriptFactory;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::LoadScriptModule(const BJMString & strScriptModulePath)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	char szCode[200];
	sprintf(szCode, "require \"%s\"", strScriptModulePath.AsCharPtr());

	pStack->executeString(szCode);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::UnloadScriptModule(const BJMString & strScriptModulePath)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	char szCode[200];
	sprintf(szCode, "bjm.util.UnloadModule(\"%s\")",strScriptModulePath.AsCharPtr());
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::ReloadScriptModule(const BJMString & strScriptModulePath)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->reload(strScriptModulePath.AsCharPtr());
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaServer::IsScriptModuleLoaded(const BJMString & strScriptModulePath)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return false;

	char szCode[200];
	sprintf(szCode, "do return bjm.util.IsModuleLoaded(\"%s\") end",strScriptModulePath.AsCharPtr());

	bool bRet = (pStack->executeString(szCode) == 1);
	return bRet;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::UnRegisterScriptFunc(const int nScriptFunc)
{
	if (nScriptFunc != 0)
	{
		LuaStack * pStack = _GetLuaStack();
		n_assert(pStack);
		if (!pStack) return;

		pStack->removeScriptHandler(nScriptFunc);
	}

}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushCCObject(cocos2d::Ref * pCCObject, const BJMString & strClassType)
{
	if (!pCCObject) return;

	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->pushObject(pCCObject, strClassType.AsCharPtr());
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushString(const BJMString & strParam)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->pushString(strParam.AsCharPtr());
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushInt(const int nParam)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->pushInt(nParam);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushFloat(const float fParam)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->pushFloat(fParam);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushBool(const bool bParam)
{
	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return;

	pStack->pushBoolean(bParam);
}

//------------------------------------------------------------------------------
/**
*/
long BJMLuaServer::ExecuteFunction(const int nScriptHandler, const int nArgs)
{
	if (nScriptHandler == 0) return 0;

	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return 0;

	return pStack->executeFunctionByHandler(nScriptHandler, nArgs);
}

//------------------------------------------------------------------------------
/**
*/
BJMString BJMLuaServer::ExecuteFunctionRetString(const int nScriptHandler, const int nArgs)
{
	if (nScriptHandler == 0) return "";

	LuaStack * pStack = _GetLuaStack();
	n_assert(pStack);
	if (!pStack) return "";

	return pStack->executeFunctionByHandlerRetString(nScriptHandler, nArgs).c_str();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::UnRefScriptData(const int nScriptData)
{
	lua_State * pState = GetLuaState();
	toluafix_unref_table(pState, nScriptData);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushPoint(const cocos2d::Point & ptPos)
{
	lua_State * pState = GetLuaState();
	vec2_to_luaval(pState, ptPos);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushRect(const cocos2d::Rect & rect)
{
	lua_State * pState = GetLuaState();
	rect_to_luaval(pState, rect);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::PushScriptData(const int nScriptData)
{
	lua_State * pState = GetLuaState();
	lua_rawgeti(pState, LUA_REGISTRYINDEX, nScriptData);		// table
	n_assert(lua_istable(pState, -1));
}

//------------------------------------------------------------------------------
/**
*/
int BJMLuaServer::GetMemoryUsed()
{
	lua_State * pState = GetLuaState();
	int nKbytes = lua_gc(pState, LUA_GCCOUNT, 0);
	return nKbytes;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::CollectGarbage()
{
	lua_State * pState = GetLuaState();
	int nKbytes = lua_gc(pState, LUA_GCCOLLECT, 0);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaServer::AppendDebugTrace()
{
	lua_State * pState = GetLuaState();
	lua_getglobal(pState, "debug");  
	lua_getfield(pState, -1, "traceback");  
	int iError = lua_pcall(pState, 0, 1, 0);   
	const char* sz = lua_tostring(pState, -1);
	BJMIO::BJMLog::Append(sz);
}

} // namespace BJMScript