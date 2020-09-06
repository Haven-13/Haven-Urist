/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	ui_module_path = /datum/ui_module/alarm_monitor/engineering
	ui_header = "alarm_green.gif"
	program_icon_state = "alert-green"
	program_key_state = "atmos_key"
	program_menu_icon = "alert"
	extended_desc = "This program provides visual interface for the alarm system."
	requires_ntnet = 1
	network_destination = "alarm monitoring network"
	size = 5
	usage_flags = PROGRAM_ALL
	var/has_alert = 0

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	var/datum/ui_module/alarm_monitor/NMA = NM
	if(istype(NMA) && NMA.has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert-red"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = 0
	return 1
