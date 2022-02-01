/datum/ui_module/program/rcon
	name = "Power RCON"
	ui_interface_name = "programs/RemoteControlProgram"

	var/list/known_SMESs = null
	var/list/known_breakers = null

/datum/ui_module/program/rcon/ui_static_data(mob/user)
	find_devices()
	. = ..()

/datum/ui_module/program/rcon/ui_data(mob/user)
	. = host.initial_data()

	// SMES DATA (simplified view)
	var/list/smeslist[0]
	for(var/tag in known_SMESs)
		var/obj/machinery/power/smes/buildable/SMES = known_SMESs[tag]
		smeslist.Add(list(SMES.ui_data(user)))

	.["smesUnits"] = sortByKey(smeslist, "rconTag")

	// BREAKER DATA (simplified view)
	var/list/breakerlist[0]
	for(var/tag in known_breakers)
		var/obj/machinery/power/breakerbox/BR = known_breakers[tag]
		breakerlist.Add(list(list(
			"rconTag" = BR.RCon_tag,
			"enabled" = BR.on
		)))
	.["breakers"] = breakerlist

/datum/ui_module/program/rcon/ui_act(action, list/params)
	UI_ACT_CHECK

	var/tag = params["tag"]
	switch(action)
		if("refresh")
			find_devices()
			. = TRUE
		if("smes_in_toggle")
			var/obj/machinery/power/smes/buildable/SMES = known_SMESs[tag]
			SMES?.toggle_input()
			. = TRUE
		if("smes_out_toggle")
			var/obj/machinery/power/smes/buildable/SMES = known_SMESs[tag]
			SMES?.toggle_output()
			. = TRUE
		if("smes_in_set")
			var/obj/machinery/power/smes/buildable/SMES = known_SMESs[tag]
			if(SMES)
				SMES.set_input(
					handle_power_channel_adjustment(
						SMES.input_level,
						0,
						SMES.input_level_max,
						params
					))
				. = TRUE
		if("smes_out_set")
			var/obj/machinery/power/smes/buildable/SMES = known_SMESs[tag]
			if(SMES)
				SMES.set_output(
					handle_power_channel_adjustment(
						SMES.output_level,
						0,
						SMES.output_level_max,
						params
					))
				. = TRUE

		if("toggle_breaker")
			var/obj/machinery/power/breakerbox/toggle = known_breakers[tag]
			if(toggle)
				if(toggle.update_locked)
					to_chat(usr, "The breaker box was recently toggled. Please wait before toggling it again.")
				else
					toggle.auto_toggle()
				. = TRUE

// Proc: find_devices()
// Parameters: None
// Description: Refreshes local list of known devices.
/datum/ui_module/program/rcon/proc/find_devices()
	known_SMESs = list()
	for(var/obj/machinery/power/smes/buildable/SMES in SSmachines.machinery)
		if(AreConnectedZLevels(get_host_z(), get_z(SMES)) && SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			known_SMESs[SMES.RCon_tag] = SMES

	known_breakers = list()
	for(var/obj/machinery/power/breakerbox/breaker in SSmachines.machinery)
		if(AreConnectedZLevels(get_host_z(), get_z(breaker)) && breaker.RCon_tag != "NO_TAG")
			known_breakers[breaker.RCon_tag] = breaker
