var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/species = SPECIES_HUMAN
	var/blood_type = "A+"				//Blood type (not-chooseable)
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color

	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color

	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color

	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color

	var/s_base = ""						//Base skin colour
	var/list/body_markings = list()
	var/list/body_descriptors = list()

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/disabilities = 0

/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2
	var/hide_species = TRUE

/datum/category_item/player_setup_item/physical/body/load_character(savefile/S)
	from_file(S["species"], pref.species)

	from_file(S["hair/style_name"], pref.h_style)
	from_file(S["hair/red"], pref.r_hair)
	from_file(S["hair/green"], pref.g_hair)
	from_file(S["hair/blue"], pref.b_hair)

	from_file(S["facial/style_name"], pref.f_style)
	from_file(S["facial/red"], pref.r_facial)
	from_file(S["facial/green"], pref.g_facial)
	from_file(S["facial/blue"], pref.b_facial)

	from_file(S["skin/tone"], pref.s_tone)
	from_file(S["skin/base"], pref.s_base)
	from_file(S["skin/red"], pref.r_skin)
	from_file(S["skin/green"], pref.g_skin)
	from_file(S["skin/blue"], pref.b_skin)

	from_file(S["eyes/red"], pref.r_eyes)
	from_file(S["eyes/green"], pref.g_eyes)
	from_file(S["eyes/blue"], pref.b_eyes)

	from_file(S["blood_type"], pref.blood_type)
	from_file(S["body_markings"], pref.body_markings)
	from_file(S["body_descriptors"], pref.body_descriptors)

	from_file(S["disabilities"], pref.disabilities)

/datum/category_item/player_setup_item/physical/body/save_character(savefile/S)
	to_file(S["species"], pref.species)

	to_file(S["hair/style_name"],pref.h_style)
	to_file(S["hair/red"], pref.r_hair)
	to_file(S["hair/green"], pref.g_hair)
	to_file(S["hair/blue"], pref.b_hair)

	to_file(S["facial/style_name"],pref.f_style)
	to_file(S["facial/red"], pref.r_facial)
	to_file(S["facial/green"], pref.g_facial)
	to_file(S["facial/blue"], pref.b_facial)

	to_file(S["skin/tone"], pref.s_tone)
	to_file(S["skin/base"], pref.s_base)
	to_file(S["skin/red"], pref.r_skin)
	to_file(S["skin/green"], pref.g_skin)
	to_file(S["skin/blue"], pref.b_skin)

	to_file(S["eyes/red"], pref.r_eyes)
	to_file(S["eyes/green"], pref.g_eyes)
	to_file(S["eyes/blue"], pref.b_eyes)

	to_file(S["blood_type"], pref.blood_type)
	to_file(S["body_markings"], pref.body_markings)
	to_file(S["body_descriptors"], pref.body_descriptors)

	to_file(S["disabilities"], pref.disabilities)

/datum/category_item/player_setup_item/physical/body/setup_character(mob/living/carbon/human/character, is_preview_copy = FALSE)
	character.set_species(pref.species)

	character.blood_type = pref.blood_type

	character.r_eyes = pref.r_eyes
	character.g_eyes = pref.g_eyes
	character.b_eyes = pref.b_eyes

	character.h_style = pref.h_style
	character.r_hair = pref.r_hair
	character.g_hair = pref.g_hair
	character.b_hair = pref.b_hair

	character.f_style = pref.f_style
	character.r_facial = pref.r_facial
	character.g_facial = pref.g_facial
	character.b_facial = pref.b_facial

	character.r_skin = pref.r_skin
	character.g_skin = pref.g_skin
	character.b_skin = pref.b_skin

	character.s_tone = pref.s_tone
	character.s_base = pref.s_base

	character.h_style = pref.h_style
	character.f_style = pref.f_style

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	for(var/M in pref.body_markings)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.body_marking_styles_list[M]
		var/mark_color = "[pref.body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	if (is_preview_copy)
		return

	if(LAZY_LENGTH(character.descriptors))
		for(var/entry in pref.body_descriptors)
			character.descriptors[entry] = pref.body_descriptors[entry]

