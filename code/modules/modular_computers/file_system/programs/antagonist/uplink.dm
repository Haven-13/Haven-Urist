/datum/computer_file/program/uplink
	filename = "taxquickly"
	filedesc = "TaxQuickly 2559"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software. It is a few years out of date."
	size = 0 // it is cloud based
	requires_ntnet = 0
	available_on_ntnet = 0
	usage_flags = PROGRAM_PDA
	ui_module_path = /datum/ui_module/program/uplink

	var/password
	var/authenticated = 0

/datum/computer_file/program/uplink/New(var/password)
	src.password = password
