/area
	base_turf = /turf/simulated/open

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/open_space.dmi'
	icon_state = "black_open"
	plane = DEFAULT_PLANE
	layer = OPEN_SPACE_LAYER
	blend_mode = BLEND_OVERLAY
	luminosity = 1
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/Initialize()
	. = ..()
	icon = null
	icon_state = "blank"
	update()

/turf/simulated/open/proc/update()
	below = GetBelow(src)
	GLOB.turf_changed_event.register(below, src,/turf/simulated/open/proc/turf_change)
	GLOB.exited_event.register(below, src, /turf/simulated/open/proc/handle_move)
	GLOB.entered_event.register(below, src, /turf/simulated/open/proc/handle_move)
	levelupdate()
	fall_check()
	update_icon()

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(atom/movable/AM, atom/OL)
	. = ..()
	if(AM)
		AM.fall()

/turf/simulated/open/Exited(atom/O)
	. = ..()
	if(!O || QDELETED(O) || QDELING(O))
		fall_check()

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM, var/speed)
	. = ..()
	AM.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	if(..(user, 2))
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

/turf/simulated/open/set_luminosity(value)
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1

/turf/simulated/open/proc/fall_check()
	var/area/A = get_area(src)
	if(HasBelow(z) && A.has_gravity()) // O(n) can get expensive, so it'd be nice to check the gravity first
		for(var/atom/movable/AM in src)
			AM.fall()

/turf/simulated/open/proc/handle_move(var/atom/current_loc, var/atom/movable/am, var/atom/changed_loc)
	//Check for mobs and create/destroy their shadows
	if(isliving(am))
		var/mob/living/M = am
		M.check_shadow()

/turf/simulated/open/proc/clean_up()
	vis_contents.Cut()
	//Unregister
	GLOB.turf_changed_event.unregister(below, src,/turf/simulated/open/proc/turf_change)
	GLOB.exited_event.unregister(below, src, /turf/simulated/open/proc/handle_move)
	GLOB.entered_event.unregister(below, src, /turf/simulated/open/proc/handle_move)
	//Take care of shadow
	for(var/mob/zshadow/M in src)
		qdel(M)

//When turf changes, a bunch of things can take place
/turf/simulated/open/proc/turf_change(var/turf/affected)
	update_icon()

//The two situations which require unregistering

/turf/simulated/open/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	//We do not want to change any of the behaviour, just make sure this goes away
	src.clean_up()
	. = ..()

/turf/simulated/open/Destroy()
	src.clean_up()
	. = ..()
