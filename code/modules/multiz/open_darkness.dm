/obj/screen/openspace_overlay
	screen_loc = "CENTER,CENTER"
	icon = 'icons/primitives.dmi'
	icon_state = "black"
//	appearance_flags = PLANE_MASTER
	plane = OPENSPACE_PLANE
	layer = OPENSPACE_DARKNESS_LAYER
	blend_mode = BLEND_MULTIPLY
	alpha = 255
	mouse_opacity = FALSE

/obj/screen/openspace_overlay/New()
	. = ..()
	src.transform = src.transform.Scale(32)
