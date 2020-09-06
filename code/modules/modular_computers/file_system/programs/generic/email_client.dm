/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 7
	requires_ntnet = 1
	available_on_ntnet = 1
	var/stored_login = ""
	var/stored_password = ""
	usage_flags = PROGRAM_ALL

	ui_module_path = /datum/ui_module/email_client

// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
/datum/computer_file/program/email_client/kill_program()
	if(NM)
		var/datum/ui_module/email_client/NME = NM
		if(NME.current_account)
			stored_login = NME.stored_login
			stored_password = NME.stored_password
			NME.log_out()
		else
			stored_login = ""
			stored_password = ""
	. = ..()

/datum/computer_file/program/email_client/run_program()
	. = ..()

	if(NM)
		var/datum/ui_module/email_client/NME = NM
		NME.stored_login = stored_login
		NME.stored_password = stored_password
		NME.log_in()
		NME.error = ""
		NME.check_for_new_messages(1)

/datum/computer_file/program/email_client/proc/new_mail_notify()
	computer.visible_message("\The [computer] beeps softly, indicating a new email has been received.", 1)
	playsound(computer, 'sound/machines/twobeep.ogg', 50, 1)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/ui_module/email_client/NME = NM
	if(!istype(NME))
		return
	NME.relayed_process(ntnet_speed)

	var/check_count = NME.check_for_new_messages()
	if(check_count)
		if(check_count == 2)
			new_mail_notify()
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"
