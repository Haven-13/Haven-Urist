/area/turbolift/pluto
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/turbolift/pluto/start
	name = "\improper Turbolift Start"

/area/turbolift/pluto/first_deck
	name = "\improper first deck"
	lift_floor_label = "1st Deck"
	lift_floor_name = "Habitation"
	base_turf = /turf/simulated/floor/plating

/area/turbolift/pluto/second_deck
	name = "\improper second deck"
	lift_floor_label = "2nd Deck"
	lift_floor_name = "Operations"

/area/turbolift/pluto/third_deck
	name = "\improper third deck"
	lift_floor_label = "3rd Deck"
	lift_floor_name = "Expedition"

/obj/turbolift_map_holder/pluto
	name = "Pluto turbolift map placeholder"
	depth = 3
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/pluto/first_deck,
		/area/turbolift/pluto/second_deck,
		/area/turbolift/pluto/third_deck
	)
