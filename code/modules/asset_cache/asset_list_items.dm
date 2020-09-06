//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui
	assets = list(
		"tgui.bundle.js" = 'tgui/public/tgui.bundle.js',
		"tgui.bundle.css" = 'tgui/public/tgui.bundle.css',
	)

/datum/asset/group/tgui
	children = list(
		/datum/asset/simple/tgui
	)

/datum/asset/simple/headers
	assets = list(
		"alarm_green.gif" 			= 'images/program_icons/alarm_green.gif',
		"alarm_red.gif" 			= 'images/program_icons/alarm_red.gif',
		"batt_5.gif" 				= 'images/program_icons/batt_5.gif',
		"batt_20.gif" 				= 'images/program_icons/batt_20.gif',
		"batt_40.gif" 				= 'images/program_icons/batt_40.gif',
		"batt_60.gif" 				= 'images/program_icons/batt_60.gif',
		"batt_80.gif" 				= 'images/program_icons/batt_80.gif',
		"batt_100.gif" 				= 'images/program_icons/batt_100.gif',
		"charging.gif" 				= 'images/program_icons/charging.gif',
		"downloader_finished.gif" 	= 'images/program_icons/downloader_finished.gif',
		"downloader_running.gif" 	= 'images/program_icons/downloader_running.gif',
		"ntnrc_idle.gif"			= 'images/program_icons/ntnrc_idle.gif',
		"ntnrc_new.gif"				= 'images/program_icons/ntnrc_new.gif',
		"power_norm.gif"			= 'images/program_icons/power_norm.gif',
		"power_warn.gif"			= 'images/program_icons/power_warn.gif',
		"sig_high.gif" 				= 'images/program_icons/sig_high.gif',
		"sig_low.gif" 				= 'images/program_icons/sig_low.gif',
		"sig_lan.gif" 				= 'images/program_icons/sig_lan.gif',
		"sig_none.gif" 				= 'images/program_icons/sig_none.gif',
		"smmon_0.gif" 				= 'images/program_icons/smmon_0.gif',
		"smmon_1.gif" 				= 'images/program_icons/smmon_1.gif',
		"smmon_2.gif" 				= 'images/program_icons/smmon_2.gif',
		"smmon_3.gif" 				= 'images/program_icons/smmon_3.gif',
		"smmon_4.gif" 				= 'images/program_icons/smmon_4.gif',
		"smmon_5.gif" 				= 'images/program_icons/smmon_5.gif',
		"smmon_6.gif" 				= 'images/program_icons/smmon_6.gif',
		"borg_mon.gif"				= 'images/program_icons/borg_mon.gif'
	)

/datum/asset/simple/radar_assets
	assets = list(
		"ntosradarbackground.png"	= 'images/UI_Icons/tgui/ntosradar_background.png',
		"ntosradarpointer.png"		= 'images/UI_Icons/tgui/ntosradar_pointer.png',
		"ntosradarpointerS.png"		= 'images/UI_Icons/tgui/ntosradar_pointer_S.png'
	)

/datum/asset/simple/pda
	assets = list(
		"atmos"			= 'images/pda_icons/pda_atmos.png',
		"back"			= 'images/pda_icons/pda_back.png',
		"bell"			= 'images/pda_icons/pda_bell.png',
		"blank"			= 'images/pda_icons/pda_blank.png',
		"boom"			= 'images/pda_icons/pda_boom.png',
		"bucket"		= 'images/pda_icons/pda_bucket.png',
		"medbot"		= 'images/pda_icons/pda_medbot.png',
		"floorbot"		= 'images/pda_icons/pda_floorbot.png',
		"cleanbot"		= 'images/pda_icons/pda_cleanbot.png',
		"crate"			= 'images/pda_icons/pda_crate.png',
		"cuffs"			= 'images/pda_icons/pda_cuffs.png',
		"eject"			= 'images/pda_icons/pda_eject.png',
		"flashlight"	= 'images/pda_icons/pda_flashlight.png',
		"honk"			= 'images/pda_icons/pda_honk.png',
		"mail"			= 'images/pda_icons/pda_mail.png',
		"medical"		= 'images/pda_icons/pda_medical.png',
		"menu"			= 'images/pda_icons/pda_menu.png',
		"mule"			= 'images/pda_icons/pda_mule.png',
		"notes"			= 'images/pda_icons/pda_notes.png',
		"power"			= 'images/pda_icons/pda_power.png',
		"rdoor"			= 'images/pda_icons/pda_rdoor.png',
		"reagent"		= 'images/pda_icons/pda_reagent.png',
		"refresh"		= 'images/pda_icons/pda_refresh.png',
		"scanner"		= 'images/pda_icons/pda_scanner.png',
		"signaler"		= 'images/pda_icons/pda_signaler.png',
		"skills"		= 'images/pda_icons/pda_skills.png',
		"status"		= 'images/pda_icons/pda_status.png',
		"dronephone"	= 'images/pda_icons/pda_dronephone.png',
		"emoji"			= 'images/pda_icons/pda_emoji.png'
	)

