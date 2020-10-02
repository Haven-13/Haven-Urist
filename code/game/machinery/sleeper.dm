/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Soporific" = /datum/reagent/soporific, "Paracetamol" = /datum/reagent/paracetamol, "Dylovene" = /datum/reagent/dylovene, "Dexalin" = /datum/reagent/dexalin)
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/pump
	var/list/stasis_settings = list(1, 2, 5)
	var/stasis = 1
	var/max_amount = 20

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/Initialize()
	. = ..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	component_parts += beaker
	build_default_parts(/obj/item/weapon/circuitboard/sleeper)
	update_icon()

/obj/machinery/sleeper/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()
	if(pump > 0)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				for(var/datum/reagent/x in occupant.ingested.reagent_list)
					occupant.ingested.trans_to_obj(beaker, 3)
		else
			toggle_pump()

	if(iscarbon(occupant) && stasis > 1)
		occupant.SetStasis(stasis)

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/ui_state(mob/user)
	return ui_not_contained_state()

/obj/machinery/sleeper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper")
		ui.open()

/obj/machinery/sleeper/ui_data(mob/user)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["name"] = T
		if(occupant && occupant.reagents)
			reagent["amount"] = occupant.reagents.get_reagent_amount(available_chemicals[T])
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		var/scan = medical_scan_results(occupant)
		scan = replacetext(scan,"'notice'","'white'")
		scan = replacetext(scan,"'warning'","'average'")
		scan = replacetext(scan,"'danger'","'bad'")
		data["occupant"] =scan
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering
	data["pump"] = pump
	data["stasis"] = stasis

	return data

/obj/machinery/sleeper/CanUseTopic(user)
	if(user == occupant)
		to_chat(usr, "<span class='warning'>You can't reach the controls from the inside.</span>")
		return UI_CLOSE
	. = ..()

/obj/machinery/sleeper/ui_act(action, list/params)
	switch(action)
		if("eject")
			go_out()
			return TRUE
		if("beaker")
			remove_beaker()
			return TRUE
		if("filter")
			toggle_filter()
			return TRUE
		if("pump")
			toggle_pump()
			return TRUE
		if("chemical")
			if(params["amount"] && occupant && occupant.stat != DEAD)
				if(params["chemical"] in available_chemicals)
					inject_chemical(usr, params["chemical"], text2num(params["amount"]))
					return TRUE
		if("stasis")
			var/nstasis = text2num(params["stasis"])
			if(stasis != nstasis && nstasis in stasis_settings)
				stasis = text2num(params["stasis"])
				return TRUE

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		add_fingerprint(user)
		if(!beaker)
			if(!user.unEquip(I, src))
				return
			beaker = I
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has a beaker already.</span>")
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	else if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_part_replacement(user,I))
		return
	else
		..()

/obj/machinery/sleeper/RefreshParts()
	var/obj/item/weapon/stock_parts/matter_bin/M = locate() in component_parts
	max_amount = M.rating * 20
	var/techlevel
	for(var/obj/item/weapon/stock_parts/manipulator/MN in component_parts)
		techlevel += MN.rating
	if(techlevel >= 3)
		available_chemicals |= list("Antidexafin" = /datum/reagent/antidexafen)
	if(techlevel >= 4)
		available_chemicals |= list("Ethylredoxrazine" = /datum/reagent/ethylredoxrazine)

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	to_chat(occupant, "<span class='warning'>You feel like your blood is being sucked away.</span>")
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pump = 0
		return
	to_chat(occupant, "<span class='warning'>You feel a tube jammed down your throat.</span>")
	pump = !pump

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		update_use_power(2)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	occupant = null

	for(var/obj/O in (contents - component_parts)) // In case an object was dropped inside or something. Excludes the beaker and component parts.
		if(O == beaker)
			continue
		O.dropInto(loc)
	update_use_power(1)
	update_icon()
	toggle_filter()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.dropInto(loc)
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical_name, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	var/chemical_type = available_chemicals[chemical_name]
	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical_type) + amount <= max_amount)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical_type, amount)
			to_chat(user, "Occupant now has [occupant.reagents.get_reagent_amount(chemical_type)] unit\s of [chemical_name] in their bloodstream.")
		else
			to_chat(user, "The subject has too many chemicals.")
	else
		to_chat(user, "There's no suitable occupant in \the [src].")