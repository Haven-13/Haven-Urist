SUBSYSTEM_DEF(culture)
	name = "Culture"
	init_order = SS_INIT_CULTURE
	flags = SS_NO_FIRE

	var/list/language_by_name = list()
	var/list/language_by_id = list()
	var/list/language_by_key = list()

	var/list/cultural_info_by_name = list()
	var/list/cultural_info_by_id = list()
	var/list/cultural_info_by_tag = list()

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
	var/files = GLOB.using_map.get_language_files()
	var/list/raw = list()
	for (var/file in files)
		if(!rustg_file_exists(file))
			error("SSculture: File [file] does not exist")
			continue
		var/list/data = rustg_read_toml_file(file)
		for(var/key in data)
			data[key]["@source"] = file
		raw.Add(data)

	for (var/key in raw)
		var/toml_def = resolve(key, raw)
		var/datum/language/lang = try_build_language_decl(key, toml_def)

		if(!lang.name)
			continue
		if(language_by_id[key])
			error("Duplicate language ID: \[[key]\] from [toml_def["@source"]]")
		if(language_by_name[lang.name])
			error("Duplicate language name: '[lang.name]' by \[[key]\] from [toml_def["@source"]]")

		language_by_id[key] = lang
		language_by_name[lang.name] = lang
		language_by_key[lang.key] = lang

/datum/controller/subsystem/culture/proc/initialize_culture_infos()
	var/files = GLOB.using_map.get_culture_files()
	var/list/raw = list()
	for (var/file in files)
		if(!rustg_file_exists(file))
			error("SSculture: File [file] does not exist")
			continue
		var/list/data = rustg_read_toml_file(file)
		for(var/key in data)
			data[key]["@source"] = file
		raw.Add(data)

	for (var/key in raw)
		var/toml_def = resolve(key, raw)
		var/decl/cultural_info/culture = try_build_culture_decl(key, toml_def)
		if(!culture.name)
			continue
		if(cultural_info_by_id[key])
			error("Duplicate cultural ID: \[[key]\] from [toml_def["@source"]]")
		if(cultural_info_by_name[culture.name])
			error("Duplicate cultural name: '[culture.name]' by \[[key]\] from [toml_def["@source"]]")
		cultural_info_by_id[key] = culture
		cultural_info_by_name[culture.name] = culture
		if(culture.category && !culture.hidden)
			if(!cultural_info_by_tag[culture.category])
				cultural_info_by_tag[culture.category] = list()
			var/list/tag_list = cultural_info_by_tag[culture.category]
			tag_list[culture.name] = culture

/datum/controller/subsystem/culture/proc/resolve(key, list/raw_toml_data)
	var/list/def = raw_toml_data[key]
	if(def["__extends"] && !def["@extension"])
		def["@extension"] = resolve(def["__extends"], raw_toml_data)
	if(!def["@full"])
		def["@full"] = def + (def["@extension"] || list())
	return def["@full"]

/datum/controller/subsystem/culture/proc/resolve_languages(keys, who)
	var/datum/language/L
	var/list/languages = list()
	if(!islist(keys))
		keys = list(keys)

	for (var/k in keys)
		if (k in language_by_id)
			L = language_by_id[k]
			languages.Add(L.name)
		else
			log_error("Culture: Language id '[k]' is undefined! -- Used by '[who]'")
	return languages

/datum/controller/subsystem/culture/proc/try_build_language_decl(key, list/data)
	var/datum/language/language = new
	language.name = data["name"]
	language.description = data["description"]
	language.syllables = data["syllables"]
	language.colour = data["colour"]
	language.shorthand = data["short_hand"]
	language.key = lowertext(data["key"])
	return language

/datum/controller/subsystem/culture/proc/try_build_culture_decl(key, list/data)
	var/decl/cultural_info/culture = new
	culture.name = data["name"]
	culture.description = data["description"]
	culture.hidden = data["hidden"] || FALSE
	culture.category = data["category"]

	var/list/langs = resolve_languages(data["language"], key)
	culture.language = LAZY_ACCESS(langs, 1)
	culture.secondary_langs = resolve_languages(data["secondary_languages"] || list(), key)
	culture.additional_langs = resolve_languages(data["additional_languages"] || list(), key)
	return culture

/datum/controller/subsystem/culture/proc/get_language(var/identifier)
	return language_by_id[identifier] || language_by_name[identifier]

/datum/controller/subsystem/culture/proc/get_culture(var/identifier)
	return cultural_info_by_id[identifier] || cultural_info_by_name[identifier]

/datum/controller/subsystem/culture/proc/pick_random_culture()
	return cultural_info_by_id[pick(cultural_info_by_id)]

/datum/controller/subsystem/culture/proc/get_all_entries_tagged_with(var/token)
	return cultural_info_by_tag[token]
