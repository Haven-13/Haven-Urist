var/image/white_background = _create_white_background()

/proc/_create_white_background()
	var/image/I = image('icons/primitives.dmi', icon_state = "white")
	I.plane = SPACE_PLANE
	return I

/turf
	var/is_transparent = FALSE

/turf/simulated/open
	is_transparent = TRUE

/turf/space
	is_transparent = TRUE

/proc/_update_multiz_icons(turf/source)
	var/turf/below = GetBelow(source)

	source.vis_contents.Cut()
	if(below)
		source.vis_contents.Add(below)

/turf/simulated/open/update_icon()
	_update_multiz_icons(src)

/turf/space/update_icon()
	_update_multiz_icons(src)
	if (!HasBelow(z))
		underlays.Cut()
		underlays |= white_background

/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if (T && T.is_transparent)
		T.update_icon()
