/datum/ui_module/program/forceauthorization/
	name = "Use of Force Authorization Manager"
	ui_interface_name = "programs/ForceAuthorization"

/datum/ui_module/program/forceauthorization/ui_data(mob/user)
	var/list/data = host.initial_data()
	data["is_silicon_usr"] = issilicon(user)

	data["guns"] = list()
	var/atom/movable/AM = ui_host()
	if(!istype(AM))
		return
	var/list/zlevels = GetConnectedZlevels(AM.z)
	for(var/obj/item/weapon/gun/G in GLOB.registered_weapons)
		if(G.standby)
			continue
		var/turf/T = get_turf(G)
		if(!T || !(T.z in zlevels))
			continue

		var/list/modes = list()
		for(var/i = 1 to G.firemodes.len)
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list(
				"index" = i,
				"mode_name" = firemode.name,
				"always_authorized" = G.authorized_modes[i] == ALWAYS_AUTHORIZED,
				"authorized" = G.authorized_modes[i]
			))

		data["guns"] += list(list("name" = G.name, "ref" = REF(G), "owner" = G.registered_owner, "modes" = modes, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z)))
	var/list/guns = data["guns"]
	if(!guns.len)
		data["message"] = "No weapons registered"

	data["cyborg_guns"] = list()
	for(var/obj/item/weapon/gun/energy/gun/secure/mounted/G in GLOB.registered_cyborg_weapons)
		var/list/modes = list() // we don't get location, unlike inside of the last loop, because borg locations are reported elsewhere.
		for(var/i = 1 to G.firemodes.len)
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list(
				"index" = i,
				"mode_name" = firemode.name,
				"always_authorized" = G.authorized_modes[i] == ALWAYS_AUTHORIZED,
				"authorized" = G.authorized_modes[i]
			))

		data["cyborg_guns"] += list(list("name" = G.name, "ref" = REF(G), "owner" = G.registered_owner, "modes" = modes))

	return data

/datum/ui_module/program/forceauthorization/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("authorize")
			var/target = params["target"]
			var/obj/item/weapon/gun/G = null
			switch(target)
				if("gun")
					G = locate(params["ref"]) in GLOB.registered_weapons
				if("cyborg_gun")
					if (issilicon(usr))
						return FALSE
					G = locate(params["ref"]) in GLOB.registered_cyborg_weapons
			var/authorize = !!!text2num(params["value"])
			var/mode = text2num(params["mode"])
			if(G && isnum(authorize) && isnum(mode))
				G.authorize(mode, authorize, usr)
			. = TRUE
