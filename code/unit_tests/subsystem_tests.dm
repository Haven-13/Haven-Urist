/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls
	name = "SUBSYSTEM - ATOMS: Shall have no bad init calls"

/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls/start_test()
	if(SSatoms.BadInitializeCalls.len)
		for(var/line in splittext_char(SSatoms.InitLog(), "\n"))
			if(line) log_bad(line)
		fail("[SSatoms] had bad initialization calls.")
	else
		pass("[SSatoms] had no bad initialization calls.")
	return 1

/datum/unit_test/subsystem_shall_be_initialized
	name = "SUBSYSTEM - INIT: Shall be initalized"

/datum/unit_test/subsystem_shall_be_initialized/start_test()
	var/list/bad_subsystems = list()
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if (SS.flags & SS_NO_INIT)
			continue
		if(!SS.initialized)
			bad_subsystems += SS.type

	if(bad_subsystems.len)
		fail("Found improperly initialized subsystems: [english_list(bad_subsystems)]")
	else
		pass("All subsystems have initialized properly")

	return 1

// Unit test to ensure SS metrics are valid
/datum/unit_test/subsystem_metric_sanity
	name = "SUBSYSTEM - METRICS: Shall have sane valid metrics JSON"
	var/failures = 0

/datum/unit_test/subsystem_metric_sanity/proc/log_fail(msg)
	log_bad(msg)
	failures += 1

/datum/unit_test/subsystem_metric_sanity/start_test()
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		var/list/data = SS.get_metrics()
		if(length(data) != 3)
			log_fail("SS[SS.ss_id] has invalid metrics data!")
			continue
		if(isnull(data["cost"]))
			log_fail("SS[SS.ss_id] has invalid metrics data! No 'cost' found in [json_encode(data)]")
			continue
		if(isnull(data["tick_usage"]))
			log_fail("SS[SS.ss_id] has invalid metrics data! No 'tick_usage' found in [json_encode(data)]")
			continue
		if(isnull(data["custom"]))
			log_fail("SS[SS.ss_id] has invalid metrics data! No 'custom' found in [json_encode(data)]")
			continue
		if(!is_list(data["custom"]))
			log_fail("SS[SS.ss_id] has invalid metrics data! 'custom' is not a list in [json_encode(data)]")
			continue
	if(failures)
		fail("#[failures] subsystem(s) have invaild metrics JSON")
	else
		pass("All subsystems have valid JSON")
	return 1

/datum/unit_test/subsystem_uniqueness
	name = "SUBSYSTEM - METRICS: Shall have unique IDs"

/datum/unit_test/subsystem_uniqueness/start_test()
	var/datum/controller/subsystem/S = new()
	var/bad_id = S.ss_id
	qdel(S)

	var/list/used_ids = list()
	var/failures = list()

	for(var/datum/controller/subsystem/SS in Master.subsystems)
		var/this_id = SS.ss_id
		if(this_id == bad_id)
			log_bad("[SS.type] uses the uninitialized ID '[bad_id]'!")
			failures[SS.type] = TRUE
		else if(this_id in used_ids)
			var/used_type = used_ids[this_id]
			var/this_type = SS.type
			if(this_type == used_type)
				log_bad("There are a duplicate of [this_type]!")
				failures[this_type] = TRUE
			else
				log_bad("[this_type] tried to take ID '[this_id]', already used by [used_type]!")
				failures[used_type] = TRUE
				failures[this_type] = TRUE
		else
			used_ids[this_id] = SS.type

	if(length(failures))
		fail("#[length(failures)] subsystem(s) are not unique")
	else
		pass("All subsystems are unique")
	return 1
