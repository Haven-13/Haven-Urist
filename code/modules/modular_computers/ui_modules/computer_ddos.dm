
/datum/ui_module/program/computer_dos
	name = "DoS Traffic Generator"

/datum/ui_module/program/computer_dos/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "DosTraffiProgram")
		ui.open()

/datum/ui_module/program/computer_dos/ui_data(mob/user)
	if(!ntnet_global)
		return
	var/datum/computer_file/program/ntnet_dos/PRG = program
	var/list/data = list()
	if(!istype(PRG))
		return
	data = PRG.get_header_data()

	if(PRG.error)
		data["error"] = PRG.error
	else if(PRG.target && PRG.executed)
		data["target"] = 1
		data["speed"] = PRG.dos_speed

		// This is mostly visual, generate some strings of 1s and 0s
		// Probability of 1 is equal of completion percentage of DoS attack on this relay.
		// Combined with UI updates this adds quite nice effect to the UI
		var/percentage = PRG.target.dos_overload * 100 / PRG.target.dos_capacity
		var/list/strings[0]
		for(var/j, j<10, j++)
			var/string = ""
			for(var/i, i<20, i++)
				string = "[string][prob(percentage)]"
			strings.Add(string)
		data["dos_strings"] = strings
	else
		var/list/relays[0]
		for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
			relays.Add(R.uid)
		data["relays"] = relays
		data["focus"] = PRG.target ? PRG.target.uid : null

	return data
