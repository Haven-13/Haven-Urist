#define STATE_DEFAULT	1
#define STATE_MESSAGELIST	2
#define STATE_VIEWMESSAGE	3
#define STATE_STATUSDISPLAY	4
#define STATE_ALERT_LEVEL	5

/datum/ui_module/program/comm
	name = "Command and Communications Program"
	ui_interface_name = "programs/CommunicationProgram"
	available_to_ai = TRUE
	var/current_status = STATE_DEFAULT
	var/msg_line1 = ""
	var/msg_line2 = ""
	var/centcomm_message_cooldown = 0
	var/announcment_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new
	var/current_viewing_message_id = 0
	var/current_viewing_message = null

/datum/ui_module/program/comm/New()
	..()
	crew_announcement.newscast = 1

/datum/ui_module/program/comm/ui_data(mob/user)
	var/list/data = host.initial_data()

	if(program)
		data["emagged"] = program.computer_emagged
		data["net_comms"] = !!program.get_signal(NTNET_COMMUNICATION) //Double !! is needed to get 1 or 0 answer
		data["net_syscont"] = !!program.get_signal(NTNET_SYSTEMCONTROL)
		if(program.computer)
			data["have_printer"] = !!program.computer.nano_printer
		else
			data["have_printer"] = 0
	else
		data["emagged"] = 0
		data["net_comms"] = 1
		data["net_syscont"] = 1
		data["have_printer"] = 0

	data["message_line1"] = msg_line1
	data["message_line2"] = msg_line2
	data["state"] = current_status
	data["isAI"] = issilicon(usr)
	data["authenticated"] = is_autenthicated(user)
	data["boss_short"] = GLOB.using_map.boss_short

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	data["current_security_level_ref"] = any2ref(security_state.current_security_level)
	data["current_security_level_title"] = security_state.current_security_level.name

	data["cannot_change_security_level"] = !security_state.can_change_security_level()
	data["current_security_level_is_high_security_level"] = security_state.current_security_level == security_state.high_security_level
	var/list/security_levels = list()
	for(var/decl/security_level/security_level in security_state.comm_console_security_levels)
		var/list/security_setup = list()
		security_setup["title"] = security_level.name
		security_setup["ref"] = any2ref(security_level)
		security_levels[++security_levels.len] = security_setup
	data["security_levels"] = security_levels

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages
	data["message_deletion_allowed"] = l != GLOB.global_message_listener
	data["message_current_id"] = current_viewing_message_id
	if(current_viewing_message)
		data["message_current"] = current_viewing_message

	data["has_central_command"] = GLOB.using_map.has_central_command

	var/list/processed_evac_options = list()
	if(!isnull(evacuation_controller))
		for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
			var/list/option = list()
			option["option_text"] = EO.option_text
			option["option_target"] = EO.option_target
			option["needs_syscontrol"] = EO.needs_syscontrol
			option["silicon_allowed"] = EO.silicon_allowed
			processed_evac_options[++processed_evac_options.len] = option
	data["evac_options"] = processed_evac_options

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