/datum/category_item/player_setup_item/physical/body/sanitize_character(savefile/S)
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style		= sanitize_inlist(pref.h_style, GLOB.hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, GLOB.facial_hair_styles_list, initial(pref.f_style))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.blood_type			= sanitize_text(pref.blood_type, initial(pref.blood_type))

	if(!pref.species || !(pref.species in playable_species))
		pref.species = SPECIES_HUMAN

	var/datum/species/mob_species = all_species[pref.species]
	if(mob_species && mob_species.spawn_flags & SPECIES_NO_LACE)
		pref.has_cortical_stack = FALSE

	var/low_skin_tone = mob_species ? (35 - mob_species.max_skin_tone()) : -185
	sanitize_integer(pref.s_tone, low_skin_tone, 34, initial(pref.s_tone))

	if(!mob_species.base_skin_colours || isnull(mob_species.base_skin_colours[pref.s_base]))
		pref.s_base = ""

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!istype(pref.body_markings))
		pref.body_markings = list()
	else
		pref.body_markings &= GLOB.body_marking_styles_list

	var/list/last_descriptors = list()
	if(is_list(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	if(LAZY_LENGTH(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = clamp(last_descriptors[entry], 1, LAZY_LENGTH(descriptor.standalone_value_descriptors))

/datum/category_item/player_setup_item/physical/body/content(mob/user)
	. = list()

	var/datum/species/mob_species = all_species[pref.species]
	var/title = "<b>Species<a href='?src=[REF(src)];show_species=1'><small>?</small></a>:</b> <a href='?src=[REF(src)];set_species=1'>[mob_species.name]</a>"
	var/append_text = "<a href='?src=[REF(src)];toggle_species_verbose=1'>[hide_species ? "Expand" : "Collapse"]</a>"
	. += "<hr>"
	. += mob_species.get_description(title, append_text, verbose = !hide_species, skip_detail = TRUE, skip_photo = TRUE)
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=[REF(src)];random=1'>&reg;</A>)"
	. += "<br>"

	. += "Blood Type: <a href='?src=[REF(src)];blood_type=1'>[pref.blood_type]</a><br>"

	if(has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
		. += "Base Colour: <a href='?src=[REF(src)];base_skin=1'>[pref.s_base]</a><br>"

	if(has_flag(mob_species, HAS_A_SKIN_TONE))
		. += "Skin Tone: <a href='?src=[REF(src)];skin_tone=1'>[-pref.s_tone + 35]/[mob_species.max_skin_tone()]</a><br>"

	. += "Needs Glasses: <a href='?src=[REF(src)];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"

	if(LAZY_LENGTH(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=[REF(src)];change_descriptor=[entry]'>Change</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=[REF(src)];hair_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair)]'><tr><td>__</td></tr></table></font> "
	. += " Style: <a href='?src=[REF(src)];hair_style=1'>[pref.h_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=[REF(src)];facial_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial)]'><tr><td>__</td></tr></table></font> "
	. += " Style: <a href='?src=[REF(src)];facial_style=1'>[pref.f_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=[REF(src)];eye_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes)]'><tr><td>__</td></tr></table></font><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=[REF(src)];skin_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin)]'><tr><td>__</td></tr></table></font><br>"

	. += "<br><a href='?src=[REF(src)];marking_style=1'>Body Markings +</a><br>"
	for(var/M in pref.body_markings)
		. += "[M] <a href='?src=[REF(src)];marking_remove=[M]'>-</a> <a href='?src=[REF(src)];marking_color=[M]'>Color</a>"
		. += "<font face='fixedsys' size='3' color='[pref.body_markings[M]]'><table style='display:inline;' bgcolor='[pref.body_markings[M]]'><tr><td>__</td></tr></table></font>"
		. += "<br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/body/proc/has_flag(datum/species/mob_species, flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(href,list/href_list, mob/user)

	var/datum/species/mob_species = all_species[pref.species]
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TRUE

	else if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = input("Please select a descriptor.", "Descriptor") as null|anything in descriptor.chargen_value_descriptors
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TRUE

	else if(href_list["blood_type"])
		var/new_blood_type = input(user, "Choose your character's blood-type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in valid_bloodtypes
		if(new_blood_type && CanUseTopic(user))
			pref.blood_type = new_blood_type
			return TRUE

	else if(href_list["show_species"])
		var/choice = input("Which species would you like to look at?") as null|anything in playable_species
		if(choice)
			var/datum/species/current_species = all_species[choice]
			show_browser(user, current_species.get_description(), "window=species;size=700x400")
			return FALSE

	else if(href_list["set_species"])

		var/list/species_to_pick = list()
		for(var/species in playable_species)
			if(!check_rights(R_ADMIN, 0) && config.usealienwhitelist)
				var/datum/species/current_species = all_species[species]
				if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
					continue
				else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
					continue
			species_to_pick += species

		var/choice = input("Select a species to play as.") as null|anything in species_to_pick
		if(!choice || !(choice in all_species))
			return

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = all_species[pref.species]
			on_species_change(mob_species)
			return UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return FALSE
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		var/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in valid_hairstyles

		mob_species = all_species[pref.species]
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return FALSE
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return FALSE
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(all_species[pref.species], HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return UPDATE_PREVIEW

	else if(href_list["base_skin"])
		if(!has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
			return FALSE
		var/new_s_base = input(user, "Choose your character's base colour:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in mob_species.base_skin_colours
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_A_SKIN_TONE))
			return FALSE
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to [mob_species.max_skin_tone()]", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.s_tone) + 35) as num|null
		mob_species = all_species[pref.species]
		if(new_s_tone && has_flag(mob_species, HAS_A_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min(round(new_s_tone), mob_species.max_skin_tone()), 1)
		return UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return FALSE
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(all_species[pref.species], HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

		var/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.f_style)  as null|anything in valid_facialhairstyles

		mob_species = all_species[pref.species]
		if(new_f_style && CanUseTopic(user) && mob_species.get_facial_hair_styles(pref.gender))
			pref.f_style = new_f_style
			return UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings.Copy() ^ GLOB.body_marking_styles_list.Copy()
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(!S.species_allowed.len)
				continue
			else if(!(pref.species in S.species_allowed))
				usable_markings -= M

		var/new_marking = input(user, "Choose a body marking:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return UPDATE_PREVIEW

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/physical/body/proc/on_species_change(datum/species/new_species)
	if(!(pref.gender in new_species.genders))
		pref.gender = new_species.genders[1]

	ResetAllHair()

	//reset hair colour and skin colour
	pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
	pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
	pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
	pref.s_tone = 0
	pref.age = max(min(pref.age, new_species.max_age), new_species.min_age)

	pref.body_markings.Cut() // Basically same as above.

	var/datum/category_collection/player_setup_collection/pref_collection = pref.player_setup
	var/datum/category_group/player_setup_category/augmentation_preferences/pref_aug = pref_collection.categories_by_name["Augmentation"]
	var/datum/category_item/player_setup_item/augmentation/modification/mod = pref_aug.items_by_name["Modification"]
	mod.reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.

	prune_occupation_prefs()

	pref.cultural_info = new_species.default_cultural_info.Copy()
	//So you want to check your languages huh?
	var/datum/category_group/player_setup_category/background_preferences/pref_background = pref_collection.categories_by_name["Background"]
	var/datum/category_item/player_setup_item/background/languages/endless_accesses = pref_background.items_by_name["Languages"]
	endless_accesses.sanitize_alt_languages()

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.h_style = GLOB.hair_styles_list["Bald"]

/datum/category_item/player_setup_item/proc/ResetFacialHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

	if(valid_facialhairstyles.len)
		pref.f_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.f_style = GLOB.facial_hair_styles_list["Shaved"]
