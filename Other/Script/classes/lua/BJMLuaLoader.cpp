/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaLoader.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMLuaLoader.h"
#include "util/BJMString.h"
#include "BJMCommonDefine.h"
#include "BJMLuaUtil.h"
#include <string>
#include "framework/BJMConfiguration.h"
#include "io/BJMURI.h"
#include "io/BJMIOServer.h"
#include "io/BJMIOInterfaceUtil.h"

using namespace BJMUtil;

extern "C"
{
//------------------------------------------------------------------------------
/**
*/
int BJMLuaLoader(lua_State *L)
{
	BJMString strFileName(luaL_checkstring(L, 1));
	
	strFileName.ReplaceChars(".", '/');
	strFileName += ".lua";

	bool bUsePackage = BJMApp::BJMConfiguration::Instance()->GetUsePackage();

	BJMString strFilePath;

	if (strFileName.FindStringIndex("cocos2d/") != InvalidIndex ||
		strFileName.FindStringIndex("bjm/") != InvalidIndex)
	{
		// is cocos2d or bjm lua file	
		if (bUsePackage)
		{
			// ie. res/cn/script/...
			strFilePath = CAT_PATH(PATH_GAME_RES_HOME, BJMString("script/") + strFileName);
		}
		else
		{
			// ie. bjmframework/lua/...
			strFilePath = CAT_PATH(PATH_SCRIPT_FRAMEWORK_HOME, strFileName);
		}
	}
	else
	{
		// is game lua file
		// ie. res/cn/script/...
		strFilePath = CAT_PATH(PATH_GAME_RES_HOME, BJMString("script/") + strFileName);
	}

	unsigned long ulFileSize = 0;
	void * szBuf = BJMIO::BJMIoInterfaceUtil::ReadFile(strFilePath.AsCharPtr(), ulFileSize);
	if (szBuf != NULL)
	{
		// use local path for better debugger support
		BJMIO::BJMURI uriFile = strFilePath;
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_WIN32
		//win32 use full path for debugger
		if (luaL_loadbuffer(L, (char*)szBuf, ulFileSize, uriFile.GetHostAndLocalPath().AsCharPtr()) != 0)
#else
		//ios use virtual path for crash report
		if (luaL_loadbuffer(L, (char*)szBuf, ulFileSize, uriFile.GetOriginalPath().AsCharPtr()) != 0)
#endif
		{
			n_warning("Lua Error: loading module %s from file %s :\n\t%s",
				lua_tostring(L, 1), strFileName.AsCharPtr(), lua_tostring(L, -1));
			/*luaL_error(L, "error loading module %s from file %s :\n\t%s",
				lua_tostring(L, 1), strFileName.AsCharPtr(), lua_tostring(L, -1));*/
		}
		else
		{
			//n_warning("success to load lua file: %s\n", strFilePath.AsCharPtr());
		}
	}
	else
	{
		n_warning("can not get file data of %s\n", strFilePath.AsCharPtr());
	}
	if (szBuf)
	{
		free(szBuf);
	}
	return 1;
}

}