
/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.load_event("config/custom_event.txt")

// Was called prof_init in https://github.com/mafemergency/byond-tracy
/proc/tracy_profiler_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("unsupported platform")

	var/init = LIBCALL(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")
	to_world_log("Tracy profiling started.")

/world/proc/pre_map_load()
	auxtools_init()

#if USE_BYOND_TRACY
	#warn USE_BYOND_TRACY is enabled
	tracy_profiler_init()
#else
	if(config.start_byond_profiling)
		Profile(PROFILE_START)
#endif

	load_configuration()
	Master = new
	return TRUE
