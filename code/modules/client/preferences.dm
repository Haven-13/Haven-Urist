#define SAVE_RESET -1

var/list/preferences_datums = list()

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	//tgui preferences
	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/preferences_ui/ui_holder

/datum/preferences/New(client/C)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)
	blood_type = RANDOM_BLOOD_TYPE

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/proc/load_and_update_character(slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	player_setup.setup_character(character, is_preview_copy)

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_body(0)
	character.update_underwear(0)
	character.update_hair(0)
	character.update_icons()

/datum/preferences/proc/get_ui()
	RETURN_TYPE(/datum/preferences_ui)
	if (!src.ui_holder)
		src.ui_holder = new (src)
	return src.ui_holder
