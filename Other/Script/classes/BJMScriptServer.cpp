/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptServer.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"
#include "BJMScriptServer.h"

namespace BJMScript
{
static BJMScriptServer * s_pScriptServer = NULL;

//------------------------------------------------------------------------------
/**
*/
BJMScriptServer::BJMScriptServer()
{

}

//------------------------------------------------------------------------------
/**
*/
BJMScriptServer::~BJMScriptServer()
{

}

//------------------------------------------------------------------------------
/**
*/
BJMScriptServer * BJMScriptServer::Instance()
{
	n_assert(s_pScriptServer);
	return s_pScriptServer;
}

//------------------------------------------------------------------------------
/**
*/
bool BJMScriptServer::HasInstance()
{
	if (s_pScriptServer)
	{
		return true;
	}

	return false;
}

//------------------------------------------------------------------------------
/**
*/
void BJMScriptServer::Destroy()
{
	n_assert(s_pScriptServer);

	if (s_pScriptServer)
	{
		n_delete(s_pScriptServer);
		s_pScriptServer = NULL;
	}
}

//------------------------------------------------------------------------------
/**
*/
void BJMScriptServer::SetInstance(BJMScriptServer * pInstance)
{
	n_assert(!s_pScriptServer);

	s_pScriptServer = pInstance;
}


} // namespace BJMScript