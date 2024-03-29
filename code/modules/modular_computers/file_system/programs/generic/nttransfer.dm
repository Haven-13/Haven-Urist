var/global/nttransfer_uid = 0

/datum/computer_file/program/nttransfer
	filename = "nttransfer"
	filedesc = "NTNet P2P Transfer Client"
	extended_desc = "This program allows for simple file transfer via direct peer to peer connection."
	program_icon_state = "comm_logs"
	program_key_state = "generic_key"
	program_menu_icon = "transferthick-e-w"
	size = 7
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_PEERTOPEER
	network_destination = "other device via P2P tunnel"
	available_on_ntnet = 1
	ui_module_path = /datum/ui_module/program/computer_nttransfer/

	var/error = ""										// Error screen
	var/server_password = ""							// Optional password to download the file.
	var/datum/computer_file/provided_file = null		// File which is provided to clients.
	var/datum/computer_file/downloaded_file = null		// File which is being downloaded
	var/list/connected_clients = list()					// List of connected clients.
	var/datum/computer_file/program/nttransfer/remote	// Client var, specifies who are we downloading from.
	var/download_completion = 0							// Download progress in GQ
	var/actual_netspeed = 0								// Displayed in the UI, this is the actual transfer speed.
	var/unique_token 									// UID of this program
	var/upload_menu = 0									// Whether we show the program list and upload menu

/datum/computer_file/program/nttransfer/New()
	unique_token = nttransfer_uid
	nttransfer_uid++
	..()

/datum/computer_file/program/nttransfer/process_tick()
	..()
	// Server mode
	if(provided_file)
		for(var/datum/computer_file/program/nttransfer/C in connected_clients)
			// Transfer speed is limited by device which uses slower connectivity.
			// We can have multiple clients downloading at same time, but let's assume we use some sort of multicast transfer
			// so they can all run on same speed.
			C.actual_netspeed = min(C.ntnet_speed, ntnet_speed)
			C.download_completion += C.actual_netspeed
			if(C.download_completion >= provided_file.size)
				C.finish_download()
	else if(downloaded_file) // Client mode
		if(!remote)
			crash_download("Connection to remote server lost")

/datum/computer_file/program/nttransfer/kill_program(forced = 0)
	if(downloaded_file) // Client mode, clean up variables for next use
		finalize_download()

	if(provided_file) // Server mode, disconnect all clients
		for(var/datum/computer_file/program/nttransfer/P in connected_clients)
			P.crash_download("Connection terminated by remote server")
		downloaded_file = null
	..(forced)

// Finishes download and attempts to store the file on HDD
/datum/computer_file/program/nttransfer/proc/finish_download()
	if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(downloaded_file))
		error = "I/O Error:  Unable to save file. Check your hard drive and try again."
	finalize_download()

//  Crashes the download and displays specific error message
/datum/computer_file/program/nttransfer/proc/crash_download(message)
	error = message || "An unknown error has occured during download"
	finalize_download()

// Cleans up variables for next use
/datum/computer_file/program/nttransfer/proc/finalize_download()
	if(remote)
		remote.connected_clients.Remove(src)
	downloaded_file = null
	remote = null
	download_completion = 0

/datum/computer_file/program/nttransfer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["PRG_downloadfile"])
		for(var/datum/computer_file/program/nttransfer/P in ntnet_global.fileservers)
			if("[P.unique_token]" == href_list["PRG_downloadfile"])
				remote = P
				break
		if(!remote || !remote.provided_file)
			return
		if(remote.server_password)
			var/pass = sanitize(input(usr, "Code 401 Unauthorized. Please enter password:", "Password required"))
			if(pass != remote.server_password)
				error = "Incorrect Password"
				return
		downloaded_file = remote.provided_file.clone()
		remote.connected_clients.Add(src)
		return 1
	if(href_list["PRG_reset"])
		error = ""
		upload_menu = 0
		finalize_download()
		if(src in ntnet_global.fileservers)
			ntnet_global.fileservers.Remove(src)
		for(var/datum/computer_file/program/nttransfer/T in connected_clients)
			T.crash_download("Remote server has forcibly closed the connection")
		provided_file = null
		return 1
	if(href_list["PRG_setpassword"])
		var/pass = sanitize(input(usr, "Enter new server password. Leave blank to cancel, input 'none' to disable password.", "Server security", "none"))
		if(!pass)
			return
		if(pass == "none")
			server_password = ""
			return
		server_password = pass
		return 1
	if(href_list["PRG_uploadfile"])
		for(var/datum/computer_file/F in computer.hard_drive.stored_files)
			if("[F.uid]" == href_list["PRG_uploadfile"])
				if(F.unsendable)
					error = "I/O Error: File locked."
					return
				provided_file = F
				ntnet_global.fileservers.Add(src)
				return
		error = "I/O Error: Unable to locate file on hard drive."
		return 1
	if(href_list["PRG_uploadmenu"])
		upload_menu = 1
	return 0
