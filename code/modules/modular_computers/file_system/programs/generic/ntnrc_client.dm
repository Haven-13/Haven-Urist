/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "NTNet Relay Chat Client"
	program_icon_state = "command"
	program_key_state = "med_key"
	program_menu_icon = "comment"
	extended_desc = "This program allows communication over NTNRC network"
	size = 8
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = 1
	ui_module_path = /datum/ui_module/program/computer_chatclient/
	var/last_message = null				// Used to generate the toolbar icon
	var/username
	var/datum/ntnet_conversation/channel = null
	var/operator_mode = 0		// Channel operator mode
	var/netadmin_mode = 0		// Administrator mode (invisible to other users + bypasses passwords)
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/chatclient/New()
	username = "DefaultUser[rand(100, 999)]"

/datum/computer_file/program/chatclient/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("PRG_speak")
			. = TRUE
			if(channel)
				var/message = sanitize(params["message"], 512)
				if(message)
					channel.add_message(message, username)
		if("PRG_joinchannel")
			. = TRUE
			var/datum/ntnet_conversation/C
			for(var/datum/ntnet_conversation/chan in ntnet_global.chat_channels)
				if(chan.id == text2num(params["choice"]))
					C = chan
					break

			if(!C)
				return 1

			if(netadmin_mode)
				channel = C		// Bypasses normal leave/join and passwords. Technically makes the user invisible to others.
				return 1

			if(C.password)
				var/password = sanitize(params["password"])
				if(C && (password == C.password))
					C.add_client(src)
					channel = C
				return 1
			C.add_client(src)
			channel = C
		if("PRG_leavechannel")
			. = 1
			if(channel)
				channel.remove_client(src)
			channel = null
		if("PRG_newchannel")
			. = 1
			var/channel_title = sanitizeSafe(params["name"], 64)
			if(!channel_title)
				return
			var/datum/ntnet_conversation/C = new/datum/ntnet_conversation()
			C.add_client(src)
			C.operator = src
			channel = C
			C.title = channel_title
		if("PRG_toggleadmin")
			. = 1
			if(netadmin_mode)
				netadmin_mode = 0
				if(channel)
					channel.remove_client(src) // We shouldn't be in channel's user list, but just in case...
					channel = null
				return 1
			if(can_run(usr, 1, access_network))
				if(channel)
					channel.remove_client(src)
					channel = null
					netadmin_mode = 1
		if("PRG_changename")
			. = 1
			var/newname = sanitize(params["new_name"], 20)
			if(!newname)
				return 1
			if(channel)
				channel.add_status_message("[username] is now known as [newname].")
			username = newname

		if("PRG_savelog")
			. = 1
			if(!channel)
				return
			var/logname = sanitize(params["filename"], 56)
			if(!logname || !channel)
				return 1
			var/datum/computer_file/data/logfile = new/datum/computer_file/data/logfile()
			// Now we will generate HTML-compliant file that can actually be viewed/printed.
			logfile.filename = logname
			logfile.stored_data = "\[b\]Logfile dump from NTNRC channel [channel.title]\[/b\]\[BR\]"
			for(var/logstring in channel.messages)
				logfile.stored_data += "[logstring]\[BR\]"
			logfile.stored_data += "\[b\]Logfile dump completed.\[/b\]"
			logfile.calculate_size()
			if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(logfile))
				if(!computer)
					// This program shouldn't even be runnable without computer.
					crash_with("Var computer is null!")
					return 1
				if(!computer.hard_drive)
					computer.visible_message("\The [computer] shows an \"I/O Error - Hard drive connection error\" warning.")
				else	// In 99.9% cases this will mean our HDD is full
					computer.visible_message("\The [computer] shows an \"I/O Error - Hard drive may be full. Please free some space and try again. Required space: [logfile.size]GQ\" warning.")
		if("PRG_renamechannel")
			. = 1
			if(!operator_mode || !channel)
				return 1
			var/newname = sanitize(params["new_name"], 64)
			if(!newname || !channel)
				return
			channel.add_status_message("Channel renamed from [channel.title] to [newname] by operator.")
			channel.title = newname
		if("PRG_deletechannel")
			. = 1
			if(channel && ((channel.operator == src) || netadmin_mode))
				qdel(channel)
				channel = null
		if("PRG_setpassword")
			. = 1
			if(!channel || ((channel.operator != src) && !netadmin_mode))
				return 1
			var/newpassword = sanitize(params["password"])
			if(!channel || !newpassword || ((channel.operator != src) && !netadmin_mode))
				return 1

			channel.password = newpassword

/datum/computer_file/program/chatclient/process_tick()
	..()
	if(program_state != PROGRAM_STATE_KILLED)
		ui_header = "ntnrc_idle.gif"
		if(channel)
			// Remember the last message. If there is no message in the channel remember null.
			last_message = channel.messages.len ? channel.messages[channel.messages.len - 1] : null
		else
			last_message = null
		return 1
	if(channel && channel.messages && channel.messages.len)
		ui_header = last_message == channel.messages[channel.messages.len - 1] ? "ntnrc_idle.gif" : "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/computer_file/program/chatclient/kill_program(var/forced = 0)
	if(channel)
		channel.remove_client(src)
		channel = null
	..(forced)
