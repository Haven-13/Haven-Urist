SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	flags = SS_TICKER
	init_order = SS_INIT_CHEMISTRY
	priority = SS_PRIORITY_CHEMISTRY

	var/list/stats

	var/list/datum/reagents/queue
	var/list/datum/reagents/processing

	var/processing_index

/datum/controller/subsystem/chemistry/PreInit()
	queue = list()
	stats = list()

/datum/controller/subsystem/chemistry/Initialize()
	initialized = TRUE
	return ..()

/datum/controller/subsystem/chemistry/stat_entry(msg)
	msg = "Q:[length(queue)], P:[processing_index] of [processing.len]"
	return ..()

/datum/controller/subsystem/chemistry/Recover()
	queue = SSchemistry.queue

/datum/controller/subsystem/chemistry/fire(resumed = FALSE)
	if(!resumed)
		processing_index = 0
		processing = list()
		for(var/thing in queue)
			if(queue[thing])
				processing += thing
		queue.Cut()

	while(processing_index < processing.len)
		var/datum/reagents/holder = processing[processing_index]
		processing_index++
		if(!QDELETED(holder))
			STAT_START_STOPWATCH
			if(holder.process_reactions())
				queue[holder] = TRUE // Add to queue
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, holder.my_atom?.type || "Unheld containers")
		if(MC_TICK_CHECK)
			return

#define QUEUE_REACTIONS(X) SSchemistry.queue[X] = TRUE
#define UNQUEUE_REACTIONS(X) SSchemistry.queue[X] = FALSE
