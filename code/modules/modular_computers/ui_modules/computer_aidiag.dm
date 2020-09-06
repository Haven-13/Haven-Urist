/datum/ui_module/program/computer_aidiag
	name = "AI Maintenance Utility"

/datum/ui_module/program/computer_aidiag/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AiFixerProgram")
		ui.open()

/datum/ui_module/program/computer_aidiag/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/mob/living/silicon/ai/A
	// A shortcut for getting the AI stored inside the computer. The program already does necessary checks.
	if(program && istype(program, /datum/computer_file/program/aidiag))
		var/datum/computer_file/program/aidiag/AD = program
		A = AD.get_ai()

	if(!A)
		data["error"] = "No AI located"
	else
		data["ai_name"] = A.name
		data["ai_integrity"] = A.hardware_integrity()
		data["ai_capacitor"] = A.backup_capacitor()
		data["ai_isdamaged"] = (A.hardware_integrity() < 100) || (A.backup_capacitor() < 100)
		data["ai_isdead"] = (A.stat == DEAD)

		var/list/all_laws[0]
		for(var/datum/ai_law/L in A.laws.all_laws())
			all_laws.Add(list(list(
			"index" = L.index,
			"text" = L.law
			)))

		data["ai_laws"] = all_laws
	return data
