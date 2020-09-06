/datum/computer_file/program/docking
	filename = "docking"
	filedesc = "Docking Control"
	required_access = access_bridge
	ui_module_path = /datum/ui_module/docking
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "triangle-2-e-w"
	extended_desc = "A management tool that lets you see the status of the docking ports."
	size = 10
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/computer_file/program/docking/run_program()
	. = ..()
	if(NM)
		var/datum/ui_module/docking/NMD = NM
		NMD.refresh_docks()
