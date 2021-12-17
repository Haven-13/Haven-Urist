/obj/aura/regenerating
	name = "regenerating aura"
	var/brute_mult = 1
	var/fire_mult = 1
	var/tox_mult = 1

/obj/aura/regenerating/life_tick()
	user.adjustBruteLoss(-brute_mult)
	user.adjustFireLoss(-fire_mult)
	user.adjustToxLoss(-tox_mult)

/obj/aura/regenerating/human
	var/nutrition_damage_mult = 1 //How much nutrition it takes to heal regular damage
	var/organ_mult = 2
	var/regen_message = "<span class='warning'>Your body throbs as you feel your ORGAN regenerate.</span>"
	var/grow_chance = 0
	var/grow_threshold = 0
	var/ignore_tag//organ tag to ignore


/obj/aura/regenerating/human/proc/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	return

/obj/aura/regenerating/human/life_tick()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		CRASH("Someone gave [user.type] a [src.type] aura. This is invalid.")
		return 0
	if(!H.innate_heal || H.InStasis() || H.stat == DEAD)
		return 0

	if(brute_mult && H.getBruteLoss())
		H.adjustBruteLoss(-brute_mult * config.organ_regeneration_multiplier)
		H.nutrition -= nutrition_damage_mult
	if(fire_mult && H.getFireLoss())
		H.adjustFireLoss(-fire_mult * config.organ_regeneration_multiplier)
		H.nutrition -= nutrition_damage_mult
	if(tox_mult && H.getToxLoss())
		H.adjustToxLoss(-tox_mult * config.organ_regeneration_multiplier)
		H.nutrition -= nutrition_damage_mult

	if(organ_mult)
		if(prob(10) && H.nutrition >= 150 && !H.getBruteLoss() && !H.getFireLoss())
			var/obj/item/organ/external/head/D = H.organs_by_name["head"]
			if (D.status & ORGAN_DISFIGURED)
				D.status &= ~ORGAN_DISFIGURED
				H.nutrition -= 20

		for(var/bpart in shuffle(H.internal_organs_by_name - BP_BRAIN))
			var/obj/item/organ/internal/regen_organ = H.internal_organs_by_name[bpart]
			if(BP_IS_ROBOTIC(regen_organ))
				continue
			if(istype(regen_organ))
				if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
					regen_organ.damage = max(regen_organ.damage - organ_mult, 0)
					H.nutrition -= organ_mult
					if(prob(5))
						to_chat(H, replacetext(regen_message,"ORGAN", regen_organ.name))

	if(prob(grow_chance) && H.nutrition > grow_threshold)
		for(var/limb_type in H.species.has_limbs)
			var/obj/item/organ/external/E = H.organs_by_name[limb_type]
			if(E && E.organ_tag != BP_HEAD && !(E.organ_tag == BP_GROIN && !E.is_stump()) && !E.vital && !E.is_usable())	//Skips heads and vital bits...
				E.removed()			//...because no one wants their head to explode to make way for a new one.
				qdel(E)
				E= null
			if(!E)
				var/list/organ_data = H.species.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/external/O = new limb_path(H)
				external_regeneration_effect(O,H)
				organ_data["descriptor"] = O.name
				H.update_body()
				return
			else
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						E.wounds -= W
	return 1
