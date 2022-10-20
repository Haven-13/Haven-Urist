/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(operating < 0) //emagged
		to_chat(user, "<span class='warning'>Unable to interface: Internal error.</span>")
		return UI_CLOSE
	if(is_silicon(user) && !src.canAIControl())
		if(src.canAIHack(user))
			src.hack(user)
		else
			if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
				to_chat(user, "<span class='warning'>Unable to interface: Connection timed out.</span>")
			else
				to_chat(user, "<span class='warning'>Unable to interface: Connection refused.</span>")
		return UI_CLOSE

	return ..()

/obj/machinery/door/airlock/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AiAirlockControl")
		ui.open()

/obj/machinery/door/airlock/ui_state(mob/user)
	return ui_silicon_only_state()

/obj/machinery/door/airlock/ui_data(mob/user)
	. = ..()

	.["power"] = list(
		"main" = !main_power_lost_until,
		"main_time_left" = main_power_lost_until,
		"backup" = !backup_power_lost_until,
		"backup_time_left" = backup_power_lost_until
	)
	.["shock"] = isElectrified()
	.["shocked_until"] = electrified_until
	.["opened"] = !density
	.["locked"] = locked
	.["welded"] = welded
	.["safe"] = safe
	.["timing"] = normalspeed
	.["id_scanner"] = !aiDisabledIdScanner
	.["lights"] = lights

	// ILL FUCKING GO PSYCHO FROM THIS SHIT!!!!
	.["wires"] = list(
		"backup_1" = !src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER1),
		"backup_2" = !src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER2),
		"main_1" = !src.isWireCut(AIRLOCK_WIRE_MAIN_POWER1),
		"main_2" = !src.isWireCut(AIRLOCK_WIRE_MAIN_POWER2),
		"timing" = !src.isWireCut(AIRLOCK_WIRE_SPEED),
		"safety" = !src.isWireCut(AIRLOCK_WIRE_SAFETY),
		"lights" = !src.isWireCut(AIRLOCK_WIRE_LIGHT),
		"bolts" = !src.isWireCut(AIRLOCK_WIRE_DOOR_BOLTS),
		"shock" = !src.isWireCut(AIRLOCK_WIRE_ELECTRIFY),
		"id_scanner" = !src.isWireCut(AIRLOCK_WIRE_IDSCAN),
	)

/obj/machinery/door/airlock/ui_act(action, list/params)
	if(..())
		return 1

	switch (action)
		if("disrupt_main")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("disrupt_backup")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts_toggle")
			if(src.isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
				to_chat(usr, "The door bolt control wire is cut - Door bolts permanently dropped.")
			else if(locked)
				if(src.unlock())
					to_chat(usr, "The door bolts have been raised.")
			else
				if(src.lock())
					to_chat(usr, "The door bolts have been dropped.")
		if("shock_restore")
			electrify(0, 1)
		if("shock_temporary")
			electrify(30, 1)
		if("shock_permanently")
			electrify(-1, 1)
		if("open_close")
			if(src.welded)
				to_chat(usr, text("The airlock has been welded shut!"))
			else if(src.locked)
				to_chat(usr, text("The door bolts are down!"))
			else if(density)
				open()
			else if(!density)
				close()
		if("idscan_toggle")
			set_idscan(!aiDisabledIdScanner, 1)
		if("safety_toggle")
			set_safeties(!safe, 1)
		if("speed_toggle")
			// Door speed control
			if(src.isWireCut(AIRLOCK_WIRE_SPEED))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (src.normalspeed)
				normalspeed = 0
			else if (!src.normalspeed)
				normalspeed = 1
		if("light_toggle")
			// Lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The lights wire is cut - The door lights are permanently disabled.")
			else if (src.lights)
				lights = 0
				to_chat(usr, "The door lights have been disabled.")
			else if (!src.lights)
				lights = 1
				to_chat(usr, "The door lights have been enabled.")

	update_icon()
	return 1
