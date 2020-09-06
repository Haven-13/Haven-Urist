/datum/ui_module/program/scanner
	name = "Scanner"

/datum/ui_module/program/scanner/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ScannerProgram")
		ui.open()

/datum/ui_module/program/scanner/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/scanner/prog = program
	if(!prog.computer)
		return
	if(prog.computer.scanner)
		data["scanner_name"] = prog.computer.scanner.name
		data["scanner_enabled"] = prog.computer.scanner.enabled
		data["can_view_scan"] = prog.computer.scanner.can_view_scan
		data["can_save_scan"] = (prog.computer.scanner.can_save_scan && prog.data_buffer)
	data["using_scanner"] = prog.using_scanner
	data["check_scanning"] = prog.check_scanning()
	data["data_buffer"] = pencode2html(prog.data_buffer)

	return data
