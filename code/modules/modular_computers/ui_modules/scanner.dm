/datum/ui_module/program/scanner
	name = "Scanner"
	ui_interface_name = "programs/ScannerProgram"

/datum/ui_module/program/scanner/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/scanner/prog = program
	if(!prog.computer)
		return

	var/obj/item/weapon/computer_hardware/scanner/scanner = prog.computer.scanner

	data["scanner_name"] = scanner ? prog.computer.scanner.name : null
	data["scanner_enabled"] = scanner ? prog.computer.scanner.enabled : 0
	data["can_view_scan"] = scanner ? scanner.can_view_scan : 0
	data["can_save_scan"] = scanner ? (scanner.can_save_scan && prog.data_buffer) : 0

	data["using_scanner"] = prog.using_scanner
	data["check_scanning"] = prog.check_scanning()
	data["data_buffer"] = pencode2html(prog.data_buffer)

	return data
