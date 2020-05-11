
// See comments in shuttle_cargo_define.dm on why this exists.
/datum/shuttle/autodock/overmap/courier_shuttle
	category = /datum/shuttle/autodock/overmap/courier_shuttle

/datum/shuttle/autodock/overmap/courier_shuttle/pluto
	name = "Eris"
	warmup_time = 5
	move_time = 30
	shuttle_area = list(
    /area/courier_shuttle/pluto/cockpit,
    /area/courier_shuttle/pluto/utility
  )
	dock_target ="eris_shuttle"
	current_location = "nav_hangar_eris"
	landmark_transition = "nav_transit_eris"
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_eris"
	//logging_access = access_courier_shuttle_helm

/obj/machinery/computer/shuttle_control/explore/eris
	name = "Eris Control Console"
	shuttle_tag = "Eris"
