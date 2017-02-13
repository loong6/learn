/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMScriptFactory.h
Description: 
****************************************************************************/

#pragma once

#include "util/BJMString.h"
#include "CCRef.h"

namespace BJMScript
{
using namespace BJMUtil;

class BJMScriptFactory
{
public:
	/*************************
	constructor
	/*************************/
	BJMScriptFactory();

	/*************************
	destructor
	/*************************/
	virtual ~BJMScriptFactory();

	/*************************
	add a script creator handler
	/*************************/
	virtual void RegisterCreatorHandler(int nCreatorHandler) = 0;

	/*************************
	create object
	/*************************/
	virtual long CreateObj(const BJMString & strClassName) = 0;
};


} // namespace BJMScript