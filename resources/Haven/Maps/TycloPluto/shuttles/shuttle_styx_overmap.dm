
// See comments in shuttle_cargo_define.dm on why this exists.
/datum/shuttle/autodock/overmap/exploration_shuttle
	category = /datum/shuttle/autodock/overmap/exploration_shuttle

/datum/shuttle/autodock/overmap/exploration_shuttle/pluto
	name = "Styx"
	warmup_time = 10
	move_time = 15
	shuttle_area = list(
		/area/exploration_shuttle/pluto/cockpit,
		/area/exploration_shuttle/pluto/atmos,
		/area/exploration_shuttle/pluto/power,
		/area/exploration_shuttle/pluto/crew,
		/area/exploration_shuttle/pluto/cargo,
		/area/exploration_shuttle/pluto/airlock
	)
	dock_target = "styx_shuttle"
	current_location = "nav_hangar_styx"
	landmark_transition = "nav_transit_styx"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_styx"
	//logging_access = access_expedition_shuttle_helm

/obj/effect/overmap/ship/landable/exploration_shuttle/pluto
	name = "Styx"
	shuttle = "Styx"
	fore_dir = EAST
	vessel_mass = 20

/obj/machinery/computer/shuttle_control/explore/styx
	name = "Styx Control Console"
	shuttle_tag = "Styx"
