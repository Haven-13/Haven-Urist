//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/weapon/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -Agouri

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 50)

	req_access = list(access_engine)

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1
	var/lockable = 1


/obj/item/weapon/airlock_electronics/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	ui_interact(user)

/obj/item/weapon/airlock_electronics/attackby(obj/item/weapon/W, mob/user)
	. = ..()
	if(.)
		return .

	var/obj/item/weapon/card/id/I = W
	I = I ? I.GetIdCard() : null
	if(!istype(I, /obj/item/weapon/card/id))
		to_chat(usr, "<span class='warning'>[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?</span>")
	if (check_access(I))
		if (locked)
			last_configurator = I.registered_name
		locked = !locked
		SStgui.try_update_ui(user, src, null)
	else
		to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")

//tgui interact code generously lifted from tgstation.
/obj/item/weapon/airlock_electronics/ui_state(mob/user)
	return ui_hands_state()

/obj/item/weapon/airlock_electronics/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockElectronics", name)
		ui.open()

/obj/item/weapon/airlock_electronics/ui_data(mob/user)
	var/list/data = list()
	var/list/regions = list()

	for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY) //code/game/jobs/_access_defs.dm
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["name"] = get_access_desc(j)
			access["id"] = j
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["id"] = i
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["accesses"] = conf_access
	data["regions"] = regions
	data["oneAccess"] = one_access

	var/list/lock_access = list()
	for(var/i in req_access)
		lock_access[++lock_access.len] = get_access_desc(i)
	data["lockRequiredAccesses"] = lock_access
	data["locked"] = locked
	data["lockable"] = lockable

	return data

/obj/item/weapon/airlock_electronics/ui_act(action, params)
	switch(action)
		if("clear")
			if(!locked)
				conf_access = list()
				one_access = 0
				. = TRUE
		if("one_access")
			if(!locked)
				one_access = !one_access
				. = TRUE
		if("set")
			if(!locked)
				var/access = text2num(params["access"])
				if (!(access in conf_access))
					conf_access += access
				else
					conf_access -= access
				. = TRUE
		if("grant_region")
			if(!locked)
				var/region = text2num(params["region"])
				for(var/access in get_region_accesses(region))
					conf_access |= access
				. = TRUE
		if("deny_region")
			if(!locked)
				var/region = text2num(params["region"])
				for(var/access in get_region_accesses(region))
					conf_access -= access
				. = TRUE
		if("grant_all")
			if(!locked)
				for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY)
					for(var/j in get_region_accesses(i))
						conf_access |= j
				. = TRUE
		if("deny_all")
			if(!locked)
				conf_access.Cut()
				. = TRUE


/obj/item/weapon/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1

/obj/item/weapon/airlock_electronics/brace
	name = "airlock brace access circuit"
	req_access = list()
	locked = 0
	lockable = 0

/obj/item/weapon/airlock_electronics/brace/ui_state(mob/user)
	return ui_deep_inventory_state()

/obj/item/weapon/airlock_electronics/brace/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockElectronics")
		ui.open()
