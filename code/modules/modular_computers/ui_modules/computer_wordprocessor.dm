/datum/ui_module/program/computer_wordprocessor
	name = "Word Processor"
	ui_interface_name = "programs/NtosWord"

/datum/ui_module/program/computer_wordprocessor/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/wordprocessor/PRG
	PRG = program

	var/obj/item/weapon/computer_hardware/hard_drive/HDD
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD

	data["error"] = PRG.error

	if(!PRG.computer || !PRG.computer.hard_drive)
		data["error"] = "I/O ERROR: Unable to access hard drive."
	else
		HDD = PRG.computer.hard_drive
		var/list/files[0]
		for(var/datum/computer_file/F in HDD.stored_files)
			if(F.filetype == "TXT")
				files.Add(list(list(
					"name" = F.filename,
					"size" = F.size
				)))
		data["files"] = files

		RHDD = PRG.computer.portable_drive
		data["usbconnected"] = !!RHDD
		data["usbfiles"] = list()
		if(RHDD)
			var/list/usbfiles[0]
			for(var/datum/computer_file/F in RHDD.stored_files)
				if(F.filetype == "TXT")
					usbfiles.Add(list(list(
						"name" = F.filename,
						"size" = F.size,
					)))
			data["usbfiles"] = usbfiles

	if(PRG.open_file)
		data["filedata"] = replacetext(PRG.loaded_data, "\[br\]", "\n")
		data["filename"] = PRG.open_file
	else
		data["filedata"] = replacetext(PRG.loaded_data, "\[br\]", "\n")
		data["filename"] = "UNNAMED"

	data["fileexists"] = !!PRG.open_file
	data["is_edited"] = PRG.is_edited

	return data
