/obj/effect/overmap/ship/combat/pluto
	name = "AFCUV Pluto"
	shipid = "pluto"
	vessel_mass = 125
	fore_dir = SOUTH
	start_x = 17
	start_y = 17
	can_board = TRUE

	target_x_bounds = list(75, 125)
	target_y_bounds = list(45, 155)

	announcement_channel = list(
		COMBAT_CHANNEL_PUBLIC = "Common",
		COMBAT_CHANNEL_PRIVATE = "Command",
		COMBAT_CHANNEL_TECHNICAL = "Engineering"
	)

	initial_restricted_waypoints = list(
		"Styx" = list("nav_hangar_styx"),
		"Eris" = list("nav_hangar_eris")
	)

	hostile_factions = list(
		"pirate",
		"hostile"
	)
