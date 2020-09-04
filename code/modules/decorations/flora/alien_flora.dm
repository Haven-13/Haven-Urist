/obj/structure/flora/shimmering_orb
	name = "bioluminescent orb"
	desc = "A floating vaguely translucent orb, small cracks of bioluminescent growths within give off a calming light."
	icon = 'icons/urist/asteroidflora.dmi'
	icon_state = "shimmering_orb"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/flora/shimmering_orb/Initialize()
	. = ..()
	set_light(1, 3, 5, 2, "#0066ff")
