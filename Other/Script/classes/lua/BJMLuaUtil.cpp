/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaUtil.cpp
Description: 
****************************************************************************/

#include "precompile/BJMScriptPrecompiled.h"

#include "BJMLuaUtil.h"
#include "io/BJMURI.h"
#include "util/BJMString.h"
#include "BJMScriptServer.h"
#include "BJMScriptFactory.h"
#include "io/BJMIOServer.h"
#include "server/BJMGuiServer.h"
#include "notification/BJMNotificationServer.h"
#include "BJMGuiDefine.h"
#include "BJMCommonDefine.h"
#include "BJMXmlSerializeServer.h"
#include "io/BJMStream.h"
#include "memory/BJMMemory.h"
#include "util/BJMDeviceUtil.h"
#include "framework/BJMAppApplication.h"
#include "util/BJMGuiUtil.h"
#include "util/BJMMd5.h"
#include "io/zip/BJMZipUtil.h"
#include "CCGLProgramCache.h"
#include "util/BJMDate.h"
#include <curl/curl.h>
#include "io/BJMLog.h"
//#include "features/crash/BJMCrashServer.h"
#include "platform/CCCommon.h"
#include "io/BJMIOInterfaceUtil.h"
#include "http/BJMHttpUtil.h"
#include "features/update/BJMUpdateUtil.h"

