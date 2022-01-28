/proc/read_global(name)
	. = global.vars[name]

/proc/write_global(name, value)
	global.vars[name] = value

/proc/get_global_keys()
	. = list()
	for(var/k in global.vars)
		. += k

/decl/global_vars/get_view_variables_header()
	return "<b>Global Variables</b>"

/decl/global_vars/get_view_variables_options()
	return "" // Ensuring changes to the base proc never affect us

/decl/global_vars/get_variables()
	. = get_global_keys() - VV_hidden()
	if(!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		. -= VV_secluded()

/decl/global_vars/get_variable_value(varname)
	. = read_global(varname)

/decl/global_vars/set_variable_value(varname, value)
	write_global(varname, value)

/decl/global_vars/make_view_variables_variable_entry(varname, value)
	return "(<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=[varname]'>E</a>) "

/decl/global_vars/VV_locked()
	return vars

/decl/global_vars/VV_hidden()
	return list("forumsqladdress",
				"forumsqldb",
				"forumsqllogin",
				"forumsqlpass",
				"forumsqlport",
				"sqladdress",
				"sqldb",
				"sqlfdbkdb",
				"sqlfdbklogin",
				"sqlfdbkpass",
				"sqllogin",
				"sqlpass",
				"sqlport",
				"comms_password",
				"ban_comms_password",
				"login_export_addr"
			)

/client/proc/debug_global_variables()
	set category = "Debug"
	set name = "View Global Variables"

	// Just fyi, this gets added to the global object, so at least
	// keep the names unique when you do this or the first instance
	// will be shown for all global/static variables sharing the same name
	var/static/decl/global_vars/global_vars_
	if(!global_vars_)
		global_vars_ = new()
	debug_variables(global_vars_)
