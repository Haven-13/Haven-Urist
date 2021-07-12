/datum/computer_file/program/contract_database
	filename = "contractdatabase"
	filedesc = "Contract Database"
	extended_desc = "This program allows access to the database of contracts currently accepted by the ICS Nerva."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 3
	requires_ntnet = 0
	available_on_ntnet = 0
	ui_module_path = /datum/ui_module/contract_database
//	usage_flags = PROGRAM_ALL

/datum/ui_module/contract_database
	name = "Contract Database"
//	var/selected_category
//	var/list/category_names
//	var/list/category_contents

/datum/ui_module/contract_database/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ContractDatabase")
		ui.open()

/datum/ui_module/contract_database/ui_data(mob/user)
	var/list/data = host.initial_data()

//	category_contents = list()
	var/list/category[0]
	for(var/datum/contract/C in GLOB.using_map.contracts)
//		if(C.is_category())
//		category_names.Add(C.faction)
//			category_names.Add(C.name)
		category.Add(list(list(
			"name" = C.name,
			"desc" = C.desc,
			"issuer" = C.faction,
			"money" = C.money,
			"amount" = C.amount,
			"progress" = C.completed
		)))
		data["existing_contracts"] = category
//		category_contents = category

	data["credits"] = "[SSsupply.points]"
	data["currency"] = GLOB.using_map.supply_currency_name
//	data["categories"] = category_names
//	if(selected_category)
//	data["category"] = selected_category
//	data["existing_contracts"] = category_contents

	return data

/*
/datum/ui_module/contract_database/Topic(href, href_list)
//	var/mob/user = usr
	if(..())
		return 1

	if(href_list["select_category"])
		selected_category = href_list["select_category"]
		return 1

	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)
*/
/*
/datum/ui_module/contract_database/proc/can_print()
	var/obj/item/modular_computer/MC = ui_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/ui_module/contract_database/proc/print_summary(var/mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Contract overview<field></i></center><hr>"
	print_text(t, user)
*/