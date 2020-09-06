
/datum/ui_module/program/access_decrypter
	name = "NTNet Access Decrypter"
	var/list/restricted_access_codes = list(access_change_ids, access_network) // access codes that are not hackable due to balance reasons

/datum/ui_module/program/access_decrypter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AccessDecrypterProgram")
		ui.open()

/datum/ui_module/program/access_decrypter/ui_data(mob/user)
	if(!ntnet_global)
		return
	var/datum/computer_file/program/access_decrypter/PRG = program
	var/list/data = list()
	if(!istype(PRG))
		return
	data = PRG.get_header_data()

	if(PRG.message)
		data["message"] = PRG.message
	else if(PRG.running)
		data["running"] = 1
		data["rate"] = PRG.computer.processor_unit.max_idle_programs

		// Stolen from DOS traffic generator, generates strings of 1s and 0s
		var/percentage = (PRG.progress / PRG.target_progress) * 100
		var/list/strings[0]
		for(var/j, j<10, j++)
			var/string = ""
			for(var/i, i<20, i++)
				string = "[string][prob(percentage)]"
			strings.Add(string)
		data["dos_strings"] = strings
	else if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		var/list/regions = list()
		for(var/i = 1; i <= 7; i++)
			var/list/accesses = list()
			for(var/access in get_region_accesses(i))
				if (get_access_desc(access))
					accesses.Add(list(list(
						"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
						"ref" = access,
						"allowed" = (access in id_card.access) ? 1 : 0,
						"blocked" = (access in restricted_access_codes) ? 1 : 0)))

			regions.Add(list(list(
				"name" = get_region_accesses_name(i),
				"accesses" = accesses)))
		data["regions"] = regions

	return data
