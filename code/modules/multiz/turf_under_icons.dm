/turf
	var/is_transparent = FALSE

/turf/simulated/open
	is_transparent = TRUE

/turf/space
	is_transparent = TRUE

/proc/_update_multiz_icons(turf/source)
	var/turf/below = GetBelow(source)
	if (!below || (source.is_transparent && istype(below, /turf/space)))
		source.ChangeTurf(/turf/space)
		if(!below)
			return

	source.vis_contents.Cut()
	if (below)
		source.vis_contents.Add(below)

	source.update_openspace() //propagate update upwards

/turf/simulated/open/update_icon()
	_update_multiz_icons(src)

/turf/space/update_icon()
	_update_multiz_icons(src)

/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if (T && T.is_transparent)
		T.update_icon()

/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()

/turf/Exited(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()
