/obj/item/weapon/fuel_assembly
	name = "fuel rod assembly"
	icon = 'resources/icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"
	layer = 4

	var/material/material_real
	var/material_name

	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = "composite"
	var/fuel_colour
	var/radioactivity = 0
	var/const/initial_amount = 300

/obj/item/weapon/fuel_assembly/New(newloc, _material, _colour)
	fuel_type = _material
	fuel_colour = _colour
	..(newloc)

/obj/item/weapon/fuel_assembly/Initialize()
	. = ..()
	var/material/material = SSmaterials.get_material_by_name(fuel_type)
	if(istype(material))
		SetName("[material.use_name] fuel rod assembly")
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.use_name
		material_real = material
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			START_PROCESSING(SSobj, src)
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		SetName("[fuel_type] fuel rod assembly")
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	overlays += mutable_appearance(icon, "fuel_assembly", fuel_colour)
	overlays += mutable_appearance(icon, "fuelassembly_bracket")
	rod_quantities[fuel_type] = initial_amount

/obj/item/weapon/fuel_assembly/Process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		SSradiation.radiate(src, max(1,Ceiling(radioactivity/30)))

/obj/item/weapon/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Mapper shorthand.
/obj/item/weapon/fuel_assembly/deuterium/New(newloc)
	..(newloc, "deuterium")

/obj/item/weapon/fuel_assembly/tritium/New(newloc)
	..(newloc, "tritium")

/obj/item/weapon/fuel_assembly/phoron/New(newloc)
	..(newloc, "phoron")

/obj/item/weapon/fuel_assembly/supermatter/New(newloc)
	..(newloc, "supermatter")

/obj/item/fuel_assembly/hydrogen/New(newloc)
	..(newloc, "hydrogen")
