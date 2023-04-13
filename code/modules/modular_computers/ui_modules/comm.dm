#define EMERGENCY_COOLDOWN 30 SECONDS
#define ANNOUNCEMENT_COOLDOWN 1 MINUTE

/datum/ui_module/program/comm
	name = "Command and Communications Program"
	ui_interface_name = "programs/CommunicationProgram"
	available_to_ai = TRUE
	var/centcomm_message_cooldown = 0
	var/announcment_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new

/datum/ui_module/program/comm/New()
	..()
	crew_announcement.newscast = 1

/datum/ui_module/program/comm/ui_static_data(mob/user)
	. = ..()

	var/list/all_levels = list()
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	for(var/decl/security_level/security_level in security_state.all_security_levels)
		var/list/security_setup = list()
		security_setup["index"] = all_levels.len
		security_setup["title"] = security_level.name
		security_setup["colour"] = security_level.light_color_status_display
		security_setup["ref"] = any2ref(security_level)
		all_levels[++all_levels.len] = security_setup
	.["all_security_levels"] = all_levels

	.["message_deletion_allowed"] = obtain_message_listener() != GLOB.global_message_listener
	.["has_central_command"] = GLOB.using_map.has_central_command

	var/list/processed_evac_options = list()
	if(!isnull(evacuation_controller))
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			var/list/option = list()
			option["option_text"] = EO.option_text
			option["option_target"] = EO.option_target
			option["needs_syscontrol"] = EO.needs_syscontrol
			option["silicon_allowed"] = EO.silicon_allowed
			processed_evac_options[++processed_evac_options.len] = option
	.["evac_options"] = processed_evac_options


/datum/ui_module/program/comm/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["emagged"] = program?.computer_emagged || 0
	data["net_comms"] = !!program?.get_signal(NTNET_COMMUNICATION) || 1 //Double !! is needed to get 1 or 0 answer
	data["net_syscont"] = !!program?.get_signal(NTNET_SYSTEMCONTROL) || 1
	data["have_printer"] = !!program?.computer.nano_printer || 0

	data["isAI"] = is_silicon(user)
	data["authenticated"] = is_autenthicated(user)
	data["boss_short"] = GLOB.using_map.boss_short
	data["boss_name"] = GLOB.using_map.boss_name

	data["user"] = list(
		"name" = user ? user.GetIdCard()?.registered_name : "Unknown",
		"job" = user ? user.GetIdCard()?.assignment : null
	)

	data["cooldown_announcement"] = time_remaining(announcment_cooldown)
	data["cooldown_emergency"] = time_remaining(centcomm_message_cooldown)
	data["cooldown_evacuation"] = evacuation_controller.is_on_cooldown()

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	data["current_security_level_ref"] = any2ref(security_state.current_security_level)

	data["cannot_change_security_level"] = !security_state.can_change_security_level()
	data["is_high_security_level"] = security_state.current_security_level == security_state.high_security_level
	var/list/security_levels = list()
	for(var/decl/security_level/security_level in security_state.comm_console_security_levels)
		var/list/security_setup = list()
		security_setup["index"] = security_levels.len
		security_setup["ref"] = any2ref(security_level)
		security_levels[++security_levels.len] = security_setup
	data["security_levels"] = security_levels

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages

	data["evac_is_active"] = evacuation_controller.is_evacuating()
	var/list/processed_evac_options = list()
	if(!isnull(evacuation_controller))
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			var/list/option = list()
			option["option_text"] = EO.option_text
			option["option_target"] = EO.option_target
			option["needs_syscontrol"] = EO.needs_syscontrol
			option["silicon_allowed"] = EO.silicon_allowed
			processed_evac_options[++processed_evac_options.len] = option
	data["evac_options_available"] = processed_evac_options

	return data

/datum/ui_module/program/comm/proc/is_autenthicated(var/mob/user)
	if(program)
		return program.can_run(user)
	return 1

/datum/ui_module/program/comm/proc/obtain_message_listener()
	if(program)
		var/datum/computer_file/program/comm/P = program
		return P.message_core
	return GLOB.global_message_listener

/datum/ui_module/program/comm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	UI_ACT_CHECK
	var/mob/user = usr
	var/ntn_comm = program ? !!program.get_signal(NTNET_COMMUNICATION) : 1
	var/ntn_cont = program ? !!program.get_signal(NTNET_SYSTEMCONTROL) : 1
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(action)
		if("announce")
			. = 1
			if(is_autenthicated(user) && !is_silicon(usr) && ntn_comm)
				if(user)
					var/obj/item/weapon/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcment_cooldown)
					to_chat(usr, "Please allow at least one minute to pass between announcements")
					return TRUE
				var/input = params["message"]
				if(!input)
					return 1
				crew_announcement.Announce(input)
				announcment_cooldown = time_point(ANNOUNCEMENT_COOLDOWN)
				spawn(ANNOUNCEMENT_COOLDOWN)//One minute cooldown
					announcment_cooldown = 0
		if("message")
			. = 1
			switch(params["target"])
				if("regular")
					if(is_autenthicated(user) && !is_silicon(usr) && ntn_comm)
						if(centcomm_message_cooldown)
							to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
							return 1
						if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Traitor funs.
							to_chat(usr, "<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit message.</span>")
							return 1
						var/input = sanitize(params["message"])
						if(!input)
							return 1
						Centcomm_announce(input, usr)
						to_chat(usr, "<span class='notice'>Message transmitted.</span>")
						log_say("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
						centcomm_message_cooldown = time_point(EMERGENCY_COOLDOWN)
						spawn(EMERGENCY_COOLDOWN) //30 second cooldown
							centcomm_message_cooldown = 0
		if("evac")
			. = 1
			if(is_autenthicated(user))
				var/datum/evacuation_option/selected_evac_option = evacuation_controller.evacuation_options[params["target"]]
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && is_silicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setalert")
			. = 1
			if(is_autenthicated(user) && !is_silicon(usr) && ntn_cont && ntn_comm)
				var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
				var/decl/security_level/target_level = locate(params["target"]) in security_state.comm_console_security_levels
				if(target_level && security_state.can_switch_to(target_level))
					if(security_state.set_security_level(target_level))
						feedback_inc(target_level.type,1)
			else
				to_chat(usr, "You press the button, but a red light flashes and nothing happens.") //This should never happen
		if("delmessage")
			. = 1
			if(is_autenthicated(user) && ntn_comm && l != GLOB.global_message_listener)
				var/id = text2num(params["target"])
				var/message = 0
				for(var/list/m in l.messages)
					if(m["id"] == id)
						message = m
				l.Remove(message)
		if("printmessage")
			. = 1
			if(is_autenthicated(user) && ntn_comm)
				if(program && program.computer && program.computer.nano_printer)
					var/id = text2num(params["target"])
					var/message = 0
					for(var/list/m in l.messages)
						if(m["id"] == id)
							message = m
					if(!program.computer.nano_printer.print_text(
						message["contents"],
						message["title"]))
						to_chat(usr, "<span class='notice'>Hardware Error: Printer was unable to print the selected file.</span>")
					else
						program.computer.visible_message("<span class='notice'>\The [program.computer] prints out a paper.</span>")
		if("emergencybeacon")
			. = 1
			if(is_autenthicated(user))
				if(GLOB.using_map.active_beacon)
					GLOB.using_map.active_beacon.try_response_force()
				else
					to_chat(usr, "<span class='warning'>Warning: Unable to connect to emergency beacon.</span>")

#undef ANNOUNCEMENT_COOLDOWN
