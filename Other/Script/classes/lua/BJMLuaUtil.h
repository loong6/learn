/****************************************************************************
Author : ZangXu @Bojoy 2014
FileName: BJMLuaUtil.h
Description: 
functions used by lua script
****************************************************************************/

#pragma once

#include "BJMScriptDefine.h"
#include "logic/BJMLogic.h"
#include <string>

namespace BJMScript
{
using namespace BJMGui;

class BJMLuaUtil
{
public:
	/*************************
	add lua search path
	/*************************/
	static void AddSearchPath(const char * szUri);

	/*************************
	register lua object creator handler
	/*************************/
	static void RegisterCreatorHandler(int nCreatorHandler);

	/*************************
	read a file
	/*************************/
	static std::string ReadFile(const char * uri);

	/*************************
	read a file from file system
	/*************************/
	static std::string ReadFileFromFileSystem(const char * uri);

	/*************************
	write a file
	/*************************/
	static bool WriteFile(const char * uri, const char * szFileContent);

	/*************************
	write a file async
	/*************************/
	static void WriteFileAsync(const char * uri, const char * szFileContent);

	/*************************
	copy a file
	/*************************/
	static bool CopyFile_(const char * fromUri, const char * toUri);

	/*************************
	copy a file
	/*************************/
	static bool CopyFileFileSystem(const char * fromUri, const char * toUri);

	/*************************
	delete a file
	/*************************/
	static bool DeleteFile_(const char * uri);

	/*************************
	check a file exists
	/*************************/
	static bool FileExists(const char * uri);

	/*************************
	check a file exists from file system
	/*************************/
	static bool FileExistsFileSystem(const char * uri);

	/*************************
	list files
	/*************************/
	static BJMArray<BJMString> ListFiles(const char * uri, const char* pattern, bool asFullPath);

	/*************************
	list files filesystem
	/*************************/
	static BJMArray<BJMString> ListFilesFileSystem(const char * uri, const char* pattern, bool asFullPath);

	/*************************
	list dirs
	/*************************/
	static BJMArray<BJMString> ListDirectories(const char * uri, const char* pattern, bool asFullPath);

	/*************************
	list dirs filesystem
	/*************************/
	static BJMArray<BJMString> ListDirectoriesFileSystem(const char * uri, const char* pattern, bool asFullPath);

	/*************************
	get the CRC checksum of a file
	/*************************/
	static unsigned int ComputeFileCrc(const char * uri);

	/*************************
	add mpq patch
	/*************************/
	static bool AddPatch(const char* strFullPath);

	/*************************
	rename a file
	// to do not implemented
	/*************************/
	static void RenameFile(const char * uri, const char * name);

	/*************************
	create all missing directories in the path
	/*************************/
	static bool CreateDirectory_(const char * uri);

	/*************************
	delete an empty directory
	/*************************/
	static bool DeleteDirectory(const char * uri);

	/*************************
	return true if directory exists
	/*************************/
	static bool DirectoryExists(const char * uri);

	/*************************
	register gui config
	/*************************/
	static void RegisterGuiConfig(const char * szConfigName, const char * uri);

	/*************************
	debug use
	add breakpoint
	/*************************/
	static void Assert(const bool bEvaluation, const char * szContent);

	/*************************
	push Notification
	/*************************/
	static void PushNotification(
		BJMLogic * pLogic,
		const char * szNotificationName,
		const int nScriptObject);

	/*************************
	push at once notification
	/*************************/
	static void PushNotificationAtOnce(
		BJMLogic * pLogic,
		const char * szNotificationName,
		const int nScriptObject);

	/*************************
	use lock?
	/*************************/
	static void SetUseLockWhenPush(const bool bUseLock);

	/*************************
	get string
	/*************************/
	static std::string GetSDKString(const char * szStringName);

	/*************************
	get string
	/*************************/
	static std::string GetGameString(const char * szStringName);

	/*************************
	uri to path
	/*************************/
	static std::string UriToPath(const char * szUri);

	/*************************
	path to uri
	/*************************/
	static std::string PathToUri(const char * szPath, const char * szPre);
    
    /*************************
    get startup url
    /*************************/
    static std::string GetStartupUrl();

	/*************************
	let main thread sleep
	only for debug use
	only support on win32 platform
	/*************************/
	static void Sleep(const unsigned int nMillsec);

