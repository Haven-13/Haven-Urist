/datum/overmap_generator/system
	var/turf/center_turf
	var/list/unoccupied_orbits

	var/list/circle_angles
	var/sigma_coefficient = 1.5 // the bigger, the higher the p on normal distribution

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
	var/center = overmap_size/2 + 1
	var/obj/effect/overmap_static/star/S = new()

	place_overmap_item_at(S, center, center)
	for (var/turf/T in oview(1, S))
		empty_map_tiles -= T

	center_turf = S.loc
	testing("Spawned a star ([S.name]) at [S.x], [S.y]")

/datum/overmap_generator/system/spawn_events(number_of_events)
	number_of_events = Floor(min(overmap_size/9, number_of_events)) || 1
	var/max_event_rings = rand(1, number_of_events)

	testing("Placing [max_event_rings] rings of events, rand max: [number_of_events]")
	for(var/i = 1 to max_event_rings)
		if(!unoccupied_orbits.len)
			break
		var/overmap_event_type = pick(event_whitelist)
		var/datum/overmap_event/E = new overmap_event_type

		var/radius = pick(unoccupied_orbits)
		testing("\tPlacing [E.name] event at orbit: [radius]")
		var/list/Ts = acquire_turfs_in_ring(center_turf, radius)
		testing("\tFound [Ts.len] turfs to populate...")

		distribute_normal(
			(Ts.len) / ((E.radius*radius) - (E.count*sqrt(radius))),
			E,
			Ts
		)

		// Put in some spacing so shit won't be so terrifyingly packed
		unoccupied_orbits -= radius + 1
		unoccupied_orbits -= radius
		unoccupied_orbits -= radius - 1

/datum/overmap_generator/system/place_overmap_item(obj/O)
	var/turf/T
	if(unoccupied_orbits.len)
		var/orbit = pick(unoccupied_orbits)
		T = pick(acquire_turfs_in_ring(center_turf, orbit))
		if (place_overmap_item_at_turf(O, T))
			unoccupied_orbits -= orbit
			testing("Put \"[O.name]\" in an orbit: r=[orbit]")
			return TRUE

	if(empty_map_tiles.len)
		T = pick(empty_map_tiles)
		. = place_overmap_item_at_turf(O, T)
		testing("Was unable to put \"[O.name]\" in an orbit, putting in random empty location: [T.x], [T.y]")
		return .

	CRASH("Unable to add \"[O.name]\"! No empty tiles left to fill!")

#define NORM_RAND(x, f, p) (f * (EULER ** (p*((x) ** 2.0))))

// Spawn event turfs distributed by a normal distribution based on count spots skipped and events' count and radius, both for sigma
/datum/overmap_generator/system/proc/distribute_normal(sigma, datum/overmap_event/E, list/turf/Ts)
	if (sigma < 0) // sigma must always be positive in normal dist (s^2 > 0)
		sigma = -sigma
	sigma *= sigma_coefficient

	var/count = 0
	// 1 / (sigma * sqrt(2*pi))
	var/normal_factor = 1/(sigma * 2.51)
	// the -1/2 * (1/sigma)**2 part of the exp in normal dist
	var/power_factor = -1/(2 * (sigma ** 2))
	for(var/event_turf in Ts)
		if(prob(NORM_RAND(count, normal_factor, power_factor) * 100))
			count += 1
		else
			overmap_event_handler.bind_event_to(E, event_turf)
			empty_map_tiles -= event_turf

#undef NORM_RAND

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
