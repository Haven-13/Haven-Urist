/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	ui_module_path = /datum/ui_module/program/camera_monitor/hacked
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "zoomin"
	extended_desc = "This very advanced piece of software uses adaptive programming and large database of cipherkeys to bypass most encryptions used on camera networks. Be warned that system administrator may notice this."
	size = 73 // Very large, a price for bypassing ID checks completely.
	available_on_ntnet = 0
	available_on_syndinet = 1

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	var/datum/ui_module/program/camera_monitor/hacked/HNM = NM

	if(HNM && prob(0.1))
		for(var/network in HNM.selected_networks)
			// The program is active and connected to one of the station's networks. Has a very small chance to trigger IDS alarm every tick.
			if(network && (network in GLOB.using_map.station_networks) && prob(50))
				if(ntnet_global.intrusion_detection_enabled)
					ntnet_global.add_log("IDS WARNING - Unauthorised access detected to camera network [network] by device with NID [computer.network_card.get_network_tag()]")
					ntnet_global.intrusion_detection_alarm = 1
