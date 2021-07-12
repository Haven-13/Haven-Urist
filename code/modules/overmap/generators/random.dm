/datum/overmap_generator/random

/datum/overmap_generator/random/New()
	. = ..()
	for (var/type in subtypesof(/datum/overmap_event))
		event_whitelist += type

/datum/overmap_generator/random/spawn_events(number_of_events)
	var/list/candidate_turfs = empty_map_tiles.Copy()
	candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap)

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(event_whitelist)
		var/datum/overmap_event/overmap_event = new overmap_event_type

		var/list/event_turfs = acquire_event_turfs(overmap_event.count, overmap_event.radius, candidate_turfs, overmap_event.continuous)

		for(var/event_turf in event_turfs)
			overmap_event_handler.bind_event_to(overmap_event, event_turf)
			candidate_turfs -= event_turf
			empty_map_tiles -= event_turf

/datum/overmap_generator/random/proc/acquire_event_turfs(var/number_of_turfs, var/distance_from_origin, var/list/candidate_turfs, var/continuous = TRUE)
	number_of_turfs = min(number_of_turfs, candidate_turfs.len)
	candidate_turfs = candidate_turfs.Copy() // Not this proc's responsibility to adjust the given lists

	var/origin_turf = pick(candidate_turfs)
	var/list/selected_turfs = list(origin_turf)
	var/list/selection_turfs = list(origin_turf)
	candidate_turfs -= origin_turf

	while(selection_turfs.len && selected_turfs.len < number_of_turfs)
		var/selection_turf = pick(selection_turfs)
		var/random_neighbour = get_random_neighbour(selection_turf, candidate_turfs, continuous, distance_from_origin)

		if(random_neighbour)
			candidate_turfs -= random_neighbour
			selected_turfs += random_neighbour
			if(get_dist(origin_turf, random_neighbour) < distance_from_origin)
				selection_turfs += random_neighbour
		else
			selection_turfs -= selection_turf

	return selected_turfs

/datum/overmap_generator/random/proc/get_random_neighbour(var/turf/origin_turf, var/list/candidate_turfs, var/continuous = TRUE, var/range)
	var/fitting_turfs
	if(continuous)
		fitting_turfs = origin_turf.CardinalTurfs(FALSE)
	else
		fitting_turfs = trange(range, origin_turf)
	fitting_turfs = shuffle(fitting_turfs)
	for(var/turf/T in fitting_turfs)
		if(T in candidate_turfs)
			return T

/datum/overmap_generator/random/place_overmap_item(obj/O)
	if(empty_map_tiles.len)
		var/turf/T = pick(empty_map_tiles)
		. = place_overmap_item_at_turf(O, T)
		testing("Putting [O.name] in random empty location: [T.x], [T.y]")
		return .

	CRASH("Unable to add [O.name]! No empty tiles left to fill!")
