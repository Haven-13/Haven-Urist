/datum/job/submap
	title = "Survivor"
	supervisors = "your conscience"
	account_allowed = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	create_record = FALSE
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/assistant
	hud_icon = "hudblank"

	var/info = "You have survived a terrible disaster. Make the best of things that you can."
	var/rank
	var/branch
	var/list/spawnpoints
	var/datum/submap/owner
	var/list/blacklisted_species
	var/list/whitelisted_species

/datum/job/submap/New(datum/submap/_owner)
	spawnpoints = list()
	owner = _owner
	..()

/datum/job/submap/is_restricted(datum/preferences/prefs, feedback)
	if(minimum_character_age && (prefs.age < minimum_character_age))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age].</span>")
		return TRUE
	if(LAZY_LENGTH(whitelisted_species) && !(prefs.species in whitelisted_species))
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as crew on \a [owner.archetype.descriptor].</span>")
		return TRUE
	if(prefs.species in blacklisted_species)
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as crew on \a [owner.archetype.descriptor].</span>")
		return TRUE
	return FALSE

/datum/job/submap/check_is_active(mob/M)
	. = (..() && M.faction == owner.name)
