// Cell rack PSU, similar to SMES, but uses power cells to store power.
// Lacks detailed control of input/output values, and has generally much worse capacity.
#define PSU_OFFLINE 0
#define PSU_OUTPUT 1
#define PSU_INPUT 2
#define PSU_AUTO 3

#define PSU_MAXCELLS 9 // Capped to 9 cells due to sprite limitation

/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	icon = 'resources/icons/obj/cellrack.dmi'
	icon_state = "rack"
	capacity = 0
	charge = 0
	should_be_mapped = 1

	var/max_transfer_rate = 0							// Maximal input/output rate. Determined by used capacitors when building the device.
	var/mode = PSU_OFFLINE								// Current inputting/outputting mode
	var/list/internal_cells = list()					// Cells stored in this PSU
	var/max_cells = PSU_MAXCELLS						// Maximal amount of stored cells at once. Capped at 9.
	var/previous_charge = 0								// Charge previous tick.
	var/equalise = 0									// If true try to equalise charge between cells
	var/icon_update = 0									// Timer in ticks for icon update.
	var/ui_tick = 0


/obj/machinery/power/smes/batteryrack/New()
	..()
	add_parts()
	RefreshParts()

/obj/machinery/power/smes/batteryrack/proc/add_parts()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/batteryrack
	component_parts += new /obj/item/weapon/stock_parts/capacitor/				// Capacitors: Maximal I/O
	component_parts += new /obj/item/weapon/stock_parts/capacitor/
	component_parts += new /obj/item/weapon/stock_parts/capacitor/

/obj/machinery/power/smes/batteryrack/RefreshParts()
	var/capacitor_efficiency = 0
	for(var/obj/item/weapon/stock_parts/capacitor/CP in component_parts)
		capacitor_efficiency += CP.rating

	max_transfer_rate = 10000 * capacitor_efficiency // 30kw - 90kw depending on used capacitors.
	input_level = max_transfer_rate
	output_level = max_transfer_rate

/obj/machinery/power/smes/batteryrack/Destroy()
	for(var/obj/item/weapon/cell/C in internal_cells)
		qdel(C)
	internal_cells = null
	return ..()

/obj/machinery/power/smes/batteryrack/update_icon()
	overlays.Cut()
	icon_update = 0

	var/cellcount = 0
	var/charge_level = between(0, round(Percentage() / 12), 7)


	overlays += "charge[charge_level]"

	for(var/obj/item/weapon/cell/C in internal_cells)
		cellcount++
		overlays += "cell[cellcount]"
		if(C.fully_charged())
			overlays += "cell[cellcount]f"
		else if(!C.charge)
			overlays += "cell[cellcount]e"

// Recalculate maxcharge and similar variables.
/obj/machinery/power/smes/batteryrack/proc/update_maxcharge()
	var/newmaxcharge = 0
	for(var/obj/item/weapon/cell/C in internal_cells)
		newmaxcharge += C.maxcharge

	capacity = newmaxcharge
	charge = between(0, charge, newmaxcharge)


// Sets input/output depending on our "mode" var.
/obj/machinery/power/smes/batteryrack/proc/update_io(newmode)
	mode = newmode
	switch(mode)
		if(PSU_OFFLINE)
			input_attempt = 0
			output_attempt = 0
		if(PSU_INPUT)
			input_attempt = 1
			output_attempt = 0
		if(PSU_OUTPUT)
			input_attempt = 0
			output_attempt = 1
		if(PSU_AUTO)
			input_attempt = 1
			output_attempt = 1

// Store charge in the power cells, instead of using the charge var. Amount is in joules.
/obj/machinery/power/smes/batteryrack/add_charge(amount)
	amount *= CELLRATE // Convert to CELLRATE first.
	if(equalise)
		// Now try to get least charged cell and use the power from it.
		var/obj/item/weapon/cell/CL = get_least_charged_cell()
		amount -= CL.give(amount)
		if(!amount)
			return
	// We're still here, so it means the least charged cell was full OR we don't care about equalising the charge. Give power to other cells instead.
	for(var/obj/item/weapon/cell/C in internal_cells)
		amount -= C.give(amount)
		// No more power to input so return.
		if(!amount)
			return


/obj/machinery/power/smes/batteryrack/remove_charge(amount)
	amount *= CELLRATE // Convert to CELLRATE first.
	if(equalise)
		// Now try to get most charged cell and use the power from it.
		var/obj/item/weapon/cell/CL = get_most_charged_cell()
		amount -= CL.use(amount)
		if(!amount)
			return
	// We're still here, so it means the most charged cell didn't have enough power OR we don't care about equalising the charge. Use power from other cells instead.
	for(var/obj/item/weapon/cell/C in internal_cells)
		amount -= C.use(amount)
		// No more power to output so return.
		if(!amount)
			return