	/*************************
	check if network is available.
	/*************************/
	static bool CheckIsNetworkAvailable();

	/*************************
	get network type.
	/*************************/
	static std::string GetNetworkType();

	/*************************
	if device is in landscape state
	/*************************/
	static bool IsLandscape();

	/*************************
	check if user has authorized for something (iOS only)
	/*************************/
	static bool IsAuthorized(const char* item);

    /*************************
    open settings for this app, must >= ios8.0
    /*************************/
    static void OpenAppSettings();

    /*************************
    show or hide status bar
    /*************************/
	static void ShowStatusBar(bool show);

	/*************************
	get device code
	/*************************/
	static std::string GetDeviceCode();

	/*************************
	get device mac
	/*************************/
	static std::string GetMac();

	/*************************
	get device model
	/*************************/
	static std::string GetModel();

	/*************************
	get app version
	/*************************/
	static std::string GetAppVersion();

	/*************************
	get sys version
	/*************************/
	static std::string GetSysVersion();

	/*************************
	get phone number
	/*************************/
	static std::string GetPhoneNumber();

	/*************************
	get resolution string
	/*************************/
	static std::string GetResolution();

	/*************************
	get os string
	/*************************/
	static std::string GetOS();

	/*************************
	get adapt type
	/*************************/
	static std::string GetAdaptType();

	/*************************
	get use update?
	/*************************/
	static bool GetUseUpdate();
	
	/*************************
	get use crash report?
	/*************************/
	static bool GetUseCrashReport();

	/*************************
	get use bulletin?
	/*************************/
	static bool GetUseBulletin();

	/*************************
	md5
	/*************************/
	static std::string MakeMD5(const char * szContent);

	/*************************
	file md5
	/*************************/
	static std::string MakeFileMD5(const char * szURI);

	/*************************
	open ie
	/*************************/
	static void OpenIE(const char * szURL);

	/*************************
	force update app
	/*************************/
	static void ForceUpdateApp(const char * szURL);

	/*************************
	exit app
	/*************************/
	static void Exit();

	/*************************
	get plugins
	/*************************/
	static std::string GetPlugins();

	/*************************
	get use hor
	/*************************/
	static bool GetUseHor(); 

	/*************************
	get channel
	/*************************/
	static std::string GetChannel();

	/*************************
	get XGParam
	/*************************/
	static std::string GetXGParam();

	/*************************
	get app code
	/*************************/
	static std::string GetAppCode();

	/*************************
	get use sdk
	/*************************/
	static bool GetUseSDK();

	/*************************
	get use offline
	/*************************/
	static bool GetUseOffline();

	/*************************
	get app id
	/*************************/
	static std::string GetAppID();

	/*************************
	get use test
	/*************************/
	static bool GetUseTest();

	/*************************
	get use inner
	/*************************/
	static bool GetUseInner();

	/*************************
	get publish Locale
	/*************************/
	static std::string GetLocale();

	/*************************
	get operator
	/*************************/
	static std::string GetOperator();

	/*************************
	render to image
	/*************************/
	static void SaveToFile(BJMNode * pNode, const char * szUri);

	/*************************
	CaptureScreen  zls 20160307
	/*************************/
	static void CaptureScreen( const char * szUri);

	/*************************
	restart
	/*************************/
	static void Restart();

	/*************************
	reset adapt type
	/*************************/
	static void ResetAdaptType(const char * szAdaptType);

	/*************************
	discard unused resource
	/*************************/
	static void DiscardUnusedResource(const int nType);

	/*************************
	unload unused resource
	/*************************/
	static void UnLoadUnusedResource(const int nType);

	/*************************
	read file from file system as base64
	/*************************/
	static std::string ReadFileFromFileSystemAsBase64(const char * szUri);

	/*************************
	hash code of a string
	/*************************/
	static int HashCode(const char * szContent);

	/*************************
	unzip
	/*************************/
	static bool Unzip(const char * szZip, const char * szTo, const bool bFlat);

	/*************************
	call this function will lead to a crash!!!!
	never call this function!!!!
	/*************************/
	static void TestCrash(); 

	/*************************
	get location(by honglei)
	/*************************/
	static void QueryGpsLocation();

