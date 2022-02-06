//TEMPLE SHIT

//turf

/turf/unsimulated/floor/temple
	name = "temple floor"
	icon = 'resources/icons/urist/jungle/turfs.dmi'
	icon_state = "templefloor"

/turf/unsimulated/wall/temple
	name = "temple wall"
	icon = 'resources/icons/urist/jungle/turfs.dmi'
	icon_state = "templewall"

//false wall

/obj/structure/temple_falsewall
	name = "temple wall"
	anchored = 1
	icon = 'resources/icons/urist/jungle/turfs.dmi'
	icon_state = "templewall"
	opacity = 1
	var/opening = 0

/obj/structure/temple_falsewall/attack_hand(mob/user as mob)
	if(opening)
		return

	if(density)
		opening = 1
		to_chat(user, "<span class='notice'>You slide the heavy wall open.</span>")
		flick("templewall_opening", src)
		sleep(5)
		density = 0
		opacity = 0
		icon_state = "templewall_open"

/obj/structure/fountain
	name = "fountain"
	desc = "A fountain that appears to be spewing red water. Wait... Is that blood?"
	icon = 'resources/icons/urist/jungle/64x64.dmi'
	icon_state = "fountain"
