/datum/ui_module/program/revelation
	name = "Revelation Virus"
	ui_interface_name = "programs/RevelationVirusProgram"

/datum/ui_module/program/revelation/ui_data(mob/user)
	var/list/data = list()
	var/datum/computer_file/program/revelation/PRG = program
	if(!istype(PRG))
		return

	data = PRG.get_header_data()

	data["armed"] = PRG.armed

	return data
