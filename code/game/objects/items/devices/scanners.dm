/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
*/


/obj/item/device/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "healthanalyzer"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/mode = 1;

/obj/item/device/healthanalyzer/do_surgery(mob/living/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	medical_scan_action(M, user, src, mode) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/device/healthanalyzer/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	medical_scan_action(target, user, src, mode)

/proc/medical_scan_action(atom/target, mob/living/user, obj/scanner, verbose)
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You are not nimble enough to use this device.</span>")
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user.visible_message("<span class='notice'>\The [user] runs \the [scanner] over the floor.")
		to_chat(user, "<span class='notice'><b>Scan results for the floor:</b></span>")
		to_chat(user, "Overall Status: Healthy</span>")
		return

	var/mob/living/carbon/human/scan_subject = null
	if (istype(target, /mob/living/carbon/human))
		user.visible_message("<span class='notice'>\The [user] runs \the [scanner] over \the [target].</span>")
		scan_subject = target
	else if (istype(target, /obj/structure/closet/body_bag))
		user.visible_message("<span class='notice'>\The [user] runs \the [scanner] over \the [target].</span>")
		var/obj/structure/closet/body_bag/B = target
		if(!B.opened)
			var/list/scan_content = list()
			for(var/mob/living/L in B.contents)
				scan_content.Add(L)

			if (scan_content.len == 1)
				for(var/mob/living/carbon/human/L in scan_content)
					scan_subject = L
			else if (scan_content.len > 1)
				to_chat(user, "<span class='warning'>\The [scanner] picks up multiple readings inside \the [target], too close together to scan properly.</span>")
				return
			else
				to_chat(user, "\The [scanner] does not detect anyone inside \the [target].")
				return
	else
		return

	if (scan_subject.isSynthetic())
		to_chat(user, "<span class='warning'>\The [scanner] is designed for organic humanoid patients only.</span>")
		return
	to_chat(user, "<hr>")
	to_chat(user, medical_scan_results(scan_subject, verbose))
	to_chat(user, "<hr>")

/proc/medical_scan_deep_primitive(mob/living/carbon/human/H)
	var/found_broken
	var/found_infection
	var/found_bleed
	var/found_tendon
	var/found_disloc
	for(var/obj/item/organ/external/e in H.organs)
		if(e)
			if(!found_broken && e.status & ORGAN_BROKEN)
				found_broken = TRUE
			if(!found_infection && e.has_infected_wound())
				found_infection = TRUE
			if(!found_disloc && e.dislocated == 2)
				found_disloc = TRUE
			if(!found_bleed && (e.status & ORGAN_ARTERY_CUT))
				found_bleed = TRUE
			if(!found_tendon && (e.status & ORGAN_TENDON_CUT))
				found_tendon = TRUE
		if(found_broken && found_infection && found_disloc && found_bleed && found_tendon)
			break
	return list(
		"hasBrokenBones" = found_broken,
		"hasInfections" = found_infection,
		"hasBleeding" = found_bleed,
		"hasTendonDamage" = found_tendon,
		"hasDislocation" = found_disloc
	)

/proc/medical_scan_json(mob/living/carbon/human/H)
	. = list()

	.["name"] = H.name
	.["species"] = H.species.name
	.["status"] = H.stat
	.["statusFlags"] = H.status_flags
	.["timeOfDeath"] = time2text(worldtime2stationtime(H.timeofdeath), "hh:mm")

	.["bodyTemperature"] = H.bodytemperature - T0C
	.["radiation"] = H.radiation
	.["shockStage"] = H.shock_stage

	.["toxinLoss"] = H.getToxLoss()
	.["bruteLoss"] = H.getBruteLoss()
	.["fireLoss"] = H.getFireLoss()
	.["oxyLoss"] = H.getOxyLoss()

	if(H.internal_organs_by_name[BP_STACK])
		.["stack"] = list("hasOrgan" = TRUE)

	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
	.["brain"] = list(
		"shouldHave" = H.should_have_organ(BP_BRAIN),
		"hasOrgan" = brain != null,
		"damage" = brain ? brain.get_current_damage_threshold() : -1
	)

	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
	.["heart"] = list(
		"shouldHave" = H.should_have_organ(BP_HEART),
		"hasOrgan" = heart != null,
		"pulse" = H.get_pulse(1),
		"bloodVolume" = H.get_blood_volume(),
		"bloodPressure" = H.get_blood_pressure(),
		"bloodOxygenation" = H.get_blood_oxygenation(),
		"asystole" = H.is_asystole()
	)

	var/l = medical_scan_deep_primitive(H)
	for (var/k in l)
		.[k] = l[k]

	.["reagents"] = list()
	if (H.reagents.total_volume)
		for(var/A in H.reagents.reagent_list)
			var/datum/reagent/R = A
			if (!R) continue
			.["reagents"] += list(list(
				"scannable" = R.scannable,
				"type" = R.type,
				"name" = R.name,
				"amount" = H.reagents.get_reagent_amount(R.type)
			))

	.["ingested"] = list()
	if (H.ingested && H.ingested.total_volume)
		for(var/A in H.ingested.reagent_list)
			var/datum/reagent/R = A
			if (!R) continue
			.["reagents"] += list(list(
				"scannable" = R.scannable,
				"type" = R.type,
				"name" = R.name,
				"amount" = H.ingested.get_reagent_amount(R.type)
			))

	.["chemTraces"] = list()
	if (H.chem_doses && H.chem_doses.len)
		for(var/T in H.chem_doses)
			var/datum/reagent/R = T
			if (!R) continue
			.["chemTraces"] += list(list(
				"scannable" = initial(R.scannable),
				"name" = initial(R.name),
				"amount" = H.chem_doses[T]
			))

	.["pathogens"] = list()
	if (H.virus2 && H.virus2.len)
		for (var/ID in H.virus2)
			if (ID in virusDB)
				var/datum/computer_file/data/virus_record/V = virusDB[ID]
				.["pathogens"] += list(list(
					"name" = V.fields["name"],
					"antigens" = V.fields["antigen"]
				))


/proc/medical_scan_results(mob/living/carbon/human/H, verbose)
	. = list()
	. += "<span class='notice'><b>Scan results for \the [H]:</b></span>"

	// Brain activity.
	var/brain_result = "normal"
	if(H.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		if(!brain || H.stat == DEAD || (H.status_flags & FAKEDEATH))
			brain_result = "<span class='danger'>none, patient is braindead</span>"
		else if(H.stat != DEAD)
			switch(brain.get_current_damage_threshold())
				if(0)
					brain_result = "<span class='notice'>normal</span>"
				if(1 to 2)
					brain_result = "<span class='notice'>minor brain damage</span>"
				if(3 to 5)
					brain_result = "<span class='warning'>weak</span>"
				if(6 to 8)
					brain_result = "<span class='danger'>extremely weak</span>"
				if(9 to INFINITY)
					brain_result = "<span class='danger'>fading</span>"
				else
					brain_result = "<span class='danger'>ERROR - Hardware fault</span>"
	else
		brain_result = "<span class='danger'>ERROR - Nonstandard biology</span>"
	. += "<span class='notice'>Brain activity:</span> [brain_result]."

	if(H.stat == DEAD || (H.status_flags & FAKEDEATH))
		. += "<span class='notice'><b>Time of Death:</b> [time2text(worldtime2stationtime(H.timeofdeath), "hh:mm")]</span>"

	if (H.internal_organs_by_name[BP_STACK])
		. += "<span class='notice'>Subject has a neural lace implant.</span>"

	// Pulse rate.
	var/pulse_result = "normal"
	var/pulse_suffix = "bpm"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(1)
	else
		pulse_result = "<span class='danger'>ERROR - Nonstandard biology</span>"
		pulse_suffix = ""

	. += "<span class='notice'>Pulse rate: [pulse_result][pulse_suffix].</span>"

	// Blood pressure. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.should_have_organ(BP_HEART))
		if(H.get_blood_volume() <= 70)
			. += "<span class='scan_danger'>Severe blood loss detected.</span>"
		. += "<b>Blood pressure:</b> [H.get_blood_pressure()] ([H.get_blood_oxygenation()]% blood oxygenation)"
	else
		. += "<b>Blood pressure:</b> N/A"

	// Body temperature.
	. += "<span class='notice'>Body temperature: [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F)</span>"

	// Radiation.
	switch(H.radiation)
		if(-INFINITY to 0)
			. += "<span class='notice'>No radiation detected.</span>"
		if(1 to 30)
			. += "<span class='notice'>Patient shows minor traces of radiation exposure.</span>"
		if(31 to 60)
			. += "<span class='notice'>Patient is suffering from mild radiation poisoning.</span>"
		if(61 to 90)
			. += "<span class='warning'>Patient is suffering from advanced radiation poisoning.</span>"
		if(91 to 120)
			. += "<span class='warning'>Patient is suffering from severe radiation poisoning.</span>"
		if(121 to 240)
			. += "<span class='danger'>Patient is suffering from extreme radiation poisoning. Immediate treatment recommended.</span>"
		if(241 to INFINITY)
			. += "<span class='danger'>Patient is suffering from acute radiation poisoning. Immediate treatment recommended.</span>"

	// Traumatic shock.
	if(H.is_asystole())
		. += "<span class='danger'>Patient is suffering from cardiovascular shock. Administer CPR immediately.</span>"
	else if(H.shock_stage > 80)
		. += "<span class='warning'>Patient is at serious risk of going into shock. Pain relief recommended.</span>"

	// Other general warnings.
	if(H.getOxyLoss() > 50)
		. += "<font color='blue'><b>Severe oxygen deprivation detected.</b></font>"
	if(H.getToxLoss() > 50)
		. += "<font color='green'><b>Major systemic organ failure detected.</b></font>"
	if(H.getFireLoss() > 50)
		. += "<font color='#ffa500'><b>Severe burn damage detected.</b></font>"
	if(H.getBruteLoss() > 50)
		. += "<font color='red'><b>Severe anatomical damage detected.</b></font>"

	for(var/name in H.organs_by_name)
		var/obj/item/organ/external/e = H.organs_by_name[name]
		if(!e)
			continue
		var/limb = e.name
		if(e.status & ORGAN_BROKEN)
			if(((e.name == BP_L_ARM) || (e.name == BP_R_ARM) || (e.name == BP_L_LEG) || (e.name == BP_R_LEG)) && (!e.splinted))
				. += "<span class='warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>"
		if(e.has_infected_wound())
			. += "<span class='warning'>Infected wound detected in subject [limb]. Disinfection recommended.</span>"

	for(var/name in H.organs_by_name)
		var/obj/item/organ/external/e = H.organs_by_name[name]
		if(e && e.status & ORGAN_BROKEN)
			. += "<span class='warning'>Bone fractures detected. Advanced scanner required for location.</span>"
			break

	var/found_bleed
	var/found_tendon
	var/found_disloc
	for(var/obj/item/organ/external/e in H.organs)
		if(e)
			if(!found_disloc && e.dislocated == 2)
				. += "<span class='warning'>Dislocation detected. Advanced scanner required for location.</span>"
				found_disloc = TRUE
			if(!found_bleed && (e.status & ORGAN_ARTERY_CUT))
				. += "<span class='warning'>Arterial bleeding detected. Advanced scanner required for location.</span>"
				found_bleed = TRUE
			if(!found_tendon && (e.status & ORGAN_TENDON_CUT))
				. += "<span class='warning'>Tendon or ligament damage detected. Advanced scanner required for location.</span>"
				found_tendon = TRUE
		if(found_disloc && found_bleed && found_tendon)
			break

	if(verbose)

		// Limb status.
		. += "<span class='notice'><b>Specific limb damage:</b></span>"

		var/list/damaged = H.get_damaged_organs(1,1)
		if(damaged.len)
			for(var/obj/item/organ/external/org in damaged)
				var/limb_result = "[capitalize(org.name)][BP_IS_ROBOTIC(org) ? " (Cybernetic)" : ""]:"
				if(org.brute_dam > 0)
					limb_result = "[limb_result] \[<font color = 'red'><b>[get_wound_severity(org.brute_ratio, (org.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))] physical trauma ([org.brute_dam])</b></font>\]"
				if(org.burn_dam > 0)
					limb_result = "[limb_result] \[<font color = '#ffa500'><b>[get_wound_severity(org.burn_ratio, (org.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))] burns ([org.burn_dam])</b></font>\]"
				if(org.status & ORGAN_BLEEDING)
					limb_result = "[limb_result] \[<span class='danger'>bleeding</span>\]"
				. += limb_result
		else
			. += "No detectable limb injuries."

	// Reagent data.
	. += "<span class='notice'><b>Reagent scan:</b></span>"

	var/print_reagent_default_message = TRUE
	if(H.reagents.total_volume)
		var/unknown = 0
		var/reagentdata[0]
		for(var/A in H.reagents.reagent_list)
			var/datum/reagent/R = A
			if(R.scannable)
				print_reagent_default_message = FALSE
				reagentdata[R.type] = "<span class='notice'>    [round(H.reagents.get_reagent_amount(R.type), 1)]u [R.name]</span>"
			else
				unknown++
		if(reagentdata.len)
			print_reagent_default_message = FALSE
			. += "<span class='notice'>Beneficial reagents detected in subject's blood:</span>"
			for(var/d in reagentdata)
				. += reagentdata[d]
		if(unknown)
			print_reagent_default_message = FALSE
			. += "<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>"

	if(H.ingested && H.ingested.total_volume)
		var/unknown = 0
		for(var/datum/reagent/R in H.ingested.reagent_list)
			if(R.scannable)
				print_reagent_default_message = FALSE
				. += "<span class='notice'>[R.name] found in subject's stomach.</span>"
			else
				++unknown
		if(unknown)
			print_reagent_default_message = FALSE
			. += "<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>"

	if(H.chem_doses.len)
		var/list/chemtraces = list()
		for(var/T in H.chem_doses)
			var/datum/reagent/R = T
			if(initial(R.scannable))
				chemtraces += "[initial(R.name)] ([H.chem_doses[T]])"
		if(chemtraces.len)
			. += "<span class='notice'>Metabolism products of [english_list(chemtraces)] found in subject's system.</span>"

	if(H.virus2.len)
		for (var/ID in H.virus2)
			if (ID in virusDB)
				print_reagent_default_message = FALSE
				var/datum/computer_file/data/virus_record/V = virusDB[ID]
				. += "<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span>"

	if(print_reagent_default_message)
		. += "No results."
	. = jointext(.,"<br>")

// Calculates severity based on the ratios defined external limbs.
/proc/get_wound_severity(damage_ratio, can_heal_overkill = 0)
	var/degree

	switch(damage_ratio)
		if(0 to 0.1)
			degree = "minor"
		if(0.1 to 0.25)
			degree = "moderate"
		if(0.25 to 0.5)
			degree = "significant"
		if(0.5 to 0.75)
			degree = "severe"
		if(0.75 to 1)
			degree = "extreme"
		else
			if(can_heal_overkill)
				degree = "critical"
			else
				degree = "catastrophic"

	return degree

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	if(mode)
		to_chat(usr, "The scanner now shows specific limb damage.")
	else
		to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/device/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/advanced_mode = 0

/obj/item/device/analyzer/verb/verbosity(mob/user)
	set name = "Toggle Advanced Gas Analysis"
	set category = "Object"
	set src in usr

	if (!user.incapacitated())
		advanced_mode = !advanced_mode
		to_chat(user, "You toggle advanced gas analysis [advanced_mode ? "on" : "off"].")

/obj/item/device/analyzer/attack_self(mob/user)

	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return

	analyze_gases(user.loc, user,advanced_mode)
	return 1

/obj/item/device/analyzer/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(istype(O) && O.simulated)
		analyze_gases(O, user, advanced_mode)

/obj/item/device/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	..()
	create_reagents(5)

/obj/item/device/mass_spectrometer/on_reagent_change()
	update_icon()

/obj/item/device/mass_spectrometer/update_icon()
	icon_state = initial(icon_state)
	if(reagents.total_volume)
		icon_state += "_s"

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		var/list/blood_doses = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.type != /datum/reagent/blood)
				reagents.clear_reagents()
				to_chat(user, "<span class='warning'>The sample was contaminated! Please insert another sample</span>")
				return
			else
				blood_traces = R.data["trace_chem"]
				blood_doses = R.data["dose_chem"]
				break
		var/dat = "Trace Chemicals Found: "
		for(var/T in blood_traces)
			var/datum/reagent/R = T
			if(details)
				dat += "[initial(R.name)] ([blood_traces[T]] units) "
			else
				dat += "[initial(R.name)] "
		if(details)
			dat += "\nMetabolism Products of Chemicals Found:"
			for(var/T in blood_doses)
				var/datum/reagent/R = T
				dat += "[initial(R.name)] ([blood_doses[T]] units) "
		to_chat(user, "[dat]")
		reagents.clear_reagents()
	return

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!istype(O))
		return
	var/dat = reagent_scan_results(O, details)
	to_chat(user, "<span class = 'notice'>[jointext(dat,"<br>")]</span>")

