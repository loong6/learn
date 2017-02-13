/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaExecuteHandler.h
Description: 
****************************************************************************/

#pragma once

#include "util/BJMString.h"

namespace BJMScript
{

class BJMLuaExecuteHandler
{
public:
	/*************************
	execute lua func which returns a light userdata on stack
	/*************************/
	static int ExecuteLuaFuncRetUserdata(const int nHandler, const BJMUtil::BJMString & strClassName);

};


} // namespace BJMScript