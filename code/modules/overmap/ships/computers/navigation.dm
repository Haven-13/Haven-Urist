
/obj/machinery/computer/ship/navigation
	name = "navigation console"
	circuit = /obj/item/weapon/circuitboard/nav
	var/viewing = 0
	icon_keyboard = "generic_key"
	icon_screen = "helm"

/obj/machinery/computer/ship/navigation/ui_status(mob/user, datum/ui_state/state)
	if(!linked)
		return UI_CLOSE
	return ..()

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipNavigation")
		ui.open()

/obj/machinery/computer/ship/navigation/ui_data(mob/user)
	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/sector/current_sector = locate() in T

	. = list(
		"sector" = current_sector ? current_sector.name : "Deep Space",
		"sectorInfo" = current_sector ? current_sector.desc : "Not Available",
		"s_x" = linked.x,
		"s_y" = linked.y,
		"speed" = linked.get_speed(),
		"accel" = linked.get_acceleration(),
		"heading" = linked.get_heading() ? dir2angle(linked.get_heading()) : 0,
		"viewing" = viewing,
		"etaNext" = linked.get_speed() ? round(linked.ETA()/10) : "N/A"
	)

/obj/machinery/computer/ship/navigation/check_eye(var/mob/user as mob)
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		viewing = 0
		return -1
	return 0

/obj/machinery/computer/ship/navigation/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		viewing = 0
		return

	if(viewing && linked &&!isAI(user))
		user.set_machine(src)
		user.reset_view(linked)

	ui_interact(user)

/obj/machinery/computer/ship/navigation/ui_act(action, list/params)
	switch(action)
		if("view")
			viewing = !viewing
			if(viewing && !isAI(usr))
				var/mob/user = usr
				user.reset_view(linked)
			. = TRUE