/proc/reagent_scan_results(obj/O, details = 0)
	if(isnull(O.reagents))
		return list("No significant chemical agents found in [O].")
	if(O.reagents.reagent_list.len == 0)
		return list("No active chemical agents found in [O].")
	. = list("Chemicals found:")
	var/one_percent = O.reagents.total_volume / 100
	for (var/datum/reagent/R in O.reagents.reagent_list)
		. += "[R][details ? ": [R.volume / one_percent]%" : ""]"

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	origin_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(DEFAULT_WALL_MATERIAL = 25, "glass" = 25)

/obj/item/device/price_scanner/afterattack(atom/movable/target, mob/user as mob, proximity)
	if(!proximity)
		return

	var/value = get_value(target)
	user.visible_message("\The [user] scans \the [target] with \the [src]")
	user.show_message("Price estimation of \the [target]: [value || "N/A"] Thalers")

/obj/item/device/slime_scanner
	name = "xenolife scanner"
	desc = "Multipurpose organic life scanner. With spectral breath analyzer you can find out what snacks Ian had! Or what gasses alien life breathes."
	icon_state = "xenobio"
	item_state = "analyzer"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

/obj/item/device/slime_scanner/proc/list_gases(gases)
	. = list()
	for(var/g in gases)
		. += "[gas_data.name[g]] ([gases[g]]%)"
	return english_list(.)

