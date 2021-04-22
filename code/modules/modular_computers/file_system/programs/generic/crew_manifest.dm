/datum/computer_file/program/crew_manifest
	filename = "crewmanifest"
	filedesc = "Crew Manifest"
	extended_desc = "This program allows access to the manifest of active crew."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 4
	requires_ntnet = 1
	available_on_ntnet = 1
	ui_module_path = /datum/ui_module/program/crew_manifest
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/crew_manifest/ui_act(action, list/params)
	. = ..()
	if (.)
		return TRUE

	switch(action)
		if("PRG_print")
			if(computer && computer.nano_printer) //This option should never be called if there is no printer
				var/contents = html_crew_manifest(FALSE)
				if(!computer.nano_printer.print_text(contents,text("crew manifest ([])", stationtime2text())))
					to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
					return
				else
					computer.visible_message("<span class='notice'>\The [computer] prints out a paper.</span>")

