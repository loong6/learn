--[[
Author : ZangXu @Bojoy 2014
FileName: BJMGlobalConstant.lua
Description: 
define all constant string, default values or enums here
]]

---BJMGlobalConstant
-- @module bjm.global

local global = bjm.global

--- scale_factor
global.scale_factor = 1

--- uri
global.uri = 
{
	bjm_game_sdk_home 						= "bjmgamesdkhome",
	bjm_sdk_home 							= "bjmsdkhome",
	app_home 								= "apphome",
	cache_home 								= "cachehome",
	doc_home 								= "dochome",
	game_res_home 							= "gamereshome",
	core_home 								= "corehome",
	script_framework_home 					= "frameworkhome",
	cocos_script_fromework_home 			= "cocosframeworkhome",
	font_home 								= "fonthome",
	sys_home 								= "syshome",
	tmp_home 								= "tmphome",
	bjm_sdk_data_home 						= "bjmsdkdatahome",
	bjm_sdk_ui_home 						= "bjmsdkuihome",
	bjm_sdk_cache_home 						= "bjmsdkcachehome",
	game_cache_home							= "gamecachehome"
}

global.sdk = {}
--- @table sdk.feature
global.sdk.feature =
{
	account 								= "Account",
	ad 										= "Ad",
	check_res_update 						= "CheckResUpdate",
	check_app_update 						= "CheckAppUpdate",
	crash_analyse 							= "CrashAnalyse",
	push									= "Push",
	question_submit							= "QuestionSubmit",
	server_list 							= "ServerList",
	user_analyse							= "UserAnalyse",
	bulletin 								= "Bulletin"
}

global.sdk.strings = 
{
	adapttype 								= "adapttype"
}

--- function_type
global.function_type = 
{
	foundatation							= 0,

	--net
	http_ret								= 1,
	socket_ret								= 2,
	net_not_available						= 3,

	--http
	http									= 4,
	http_download							= 5,
	http_download_finish					= 6,
	http_download_error						= 7,
	http_download_stop						= 8,

	--gps
	gps_location							= 50,

	--install app
	installed_app							= 60,

	--btn back
	btn_back								= 70,
	
	--scroll to top
	scroll_to_top							= 75,

	--device_token
	device_token							= 80,
	
	--send_sms
	send_sms								= 90,

	--click
	click_down  							= 101,
	click_up 								= 102,
	click_up_inside 						= 103,
	click_up_outside 						= 104,
	slip									= 105,
	click_cancel							= 106,

	--armature
	armature_movement_start					= 120,
	armature_movement_complete				= 121,
	armature_movement_loop_complete			= 122,
	armature_frame							= 123,

	--frame animation
	frame_animation_complete				= 125,

	--gaf
	gaf_playback_complete					= 127,
	gaf_playback_loop_complete				= 128,
	gaf_frame								= 129,

	--scroll view
	scrollview_scroll_begin					= 130,
	scrollview_scroll_end					= 131,
	scrollview_scroll_page_loaded			= 132,

	--move view
	moveview_node_loaded					= 135,
	moveview_drag_percent					= 136,
	moveview_scroll_begin					= 137,
	moveview_scroll_end						= 138,
	moveview_node_unload					= 139,
	
	--rich node
	richnode_click							= 140,
	richnode_moved							= 141,
	richnode_click_down						= 142,

	--multiplex view
	multiplex_switch						= 150,

	--number selector
	number_change							= 155,
	
	--edit box
	edit_begin								= 170,
	edit_end								= 171,
	edit_text_changed						= 172,
	edit_return								= 173,
	keyboard_moved							= 174,

	--spine
	skeleton_animation_start				= 180,
	skeleton_animation_end					= 181,
	skeleton_animation_loop_complete		= 182,
	skeleton_animation_event				= 183,
	skeleton_animation_asyncloaded 			= 184,

	--video node
	video_complete 							= 190,
	video_click 							= 191,

	--logic
	on_loaded 								= 300,
	on_destroy								= 301,
	on_close								= 302,

	--update
	update_check_patches					= 320,
	update_check_patches_error				= 321,
	update_download_patch					= 322,
	update_download_patch_error				= 323,
	update_success							= 324,
	update_res_version						= 325,
	update_max_res_version					= 326,
	update_no_patch 						= 327,
	update_show_wifi						= 328,
	update_show_check_patches_error			= 329,
	update_show_download_error				= 330,
	update_add_patch_fail					= 331,
	update_patch_crc_invalid				= 332,
	update_stop 							= 333,


	--custom
	custom									= 500
}

