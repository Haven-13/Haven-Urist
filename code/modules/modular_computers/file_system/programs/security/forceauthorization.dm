/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization Manager"
	extended_desc = "Control console used to activate the NT Mk30-S NL authorization chip."
	size = 4
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	program_icon_state = "security"
	program_menu_icon = "locked"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_armory
	ui_module_path = /datum/ui_module/forceauthorization/