namespace BJMScript
{

using namespace BJMGui;
using namespace BJMIO;
using namespace BJMUtil;

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::AddSearchPath(const char * szPathUri)
{
	BJMURI uri(szPathUri);
	BJMScriptServer::Instance()->AddPath(uri);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::RegisterCreatorHandler(int nCreatorHandler)
{
	BJMScriptFactory * pScriptFactory = BJMScriptServer::Instance()->GetScriptFactory();
	if (pScriptFactory)
	{
		pScriptFactory->RegisterCreatorHandler(nCreatorHandler);
	}
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::ReadFile(const char * uri)
{
	return BJMIoInterfaceUtil::ReadFileAsString(uri).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::ReadFileFromFileSystem(const char * uri)
{
	return BJMIoInterfaceUtil::ReadFileFromFileSystemAsString(uri).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::WriteFile(const char * uri, const char * szFileContent)
{
	return BJMIoInterfaceUtil::WriteFileAsString(uri, szFileContent);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::WriteFileAsync(const char * uri, const char * szFileContent)
{
	BJMIoInterfaceUtil::WriteFileAsStringAsync(uri, szFileContent);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::CopyFile_(const char * fromUri, const char * toUri)
{
	return BJMIoInterfaceUtil::CopyFile(fromUri, toUri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::CopyFileFileSystem(const char * fromUri, const char * toUri)
{
	return BJMIoInterfaceUtil::CopyFileFileSystem(fromUri, toUri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::DeleteFile_(const char * uri)
{
	return BJMIoInterfaceUtil::DeleteFile_(uri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::FileExists(const char * uri)
{
	return BJMIoInterfaceUtil::FileExists(uri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::FileExistsFileSystem(const char * uri)
{
	return BJMIoServer::FileExistsFileSystem(uri);
}

//------------------------------------------------------------------------------
/**
*/
BJMUtil::BJMArray<BJMUtil::BJMString> BJMLuaUtil::ListFiles(const char * uri, const char* pattern, bool asFullPath)
{
	return BJMIoInterfaceUtil::ListFiles(uri, pattern, asFullPath);
}

//------------------------------------------------------------------------------
/**
*/
BJMUtil::BJMArray<BJMUtil::BJMString> BJMLuaUtil::ListDirectories(const char * uri, const char* pattern, bool asFullPath)
{
	return BJMIoInterfaceUtil::ListDirectories(uri, pattern, asFullPath);
}

//------------------------------------------------------------------------------
/**
*/
BJMUtil::BJMArray<BJMUtil::BJMString> BJMLuaUtil::ListFilesFileSystem(const char * uri, const char* pattern, bool asFullPath)
{
	return BJMIoInterfaceUtil::ListFilesFileSystem(uri, pattern, asFullPath);
}

//------------------------------------------------------------------------------
/**
*/
BJMUtil::BJMArray<BJMUtil::BJMString> BJMLuaUtil::ListDirectoriesFileSystem(const char * uri, const char* pattern, bool asFullPath)
{
	return BJMIoInterfaceUtil::ListDirectoriesFileSystem(uri, pattern, asFullPath);
}

//------------------------------------------------------------------------------
/**
*/
unsigned int BJMLuaUtil::ComputeFileCrc(const char * uri)
{
	return BJMIoInterfaceUtil::ComputeFileCrc(uri);
}


//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::AddPatch(const char* strFullPath)
{
	if (!strFullPath)
		return false;

	return BJMPackage::BJMPackageServer::Instance()->AddPatch(strFullPath);
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::RenameFile(const char * uri, const char * name)
{
	n_error("not implement yet!!");
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::CreateDirectory_(const char * uri)
{
	return BJMIoServer::CreateDirectory(uri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::DeleteDirectory(const char * uri)
{
	return BJMIoServer::DeleteDirectory(uri);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::DirectoryExists(const char * uri)
{
	return BJMIoServer::DirectoryExists(uri);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::RegisterGuiConfig(const char * szConfigName, const char * uri)
{
	BJMGui::BJMGuiServer::Instance()->RegisterConfig(szConfigName, uri);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::Assert(const bool bEvaluation, const char * szContent)
{
	if (!bEvaluation)
	{
		n_error(szContent);
	}	
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::PushNotification(
	BJMLogic * pLogic,
	const char * szNotificationName,
	const int nScriptObject)
{
	BJMPtr<BJMLogic> logic = pLogic;
	BJMNotify::BJMNotificationServer::Instance()->PushNotification_L(
		NotificationCustom,
		NotificationCustom,
		logic.upcast<BJMNotificationHandler>(),
		nScriptObject,
		szNotificationName);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::PushNotificationAtOnce(
	BJMLogic * pLogic,
	const char * szNotificationName,
	const int nScriptObject)
{
	BJMPtr<BJMLogic> logic = pLogic;
	BJMNotify::BJMNotificationServer::Instance()->PushNotificationAtOnce_L(
		NotificationCustom,
		NotificationCustom,
		logic.upcast<BJMNotificationHandler>(),
		nScriptObject,
		szNotificationName);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetSDKString(const char * szStringName)
{
	bool bFound;
	return BJMSerialize::BJMXmlSerializeServer::Instance()->GetString(szStringName, DataConfig_SdkString, bFound).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetGameString(const char * szStringName)
{
	bool bFound;
	return BJMSerialize::BJMXmlSerializeServer::Instance()->GetString(szStringName, CONFIG_GAME_STRING, bFound).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::UriToPath(const char * szUri)
{
	BJMIO::BJMURI uri(szUri);
	return uri.GetHostAndLocalPath().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::PathToUri(const char * szPath, const char * szPre)
{
	return BJMIO::BJMURI::GetUriFromRawPath(szPath, szPre).AsCharPtr();
}
    
//------------------------------------------------------------------------------
/**
 */
std::string BJMLuaUtil::GetStartupUrl()
{
    return BJMDeviceUtil::GetStartupUrl().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::Sleep(const unsigned int nMillsec)
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_WIN32
#if BJM_DEBUG >= 1
	::Sleep(nMillsec);
#endif
#else
	n_assert2(false, "Sleep only implemented on win32 platform and is only for debug usage!!!");
#endif	
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::CheckIsNetworkAvailable()
{
	return BJMDeviceUtil::CheckIsNetworkAvailable();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetNetworkType()
{
	return BJMDeviceUtil::GetNetworkType().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::IsLandscape()
{
	return BJMDeviceUtil::IsLandscape();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::OpenAppSettings()
{
#if BJM_TARGET_PLATFORM != BJM_PLATFORM_WIN32
	BJMDeviceUtil::OpenAppSettings();
#endif
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::ShowStatusBar(bool show)
{
#if BJM_TARGET_PLATFORM != BJM_PLATFORM_WIN32
	BJMDeviceUtil::ShowStatusBar(show);
#endif
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::IsAuthorized(const char* item)
{
	return BJMDeviceUtil::IsAuthorized(item);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetDeviceCode()
{
	return BJMDeviceUtil::GetDeviceCode().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetMac()
{
	return BJMDeviceUtil::GetMac().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetModel()
{
	return BJMDeviceUtil::GetModel().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetAppVersion()
{
	return BJMApp::BJMAppApplication::Instance()->GetAppVersion().ToString().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetSysVersion()
{
	return BJMDeviceUtil::GetSystemVersion().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetPhoneNumber()
{
	return BJMUtil::BJMDeviceUtil::GetPhoneNumber().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetResolution()
{
	cocos2d::Size size = BJMGui::BJMGuiUtil::GetResolutionSize();
	char szRet[200];
	sprintf(szRet, "%d*%d", (int)size.width, (int)size.height);
	return szRet;
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetOS()
{
	return BJMUtil::BJMDeviceUtil::GetOS().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::MakeMD5(const char * szContent)
{
	return BJMUtil::BJMMD5(szContent).ToString().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::MakeFileMD5(const char * szURI)
{
	unsigned long len = 0;
	void* data = BJMIoInterfaceUtil::ReadFileFromFileSystem(szURI, len);

	if (data)
	{
		BJMString md5 = BJMUtil::BJMMD5(data, len).ToString();

		free(data);

		return md5.AsCharPtr();
	}

	return "";
}

//------------------------------------------------------------------------------
/**
*/
//void BJMLuaUtil::UpdateApp(
//	const char * szURL, 
//	const bool bForceUpdate,
//	const char * szNewVersion)
//{
//	BJMUtil::BJMDeviceUtil::UpdateApp(szURL, bForceUpdate, szNewVersion);
//}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::OpenIE(const char * szURL)
{
	BJMUtil::BJMDeviceUtil::OpenIE(szURL, false);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::ForceUpdateApp(const char * szURL)
{
	BJMUtil::BJMDeviceUtil::OpenIE(szURL, true);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::Exit()
{
	BJMUtil::BJMDeviceUtil::Exit();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetPlugins()
{
	return BJMApp::BJMAppApplication::Instance()->GetPlugins().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseHor()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseHorizontal();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetChannel()
{
	return BJMApp::BJMAppApplication::Instance()->GetChannel().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetLocale()
{
	return BJMApp::BJMAppApplication::Instance()->GetLocale().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetXGParam()
{
	return BJMApp::BJMAppApplication::Instance()->GetXGParam().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetAppCode()
{
	return BJMApp::BJMAppApplication::Instance()->GetAppCode().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseSDK()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseSDK();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetOperator()
{
	return BJMApp::BJMAppApplication::Instance()->GetOperator().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseOffline()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseOffline();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseUpdate()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseUpdate();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseBulletin()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseBulletin();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetAppID()
{
	return BJMApp::BJMAppApplication::Instance()->GetAppID().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseTest()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseTest();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseInner()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseInner();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::GetUseCrashReport()
{
	return BJMApp::BJMAppApplication::Instance()->GetUseCrashReport();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SaveToFile(BJMNode * pNode, const char * szUri)
{
	BJMURI uri(szUri);
	BJMString strFullPath = uri.GetHostAndLocalPath();
	BJMGui::BJMGuiUtil::SaveToFile(pNode, strFullPath);
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::CaptureScreen(const char * szUri)
{
	BJMURI uri(szUri);
	BJMString strFullPath = uri.GetHostAndLocalPath();
	BJMGui::BJMGuiUtil::CaptureScreen(strFullPath);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::Restart()
{
	BJMApp::BJMAppApplication::Instance()->RestartInNextFrame();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::ResetAdaptType(const char * szAdaptType)
{
	BJMApp::BJMAppApplication::Instance()->ResetAdaptType(szAdaptType);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::DiscardUnusedResource(const int nType)
{
	BJMApp::BJMAppApplication::Instance()->DiscardUnreferencedResource((BJMCommon::MemoryType)nType);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::UnLoadUnusedResource(const int nType)
{
	BJMApp::BJMAppApplication::Instance()->UnLoadUnreferencedResource((BJMCommon::MemoryType)nType);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetUseLockWhenPush(const bool bUseLock)
{
	BJMNotify::BJMNotificationServer::Instance()->SetUseLockWhenPush(bUseLock);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::ReadFileFromFileSystemAsBase64(const char * szUri)
{
	return BJMIO::BJMIoServer::ReadFileFromFileSystemAsBase64(szUri).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
int BJMLuaUtil::HashCode(const char * szContent)
{
	return BJMString(szContent).HashCode();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::Unzip(const char * szZip, const char * szTo, const bool bFlat)
{
	return BJMIO::BJMZipUtil::Unzip(szZip, szTo, bFlat);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::TestCrash()
{
	int * a = NULL;
	*a = 1;
	//BJMApp::BJMCrashServer::Instance()->TestDump();
}

//------------------------------------------------------------------------------
/**
*/
unsigned long long BJMLuaUtil::DateToTimeStamp(const char * szDate, const char * szPattern)
{
	int nYear = 0, nMonth = 0, nDay = 0, nHours = 0, nMins = 0, nSecs = 0;
	sscanf(szDate, szPattern, &nYear, &nMonth, &nDay, &nHours, &nMins, &nSecs);
	BJMUtil::BJMDate date(nYear - 1900, nMonth - 1, nDay, nHours, nMins, nSecs);
	return date.GetUnixTimestamp();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::RunInAutoReleasePool(int nFunc)
{
	AutoreleasePool tmpPool("BJMLuaUtil_AutoReleasePool");

	BJMScript::BJMScriptServer * pScriptServer = BJMScript::BJMScriptServer::Instance();
	pScriptServer->ExecuteFunction(nFunc, 0);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::GetInstalledApps(const char* strAppList)
{
	BJMUtil::BJMDeviceUtil::GetInstalledApps(strAppList);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::HttpPost(const char* strConnName, const char* strUrl, const char* strPostData, int timeout)
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_WIN32
	BJMString ret;
	BJMHttp::BJMHttpUtil::QueryStringAsync(strConnName, strUrl, strPostData, "", ret);
#else
	BJMDeviceUtil::HttpPost(strConnName, strUrl, strPostData, timeout);
#endif
}


//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::OpenApp(const char * packageName, const char * activityName)
{
	return BJMUtil::BJMDeviceUtil::OpenApp(packageName, activityName);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::ExtractAppIcon(const char * packageName)
{
	BJMUtil::BJMDeviceUtil::ExtractAppIcon(packageName);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetPhoneContacts(const char * time)
{
	return BJMUtil::BJMDeviceUtil::GetPhoneContacts(time).AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::InstallApp(const char * filePath)
{
	BJMUtil::BJMDeviceUtil::InstallApp(filePath);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::CopyToClipboard(const char * str)
{
	BJMUtil::BJMDeviceUtil::CopyToClipboard(str);
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::QueryGpsLocation()
{
	BJMUtil::BJMDeviceUtil::QueryGpsLocation();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::QueryAPNSDeviceToken()
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_IOS
	BJMUtil::BJMDeviceUtil::QueryAPNSDeviceToken();
#endif
}
    
//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::IsAPNSEnabled()
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_IOS
	return BJMUtil::BJMDeviceUtil::IsAPNSEnabled();
#endif

	return false;
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetAppIconBadgeNumber(int num)
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_IOS
	BJMUtil::BJMDeviceUtil::SetAppIconBadgeNumber(num);
#endif
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SendSMS(const char* destPhone, const char* strMsg)
{
	BJMUtil::BJMDeviceUtil::SendSMS(destPhone, strMsg);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetAdaptType()
{
	return BJMApp::BJMAppApplication::Instance()->GetAdaptType().AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::EscapeUrl(const std::string & strFrom)
{
	std::string strRet;
	char *escape_content = curl_escape(strFrom.c_str(), strFrom.size()); 
	strRet = escape_content;
	curl_free(escape_content);  
	return strRet;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::AppendLog(const char * szLog)
{
	BJMIO::BJMLog::Append(szLog);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::DebugMessageBox(const char * title, const char * szContent)
{
#if BJM_DEBUG > 0
	cocos2d::MessageBox(szContent, title);
#endif
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::ReleaseMessageBox(const char * title, const char * szContent)
{
	cocos2d::MessageBox(szContent, title);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetupBasicConfig()
{
	BJMApp::BJMAppApplication::Instance()->SetupBasicConfig();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetBasicConfigValue(const char * key,const char * value)
{
	BJMApp::BJMAppApplication::Instance()->SetBasicConfigValue(key,value);
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::PatchBasicConfig()
{
	BJMApp::BJMAppApplication::Instance()->PatchBasicConfig();
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SendLuaError(const int nErrorCode)
{
	//if (BJMApp::BJMCrashServer::HasInstance())
	//{
	//	BJMApp::BJMCrashServer::Instance()->UploadCrashReport("", nErrorCode);
	//}
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SaveImageToGallery(const char * imagePath)
{
	BJMUtil::BJMDeviceUtil::SaveImageToGallery(imagePath);
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::RenameFile(char *from, char * to)
{
	return BJMIoInterfaceUtil::RenameFile(from, to);
}

void BJMLuaUtil::VibrateSoundPlay(char * vibrate, char * sound, char *soundPath)
{
	BJMUtil::BJMDeviceUtil::VibrateSoundPlay(vibrate, sound, soundPath);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::MoveAppToBack()
{
	BJMUtil::BJMDeviceUtil::MoveAppToBack();
}

//------------------------------------------------------------------------------
/**
*/
bool BJMLuaUtil::IsAppOnForeground()
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_ANDROID
	return BJMUtil::BJMDeviceUtil::IsAppOnForeground();
#else
	return BJMApp::BJMAppApplication::Instance()->IsAppOnForeground();
#endif
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::LogRelease(char * content)
{
	if (content == NULL) return;
	n_printf("%s", content);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::UseBatterySave()
{
	cocos2d::Director::getInstance()->setBatterySave(true);
}


//------------------------------------------------------------------------------
/**
*/
int BJMLuaUtil::GetLastKeyboardHeight()
{
#if BJM_TARGET_PLATFORM == BJM_PLATFORM_ANDROID
	return BJMUtil::BJMDeviceUtil::GetLastKeyboardHeight();
#endif	
	
	return -1;
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::RegisterFrameUpdateFunc(const int nFrameUpdateFunc)
{
	BJMApp::BJMAppApplication::Instance()->SetFrameUpdateFunc(nFrameUpdateFunc);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SaveGameDataToDevice(const char * szKey, const char * szValue)
{
	BJMUtil::BJMDeviceUtil::SaveDataToDevice(szKey, szValue, "");
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetGameDataFromDevice(const char * szKey)
{
	return BJMUtil::BJMDeviceUtil::GetDataFromDevice(szKey, "").AsCharPtr();
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SavePublicDataToDevice(const char * szKey, const char * szValue, const char * szPublic)
{
	if (strcmp(szPublic, "") == 0)
	{
		szPublic = "public";
	}
	BJMUtil::BJMDeviceUtil::SaveDataToDevice(szKey, szValue, szPublic);
}

//------------------------------------------------------------------------------
/**
*/
std::string BJMLuaUtil::GetPublicDataFromDevice(const char * szKey, const char * szPublic)
{
	if (strcmp(szPublic, "") == 0)
	{
		szPublic = "public";
	}
	return BJMUtil::BJMDeviceUtil::GetDataFromDevice(szKey, szPublic).AsCharPtr();
}

float BJMLuaUtil::GetBatteryLevel()
{
	return BJMUtil::BJMDeviceUtil::GetBatteryLevel();
}


//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetUseMultiTouch(const bool bUse)
{
	BJMGui::BJMGuiUtil::SetUseMultiTouch(bUse);
}

//------------------------------------------------------------------------------
/**
*/
void BJMLuaUtil::SetUseAppRestart(const bool bUse)
{
	BJMApp::BJMAppApplication::Instance()->SetUseAppRestart(bUse);
}

void BJMLuaUtil::SetUseHttps(const bool bUseHttps)
{
	BJMHttp::BJMHttpUtil::SetUseHttps(bUseHttps);
	BJMApp::BJMUpdateUtil::SetUseHttps(bUseHttps);

}


}
// namespace BJMScript