
#define ORGAN_OPTION_NORMAL null
#define ORGAN_OPTION_CYBORG "cyborg"
#define ORGAN_OPTION_ASSISTED "assisted"
#define ORGAN_OPTION_SYNTHETIC "synthetic"
#define ORGAN_OPTION_AMPUTATED "amputated"

var/list/organ_option_names = list(
	ORGAN_OPTION_NORMAL = "Normal",
	ORGAN_OPTION_CYBORG = "Cyborg",
	ORGAN_OPTION_ASSISTED = "Assisted",
	ORGAN_OPTION_SYNTHETIC = "Synthetic",
	ORGAN_OPTION_AMPUTATED = "Amputated",
)

/datum/preferences
	var/ui_selected_organ

	var/list/organ_augmentation_data
	var/list/robotic_limb_data
	var/has_cortical_stack = TRUE

/datum/category_item/player_setup_item/augmentation/modification
	name = "Modification"
	sort_order = 1

/datum/category_item/player_setup_item/augmentation/modification/load_character(savefile/S)
	from_file(S["organ_augmentation_data"], pref.organ_augmentation_data)
	from_file(S["robotic_limb_data"], pref.robotic_limb_data)
	from_file(S["has_cortical_stack"], pref.has_cortical_stack)

/datum/category_item/player_setup_item/augmentation/modification/save_character(savefile/S)
	to_file(S["organ_augmentation_data"], pref.organ_augmentation_data)
	to_file(S["robotic_limb_data"], pref.robotic_limb_data)
	to_file(S["has_cortical_stack"], pref.has_cortical_stack)

