/datum/computer_file/program/supply
	filename = "supply"
	filedesc = "Supply Management"
	ui_module_path = /datum/ui_module/supply
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "cart"
	extended_desc = "A management tool that allows for ordering of various supplies through the facility's cargo system. Some features may require additional access."
	size = 21
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/computer_file/program/supply/process_tick()
	..()
	var/datum/ui_module/supply/SNM = NM
	if(istype(SNM))
		SNM.emagged = computer_emagged
