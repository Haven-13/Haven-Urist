//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle
	name = "tree"
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle/variant1
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree2"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle/variant2
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree3"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle/variant3
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree4"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle/variant4
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree5"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle/variant5
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree6"
	pixel_x = -45
	pixel_y = -16

/obj/structure/flora/tree/jungle_small
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree"
	pixel_x = -30
	pixel_y = -16

/obj/structure/flora/tree/jungle_small/variant1
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree2"
	pixel_x = -30
	pixel_y = -16

/obj/structure/flora/tree/jungle_small/variant2
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree3"
	pixel_x = -30
	pixel_y = -16

/obj/structure/flora/tree/jungle_small/variant3
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree4"
	pixel_x = -30
	pixel_y = -16

/obj/structure/flora/tree/jungle_small/variant4
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree5"
	pixel_x = -30
	pixel_y = -16

/obj/structure/flora/tree/jungle_small/variant5
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree6"
	pixel_x = -30
	pixel_y = -16
