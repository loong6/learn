/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaFactory.h
Description: 
****************************************************************************/

#pragma once

#include "BJMScriptFactory.h"
#include "util/BJMDictionary.h"

namespace BJMScript
{

using namespace BJMUtil;

class BJMLuaFactory : public BJMScriptFactory
{
public:
	/*************************
	constructor
	/*************************/
	BJMLuaFactory();

	/*************************
	destructor
	/*************************/
	virtual ~BJMLuaFactory();

	/*************************
	add a script creator handler
	/*************************/
	virtual void RegisterCreatorHandler(int nCreatorHandler) override;

	/*************************
	create object
	/*************************/
	virtual long CreateObj(const BJMString & strClassName) override;

protected:
	int m_nCreatorHandler;
};

//------------------------------------------------------------------------------
/**
*/
inline void BJMLuaFactory::RegisterCreatorHandler(int nCreatorHandler)
{
	m_nCreatorHandler = nCreatorHandler;
}

} // namespace BJMScript
