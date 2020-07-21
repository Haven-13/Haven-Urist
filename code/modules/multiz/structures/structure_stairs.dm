/*
 * Stairs spawner, see the old structures.dm file one folder down for older
 * version of the object
 */
/obj/structure/stairs
  name = "stairs"
  desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
  icon = 'icons/obj/stairs.dmi'
  density = 0
  opacity = 0
  anchored = 1
  plane = ABOVE_TURF_PLANE
  layer = RUNE_LAYER

/obj/structure/stairs/Initialize()
  for(var/turf/turf in locs)
    var/turf/simulated/open/above = GetAbove(turf)
    if(!above)
      warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
      return INITIALIZE_HINT_QDEL
    if(!istype(above))
      above.ChangeTurf(/turf/simulated/open)
  spawn_stair_pieces()
  return INITIALIZE_HINT_QDEL

/obj/structure/stairs/proc/spawn_stair_pieces()
  // activate tile, assinged to A
  var/obj/structure/multiz/stairs/activate/A = new (src.loc)
  A.dir = src.dir

  // entry tile, assigned to E
  var/obj/structure/multiz/stairs/entry/E = new ((src.locs - src.loc)[1])
  E.dir = src.dir

// type paths to make mapping easier.
/obj/structure/stairs/north
  dir = NORTH
  bound_height = 64
  bound_y = -32
  pixel_y = -32

/obj/structure/stairs/south
  dir = SOUTH
  bound_height = 64

/obj/structure/stairs/east
  dir = EAST
  bound_width = 64
  bound_x = -32
  pixel_x = -32

/obj/structure/stairs/west
  dir = WEST
  bound_width = 64

/*
 * Single-tile version of stairs. CEV Eris style
 *
 * Don't use them for mapping. Instead, use the
 * /obj/structure/stairs
 */
/obj/structure/multiz/stairs
  name = "stairs"
  desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
  icon = 'icons/obj/stairs_32.dmi'
  density = 0
  opacity = 0
  anchored = 1
  plane = ABOVE_TURF_PLANE
  layer = RUNE_LAYER

/obj/structure/multiz/stairs/CanPass(obj/mover, turf/source, height, airflow)
  return airflow || !density

/obj/structure/multiz/stairs/entry
  icon_state = "entry"

/obj/structure/multiz/stairs/activate
  icon_state = "activator"
  density = 0

/obj/structure/stairs/activate/Bumped(atom/movable/A)
  var/turf/source = A.loc
  if (!locate(/obj/structure/multiz/stairs/entry) in source)
    return

  var/turf/above = GetAbove(A)
  var/turf/target = get_step(above, dir)
  if(above.CanZPass(source, UP) && target.Enter(A, src))
    A.forceMove(target)
    if(isliving(A))
      var/mob/living/L = A
      if(L.pulling)
        L.pulling.forceMove(target)
  else
    to_chat(A, "<span class='warning'>Something blocks the path.</span>")
