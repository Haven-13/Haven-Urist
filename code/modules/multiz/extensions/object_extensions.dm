/obj/machinery/computer/update_icon()
	. = ..()
	update_openspace()

/obj/machinery/door/update_icon()
	. = ..()
	update_openspace()

/obj/structure/closet/open()
	. = ..()
	update_openspace()

/obj/structure/closet/close()
	. = ..()
	update_openspace()

/obj/effect/bmode/update_plane()
	return

/obj/effect/shield/New()
	. = ..()
	update_openspace()
