
/datum/ui_module/program/card_mod
	name = "ID card modification program"
	ui_interface_name = "programs/NtosCard"
	var/mod_mode = 1
	var/is_centcom = 0
	var/show_assignments = 0

/datum/ui_module/program/card_mod/ui_static_data(mob/user)
	. = host.ui_static_data(user)
	.["jobs"] = list(
		"Command" = format_jobs(GLOB.command_positions),
		"Engineering" = format_jobs(GLOB.engineering_positions),
		"Medical" = format_jobs(GLOB.medical_positions),
		"Security" = format_jobs(GLOB.security_positions),
		"Service" = format_jobs(GLOB.service_positions),
		"Supply" = format_jobs(GLOB.supply_positions),
		"Civilian" = format_jobs(GLOB.civilian_positions),
	)
	if (is_centcom)
		.["jobs"]["Centcom"] = format_jobs(get_all_centcom_jobs())

/datum/ui_module/program/card_mod/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["src"] = REF(src)

	data["have_id_slot"] = 0
	data["have_printer"] = 0
	data["authenticated"] = 0
	if(program && program.computer)
		data["have_id_slot"] = !!program.computer.card_slot
		data["have_printer"] = !!program.computer.nano_printer
		data["authenticated"] = program.can_run(user)
		if(!program.computer.card_slot || !program.computer.card_slot.can_write)
			mod_mode = 0 //We can't modify IDs when there is no card reader
	data["centcom_access"] = is_centcom

	if(program && program.computer && program.computer.card_slot)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		data["has_id"] = !!id_card
		data["id_account_number"] = id_card ? id_card.associated_account_number : null
		data["id_email_login"] = id_card ? id_card.associated_email_login["login"] : null
		data["id_email_password"] = id_card ? stars(id_card.associated_email_login["password"], 0) : null
		data["id_rank"] = id_card && id_card.assignment || "Unassigned"
		data["id_owner"] = id_card && id_card.registered_name || "-----"
		data["id_name"] = id_card ? id_card.name : "-----"

	data["regions"] = get_accesses()

	return data

/datum/ui_module/program/card_mod/proc/format_jobs(list/jobs)
	var/obj/item/weapon/card/id/id_card = program.computer.card_slot ? program.computer.card_slot.stored_card : null
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = job,
			"target_rank" = id_card && id_card.assignment || "Unassigned",
			"job" = job)))

	return formatted

/datum/ui_module/program/card_mod/proc/get_accesses(is_centcom = 0)
	. = list()
	if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		for(var/i = 1; i <= 7; i++)
			var/list/accesses = list()
			for(var/access in get_region_accesses(i))
				if (get_access_desc(access))
					accesses.Add(list(list(
						"name" = get_access_desc(access),
						"ref" = access,
						"allowed" = (access in id_card.access) ? 1 : 0)))

			. += list(list(
				"name" = get_region_accesses_name(i),
				"ref" = i,
				"accesses" = accesses
			))

		if(is_centcom)
			var/list/all_centcom_access = list()
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"name" = get_centcom_access_desc(access),
					"ref" = access,
					"allowed" = (access in id_card.access) ? 1 : 0)))
			. += list(list(
				"name" = "Centcom",
				"ref" = 0,
				"accesses" = all_centcom_access
			))
