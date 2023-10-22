
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0,damagetype = DAMAGE_TYPE_BRUTE, def_zone = null, blocked = 0, damage_flags = 0, used_weapon = null)
	if(!damage || (blocked >= 100))	return 0
	switch(damagetype)
		if(DAMAGE_TYPE_BRUTE)
			adjustBruteLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_BURN)
			if(COLD_RESISTANCE in mutations)	damage = 0
			adjustFireLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_TOXIN)
			adjustToxLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_ASPHYXIA)
			adjustOxyLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_GENETIC)
			adjustCloneLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_PAIN)
			adjustHalLoss(damage * blocked_mult(blocked))
		if(DAMAGE_TYPE_SHOCK)
			electrocute_act(damage, used_weapon, 1.0, def_zone)

	updatehealth()
	return 1


/mob/living/proc/apply_damages(brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, halloss = 0, def_zone = null, blocked = 0, damage_flags = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, DAMAGE_TYPE_BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, DAMAGE_TYPE_BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, DAMAGE_TYPE_TOXIN, def_zone, blocked)
	if(oxy)		apply_damage(oxy, DAMAGE_TYPE_ASPHYXIA, def_zone, blocked)
	if(clone)	apply_damage(clone, DAMAGE_TYPE_GENETIC, def_zone, blocked)
	if(halloss) apply_damage(halloss, DAMAGE_TYPE_PAIN, def_zone, blocked)
	return 1


/mob/living/proc/apply_effect(effect = 0,effecttype = DAMAGE_TYPE_STUN, blocked = 0)
	if(!effect || (blocked >= 100))	return 0

	switch(effecttype)
		if(DAMAGE_TYPE_STUN)
			Stun(effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_WEAKEN)
			Weaken(effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_PARALYZE)
			Paralyse(effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_PAIN)
			adjustHalLoss(effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_RADIATION)
			radiation += effect * blocked_mult(blocked)
		if(DAMAGE_TYPE_STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				stuttering = max(stuttering, effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_EYE_BLUR)
			eye_blurry = max(eye_blurry, effect * blocked_mult(blocked))
		if(DAMAGE_TYPE_EXHAUST)
			drowsyness = max(drowsyness, effect * blocked_mult(blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(stun = 0, weaken = 0, paralyze = 0, irradiate = 0, stutter = 0, eyeblur = 0, drowsy = 0, agony = 0, blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun,      DAMAGE_TYPE_STUN, blocked)
	if(weaken)		apply_effect(weaken,    DAMAGE_TYPE_WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze,  DAMAGE_TYPE_PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, DAMAGE_TYPE_RADIATION, blocked)
	if(stutter)		apply_effect(stutter,   DAMAGE_TYPE_STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur,   DAMAGE_TYPE_EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DAMAGE_TYPE_EXHAUST, blocked)
	if(agony)		apply_effect(agony,     DAMAGE_TYPE_PAIN, blocked)
	return 1
