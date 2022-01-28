
/datum/unit_test/no_dupe_variables_test
	name = "GLOBALS: No duplicates must exist"

/datum/unit_test/no_dupe_variables_test/start_test()
	var/list/variable_name_count = list()
	var/total
	var/fails = 0
	for(var/variable in global.vars)
		if(!variable_name_count[variable])
			variable_name_count[variable] = 1
		else
			variable_name_count[variable] += 1

	for(var/variable in variable_name_count)
		var/count = variable_name_count[variable]
		if(count > 1)
			log_bad("Variable '[variable]' has [count] duplications!")
			fails += 1
		total += count

	if(fails)
		fail("[fails] out of [length(variable_name_count)] unique variables (total [total]) have duplicates. Please address these or the debugger and View-Variables will shit the bed.")
	else
		pass("All [length(variable_name_count)] passed the test.")
	return TRUE
