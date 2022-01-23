//portal

/obj/structure/boarding/shipportal //this is for returning from the map ships
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'resources/icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	anchored = 1
	layer = 3.1

/obj/structure/boarding/shipportal/Bumped(atom/movable/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return
/*
/obj/structure/boarding/shipportal/Crossed(atom/movable/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return
*/
/obj/structure/boarding/shipportal/attack_hand(mob/user as mob)
	spawn(0)
		src.teleport(user)
		return
	return

/obj/structure/boarding/shipportal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	else
		var/tele_x = GLOB.using_map.overmap_ship.evac_x
		var/tele_y = GLOB.using_map.overmap_ship.evac_y
		var/tele_z = GLOB.using_map.overmap_ship.evac_z

		do_teleport(M, locate(tele_x,tele_y,tele_z), 0)
		to_chat(M, "<span class='warning'>You teleport back to the ship!</span>")

/obj/effect/step_trigger/teleporter/urist/nerva
	teleport_x = 89
	teleport_y = 90
	teleport_z = 1

//self destruct for boarding //currently commented out until I work out the kinks

/obj/structure/boarding/self_destruct
	var/triggered = FALSE
	name = "self destruct mechanism"
	icon = 'resources/icons/obj/stationobjs.dmi'
	icon_state = "bus"
	anchored = 1
	density = 1
	var/shipid = null

/obj/structure/boarding/self_destruct/ex_act()
	return

/obj/structure/boarding/self_destruct/attack_hand(mob/user as mob)
	if(triggered)
		return

	else
		var/want = input("Start the self destruct countdown? You will have one minute to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
		switch(want)
			if("Cancel")
				return
			if("Yes")
				if(triggered)
					return

				else
					triggered = TRUE
					GLOB.global_announcer.autosay(
						"<b>The self-destruct sequence on the attacking ship has been initiated. Evacuate all boarding parties immediately.</b>",
						"[GLOB.using_map.full_name] Automated Defence Computer",
						"Common"
					)
					for(var/obj/effect/landmark/scom/bomb/B in landmarks_list)
						if(B.shipid == src.shipid)
							B.incomprehensibleprocname() //i fucking hate myself. what was i trying to prove with this shit.

						if(GLOB.using_map.overmap_ship)
							for(var/datum/shipcomponents/C in GLOB.using_map.overmap_ship)
								C.broken = TRUE

					spawn(1 MINUTE)
						if(GLOB.using_map.overmap_ship)
							if(!GLOB.using_map.overmap_ship.target.dying)
								GLOB.using_map.overmap_ship.target.shipdeath()


/obj/structure/boarding/self_destruct/lactera
	icon = 'resources/icons/urist/turf/scomturfs.dmi'
	icon_state = "9,8"
	shipid = "biglactship"

/obj/structure/boarding/self_destruct/pirateship
	shipid = "pirateship"

/obj/effect/landmark/scom/bomb/boarding
	var/delay_lower = 100
	var/delay_upper = 600

/obj/effect/landmark/scom/bomb/boarding/New()
	if(!bombdelay)
		bombdelay = rand(delay_lower,delay_upper)

	..()

/obj/effect/landmark/scom/bomb/boarding/pirateship
	shipid = "pirateship"

/obj/effect/landmark/scom/bomb/boarding/biglactship
	shipid = "biglactship"

/obj/structure/boarding/self_destruct/station
	name = "station self destruct mechanism"

/obj/structure/boarding/self_destruct/station/attack_hand(mob/user as mob)
	if(triggered)
		return

	else
		var/want = input("Start the self destruct countdown? You will have ten minutes to escape.", "Your Choice", "Cancel") in list ("Cancel", "Yes")
		switch(want)
			if("Cancel")
				return
			if("Yes")
				if(triggered)
					return

				else
					triggered = TRUE
					spawn(10 MINUTES)
						for(var/obj/effect/landmark/scom/bomb/B in landmarks_list)
							if(B.shipid == src.shipid)
								B.incomprehensibleprocname() //i fucking hate myself. what was i trying to prove with this shit.



					for(var/obj/effect/overmap/sector/station/S in SStrade_controller.overmap_stations)
						if(src.z in S.map_z)
							for(var/datum/contract/station_destroy/A in GLOB.using_map.contracts)
								if(A.neg_faction == S.faction)
									A.Complete(1)
