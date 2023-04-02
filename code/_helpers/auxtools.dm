GLOBAL_VAR_INIT(auxtools_debug_server, world.GetConfig("env", "AUXTOOLS_DEBUG_DLL"))

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	return

/hook/startup/proc/auxtools_init()
	if (GLOB.auxtools_debug_server)
		LIBCALL(GLOB.auxtools_debug_server, "auxtools_init")()
		enable_debugging()
	return TRUE

/hook/shutdown/proc/auxtools_shutdown()
	if (GLOB.auxtools_debug_server)
		LIBCALL(GLOB.auxtools_debug_server, "auxtools_shutdown")()
	return TRUE