--- notification_type
global.notification_type = 
{
	foundatation							= 0,

	--net
	http_ret								= 1,
	socket_ret								= 2,
	net_not_available						= 3,

	--net specs
	http									= 4,
	download								= 5,
	download_finish							= 6,
	download_error							= 7,
	download_stop							= 8,

	--click
	click_down  							= 101,
	click_up 								= 102,
	click_up_inside 						= 103,
	click_up_outside 						= 104,
	slip									= 105,

	--armature
	armature_movement_start					= 120,
	armature_movement_complete				= 121,
	armature_movement_loop_complete			= 122,
	armature_frame							= 123,

	--frame animation
	frame_animation_complete				= 125,

	--gaf
	gaf_playback_complete					= 127,
	gaf_playback_loop_complete				= 128,
	gaf_frame								= 129,

	--move view
	scrollview_scroll_begin					= 130,
	scrollview_scroll_end					= 131,
	scrollview_scroll_page_loaded			= 132,

	--multiplex view
	multiplexview_switch					= 150,

	--number selector
	number_change							= 155,

	--logic
	logic_open								= 160,
	logic_close								= 161,

	--spine
	skeleton_animation_start				= 180,
	skeleton_animation_end					= 181,
	skeleton_animation_loop_complete		= 182,
	skeleton_animation_event				= 183,

	--update
	update_check_patches					= 320,
	update_check_patches_error				= 321,
	update_download_patch					= 322,
	update_download_patch_error				= 323,
	update_success							= 324,
	update_res_version						= 325,
	update_max_res_version					= 326,
	update_no_patch 						= 327,
	update_show_wifi						= 328,
	update_show_check_patches_error			= 329,
	update_show_download_error				= 330,
	update_add_patch_fail					= 331,
	update_patch_crc_invalid				= 332,

	--custom
	custom									= 500
}

--- config
global.config = 
{
	game_uidict 							= "UIDict",
	sdk_uidict 								= "UISdkDict",
	animation								= "Animation",
	game_string								= "GameString"
}

--- color3b
global.color3b =
{
	white 									= cc.c3b(255, 255, 255),
	yellow 									= cc.c3b(255, 255,   0),
	green 									= cc.c3b(  0, 255,   0),
	blue 									= cc.c3b(  0,   0, 255),
	red 									= cc.c3b(255,   0,   0),
	magenta 								= cc.c3b(255,   0, 255),
	black 									= cc.c3b(  0,   0,   0),
	orange 									= cc.c3b(255, 127,   0),
	gray 									= cc.c3b(166, 166, 166)
}

--- color4b
global.color4b =
{
	white 									= cc.c4b(255, 255, 255, 255),
	yellow 									= cc.c4b(255, 255,   0, 255),
	green 									= cc.c4b(  0, 255,   0, 255),
	blue 									= cc.c4b(  0,   0, 255, 255),
	red 									= cc.c4b(255,   0,   0, 255),
	magenta 								= cc.c4b(255,   0, 255, 255),
	black 									= cc.c4b(  0,   0,   0, 255),
	orange 									= cc.c4b(255, 127,   0, 255),
	gray 									= cc.c4b(166, 166, 166, 255)
}

--- color4f
global.color4f =
{
	white 									= cc.c4f(    1,     1,     1, 1),
	yellow 									= cc.c4f(    1,     1,     0, 1),
	green 									= cc.c4f(    0,     1,     0, 1),
	blue 									= cc.c4f(    0,     0,     1, 1),
	red 									= cc.c4f(    1,     0,     0, 1),
	magenta 								= cc.c4f(    1,     0,     1, 1),
	black 									= cc.c4f(    0,     0,     0, 1),
	orange 									= cc.c4f(    1,   0.5,     0, 1),
	gray 									= cc.c4f( 0.65,  0.65,  0.65, 1)
}

--- zero
global.zero =
{
	size 									= cc.size(0,0),
	point 									= cc.p(0,0),
	rect 									= cc.rect(0,0,0,0)
}

--- default
global.default = 
{
	font_name 								= "simhei",
	font_size 								= 24 / global.scale_factor,
	color 									= global.color3b.black
}

--- module
global.module = 
{
	logic 									= "Logic",
	move_logic 								= "MoveLogic",
	confirm_logic 							= "ConfirmLogic",
	multiplex_logic 						= "MultiplexLogic",
	scroll_logic 							= "ScrollLogic",
	net_logic								= "NetLogic",
	update_logic							= "UpdateLogic",
	sdk_logic								= "SDKLogic",
	http_logic								= "HttpLogic"
}

---location 
global.location = 
{
	TopLeft				= 0,
	TopCenter			= 1,
	TopRight			= 2,
	CenterLeft			= 3,
	CenterCenter		= 4,
	CenterRight			= 5,
	BottomLeft			= 6,
	BottomCenter		= 7,
	BottomRight			= 8,	
	Top					= 9,
	Right				= 10,
	Bottom				= 11,
	Left				= 12,
}