/datum/ui_module/program/comm/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr
	var/ntn_comm = program ? !!program.get_signal(NTNET_COMMUNICATION) : 1
	var/ntn_cont = program ? !!program.get_signal(NTNET_SYSTEMCONTROL) : 1
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(href_list["action"])
		if("sw_menu")
			. = 1
			current_status = text2num(href_list["target"])
		if("announce")
			. = 1
			if(is_autenthicated(user) && !issilicon(usr) && ntn_comm)
				if(user)
					var/obj/item/weapon/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcment_cooldown)
					to_chat(usr, "Please allow at least one minute to pass between announcements")
					return TRUE
				var/input = input(usr, "Please write a message to announce to the [station_name()].", "Priority Announcement") as null|text
				if(!input || !can_still_topic())
					return 1
				crew_announcement.Announce(input)
				announcment_cooldown = 1
				spawn(600)//One minute cooldown
					announcment_cooldown = 0
		if("message")
			. = 1
			if(href_list["target"] == "emagged")
				if(program)
					if(is_autenthicated(user) && program.computer_emagged && !issilicon(usr) && ntn_comm)
						if(centcomm_message_cooldown)
							to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
							SStgui.update_uis(src)
							return
						var/input = sanitize(input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
						if(!input || !can_still_topic())
							return 1
						Syndicate_announce(input, usr)
						to_chat(usr, "<span class='notice'>Message transmitted.</span>")
						log_say("[key_name(usr)] has made an illegal announcement: [input]")
						centcomm_message_cooldown = 1
						spawn(300)//30 second cooldown
							centcomm_message_cooldown = 0
			else if(href_list["target"] == "regular")
				if(is_autenthicated(user) && !issilicon(usr) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
						SStgui.update_uis(src)
						return
					if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Traitor funs.
						to_chat(usr, "<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit message.</span>")
						return 1
					var/input = sanitize(input("Please choose a message to transmit to [GLOB.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
					if(!input || !can_still_topic())
						return 1
					Centcomm_announce(input, usr)
					to_chat(usr, "<span class='notice'>Message transmitted.</span>")
					log_say("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
					centcomm_message_cooldown = 1
					spawn(300) //30 second cooldown
						centcomm_message_cooldown = 0
		if("evac")
			. = 1
			if(is_autenthicated(user))
				var/datum/evacuation_option/selected_evac_option = evacuation_controller.evacuation_options[href_list["target"]]
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && issilicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				var/confirm = alert("Are you sure you want to [selected_evac_option.option_desc]?", name, "No", "Yes")
				if (confirm == "Yes" && can_still_topic())
					evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			. = 1
			if(is_autenthicated(user) && ntn_cont)
				switch(href_list["target"])
					if("line1")
						var/linput = reject_bad_text(sanitize(input("Line 1", "Enter Message Text", msg_line1) as text|null, 40), 40)
						if(can_still_topic())
							msg_line1 = linput
					if("line2")
						var/linput = reject_bad_text(sanitize(input("Line 2", "Enter Message Text", msg_line2) as text|null, 40), 40)
						if(can_still_topic())
							msg_line2 = linput
					if("message")
						post_status("message", msg_line1, msg_line2)
					if("image")
						post_status("image", href_list["image"])
					else
						post_status(href_list["target"])
		if("setalert")
			. = 1
			if(is_autenthicated(user) && !issilicon(usr) && ntn_cont && ntn_comm)
				var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
				var/decl/security_level/target_level = locate(href_list["target"]) in security_state.comm_console_security_levels
				if(target_level && security_state.can_switch_to(target_level))
					var/confirm = alert("Are you sure you want to change the alert level to [target_level.name]?", name, "No", "Yes")
					if(confirm == "Yes" && can_still_topic())
						if(security_state.set_security_level(target_level))
							feedback_inc(target_level.type,1)
			else
				to_chat(usr, "You press the button, but a red light flashes and nothing happens.") //This should never happen

			current_status = STATE_DEFAULT
		if("viewmessage")
			. = 1
			if(is_autenthicated(user) && ntn_comm)
				current_viewing_message_id = text2num(href_list["target"])
				for(var/list/m in l.messages)
					if(m["id"] == current_viewing_message_id)
						current_viewing_message = m
				current_status = STATE_VIEWMESSAGE
		if("delmessage")
			. = 1
			if(is_autenthicated(user) && ntn_comm && l != GLOB.global_message_listener)
				l.Remove(current_viewing_message)
			current_status = STATE_MESSAGELIST
		if("printmessage")
			. = 1
			if(is_autenthicated(user) && ntn_comm)
				if(program && program.computer && program.computer.nano_printer)
					if(!program.computer.nano_printer.print_text(current_viewing_message["contents"],current_viewing_message["title"]))
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

#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL
