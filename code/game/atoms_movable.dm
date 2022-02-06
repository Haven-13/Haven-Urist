/atom/movable
	plane = DEFAULT_PLANE

	appearance_flags = TILE_BOUND
	glide_size = 8

	var/waterproof = TRUE
	var/movable_flags

	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)

	/// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = FALSE
	///Internal holder for emissive blocker object, do not use directly use blocks_emissive
	var/atom/movable/emissive_blocker/em_block

/atom/movable/Initialize(mapload)
	. = ..()
	add_overlay(get_emissive_blocker())

/atom/movable/Destroy()
	. = ..()

	QDEL_NULL(em_block)
	for(var/atom/movable/AM in src)
		qdel(AM)

	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/Bump(var/atom/A, yes)
	if(src.throwing)
		src.throw_impact(A)
		src.throwing = 0

	spawn(0)
		if (A && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/movable/proc/forceMove(atom/destination)
	if(loc == destination)
		return 0
	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
			// Only update plane if we're located on map
			// if we wasn't on map OR our Z coord was changed
			if (!is_origin_turf || (get_z(loc) != get_z(origin)))
				update_plane()

	return 1

// Keep in mind that this is also overriden in  code/datums/observation/moved.dm
/atom/movable/Move()
	var/atom/origin = loc
	. = ..()
	// Only update plane if we're located on map
	if (isturf(src.loc))
		// if we wasn't on map OR our Z coord was changed
		if (!isturf(origin) || (get_z(loc) != get_z(origin)))
			update_plane()

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(is_obj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		T.hitby(src,speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(is_obj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	set waitfor = FALSE

	if(!target || !src)
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf
	src.pixel_z = 0
	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/distance = get_dist(src, target)
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dist_z = abs(target.z - src.z)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH

	// This is not a realistic throwing algothrim
	// TODO: make a curve function for this
	var/dz
	if (target.z > src.z)
		dz = UP
	else
		dz = DOWN

	var/error
	var/major_dir
	var/major_dist
	var/minor_dir
	var/minor_dist
	if(dist_x > dist_y)
		error = dist_x/2 - dist_y
		major_dir = dx
		major_dist = dist_x
		minor_dir = dy
		minor_dist = dist_y
	else
		error = dist_y/2 - dist_x
		major_dir = dy
		major_dist = dist_y
		minor_dir = dx
		minor_dist = dist_x

	var/section = 0
	var/section_dist
	var/max_jumps
	if (dist_z)
		// how much distance to travel before attempting to go up/down?
		section_dist = distance / (dist_z + 1)
		if (dz == UP)
			section_dist = Floor(section_dist)
		else
			section_dist = Ceiling(section_dist)
		max_jumps = dist_z

	while(src && target && src.throwing && istype(src.loc, /turf) \
			&& ((abs(target.x - src.x)+abs(target.y - src.y) > 0 && dist_travelled < range) \
				|| (a && a.has_gravity == 0) \
				|| istype(src.loc, /turf/space)))
		// begin while loop
		if(dist_z)
			if(dist_travelled >= (section_dist * (section + 1)) && \
				section < max_jumps
			)
				var/turf/T = null
				var/turf/O = get_turf(src)
				var/can_pass_z = O.CanZPass(src, dz)
				if (dz == UP)
					T = GetAbove(src)
					can_pass_z = can_pass_z && (T && T.CanZPass(src, dz))
				else
					T = GetBelow(src)
				if(can_pass_z && T)
					src.forceMove(T)
					hit_check(speed)
					section++
				else
					break // we hit something

		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		if(error >= 0)
			step = get_step(src, major_dir)
			error -= minor_dist
		else
			step = get_step(src, minor_dir)
			error += major_dist
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break

		src.Move(step)
		hit_check(speed)
		dist_travelled++
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)
		a = get_area(src.loc)
		// and yet it moves
		if(src.does_spin)
			src.SpinAnimation(speed = 4, loops = 1)
		// end of while loop

	//done throwing, either because it hit something or it finished moving
	if(is_obj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null
	fall()

/atom/movable/proc/get_emissive_blocker()
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			var/mutable_appearance/gen_emissive_blocker = mutable_appearance(
				icon,
				plane = get_float_plane(EMISSIVE_PLANE),
				alpha = src.alpha
			)
			gen_emissive_blocker.color = GLOB.em_block_color
			gen_emissive_blocker.appearance_flags |= appearance_flags
			return list(gen_emissive_blocker)
		if(EMISSIVE_BLOCK_UNIQUE)
			if(!em_block && !QDELETED(src))
				render_target = ref(src)
				em_block = new(src, render_target)
			return list(em_block)
	return null

/*
 * Creates an pair of overlay images, one is the base colours and the other
 * is the black-color mask of the base image, creating an obstruction of lights layered below.
 */
/atom/movable/proc/get_normal_overlay(
		var/icon = src.icon,
		var/state = src.icon_state,
		var/layer = FLOAT_LAYER,
		var/icon_plane = src.original_plane,
		var/alpha = src.alpha,
	)
	var/_plane = get_float_plane(icon_plane)
	var/mutable_appearance/base = mutable_appearance(
		icon,
		state,
		plane = _plane,
		layer = layer,
		alpha = alpha
	)

	var/_em_plane = get_float_plane(EMISSIVE_PLANE)
	var/mutable_appearance/blocker = mutable_appearance(
		icon,
		state,
		plane = _em_plane,
		alpha = alpha
	)
	blocker.color = GLOB.em_block_color

	return list(base, blocker)

/*
 * Creates an pair of overlay images, one is the base colours and the other
 * is the white-color mask of the base image, creating an emissive light effect.
 */
/atom/movable/proc/get_emissive_overlay(
		var/icon = src.icon,
		var/state = src.icon_state,
		var/layer = FLOAT_LAYER,
		var/icon_plane = src.original_plane,
		var/alpha = src.alpha,
		var/no_block = FALSE,
		var/no_base = FALSE
	)
	. = list()
	if (!no_base)
		var/_plane = get_float_plane(icon_plane)
		var/mutable_appearance/base = mutable_appearance(
			icon,
			state,
			plane = _plane,
			layer = layer,
			alpha = alpha
		)
		. |= base

	var/_em_plane = get_float_plane(EMISSIVE_PLANE)
	var/_em_layer = (no_block && EMISSIVE_UNBLOCKABLE_LAYER) || FLOAT_LAYER
	var/mutable_appearance/mask = mutable_appearance(
		icon,
		state,
		plane = _em_plane,
		layer = _em_layer,
		alpha = alpha
	)
	mask.color = GLOB.emissive_color
	. |= mask


//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	src.verbs.Cut()
	..()

/atom/movable/overlay/Destroy()
	master = null
	. = ..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(!simulated)
		return

	if(!z || (z in GLOB.using_map.sealed_levels))
		return

	if(!GLOB.universe.OnTouchMapEdge(src))
		return

	if(GLOB.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/new_x
	var/new_y
	var/new_z = GLOB.using_map.get_transit_zlevel(z)
	if(new_z)
		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		var/turf/T = locate(new_x, new_y, new_z)
		if(T)
			forceMove(T)
