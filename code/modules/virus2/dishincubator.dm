/obj/machinery/disease2/incubator/
	name = "pathogenic incubator"
	density = 1
	anchored = 1
	icon = 'resources/icons/obj/virology.dmi'
	icon_state = "incubator"
	var/obj/item/weapon/virusdish/dish
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/radiation = 0

	var/on = 0
	var/power = 0

	var/foodsupply = 0
	var/toxins = 0

/obj/machinery/disease2/incubator/Initialize()
	build_default_parts(/obj/item/weapon/circuitboard/incubator)
	. = ..()

/obj/machinery/disease2/incubator/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/syringe))

		if(beaker)
			to_chat(user, "\The [src] is already loaded.")
			return
		if(!user.unEquip(O, src))
			return
		beaker = O

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SStgui.update_uis(src)

		src.attack_hand(user)
		return

	if(istype(O, /obj/item/weapon/virusdish))

		if(dish)
			to_chat(user, "The dish tray is aleady full!")
			return
		if(!user.unEquip(O, src))
			return
		dish = O

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SStgui.update_uis(src)

		src.attack_hand(user)

	else
		. = ..()

/obj/machinery/disease2/incubator/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	return ..()

/obj/machinery/disease2/incubator/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "virology/PathogenicIncubator", name)
		ui.open()

/obj/machinery/disease2/incubator/ui_static_data(mob/user)
	. = list(
		"minFood" = 0,
		"maxFood" = 100,
		"minRadiation" = 0,
		"maxRadiation" = 100,
		"minToxins" = 0,
		"maxToxins" = 100,
		"minGrowth" = 0,
		"maxGrowth" = 100
	)

/obj/machinery/disease2/incubator/ui_data(mob/user)
	. = list(
		"chemicalsInserted" = !!beaker,
		"dishInserted" = !!dish,
		"foodSupply" = foodsupply,
		"radiation" = radiation,
		"toxins" = min(toxins, 100),
		"on" = on,
		"systemInUse" = foodsupply > 0 || radiation > 0 || toxins > 0,
		"chemicalVolume" = beaker ? beaker.reagents.total_volume : 0,
		"maxChemicalVolume" = beaker ? beaker.volume : 1,
		"virus" = dish ? dish.virus2.name() : null,
		"growth" = dish ? min(dish.growth, 100) : 0,
		"infectionRate" = dish && dish.virus2 ? dish.virus2.infectionchance : 0,
		"analysed" = dish && dish.analysed ? 1 : 0
	)

/obj/machinery/disease2/incubator/ui_act(action, list/params)
	switch(action)
		if ("eject_chem")
			if(beaker)
				beaker.dropInto(loc)
				beaker = null
			return TRUE

		if ("power")
			if (dish)
				on = !on
				icon_state = on ? "incubator_on" : "incubator"
			return TRUE

		if ("eject_dish")
			if(dish)
				dish.dropInto(loc)
				dish = null
			return TRUE

		if ("rad")
			radiation = min(100, radiation + 10)
			return TRUE

		if ("flush")
			radiation = 0
			toxins = 0
			foodsupply = 0
			return TRUE

/obj/machinery/disease2/incubator/Process()
	if(dish && on && dish.virus2)
		use_power(50,EQUIP)
		if(!powered(EQUIP))
			on = 0
			icon_state = "incubator"

		if(foodsupply)
			if(dish.growth + 3 >= 100 && dish.growth < 100)
				ping("\The [src] pings, \"Sufficient viral growth density achieved.\"")

			foodsupply -= 1
			dish.growth += 3
			SStgui.update_uis(src)

		if(radiation)
			if(radiation > 50 & prob(5))
				dish.virus2.majormutate()
				if(dish.info)
					dish.info = "OUTDATED : [dish.info]"
					dish.basic_info = "OUTDATED: [dish.basic_info]"
					dish.analysed = 0
				ping("\The [src] pings, \"Mutant viral strain detected.\"")
			else if(prob(5))
				dish.virus2.minormutate()
			radiation -= 1
			SStgui.update_uis(src)
		if(toxins && prob(5))
			dish.virus2.infectionchance -= 1
			SStgui.update_uis(src)
		if(toxins > 50)
			dish.growth = 0
			dish.virus2 = null
			SStgui.update_uis(src)
	else if(!dish)
		on = 0
		icon_state = "incubator"
		SStgui.update_uis(src)

	if(beaker)
		if (foodsupply < 100 && beaker.reagents.has_reagent(/datum/reagent/nutriment/virus_food))
			var/food_needed = min(10, 100 - foodsupply) / 2
			var/food_taken = min(food_needed, beaker.reagents.get_reagent_amount(/datum/reagent/nutriment/virus_food))

			beaker.reagents.remove_reagent(/datum/reagent/nutriment/virus_food, food_taken)
			foodsupply = min(100, foodsupply+(food_taken * 2))
			SStgui.update_uis(src)

		if (locate(/datum/reagent/toxin) in beaker.reagents.reagent_list && toxins < 100)
			for(var/datum/reagent/toxin/T in beaker.reagents.reagent_list)
				toxins += max(T.strength,1)
				beaker.reagents.remove_reagent(T.type,1)
				if(toxins > 100)
					toxins = 100
					break
			SStgui.update_uis(src)
