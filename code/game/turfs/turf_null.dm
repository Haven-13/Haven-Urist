/turf/null
	icon = null
	icon_state = null
	simulated = FALSE
	density = 0
	opacity = 1
	luminosity = 0
	dynamic_lighting = FALSE

/turf/null/New()
	return

/turf/null/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	atom_flags |= ATOM_FLAG_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/turf/null/Destroy()
	return ..()

/turf/null/set_luminosity(value)
	return
