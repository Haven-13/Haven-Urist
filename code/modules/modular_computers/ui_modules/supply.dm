
/datum/ui_module/program/supply
	name = "Supply Management program"
	ui_interface_name = "programs/SupplyProgram"

	var/selected_category
	var/list/category_names
	var/list/category_contents
	var/emagged = FALSE	// TODO: Implement synchronisation with modular computer framework.
	var/current_security_level

/datum/ui_module/program/supply/ui_static_data(mob/user)
	if(!category_names || !category_contents)
		generate_categories()

	. = list()
	.["categories"] = category_names
	.["items"] = category_contents

/datum/ui_module/program/supply/ui_data(mob/user)
	var/list/data = host.initial_data()
	var/is_admin = check_access(user, access_cargo)
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(current_security_level != security_state.current_security_level)
		current_security_level = security_state.current_security_level

	data["current_security_level"] = (security_state.index_of(current_security_level) - 1)
	data["current_security_level_name"] = current_security_level
	data["is_admin"] = is_admin
	data["credits"] = SSsupply.points
	data["currency"] = GLOB.using_map.supply_currency_name
	data["currency_short"] = GLOB.using_map.supply_currency_name_short

	var/list/point_breakdown = list()
	for(var/tag in SSsupply.point_source_descriptions)
		var/entry = list()
		entry["desc"] = SSsupply.point_source_descriptions[tag]
		entry["points"] = SSsupply.point_sources[tag] || 0
		point_breakdown += list(entry) //Make a list of lists, don't flatten
	data["point_breakdown"] = point_breakdown
	data["can_print"] = can_print()

	data["shuttle"] = get_shuttle_status()

	var/list/cart[0]
	var/list/requests[0]
	var/list/done[0]
	for(var/datum/supply_order/SO in SSsupply.shoppinglist)
		cart.Add(order_to_ui_json(SO))
	for(var/datum/supply_order/SO in SSsupply.requestlist)
		requests.Add(order_to_ui_json(SO))
	for(var/datum/supply_order/SO in SSsupply.donelist)
		done.Add(order_to_ui_json(SO))
	data["cart"] = cart
	data["requests"] = requests
	data["done"] = done

	return data

/datum/ui_module/program/supply/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	UI_ACT_CHECK

	var/mob/living/user = usr
	switch(action)
		if("order")
			var/decl/hierarchy/supply_pack/P = locate(params["item"]) in SSsupply.master_supply_list
			if(!istype(P) || P.is_category())
				return TRUE

			if((P.hidden || P.contraband) && !emagged)
				return TRUE

			if(!P.sec_available())
				return TRUE

			var/idname = "*None Provided*"
			var/idjob = "*None Provided*"
			if(is_human_mob(user))
				var/mob/living/carbon/human/H = user
				idname = H.get_authentification_name()
				idjob = H.get_assignment()
			else if(is_silicon(user))
				idname = user.real_name

			SSsupply.ordernum++

			var/datum/supply_order/O = new /datum/supply_order()
			O.ordernum = SSsupply.ordernum
			O.object = P
			O.orderedby = idname
			O.orderedjob = idjob
			O.comment = "#[O.ordernum]"
			SSsupply.requestlist += O

			if(can_print() && params["receipt"])
				print_order(O, user)
			return TRUE

		if("print_summary")
			if(!can_print())
				return FALSE
			print_summary(user)

	// Items requiring cargo access go below this entry. Other items go above.
	if(check_access(access_cargo))
		switch(action)
			if("launch_shuttle")
				var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
				if(!shuttle)
					to_chat(user, "<span class='warning'>Error connecting to the shuttle.</span>")
					return
				if(shuttle.at_station())
					if (shuttle.forbidden_atoms_check())
						to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
					else
						shuttle.launch(user)
				else
					shuttle.launch(user)
					var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
					if(!frequency)
						return

					var/datum/signal/status_signal = new
					status_signal.source = src
					status_signal.transmission_method = 1
					status_signal.data["command"] = "supply"
					frequency.post_signal(src, status_signal)
				return 1

			if("approve_order")
				var/id = text2num(params["order"])
				for(var/datum/supply_order/SO in SSsupply.requestlist)
					if(SO.ordernum != id)
						continue
					if(SO.object.cost > SSsupply.points)
						to_chat(usr, "<span class='warning'>Not enough points to purchase \the [SO.object.name]!</span>")
						return 1
					SSsupply.requestlist -= SO
					SSsupply.shoppinglist += SO
					SSsupply.points -= SO.object.cost

					if(GLOB.using_map.using_new_cargo)
						station_account.money -= SO.object.cost

					break
				return 1

			if("deny_order")
				var/id = text2num(params["order"])
				for(var/datum/supply_order/SO in SSsupply.requestlist)
					if(SO.ordernum == id)
						SSsupply.requestlist -= SO
						break
				return 1

			if("cancel_order")
				var/id = text2num(params["order"])
				for(var/datum/supply_order/SO in SSsupply.shoppinglist)
					if(SO.ordernum == id)
						SSsupply.shoppinglist -= SO
						SSsupply.points += SO.object.cost
						break
				return 1

			if("delete_order")
				var/id = text2num(params["order"])
				for(var/datum/supply_order/SO in SSsupply.donelist)
					if(SO.ordernum == id)
						SSsupply.donelist -= SO
						break
				return 1