/datum/category_item/player_setup_item/augmentation/modification/setup_character(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Replace any missing limbs.
	for(var/name in BP_ALL_LIMBS)
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O && pref.organ_augmentation_data[name] != ORGAN_OPTION_AMPUTATED)
			var/list/organ_data = character.species.has_limbs[name]
			if(!is_list(organ_data)) continue
			var/limb_path = organ_data["path"]
			O = new limb_path(character)

	// Destroy/cyborgize organs and limbs. The order is important for preserving low-level choices for robolimb sprites being overridden.
	for(var/name in BP_BY_DEPTH)
		var/status = pref.organ_augmentation_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(!O)
			continue
		O.status = 0
		O.model = null
		if(status == ORGAN_OPTION_AMPUTATED)
			character.organs_by_name[O.organ_tag] = null
			character.organs -= O
			if(O.children) // This might need to become recursive.
				for(var/obj/item/organ/external/child in O.children)
					character.organs_by_name[child.organ_tag] = null
					character.organs -= child
					qdel(child)
			qdel(O)
		else if(status == ORGAN_OPTION_CYBORG)
			if(pref.robotic_limb_data[name])
				O.robotize(pref.robotic_limb_data[name])
			else
				O.robotize()
		else //normal organ
			O.force_icon = initial(O.force_icon)
			O.SetName(initial(O.name))
			O.desc = initial(O.desc)

	//For species that don't care about your silly prefs
	character.species.handle_limbs_setup(character)
	if(!is_preview_copy)
		for(var/name in list(BP_HEART,BP_EYES,BP_BRAIN,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
			var/status = pref.organ_augmentation_data[name]
			if(!status)
				continue
			var/obj/item/organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == ORGAN_OPTION_ASSISTED)
					I.mechassist()
				else if(status == ORGAN_OPTION_SYNTHETIC)
					I.robotize()

/datum/category_item/player_setup_item/augmentation/modification/sanitize_character(savefile/S)
	pref.has_cortical_stack = sanitize_bool(pref.has_cortical_stack, initial(pref.has_cortical_stack))
	if(!istype(pref.organ_augmentation_data))
		pref.organ_augmentation_data = list()
	if(!istype(pref.robotic_limb_data))
		pref.robotic_limb_data = list()

/datum/category_item/player_setup_item/augmentation/modification/content(mob/user)
	. = list()
	var/datum/species/mob_species = all_species[pref.species]

	. += "<a href='?src=[REF(src)];reset_limbs=1'>Reset All</a>"
	. += "<table style='width:100%;height:100%'><tr><th style='width:50%'></th><th style='width:50%'></th></tr>"
	. += "<tr><td>"
	. += "<b>Implants</b><br>"
	if(config.use_cortical_stacks)
		. += "Neural lace: "
		if(mob_species.spawn_flags & SPECIES_NO_LACE)
			. += "incompatible."
		else
			. += pref.has_cortical_stack ? "present." : "<b>not present.</b>"
			. += " \[<a href='?src=[REF(src)];toggle_stack=1'>toggle</a>\]"
		. += "<br>"
	. += "<b>Organs</b>"
	. += "<table>"
	for(var/organ_key in mob_species.has_organ)
		var/limb_info = get_organ_info(organ_key)
		var/is_selected = organ_key == pref.ui_selected_organ
		. += "<tr>"
		. += "<td><a href='?src=[REF(src)];select_organ=[organ_key]' [is_selected && "class='linkOn'"]>[limb_info[1]]</a></td>"
		. += "<td>[limb_info[2]]</td>"
		. += "</tr>"
	. += "</table>"

	. += "<hr>"
	. += "<b>Limbs</b>"
	. += "<table>"
	for(var/limb_key in mob_species.has_limbs)
		var/limb_info = get_organ_info(limb_key)
		var/is_selected = limb_key == pref.ui_selected_organ
		. += "<tr>"
		. += "<td><a href='?src=[REF(src)];select_organ=[limb_key]' [is_selected && "class='linkOn'"]>[limb_info[1]]</a></td>"
		. += "<td>[limb_info[2]]</td>"
		. += "</tr>"
	. += "</table>"

	. += "</td><td>"
	. += "<b>Selected organ:</b> [pref.ui_selected_organ]<br>"
	. += show_organ_options(mob_species, pref.ui_selected_organ)
	. += "</td></tr></table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/augmentation/modification/proc/get_organ_info(organ_key)
	var/name = organ_key
	var/status
	switch(pref.organ_augmentation_data[organ_key])
		if(ORGAN_OPTION_CYBORG)
			var/datum/robolimb/R
			if(pref.robotic_limb_data[organ_key] && all_robolimbs[pref.robotic_limb_data[organ_key]])
				R = all_robolimbs[pref.robotic_limb_data[organ_key]]
			else
				R = basic_robolimb
			status = "\t[R.company] prosthesis"
		else
			status = organ_option_names[pref.organ_augmentation_data[organ_key] || "null"]
	return list(name, status)

/datum/category_item/player_setup_item/augmentation/modification/proc/get_organ_options(datum/species/species_info, organ_key)
	var/is_full_cyborg = pref.organ_augmentation_data[BP_CHEST] == ORGAN_OPTION_CYBORG
	var/is_allowed_full_cyborg = !(species_info.spawn_flags & SPECIES_NO_FBP_CHARGEN)
	if (organ_key == "ALL")
		return list(ORGAN_OPTION_NORMAL = TRUE, ORGAN_OPTION_CYBORG = TRUE)
	if (organ_key in species_info.has_organ)
		if(organ_key == BP_BRAIN)
			return list(
				ORGAN_OPTION_NORMAL = !is_full_cyborg,
				ORGAN_OPTION_ASSISTED = is_full_cyborg,
				ORGAN_OPTION_SYNTHETIC = !is_allowed_full_cyborg,
			)
		if(organ_key in list(BP_POSIBRAIN, BP_OPTICS))
			return list(ORGAN_OPTION_NORMAL = TRUE)
		return list(
			ORGAN_OPTION_NORMAL = !is_full_cyborg,
			ORGAN_OPTION_ASSISTED = !is_full_cyborg,
			ORGAN_OPTION_SYNTHETIC = TRUE,
		)
	if (organ_key in species_info.has_limbs)
		if(organ_key in list(BP_HEAD, BP_GROIN))
			return list(ORGAN_OPTION_NORMAL = !is_full_cyborg, ORGAN_OPTION_CYBORG = TRUE)
		if(organ_key == BP_CHEST)
			return list(ORGAN_OPTION_NORMAL = TRUE, ORGAN_OPTION_CYBORG = TRUE)
		return list(
			ORGAN_OPTION_NORMAL = !is_full_cyborg,
			ORGAN_OPTION_AMPUTATED = TRUE,
			ORGAN_OPTION_CYBORG = TRUE,
		)
	return list()

/datum/category_item/player_setup_item/augmentation/modification/proc/get_cyborg_options(datum/species/species_info, organ_key)
	. = list()
	for(var/company in chargen_robolimbs)
		var/datum/robolimb/M = chargen_robolimbs[company]
		if(species_info in M.species_cannot_use)
			continue
		if(M.restricted_to.len && !(species_info in M.restricted_to))
			continue
		if(M.applies_to_part.len && !(organ_key in M.applies_to_part))
			continue
		.[company] = M

/datum/category_item/player_setup_item/augmentation/modification/proc/show_organ_options(datum/species/species_info, organ_key)
	. = list()
	. += "<table><tr><th></th></tr>"
	var/list/options = get_organ_options(species_info, organ_key)
	for(var/option in options)
		var/class = (!options[option] && "linkOff") || ""
		var/href = "set_organ=[organ_key];set_option=[option]"
		if(option == ORGAN_OPTION_CYBORG)
			var/cyborg_options = get_cyborg_options(species_info, organ_key)
			for(var/cyborg_option in cyborg_options)
				var/class_ = (pref.robotic_limb_data[organ_key] == cyborg_option && "linkOn") || class
				var/href_ = "[href];option_extra=[cyborg_option]"
				var/datum/robolimb/robot_limb_info = cyborg_options[cyborg_option]
				. += "<tr><td><a href='?src=[REF(src)];[href_]' class='[class_]'>[robot_limb_info.company]</a></td></tr>"
		else
			class = (pref.organ_augmentation_data[organ_key] == option && "linkOn") || class
			. += "<tr><td><a href='?src=[REF(src)];[href]' class='[class]'>[organ_option_names[option]]</a></td></tr>"
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/augmentation/modification/OnTopic(href, list/href_list, mob/user)
	if(href_list["toggle_stack"])
		pref.has_cortical_stack = !pref.has_cortical_stack
		return TRUE

	if(href_list["reset_limbs"])
		reset_limbs()
		return UPDATE_PREVIEW

	if(href_list["select_organ"])
		var/option = href_list["select_organ"]
		if (pref.ui_selected_organ == option)
			pref.ui_selected_organ = null
		else
			pref.ui_selected_organ = option
		return TRUE

	if(href_list["set_organ"])
		var/target = href_list["set_organ"]
		var/option = href_list["set_option"]
		var/extra = href_list["option_extra"]

		if(!(target || option) || !CanUseTopic(user))
			return FALSE

		var/datum/species/current_species = all_species[pref.species]
		var/list/valid_options = get_organ_options(current_species, target)
		if(!valid_options[option])
			return FALSE
		if(target in current_species.has_organ)
			pref.organ_augmentation_data[target] = option
			return TRUE
		if(target in current_species.has_limbs)
			if(set_limb_state(current_species, target, option, extra))
				return UPDATE_PREVIEW
			return FALSE
		CRASH("Unknown unsanitized target value [target], with option: [option] and extra: [extra]")
	return ..()

/datum/category_item/player_setup_item/augmentation/modification/proc/set_limb_state(datum/species/species_info, organ_tag, new_state, extra)
	var/limb = organ_tag
	var/second_limb = null // if you try to change the arm, the hand should also change
	var/third_limb = null  // if you try to unchange the hand, the arm should also change

	switch(limb)
		if(BP_L_LEG)
			second_limb = BP_L_FOOT
		if(BP_R_LEG)
			second_limb = BP_R_FOOT
		if(BP_L_ARM)
			second_limb = BP_L_HAND
		if(BP_R_ARM)
			second_limb = BP_R_HAND
		if(BP_L_FOOT)
			third_limb = BP_L_LEG
		if(BP_R_FOOT)
			third_limb = BP_R_LEG
		if(BP_L_HAND)
			third_limb = BP_L_ARM
		if(BP_R_HAND)
			third_limb = BP_R_ARM
		if(BP_HEAD)
			third_limb = BP_CHEST
		if(BP_CHEST)
			third_limb =  BP_GROIN
		if("ALL")
			limb = BP_CHEST
			third_limb = BP_GROIN

	if(new_state == "null")
		new_state = null

	switch(new_state)
		if(ORGAN_OPTION_NORMAL)
			if(limb == BP_CHEST)
				for(var/other_limb in (BP_ALL_LIMBS - BP_CHEST))
					pref.organ_augmentation_data[other_limb] = ORGAN_OPTION_NORMAL
					pref.robotic_limb_data[other_limb] = null
					for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS,BP_BRAIN))
						pref.organ_augmentation_data[internal_organ] = ORGAN_OPTION_NORMAL
			pref.organ_augmentation_data[limb] = ORGAN_OPTION_NORMAL
			pref.robotic_limb_data[limb] = null
			if(third_limb)
				pref.organ_augmentation_data[third_limb] = ORGAN_OPTION_NORMAL
				pref.robotic_limb_data[third_limb] = null
			return TRUE
		if(ORGAN_OPTION_AMPUTATED)
			if(limb == BP_CHEST)
				return FALSE
			pref.organ_augmentation_data[limb] = ORGAN_OPTION_AMPUTATED
			pref.robotic_limb_data[limb] = null
			if(second_limb)
				pref.organ_augmentation_data[second_limb] = ORGAN_OPTION_AMPUTATED
				pref.robotic_limb_data[second_limb] = null
			return TRUE
		if(ORGAN_OPTION_CYBORG)
			var/choice = extra
			var/valid_options = get_cyborg_options(species_info, limb)
			if(!valid_options[choice])
				return FALSE

			pref.robotic_limb_data[limb] = choice
			pref.organ_augmentation_data[limb] = ORGAN_OPTION_CYBORG
			if(second_limb)
				var/before = pref.organ_augmentation_data[second_limb]
				if(before != ORGAN_OPTION_CYBORG)
					pref.organ_augmentation_data[second_limb] = ORGAN_OPTION_CYBORG
					pref.robotic_limb_data[second_limb] = choice
			if(third_limb && pref.organ_augmentation_data[third_limb] == ORGAN_OPTION_AMPUTATED)
				pref.organ_augmentation_data[third_limb] = ORGAN_OPTION_CYBORG
				pref.robotic_limb_data[third_limb] = choice

			if(limb in list(BP_CHEST, BP_HEAD))
				for(var/other_limb in BP_ALL_LIMBS - limb)
					var/before = pref.organ_augmentation_data[other_limb]
					if(before != ORGAN_OPTION_CYBORG)
						pref.organ_augmentation_data[other_limb] = ORGAN_OPTION_CYBORG
						pref.robotic_limb_data[other_limb] = choice
				if(!pref.organ_augmentation_data[BP_BRAIN])
					if(BP_BRAIN in species_info.has_organ)
						pref.organ_augmentation_data[BP_BRAIN] = ORGAN_OPTION_ASSISTED
				for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
					if(internal_organ in species_info.has_organ)
						pref.organ_augmentation_data[internal_organ] = ORGAN_OPTION_SYNTHETIC
			return TRUE

/datum/category_item/player_setup_item/augmentation/modification/proc/reset_limbs()
	pref.organ_augmentation_data.Cut()
	pref.robotic_limb_data.Cut()
