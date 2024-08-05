/datum/unit_test/preferences_sanity
	name = "PREFERENCES: Savefile Sanity"
	var/list/key_ignore_list

/datum/unit_test/preferences_sanity/New()
	key_ignore_list = list(
		"client",              // client
		"client_ckey",         // client
		"last_id",             // administrative action
		"last_ip",             // administrative action
		"loaded_preferences",  // savefile
		"loaded_character",    // savefile
		"muted",               // administrative action
		"path",                // savefile
		"player_setup",        // player UI
		"ui_holder",           // player UI
		"warns",               // administrative action
	)
	var/datum/D = new()
	for(var/key in D.vars)
		key_ignore_list.Add(key)
	qdel(D)

/datum/unit_test/preferences_sanity/start_test()
	var/datum/preferences/P = new(null)
	P.load_path("test")

	P.save()
	var/list/before_load = deepCopyList(P.vars)

	if(!fexists(P.path))
		fail("Failed to save to [P.path]")
		return FALSE
	pass("Test save located at [P.path]")

	// Corrupt the preferences to prevent same values from staying between saving and loading
	for(var/key in P.vars)
		if(key in key_ignore_list)
			continue
		if(is_list(P.vars[key]))
			var/list/L = P.vars[key]
			L.Cut()
		else
			P.vars[key] = rand(1024, 999999)

	P.reload()
	var/list/after_load = P.vars.Copy()

	var/before
	var/after
	var/bad = FALSE
	for (var/key in P.vars)
		if(key in key_ignore_list)
			continue

		before = before_load[key]
		after = after_load[key]
		if(islist(before) && islist(after))
			var/diff = difflist(before, after)
			if (length(diff))
				log_bad("Save field mismatch: variable '[key]', lists differ: [english_list(diff)]")
				bad = TRUE
			continue
		if (before != after)
			log_bad("Save field mismatch: variable: '[key]', before: [before], after: [after]")
			bad = TRUE

	before_load.Cut()
	after_load.Cut()

	if (bad)
		fail("Not all save fields could not be correctly saved or loaded.")
	else
		pass("All save fields could be properly saved and loaded.")
	return !bad
