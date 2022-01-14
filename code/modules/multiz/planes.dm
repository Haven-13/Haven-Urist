#define PLANES_PER_Z_LEVEL PLANE_DIFFERENCE

/atom
	var/original_plane = null

/atom/proc/init_plane()	//Set initial original plane
	if(!original_plane)
		original_plane = plane

/atom/proc/set_plane(new_plane)	//Changes plane
	original_plane = new_plane
	update_plane()

/proc/calculate_plane(z, original_plane)
	if(z <= 0 || z > world.maxz)
		return original_plane

	var/bottom_most_z = HasSubmapData(z) ? GetSubmapData(z).get_bottommost_z() : z
	return calculate_plane_by_depth(z - bottom_most_z, original_plane)

/proc/calculate_plane_by_depth(z_depth, original)
	return min(MAX_PLANE,(max(0, z_depth)*PLANES_PER_Z_LEVEL) + original)

/atom/proc/update_plane(override_z = 0)	//Updates plane using local z-coordinate
	var/_z = (override_z || z)
	if(_z > 0)
		plane = calculate_plane(_z, original_plane)
	else
		plane = ABOVE_HUD_PLANE

// Should be used for objects and base icons
// For non-absolute or cached overlays, use get_float_plane
/atom/proc/get_relative_plane(plane)
	return calculate_plane(z,plane)

// Should be used for overlays, specially cached ones
// For atoms, use get_relative_plane
/atom/proc/get_float_plane(plane)
	return FLOAT_PLANE + (plane - original_plane)
