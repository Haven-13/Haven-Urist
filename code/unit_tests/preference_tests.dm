/datum/unit_test/preferences_sanity
	name = "PREFERENCES: Savefile Sanity"
	var/list/key_ignore_list

/datum/unit_test/preferences_sanity/New()
	key_ignore_list = list(
		"client",
		"client_ckey",
		"path",
		"ui_holder",
		"player_setup",
	)
	var/datum/D = new()
	for(var/key in D.vars)
		key_ignore_list.Add(key)
	qdel(D)

/datum/unit_test/preferences_sanity/start_test()
	var/datum/preferences/P = new(null)
	P.load_path("test")

	P.save()
	var/list/before_load = P.vars.Copy()

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
		if(before != after)
			fail("Save field mismatch: variable: '[key]', before: [before], after: [after]")
			bad = TRUE

	before_load.Cut()
	after_load.Cut()

	if (bad)
		fail("Not all save fields could not be correctly saved or loaded.")
	else
		pass("All save fields could be properly saved and loaded.")
	return !bad
