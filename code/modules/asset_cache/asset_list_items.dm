//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui_common
	keep_local_name = TRUE
	assets = list(
		"tgui-common.bundle.js" = 'tgui/public/tgui-common.bundle.js',
	)

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = 'tgui/public/tgui.bundle.js',
		"tgui.bundle.css" = 'tgui/public/tgui.bundle.css',
	)

/datum/asset/simple/ntos_headers
	legacy = TRUE
	assets = list(
		"alarm_green.gif" 			= 'html/images/program_icons/alarm_green.gif',
		"alarm_red.gif" 			= 'html/images/program_icons/alarm_red.gif',
		"batt_5.gif" 				= 'html/images/program_icons/batt_5.gif',
		"batt_20.gif" 				= 'html/images/program_icons/batt_20.gif',
		"batt_40.gif" 				= 'html/images/program_icons/batt_40.gif',
		"batt_60.gif" 				= 'html/images/program_icons/batt_60.gif',
		"batt_80.gif" 				= 'html/images/program_icons/batt_80.gif',
		"batt_100.gif" 				= 'html/images/program_icons/batt_100.gif',
		"borg_mon.gif"				= 'html/images/program_icons/borg_mon.gif',
		"charging.gif" 				= 'html/images/program_icons/charging.gif',
		"crew_green.gif"			= 'html/images/program_icons/crew_green.gif',
		"crew_red.gif"				= 'html/images/program_icons/crew_red.gif',
		"downloader_finished.gif" 	= 'html/images/program_icons/downloader_finished.gif',
		"downloader_running.gif" 	= 'html/images/program_icons/downloader_running.gif',
		"ntnrc_idle.gif"			= 'html/images/program_icons/ntnrc_idle.gif',
		"ntnrc_new.gif"				= 'html/images/program_icons/ntnrc_new.gif',
		"power_norm.gif"			= 'html/images/program_icons/power_norm.gif',
		"power_warn.gif"			= 'html/images/program_icons/power_warn.gif',
		"shield.gif"				= 'html/images/program_icons/shield.gif',
		"sig_high.gif" 				= 'html/images/program_icons/sig_high.gif',
		"sig_low.gif" 				= 'html/images/program_icons/sig_low.gif',
		"sig_lan.gif" 				= 'html/images/program_icons/sig_lan.gif',
		"sig_none.gif" 				= 'html/images/program_icons/sig_none.gif',
		"smmon_0.gif" 				= 'html/images/program_icons/smmon_0.gif',
		"smmon_1.gif" 				= 'html/images/program_icons/smmon_1.gif',
		"smmon_2.gif" 				= 'html/images/program_icons/smmon_2.gif',
		"smmon_3.gif" 				= 'html/images/program_icons/smmon_3.gif',
		"smmon_4.gif" 				= 'html/images/program_icons/smmon_4.gif',
		"smmon_5.gif" 				= 'html/images/program_icons/smmon_5.gif',
		"smmon_6.gif" 				= 'html/images/program_icons/smmon_6.gif',
	)

