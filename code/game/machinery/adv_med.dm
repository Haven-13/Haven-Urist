// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/human/occupant
	var/locked
	name = "Body Scanner"
	icon = 'resources/icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/bodyscanner/Initialize()
	. = ..()
	build_default_parts(/obj/item/weapon/circuitboard/body_scanner)

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"
	if (usr.stat != 0)
		return
	if(src.occupant)
		to_chat(usr, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if(usr.abiotic())
		to_chat(usr, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	occupant = usr
	update_use_power(2)
	icon_state = "body_scanner_1"
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if(!(occupant) || locked)
		return
	for(var/obj/O in (src.contents - component_parts))
		O.dropInto(loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.dropInto(loc)
	src.occupant = null
	update_use_power(1)
	src.icon_state = "body_scanner_0"
	return

/obj/machinery/bodyscanner/attackby(obj/item/O as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		go_out()
		return
	if(default_deconstruction_crowbar(user, O))
		go_out()
		return
	if(default_part_replacement(user, O))
		return
	if(!istype(O, /obj/item/grab/normal))
		return src.handle_grab(O, user)

/obj/machinery/bodyscanner/proc/handle_grab(obj/item/grab/normal/G, mob/user)
	if(!istype(G))
		if(default_deconstruction_screwdriver(user, G))
			updateUsrDialog()
			return
		if(default_deconstruction_crowbar(user, G))
			return
		if(default_part_replacement(user, G))
			return
	var/mob/M = G.affecting
	if(!user_can_move_target_inside(M, user))
		return
	M.forceMove(src)
	src.occupant = M

	update_use_power(2)
	src.icon_state = "body_scanner_1"
	for(var/obj/O in (contents - component_parts))
		O.forceMove(loc)

	src.add_fingerprint(user)
	qdel(G)

/obj/machinery/bodyscanner/proc/user_can_move_target_inside(mob/target, mob/user)
	if(!istype(user) || !istype(target))
		return FALSE
	if(!CanMouseDrop(target, user))
		return FALSE
	if(occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return FALSE
	if(target.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return FALSE
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return FALSE
	return TRUE

//Like grap-put, but for mouse-drop.
/obj/machinery/bodyscanner/MouseDrop_T(mob/target, mob/user)
	if(!user_can_move_target_inside(target, user))
		return
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	if(!user_can_move_target_inside(target, user))
		return
	var/mob/M = target
	M.forceMove(src)
	src.occupant = M
	update_use_power(2)
	src.icon_state = "body_scanner_1"
	for(var/obj/O in (contents - component_parts))
		O.forceMove(loc)
	src.add_fingerprint(user)

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.dropInto(loc)
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/body_scanconsole/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		else
	return



/obj/machinery/body_scanconsole/update_icon()
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else if (stat & NOPOWER)
		spawn(rand(0, 15))
			src.icon_state = "body_scannerconsole-p"
	else
		icon_state = initial(icon_state)

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/stored_scan
	var/stored_scan_subject
	name = "Body Scanner Console"
	icon = 'resources/icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1

/obj/machinery/body_scanconsole/Initialize()
	. = ..()
	locate_scanner()
	build_default_parts(/obj/item/weapon/circuitboard/scanner_console)

/obj/machinery/body_scanconsole/proc/locate_scanner()
	for(var/D in GLOB.cardinal)
		var/turf/T = get_step(src, D)
		var/obj/machinery/bodyscanner/B = locate() in T.contents
		if(B)
			connected = B
			return TRUE
	return FALSE

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(mob/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, "<span class='warning'>This console is not connected to a functioning body scanner.</span>")
		return
	generate_window(user)
	return

/obj/machinery/body_scanconsole/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	. = ..()

/obj/machinery/body_scanconsole/OnTopic(mob/user, href_list)
	if (href_list["print"])
		if (!stored_scan)
			to_chat(user, "\icon[src]<span class='warning'>Error: No scan stored.</span>")
			return TRUE
		new/obj/item/weapon/paper/(loc, "<tt>[stored_scan]</tt>", "Body scan report - [stored_scan_subject]")
		return TRUE
	if(href_list["scan"])
		if (!connected.occupant)
			to_chat(user, "\icon[src]<span class='warning'>The body scanner is empty.</span>")
			return TRUE
		if (!istype(connected.occupant))
			to_chat(user, "\icon[src]<span class='warning'>The body scanner cannot scan that lifeform.</span>")
			return TRUE
		stored_scan = connected.occupant.get_medical_data()
		stored_scan_subject = connected.occupant
		user.visible_message("<span class='notice'>\The [user] performs a scan of \the [connected.occupant] using \the [connected].</span>")
		generate_window(user)
		return TRUE
	if(href_list["erase"])
		stored_scan = null
		stored_scan_subject = null
		generate_window(user)
		return TRUE
	if(href_list["scan_refresh"])
		generate_window(user)
		return TRUE

/proc/get_severity(amount)
	if(!amount)
		return "none"
	. = "minor"
	if(amount > 50)
		. = "severe"
	else if(amount > 25)
		. = "significant"
	else if(amount > 10)
		. = "moderate"

/obj/machinery/body_scanconsole/proc/generate_window(mob/user)
	var/dat = list()
	if (stored_scan)
		dat = stored_scan
		dat += "<br><HR><A href='?src=[REF(src)];print=1'>Print Scan</A>"
		dat += "<br><HR><A href='?src=[REF(src)];erase=1'>Erase Scan</A>"
		if(is_human_mob(connected.occupant))
			dat += "<br><HR><A href='?src=[REF(src)];scan=1'>Rescan Occupant</A>"
	else
		dat = "<b>Scan Menu</b>"
		if (!connected.occupant)
			dat += "<br><HR><span class='warning'>The body scanner is empty.</span>"
		else if(!is_human_mob(connected.occupant))
			dat += "<br><HR><span class='warning'>This device can only scan compatible lifeforms.</span>"
		else
			dat += "<br><HR><A href='?src=[REF(src)];scan=1'>Scan Occupant</A>"

	dat += "<BR><HR><A href='?src=[REF(src)];scan_refresh=1'>Refresh</A>"
	dat += "<BR><HR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>"
	show_browser(user, jointext(dat, null), "window=scanconsole;size=430x600")

/mob/living/carbon/human/proc/get_medical_data()
	var/mob/living/carbon/human/H = src
	var/dat = list()
	dat +="<b>SCAN RESULTS FOR: [H]</b>"
	dat +="Scan performed at [stationtime2text()]<br>"

	var/brain_result = "normal"
	if(H.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		if(!brain || H.stat == DEAD || (H.status_flags & FAKEDEATH))
			brain_result = "<span class='danger'>none, patient is braindead</span>"
		else if(H.stat != DEAD)
			brain_result = "[round(max(0,(1 - brain.damage/brain.max_damage)*100))]%"
	else
		brain_result = "<span class='danger'>ERROR - Nonstandard biology</span>"
	dat += "<b>Brain activity:</b> [brain_result]"

	var/pulse_result = "normal"
	var/pulse_suffix = "bpm"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(1)
	else
		pulse_result = "ERROR - Nonstandard biology"
		pulse_suffix = ""
	dat += "<b>Pulse rate:</b> [pulse_result][pulse_suffix]"

	// Blood pressure. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.get_blood_volume() <= 70)
		dat += "<span class='danger'>Severe blood loss detected.</span>"
	dat += "<b>Blood pressure:</b> [H.get_blood_pressure()] ([H.get_blood_oxygenation()]% blood oxygenation)"
	dat += "<b>Blood volume:</b> [H.vessel.get_reagent_amount(/datum/reagent/blood)]/[H.species.blood_volume]u"

	// Body temperature.
	dat += "<b>Body temperature:</b> [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F)"

	dat += "<b>Physical Trauma:</b>\t[get_severity(H.getBruteLoss())]"
	dat += "<b>Burn Severity:</b>\t[get_severity(H.getFireLoss())]"
	dat += "<b>Systematic Organ Failure:</b>\t[get_severity(H.getToxLoss())]"
	dat += "<b>Oxygen Deprivation:</b>\t[get_severity(H.getOxyLoss())]"

	dat += "<b>Radiation Level:</b>\t[get_severity(H.radiation/5)]"
	dat += "<b>Genetic Tissue Damage:</b>\t[get_severity(H.getCloneLoss())]"
	if(H.paralysis)
		dat += "Paralysis Summary: approx. [H.paralysis/4] seconds left"

	dat += "Antibody levels and immune system perfomance are at [round(H.virus_immunity()*100)]% of baseline."
	if (H.virus2.len)
		dat += "<font color='red'>Viral pathogen detected in blood stream.</font>"

	if(H.reagents.total_volume)
		var/reagentdata[0]
		for(var/A in H.reagents.reagent_list)
			var/datum/reagent/R = A
			if(R.scannable)
				reagentdata[R.type] = "[round(H.reagents.get_reagent_amount(R.type), 1)]u [R.name]"
		if(reagentdata.len)
			dat += "Beneficial reagents detected in subject's blood:"
			for(var/d in reagentdata)
				dat += reagentdata[d]

	var/list/table = list()
	table += "<table border='1'><tr><th>Organ</th><th>Damage</th><th>Status</th></tr>"
	for(var/obj/item/organ/external/E in H.organs)
		table += "<tr><td>[E.name]</td>"
		if(E.is_stump())
			table += "<td>N/A</td><td>Missing</td>"
		else
			table += "<td>"
			if(E.brute_dam)
				table += "[capitalize(get_wound_severity(E.brute_ratio))] physical trauma ([E.brute_dam])"
			if(E.burn_dam)
				table += " [capitalize(get_wound_severity(E.burn_ratio))] burns ([E.burn_dam])"
			if(E.brute_dam + E.burn_dam == 0)
				table += "None"
			table += "</td><td>[english_list(E.get_scan_results(), "", ", ", ", ", "")]</td></tr>"

	table += "<tr><td>---</td><td><b>INTERNAL ORGANS</b></td><td>---</td></tr>"
	for(var/obj/item/organ/internal/I in H.internal_organs)
		table += "<tr><td>[I.name]</td>"
		table += "<td>"
		if(I.is_broken())
			table += "Severe"
		else if(I.is_bruised())
			table += "Moderate"
		else if(I.is_damaged())
			table += "Minor"
		else
			table += "None"
		table += "</td><td>[english_list(I.get_scan_results(), "", ", ", ", ", "")]</td></tr>"
	table += "</table>"
	dat += jointext(table,null)
	table.Cut()
	for(var/organ_name in H.species.has_organ)
		if(!locate(H.species.has_organ[organ_name]) in H.internal_organs)
			dat += text("No [organ_name] detected.")

	if(H.sdisabilities & BLIND)
		dat += text("Cataracts detected.")
	if(H.sdisabilities & NEARSIGHTED)
		dat += text("Retinal misalignment detected.")

	. = jointext(dat,"<br>")