// Helper procs to get most/least charged cells.
/obj/machinery/power/smes/batteryrack/proc/get_most_charged_cell()
	var/obj/item/weapon/cell/CL = null
	for(var/obj/item/weapon/cell/C in internal_cells)
		if(CL == null)
			CL = C
		else if(CL.percent() < C.percent())
			CL = C
	return CL
/obj/machinery/power/smes/batteryrack/proc/get_least_charged_cell()
	var/obj/item/weapon/cell/CL = null
	for(var/obj/item/weapon/cell/C in internal_cells)
		if(CL == null)
			CL = C
		else if(CL.percent() > C.percent())
			CL = C
	return CL

/obj/machinery/power/smes/batteryrack/proc/insert_cell(obj/item/weapon/cell/C, mob/user)
	if(!istype(C))
		return 0

	if(internal_cells.len >= max_cells)
		return 0
	if(user && !user.unEquip(C))
		return 0
	internal_cells.Add(C)
	C.forceMove(src)
	RefreshParts()
	update_maxcharge()
	update_icon()
	return 1


/obj/machinery/power/smes/batteryrack/Process()
	charge = 0
	for(var/obj/item/weapon/cell/C in internal_cells)
		charge += C.charge

	..()
	ui_tick = !ui_tick
	icon_update++

	// Don't update icon too much, prevents unnecessary processing.
	if(icon_update >= 10)
		update_icon()
	// Try to balance charge between stored cells. Capped at max_transfer_rate per tick.
	// Take power from most charged cell, and give it to least charged cell.
	if(equalise)
		var/obj/item/weapon/cell/least = get_least_charged_cell()
		var/obj/item/weapon/cell/most = get_most_charged_cell()
		// Don't bother equalising charge between two same cells. Also ensure we don't get NULLs or wrong types. Don't bother equalising when difference between charges is tiny.
		if(least == most || !istype(least) || !istype(most) || least.percent() == most.percent())
			return
		var/percentdiff = (most.percent() - least.percent()) / 2 // Transfer only 50% of power. The reason is that it could lead to situations where least and most charged cells would "swap places" (45->50% and 50%->45%)
		var/celldiff
		// Take amount of power to transfer from the cell with smaller maxcharge
		if(most.maxcharge > least.maxcharge)
			celldiff = (least.maxcharge / 100) * percentdiff
		else
			celldiff = (most.maxcharge / 100) * percentdiff
		celldiff = between(0, celldiff, max_transfer_rate * CELLRATE)
		// Ensure we don't transfer more energy than the most charged cell has, and that the least charged cell can input.
		celldiff = min(min(celldiff, most.charge), least.maxcharge - least.charge)
		least.give(most.use(celldiff))

/obj/machinery/power/smes/batteryrack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "power/PowerBatteryRack", src.name)
		ui.open()

/obj/machinery/power/smes/batteryrack/ui_data(mob/user)
	. = list()

	.["mode"] = mode
	.["transfer_max"] = max_transfer_rate
	.["output_load"] = round(output_used)
	.["input_load"] = round(input_available)
	.["equalise"] = equalise
	.["blink_tick"] = ui_tick

	.["cells"] = list()
	for(var/cell_index in 1 to max_cells)
		if (cell_index <= length(internal_cells))
			var/obj/item/weapon/cell/C = internal_cells[cell_index]
			.["cells"] += list(list(
				"slot" = cell_index,
				"used" = TRUE,
				"charge" = C.charge,
				"capacity" = C.maxcharge,
				"id" = C.c_uid,
			))
		else
			.["cells"] += list(list(
				"slot" = cell_index,
				"used" = FALSE
			))

/obj/machinery/power/smes/batteryrack/ui_act(action, list/params)
	UI_ACT_CHECK

	switch(action)
		if("disable")
			update_io(0)
			return TRUE
		if("enable")
			update_io(between(1, text2num(params["mode"]), 3))
			return TRUE
		if("equalise")
			equalise = !equalise
			return TRUE
		if("ejectcell")
			var/obj/item/weapon/cell/C
			for(var/obj/item/weapon/cell/CL in internal_cells)
				if(CL.c_uid == text2num(params["eject"]))
					C = CL
					break

			if(!istype(C))
				return TRUE

			C.forceMove(get_turf(src))
			internal_cells -= C
			update_icon()
			RefreshParts()
			update_maxcharge()
			return TRUE

/obj/machinery/power/smes/batteryrack/dismantle()
	for(var/obj/item/weapon/cell/C in internal_cells)
		C.forceMove(get_turf(src))
		internal_cells -= C
	return ..()

/obj/machinery/power/smes/batteryrack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!..())
		return 0
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(istype(W, /obj/item/weapon/cell)) // ID Card, try to insert it.
		if(insert_cell(W, user))
			to_chat(user, "You insert \the [W] into \the [src].")
		else
			to_chat(user, "\The [src] has no empty slot for \the [W]")

/obj/machinery/power/smes/batteryrack/inputting()
	return

/obj/machinery/power/smes/batteryrack/outputting()
	return
