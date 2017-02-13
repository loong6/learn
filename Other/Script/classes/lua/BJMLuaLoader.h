/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaLoader.h
Description: 
****************************************************************************/

#pragma once

extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

extern int BJMLuaLoader(lua_State *L);

}

