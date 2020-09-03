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

/atom/movable/proc/add_emissive_overlay(
  var/icon = src.icon,
  var/state = src.icon_state,
  var/layer = src.layer,
  var/icon_plane = src.plane,
  var/dir = src.dir)
  SSvis_overlays.add_vis_overlay(src, icon, state, layer, icon_plane, dir)
  SSvis_overlays.add_vis_overlay(src, icon, state, layer, EMISSIVE_PLANE, dir)
