LEGACY_RECORD_STRUCTURE(all_waypoints, waypoint)

/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	circuit = /obj/item/weapon/circuitboard/helm
	var/obj/effect/overmap/ship/linked			//connected overmap object
	var/viewing = 0
	var/list/viewers = list()

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	linked = map_sectors["[z]"]

/obj/machinery/computer/ship/helm/Destroy()
	if(LAZY_LENGTH(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/obj/machinery/computer/ship/helm/proc/get_overmap_area()
	var/turf/T = locate(1,1,GLOB.using_map.overmap_z)
	if (T) // Baycode overmap may be the simplest, but it is also the shittest
		return T.loc

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/computer/ship/helm/check_eye(var/mob/user as mob)
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		return -1
	return 0

/obj/machinery/computer/ship/helm/attack_hand(var/mob/user as mob)
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

/obj/machinery/computer/ship/helm/proc/look(var/mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + 4
	GLOB.moved_event.register(user, src, /obj/machinery/computer/ship/helm/proc/unlook)
	GLOB.stat_set_event.register(user, src, /obj/machinery/computer/ship/helm/proc/unlook)
	LAZY_ADD_UNIQUE(viewers, weakref(user))

/obj/machinery/computer/ship/helm/proc/unlook(var/mob/user)
	user.reset_view()
	if(user.client)
		user.client.view = world.view
	GLOB.moved_event.unregister(user, src, /obj/machinery/computer/ship/helm/proc/unlook)
	GLOB.stat_set_event.unregister(user, src, /obj/machinery/computer/ship/helm/proc/unlook)
	LAZY_REMOVE(viewers, weakref(user))

/obj/machinery/computer/ship/helm/ui_status(mob/user, datum/ui_state/state)
	if(!linked)
		return UI_CLOSE
	return ..()

/obj/machinery/computer/ship/helm/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipHelm")
		ui.open()

/obj/machinery/computer/ship/helm/ui_data(mob/user)
	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	. = list(
		"sector" = current_sector ? current_sector.name : "Deep Space",
		"sectorInfo" = current_sector ? current_sector.desc : "Not Available",
		"s_x" = linked.x,
		"s_y" = linked.y,
		"speed" = linked.get_speed(),
		"acceleration" = linked.get_acceleration(),
		"heading" = linked.get_heading() ? dir2angle(linked.get_heading()) : 0,
		"viewing" = viewing,
		"canburn" = linked.can_burn(),
		"etaNext" = linked.get_speed() ? round(linked.ETA()/10) : "N/A"
	)

/obj/machinery/computer/ship/helm/ui_act(action, list/params)
	switch(action)
		if ("move")
			linked.relaymove(usr, params["move"])
		if ("brake")
			linked.decelerate()
		if ("view")
			viewing = !viewing
			if(usr && !isAI(usr))
				viewing ? look(usr) : unlook(usr)

	return TRUE
