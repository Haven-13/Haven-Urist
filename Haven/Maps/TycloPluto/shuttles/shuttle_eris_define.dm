/area/courier_shuttle/pluto
	name = "\improper Eris"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/courier_shuttle/pluto/cockpit
	name = "\improper Eris - Cockpit"
/area/courier_shuttle/pluto/utility
	name = "\improper Eris - Utility Bay"


/obj/effect/shuttle_landmark/pluto/hangar/courier_shuttle
	name = "Eris Hangar"
	landmark_tag = "nav_hangar_eris"
	base_area = /area
	base_turf = /turf/space

/obj/effect/shuttle_landmark/pluto/transit/courier_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_eris"
