/turf/space/update_plane()
	return

/turf/space/set_plane(new_plane)
	plane = new_plane

// override to make sure nothing is hidden
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_NORMAL)
		update_icon()
