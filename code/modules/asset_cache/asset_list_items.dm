//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui_common
	keep_local_name = TRUE
	assets = list(
		"tgui-common.bundle.js" = file("tgui/public/tgui-common.bundle.js"),
	)

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/ntos_headers
	legacy = TRUE
	assets = list(
		"alarm_green.gif" 			= 'resources/html/images/program_icons/alarm_green.gif',
		"alarm_red.gif" 			= 'resources/html/images/program_icons/alarm_red.gif',
		"batt_5.gif" 				= 'resources/html/images/program_icons/batt_5.gif',
		"batt_20.gif" 				= 'resources/html/images/program_icons/batt_20.gif',
		"batt_40.gif" 				= 'resources/html/images/program_icons/batt_40.gif',
		"batt_60.gif" 				= 'resources/html/images/program_icons/batt_60.gif',
		"batt_80.gif" 				= 'resources/html/images/program_icons/batt_80.gif',
		"batt_100.gif" 				= 'resources/html/images/program_icons/batt_100.gif',
		"borg_mon.gif"				= 'resources/html/images/program_icons/borg_mon.gif',
		"charging.gif" 				= 'resources/html/images/program_icons/charging.gif',
		"crew_green.gif"			= 'resources/html/images/program_icons/crew_green.gif',
		"crew_red.gif"				= 'resources/html/images/program_icons/crew_red.gif',
		"downloader_finished.gif" 	= 'resources/html/images/program_icons/downloader_finished.gif',
		"downloader_running.gif" 	= 'resources/html/images/program_icons/downloader_running.gif',
		"ntnrc_idle.gif"			= 'resources/html/images/program_icons/ntnrc_idle.gif',
		"ntnrc_new.gif"				= 'resources/html/images/program_icons/ntnrc_new.gif',
		"power_norm.gif"			= 'resources/html/images/program_icons/power_norm.gif',
		"power_warn.gif"			= 'resources/html/images/program_icons/power_warn.gif',
		"shield.gif"				= 'resources/html/images/program_icons/shield.gif',
		"sig_high.gif" 				= 'resources/html/images/program_icons/sig_high.gif',
		"sig_low.gif" 				= 'resources/html/images/program_icons/sig_low.gif',
		"sig_lan.gif" 				= 'resources/html/images/program_icons/sig_lan.gif',
		"sig_none.gif" 				= 'resources/html/images/program_icons/sig_none.gif',
		"smmon_0.gif" 				= 'resources/html/images/program_icons/smmon_0.gif',
		"smmon_1.gif" 				= 'resources/html/images/program_icons/smmon_1.gif',
		"smmon_2.gif" 				= 'resources/html/images/program_icons/smmon_2.gif',
		"smmon_3.gif" 				= 'resources/html/images/program_icons/smmon_3.gif',
		"smmon_4.gif" 				= 'resources/html/images/program_icons/smmon_4.gif',
		"smmon_5.gif" 				= 'resources/html/images/program_icons/smmon_5.gif',
		"smmon_6.gif" 				= 'resources/html/images/program_icons/smmon_6.gif',
	)

