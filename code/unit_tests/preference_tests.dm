/datum/unit_test/preferences_save_parity
	name = "PREFERENCES: Savefile Save/Load Parity"

	var/list/key_ignore_list = list(
		"type",
		"parent",
		"weakref",
		"vars",
	)

/datum/unit_test/preferences_save_parity/start_test()
	var/datum/preferences/P = new(null)

	var/list/before_load = P.vars.Copy()
	P.Topic(null, list("save" = TRUE))

	P.Topic(null, list("reload" = TRUE))
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
		else
			pass("Save field OK: variable: '[key]', default value: [before]")

	before_load.Cut()
	after_load.Cut()

	return !bad
