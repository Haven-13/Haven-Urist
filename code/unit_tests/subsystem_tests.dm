/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls
	name = "SUBSYSTEM - ATOMS: Shall have no bad init calls"

/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls/start_test()
	if(SSatoms.BadInitializeCalls.len)
		log_bad(jointext(SSatoms.InitLog(), null))
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
		if(!islist(data["custom"]))
			log_fail("SS[SS.ss_id] has invalid metrics data! 'custom' is not a list in [json_encode(data)]")
			continue
	if(failures)
		fail("#[failures] subsystem(s) have invaild metrics JSON")
	else
		pass("All subsystems have valid JSON")
	return 1
