/proc/get_combat_ships(datum/unit_test/test)
	var/static/list/obj/effect/overmap/ship/combat/ships
	if(!ships)
		ships = list()
		for (var/obj/effect/overmap/ship/ship in GLOB.overmap_ships)
			if(!istype(ship))
				continue
			if(istype(ship, /obj/effect/overmap/ship/combat))
				test.log_debug(
					"Vessel '[ship]' is of combat subtype and will be tested."
				)
				ships += ship
			else
				test.log_debug(
					"Vessel '[ship]' isn't of combat subtype, skipping."
				)
	test.log_debug("Found [length(ships)] to test.")
	return ships

/datum/unit_test/must_have_landmarks
	name = "SHIP COMBAT: Maps must have all required landmarks"

/datum/unit_test/must_have_landmarks/start_test()
	var/list/failed = list()
	var/list/fails = list()
	var/list/fails_this_ship
	var/list/vessels_to_test = get_combat_ships(src)
	if(!length(vessels_to_test))
		skip("Found no combat type vessels to unit-test, skipping.")
		return TRUE

	for(var/obj/effect/overmap/ship/combat/C in vessels_to_test)
		if(!istype(C))
			continue
		if(!length(C.projectile_landmarks))
			LAZY_ADD(fails_this_ship,\
			"'[C.shipid]' ([C.ship_name]: [C]) has no projectile landmarks in its list")
		if(!length(C.boarding_landmarks))
			LAZY_ADD(fails_this_ship,\
			"'[C.shipid]' ([C.ship_name]: [C]) has no boarding hint landmarks in its list")

		if(length(fails_this_ship))
			failed[C.shipid] = TRUE
			fails |= fails_this_ship
		fails_this_ship = null

	if(length(fails))
		for(var/f in fails)
			log_bad(f)
		fail("[length(fails)] vessels out of [length(vessels_to_test)] did not pass.")
	else
		pass("All [length(vessels_to_test)] vessels passed.")
	return TRUE

/datum/unit_test/ship_basic_requirements
	name = "SHIP COMBAT: Maps must meet minimum requirements"

/datum/unit_test/ship_basic_requirements/start_test()
	var/list/failed = list()
	var/list/fails = list()
	var/list/fails_this_ship
	var/list/vessels_to_test = get_combat_ships(src)
	if(!length(vessels_to_test))
		skip("Found no combat type vessels to unit-test, skipping.")
		return TRUE

	for(var/obj/effect/overmap/ship/combat/C in vessels_to_test)
		if(!istype(C))
			continue
		// These two make me feel disgusting, but just get the job done, alright
		if(!C.target_x_bounds\
			|| (length(C.target_x_bounds) != 2)\
			|| !isnum(C.target_x_bounds[1])\
			|| !isnum(C.target_x_bounds[2]))
			LAZY_ADD(fails_this_ship,\
			"'[C.shipid]' ([C.ship_name]: [C]) requires a list with 2 integers for 'target_x_bounds'")
		if(!C.target_y_bounds\
			|| (length(C.target_y_bounds) != 2)\
			|| !isnum(C.target_y_bounds[1])\
			|| !isnum(C.target_y_bounds[2]))
			LAZY_ADD(fails_this_ship,\
			"'[C.shipid]' ([C.ship_name]: [C]) requires a list with 2 integers for 'target_y_bounds'")

		if(length(fails_this_ship))
			failed[C.shipid] = TRUE
			fails |= fails_this_ship
		fails_this_ship = null

	if(length(fails))
		for(var/f in fails)
			log_bad(f)
		fail("[length(fails)] vessels out of [length(vessels_to_test)] did not pass.")
	else
		pass("All [length(vessels_to_test)] vessels passed.")
	return TRUE
