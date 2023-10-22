/obj/item/modular_computer/ui_state(mob/user)
	return ui_default_state()

/obj/item/modular_computer/ui_status(mob/user, datum/ui_state/state)
	if(!screen_on || !enabled || bsod)
		return UI_CLOSE

	if(!apc_power(0) && !battery_power(0))
		return UI_CLOSE

	// If we have an active program switch to it now.
	if(active_program)
		active_program.ui_interact(user)
		return UI_CLOSE

	// We are still here, that means there is no program loaded. Load the BIOS/ROM/OS/whatever you want to call it.
	// This screen simply lists available programs and user may select them.
	if(!hard_drive || !hard_drive.stored_files || !hard_drive.stored_files.len)
		visible_message("\The [src] beeps three times, it's screen displaying \"DISK ERROR\" warning.")
		return UI_CLOSE // No HDD, No HDD files list or no stored files. Something is very broken.

	return ..()

// Operates tgUI
/obj/item/modular_computer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "programs/NtosBase")
		ui.open()

/obj/item/modular_computer/ui_data(mob/user)
	var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")

	var/list/data = get_header_data()

	var/list/programs = list()
	for(var/datum/computer_file/program/P in hard_drive.stored_files)
		var/list/program = list()
		program["name"] = P.filename
		program["desc"] = P.filedesc
		program["icon"] = P.program_menu_icon
		program["autorun"] = (istype(autorun) && (autorun.stored_data == P.filename)) ? 1 : 0
		program["running"] = (P in idle_threads) ? 1 : 0
		programs.Add(list(program))

	data["programs"] = programs
	return data

/obj/item/modular_computer/ui_act(action, list/params)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(.)
		return .
	switch(action)
		if("PC_exit")
			kill_program()
			. = TRUE
		if("PC_toggle_component")
			var/obj/item/weapon/computer_hardware/H = find_hardware_by_name(params["name"])
			if(H && istype(H))
				H.enabled = !H.enabled
			. = TRUE
		if("PC_eject_item")
			switch(params["name"])
				if("id_card")
					proc_eject_id(usr)
				if("ai_card")
					proc_eject_ai(usr)
				if("storage")
					proc_eject_usb(usr)
			. = TRUE
		if("PC_shutdown")
			shutdown_computer()
			. = TRUE
		if("PC_minimize")
			minimize_program(usr)
			. = TRUE
		if("PC_killprogram")
			var/prog = params["name"]
			if(hard_drive)
				var/datum/computer_file/program/P = hard_drive.find_file_by_name(prog)
				if(istype(P) && P.program_state != PROGRAM_STATE_KILLED)
					P.kill_program(1)
					to_chat(usr, "<span class='notice'>Program [P.filename].[P.filetype] with PID [rand(100,999)] has been killed.</span>")
			. = TRUE
		if("PC_runprogram")
			. = run_program(params["name"])
		if("PC_setautorun")
			if(hard_drive)
				set_autorun(params["name"])
			. = TRUE

// Function used by tgUI to obtain data for header. All relevant entries begin with "PC_"
/obj/item/modular_computer/proc/get_header_data()
	var/list/data = list()

	if(battery_module)
		switch(battery_module.battery.percent())
			if(80 to 200) // 100 should be maximal but just in case..
				data["PC_batteryicon"] = "batt_100.gif"
			if(60 to 80)
				data["PC_batteryicon"] = "batt_80.gif"
			if(40 to 60)
				data["PC_batteryicon"] = "batt_60.gif"
			if(20 to 40)
				data["PC_batteryicon"] = "batt_40.gif"
			if(5 to 20)
				data["PC_batteryicon"] = "batt_20.gif"
			else
				data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "[round(battery_module.battery.percent())] %"
		data["PC_showbatteryicon"] = 1
	else
		data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "N/C"
		data["PC_showbatteryicon"] = battery_module ? 1 : 0

	if(card_slot)
		data["PC_hascardslot"] = 1
		data["PC_boardcastcard"] = card_slot.can_broadcast
		data["PC_card"] = istype(card_slot.stored_card) ? list(
			"IDName" = card_slot.stored_card.registered_name,
			"IDJob" = card_slot.stored_card.assignment
		) : null
	else
		data["PC_hascardslot"] = 0

	if(tesla_link && tesla_link.enabled && apc_powered)
		data["PC_apclinkicon"] = "charging.gif"

	if(network_card && network_card.is_banned())
		data["PC_ntneticon"] = "sig_warning.gif"
	else
		switch(get_ntnet_status())
			if(0)
				data["PC_ntneticon"] = "sig_none.gif"
			if(1)
				data["PC_ntneticon"] = "sig_low.gif"
			if(2)
				data["PC_ntneticon"] = "sig_high.gif"
			if(3)
				data["PC_ntneticon"] = "sig_lan.gif"

	var/list/program_headers = list()
	for(var/datum/computer_file/program/P in idle_threads)
		if(!P.ui_header)
			continue
		program_headers.Add(list(list(
			"icon" = P.ui_header
		)))
	if(active_program && active_program.ui_header)
		program_headers.Add(list(list(
			"icon" = active_program.ui_header
		)))
	data["PC_programheaders"] = program_headers

	data["PC_stationtime"] = stationtime2text()
	data["PC_hasheader"] = 1
	data["PC_showexitprogram"] = active_program ? 1 : 0 // Hides "Exit Program" button on mainscreen
	return data
