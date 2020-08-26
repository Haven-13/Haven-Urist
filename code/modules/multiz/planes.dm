#define PLANES_PER_Z_LEVEL PLANE_DIFFERENCE

/atom
	var/original_plane = null

/atom/proc/init_plane()	//Set initial original plane
	if(!original_plane)
		original_plane = plane

/atom/proc/set_plane(var/new_plane)	//Changes plane
	original_plane = new_plane
	update_plane()

/proc/calculate_plane(var/z,var/original_plane)
	if(z <= 0 || z_levels.len < z)
		return original_plane

	var/bottom_most_z = HasSubmapData(z) ? GetSubmapData(z).get_bottommost_z() : z
	return min(32767,((z - bottom_most_z)*PLANES_PER_Z_LEVEL) + original_plane)

/atom/proc/update_plane()	//Updates plane using local z-coordinate
	if(z > 0)
		plane = calculate_plane(z,original_plane)
	else
		plane = ABOVE_HUD_PLANE

/atom/proc/get_relative_plane(var/plane)
	return calculate_plane(z,plane)