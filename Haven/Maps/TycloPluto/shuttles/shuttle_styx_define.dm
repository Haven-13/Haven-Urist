/area/exploration_shuttle/pluto
	name = "\improper Styx"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/exploration_shuttle/pluto/cockpit
	name = "\improper Styx - Cockpit"
/area/exploration_shuttle/pluto/atmos
	name = "\improper Styx - Atmos Compartment"
/area/exploration_shuttle/pluto/power
	name = "\improper Styx - Power Compartment"
/area/exploration_shuttle/pluto/crew
	name = "\improper Styx - Crew Compartment"
/area/exploration_shuttle/pluto/cargo
	name = "\improper Styx - Cargo Bay"
/area/exploration_shuttle/pluto/airlock
	name = "\improper Styx - Airlock Compartment"


/obj/effect/shuttle_landmark/pluto/hangar/exploration_shuttle
	name = "Styx Hangar"
	landmark_tag = "nav_hangar_styx"
	base_area = /area/space
	base_turf = /turf/space
	docking_controller = "styx_shuttle_dock_airlock"

/obj/effect/shuttle_landmark/pluto/transit/exploration_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_styx"
