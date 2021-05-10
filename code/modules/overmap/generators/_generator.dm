/datum/overmap_generator
	var/overmap_size

	var/list/turf/unsimulated/map/all_map_tiles
	var/list/turf/unsimulated/map/empty_map_tiles

	var/list/event_whitelist

/datum/overmap_generator/New()
	overmap_size = GLOB.using_map.overmap_size
	all_map_tiles = list()
	event_whitelist = list()


/datum/overmap_generator/proc/build_overmap()
	SHOULD_NOT_OVERRIDE(TRUE)
	world.maxz++
	GLOB.using_map.overmap_z = world.maxz

	var/list/edges = list()
	for (var/square in block(locate(1,1,GLOB.using_map.overmap_z), locate(overmap_size, overmap_size, GLOB.using_map.overmap_z)))
		var/turf/T = square
		if(T.x == overmap_size || T.y == overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
			edges += T
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
			all_map_tiles += T

	var/area/overmap/A = new
	A.contents.Add(all_map_tiles)
	A.contents.Add(edges)

	empty_map_tiles = all_map_tiles.Copy()

	GLOB.using_map.sealed_levels |= GLOB.using_map.overmap_z

	spawn_effects()
	// don't fucking ask me why Baycode folks thought this was a good idea to use the Z
	// instead of any other arbitrary value like a normal human being
	spawn_events(GLOB.using_map.overmap_z)

#define PLACE_OVERMAP_ITEM(O, T)    \
	if((istype(T) && istype(O)))    \
	{                               \
		O.forceMove(T);             \
		empty_map_tiles -= T;       \
		. = TRUE;                   \
	}

// Place overmap item according to strategy overriding this function
/datum/overmap_generator/proc/place_overmap_item(obj/O)
	CRASH("[src.type]: place_overmap_item is unimplemented")

// Place overmap item at fixated coordinates
/datum/overmap_generator/proc/place_overmap_item_at(obj/O, x, y)
	var/turf/T = locate(x, y, GLOB.using_map.overmap_z)
	PLACE_OVERMAP_ITEM(O, T)

// Place overmap item at fixated turf
/datum/overmap_generator/proc/place_overmap_item_at_turf(obj/O, turf/T)
	PLACE_OVERMAP_ITEM(O, T)

#undef PLACE_OVERMAP_ITEM

/datum/overmap_generator/proc/spawn_effects()
	return

/datum/overmap_generator/proc/spawn_events(number_of_events)
	CRASH("[src.type]: spawn_events is unimplemented")
