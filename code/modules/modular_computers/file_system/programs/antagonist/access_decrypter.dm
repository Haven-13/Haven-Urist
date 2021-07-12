/datum/computer_file/program/access_decrypter
	filename = "nt_accrypt"
	filedesc = "NTNet Access Decrypter"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "unlocked"
	extended_desc = "This highly advanced script can very slowly decrypt operational codes used in almost any network. These codes can be downloaded to an ID card to expand the available access. The system administrator will probably notice this."
	size = 34
	requires_ntnet = 1
	available_on_ntnet = 0
	available_on_syndinet = 1
	ui_module_path = /datum/ui_module/program/access_decrypter/
	var/message = ""
	var/running = FALSE
	var/progress = 0
	var/target_progress = 300
	var/datum/access/target_access = null

/datum/computer_file/program/access_decrypter/kill_program(var/forced)
	reset()
	..(forced)

/datum/computer_file/program/access_decrypter/proc/reset()
	running = FALSE
	message = ""
	progress = 0

/datum/computer_file/program/access_decrypter/process_tick()
	. = ..()
	if(!running)
		return
	var/obj/item/weapon/computer_hardware/processor_unit/CPU = computer.processor_unit
	var/obj/item/weapon/computer_hardware/card_slot/RFID = computer.card_slot
	if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
		message = "A fatal hardware error has been detected."
		return
	if(!istype(RFID.stored_card))
		message = "RFID card has been removed from the device. Operation aborted."
		return

	progress += CPU.max_idle_programs
	if(progress >= target_progress)
		reset()
		RFID.stored_card.access |= target_access.id
		if(ntnet_global.intrusion_detection_enabled)
			ntnet_global.add_log("IDS WARNING - Unauthorised access to primary keycode database from device: [computer.network_card.get_network_tag()]  - downloaded access codes for: [target_access.desc].")
			ntnet_global.intrusion_detection_alarm = 1
		message = "Successfully decrypted and saved operational key codes. Downloaded access codes for: [target_access.desc]"
		target_access = null

/datum/computer_file/program/access_decrypter/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["PRG_reset"])
		reset()
		return 1
	if(href_list["PRG_execute"])
		if(running)
			return 1
		if(text2num(href_list["allowed"]))
			return 1
		var/obj/item/weapon/computer_hardware/processor_unit/CPU = computer.processor_unit
		var/obj/item/weapon/computer_hardware/card_slot/RFID = computer.card_slot
		if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
			message = "A fatal hardware error has been detected."
			return
		if(!istype(RFID.stored_card))
			message = "RFID card is not present in the device. Operation aborted."
			return
		running = TRUE
		target_access = get_access_by_id(text2num(href_list["PRG_execute"]))
		if(ntnet_global.intrusion_detection_enabled)
			ntnet_global.add_log("IDS WARNING - Unauthorised access attempt to primary keycode database from device: [computer.network_card.get_network_tag()]")
			ntnet_global.intrusion_detection_alarm = 1
		return 1
