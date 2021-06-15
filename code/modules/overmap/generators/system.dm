#define DISTRIBUTION_SINUSOIDAL 1
#define DISTRIBUTION_NORMAL     2

// Poisson distribution random
#define POISSON_PDF(l, k, f) ((l ** k) * (EULER ** (-(l))) / (f))

/proc/POISSON_RAND(lambda, max=10)
	var/k = 0
	var/f = 1
	var/p = POISSON_PDF(lambda, k, f)
	var/cdf = p
	var/ran = rand(0, 100) / 100
	while(k < max && (ran > cdf))
		k += 1
		f *= k
		p = POISSON_PDF(lambda, k, f)
		cdf += p
	return k

#undef POISSON_PDF
// End Poisson

/datum/overmap_generator/system
	var/turf/center_turf
	var/list/unoccupied_orbits

	var/minimum_radius = 4
	var/maximum_radius = 30

	var/ring_exclusion_zone_radius = 2

	var/probability_clamp_max = 0.95
	var/probability_clamp_min = 0.25

	var/mean_rings = 1.5        // lambda for the poisson distribution for amount of rings
	var/peaks_per_ring = 3      // (Sinusoidal only) how many high-probability peaks should the rings have?

	var/distribution_method = DISTRIBUTION_SINUSOIDAL

/datum/overmap_generator/system/New()
	. = ..()
	unoccupied_orbits = list()
	minimum_radius = max(4, minimum_radius)
	maximum_radius = min((overmap_size/2 - OVERMAP_EDGE), maximum_radius)
	for (var/o = minimum_radius to maximum_radius)
		unoccupied_orbits += o

	event_whitelist += /datum/overmap_event/meteor
	event_whitelist += /datum/overmap_event/dust

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
	var/max_event_rings = 0
	var/list/candidate_rings
#ifdef UNIT_TEST
	max_event_rings = 1
	candidate_rings = list(minimum_radius)
	testing("Unit-test enabled, will guarantee [max_event_rings] ring[max_event_rings != 1 && "s" || ""]" + \
	" at the orbit[candidate_rings.len != 1 && "s" || ""]: [english_list(candidate_rings)]")
#else
	max_event_rings = POISSON_RAND(mean_rings, max=number_of_events)
	candidate_rings = unoccupied_orbits.Copy()
	testing("Placing [max_event_rings] rings in system")
#endif

	for(var/i = 1 to max_event_rings)
		if(!candidate_rings.len)
			break
		var/overmap_event_type = pick(event_whitelist)
		var/datum/overmap_event/E = new overmap_event_type

		var/radius = pick(candidate_rings)
		testing("\tPlacing [E.name] event at orbit: [radius]")
		var/list/Ts = acquire_turfs_in_ring(center_turf, radius)

		switch(distribution_method)
			if(DISTRIBUTION_SINUSOIDAL)
				distribute_sinusoidal(E, Ts)
			if(DISTRIBUTION_NORMAL)
				distribute_normal(E, Ts)
			else
				CRASH("No distribution method is defined for [E.name]!")

		// Put in some spacing so shit won't be so terrifyingly packed
		for (var/r = (radius - ring_exclusion_zone_radius) to (radius + ring_exclusion_zone_radius))
			candidate_rings -= r

		unoccupied_orbits -= radius

/datum/overmap_generator/system/place_overmap_item(obj/O)
	var/turf/T
	if(unoccupied_orbits.len)
		var/orbit = pick(unoccupied_orbits)
		T = pick(acquire_turfs_in_ring(center_turf, orbit, check_empty=TRUE))
		if (place_overmap_item_at_turf(O, T))
			unoccupied_orbits -= orbit
			testing("Put \"[O.name]\" in the orbit: r=[orbit]")
			return TRUE

	if(empty_map_tiles.len)
		T = pick(empty_map_tiles)
		. = place_overmap_item_at_turf(O, T)
		testing("Was unable to put \"[O.name]\" in an orbit, putting in random empty location: [T.x], [T.y]")
		return .

	CRASH("Unable to add \"[O.name]\"! No empty tiles left to fill!")

// Distribute the events using a sinusoidal function fit to have N=peaks_per_ring "peaks"
// The peaks are where the probability p is the highest, so most of the event effects are
// placed at those peaks. Mimicking distribution of real-life asteroids close to planets.
/datum/overmap_generator/system/proc/distribute_sinusoidal(datum/overmap_event/E, list/turf/Ts)
	var/step = 360 / Ts.len
	var/angle = rand(0, 359) // start

	var/clamp = probability_clamp_max - probability_clamp_min
	for(var/turf/T in Ts)
		var/p = (sin(angle * peaks_per_ring) + 1)/2 * clamp + probability_clamp_min
		if(prob(p * 100))
			overmap_event_handler.bind_event_to(E, T)
			empty_map_tiles -= T
		angle += step

// Just a fair warning, the distribution here is a hot mess and is not even a real normal distribution
// but for the purpose of a common-ground between gameplay and aesthetic, it works fine
#define NORM_RAND(x, f, p) (f * (EULER ** (p*((x) ** 2.0))))

// Spawn event turfs distributed by a normal distribution based on count spots skipped
// For the sigma, we use 2*pi*r, which we already get from the Ts list because it is the rind
/datum/overmap_generator/system/proc/distribute_normal(datum/overmap_event/E, list/turf/Ts)
	var/count = 0
	var/sigma = Ts.len
	// 1 / (sigma * sqrt(2*pi))
	var/normal_factor = 1/(sigma * 2.51)
	// the -1/2 * (1/sigma)**2 part of the exp in normal dist
	var/power_factor = -1/(2 * (sigma ** 2))
	// clamp the model to a desired probability range
	var/normalize = 1/(NORM_RAND(0, normal_factor, power_factor)) * (probability_clamp_max - probability_clamp_min)
	for(var/turf/T in Ts)
		if(!prob(((NORM_RAND(count, normal_factor, power_factor) * normalize) + probability_clamp_min) * 100))
			overmap_event_handler.bind_event_to(E, T)
			empty_map_tiles -= T
		else
			count += 1

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
/datum/overmap_generator/system/proc/acquire_turfs_in_ring(turf/origio, radius, radius_offset = 0.5, check_empty=FALSE)
	var/list/turfs = list()
	var/angle = 0
	var/step = arctan(radius + radius_offset, 1) // Equivalent to arctan (1 / (radius + 0.5))
	while(angle < 360)
		var/turf/T = rind_locate(
			origio.x,
			origio.y,
			GLOB.using_map.overmap_z,
			radius,
			angle,
			radius_offset
		)
		angle += step
		if (istype(T) && !(T in turfs))
			if (check_empty && !(T in empty_map_tiles))
				continue
			turfs += T
	return turfs
