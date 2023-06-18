// See 'callback-usage.txt' in this directory for instructions on how to use this.
// It used to be in this file, but Travis no likey.

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

	var/source_file
	var/source_line

/datum/callback/New(_file, _line, thingtocall, proctocall, ...)
	source_file = _file
	source_line = _line

	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	if (length(args) > 4)
		arguments = args.Copy(5)

/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		call(thingtocall, proctocall)(arglist(calling_arguments))

#if (TRY_CATCH_CALLBACKS)
#define DO_INVOKE \
	try { \
		if (object == GLOBAL_PROC) { \
			return call(delegate)(arglist(calling_arguments)); \
		} \
		return call(object, delegate)(arglist(calling_arguments)); \
	} catch (var/exception/e) { \
		var/file_name = splicetext(source_file, 1, findlasttext(source_file,"/") + 1); \
		if (e.name == "bad proc") { \
			if (object == GLOBAL_PROC) { CRASH("Invalid global delegate '[delegate]' given by [file_name],[source_line]"); } \
			else { CRASH("Invalid type delegate '[delegate]' given by [file_name],[source_line]"); } \
		} \
		else { \
			e.name = "\<\<Callback of [file_name],[source_line]\>\> [e.name]"; \
			throw e; \
		} \
	}
#else
#define DO_INVOKE \
	if (object == GLOBAL_PROC) { \
		return call(delegate)(arglist(calling_arguments)); \
	} \
	return call(object, delegate)(arglist(calling_arguments));
#endif

/datum/callback/proc/Invoke(...)
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			//not += so that it creates a new list so the arguments list stays clean
			calling_arguments = calling_arguments + args
		else
			calling_arguments = args
	DO_INVOKE

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = FALSE
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			//not += so that it creates a new list so the arguments list stays clean
			calling_arguments = calling_arguments + args
		else
			calling_arguments = args
	DO_INVOKE

#undef DO_INVOKE
