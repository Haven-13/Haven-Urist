/datum/ui_module/forceauthorization/
	name = "Use of Force Authorization Manager"

/datum/ui_module/forceauthorization/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ForceAuthorizationProgram")
		ui.open()

/datum/ui_module/forceauthorization/ui_data(mob/user)
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
			if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
				continue
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

		data["guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z)))
	var/list/guns = data["guns"]
	if(!guns.len)
		data["message"] = "No weapons registered"

	if(!data["is_silicon_usr"]) // don't send data even though they won't be able to see it
		data["cyborg_guns"] = list()
		for(var/obj/item/weapon/gun/energy/gun/secure/mounted/G in GLOB.registered_cyborg_weapons)
			var/list/modes = list() // we don't get location, unlike inside of the last loop, because borg locations are reported elsewhere.
			for(var/i = 1 to G.firemodes.len)
				if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
					continue
				var/datum/firemode/firemode = G.firemodes[i]
				modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

			data["cyborg_guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes))

	return data

/datum/ui_module/forceauthorization/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/weapon/gun/G = locate(href_list["gun"]) in GLOB.registered_weapons
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && G && G.authorize(mode, do_authorize, usr.name)

	if(href_list["cyborg_gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/weapon/gun/energy/gun/secure/mounted/M = locate(href_list["cyborg_gun"]) in GLOB.registered_cyborg_weapons
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && M && M.authorize(mode, do_authorize, usr.name)

	return 0
