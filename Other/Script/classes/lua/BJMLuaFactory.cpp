/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaFactory.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMLuaFactory.h"
#include "BJMScriptServer.h"

namespace BJMScript
{

//------------------------------------------------------------------------------
/**
*/
BJMLuaFactory::BJMLuaFactory()
	:m_nCreatorHandler(0)
{

}

//------------------------------------------------------------------------------
/**
*/
BJMLuaFactory::~BJMLuaFactory()
{

}

//------------------------------------------------------------------------------
/**
*/
long BJMLuaFactory::CreateObj(const BJMString & strClassName)
{
	n_assert(m_nCreatorHandler != 0);
	if (m_nCreatorHandler == 0)
	{
		n_error("Lua Creator Handler is invalid(0).");
		return NULL;
	}

	BJMScriptServer::Instance()->PushString(strClassName);
	return BJMScriptServer::Instance()->ExecuteFunction(m_nCreatorHandler, 1);
}


} // namespace BJMScript
