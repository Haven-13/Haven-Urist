/datum/ui_module/program/computer_nttransfer
	name = "NTNet P2P Transfer Client"

/datum/ui_module/program/computer_nttransfer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "NtnetTransferProgram")
		ui.open()

/datum/ui_module/program/computer_nttransfer/ui_data(mob/user)
	if(!program)
		return
	var/datum/computer_file/program/nttransfer/PRG = program
	if(!istype(PRG))
		return

	var/list/data = program.get_header_data()

	if(PRG.error)
		data["error"] = PRG.error
	else if(PRG.downloaded_file)
		data["downloading"] = 1
		data["download_size"] = PRG.downloaded_file.size
		data["download_progress"] = PRG.download_completion
		data["download_netspeed"] = PRG.actual_netspeed
		data["download_name"] = "[PRG.downloaded_file.filename].[PRG.downloaded_file.filetype]"
	else if (PRG.provided_file)
		data["uploading"] = 1
		data["upload_uid"] = PRG.unique_token
		data["upload_clients"] = PRG.connected_clients.len
		data["upload_haspassword"] = PRG.server_password ? 1 : 0
		data["upload_filename"] = "[PRG.provided_file.filename].[PRG.provided_file.filetype]"
	else if (PRG.upload_menu)
		var/list/all_files[0]
		for(var/datum/computer_file/F in PRG.computer.hard_drive.stored_files)
			all_files.Add(list(list(
			"uid" = F.uid,
			"filename" = "[F.filename].[F.filetype]",
			"size" = F.size
			)))
		data["upload_filelist"] = all_files
	else
		var/list/all_servers[0]
		for(var/datum/computer_file/program/nttransfer/P in ntnet_global.fileservers)
			if(!P.provided_file)
				continue
			all_servers.Add(list(list(
			"uid" = P.unique_token,
			"filename" = "[P.provided_file.filename].[P.provided_file.filetype]",
			"size" = P.provided_file.size,
			"haspassword" = P.server_password ? 1 : 0
			)))
		data["servers"] = all_servers

	return data