/datum/asset/simple/pda
	assets = list(
		"atmos"			= 'html/images/pda_icons/pda_atmos.png',
		"back"			= 'html/images/pda_icons/pda_back.png',
		"bell"			= 'html/images/pda_icons/pda_bell.png',
		"blank"			= 'html/images/pda_icons/pda_blank.png',
		"boom"			= 'html/images/pda_icons/pda_boom.png',
		"bucket"		= 'html/images/pda_icons/pda_bucket.png',
		"medbot"		= 'html/images/pda_icons/pda_medbot.png',
		"floorbot"		= 'html/images/pda_icons/pda_floorbot.png',
		"cleanbot"		= 'html/images/pda_icons/pda_cleanbot.png',
		"crate"			= 'html/images/pda_icons/pda_crate.png',
		"cuffs"			= 'html/images/pda_icons/pda_cuffs.png',
		"eject"			= 'html/images/pda_icons/pda_eject.png',
		"flashlight"	= 'html/images/pda_icons/pda_flashlight.png',
		"honk"			= 'html/images/pda_icons/pda_honk.png',
		"mail"			= 'html/images/pda_icons/pda_mail.png',
		"medical"		= 'html/images/pda_icons/pda_medical.png',
		"menu"			= 'html/images/pda_icons/pda_menu.png',
		"mule"			= 'html/images/pda_icons/pda_mule.png',
		"notes"			= 'html/images/pda_icons/pda_notes.png',
		"power"			= 'html/images/pda_icons/pda_power.png',
		"rdoor"			= 'html/images/pda_icons/pda_rdoor.png',
		"reagent"		= 'html/images/pda_icons/pda_reagent.png',
		"refresh"		= 'html/images/pda_icons/pda_refresh.png',
		"scanner"		= 'html/images/pda_icons/pda_scanner.png',
		"signaler"		= 'html/images/pda_icons/pda_signaler.png',
		"skills"		= 'html/images/pda_icons/pda_skills.png',
		"status"		= 'html/images/pda_icons/pda_status.png',
		"dronephone"	= 'html/images/pda_icons/pda_dronephone.png',
		"emoji"			= 'html/images/pda_icons/pda_emoji.png'
	)

/datum/asset/group/paper
	children = list(
		/datum/asset/simple/paper_logos,
		/datum/asset/simple/paper_stamps
	)

/datum/asset/simple/paper_logos
	legacy = TRUE
	assets = list(
		"bluentlogo.png"	= 'html/images/bluentlogo.png',
		"ntlogo.png"		= 'html/images/ntlogo.png',
		"sollogo.png"		= 'html/images/sollogo.png',
		"talisman.png"		= 'html/images/talisman.png',
		"terralogo.png"		= 'html/images/terralogo.png'
	)

/datum/asset/simple/paper_stamps
	legacy = TRUE
	assets = list(
		"stamp-clown"		= 'html/images/stamp_icons/large_stamp-clown.png',
		"stamp-deny"		= 'html/images/stamp_icons/large_stamp-deny.png',
		"stamp-ok"			= 'html/images/stamp_icons/large_stamp-ok.png',
		"stamp-hop"			= 'html/images/stamp_icons/large_stamp-hop.png',
		"stamp-cmo"			= 'html/images/stamp_icons/large_stamp-cmo.png',
		"stamp-ce"			= 'html/images/stamp_icons/large_stamp-ce.png',
		"stamp-hos"			= 'html/images/stamp_icons/large_stamp-hos.png',
		"stamp-rd"			= 'html/images/stamp_icons/large_stamp-rd.png',
		"stamp-cap"			= 'html/images/stamp_icons/large_stamp-cap.png',
		"stamp-qm"			= 'html/images/stamp_icons/large_stamp-qm.png',
		"stamp-law"			= 'html/images/stamp_icons/large_stamp-law.png',
		"stamp-chap"		= 'html/images/stamp_icons/large_stamp-chap.png',
		"stamp-mime"		= 'html/images/stamp_icons/large_stamp-mime.png',
		"stamp-centcom" 	= 'html/images/stamp_icons/large_stamp-centcom.png',
		"stamp-syndicate" 	= 'html/images/stamp_icons/large_stamp-syndicate.png'
	)

