/datum/ui_module/program/records
	name = "Crew Records"
	ui_interface_name = "programs/CrewRecordsProgram"

	var/datum/computer_file/report/crew_record/active_record
	var/message = null

/datum/ui_module/program/records/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)

	data["message"] = message
	data["active"] = null
	if(active_record)
		send_rsc(user, active_record.photo_front, "front_[active_record.uid].png")
		send_rsc(user, active_record.photo_side, "side_[active_record.uid].png")
		data["pic_edit"] = check_access(user, access_bridge) || check_access(user, access_security)
		data["active"] = active_record.generate_ui_json_data(user_access)
	else
		var/list/all_records = list()

		for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
			all_records.Add(list(list(
				"name" = R.get_name(),
				"job" = R.get_job(),
				"dna" = R.get_dna(),
				"fingerprint" = R.get_fingerprint(),
				"id" = R.uid
			)))
		data["all_records"] = all_records
		data["creation"] = check_access(user, access_bridge)
		data["dnasearch"] = check_access(user, access_medical) || check_access(user, access_forensics_lockers)
		data["fingersearch"] = check_access(user, access_security)

	return data

/datum/ui_module/program/records/proc/get_record_access(var/mob/user)
	var/list/user_access = using_access || user.GetAccess()

	var/obj/item/modular_computer/PC = ui_host()
	if(istype(PC) && PC.computer_emagged)
		user_access = user_access.Copy()
		user_access |= access_syndicate

	return user_access

/datum/ui_module/program/records/proc/edit_field(var/mob/user, var/field_ID, var/field_value)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!F.verify_access_edit(get_record_access(user)))
		to_chat(user, "<span class='notice'>\The [ui_host()] flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

/datum/ui_module/program/records/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/weapon/photo))
		var/obj/item/weapon/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/weapon/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img

/datum/ui_module/program/records/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("open_record")
			var/id = text2num(params["record"])
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				if(R.uid == id)
					active_record = R
					break
			return TRUE
		if("close_record")
			active_record = null

			return TRUE
		if("create_record")
			if(!check_access(usr, access_bridge))
				to_chat(usr, "Access Denied.")
				return FALSE

			active_record = new/datum/computer_file/report/crew_record()
			GLOB.all_crew_records.Add(active_record)
			return TRUE
		if("print_record")
			var/id = text2num(params["record"])
			var/record = null
			for(var/datum/computer_file/report/crew_record/R in GLOB.all_crew_records)
				if(R.uid == id)
					record = R
					break
			print_text(record_to_html(record, get_record_access(usr)), usr)
			return TRUE
		if("update_record_photo")
			var/target = params["target"]
			var/photo = get_photo(usr)
			if(photo && active_record)
				switch(target)
					if("front")
						active_record.photo_front = photo
					if("side")
						active_record.photo_side = photo
				return TRUE
		if("update_record_field")
			edit_field(usr, text2num(params["field"]), params["value"])
			return TRUE

