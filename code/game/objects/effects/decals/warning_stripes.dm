/obj/effect/decal/warning_stripes
	icon = 'resources/icons/effects/warning_stripes.dmi'

/obj/effect/decal/warning_stripes/Initialize()
	. = ..()
	var/turf/T=get_turf(src)
	var/image/I=image(icon, icon_state = icon_state, dir = dir)
	I.color=color
	I.plane = DEFAULT_PLANE
	I.layer = TURF_DECAL_LAYER
	T.overlays += I
	return INITIALIZE_HINT_QDEL
