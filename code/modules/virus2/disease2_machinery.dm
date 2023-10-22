/obj/machinery/disease2/attackby(obj/O as obj, mob/user as mob)
	if(default_deconstruction_crowbar(user, O))
		return
	else if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_part_replacement(user,O))
		return
	. = ..()