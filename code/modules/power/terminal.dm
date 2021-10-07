// the underfloor wiring terminal for the APC
// autogenerated when an APC is placed
// all conduit connects go to this object instead of the APC
// using this solves the problem of having the APC in a wall yet also inside an area

/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "It's an underfloor wiring terminal for power equipment."
	level = 1
	plane = DEFAULT_PLANE
	layer = EXPOSED_TERMINAL_LAYER
	var/obj/machinery/power/master = null
	anchored = 1


/obj/machinery/power/terminal/New()
	..()
	var/turf/T = src.loc
	if(level==1) hide(!T.is_plating())
	return

/obj/machinery/power/terminal/Destroy()
	if(master)
		master.disconnect_terminal(src)
		master = null
	return ..()

/obj/machinery/power/terminal/hide(var/do_hide)
	if(do_hide && level == 1)
		plane = DEFAULT_PLANE
		layer = TERMINAL_LAYER
	else
		reset_plane_and_layer()

// Needed so terminals are not removed from machines list.
// Powernet rebuilds need this to work properly.
/obj/machinery/power/terminal/Process()
	return 1