--- shader
global.shader = 
{
	default									= 0,
	gray									= 1,
	pure									= 2,
	blur 									= 3,
	outline 								= 4,
	noise 									= 5,
	sepia 									= 6,
	bloom 									= 7,
	blurEx 									= 8,
	radialBlur 								= 9,
	cel	 									= 10,
}

---define GAF,Armature,FrameAnimation action when played complete
global.complete_action =
{
	default 								= 0,
	visible 								= 1,
	remove 									= 2,
}

--- encrypt
global.encrypt = 
{
	bojoy 									= 0
}

--- memory type
global.memory = 
{
	cocos2d 								= 1,
	bjm	 									= 2,
	font 									= 3,
	script 			 						= 4,
	all 									= 5,
}

--- adapt type
global.adapt_type = 
{
	showall									= "showall",
	exactfit								= "exactfit",
	noborder								= "noborder",
	fixedheight								= "fixedheight",
	fixedwidth								= "fixedwidth",
}

--- gam minestone
--- [1-50]
global.gam = 
{
	game_start								= 1,
	send_w001 								= 2,
	receive_w001							= 3,
	parse_w001_success						= 4,
	before_show_bulletin					= 5,
	before_init_sdk							= 6,
	before_app_update						= 7,
	before_res_update						= 8,
	wait_for_login_gui						= 9,
	before_login 							= 10,
	sdk_login_finish						= 11,
}

-- read errors
global.err = 
{
	normal									= 2,
	fail_to_prepare_cdn						= 3,
	all_cdn_fail_w001						= 4,
	fail_to_retrieve_patches				= 5,
	fail_to_download_single_patch			= 6,
	fail_to_valid_single_patch				= 7,
	fail_to_use_single_patch				= 8,
	fail_to_retrieve_serverlist				= 9,
}

