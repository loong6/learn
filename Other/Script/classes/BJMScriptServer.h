/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptServer.h
Description: 
****************************************************************************/

#pragma once

#include "core/BJMRefCounted.h"
#include "util/BJMString.h"
#include "io/BJMURI.h"
#include "BJMScriptDefine.h"
#include "core/BJMSingleton.h"
#include "BJMScriptFactory.h"
#include "CCGeometry.h"

#include "CCRef.h"

extern "C" {
#include "lua.h"
}

namespace BJMScript
{

using namespace BJMIO;
using namespace BJMUtil;

class BJMScriptServer
{
public:
	/*************************
	constructor
	/*************************/
	BJMScriptServer();

	/*************************
	destructor
	/*************************/
	virtual ~BJMScriptServer();

	/*************************
	get instance
	/*************************/
	static BJMScriptServer * Instance();

	/*************************
	has instance
	/*************************/
	static bool HasInstance();

	/*************************
	destroy instance
	/*************************/
	static void Destroy();

	/*************************
	set instancfe
	/*************************/
	static void SetInstance(BJMScriptServer * pInstance);

	/*************************
	initialize script server
	/*************************/
	virtual void Open(OpenLibFunc func) = 0;

	/*************************
	check is open
	/*************************/
	virtual bool IsOpen() = 0;

	/*************************
	close script server
	/*************************/
	virtual void Close(void) = 0;

	/*************************
	execute script file
	/*************************/
	virtual bool ExecuteScriptFile(const BJMURI & uri) = 0;

	/*************************
	add new path
	/*************************/
	virtual void AddPath(const BJMURI & uri) = 0;

	/*************************
	get lua state
	/*************************/
	virtual lua_State * GetLuaState() = 0;

	/*************************
	get script object factory
	/*************************/
	virtual BJMScriptFactory * GetScriptFactory() = 0;

	/*************************
	create a script object by class name
	/*************************/
	virtual long CreateScriptObjectByClassName(const BJMString & strClassName) = 0;

	/*************************
	load script module
	/*************************/
	virtual void LoadScriptModule(const BJMString & strScriptModulePath) = 0;

	/*************************
	unload script module
	/*************************/
	virtual void UnloadScriptModule(const BJMString & strScriptModulePath) = 0;

	/*************************
	reload script module
	/*************************/
	virtual void ReloadScriptModule(const BJMString & strScriptModulePath) = 0;

	/*************************
	check is script module loaded
	/*************************/
	virtual bool IsScriptModuleLoaded(const BJMString & strScriptModulePath) = 0;

	/*************************
	unregister script function
	/*************************/
	virtual void UnRegisterScriptFunc(const int nScriptFunc) = 0;

	/*************************
	push CCObject param
	/*************************/
	virtual void PushCCObject(cocos2d::Ref * pCCObject, const BJMString & strClassType) = 0;

	/*************************
	execute script function
	/*************************/
	virtual long ExecuteFunction(const int nScriptHandler, const int nArgs) = 0;

	/*************************
	execute script function
	/*************************/
	virtual BJMString ExecuteFunctionRetString(const int nScriptHandler, const int nArgs) = 0;

	/*************************
	push string param
	/*************************/
	virtual void PushString(const BJMString & strParam) = 0;

	/*************************
	push int param
	/*************************/
	virtual void PushInt(const int nParam) = 0;

	/*************************
	push float param
	/*************************/
	virtual void PushFloat(const float fParam) = 0;

	/*************************
	push bool param
	/*************************/
	virtual void PushBool(const bool bParam) = 0;

	/*************************
	unref a script data
	/*************************/
	virtual void UnRefScriptData(const int nScriptData) = 0;

	/*************************
	push point
	/*************************/
	virtual void PushPoint(const cocos2d::Point & ptPos) = 0;

	/*************************
	push rect
	/*************************/
	virtual void PushRect(const cocos2d::Rect & rect) = 0;

	/*************************
	push a script data
	/*************************/
	virtual void PushScriptData(const int nScriptData) = 0;

	/*************************
	get memory used
	/*************************/
	virtual int GetMemoryUsed() = 0;

	/*************************
	do garbage collection
	/*************************/
	virtual void CollectGarbage() = 0;

	/*************************
	get track stack
	/*************************/
	virtual void AppendDebugTrace() = 0;
};


} // namespace BJMScript