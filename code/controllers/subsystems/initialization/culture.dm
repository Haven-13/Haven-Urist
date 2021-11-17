SUBSYSTEM_DEF(culture)
	name = "Culture"
	init_order = SS_INIT_CULTURE
	flags = SS_NO_FIRE

	var/list/raw_toml_data = list()

	var/list/cultural_info_by_name = list()
	var/list/cultural_info_by_id = list()
	var/list/tagged_info = list()

/datum/controller/subsystem/culture/Initialize()
	initialize_name_lists()
	initialize_language_infos()
	initialize_culture_infos()
	. = ..()

/datum/controller/subsystem/culture/proc/initialize_name_lists()
	var/list/config = rustg_read_toml_file("resources/strings/names/name_lists.toml")
	var/list/fcache = list()

	for(var/key in config)
		var/list/files = config[key]
		var/list/contents = list()

		for(var/f in files)
			var/filename = "resources/strings/names/[f]"
			if (!(f in fcache))
				var/list/data = file2list(filename)
				if(file_get_extension(filename) == "csv")
					data.Cut(1,1) // Remove the header (for CSV files)
				fcache[f] = data
			contents.Add(fcache[f])

		SSstrings.create_list(key, contents)

/datum/controller/subsystem/culture/proc/initialize_language_infos()
	return FALSE

/datum/controller/subsystem/culture/proc/initialize_culture_infos()
	var/files = GLOB.using_map.get_culture_files()
	for (var/file in files)
		if(!rustg_file_exists(file))
			error("SSculture: File [file] does not exist")
			continue
		var/list/data = rustg_read_toml_file(file)
		for(var/key in data)
			data[key]["@source"] = file
		raw_toml_data.Add(data)

	for (var/key in raw_toml_data)
		var/toml_def = resolve(key)
		var/decl/cultural_info/culture = try_build_decl(key, toml_def)
		if(!culture.name)
			continue
		if(cultural_info_by_id[key])
			error("Duplicate cultural ID: \[[key]\] from [toml_def['@source']]")
		if(cultural_info_by_name[culture.name])
			error("Duplicate cultural name: '[culture.name]' by \[[key]\] from [toml_def['@source']]")
		cultural_info_by_id[key] = culture
		cultural_info_by_name[culture.name] = culture
		if(culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture

/datum/controller/subsystem/culture/proc/resolve(key)
	var/list/def = raw_toml_data[key]
	if(def["__extends"] && !def["@extension"])
		def["@extension"] = resolve(def["__extends"])
	if(!def["@full"])
		def["@full"] = def + (def["@extension"] || list())
	return def["@full"]

/datum/controller/subsystem/culture/proc/try_build_decl(key, list/data)
	var/decl/cultural_info/culture = new
	culture.name = data["name"]
	culture.description = data["description"]
	culture.language = data["language"]
	culture.secondary_langs = data["secondary_languages"] || list()
	culture.additional_langs = data["additional_languages"] || list()
	culture.hidden = data["hidden"] || FALSE
	return culture

/datum/controller/subsystem/culture/proc/get_culture(var/identifer)
	return cultural_info_by_id[identifer] || cultural_info_by_name[identifer]

/datum/controller/subsystem/culture/proc/pick_random_culture()
	return cultural_info_by_id[pick(cultural_info_by_id)]

/datum/controller/subsystem/culture/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]
