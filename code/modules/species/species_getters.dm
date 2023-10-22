/datum/species/proc/get_valid_shapeshifter_forms(mob/living/carbon/human/H)
	return list()

/datum/species/proc/get_additional_examine_text(mob/living/carbon/human/H)
	return

/datum/species/proc/get_tail(mob/living/carbon/human/H)
	return tail

/datum/species/proc/get_tail_animation(mob/living/carbon/human/H)
	return tail_animation

/datum/species/proc/get_tail_hair(mob/living/carbon/human/H)
	return tail_hair

/datum/species/proc/get_blood_mask(mob/living/carbon/human/H)
	return blood_mask

/datum/species/proc/get_damage_overlays(mob/living/carbon/human/H)
	return damage_overlays

/datum/species/proc/get_damage_mask(mob/living/carbon/human/H)
	return damage_mask

/datum/species/proc/get_examine_name(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_icobase(mob/living/carbon/human/H, get_deform)
	return (get_deform ? deform : icobase)

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_race_key(mob/living/carbon/human/H)
	return race_key

/datum/species/proc/get_bodytype(mob/living/carbon/human/H)
	return name

/datum/species/proc/get_knockout_message(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "encounters a hardware fault and suddenly reboots!" : knockout_message)

/datum/species/proc/get_death_message(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "gives one shrill beep before falling lifeless." : death_message)

/datum/species/proc/get_ssd(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? "flashing a 'system offline' glyph on their monitor" : show_ssd)

/datum/species/proc/get_blood_colour(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_BLOOD_COLOUR : blood_color)

/datum/species/proc/get_virus_immune(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? 1 : virus_immune)

/datum/species/proc/get_flesh_colour(mob/living/carbon/human/H)
	return ((H && H.isSynthetic()) ? SYNTH_FLESH_COLOUR : flesh_color)

/datum/species/proc/get_environment_discomfort(mob/living/carbon/human/H, msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.l_hand == clothes || H.r_hand == clothes)
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				to_chat(H, "<span class='danger'>[pick(cold_discomfort_strings)]</span>")
		if("heat")
			if(covered)
				to_chat(H, "<span class='danger'>[pick(heat_discomfort_strings)]</span>")

/datum/species/proc/get_vision_flags(mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/get_husk_icon(mob/living/carbon/human/H)
	return husk_icon