LEGACY_RECORD_STRUCTURE(all_waypoints, waypoint)

/obj/machinery/computer/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	circuit = /obj/item/weapon/circuitboard/helm
	var/obj/effect/overmap/ship/linked			//connected overmap object
	var/autopilot = 0
	var/viewing = 0
	var/list/viewers
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 2 //top speed for autopilot

/obj/machinery/computer/helm/Initialize()
	. = ..()
	linked = map_sectors["[z]"]
	get_known_sectors()

/obj/machinery/computer/helm/Destroy()
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	QDEL_NULL_LIST(known_sectors)
	. = ..()

/obj/machinery/computer/helm/proc/get_overmap_area()
	var/turf/T = locate(1,1,GLOB.using_map.overmap_z)
	if (T) // Baycode overmap may be the simplest, but it is also the shittest
		return T.loc

/obj/machinery/computer/helm/proc/get_known_sectors()
	var/area/overmap/map = get_overmap_area()
	if (!map)
		return
	for(var/obj/effect/overmap/sector/S in map.contents)
		if (S.known)
			var/datum/computer_file/data/waypoint/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R

/obj/machinery/computer/helm/Process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,GLOB.using_map.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()

		var/brake_path = linked.get_brake_path()

		if((!speedlimit || linked.get_speed() < speedlimit) && get_dist(linked.loc, T) > brake_path)
			linked.accelerate(get_dir(linked.loc, T))
		else
			linked.decelerate()

		return

/obj/machinery/computer/helm/relaymove(var/mob/user, direction)
	if(viewing && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		return -1
	return 0

/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		unlook(user)
		viewing = 0
		return

	if(!isAI(user))
		user.set_machine(src)
		if(linked && viewing)
			look(user)

	ui_interact(user)

/obj/machinery/computer/helm/proc/look(var/mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + 4
	GLOB.moved_event.register(user, src, /obj/machinery/computer/helm/proc/unlook)
	GLOB.stat_set_event.register(user, src, /obj/machinery/computer/helm/proc/unlook)
	LAZYDISTINCTADD(viewers, weakref(user))

/obj/machinery/computer/helm/proc/unlook(var/mob/user)
	user.reset_view()
	if(user.client)
		user.client.view = world.view
	GLOB.moved_event.unregister(user, src, /obj/machinery/computer/helm/proc/unlook)
	GLOB.stat_set_event.unregister(user, src, /obj/machinery/computer/helm/proc/unlook)
	LAZYREMOVE(viewers, weakref(user))

/obj/machinery/computer/helm/ui_status(mob/user, datum/ui_state/state)
	if(!linked)
		return UI_CLOSE
	return ..()

/obj/machinery/computer/helm/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipHelm")
		ui.open()

/obj/machinery/computer/helm/ui_data(mob/user)
	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	. = list(
		"sector" = current_sector ? current_sector.name : "Deep Space",
		"sectorInfo" = current_sector ? current_sector.desc : "Not Available",
		"s_x" = linked.x,
		"s_y" = linked.y,
		"dest" = dy && dx,
		"d_x" = dx,
		"d_y" = dy,
		"speed" = linked.get_speed(),
		"accel" = linked.get_acceleration(),
		"heading" = linked.get_heading() ? dir2angle(linked.get_heading()) : 0,
		"viewing" = viewing,
		"canburn" = linked.can_burn(),
		"etaNext" = linked.get_speed() ? round(linked.ETA()/10) : "N/A"
	)

	var/list/locations[0]
	for (var/key in known_sectors)
		var/datum/computer_file/data/waypoint/R = known_sectors[key]
		locations.Add(list(list(
			"name" = R.fields["name"],
			"x" = R.fields["x"],
			"y" = R.fields["y"],
			"reference" = "\ref[R]"
		)))

	.["locations"] = locations

/obj/machinery/computer/helm/ui_act(action, list/params)
	switch(action)
		if("waypoint")
			switch(params["waypoint"])
				if("add")
					add_waypoint(params["new_data"])
				if("remove")
					remove_waypoint(params["remove"])
		if("set")
			switch(params["set"])
				if("dest_x")
					dx = between(1, params["dest_x"], world.maxx)
				if("dest_y")
					dy = between(1, params["dest_y"], world.maxy)
				if("reset")
					dx = dy = 0
		if ("move")
			linked.relaymove(usr, params["move"])
		if ("brake")
			linked.decelerate()
		if ("view")
			viewing = !viewing
			if(usr && !isAI(usr))
				viewing ? look(usr) : unlook(usr)

	return TRUE

/obj/machinery/computer/helm/proc/add_waypoint(list/data)
	var/datum/computer_file/data/waypoint/R = new()
	R.fields["name"] = data["name"]
	R.fields["x"] = data["x"]
	R.fields["y"] = data["y"]
	known_sectors[data["name"]] = R

/obj/machinery/computer/helm/proc/remove_waypoint(ref)
	var/datum/computer_file/data/waypoint/R = locate(ref)
	if(R)
		known_sectors.Remove(R.fields["name"])
		qdel(R)