------------------------------------- key code -------------------------------------
global.keycode = 
{
	KEY_NONE								= 0,
    KEY_PAUSE								= 1,
    KEY_SCROLL_LOCK							= 2,
    KEY_PRINT								= 3,
    KEY_SYSREQ								= 4,
    KEY_BREAK								= 5,
    KEY_ESCAPE								= 6,
    KEY_BACKSPACE							= 7,
    KEY_TAB									= 8,
    KEY_BACK_TAB							= 9,
    KEY_RETURN								= 10,
    KEY_CAPS_LOCK							= 11,
    KEY_SHIFT								= 12,
    KEY_CTRL								= 13,
    KEY_ALT									= 14,
    KEY_MENU								= 15,
    KEY_HYPER								= 16,
    KEY_INSERT								= 17,
    KEY_HOME								= 18,
    KEY_PG_UP								= 19,
    KEY_DELETE								= 20,
    KEY_END									= 21,
    KEY_PG_DOWN								= 22,
    KEY_LEFT_ARROW							= 23,
    KEY_RIGHT_ARROW							= 24,
    KEY_UP_ARROW							= 25,
    KEY_DOWN_ARROW							= 26,
    KEY_NUM_LOCK							= 27,
    KEY_KP_PLUS								= 28,
    KEY_KP_MINUS							= 29,
    KEY_KP_MULTIPLY							= 30,
    KEY_KP_DIVIDE							= 31,
    KEY_KP_ENTER							= 32,
    KEY_KP_HOME								= 33,
    KEY_KP_UP								= 34,
    KEY_KP_PG_UP							= 35,
    KEY_KP_LEFT								= 36,
    KEY_KP_FIVE								= 37,
    KEY_KP_RIGHT							= 38,
    KEY_KP_END								= 39,
    KEY_KP_DOWN								= 40,
    KEY_KP_PG_DOWN							= 41,
    KEY_KP_INSERT							= 42,
    KEY_KP_DELETE							= 43,
    KEY_F1									= 44,
    KEY_F2									= 45,
    KEY_F3									= 46,
    KEY_F4									= 47,
    KEY_F5									= 48,
    KEY_F6									= 49,
    KEY_F7									= 50,
    KEY_F8									= 51,
    KEY_F9									= 52,
    KEY_F10									= 53,
    KEY_F11									= 54,
    KEY_F12									= 55,
    KEY_SPACE								= 56,
    KEY_EXCLAM								= 57,
    KEY_QUOTE								= 58,
    KEY_NUMBER								= 59,
    KEY_DOLLAR								= 60,
    KEY_PERCENT								= 61,
    KEY_CIRCUMFLEX							= 62,
    KEY_AMPERSAND                           = 63,
    KEY_APOSTROPHE                          = 64,
    KEY_LEFT_PARENTHESIS                    = 65,
    KEY_RIGHT_PARENTHESIS                   = 66,
    KEY_ASTERISK                            = 67,
    KEY_PLUS                                = 68,
    KEY_COMMA                               = 69,
    KEY_MINUS                               = 70,
    KEY_PERIOD                              = 71,
    KEY_SLASH                               = 72,
    KEY_0                                   = 73,
    KEY_1                                   = 74,
    KEY_2                                   = 75,
    KEY_3                                   = 76,
    KEY_4                                   = 77,
    KEY_5                                   = 78,
    KEY_6                                   = 79,
    KEY_7                                   = 80,
    KEY_8                                   = 81,
    KEY_9                                   = 82,
    KEY_COLON                               = 83,
    KEY_SEMICOLON                           = 84,
    KEY_LESS_THAN                           = 85,
    KEY_EQUAL                               = 86,
    KEY_GREATER_THAN                        = 87,
    KEY_QUESTION                            = 88,
    KEY_AT                                  = 89,
    KEY_CAPITAL_A                           = 90,
    KEY_CAPITAL_B                           = 91,
    KEY_CAPITAL_C                           = 92,
    KEY_CAPITAL_D                           = 93,
    KEY_CAPITAL_E                           = 94,
    KEY_CAPITAL_F                           = 95,
    KEY_CAPITAL_G                           = 96,
    KEY_CAPITAL_H                           = 97,
    KEY_CAPITAL_I                           = 98,
    KEY_CAPITAL_J                           = 99,
    KEY_CAPITAL_K                           = 100,
    KEY_CAPITAL_L                           = 101,
    KEY_CAPITAL_M                           = 102,
    KEY_CAPITAL_N                           = 103,
    KEY_CAPITAL_O                           = 104,
    KEY_CAPITAL_P                           = 105,
    KEY_CAPITAL_Q                           = 106,
    KEY_CAPITAL_R                           = 107,
    KEY_CAPITAL_S                           = 108,
    KEY_CAPITAL_T                           = 109,
    KEY_CAPITAL_U                           = 110,
    KEY_CAPITAL_V                           = 111,
    KEY_CAPITAL_W                           = 112,
    KEY_CAPITAL_X                           = 113,
    KEY_CAPITAL_Y                           = 114,
    KEY_CAPITAL_Z                           = 115,
    KEY_LEFT_BRACKET                        = 116,
    KEY_BACK_SLASH                          = 117,
    KEY_RIGHT_BRACKET                       = 118,
    KEY_UNDERSCORE                          = 119,
    KEY_GRAVE                               = 120,
    KEY_A                                   = 121,
    KEY_B                                   = 122,
    KEY_C                                   = 123,
    KEY_D                                   = 124,
    KEY_E                                   = 125,
    KEY_F                                   = 126,
    KEY_G                                   = 127,
    KEY_H                                   = 128,
    KEY_I                                   = 129,
    KEY_J                                   = 130,
    KEY_K                                   = 131,
    KEY_L                                   = 132,
    KEY_M                                   = 133,
    KEY_N                                   = 134,
    KEY_O                                   = 135,
    KEY_P                                   = 136,
    KEY_Q                                   = 137,
    KEY_R                                   = 138,
    KEY_S                                   = 139,
    KEY_T                                   = 140,
    KEY_U                                   = 141,
    KEY_V                                   = 142,
    KEY_W                                   = 143,
    KEY_X                                   = 144,
    KEY_Y                                   = 145,
    KEY_Z                                   = 146,
    KEY_LEFT_BRACE                          = 147,
    KEY_BAR                                 = 148,
    KEY_RIGHT_BRACE                         = 149,
    KEY_TILDE                               = 150,
    KEY_EURO                                = 151,
    KEY_POUND                               = 152,
    KEY_YEN                                 = 153,
    KEY_MIDDLE_DOT                          = 154,
    KEY_SEARCH                              = 155,
    KEY_DPAD_LEFT                           = 156,
    KEY_DPAD_RIGHT                          = 157,
    KEY_DPAD_UP                             = 158,
    KEY_DPAD_DOWN                           = 159,
    KEY_DPAD_CENTER                         = 160,
    KEY_ENTER                               = 161,
    KEY_PLAY                                = 162,
}

------------------------------------- filename ------------------------------------
global.filetype = {
	gamefont	= "GameFont",
	uidict		= "UIDict",
	gamestring	= "GameString",
	animation	= "Animation",
}

------------------------------------- directions -------------------------------------
global.direction = 
{
	up = 0,
	up_right = 1,
	right = 2,
	down_right = 3,
	down = 4,
	down_left = 5,
	left = 6,
	up_left = 7,
	count = 8
}

global.pathfinderType = {
	astar 	= "astar",
	jps 	= "jps",
}