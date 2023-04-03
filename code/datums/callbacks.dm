// See 'callback-usage.txt' in this directory for instructions on how to use this.
// It used to be in this file, but Travis no likey.

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

	var/source_file
	var/source_line
	var/source_type
	var/source_proc

/datum/callback/New(_file, _line, thingtocall, proctocall, ...)
	source_file = _file
	source_line = _line
	// source_type = _type
	// source_proc = _proc

	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	if (length(args) > 2)
		arguments = args.Copy(3)

/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		call(thingtocall, proctocall)(arglist(calling_arguments))

#define DO_INVOKE \
	try { \
		if (object == GLOBAL_PROC) { \
			return call(delegate)(arglist(calling_arguments)) \
		} \
		return call(object, delegate)(arglist(calling_arguments)) \
	} catch (var/exception/e) { \
		EXCEPTION("Exception '[e.name]' on callback for [object]/[delegate], by [source_type]/proc/[source_proc] @ [source_file]:[source_line]") \
	}

/datum/callback/proc/Invoke(...)
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
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
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	DO_INVOKE

#undef DO_INVOKE
