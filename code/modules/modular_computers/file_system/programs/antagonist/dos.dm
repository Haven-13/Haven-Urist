/datum/computer_file/program/ntnet_dos
	filename = "ntn_dos"
	filedesc = "DoS Traffic Generator"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "arrow-4-diag"
	extended_desc = "This advanced script can perform denial of service attacks against NTNet quantum relays. The system administrator will probably notice this. Multiple devices can run this program together against same relay for increased effect."
	size = 20
	requires_ntnet = 1
	available_on_ntnet = 0
	available_on_syndinet = 1
	ui_module_path = /datum/ui_module/program/computer_dos/
	usage_flags = PROGRAM_ALL
	var/obj/machinery/ntnet_relay/target = null
	var/dos_speed = 0
	var/error = ""
	var/executed = 0

/datum/computer_file/program/ntnet_dos/process_tick()
	dos_speed = 0
	switch(ntnet_status)
		if(1)
			dos_speed = NTNETSPEED_LOWSIGNAL * NTNETSPEED_DOS_AMPLIFICATION
		if(2)
			dos_speed = NTNETSPEED_HIGHSIGNAL * NTNETSPEED_DOS_AMPLIFICATION
		if(3)
			dos_speed = NTNETSPEED_ETHERNET * NTNETSPEED_DOS_AMPLIFICATION
	if(target && executed)
		target.dos_overload += dos_speed
		if(!target.operable())
			target.dos_sources.Remove(src)
			target = null
			error = "Connection to destination relay lost."

/datum/computer_file/program/ntnet_dos/kill_program(var/forced)
	if(target)
		target.dos_sources.Remove(src)
		target = null
	executed = 0

	..(forced)

/datum/computer_file/program/ntnet_dos/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["PRG_target_relay"])
		for(var/obj/machinery/ntnet_relay/R in ntnet_global.relays)
			if("[R.uid]" == href_list["PRG_target_relay"])
				target = R
		return 1
	if(href_list["PRG_reset"])
		if(target)
			target.dos_sources.Remove(src)
			target = null
		executed = 0
		error = ""
		return 1
	if(href_list["PRG_execute"])
		if(target)
			executed = 1
			target.dos_sources.Add(src)
			if(ntnet_global.intrusion_detection_enabled)
				ntnet_global.add_log("IDS WARNING - Excess traffic flood targeting relay [target.uid] detected from device: [computer.network_card.get_network_tag()]")
				ntnet_global.intrusion_detection_alarm = 1
		return 1
