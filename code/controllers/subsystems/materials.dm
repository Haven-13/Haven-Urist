SUBSYSTEM_DEF(materials)
	name = "Materials"
	flags = SS_TICKER
	init_order = SS_INIT_MATERIALS
	priority = SS_PRIORITY_MATERIALS

	var/list/datum/reagents/queue = list()
	var/list/datum/reagents/processing

	var/processing_index

/datum/controller/subsystem/materials/PreInit()
	queue = list()
	stats = list()

/datum/controller/subsystem/materials/Initialize()
	initialized = TRUE
	fire(mc_check = FALSE)
	return ..()

/datum/controller/subsystem/materials/stat_entry(msg)
	msg = "Q:[length(queue)], P:[processing_index] of [processing.len]"
	return ..()

/datum/controller/subsystem/materials/Recover()
	queue = SSmaterials.queue

/datum/controller/subsystem/materials/fire(resumed = FALSE)
	if(!resumed)
		processing_index = 0
		processing = list()
		for(var/thing in queue)
			if(queue[thing])
				processing += thing
		queue.Cut()

	while(processing_index < processing.len)
		var/datum/reagent/holder = processing[processing_index]
		processing_index++
		if(!QDELETED(holder))
			STAT_START_STOPWATCH
			if(holder.process_reactions())
				queue[holder] = TRUE // Add to queue
			STAT_STOP_STOPWATCH
			STAT_LOG_ENTRY(stats, holder.my_atom?.type || "Unheld containers")
		if(MC_TICK_CHECK)
			return

#define QUEUE_REACTIONS(X) SSmaterials.queue[X] = TRUE
#define UNQUEUE_REACTIONS(X) SSmaterials.queue[X] = FALSE