/datum/asset/simple/changelog
	legacy = TRUE
	assets = list(
		"88x31.png" 				= 'html/changelog/88x31.png',
		"bug-minus.png" 			= 'html/changelog/bug-minus.png',
		"cross-circle.png" 			= 'html/changelog/cross-circle.png',
		"hard-hat-exclamation.png" 	= 'html/changelog/hard-hat-exclamation.png',
		"image-minus.png" 			= 'html/changelog/image-minus.png',
		"image-plus.png" 			= 'html/changelog/image-plus.png',
		"music-minus.png" 			= 'html/changelog/music-minus.png',
		"music-plus.png" 			= 'html/changelog/music-plus.png',
		"tick-circle.png" 			= 'html/changelog/tick-circle.png',
		"wrench-screwdriver.png" 	= 'html/changelog/wrench-screwdriver.png',
		"spell-check.png" 			= 'html/changelog/spell-check.png',
		"burn-exclamation.png" 		= 'html/changelog/burn-exclamation.png',
		"chevron.png" 				= 'html/changelog/chevron.png',
		"chevron-expand.png" 		= 'html/changelog/chevron-expand.png',
		"scales.png" 				= 'html/changelog/scales.png',
		"coding.png" 				= 'html/changelog/coding.png',
		"ban.png" 					= 'html/changelog/ban.png',
		"chrome-wrench.png" 		= 'html/changelog/chrome-wrench.png',
		"changelog.css" 			= 'html/changelog/changelog.css'
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/fonts/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/fonts/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/fonts/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/fonts/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'html/fonts/font-awesome/css/v4-shims.min.css'
	)
	parents = list("font-awesome.css" = 'html/fonts/font-awesome/css/all.min.css')

/datum/asset/simple/namespaced/common
	assets = list(
		"padlock.png"	= 'html/images/padlock.png',
		"loading.gif"	= 'html/images/loading.gif'
	)
	parents = list("common.css" = 'html/browser/common.css')

/datum/asset/simple/arcade
	assets = list(
		"boss1.gif" = 'html/images/ui_icons/arcade/boss1.gif',
		"boss2.gif" = 'html/images/ui_icons/arcade/boss2.gif',
		"boss3.gif" = 'html/images/ui_icons/arcade/boss3.gif',
		"boss4.gif" = 'html/images/ui_icons/arcade/boss4.gif',
		"boss5.gif" = 'html/images/ui_icons/arcade/boss5.gif',
		"boss6.gif" = 'html/images/ui_icons/arcade/boss6.gif',
	)

/datum/asset/simple/pills
	assets = list(
		"pill1"  = 'html/images/ui_icons/pills/pill1.png',
		"pill2"  = 'html/images/ui_icons/pills/pill2.png',
		"pill3"  = 'html/images/ui_icons/pills/pill3.png',
		"pill4"  = 'html/images/ui_icons/pills/pill4.png',
		"pill5"  = 'html/images/ui_icons/pills/pill5.png',
		"pill6"  = 'html/images/ui_icons/pills/pill6.png',
		"pill7"  = 'html/images/ui_icons/pills/pill7.png',
		"pill8"  = 'html/images/ui_icons/pills/pill8.png',
		"pill9"  = 'html/images/ui_icons/pills/pill9.png',
		"pill10" = 'html/images/ui_icons/pills/pill10.png',
		"pill11" = 'html/images/ui_icons/pills/pill11.png',
		"pill12" = 'html/images/ui_icons/pills/pill12.png',
		"pill13" = 'html/images/ui_icons/pills/pill13.png',
		"pill14" = 'html/images/ui_icons/pills/pill14.png',
		"pill15" = 'html/images/ui_icons/pills/pill15.png',
		"pill16" = 'html/images/ui_icons/pills/pill16.png',
		"pill17" = 'html/images/ui_icons/pills/pill17.png',
		"pill18" = 'html/images/ui_icons/pills/pill18.png',
		"pill19" = 'html/images/ui_icons/pills/pill19.png',
		"pill20" = 'html/images/ui_icons/pills/pill20.png',
		"pill21" = 'html/images/ui_icons/pills/pill21.png',
		"pill22" = 'html/images/ui_icons/pills/pill22.png',
	)

/datum/asset/spritesheet/sheetmaterials
	name = "sheetmaterials"

/datum/asset/spritesheet/sheetmaterials/register()
	InsertAll("", 'icons/obj/stack_objects.dmi')
	..()

/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)

/datum/asset/simple/permissions_panel
	legacy = TRUE
	assets = list(
		"search.js" = 'html/admin/search.js',
		"panels.css" = 'html/admin/panels.css'
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery.min.js',
	)
