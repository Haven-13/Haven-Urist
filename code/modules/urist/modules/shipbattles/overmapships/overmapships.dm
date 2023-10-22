/area/boarding_ship
	name = "Ship - Boarding"
	icon_state = "away"
	requires_power = 0

/mob/living/simple_animal/hostile/overmapship //maybe do components as objects instead of datums
//	var/shipdatum = /datum/ships
	var/shields
	var/max_shields
	var/firedelay = 100
	var/designation = "FFS"
	var/ship_category = "debug ship"
	icon = 'resources/icons/obj/overmap.dmi'
	icon_state = "ship"
	icon_living = "ship"
	icon_dead = "ship"
	var/moving_direction
	var/moving_state = "ship_moving"
	var/boardingmap = "maps/shipmaps/ship_blank.dmm"
	var/list/components = list()
	var/list/weapons = list()
	var/incombat = 0
	var/aggressive = 0 //will always attack
	var/obj/effect/overmap/ship/combat/target_ship
	var/obj/effect/overmap/sector/station/home_station
	min_gas = null
	max_gas = null
	minbodytemp = 0
	autonomous = TRUE
	var/dying = FALSE //are we dying?
	var/event = 0 //are we part of an event
	var/boarding = FALSE //are we being boarded
	var/can_board = FALSE //can we be boarded
	var/map_spawned = FALSE //have we spawned our boardingmap
	turns_per_move = 10 //this is now determined by the engine component
	var/potential_weapons = list()
	var/boarders_amount = 0 //how many human boarders can we have?

/mob/living/simple_animal/hostile/overmapship/Destroy()
	QDEL_NULL_LIST(components)
	QDEL_NULL_LIST(weapons)
	home_station = null
	target_ship = null
	. = ..()

/mob/living/simple_animal/hostile/overmapship/Initialize()
	.=..()

	update_ship_components()

	name = ship_category //once i get names, flesh this out
	faction = "neutral" //come back to this
	shields = max_shields

/mob/living/simple_animal/hostile/overmapship/proc/update_ship_components()
	max_shields = 0
	turns_per_move = 0

	for(var/datum/shipcomponents/C in src.components)
		C.mastership = src

		if(istype(C, /datum/shipcomponents/weapons))
			weapons += C

		if(istype(C, /datum/shipcomponents/shield))
			var/datum/shipcomponents/shield/S = C
			max_shields += S.strength

		if(istype(C, /datum/shipcomponents/engines))
			var/datum/shipcomponents/engines/E = C
			turns_per_move = E.turns_per_move

/mob/living/simple_animal/hostile/overmapship/Allow_Spacemove(check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/overmapship/Crossed(O as obj)
	..()

	if(!event)

		if(istype(O, /obj/effect/overmap/ship/combat))
			var/obj/effect/overmap/ship/combat/L = O
			if(L.canfight)
				if(!L.incombat && !L.crossed)
					L.Contact(src)

				else
					return


/mob/living/simple_animal/hostile/overmapship/Life() //here we do the attacking stuff. i hate that this is life, but fuck.
	if(incombat)
		for(var/datum/shipcomponents/M in src.components)
			if(M.broken)
				return
			else
				M.DoActivate()

	..()

/mob/living/simple_animal/hostile/overmapship/handle_automated_movement()
	if(!turns_since_move)
		moving_direction = pick(GLOB.cardinal)
		icon_state = moving_state
		set_dir(moving_direction)
	turns_since_move++
	if(turns_since_move >= turns_per_move)
		DoMove(moving_direction, src)
		icon_state = icon_living
		turns_since_move = 0

/mob/living/simple_animal/hostile/overmapship/proc/spawnmap()
	if(target_ship == GLOB.using_map.overmap_ship && boardingmap)
		for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
			S.mapfile = src.boardingmap
			S.Load()
			src.map_spawned = TRUE
			if(home_station && !home_station.known)
				for(var/obj/effect/urist/triggers/station_disk/D in GLOB.trigger_landmarks)
					if(D.faction_id == hiddenfaction.factionid)
						D.spawn_disk(home_station)
		return

/mob/living/simple_animal/hostile/overmapship/proc/despawnmap()
	if(target_ship == GLOB.using_map.overmap_ship)
		for(var/obj/effect/template_loader/ships/S in GLOB.trigger_landmarks) //there can only ever be one of these atm
			S.mapfile = "maps/shipmaps/ship_blank.dmm"
			S.Load()
		return

/mob/living/simple_animal/hostile/overmapship/death() //move shipdeath to this proc
	return

/mob/living/simple_animal/hostile/overmapship/proc/shipdeath()
	if(dying)
		return

	else
		dying = TRUE

		if(GLOB.using_map.using_new_cargo)
			GLOB.using_map.destroyed_ships += 1

			for(var/datum/contract/shiphunt/A in GLOB.using_map.contracts)
				if(A.neg_faction == src.hiddenfaction)
					A.Complete(1)

		if(home_station)
//			home_station.spawned_ships -= src
			home_station.ship_amount -= 1

		for(var/datum/shipcomponents/S in src.components)
			S.broken = TRUE

		despawnmap()

		target_ship.autoannounce(
			"<b>The attacking [src.ship_category] has been destroyed.</b>",
			COMBAT_CHANNEL_PUBLIC
		)
		target_ship.leave_combat()

		spawn(30)
			adjustBruteLoss(maxHealth)
			qdel(src)

/mob/living/simple_animal/hostile/overmapship/proc/boarded()
	if(!boarding)
		boarding = TRUE

		if(target_ship == GLOB.using_map.overmap_ship) //currently only the main ship can board, pending a rewrite of boarding code
			target_ship.autoannounce(
				"<b>The attacking [src.ship_category] is now able to be boarded via teleporter. Please await further instructions from Command.</b>",
				COMBAT_CHANNEL_PUBLIC
			) //add name+designation if I get lists for that stuff

			for(var/obj/effect/urist/triggers/boarding_landmark/L in GLOB.trigger_landmarks)
				new /obj/item/device/radio/beacon(L.loc)

			for(var/obj/effect/urist/triggers/shipweapons/S in GLOB.trigger_landmarks)
				var/datum/shipcomponents/weapons/W = pick(weapons)
				new W.weapon_type(S.loc)
				qdel(S)

			for(var/obj/effect/urist/triggers/ai_defender_landmark/A in GLOB.trigger_landmarks)
				A.spawn_mobs()

			communicate(/decl/communication_channel/dsay, GLOB.global_announcer, "<b>Ghosts can now join as a hostile boarder using the verb under the IC tab. You have one minute to join.</b>", /decl/dsay_communication/direct)

			spawn(1 MINUTE)
				boarders_amount = 0 //after a minute we null out the amount of boarders so noone joins mid boarding action.

//	for(var/mob/observer/ghost/G in GLOB.player_list)
//		if(G.client)
//			G.shipdefender_spawn(src.hiddenfaction)

/mob/living/simple_animal/hostile/overmapship/proc/add_weapons()
	var/datum/shipcomponents/weapons/W = pick(potential_weapons)
	components += new W
