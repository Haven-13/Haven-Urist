
/proc/get_combat_ships(datum/unit_test/test)
	var/static/list/obj/effect/overmap/ship/combat/ships
	if(!ships)
		ships = list()
		for (var/obj/effect/overmap/ship/ship in GLOB.overmap_ships)
			if(!istype(ship))
				continue
			if(istype(ship, /obj/effect/overmap/ship/combat))
				test.log_debug(
					"[ship] is of combat subtype, will be tested."
				)
				ships += ship
			else
				test.log_debug(
					"[ship] isn't of combat subtype, skipping."
				)
	test.log_debug("Found [length(ships)] to test.")
	return ships


/datum/unit_test/has_projectile_landmarks
	name = "SHIP COMBAT SUPPORT: Has projectile landmarks"

/datum/unit_test/has_projectile_landmarks/start_test()
	var/list/fails = list()
	var/list/passes = list()
	var/list/vessels_to_test = get_combat_ships(src)
	if(!length(vessels_to_test))
		skip("Found no combat type vessels to unit-test, skipping.")
		return TRUE

	for(var/obj/effect/overmap/ship/combat/C in vessels_to_test)
		if(!istype(C))
			continue
		if(length(C.landmarks))
			passes[C.shipid] = TRUE
		else
			fails += "'[C.shipid]' ([C.ship_name]: [C]) has no projectile landmarks in its list"

	if(fails)
		for(var/f in fails)
			log_bad(f)
		fail("[length(fails)] vessels out of [length(vessels_to_test)] have no landmarks as required.")
	else
		pass("All [length(vessels_to_test)] vessels tested have landmarks.")
	return TRUE

