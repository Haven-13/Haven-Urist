// List of all planes that should be rendered to the HUD's
// handling of rendering multi-z
//
// Planes that are not included are:
// - LIGHTING_PLANE; blending cause the lighting overlay to be
//       almost invisible in multi-z. Undesired effect
/proc/multiz_rendering_planes()
	return list(
		DEFAULT_PLANE,
		EFFECTS_PLANE,
		VISIBLE_GAME_WORLD_PLANE,
		EMISSIVE_PLANE,
		OBSCURITY_PLANE
	)

/image/proc/plating_decal_layerise(atom/target)
	plane = target.get_float_plane(ABOVE_PLATING_PLANE)
	layer = DECAL_PLATING_LAYER

/image/proc/turf_decal_layerise(atom/target)
	plane = target.get_float_plane(ABOVE_TURF_PLANE)
	layer = DECAL_LAYER

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/atom/proc/reset_plane_and_layer()
	set_plane(initial(plane))
	layer = initial(layer)