/obj/item/device/slime_scanner/afterattack(mob/target, mob/user, proximity)
	if(!proximity)
		return

	if(!istype(target))
		return

	user.visible_message("\The [user] scans \the [target] with \the [src]")
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		user.show_message("<span class='notice'>Data for [H]:</span>")
		user.show_message("Species:\t[H.species]")
		user.show_message("Breathes:\t[gas_data.name[H.species.breath_type]]")
		user.show_message("Exhales:\t[gas_data.name[H.species.exhale_type]]")
		user.show_message("Known toxins:\t[english_list(H.species.poison_types)]")
		user.show_message("Temperature comfort zone:\t[H.species.cold_discomfort_level] K to [H.species.heat_discomfort_level] K")
		user.show_message("Pressure comfort zone:\t[H.species.warning_low_pressure] kPa to [H.species.warning_high_pressure] kPa")
	else if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = target
		user.show_message("<span class='notice'>Data for [A]:</span>")
		user.show_message("Species:\t[initial(A.name)]")
		user.show_message("Breathes:\t[list_gases(A.min_gas)]")
		user.show_message("Known toxins:\t[list_gases(A.max_gas)]")
		user.show_message("Temperature comfort zone:\t[A.minbodytemp] K to [A.maxbodytemp] K")
	else if(istype(target, /mob/living/carbon/slime/))
		var/mob/living/carbon/slime/T = target
		user.show_message("<span class='notice'>Slime scan result for \the [T]:</span>")
		user.show_message("[T.colour] [T.is_adult ? "adult" : "baby"] slime")
		user.show_message("Nutrition:\t[T.nutrition]/[T.get_max_nutrition()]")
		if(T.nutrition < T.get_starve_nutrition())
			user.show_message("<span class='alert'>Warning:\tthe slime is starving!</span>")
		else if (T.nutrition < T.get_hunger_nutrition())
			user.show_message("<span class='warning'>Warning:\tthe slime is hungry.</span>")
		user.show_message("Electric charge strength:\t[T.powerlevel]")
		user.show_message("Health:\t[round((T.health * 100) / T.maxHealth)]%")

		var/list/mutations = T.GetMutations()

		if(!mutations.len)
			user.show_message("This slime will never mutate.")
		else
			var/list/mutationChances = list()
			for(var/i in mutations)
				if(i == T.colour)
					continue
				if(mutationChances[i])
					mutationChances[i] += T.mutation_chance / mutations.len
				else
					mutationChances[i] = T.mutation_chance / mutations.len

			var/list/mutationTexts = list("[T.colour] ([100 - T.mutation_chance]%)")
			for(var/i in mutationChances)
				mutationTexts += "[i] ([mutationChances[i]]%)"

			user.show_message("Possible colours on splitting:\t[english_list(mutationTexts)]")

		if (T.cores > 1)
			user.show_message("Anomalous slime core amount detected.")
		user.show_message("Growth progress:\t[T.amount_grown]/10.")
	else
		user.show_message("Incompatible life form, analysis failed.")
