#define EAT_MOB_DELAY 300 // 30s

//genetics powers, ported from vg who took them from goon

// WAS: /datum/bioEffect/alcres
/datum/dna/gene/basic/sober
	name="Sober"
	activation_messages=list("You feel unusually sober.")
	deactivation_messages = list("You feel like you could use a stiff drink.")

	mutation=M_SOBER

/datum/dna/gene/basic/sober/New()
	block=SOBERBLOCK

//WAS: /datum/bioEffect/psychic_resist
/datum/dna/gene/basic/psychic_resist
	name="Psy-Resist"
	desc = "Boosts efficiency in sectors of the brain commonly associated with meta-mental energies."
	activation_messages = list("Your mind feels closed.")
	deactivation_messages = list("You feel oddly exposed.")

	mutation=M_PSY_RESIST

/datum/dna/gene/basic/psychic_resist/New()
	block=PSYRESISTBLOCK

/////////////////////////
// Stealth Enhancers
/////////////////////////

/datum/dna/gene/basic/stealth/can_activate(var/mob/M, var/flags)
	// Can only activate one of these at a time.
	if(is_type_in_list(/datum/dna/gene/basic/stealth,M.active_genes))
		testing("Cannot activate [type]: /datum/dna/gene/basic/stealth in M.active_genes.")
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/stealth/deactivate(var/mob/M)
	..(M)
	M.alpha=255

// WAS: /datum/bioEffect/darkcloak
/datum/dna/gene/basic/stealth/darkcloak
	name = "Cloak of Darkness"
	desc = "Enables the subject to bend low levels of light around themselves, creating a cloaking effect."
	activation_messages = list("You begin to fade into the shadows.")
	deactivation_messages = list("You become fully visible.")

/datum/dna/gene/basic/stealth/darkcloak/New()
	block=SHADOWBLOCK

/datum/dna/gene/basic/stealth/darkcloak/OnMobLife(var/mob/M)
	if(is_turf(M.loc))
		var/turf/T = M.loc
		if(shadow_check(T, 2, 1))
			M.alpha = 0
		else
			M.alpha = round(255 * 0.80)
	else
		M.alpha = round(255 * 0.80)
