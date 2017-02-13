/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaServer
Description: 
****************************************************************************/

#pragma once

#include "core/BJMRefCounted.h"
#include "BJMScriptServer.h"

#include "CCLuaStack.h"
#include "util/BJMDictionary.h"
#include "CCLuaEngine.h"
#include "tolua_fix.h"

namespace BJMScript
{

class BJMLuaServer : public BJMScriptServer
{
public:
	/*************************
	constructor
	/*************************/
	BJMLuaServer();

	/*************************
	destructor
	/*************************/
	~BJMLuaServer();

	/*************************
	initialize script server
	/*************************/
	virtual void Open(OpenLibFunc func) override;

	/*************************
	check is open
	/*************************/
	inline virtual bool IsOpen() override;

	/*************************
	close script server
	/*************************/
	virtual void Close(void) override;

	/*************************
	execute script file
	/*************************/
	virtual bool ExecuteScriptFile(const BJMURI & uri) override;

	/*************************
	add new path
	/*************************/
	virtual void AddPath(const BJMURI & uri) override;

	/*************************
	get lua state
	/*************************/
	virtual lua_State * GetLuaState() override;

	/*************************
	create a script object by class name
	/*************************/
	virtual long CreateScriptObjectByClassName(const BJMString & strClassName) override;

	/*************************
	get script factory
	/*************************/
	virtual BJMScriptFactory * GetScriptFactory() override;

	/*************************
	load script module
	/*************************/
	virtual void LoadScriptModule(const BJMString & strScriptModulePath) override;

	/*************************
	unload script module
	/*************************/
	virtual void UnloadScriptModule(const BJMString & strScriptModulePath) override;

	/*************************
	reload script module
	/*************************/
	virtual void ReloadScriptModule(const BJMString & strScriptModulePath) override;

	/*************************
	check is script module loaded
	/*************************/
	virtual bool IsScriptModuleLoaded(const BJMString & strScriptModulePath) override;

	/*************************
	unregister script function
	/*************************/
	virtual void UnRegisterScriptFunc(const int nScriptFunc) override;

	/*************************
	push ccobject param
	/*************************/
	virtual void PushCCObject(cocos2d::Ref * pCCObject, const BJMString & strClassType) override;

	/*************************
	execute script function
	/*************************/
	virtual long ExecuteFunction(const int nScriptHandler, const int nArgs) override;

	/*************************
	execute script function
	/*************************/
	virtual BJMString ExecuteFunctionRetString(const int nScriptHandler, const int nArgs) override;

	/*************************
	push string param
	/*************************/
	virtual void PushString(const BJMString & strParam) override;

	/*************************
	push int param
	/*************************/
	virtual void PushInt(const int nParam) override;

	/*************************
	push float param
	/*************************/
	virtual void PushFloat(const float fParam) override;

	/*************************
	push bool param
	/*************************/
	virtual void PushBool(const bool bParam) override;

	/*************************
	push point
	/*************************/
	virtual void PushPoint(const cocos2d::Point & ptPos) override;

	/*************************
	push rect
	/*************************/
	virtual void PushRect(const cocos2d::Rect & rect) override;

	/*************************
	unref a script data
	/*************************/
	virtual void UnRefScriptData(const int nScriptData) override;

	/*************************
	push script data
	/*************************/
	virtual void PushScriptData(const int nScriptData) override;

	/*************************
	get memory used
	/*************************/
	virtual int GetMemoryUsed() override;

	/*************************
	collect garbage
	/*************************/
	virtual void CollectGarbage() override;

	/*************************
	debug trace
	/*************************/
	virtual void AppendDebugTrace() override;

protected:
	/*************************
	get lua stack
	/*************************/
	cocos2d::LuaStack * _GetLuaStack();

protected:
	/*************************
	server is opened
	/*************************/
	bool m_bIsOpen;

	/*************************
	script factory
	/*************************/
	BJMScriptFactory * m_pScriptFactory;
};

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaServer::IsOpen()
{
	return m_bIsOpen;
}

//------------------------------------------------------------------------------
/**
*/
inline cocos2d::LuaStack * BJMLuaServer::_GetLuaStack()
{
	return cocos2d::LuaEngine::getInstance()->getLuaStack();
}

} // namespace BJMScript