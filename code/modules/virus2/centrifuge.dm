/obj/machinery/disease2/centrifuge
	name = "isolation centrifuge"
	desc = "Used to separate things with different weights. Spin 'em round, round, right round."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	density = TRUE
	var/curing
	var/isolating

	var/obj/item/weapon/reagent_containers/glass/beaker/vial/sample = null
	var/datum/disease2/disease/virus2 = null

/obj/machinery/disease2/centrifuge/Initialize()
	build_default_parts(/obj/item/weapon/circuitboard/centrifuge)
	. = ..()

/obj/machinery/disease2/centrifuge/attackby(var/obj/O as obj, var/mob/user as mob)
	if(..())
		return
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial))
		if(sample)
			to_chat(user, "\The [src] is already loaded.")
			return
		if(!user.unEquip(O, src))
			return
		sample = O

		user.visible_message("[user] adds \a [O] to \the [src]!", "You add \a [O] to \the [src]!")
		SStgui.update_uis(src)

	src.attack_hand(user)

/obj/machinery/disease2/centrifuge/update_icon()
	..()
	if(! (stat & (BROKEN|NOPOWER)))
		icon_state = (isolating || curing) ? "centrifuge_moving" : "centrifuge"

/obj/machinery/disease2/centrifuge/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "virology/PathogenicCentrifuge")
		ui.open()

/obj/machinery/disease2/centrifuge/ui_data(mob/user)
	. = list(
		"antibodies" = null,
		"pathogens" = null,
		"isAntibodySample" = FALSE,
		"busy" = null,
		"timeLeft" = 0
	)

	if (curing)
		.["busy"] = "Isolating antibodies..."
		.["timeLeft"] = curing
	else if (isolating)
		.["busy"] = "Isolating pathogens..."
		.["timeLeft"] = isolating

	.["sampleInserted"] = !!sample

	if (sample)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
		if (B)
			.["antibodies"] = antigens2string(B.data["antibodies"], none=null)

			var/list/pathogens[0]
			var/list/virus = B.data["virus2"]
			for (var/ID in virus)
				var/datum/disease2/disease/V = virus[ID]
				pathogens.Add(list(list("name" = V.name(), "spreadType" = V.spreadtype, "reference" = "\ref[V]")))

			if (pathogens.len > 0)
				.["pathogens"] = pathogens

		else
			var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
			if(A)
				.["antibodies"] = antigens2string(A.data["antibodies"], none=null)
			.["isAntibodySample"] = TRUE

/obj/machinery/disease2/centrifuge/Process()
	..()
	if (stat & (NOPOWER|BROKEN)) return

	if (curing)
		curing -= 1
		if (curing == 0)
			cure()

	if (isolating)
		isolating -= 1
		if(isolating == 0)
			isolate()

/obj/machinery/disease2/centrifuge/ui_act(action, list/params)
	switch(action)
		if("print")
			print(usr)
			. = FALSE
		if("isolate")
			isolate_pathogen(params["isolate"])
			. = TRUE
		if("antibody")
			isolate_antigens()
			. = TRUE
		if("eject")
			if(sample)
				sample.dropInto(loc)
				sample = null
			. = TRUE
	if(.)
		update_icon()

/obj/machinery/disease2/centrifuge/proc/isolate_pathogen(target)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (B)
		var/datum/disease2/disease/virus = locate(target)
		virus2 = virus.getcopy()
		isolating = 40

/obj/machinery/disease2/centrifuge/proc/isolate_antigens()
	var/delay = 20
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (!B)
		state("\The [src] buzzes, \"No antibody carrier detected.\"", "blue")
		return FALSE

	var/has_toxins = locate(/datum/reagent/toxin) in sample.reagents.reagent_list
	var/has_radium = sample.reagents.has_reagent(/datum/reagent/radium)
	if (has_toxins || has_radium)
		state("\The [src] beeps, \"Pathogen purging speed above nominal.\"", "blue")
		if (has_toxins)
			delay = delay/2
		if (has_radium)
			delay = delay/2

	curing = round(delay)
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)

/obj/machinery/disease2/centrifuge/proc/cure()
	if (!sample) return
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (!B) return

	var/list/data = list("antibodies" = B.data["antibodies"])
	var/amt= sample.reagents.get_reagent_amount(/datum/reagent/blood)
	sample.reagents.remove_reagent(/datum/reagent/blood, amt)
	sample.reagents.add_reagent(/datum/reagent/antibodies, amt, data)

	SStgui.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Antibody isolated.\"")

/obj/machinery/disease2/centrifuge/proc/isolate()
	if (!sample) return
	var/obj/item/weapon/virusdish/dish = new/obj/item/weapon/virusdish(loc)
	dish.virus2 = virus2
	virus2 = null

	SStgui.update_uis(src)
	update_icon()
	ping("\The [src] pings, \"Pathogen isolated.\"")

/obj/machinery/disease2/centrifuge/proc/print(var/mob/user)
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
	P.SetName("paper - Pathology Report")
	P.info = {"
		[virology_letterhead("Pathology Report")]
		<large><u>Sample:</u></large> [sample.name]<br>
"}

	if (user)
		P.info += "<u>Generated By:</u> [user.name]<br>"

	P.info += "<hr>"

	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in sample.reagents.reagent_list
	if (B)
		P.info += "<u>Antibodies:</u> "
		P.info += antigens2string(B.data["antibodies"])
		P.info += "<br>"

		var/list/virus = B.data["virus2"]
		P.info += "<u>Pathogens:</u> <br>"
		if (virus.len > 0)
			for (var/ID in virus)
				var/datum/disease2/disease/V = virus[ID]
				P.info += "[V.name()]<br>"
		else
			P.info += "None<br>"

	else
		var/datum/reagent/antibodies/A = locate(/datum/reagent/antibodies) in sample.reagents.reagent_list
		if (A)
			P.info += "The following antibodies have been isolated from the blood sample: "
			P.info += antigens2string(A.data["antibodies"])
			P.info += "<br>"

	P.info += {"
	<hr>
	<u>Additional Notes:</u> <field>
"}

	state("The nearby computer prints out a pathology report.")
