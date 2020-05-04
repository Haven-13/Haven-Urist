/obj/effect/overmap/ship/combat/pluto
	name = "AFCUV Pluto"
	shipid = "pluto"
	vessel_mass = 200 //bigger than wyrm, smaller than torch
	fore_dir = SOUTH
	start_x = 6
	start_y = 7
	can_board = TRUE

  initial_restricted_waypoints = list(
    "Styx" = list("nav_hangar_styx")
    "Eris" = list("nav_hangar_eris")
  )

  hostile_factions = list(
    "pirate",
    "hostile"
  )
