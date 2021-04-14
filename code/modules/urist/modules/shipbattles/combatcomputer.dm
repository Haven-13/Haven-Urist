/obj/machinery/computer/combatcomputer
	name = "weapons control computer"
	desc = "the control centre for the ship's weapons systems."
	anchored = 1
	var/list/linkedweapons = list() //put the weapons in here on their init
	var/shipid = null
	var/target = null
	var/obj/effect/overmap/ship/combat/homeship
	var/fallback_connect = FALSE

/obj/machinery/computer/combatcomputer/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	if(!fallback_connect) //sometimes connecting is fucky, so this is a fallback in case something fucks up somewhere along the line
		for(var/obj/machinery/shipweapons/S in SSmachines.machinery)
			if(!S.linkedcomputer && S.shipid == src.shipid)
				S.linkedcomputer = src
				linkedweapons += S

		for(var/obj/effect/overmap/ship/combat/C in GLOB.overmap_ships)
			if(C.shipid == src.shipid)
				homeship = C

		for(var/obj/machinery/shipweapons/S in linkedweapons)
			if(!S.homeship)
				S.homeship = homeship

		fallback_connect = TRUE

	ui_interact(user)

/obj/machinery/computer/combatcomputer/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "spacecraft/ShipCombatComputer", name)
		ui.open()

/obj/machinery/computer/combatcomputer/ui_data(mob/user)
	. = list()

	if(linkedweapons.len)
		var/list/weapons[0]
		for(var/obj/machinery/shipweapons/S in linkedweapons)
			weapons.Add(list(list(
			"name" = S.name,
			"status" = S.status,
			"strengthHull" = S.hulldamage,
			"strengthShield" = S.shielddamage,
			"shieldPass" = S.passshield,
			"location" = S.loc.loc.name,
			"ref" = REF(S)
			)))
			//maybe change passshield data to ammo?
			.["weapons"] = weapons

	if(target) //come back to this when making pvp
		var/mob/living/simple_animal/hostile/overmapship/OM = target
		var/list/targetcomponents[0]
		for(var/datum/shipcomponents/C in OM.components)
			var/status
			if(C.broken)
				status = "Broken"
			else if(!C.broken)
				status = "Operational"

			targetcomponents.Add(list(list(
			"name" = C.name,
			"status" = status,
			"targeted" = C.targeted,
			"ref" = REF(C)
			)))
		.["target"] = list(
			"name" = OM.name,
			"type" = OM.ship_category,
			"health" = OM.health,
			"maxHealth" = OM.maxHealth,
			"shields" = OM.shields,
			"maxShields" = initial(OM.shields),
			"components" = targetcomponents
		)
	else
		.["target"] = null

/obj/machinery/computer/combatcomputer/ui_act(action, list/params)
	if(..())
		return TRUE

	switch(action)
		if("fire")
			if(homeship?.incombat)
				var/obj/machinery/shipweapons/S = locate(params["fire"]) in linkedweapons
				if(S?.canfire)
					if(!istype(S))
						return
					if(S.charged && !S.firing)
						S.Fire()
						to_chat(usr, "<span class='warning'>You fire the [S.name].</span>")
				else
					to_chat(usr, "<span class='warning'>The [S.name] cannot be fired right now.</span>")
			else
				to_chat(usr, "<span class='warning'>You cannot fire right now.</span>")	//this shouldn't happen
		if("set_target")
			if(target)
				var/mob/living/simple_animal/hostile/overmapship/OM = target
				for(var/datum/shipcomponents/SC in OM.components)
					SC.targeted = FALSE

				var/datum/shipcomponents/C = locate(params["set_target"]) in OM.components
				C.targeted = TRUE

				for(var/obj/machinery/shipweapons/S in linkedweapons)
					S.targeted_component = C
		if("unset_target")
			for(var/obj/machinery/shipweapons/S in linkedweapons)
				S.targeted_component = null
			if(target)
				var/mob/living/simple_animal/hostile/overmapship/OM = target
				for(var/datum/shipcomponents/C in OM.components)
					C.targeted = FALSE
	return TRUE
