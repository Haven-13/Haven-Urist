/datum/ui_module/program/revelation
	name = "Revelation Virus"

/datum/ui_module/program/revelation/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "RevelationVirusProgram")
		ui.open()

/datum/ui_module/program/revelation/ui_data(mob/user)
	var/list/data = list()
	var/datum/computer_file/program/revelation/PRG = program
	if(!istype(PRG))
		return

	data = PRG.get_header_data()

	data["armed"] = PRG.armed

	return data
