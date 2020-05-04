/area/supply_drone/dock
	name = "Supply Drone"
	icon_state = "shuttle3"
	requires_power = 0

/datum/shuttle/autodock/ferry/supply/drone/pluto
	name = "Supply Drone"
	location = 1
	warmup_time = 5
	move_time = 30
	shuttle_area = /area/supply_drone/dock
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"
	var/doorid = "supplyshuttledoors"


/obj/effect/shuttle_landmark/supply/pluto/away
	name = "Away"
	landmark_tag = "nav_cargo_away"

/obj/effect/shuttle_landmark/supply/pluto/docked
	name = "Onboard"
	landmark_tag = "nav_cargo_dock"
	base_area = /area/spacestations/nanotrasenspace
	base_turf = /turf/simulated/floor/plating


/datum/shuttle/autodock/ferry/supply/drone/pluto/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(!destination)
		return FALSE

	else
		..()

/datum/shuttle/autodock/ferry/supply/drone/pluto/arrived()
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
