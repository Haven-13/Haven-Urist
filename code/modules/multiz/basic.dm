// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	..()

	var/obj/effect/landmark/submap_data/previous
	var/obj/effect/landmark/submap_data/current

	for(var/i = (z - height + 1) to (z))
		// Generate submap chunks
		current = new/obj/effect/landmark/submap_data(locate(1,1,i))
		if (previous)
			previous.register_link_above(current)
		previous = current

/obj/effect/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/proc/GetZDepth(z)
	var/obj/effect/landmark/submap_data/SMD = GetSubmapData(z)

	var/bottom_z
	if (SMD)
		bottom_z = SMD.get_bottommost_z()
	else
		bottom_z = z

	return (z - bottom_z) + 1

/proc/HasAbove(z)
	if(z >= world.maxz || z < 1)
		return FALSE
	if (HasSubmapData(z))
		return GetSubmapData(z).has_above()
	return FALSE

/proc/HasBelow(z)
	if(z > world.maxz || z < 2)
		return FALSE
	if (HasSubmapData(z))
		return GetSubmapData(z).has_below()
	return FALSE

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(z)
	. = list()
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	. |= z
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(zA, zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)
