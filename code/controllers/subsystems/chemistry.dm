SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	flags = SS_TICKER
	init_order = SS_INIT_CHEMISTRY
	priority = SS_PRIORITY_CHEMISTRY

	var/list/stats

	var/list/datum/reagents/queue
	var/list/datum/reagents/processing

/datum/controller/subsystem/chemistry/PreInit()
	processing = list()
	queue = list()
	stats = list()

/datum/controller/subsystem/chemistry/Initialize()
	initialized = TRUE
	return ..()

/datum/controller/subsystem/chemistry/stat_entry()
	return ..("Q:[length(queue)], P:[processing.len]")

/datum/controller/subsystem/chemistry/Recover()
	queue = SSchemistry.queue

/datum/controller/subsystem/chemistry/fire(resumed = FALSE)
	if(!resumed)
		processing = queue.Copy()

	while(processing.len)
		var/datum/reagents/holder = processing[processing.len]
		processing.len--
		if(!QDELETED(holder))
			STAT_START_STOPWATCH
			if(!holder.process_reactions())
				queue -= holder
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, holder.my_atom?.type || "Unheld containers")
		if(MC_TICK_CHECK)
			return

#define QUEUE_REACTIONS(X) SSchemistry.queue[X] = TRUE
#define DEQUEUE_REACTIONS(X) SSchemistry.queue -= X
