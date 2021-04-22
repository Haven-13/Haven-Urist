/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID card modification program"
	ui_module_path = /datum/ui_module/program/card_mod
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for programming crew ID cards."
	required_access = access_change_ids
	requires_ntnet = 0
	size = 8

/datum/computer_file/program/card_mod/ui_act(action, list/params)
	. = ..()
	if(.)
		return TRUE

	var/mob/user = usr
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	var/obj/item/weapon/card/id/id_card
	if (computer.card_slot)
		id_card = computer.card_slot.stored_card

	var/datum/ui_module/program/card_mod/module = NM

	switch(action)
		if("PRG_print")
			if(computer && computer.nano_printer) //This option should never be called if there is no printer
				if(module.mod_mode)
					if(can_run(user, 1))
						var/contents = {"<h4>Access Report</h4>
									<u>Prepared By:</u> [user_id_card.registered_name || "Unknown"]<br>
									<u>For:</u> [id_card.registered_name || "Unregistered"]<br>
									<hr>
									<u>Assignment:</u> [id_card.assignment]<br>
									<u>Account Number:</u> #[id_card.associated_account_number]<br>
									<u>Email account:</u> [id_card.associated_email_login["login"]]
									<u>Email password:</u> [stars(id_card.associated_email_login["password"], 0)]
									<u>Blood Type:</u> [id_card.blood_type]<br><br>
									<u>Access:</u><br>
								"}

						var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
						for(var/A in id_card.access)
							if(A in known_access_rights)
								contents += "  [get_access_desc(A)]"

						if(!computer.nano_printer.print_text(contents,"access report"))
							to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
							return
						else
							computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
				else
					var/contents = {"<h4>Crew Manifest</h4>
									<br>
									[html_crew_manifest()]
									"}
					if(!computer.nano_printer.print_text(contents,text("crew manifest ([])", stationtime2text())))
						to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
						return
					else
						computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
			. = TRUE
		if("PRG_eject")
			if(computer)
				if(computer.card_slot && computer.card_slot.stored_card)
					computer.proc_eject_id(user)
				else
					computer.attackby(user.get_active_hand(), user)
			. = TRUE
		if("PRG_terminate")
			if(computer && can_run(user, 1))
				id_card.assignment = "Terminated"
				remove_nt_access(id_card)
				callHook("terminate_employee", list(id_card))
			. = TRUE
		if("PRG_edit")
			if(computer && can_run(user, 1))
				if(params["name"])
					var/temp_name = sanitizeName(params["name"],allow_numbers=TRUE)
					if(temp_name)
						id_card.registered_name = temp_name
					else
						computer.visible_message("<span class='notice'>[computer] buzzes rudely.</span>")
				else if(params["account"])
					var/account_num = text2num(params["account"])
					id_card.associated_account_number = account_num
				else if(params["login"])
					var/email_login = params["login"]
					id_card.associated_email_login["login"] = email_login
				else if(params["pass"])
					var/email_password = params["pass"]
					id_card.associated_email_login["password"] = email_password
			. = TRUE
		if("PRG_assign")
			if(computer && can_run(user, 1) && id_card)
				var/t1 = params["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(params["name"], 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(module.is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J = new jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							to_chat(usr, "<span class='warning'>No log exists for this job: [t1]</span>")
							return

						access = jobdatum.get_access()

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1
					id_card.rank = t1

				callHook("reassign_employee", list(id_card))
			. = TRUE
		if("PRG_access")
			if(params["allowed"] && computer && can_run(user, 1))
				var/access_type = text2num(params["access_target"])
				var/access_allowed = text2num(params["allowed"])
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					id_card.access -= access_type
					if(!access_allowed)
						id_card.access += access_type
			. = TRUE
	if(id_card)
		id_card.SetName(text("[id_card.registered_name]'s ID Card ([id_card.assignment])"))

/datum/computer_file/program/card_mod/proc/remove_nt_access(var/obj/item/weapon/card/id/id_card)
	id_card.access -= get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)

/datum/computer_file/program/card_mod/proc/apply_access(var/obj/item/weapon/card/id/id_card, var/list/accesses)
	id_card.access |= accesses
