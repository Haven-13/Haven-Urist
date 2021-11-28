
/datum/unit_test/elevator_floors_sanity/
	name = "MULTI-Z: Elevators must be consistent & sane"

/datum/unit_test/elevator_floors_sanity/start_test()
	if(!length(turbolifts))
		return 0

	var/failures = 0
	var/list/failed = list()

	for (var/datum/turbolift/lift in turbolifts)
		for (var/i in 1 to length(lift.floors))
			var/datum/turbolift_floor/floor = lift.floors[i]
			var/area/turbolift/A = floor.area_ref
			var/consistent = (\
				A.lift_floor_label == floor.label\
				&& (A.lift_floor_name == floor.name || A.name == floor.name)\
				&& A.lift_announce_str == floor.announce_str\
			)
			if(!consistent)
				log_bad("Lift [lift.creator_type]: Option [i] ([floor.label] - [floor.name]) is inconsistent with [A]!")
				failures += 1
				failed[lift.creator_type] = TRUE

	if(failures)
		fail("Found [failures] inconsistencies in [english_list(failed)]!")
	else
		pass("All elevators found to be consistent & sane")
	return 1
