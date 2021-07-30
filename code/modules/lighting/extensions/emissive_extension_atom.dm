/atom/movable
  /// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
  var/blocks_emissive = FALSE
  ///Internal holder for emissive blocker object, do not use directly use blocks_emissive
  var/atom/movable/emissive_blocker/em_block

/atom/movable/Initialize(mapload)
	. = ..()
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			update_emissive_block()
		if(EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			vis_contents += em_block

/atom/movable/Destroy()
	QDEL_NULL(em_block)
	return ..()

/atom/movable/proc/update_emissive_block()
	if(blocks_emissive != EMISSIVE_BLOCK_GENERIC)
		return
	if(length(managed_vis_overlays))
		for(var/a in managed_vis_overlays)
			var/obj/effect/overlay/vis/vs
			if(vs.plane == EMISSIVE_BLOCKER_PLANE)
				SSvis_overlays.remove_vis_overlay(src, list(vs))
				break
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, EMISSIVE_BLOCKER_LAYER, EMISSIVE_BLOCKER_PLANE, dir)

/atom/movable/update_plane()
	. = ..()
	em_block?.update_plane()

/*
* If the overlay's plane is supposed to be overlayed (floating), use icon_plane
* If the overlay's plane is supposed to be fixed and not a float plane, use force_plane.
*
* One thumbrule is, float planes do not require calculations to update their planes. But if you
* want them fixated or use precalculated plane of yours, use force_plane.
*/
/atom/movable/proc/add_emissive_overlay(
	var/icon = src.icon,
	var/state = src.icon_state,
	var/layer = src.layer,
	var/icon_plane = src.original_plane,
	var/force_plane = null,
	var/dir = src.dir,
	var/no_block = FALSE
	)
	var/_plane = (force_plane || get_float_plane(icon_plane))
	var/_em_plane = get_float_plane((no_block && EMISSIVE_UNBLOCKABLE_PLANE) || EMISSIVE_PLANE)
	SSvis_overlays.add_vis_overlay(src, icon, state, layer, _plane, dir)
	SSvis_overlays.add_vis_overlay(src, icon, state, layer, _em_plane, dir)
