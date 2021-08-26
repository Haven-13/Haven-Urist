//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	var/list/map_z = list()

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles
	var/docking_codes

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/base = 0		//starting sector, counts as station_levels
	var/known = 1		//shows up on nav computers automatically
	var/in_space = 1	//can be accessed via lucky EVA

/obj/effect/overmap/Initialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(!IS_OVERMAP_INITIALIZED)
		overmap_initialize()

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	if (start_x && start_y)
		GLOB.overmap_generator.place_overmap_item_at(src, start_x, start_y)
	else
		GLOB.overmap_generator.place_overmap_item(src)
	testing("Located sector \"[name]\" at [src.x],[src.y], containing Z [english_list(map_z)]")

	GLOB.using_map.player_levels |= map_z

	if(!in_space)
		GLOB.using_map.sealed_levels |= map_z

	if(base)
		GLOB.using_map.station_levels |= map_z
		GLOB.using_map.contact_levels |= map_z

	SSshuttle.initialize_sector(src) //Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.

	for(var/obj/machinery/computer/sensors/S in SSmachines.machinery)
		if (S.z in map_z)
			S.linked = src

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/effect/overmap/proc/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_name)
	landmark.sector_set(src)
	if(shuttle_name)
		LAZY_ADD(restricted_waypoints[shuttle_name], landmark)
	else
		generic_waypoints += landmark

/obj/effect/overmap/proc/get_waypoints(var/shuttle_name)
	. = generic_waypoints.Copy()
	if(shuttle_name in restricted_waypoints)
		. += restricted_waypoints[shuttle_name]

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

/obj/effect/overmap/sector/Initialize()
	. = ..()
	if(known)
		layer = ABOVE_LIGHTING_LAYER
		add_overlay(list(mutable_appearance(
			icon,
			icon_state,
			plane = get_float_plane(EMISSIVE_PLANE)
		)))
