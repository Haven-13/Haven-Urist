/atom/movable/screen/openspace_overlay
	screen_loc = "CENTER,CENTER"
	icon = 'icons/primitives.dmi'
	icon_state = "black"
	plane = DEFAULT_PLANE
	layer = OPEN_SPACE_LAYER
	blend_mode = BLEND_MULTIPLY
	alpha = 255
	mouse_opacity = FALSE

/atom/movable/screen/openspace_overlay/New()
	. = ..()
	src.transform = src.transform.Scale(32)
