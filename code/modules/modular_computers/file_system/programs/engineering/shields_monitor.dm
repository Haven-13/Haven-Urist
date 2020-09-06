/datum/computer_file/program/shields_monitor
	filename = "shieldsmonitor"
	filedesc = "Shield Generators Monitoring"
	ui_module_path = /datum/ui_module/shields_monitor/
	program_icon_state = "shield"
	program_key_state = "generic_key"
	program_menu_icon = "radio-on"
	extended_desc = "This program connects to shield generators and monitors their statuses."
	ui_header = "shield.gif"
	requires_ntnet = 1
	network_destination = "shields monitoring system"
	size = 10
