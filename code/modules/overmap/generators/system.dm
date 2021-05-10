/datum/overmap_generator/system
	var/turf/center_turf
	var/list/unoccupied_orbits

	var/list/circle_angles

/datum/overmap_generator/system/New()
	. = ..()
	unoccupied_orbits = list()
	for (var/o = 4 to (overmap_size/2 - 3))
		unoccupied_orbits += o
	event_whitelist += /datum/overmap_event/meteor
	event_whitelist += /datum/overmap_event/dust

	circle_angles = list()
	var/c = 0
	while (c < 360)
		c += 0.3 // step, this will give you 360/step = 360 * ~3 points
		circle_angles += c

/datum/overmap_generator/system/spawn_effects()
	center_turf = locate(overmap_size/2 + 1, overmap_size/2 + 1, GLOB.using_map.overmap_z)
	var/obj/effect/overmap_static/star/S = new(center_turf)
	testing("Spawned a star ([S.name]) at [S.x], [S.y]")

/datum/overmap_generator/system/spawn_events(number_of_events)
	number_of_events = Floor(min(overmap_size/9, number_of_events)) || 1
	var/max_event_rings = rand(1, min(number_of_events, number_of_events))
	testing("Placing [max_event_rings], random from [number_of_events]")
	for(var/i = 1 to max_event_rings)
		if(!unoccupied_orbits.len)
			break
		var/overmap_event_type = pick(event_whitelist)
		var/datum/overmap_event/overmap_event = new overmap_event_type

		var/radius = pick(unoccupied_orbits)
		testing("Placing [overmap_event.name] event at orbit: [radius]")
		var/list/event_turfs = acquire_turfs_in_ring(center_turf, radius)
		testing("Found [event_turfs.len] turfs to populate...")
		for(var/event_turf in event_turfs)
			overmap_event_handler.bind_event_to(overmap_event, event_turf)
			empty_map_tiles -= event_turf

		// Put in some spacing so shit won't be so terrifyingly packed
		unoccupied_orbits -= radius - 1
		unoccupied_orbits -= radius
		unoccupied_orbits -= radius + 1

/datum/overmap_generator/system/proc/rind_locate(ox, oy, oz, radius, degree, radius_offset = 0.5)
	var/r = radius + radius_offset // offset the radius to account for the discrete nature of grid coordinates, eliminating "spikes"
	var/rx = r * cos(degree)
	var/ry = r * sin(degree)
	return locate(
		ox + Round(rx),
		oy + Round(ry),
		oz
	)

// TODO: Turn this into an independent "orind" or "rind" function that returns all the turfs in said rind
/datum/overmap_generator/system/proc/acquire_turfs_in_ring(turf/origio, radius)
	var/list/turfs = list()
	for(var/d in circle_angles)
		var/turf/T = rind_locate(
			origio.x,
			origio.y,
			GLOB.using_map.overmap_z,
			radius,
			d
		)
		if (istype(T) && !(T in turfs))
			turfs += T
	return turfs