/datum/asset/simple/pda
	assets = list(
		"atmos"			= 'resources/html/images/pda_icons/pda_atmos.png',
		"back"			= 'resources/html/images/pda_icons/pda_back.png',
		"bell"			= 'resources/html/images/pda_icons/pda_bell.png',
		"blank"			= 'resources/html/images/pda_icons/pda_blank.png',
		"boom"			= 'resources/html/images/pda_icons/pda_boom.png',
		"bucket"		= 'resources/html/images/pda_icons/pda_bucket.png',
		"medbot"		= 'resources/html/images/pda_icons/pda_medbot.png',
		"floorbot"		= 'resources/html/images/pda_icons/pda_floorbot.png',
		"cleanbot"		= 'resources/html/images/pda_icons/pda_cleanbot.png',
		"crate"			= 'resources/html/images/pda_icons/pda_crate.png',
		"cuffs"			= 'resources/html/images/pda_icons/pda_cuffs.png',
		"eject"			= 'resources/html/images/pda_icons/pda_eject.png',
		"flashlight"	= 'resources/html/images/pda_icons/pda_flashlight.png',
		"honk"			= 'resources/html/images/pda_icons/pda_honk.png',
		"mail"			= 'resources/html/images/pda_icons/pda_mail.png',
		"medical"		= 'resources/html/images/pda_icons/pda_medical.png',
		"menu"			= 'resources/html/images/pda_icons/pda_menu.png',
		"mule"			= 'resources/html/images/pda_icons/pda_mule.png',
		"notes"			= 'resources/html/images/pda_icons/pda_notes.png',
		"power"			= 'resources/html/images/pda_icons/pda_power.png',
		"rdoor"			= 'resources/html/images/pda_icons/pda_rdoor.png',
		"reagent"		= 'resources/html/images/pda_icons/pda_reagent.png',
		"refresh"		= 'resources/html/images/pda_icons/pda_refresh.png',
		"scanner"		= 'resources/html/images/pda_icons/pda_scanner.png',
		"signaler"		= 'resources/html/images/pda_icons/pda_signaler.png',
		"skills"		= 'resources/html/images/pda_icons/pda_skills.png',
		"status"		= 'resources/html/images/pda_icons/pda_status.png',
		"dronephone"	= 'resources/html/images/pda_icons/pda_dronephone.png',
		"emoji"			= 'resources/html/images/pda_icons/pda_emoji.png'
	)

/datum/asset/group/paper
	children = list(
		/datum/asset/simple/paper_logos,
		/datum/asset/simple/paper_stamps
	)

/datum/asset/simple/paper_logos
	legacy = TRUE
	assets = list(
		"bluentlogo.png"	= 'resources/html/images/bluentlogo.png',
		"ntlogo.png"		= 'resources/html/images/ntlogo.png',
		"sollogo.png"		= 'resources/html/images/sollogo.png',
		"talisman.png"		= 'resources/html/images/talisman.png',
		"terralogo.png"		= 'resources/html/images/terralogo.png'
	)

/datum/asset/simple/paper_stamps
	legacy = TRUE
	assets = list(
		"stamp-clown"		= 'resources/html/images/stamp_icons/large_stamp-clown.png',
		"stamp-deny"		= 'resources/html/images/stamp_icons/large_stamp-deny.png',
		"stamp-ok"			= 'resources/html/images/stamp_icons/large_stamp-ok.png',
		"stamp-hop"			= 'resources/html/images/stamp_icons/large_stamp-hop.png',
		"stamp-cmo"			= 'resources/html/images/stamp_icons/large_stamp-cmo.png',
		"stamp-ce"			= 'resources/html/images/stamp_icons/large_stamp-ce.png',
		"stamp-hos"			= 'resources/html/images/stamp_icons/large_stamp-hos.png',
		"stamp-rd"			= 'resources/html/images/stamp_icons/large_stamp-rd.png',
		"stamp-cap"			= 'resources/html/images/stamp_icons/large_stamp-cap.png',
		"stamp-qm"			= 'resources/html/images/stamp_icons/large_stamp-qm.png',
		"stamp-law"			= 'resources/html/images/stamp_icons/large_stamp-law.png',
		"stamp-chap"		= 'resources/html/images/stamp_icons/large_stamp-chap.png',
		"stamp-mime"		= 'resources/html/images/stamp_icons/large_stamp-mime.png',
		"stamp-centcom" 	= 'resources/html/images/stamp_icons/large_stamp-centcom.png',
		"stamp-syndicate" 	= 'resources/html/images/stamp_icons/large_stamp-syndicate.png'
	)

