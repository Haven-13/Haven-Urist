//
//	PLANE MASTERS
//

/obj/screen/plane_master
	screen_loc = "CENTER,CENTER"
	icon_state = "blank"
	globalscreen = 1
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/obj/screen/plane_master/proc/update_screen_plane(z_level)
	if(initial(src.render_target))
		src.render_target = "[initial(src.render_target)]-[z_level]z"
	else
		src.render_target = "[src.plane]-[z_level]z"
	src.plane = calculate_plane(z_level, src.plane)

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/obj/screen/plane_master/proc/backdrop(mob/mymob)

/*
 *  I hate myself, I hate Baycode, I hate Byond
 *
 *  Welcome to the wonders of BYOND DM coding!
 *
 *  For multi_z rendering, take a look in _onclick/hud/hud.dm and _onclick/hud/map_view.dm
 *  For a list of what planes are included, take a look in
 *  __defines/_planes+layers.dm
 */

#define EMISSIVE_RENDER_TARGET "*emissive_render_target"
#define VISIBLE_GAME_WORLD_RENDER "*visible_game_world_render"

/obj/screen/plane_master/space_master
	plane = SPACE_PLANE

/obj/screen/plane_master/space_master/update_screen_plane(z_level)
	return

/obj/screen/plane_master/openspace_master
	plane = OPENSPACE_PLANE

/obj/screen/plane_master/below_turf_master
	plane = BELOW_TURF_PLANE

/obj/screen/plane_master/plating_plane_master
	plane = PLATING_PLANE

/obj/screen/plane_master/above_plating_master
	plane = ABOVE_PLATING_PLANE

/obj/screen/plane_master/turf_master
	plane = TURF_PLANE

/obj/screen/plane_master/above_turf_master
	plane = ABOVE_TURF_PLANE

/obj/screen/plane_master/under_obj_master
	plane = UNDER_OBJ_PLANE

/obj/screen/plane_master/hiding_mob_master
	plane = HIDING_MOB_PLANE

/obj/screen/plane_master/obj_plane_master
	plane = OBJ_PLANE

/obj/screen/plane_master/lying_mob_master
	plane = LYING_MOB_PLANE

/obj/screen/plane_master/lying_human_master
	plane = LYING_HUMAN_PLANE

/obj/screen/plane_master/above_obj_master
	plane = ABOVE_OBJ_PLANE

/obj/screen/plane_master/human_plane_master
	plane = HUMAN_PLANE

/obj/screen/plane_master/mob_plane_master
	plane = MOB_PLANE

/obj/screen/plane_master/above_human_master
	plane = ABOVE_HUMAN_PLANE

/obj/screen/plane_master/blob_plane_master
	plane = BLOB_PLANE

/obj/screen/plane_master/effects_below_lighting_master
	plane = EFFECTS_BELOW_LIGHTING_PLANE

/obj/screen/plane_master/observer_master
	plane = OBSERVER_PLANE

/obj/screen/plane_master/visible_game_world_plane_master
	plane = VISIBLE_GAME_WORLD_PLANE
	render_target = VISIBLE_GAME_WORLD_RENDER
	mouse_opacity = 0    // nothing on this plane is mouse-visible

/obj/screen/plane_master/visible_game_world_plane_master/update_screen_plane(z_level)
	..()
	update_composite(z_level)

/obj/screen/plane_master/visible_game_world_plane_master/proc/update_composite(z)
	for (var/plane in BELOW_TURF_PLANE to OBSERVER_PLANE)
		filters += filter(
			type="layer",
			render_source="[plane]-[z]z",
			blend_mode=BLEND_ADD
		)

/obj/screen/plane_master/lighting_plane
	name = "lighting plane master"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	mouse_opacity = 0    // nothing on this plane is mouse-visible

/obj/screen/plane_master/lighting_plane/update_screen_plane(z_level)
	..()
	update_masks(z_level)

/obj/screen/plane_master/lighting_plane/proc/update_masks(z)
	filters += filter(
		type="alpha",
		render_source="[VISIBLE_GAME_WORLD_RENDER]-[z]z"
	)
	filters += filter(
		type="alpha",
		render_source="[EMISSIVE_RENDER_TARGET]-[z]z",
		flags=MASK_INVERSE
	)

/*
/obj/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET

/obj/screen/plane_master/emissive/Initialize()
	. = ..()
	filters += filter(
		type="color",
		color=GLOB.em_mask_matrix
	)
*/

/obj/screen/plane_master/obscurity_master
	plane = OBSCURITY_PLANE

#undef VISIBLE_GAME_WORLD_RENDER
#undef EMISSIVE_RENDER_TARGET
