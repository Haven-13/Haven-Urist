//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

var/list/default_material_composition = list("steel" = 0, "glass" = 0, "gold" = 0, "silver" = 0, "phoron" = 0, "uranium" = 0, "diamond" = 0)
/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'resources/icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] >= SHEET_MATERIAL_AMOUNT)
			var/path = SSmaterials.get_material_by_name(f)
			if(path)
				var/obj/item/stack/S = new f(loc)
				S.amount = round(materials[f] / SHEET_MATERIAL_AMOUNT)
	..()


/obj/machinery/r_n_d/proc/eject(material, amount)
	if(!(material in materials))
		return
	var/material/mat = SSmaterials.get_material_by_name(material)
	var/eject = clamp(round(materials[material] / mat.units_per_sheet), 0, amount)
	if(eject > 0)
		mat.place_sheet(loc, eject)
		materials[material] -= eject * mat.units_per_sheet

/obj/machinery/r_n_d/proc/TotalMaterials()
	for(var/f in materials)
		. += materials[f]

/obj/machinery/r_n_d/proc/getLackingMaterials(datum/design/D)
	var/list/ret = list()
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			var/datum/reagent/R = C
			ret += R.name
	return english_list(ret)
