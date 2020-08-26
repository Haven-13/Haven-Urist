/*
  PLANE MASTERS
*/

/obj/screen/plane_master
	screen_loc = "CENTER,CENTER"
	icon_state = "blank"
	globalscreen = 1
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/obj/screen/plane_master/proc/backdrop(mob/mymob)

/obj/screen/plane_master/ghost_master
	plane = OBSERVER_PLANE

/obj/screen/plane_master/ghost_dummy
	// this avoids a bug which means plane masters which have nothing to control get angry and mess with the other plane masters out of spite
	alpha = 0
	appearance_flags = 0
	plane = OBSERVER_PLANE

GLOBAL_LIST_INIT(ghost_master, list(
	new /obj/screen/plane_master/ghost_master(),
	new /obj/screen/plane_master/ghost_dummy()
))

/obj/screen/plane_master/lighting_plane
	name = "lighting plane master"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	mouse_opacity = 0    // nothing on this plane is mouse-visible
	
	
	// use 20% ambient lighting; be sure to add full alpha
	color = list(
			-1, 00, 00, 00,
			00, -1, 00, 00,
			00, 00, -1, 00,
			00, 00, 00, 00,
			01, 01, 01, 01
		)
