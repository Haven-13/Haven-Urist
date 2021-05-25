#include "noctis_areas.dm"
#include "noctis_jobs.dm"
#include "noctis_shuttle.dm"

/obj/effect/submap_landmark/joinable_submap/noctis
	name = "UXO Noctis"
	archetype = /decl/submap_archetype/derelict/noctis

/decl/submap_archetype/derelict/noctis
	descriptor = "derelict"
	map = "Pirate Ship"
	crew_jobs = list(
		/datum/job/submap/noctis_crew
	)

/datum/map_template/ruin/away_site/pirate_ship
	name = "Pirate Ship"
	id = "awaysite_pirate_ship"
	description = "An exploration vessel taken over by pirates."
	suffixes = list("noctis/noctis-1.dmm", "noctis/noctis-2.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/raptor)

/obj/effect/overmap/ship/noctis
	name = "exploration corvette"
	color = "#640000"
	vessel_mass = 40
	default_delay = 15 SECONDS
	speed_mod = 0.1 MINUTE
	burn_delay = 2 SECONDS
	initial_restricted_waypoints = list(
		"Raptor" = list("nav_noctis_raptor")
	)

/obj/effect/overmap/ship/noctis/New()
	name = "UXO [pick("Khan's Blade", "Liberator", "Serpentine", "Arachnophobia","Sailor's Delight","NULL")]"
	for(var/area/noctis/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	name = "[name], \an [initial(name)]"
	..()

/obj/effect/floor_decal/borderfloorgrey
	name = "border floor"
	icon_state = "borderfloor_white"
	color = "#8d8c8c"

/obj/effect/floor_decal/borderfloorgrey/corner
	icon_state = "borderfloorcorner_white"

/obj/effect/floor_decal/borderfloorgrey/corner2
	icon_state = "borderfloorcorner2_white"

/obj/effect/floor_decal/borderfloorgrey/full
	icon_state = "borderfloorfull_white"

/obj/effect/floor_decal/borderfloorgrey/cee
	icon_state = "borderfloorcee_white"

/obj/effect/paint/green_grey
	color = "#8daf6a"

/obj/structure/closet/secure_closet/engineering_electrical/noctis
	req_access = access_noctis

/obj/structure/closet/secure_closet/engineering_electrical/noctis/WillContain()
	return list(
		/obj/item/clothing/gloves/insulated = 1,
		/obj/item/stack/cable_coil/blue = 3,
		/obj/item/weapon/wirecutters = 2,
		/obj/item/frame/apc = 2,
		/obj/item/weapon/module/power_control = 2,
		/obj/item/device/multitool = 2
	)

/obj/structure/closet/secure_closet/engineering_welding/noctis
	req_access = access_noctis

/obj/structure/closet/secure_closet/engineering_welding/noctis/WillContain()
	return list(
		/obj/item/clothing/head/welding/carp = 1,
		/obj/item/clothing/head/welding/fancy = 1,
		/obj/item/weapon/weldingtool = 1,
		/obj/item/weapon/weldingtool/experimental = 1,
		/obj/item/weapon/weldpack = 1,
		/obj/item/weapon/welder_tank = 3
	)

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet-silver"
	default_type = "titanium"
	apply_colour = 1
