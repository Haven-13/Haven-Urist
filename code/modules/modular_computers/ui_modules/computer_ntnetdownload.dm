/datum/ui_module/program/computer_ntnetdownload
	name = "Network Downloader"
	var/obj/item/modular_computer/my_computer = null

/datum/ui_module/program/computer_ntnetdownload/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "NtnetDownloaderProgram")
		ui.open()

/datum/ui_module/program/computer_ntnetdownload/ui_data(mob/user)
	if(program)
		my_computer = program.computer

	if(!istype(my_computer))
		return

	var/list/data = list()
	var/datum/computer_file/program/ntnetdownload/prog = program
	// For now limited to execution by the downloader program
	if(!prog || !istype(prog))
		return
	if(program)
		data = program.get_header_data()

	// This IF cuts on data transferred to client, so i guess it's worth it.
	if(prog.downloaderror) // Download errored. Wait until user resets the program.
		data["error"] = prog.downloaderror
	if(prog.downloaded_file) // Download running. Wait please..
		data["downloadname"] = prog.downloaded_file.filename
		data["downloaddesc"] = prog.downloaded_file.filedesc
		data["downloadsize"] = prog.downloaded_file.size
		data["downloadspeed"] = prog.download_netspeed
		data["downloadcompletion"] = round(prog.download_completion, 0.1)

	data["disk_size"] = my_computer.hard_drive.max_capacity
	data["disk_used"] = my_computer.hard_drive.used_capacity
	var/list/all_entries[0]
	for(var/datum/computer_file/program/P in ntnet_global.available_station_software)
		// Only those programs our user can run will show in the list
		if(!P.can_run(user) && P.requires_access_to_download)
			continue
		if(!P.is_supported_by_hardware(my_computer.hardware_flag, 1, user))
			continue
		all_entries.Add(list(list(
		"filename" = P.filename,
		"filedesc" = P.filedesc,
		"fileinfo" = P.extended_desc,
		"size" = P.size,
		"icon" = P.program_menu_icon
		)))
	data["hackedavailable"] = 0
	if(prog.computer_emagged) // If we are running on emagged computer we have access to some "bonus" software
		var/list/hacked_programs[0]
		for(var/datum/computer_file/program/P in ntnet_global.available_antag_software)
			data["hackedavailable"] = 1
			hacked_programs.Add(list(list(
			"filename" = P.filename,
			"filedesc" = P.filedesc,
			"fileinfo" = P.extended_desc,
			"size" = P.size,
			"icon" = P.program_menu_icon
			)))
		data["hacked_programs"] = hacked_programs

	data["downloadable_programs"] = all_entries

	if(prog.downloads_queue.len > 0)
		data["downloads_queue"] = prog.downloads_queue

	return data
