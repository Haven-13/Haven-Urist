/obj/item/weapon/ore
	name = "ore"
	icon_state = "lump"
	icon = 'resources/icons/obj/materials/ore.dmi'
	randpixel = 8
	w_class = 2
	var/material/material
	var/datum/geosample/geologic_data

/obj/item/weapon/ore/get_material()
	return material

/obj/item/weapon/ore/New(newloc, _mat)
	if(_mat)
		matter = list()
		matter[_mat] = SHEET_MATERIAL_AMOUNT
	..(newloc)

/obj/item/weapon/ore/Initialize()
	for(var/stuff in matter)
		var/material/M = SSmaterials.get_material_by_name(stuff)
		if(M)
			name = M.ore_name
			desc = M.ore_desc || "A lump of ore."
			material = M
			color = M.icon_colour
			icon_state = M.ore_icon_overlay
			if(M.ore_desc)
				desc = M.ore_desc
			if(icon_state == "dust")
				slot_flags = SLOT_HOLSTER
			break
	. = ..()

// POCKET SAND!
/obj/item/weapon/ore/throw_impact(atom/hit_atom)
	..()
	if(icon_state == "dust")
		var/mob/living/carbon/human/H = hit_atom
		if(istype(H) && H.has_eyes() && prob(85))
			to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
			H.eye_blind += 5
			H.eye_blurry += 10
			QDEL_IN(src, 1)

// Map definitions.
/obj/item/weapon/ore/uranium/New(newloc)
	..(newloc, "pitchblende")
/obj/item/weapon/ore/iron/New(newloc)
	..(newloc, "hematite")
/obj/item/weapon/ore/coal/New(newloc)
	..(newloc, "graphene")
/obj/item/weapon/ore/glass/New(newloc)
	..(newloc, "sand")
/obj/item/weapon/ore/silver/New(newloc)
	..(newloc, "silver")
/obj/item/weapon/ore/gold/New(newloc)
	..(newloc, "gold")
/obj/item/weapon/ore/diamond/New(newloc)
	..(newloc, "diamond")
/obj/item/weapon/ore/osmium/New(newloc)
	..(newloc, "platinum")
/obj/item/weapon/ore/hydrogen/New(newloc)
	..(newloc, "mhydrogen")
/obj/item/weapon/ore/slag/New(newloc)
	..(newloc, "waste")
/obj/item/weapon/ore/phoron/New(newloc)
	..(newloc, "phoron")
