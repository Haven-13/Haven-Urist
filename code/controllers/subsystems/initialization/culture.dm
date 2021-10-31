SUBSYSTEM_DEF(culture)
	name = "Culture"
	init_order = SS_INIT_CULTURE
	flags = SS_NO_FIRE

	var/list/raw_toml_data = list()

	var/list/cultural_info_by_name = list()
	var/list/cultural_info_by_id = list()
	var/list/cultural_info_by_path = list()
	var/list/tagged_info = list()

/datum/controller/subsystem/culture/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]

/datum/controller/subsystem/culture/Initialize()
	var/files = list(
		"resources/defs/cultures/cultures_common.toml",
		"resources/defs/cultures/cultures_human.toml",
		"resources/defs/cultures/cultures_machine.toml",
		"resources/defs/cultures/cultures_skrell.toml",
		"resources/defs/cultures/cultures_teshari.toml",
		"resources/defs/cultures/cultures_unathi.toml",
		"resources/defs/cultures/cultures_vox.toml",
	)
	for (var/file in files)
		var/list/data = rustg_read_toml_file(file)
		for(var/key in data)
			data[key]["@source"] = file
		raw_toml_data.Add(data)

	for (var/key in raw_toml_data)
		try_build_decl(key, resolve(key))

	/*
	for(var/ftype in typesof(/decl/cultural_info)-/decl/cultural_info)
		var/decl/cultural_info/culture = ftype
		if(!initial(culture.name))
			continue
		culture = new culture
		if(cultural_info_by_name[culture.name])
			crash_with("Duplicate cultural datum ID - [culture.name] - [ftype]")
		cultural_info_by_name[culture.name] = culture
		cultural_info_by_path[ftype] = culture
		if(culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture
	*/
	. = ..()

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
	cultural_info_by_id[key] = culture

/datum/controller/subsystem/culture/proc/get_culture(var/culture_ident)
	return cultural_info_by_name[culture_ident] ? cultural_info_by_name[culture_ident] : cultural_info_by_path[culture_ident]
