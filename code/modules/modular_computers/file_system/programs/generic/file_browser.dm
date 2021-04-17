/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 8
	requires_ntnet = 0
	available_on_ntnet = 0
	undeletable = 1
	ui_module_path = /datum/ui_module/program/computer_filemanager/
	var/open_file
	var/error
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/filemanager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return TRUE

	switch(action)
		if("PRG_openfile")
			. = 1
			open_file = "PRG_openfile"
		if("PRG_newtextfile")
			. = 1
			var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
			if(!newname)
				return 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/data/F = new/datum/computer_file/data()
			F.filename = newname
			F.filetype = "TXT"
			HDD.store_file(F)
		if("PRG_deletefile")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/file = HDD.find_file_by_name(params["name"])
			if(!file || file.undeletable)
				return 1
			HDD.remove_file(file)
		if("PRG_usbdeletefile")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/RHDD = computer.portable_drive
			if(!RHDD)
				return 1
			var/datum/computer_file/file = RHDD.find_file_by_name(params["name"])
			if(!file || file.undeletable)
				return 1
			RHDD.remove_file(file)
		if("PRG_closefile")
			. = 1
			open_file = null
			error = null
		if("PRG_clone")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/F = HDD.find_file_by_name(params["file"])
			if(!F || !istype(F))
				return 1
			var/datum/computer_file/C = F.clone(1)
			HDD.store_file(C)
		if("PRG_rename")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/file = HDD.find_file_by_name(params["name"])
			if(!file || !istype(file))
				return 1
			var/newname = sanitize(params["new_name"])
			if(file && newname)
				file.filename = newname
		if("PRG_edit")
			. = 1
			if(!open_file)
				return 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			if(!F || !istype(F))
				return 1
			if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
				return 1

			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[br\]", "\n")

			var/newtext = sanitize(replacetext(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
			if(!newtext)
				return

			if(F)
				var/datum/computer_file/data/backup = F.clone()
				HDD.remove_file(F)
				F.stored_data = newtext
				F.calculate_size()
				// We can't store the updated file, it's probably too large. Print an error and restore backed up version.
				// This is mostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
				// They will be able to copy-paste the text from error screen and store it in notepad or something.
				if(!HDD.store_file(F))
					error = "I/O error: Unable to overwrite file. Hard drive is probably full. You may want to backup your changes before closing this window:<br><br>[html_decode(F.stored_data)]<br><br>"
					HDD.store_file(backup)
		if("PRG_printfile")
			. = 1
			if(!open_file)
				return 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return 1
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			if(!F || !istype(F))
				return 1
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have required hardware to complete this operation."
				return 1
			if(!computer.nano_printer.print_text(pencode2html(F.stored_data)))
				error = "Hardware error: Printer was unable to print the file. It may be out of paper."
				return 1
		if("PRG_copytousb")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return 1
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_copytousb"])
			if(!F || !istype(F))
				return 1
			var/datum/computer_file/C = F.clone(0)
			RHDD.store_file(C)
		if("PRG_copyfromusb")
			. = 1
			var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return 1
			var/datum/computer_file/F = RHDD.find_file_by_name(params["PRG_copyfromusb"])
			if(!F || !istype(F))
				return 1
			var/datum/computer_file/C = F.clone(0)
			HDD.store_file(C)