/datum/asset/simple/paper
	assets = list(
		"stamp-clown"		= 'images/stamp_icons/large_stamp-clown.png',
		"stamp-deny"		= 'images/stamp_icons/large_stamp-deny.png',
		"stamp-ok"			= 'images/stamp_icons/large_stamp-ok.png',
		"stamp-hop"			= 'images/stamp_icons/large_stamp-hop.png',
		"stamp-cmo"			= 'images/stamp_icons/large_stamp-cmo.png',
		"stamp-ce"			= 'images/stamp_icons/large_stamp-ce.png',
		"stamp-hos"			= 'images/stamp_icons/large_stamp-hos.png',
		"stamp-rd"			= 'images/stamp_icons/large_stamp-rd.png',
		"stamp-cap"			= 'images/stamp_icons/large_stamp-cap.png',
		"stamp-qm"			= 'images/stamp_icons/large_stamp-qm.png',
		"stamp-law"			= 'images/stamp_icons/large_stamp-law.png',
		"stamp-chap"		= 'images/stamp_icons/large_stamp-chap.png',
		"stamp-mime"		= 'images/stamp_icons/large_stamp-mime.png',
		"stamp-centcom" 	= 'images/stamp_icons/large_stamp-centcom.png',
		"stamp-syndicate" 	= 'images/stamp_icons/large_stamp-syndicate.png'
	)

/datum/asset/simple/changelog
	assets = list(
		"88x31.png" = 'html/88x31.png',
		"bug-minus.png" = 'html/bug-minus.png',
		"cross-circle.png" = 'html/cross-circle.png',
		"hard-hat-exclamation.png" = 'html/hard-hat-exclamation.png',
		"image-minus.png" = 'html/image-minus.png',
		"image-plus.png" = 'html/image-plus.png',
		"music-minus.png" = 'html/music-minus.png',
		"music-plus.png" = 'html/music-plus.png',
		"tick-circle.png" = 'html/tick-circle.png',
		"wrench-screwdriver.png" = 'html/wrench-screwdriver.png',
		"spell-check.png" = 'html/spell-check.png',
		"burn-exclamation.png" = 'html/burn-exclamation.png',
		"chevron.png" = 'html/chevron.png',
		"chevron-expand.png" = 'html/chevron-expand.png',
		"scales.png" = 'html/scales.png',
		"coding.png" = 'html/coding.png',
		"ban.png" = 'html/ban.png',
		"chrome-wrench.png" = 'html/chrome-wrench.png',
		"changelog.css" = 'html/changelog.css'
	)

/datum/asset/simple/jquery
	assets = list(
		"jquery.min.js" = 'html/jquery.min.js',
	)

/datum/asset/simple/permissions
	assets = list(
		"padlock.png" = 'html/padlock.png'
	)

/datum/asset/simple/arcade
	assets = list(
		"boss1.gif" = 'images/UI_Icons/Arcade/boss1.gif',
		"boss2.gif" = 'images/UI_Icons/Arcade/boss2.gif',
		"boss3.gif" = 'images/UI_Icons/Arcade/boss3.gif',
		"boss4.gif" = 'images/UI_Icons/Arcade/boss4.gif',
		"boss5.gif" = 'images/UI_Icons/Arcade/boss5.gif',
		"boss6.gif" = 'images/UI_Icons/Arcade/boss6.gif',
	)

/datum/asset/simple/pills
	assets = list(
		"pill1"  = 'images/UI_Icons/Pills/pill1.png',
		"pill2"  = 'images/UI_Icons/Pills/pill2.png',
		"pill3"  = 'images/UI_Icons/Pills/pill3.png',
		"pill4"  = 'images/UI_Icons/Pills/pill4.png',
		"pill5"  = 'images/UI_Icons/Pills/pill5.png',
		"pill6"  = 'images/UI_Icons/Pills/pill6.png',
		"pill7"  = 'images/UI_Icons/Pills/pill7.png',
		"pill8"  = 'images/UI_Icons/Pills/pill8.png',
		"pill9"  = 'images/UI_Icons/Pills/pill9.png',
		"pill10" = 'images/UI_Icons/Pills/pill10.png',
		"pill11" = 'images/UI_Icons/Pills/pill11.png',
		"pill12" = 'images/UI_Icons/Pills/pill12.png',
		"pill13" = 'images/UI_Icons/Pills/pill13.png',
		"pill14" = 'images/UI_Icons/Pills/pill14.png',
		"pill15" = 'images/UI_Icons/Pills/pill15.png',
		"pill16" = 'images/UI_Icons/Pills/pill16.png',
		"pill17" = 'images/UI_Icons/Pills/pill17.png',
		"pill18" = 'images/UI_Icons/Pills/pill18.png',
		"pill19" = 'images/UI_Icons/Pills/pill19.png',
		"pill20" = 'images/UI_Icons/Pills/pill20.png',
		"pill21" = 'images/UI_Icons/Pills/pill21.png',
		"pill22" = 'images/UI_Icons/Pills/pill22.png',
	)

/datum/asset/simple/vv
	assets = list(
		"view_variables.css" = 'html/admin/view_variables.css'
	)