    /*************************
    get apns device token (ios only)
    /*************************/
    static void QueryAPNSDeviceToken();
    
    /*************************
    is apns enabled (ios only)
    /*************************/
    static bool IsAPNSEnabled();

    /*************************
    set badge number (ios only)
    /*************************/
    static void SetAppIconBadgeNumber(int num);

	/*************************
	date to time stamp
	/*************************/
	static unsigned long long DateToTimeStamp(const char * szDate, const char * szPattern);

	/*************************
	run in autorelease pool
	/*************************/
	static void RunInAutoReleasePool(int nFunc);

	/*************************
	get apps info
	/*************************/
	static void GetInstalledApps(const char* strAppList);

	/*************************
	http post
	/*************************/
	static void HttpPost(const char* strConnName, const char* strUrl, const char* strPostData, int timeout);

	/*************************
	enter app(by liqiyin)
	/*************************/
	static bool OpenApp(const char * packageName, const char * activityName);

	/*************************
	extract app icon(by liqiyin)
	/*************************/
	static void ExtractAppIcon(const char * packageName);

	/*************************
	get phone contact info(by liqiyin)
	/*************************/
	static std::string GetPhoneContacts(const char * time);

	/*************************
	install app(by liqiyin)
	/*************************/
	static void InstallApp(const char * filePath);

	/*************************
	copy to clipboard(by liqiyin)
	/*************************/
	static void CopyToClipboard(const char * str);

	/*************************
	send sms
	/*************************/
	static void SendSMS(const char* destPhone, const char* strMsg);

	/*************************
	escape html
	/*************************/
	static std::string EscapeUrl(const std::string & strFrom);

	/*************************
	append log
	/*************************/
	static void AppendLog(const char * szLog);

	/*************************
	confirm
	/*************************/
	static void DebugMessageBox(const char * title, const char * szContent);

	/*************************
	release message box
	/*************************/
	static void ReleaseMessageBox(const char * title, const char * szContent);

	/*************************
	setup basic config
	/*************************/
	static void SetupBasicConfig();

	/*************************
	set basic config value
	/*************************/
	static void SetBasicConfigValue(const char * key,const char * value);

	/*************************
	patch basic config
	/*************************/
	static void PatchBasicConfig();

	/*************************
	send lua error
	/*************************/
	static void SendLuaError(const int nErrorCode);

	/*************************
	save image to gallery(by liqiyin)
	/*************************/
	static void SaveImageToGallery(const char * imagePath);

	/*************************
	rename a file
	/*************************/
	static bool RenameFile(char *from, char * to);

	/*************************
	vibrate and play a sound
	/*************************/
	static void VibrateSoundPlay(char * vibrate, char *sound, char *soundPath);

	/*************************
	move app to background for android
	/*************************/
	static void MoveAppToBack();

	/*************************
	is app on foreground for android
	/*************************/
	static bool IsAppOnForeground();

	/*************************
	log release version
	/*************************/
	static void LogRelease(char * content);

	/*************************
	use battery save ability
	/*************************/
	static void UseBatterySave();

	/*************************
	get last keyboard height (android only)
	/*************************/
	static int GetLastKeyboardHeight();

	/*************************
	register lua frame update function
	/*************************/
	static void RegisterFrameUpdateFunc(const int nFrameUpdateFunc);

	/*************************
	save game data to device
	/*************************/
	static void SaveGameDataToDevice(const char * szKey, const char * szValue);

	/*************************
	get game data from device
	/*************************/
	static std::string GetGameDataFromDevice(const char * szKey);

	/*************************
	save public data to device
	/*************************/
	static void SavePublicDataToDevice(const char * szKey, const char * szValue, const char * szPublic);

	/*************************
	get public data from device
	/*************************/
	static std::string GetPublicDataFromDevice(const char * szKey, const char * szPublic);

	/*************************
	get public GetBatteryLevel from device
	return [-1 ,100]
	-1 无法取得电量
	/*************************/
	static float GetBatteryLevel();


	/*************************
	SetUseMultiTouch  zls 20160307
	/*************************/
	static void SetUseMultiTouch(const bool bUse);


	/*************************
	Set Use AppRestart  zls 20160809 only for android
	/*************************/
	static void SetUseAppRestart(const bool bUse);

	static void SetUseHttps(const bool bUseHttps);

};

} // namespace BJMScript