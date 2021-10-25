//
//	PLANE MASTERS
//

/atom/movable/screen/plane_master
	screen_loc = "CENTER,CENTER"
	icon_state = "blank"
	globalscreen = 1
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/atom/movable/screen/plane_master/proc/update_screen_plane(z_level)
	if(initial(src.render_target))
		src.render_target = "[initial(src.render_target)]-[z_level]z"
	else
		src.render_target = "[src.plane]-[z_level]z"
	src.plane = calculate_plane(z_level, src.plane)

/atom/movable/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/atom/movable/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/atom/movable/screen/plane_master/proc/backdrop(client/C)

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

/atom/movable/screen/plane_master/space_master
	plane = SPACE_PLANE

/atom/movable/screen/plane_master/space_master/update_screen_plane(z_level)
	return

/atom/movable/screen/plane_master/default_master
	plane = DEFAULT_PLANE

/atom/movable/screen/plane_master/effects_master
	plane = EFFECTS_PLANE

/atom/movable/screen/plane_master/visible_game_world_plane_master
	plane = VISIBLE_GAME_WORLD_PLANE
	render_target = VISIBLE_GAME_WORLD_RENDER
	mouse_opacity = 0    // nothing on this plane is mouse-visible

/atom/movable/screen/plane_master/visible_game_world_plane_master/update_screen_plane(z_level)
	..()
	update_composite(z_level)

/atom/movable/screen/plane_master/visible_game_world_plane_master/proc/update_composite(z)
	for (var/plane in DEFAULT_PLANE to EFFECTS_PLANE)
		filters += filter(
			type="layer",
			render_source="[plane]-[z]z",
			blend_mode=BLEND_ADD
		)

/atom/movable/screen/plane_master/lighting_plane
	name = "lighting plane master"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	mouse_opacity = 0    // nothing on this plane is mouse-visible

/atom/movable/screen/plane_master/lighting_plane/update_screen_plane(z_level)
	..()
	update_masks(z_level)

/atom/movable/screen/plane_master/lighting_plane/proc/update_masks(z)
	filters += filter(
		type="alpha",
		render_source="[VISIBLE_GAME_WORLD_RENDER]-[z]z"
	)
	filters += filter(
		type="alpha",
		render_source="[EMISSIVE_RENDER_TARGET]-[z]z",
		flags=MASK_INVERSE
	)

/atom/movable/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET

/atom/movable/screen/plane_master/emissive/Initialize()
	. = ..()
	filters += filter(
		type="color",
		color=GLOB.em_mask_matrix
	)

/atom/movable/screen/plane_master/obscurity_master
	plane = OBSCURITY_PLANE

#undef VISIBLE_GAME_WORLD_RENDER
#undef EMISSIVE_RENDER_TARGET
