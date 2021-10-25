/area/cargo_lift/pluto/lift
	name = "Cargo Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open

/datum/shuttle/autodock/ferry/cargo_lift_pluto
	name = "Cargo Freight Elevator"
	shuttle_area = /area/cargo_lift/pluto/lift
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_pluto_lift_bottom"
	waypoint_offsite = "nav_pluto_lift_top"
	sound_takeoff = 'resources/sound/effects/lift_heavy_start.ogg'
	sound_landing = 'resources/sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0

/obj/machinery/computer/shuttle_control/cargo_lift_pluto
	name = "cargo freight elevator controls"
	shuttle_tag = "Cargo Freight Elevator"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/effect/shuttle_landmark/cargo_lift_pluto/top
	name = "Top Deck"
	landmark_tag = "nav_pluto_lift_top"
	base_area = /area/logistics/uppercargo
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/cargo_lift_pluto/bottom
	name = "Lower Deck"
	landmark_tag = "nav_pluto_lift_bottom"
	base_area = /area/logistics/lowercargo
	base_turf = /turf/simulated/floor/plating
