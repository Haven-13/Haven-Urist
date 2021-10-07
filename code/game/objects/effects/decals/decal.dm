/obj/effect/decal
	plane = DEFAULT_PLANE
	layer = TURF_DECAL_LAYER


/obj/effect/decal/fall_damage()
	return 0

/obj/effect/decal/is_burnable()
	return TRUE

/obj/effect/decal/lava_act()
	. = !throwing ? ..() : FALSE
