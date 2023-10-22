/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'resources/icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit = null

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.

	var/ui_template = "spacecraft/ShuttleConsole"


/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	ui_interact(user)

/obj/machinery/computer/shuttle_control/proc/get_shuttle_ui_data(datum/shuttle/autodock/shuttle)
	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"


	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else
				shuttle_status = "Standing by."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Launching..."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving..."

	return list(
		"hasTimeLeft" = shuttle.has_arrive_time(),
		"timeLeft" = shuttle.has_arrive_time() ? shuttle.time_left() : null,
		"currentLocation" = shuttle.current_location.name,
		"shuttleStatus" = shuttle_status,
		"shuttleState" = shuttle_state,
		"hasDocking" = shuttle.shuttle_docking_controller? 1 : 0,
		"dockingStatus" = shuttle.shuttle_docking_controller? shuttle.shuttle_docking_controller.get_docking_status() : null,
		"dockingOverride" = shuttle.shuttle_docking_controller? shuttle.shuttle_docking_controller.override_enabled : null,
		"canLaunch" = shuttle.can_launch(),
		"canCancel" = shuttle.can_cancel(),
		"canForce" = shuttle.can_force(),
		"dockingCodes" = shuttle.docking_codes
	)

/obj/machinery/computer/shuttle_control/ui_data(mob/user)
	var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]

	if (!istype(shuttle))
		to_chat(user,"<span class='warning'>Unable to establish link with the shuttle.</span>")
		return list()

	return get_shuttle_ui_data(shuttle)

/obj/machinery/computer/shuttle_control/proc/handle_ui_act(datum/shuttle/autodock/shuttle, action, list/params, user)
	if(!istype(shuttle))
		return FALSE

	switch(action)
		if("move")
			if(!shuttle.next_location.is_valid(shuttle))
				to_chat(user, "<span class='warning'>Destination zone is invalid or obstructed.</span>")
				. = FALSE
			else
				shuttle.launch(src)
				. = TRUE
		if("force")
			shuttle.force_launch(src)
			. = TRUE
		if("abort")
			shuttle.cancel_launch(src)
			. = TRUE
		if("set_codes")
			var/newcode = params["code"]
			shuttle.set_docking_codes(uppertext(newcode))
			. = TRUE

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_template, name)
		ui.open()

/obj/machinery/computer/shuttle_control/ui_act(action, list/params)
	UI_ACT_CHECK
	return handle_ui_act(SSshuttle.shuttles[shuttle_tag], action, params, usr)

/obj/machinery/computer/shuttle_control/emag_act(remaining_charges, mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1

/obj/machinery/computer/shuttle_control/bullet_act(obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act()
	return