/datum/ui_module/program/supply/proc/generate_categories()
	category_names = list()
	category_contents = list()
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			category_names.Add(sp.name)
			var/list/category[0]
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				category.Add(list(list(
					"name" = spc.name,
					"cost" = spc.cost,
					"hidden" = spc.hidden,
					"illegal" = spc.contraband,
					"security_level" = spc.security_level || 0,
					"ref" = REF(spc)
				)))
			category_contents[sp.name] = category

/datum/ui_module/program/supply/proc/get_shuttle_status()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	. = list(
		"name" = shuttle?.name,
		"status" = \
			istype(shuttle) && (\
				(shuttle.has_arrive_time() && "In transit") || \
				(shuttle.can_launch() && "Docked") \
			) || "No connection",
		"time_left" = \
			(istype(shuttle) && (shuttle.has_arrive_time() && shuttle.time_left())) || null,
		"location" = \
			istype(shuttle) && ( \
				shuttle.at_station() && GLOB.using_map.name || "Remote location" \
			) || "No connection",
		"can_control" = shuttle?.can_launch()
	)

/datum/ui_module/program/supply/proc/order_to_ui_json(datum/supply_order/SO)
	return list(list(
		"id" = SO.ordernum,
		"object" = SO.object.name,
		"orderer" = SO.orderedby,
		"orderer_job" = SO.orderedjob,
		"cost" = SO.object.cost,
	))

/datum/ui_module/program/supply/proc/can_print()
	var/obj/item/modular_computer/MC = ui_host()
	if(!istype(MC) || !istype(MC.nano_printer))
		return 0
	return 1

/datum/ui_module/program/supply/proc/print_order(datum/supply_order/O, mob/user)
	if(!O)
		return

	var/t = ""
	t += "<h3>[GLOB.using_map.station_name] Supply Requisition Reciept</h3><hr>"
	t += "INDEX: #[O.ordernum]<br>"
	t += "REQUESTED BY: [O.orderedby]<br>"
	t += "ASSIGNMENT: [O.orderedjob]<br>"
	t += "SUPPLY CRATE TYPE: [O.object.name]<br>"
	t += "ACCESS RESTRICTION: [get_access_desc(O.object.access)]<br>"
	t += "CONTENTS:<br>"
	t += O.object.manifest
	t += "<hr>"
	print_text(t, user)

/datum/ui_module/program/supply/proc/print_summary(mob/user)
	var/t = ""
	t += "<center><BR><b><large>[GLOB.using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Export overview<field></i></center><hr>"
	for(var/source in SSsupply.point_source_descriptions)
		t += "[SSsupply.point_source_descriptions[source]]: [SSsupply.point_sources[source] || 0]<br>"
	print_text(t, user)