/datum/asset/simple/changelog
	legacy = TRUE
	assets = list(
		"88x31.png" 				= 'resources/html/changelog/88x31.png',
		"bug-minus.png" 			= 'resources/html/changelog/bug-minus.png',
		"cross-circle.png" 			= 'resources/html/changelog/cross-circle.png',
		"hard-hat-exclamation.png" 	= 'resources/html/changelog/hard-hat-exclamation.png',
		"image-minus.png" 			= 'resources/html/changelog/image-minus.png',
		"image-plus.png" 			= 'resources/html/changelog/image-plus.png',
		"music-minus.png" 			= 'resources/html/changelog/music-minus.png',
		"music-plus.png" 			= 'resources/html/changelog/music-plus.png',
		"tick-circle.png" 			= 'resources/html/changelog/tick-circle.png',
		"wrench-screwdriver.png" 	= 'resources/html/changelog/wrench-screwdriver.png',
		"spell-check.png" 			= 'resources/html/changelog/spell-check.png',
		"burn-exclamation.png" 		= 'resources/html/changelog/burn-exclamation.png',
		"chevron.png" 				= 'resources/html/changelog/chevron.png',
		"chevron-expand.png" 		= 'resources/html/changelog/chevron-expand.png',
		"scales.png" 				= 'resources/html/changelog/scales.png',
		"coding.png" 				= 'resources/html/changelog/coding.png',
		"ban.png" 					= 'resources/html/changelog/ban.png',
		"chrome-wrench.png" 		= 'resources/html/changelog/chrome-wrench.png',
		"changelog.css" 			= 'resources/html/changelog/changelog.css'
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'resources/html/fonts/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'resources/html/fonts/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'resources/html/fonts/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'resources/html/fonts/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'resources/html/fonts/font-awesome/css/v4-shims.min.css'
	)
	parents = list("font-awesome.css" = 'resources/html/fonts/font-awesome/css/all.min.css')

/datum/asset/simple/namespaced/common
	assets = list(
		"padlock.png"	= 'resources/html/images/padlock.png',
		"loading.gif"	= 'resources/html/images/loading.gif'
	)
	parents = list("common.css" = 'resources/html/browser/common.css')

/datum/asset/simple/arcade
	assets = list(
		"boss1.gif" = 'resources/html/images/ui_icons/arcade/boss1.gif',
		"boss2.gif" = 'resources/html/images/ui_icons/arcade/boss2.gif',
		"boss3.gif" = 'resources/html/images/ui_icons/arcade/boss3.gif',
		"boss4.gif" = 'resources/html/images/ui_icons/arcade/boss4.gif',
		"boss5.gif" = 'resources/html/images/ui_icons/arcade/boss5.gif',
		"boss6.gif" = 'resources/html/images/ui_icons/arcade/boss6.gif',
	)

/datum/asset/simple/pills
	assets = list(
		"pill1"  = 'resources/html/images/ui_icons/pills/pill1.png',
		"pill2"  = 'resources/html/images/ui_icons/pills/pill2.png',
		"pill3"  = 'resources/html/images/ui_icons/pills/pill3.png',
		"pill4"  = 'resources/html/images/ui_icons/pills/pill4.png',
		"pill5"  = 'resources/html/images/ui_icons/pills/pill5.png',
		"pill6"  = 'resources/html/images/ui_icons/pills/pill6.png',
		"pill7"  = 'resources/html/images/ui_icons/pills/pill7.png',
		"pill8"  = 'resources/html/images/ui_icons/pills/pill8.png',
		"pill9"  = 'resources/html/images/ui_icons/pills/pill9.png',
		"pill10" = 'resources/html/images/ui_icons/pills/pill10.png',
		"pill11" = 'resources/html/images/ui_icons/pills/pill11.png',
		"pill12" = 'resources/html/images/ui_icons/pills/pill12.png',
		"pill13" = 'resources/html/images/ui_icons/pills/pill13.png',
		"pill14" = 'resources/html/images/ui_icons/pills/pill14.png',
		"pill15" = 'resources/html/images/ui_icons/pills/pill15.png',
		"pill16" = 'resources/html/images/ui_icons/pills/pill16.png',
		"pill17" = 'resources/html/images/ui_icons/pills/pill17.png',
		"pill18" = 'resources/html/images/ui_icons/pills/pill18.png',
		"pill19" = 'resources/html/images/ui_icons/pills/pill19.png',
		"pill20" = 'resources/html/images/ui_icons/pills/pill20.png',
		"pill21" = 'resources/html/images/ui_icons/pills/pill21.png',
		"pill22" = 'resources/html/images/ui_icons/pills/pill22.png',
	)

/datum/asset/spritesheet/sheetmaterials
	name = "sheetmaterials"

/datum/asset/spritesheet/sheetmaterials/register()
	InsertAll("", 'resources/icons/obj/stack_objects.dmi')
	..()

/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'resources/html/admin/view_variables.css'
	)

/datum/asset/simple/permissions_panel
	legacy = TRUE
	assets = list(
		"search.js" = 'resources/html/admin/search.js',
		"panels.css" = 'resources/html/admin/panels.css'
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'resources/html/jquery.min.js',
	)
