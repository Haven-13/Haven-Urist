/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'resources/icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	plane = DEFAULT_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'resources/icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	plane = DEFAULT_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'resources/icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'resources/icons/turf/space.dmi'
	icon_state = "bluespacify"
	plane = EMISSIVE_PLANE
	layer = EMISSIVE_UNBLOCKABLE_LAYER

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'resources/icons/effects/wallrot.dmi'
	anchored = 1
	density = 1
	plane = DEFAULT_PLANE
	layer = ABOVE_TURF_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)
