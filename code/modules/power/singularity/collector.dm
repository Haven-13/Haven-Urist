//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
var/global/list/rad_collectors = list()

/obj/machinery/power/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses radiation and phoron to produce power."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "ca"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)
//	use_power = 0
	var/obj/item/weapon/tank/phoron/P = null
	var/last_power = 0
	var/last_power_new = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

/obj/machinery/power/rad_collector/New()
	..()
	rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	rad_collectors -= src
	. = ..()

/obj/machinery/power/rad_collector/Process()
	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0

	if(P && active)
		var/rads = SSradiation.get_rads_at_turf(get_turf(src))
		if(rads)
			receive_pulse(rads * 5) //Maths is hard

	if(P)
		if(P.air_contents.gas["phoron"] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			eject()
		else
			P.air_contents.adjust_gas("phoron", -0.001*drainratio)
	return


/obj/machinery/power/rad_collector/attack_hand(mob/user as mob)
	if(anchored)
		if(!src.locked)
			toggle_power()
			user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
			"You turn the [src.name] [active? "on":"off"].")
			investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [user.key]. [P?"Fuel: [round(P.air_contents.gas["phoron"]/0.29)]%":"<font color='red'>It is empty</font>"].","singulo")
			return
		else
			to_chat(user, "<span class='warning'>The controls are locked!</span>")
			return


/obj/machinery/power/rad_collector/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/tank/phoron))
		if(!src.anchored)
			to_chat(user, "<span class='warning'>The [src] needs to be secured to the floor first.</span>")
			return 1
		if(src.P)
			to_chat(user, "<span class='warning'>There's already a phoron tank loaded.</span>")
			return 1
		if(!user.unEquip(W, src))
			return
		src.P = W
		update_icons()
		return 1
	else if(isCrowbar(W))
		if(P && !src.locked)
			eject()
			return 1
	else if(isWrench(W))
		if(P)
			to_chat(user, "<span class='notice'>Remove the phoron tank first.</span>")
			return 1
		for(var/obj/machinery/power/rad_collector/R in get_turf(src))
			if(R != src)
				to_chat(user, "<span class='warning'>You cannot install more than one collector on the same spot.</span>")
				return 1
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet")
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
		return 1
	else if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/modular_computer))
		if (src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = 0 //just in case it somehow gets locked
				to_chat(user, "<span class='warning'>The controls can only be locked when the [src] is active</span>")
		else
			to_chat(user, "<span class='warning'>Access denied!</span>")
		return 1
	return ..()

/obj/machinery/power/rad_collector/examine(mob/user)
	if (..(user, 3))
		to_chat(user, "The meter indicates that \the [src] is collecting [last_power] W.")
		return 1

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(2, 3)
			eject()
	return ..()

/obj/machinery/power/rad_collector/return_air()
	if(P)
		return P.return_air()

/obj/machinery/power/rad_collector/proc/eject()
	locked = 0
	var/obj/item/weapon/tank/phoron/Z = src.P
	if (!Z)
		return
	Z.forceMove(get_turf(src))
	Z.reset_plane_and_layer()
	src.P = null
	if(active)
		toggle_power()
	else
		update_icons()

/obj/machinery/power/rad_collector/proc/receive_pulse(var/pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = P.air_contents.gas["phoron"]*pulse_strength*20
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/power/rad_collector/proc/update_icons()
	overlays.Cut()
	if(P)
		overlays += mutable_appearance(icon, "ptank")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		overlays += mutable_appearance(icon, "on")


/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	update_icons()
	return

/obj/machinery/power/rad_collector/pipenet
	name = "Modular Radiation Collector Array"
	desc = "A variant of the radiation collector array which connects to a pipecap underneath it."
	var/obj/machinery/atmospherics/pipe/cap/pipe = null
	var/datum/gas_mixture/removed = null

/obj/machinery/power/rad_collector/pipenet/Destroy()
	QDEL_NULL(removed)
	pipe = null
	. = ..()

/obj/machinery/power/rad_collector/pipenet/Initialize()
	if(anchored)
		locate_pipenet()
		connect_to_network()
	. = ..()

/obj/machinery/power/rad_collector/pipenet/Process()
	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0
	if(!pipe || !anchored)
		return
	var/datum/gas_mixture/env = pipe.return_air()
	removed = env.remove(0.75 * env.total_moles)
	if(pipe && active)
		var/rads = SSradiation.get_rads_at_turf(get_turf(src))
		if(rads)
			receive_pulse(rads * 5) //Maths is hard

	if(pipe && removed)
		if(removed.gas["phoron"] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			active = 0
			update_icons()
		else
			removed.adjust_gas("phoron", -0.001*drainratio)
			env.merge(removed)
	return

/obj/machinery/power/rad_collector/pipenet/receive_pulse(var/pulse_strength)
	if(pipe && active)
		var/power_produced = 0
		power_produced = removed.gas["phoron"]*pulse_strength*20
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/power/rad_collector/pipenet/attackby(obj/item/W, mob/user)
	if(isWrench(W))
		for(var/obj/machinery/power/rad_collector/R in get_turf(src))
			if(R != src)
				to_chat(user, "<span class='warning'>You cannot install more than one collector on the same spot.</span>")
				return 1
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet")
		if(anchored)
			connect_to_network()
			locate_pipenet()
		else
			disconnect_from_network()
			P = null
		return 1
	return ..()


/obj/machinery/power/rad_collector/pipenet/proc/locate_pipenet()
	var/turf/T = get_turf(src)
	pipe = locate(/obj/machinery/atmospherics/pipe/cap) in T

/obj/machinery/power/rad_collector/pipenet/update_icons()
	overlays.Cut()
	if(pipe)
		overlays += mutable_appearance(icon, "ptank")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		overlays += mutable_appearance(icon, "on")
