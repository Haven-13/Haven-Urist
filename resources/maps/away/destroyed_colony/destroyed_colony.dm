#include "destroyed_colony_items.dm"

/area/planet/destroyed_colony
	name = "\improper Destroyed Colony"
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/obj/effect/overmap/sector/destroyed_colony
	name = "destroyed colony"
	desc = "A former Terran Confederation colony, any settlements on this world were destroyed during the Galactic Crisis. Little remains, but sensors are detecting a faint signal from a destroyed settlement."
	icon_state = "globe"
	known = 0
	in_space = 0
	initial_generic_waypoints = list(
		"nav_destroyed_colony_1",
		"nav_destroyed_colony_2"
		)

/obj/effect/overmap/sector/destroyed_colony/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/shuttle_landmark/nav_destroyed_colony/nav1
	name = "Planetary Navpoint #1"
	landmark_tag = "nav_destroyed_colony_1"
	base_area = /area/planet/destroyed_colony
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/obj/effect/shuttle_landmark/nav_destroyed_colony/nav2
	name = "Planetary Navpoint #2"
	landmark_tag = "nav_destroyed_colony_2"
	base_area = /area/planet/destroyed_colony
	base_turf = /turf/simulated/floor/planet/ariddirt/clear

/datum/map_template/ruin/away_site/destroyed_colony
	name = "Destroyed Colony"
	id = "awaysite_destroyed_colony"
	description = "A former Terran Confederation colony, any settlements on this world were destroyed during the Galactic Crisis. Little remains, but sensors are detecting a faint signal from a destroyed settlement."
	suffixes = list("destroyed_colony/destroyed_colony.dmm")
	accessibility_weight = 10
//	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/turf/simulated/floor/fixed/destroyedroad
	name = "road"
	desc = "It's a road. It's seen better days."
	icon = 'resources/icons/urist/turf/floorsplus.dmi'
	icon_state = ""

/turf/simulated/floor/fixed/destroyedroad/attackby(obj/item/C, mob/user)
	if(is_crowbar(C))
		to_chat(user, "<span class='notice'>There aren't any openings big enough to pry it away...</span>")
		return
	return ..()

/turf/simulated/floor/fixed/destroyedroad/ex_act(severity)
	return
//	if(severity == 1)
//		ChangeTurf(get_base_turf_by_area(src))
