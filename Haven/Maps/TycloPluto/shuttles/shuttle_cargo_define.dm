/area/supply_drone/dock
	name = "Supply Drone"
	icon_state = "shuttle3"
	requires_power = 0

// Subtyping shuttles make the Shuttles subsystem whine, SSshuttle uses
// subtypesof(/datum/shuttle) to initialize shuttle datums. Unless the type has
// itself as its own category, excluding it.
// So categorizing them make the subsystem ignore them.
/datum/shuttle/autodock/ferry/supply/drone
	category = /datum/shuttle/autodock/ferry/supply/drone

/datum/shuttle/autodock/ferry/supply/drone/pluto
	name = "Supply Drone"
	location = 0
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/supply_drone/dock
	dock_target = "pluto_supply_drone"
	current_location = "nav_cargo_dock"
	waypoint_offsite = "nav_cargo_away"
	waypoint_station = "nav_cargo_dock"
//	var/doorid = "supplyshuttledoors"


/obj/effect/shuttle_landmark/supply/pluto/away
	name = "Away"
	landmark_tag = "nav_cargo_away"

/obj/effect/shuttle_landmark/supply/pluto/docked
	name = "Onboard"
	landmark_tag = "nav_cargo_dock"
	base_area = /area/pluto/maintenance/central/bottom
	base_turf = /turf/space
	docking_controller = "supply_drone_dock"

/*
/datum/shuttle/autodock/ferry/supply/drone/pluto/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(!destination)
		return FALSE

	else
		..()

/datum/shuttle/autodock/ferry/supply/drone/pluto/arrived()
	. = ..()
	if(location == 0)
		for(var/obj/machinery/door/blast/M in SSmachines.machinery)
			if(M.id == src.doorid)
				if(M.density)
					spawn(0)
						M.open()
						return
				else
					spawn(0)
						M.close()
						return

/datum/shuttle/autodock/ferry/supply/drone/pluto/launch()
	if(location == 0)
		for(var/obj/machinery/door/blast/M in SSmachines.machinery)
			if(M.id == src.doorid)
				if(M.density)
					spawn(0)
						M.open()
						return
				else
					spawn(0)
						M.close()
						return

	..()
*/
