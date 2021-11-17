SUBSYSTEM_DEF(strings)
	name = "Strings"
	init_order = SS_INIT_STRINGS
	flags = SS_NO_FIRE

	var/list/string_list_by_name = list()
	var/list/string_list_sources = list()
	var/list/already_loaded_files = list()

	var/string_listing/listing

/datum/controller/subsystem/strings/Initialize()
	listing = new/string_listing()
	. = ..()

/datum/controller/subsystem/strings/proc/fetch_strings_json(strings_file, strings_name)
	if(!LAZY_IS_IN(already_loaded_files, strings_file))
		return load_strings_json(strings_file)[strings_name]
	return string_list_by_name[strings_name]

/datum/controller/subsystem/strings/proc/fetch_strings(strings_file, strings_name)
	if(!LAZY_IS_IN(already_loaded_files, strings_file))
		return load_strings_txt(strings_name, strings_file)
	return string_list_by_name[strings_name]

/datum/controller/subsystem/strings/proc/load_strings_json(strings_file)
	var/list/json_data = json_decode(file2text(strings_file))
	for (var/key in json_data)
		LAZY_ADD_UNIQUE(string_list_by_name[key], json_data[key])
		LAZY_ADD_UNIQUE(string_list_sources[key], strings_file)
	LAZY_ADD_UNIQUE(already_loaded_files, strings_file)
	return json_data

/datum/controller/subsystem/strings/proc/load_strings_txt(strings_name, strings_file)
	var/list/strings = file2list(strings_file)
	LAZY_ADD_UNIQUE(string_list_by_name[strings_name], strings)
	LAZY_ADD_UNIQUE(string_list_sources[strings_name], strings_file)
	LAZY_ADD_UNIQUE(already_loaded_files, strings_file)
	return string_list_by_name[strings_name]

/datum/controller/subsystem/strings/proc/create_list(strings_name, string_list, strings_source = "<<Runtime>>")
	if(LAZY_IS_IN(string_list_by_name, strings_name))
		. = FALSE
		CRASH("Attempted to create string listing '[strings_name]', but it already exists!")
	return append_list(strings_name, string_list, strings_source, FALSE)

/datum/controller/subsystem/strings/proc/append_list(strings_name, string_list, strings_source = "<<Runtime>>", check_exists = TRUE)
	if(!islist(string_list))
		string_list = list(string_list)
	if(!strings_source || !length(strings_source))
		. = FALSE
		CRASH("The string listing for source [strings_source||"empty"] must have a name!")
	if(!strings_source || !length(strings_source))
		. = FALSE
		CRASH("The source for [strings_name] cannot be [strings_source||"empty"]!")
	if(check_exists && !LAZY_IS_IN(string_list_by_name, strings_name))
		. = FALSE
		CRASH("Attempted to extend string listing '[strings_name]', but it does not exist!")
	LAZY_ADD_UNIQUE(string_list_by_name[strings_name], string_list)
	LAZY_ADD_UNIQUE(string_list_sources[strings_name], strings_source)
	return string_list_by_name[strings_name]
