/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/proc/_can_z_pass(turf/source, atom/A, direction)
	if(locate(/obj/structure/catwalk, source))
		if(source.z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

/turf/simulated/open/CanZPass(atom/A, direction)
	return _can_z_pass(src, A, direction)

/turf/space/CanZPass(atom/A, direction)
	return _can_z_pass(src, A, direction)
