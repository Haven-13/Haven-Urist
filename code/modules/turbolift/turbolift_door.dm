/obj/machinery/door/airlock/lift
	name = "Elevator Door"
	desc = "Ding."
	req_access = list(access_maint_tunnels)
	opacity = 0
	autoclose = 0
	glass = 1
	airlock_type = "elevator"
	icon = 'resources/icons/obj/doors/elevator/door.dmi'
	fill_file = 'resources/icons/obj/doors/elevator/fill_steel.dmi'
	glass_file = 'resources/icons/obj/doors/elevator/fill_glass.dmi'
	bolts_file = 'resources/icons/obj/doors/elevator/lights_bolts.dmi'
	deny_file = 'resources/icons/obj/doors/elevator/lights_deny.dmi'
	lights_file = 'resources/icons/obj/doors/elevator/lights_green.dmi'

	paintable = 0

	var/datum/turbolift/lift
	var/datum/turbolift_floor/floor

/obj/machinery/door/airlock/lift/Destroy()
	if(lift)
		lift.doors -= src
	if(floor)
		floor.doors -= src
	return ..()

/obj/machinery/door/airlock/lift/bumpopen(mob/user)
	return // No accidental sprinting into open elevator shafts.

/obj/machinery/door/airlock/lift/allowed(mob/M)
	return FALSE //only the lift machinery is allowed to operate this door

/obj/machinery/door/airlock/lift/close(forced=0)
	for(var/turf/turf in locs)
		for(var/mob/living/LM in turf)
			if(LM.mob_size <= MOB_TINY)
				var/moved = 0
				for(dir in shuffle(GLOB.cardinal.Copy()))
					var/dest = get_step(LM,dir)
					if(!(locate(/obj/machinery/door/airlock/lift) in dest))
						if(LM.Move(dest))
							moved = 1
							LM.visible_message("\The [LM] scurries away from the closing doors.")
							break
				if(!moved) // nowhere to go....
					LM.gib()
			else // the mob is too big to just move, so we need to give up what we're doing
				audible_message("\The [src]'s motors grind as they quickly reverse direction, unable to safely close.")
				cur_command = null // the door will just keep trying otherwise
				return 0
	return ..()
