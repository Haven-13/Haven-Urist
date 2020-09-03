var/const/emissive_render_target = "*emissive_render_target"
var/const/emissive_blocker_render_target = "*emissive_blocker_render_target"

/obj/screen/plane_master/emissive
  name = "emissive plane master"
  plane = EMISSIVE_PLANE
  mouse_opacity = MOUSE_OPACITY_TRANSPARENT
  render_target = emissive_render_target

/obj/screen/plane_master/emissive/Initialize()
  . = ..()
  filters += filter(type="alpha", render_source=emissive_blocker_render_target, flags=MASK_INVERSE)

/obj/screen/plane_master/emissive_blocker
  name = "emissive blocker plane master"
  plane = EMISSIVE_BLOCKER_PLANE
  mouse_opacity = MOUSE_OPACITY_TRANSPARENT
  render_target = emissive_blocker_render_target
