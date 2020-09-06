/datum/computer_file/program/scanner
	filename = "scndvr"
	filedesc = "Scanner"
	extended_desc = "This program allows setting up and using an attached scanner module."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	requires_ntnet = 0
	available_on_ntnet = 1
	usage_flags = PROGRAM_ALL
	ui_module_path = /datum/ui_module/program/scanner

	var/using_scanner = 0	//Whether or not the program is synched with the scanner module.
	var/data_buffer = ""	//Buffers scan output for saving/viewing.
	var/scan_file_type = /datum/computer_file/data/text		//The type of file the data will be saved to.

/datum/computer_file/program/scanner/proc/connect_scanner()	//If already connected, will reconnect.
	if(!computer || !computer.scanner)
		return 0
	if(istype(src, computer.scanner.driver_type))
		using_scanner = 1
		computer.scanner.driver = src
		return 1
	return 0

/datum/computer_file/program/scanner/proc/disconnect_scanner()
	using_scanner = 0
	if(computer && computer.scanner && (src == computer.scanner.driver) )
		computer.scanner.driver = null
	data_buffer = null
	return 1

/datum/computer_file/program/scanner/proc/save_scan(name)
	if(!data_buffer)
		return 0
	if(!create_file(name, data_buffer, scan_file_type))
		return 0
	return 1

/datum/computer_file/program/scanner/proc/check_scanning()
	if(!computer || !computer.scanner)
		return 0
	if(!computer.scanner.can_run_scan)
		return 0
	if(!computer.scanner.check_functionality())
		return 0
	if(!using_scanner)
		return 0
	if(src != computer.scanner.driver)
		return 0
	return 1

/datum/computer_file/program/scanner/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["connect_scanner"])
		if(text2num(href_list["connect_scanner"]))
			if(!connect_scanner())
				to_chat(usr, "Scanner installation failed.")
		else
			disconnect_scanner()
		return 1

	if(href_list["scan"])
		if(check_scanning())
			computer.scanner.run_scan(usr, src)
		return 1

	if(href_list["save"])
		var/name = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!save_scan(name))
			to_chat(usr, "Scan save failed.")

	if(.)
		SStgui.update_uis(NM)

