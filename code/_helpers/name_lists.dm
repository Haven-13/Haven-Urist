GLOBAL_LIST_INIT(name_list_cache, list())

/hook/global_init/proc/load_name_lists()
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

		name_list_cache[key] = contents

	return TRUE
