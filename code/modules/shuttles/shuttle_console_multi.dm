/obj/machinery/computer/shuttle_control/multi
	ui_template = "shuttle_control_console_multi.tmpl"

/obj/machinery/computer/shuttle_control/multi/get_shuttle_ui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/multi/handle_ui_act(var/datum/shuttle/autodock/multi/shuttle, var/action, var/list/params)
	if((. = ..()) || !istype(shuttle))
		return

	switch(action)
		if("set_destination")
			var/dest_key = input("Choose shuttle destination", "Shuttle Destination") as null|anything in shuttle.get_destinations()
			if(dest_key && CanInteract(usr, ui_default_state()))
				shuttle.set_destination(dest_key, usr)
			return TRUE


/obj/machinery/computer/shuttle_control/multi/antag
	ui_template = "shuttle_control_console_antag.tmpl"

/obj/machinery/computer/shuttle_control/multi/antag/get_shuttle_ui_data(var/datum/shuttle/autodock/multi/antag/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"cloaked" = shuttle.cloaked,
		)

/obj/machinery/computer/shuttle_control/multi/antag/handle_ui_act(var/datum/shuttle/autodock/multi/antag/shuttle, var/action, var/list/params)
	if((. = ..()) || !istype(shuttle))
		return

	switch(action)
		if("toggle_cloak")
			shuttle.cloaked = !shuttle.cloaked
			return TRUE
