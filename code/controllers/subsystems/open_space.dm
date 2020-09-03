//
// Controller handling icon updates of open space turfs
//

GLOBAL_VAR_INIT(open_space_initialised, FALSE)

SUBSYSTEM_DEF(open_space)
	name = "Open Space"
	init_order = SS_INIT_OPEN_SPACE
	var/list/turfs_to_process = list()		// List of turfs queued for update.
	var/list/turfs_to_process_old = list()  //List of previous turfs that is set to update
	var/counter = 1 //Can't use .len because we need to iterate in order


/datum/controller/subsystem/open_space/Initialize()
	. = ..()
	wait = world.tick_lag // every second
	GLOB.open_space_initialised = TRUE
	return INITIALIZE_HINT_LATELOAD


/datum/controller/subsystem/open_space/fire(resumed = 0)
	// We use a different list so any additions to the update lists during a delay from CHECK_TICK
	// don't cause things to be cut from the list without being updated.

	//If we're not resuming, this must mean it's a new iteration so we have to grab the turfs
	if(!resumed)
		counter = 1
		src.turfs_to_process_old = turfs_to_process
		//Clear list
		turfs_to_process = list()

	//Apparently this is actually faster
	var/list/turfs_to_process_old = src.turfs_to_process_old

	while(counter <= turfs_to_process_old.len)
		var/turf/T = turfs_to_process_old[counter]
		counter += 1
		update_turf(T)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/open_space/proc/update_turf(var/turf/T)
	for(var/atom/movable/A in T)
		A.fall()
	T.update_icon()

/datum/controller/subsystem/open_space/proc/add_turf(var/turf/T, var/recursive = 0)
	ASSERT(isturf(T))
	//Check for multiple additions
	if((T in turfs_to_process))
		//If we want to add it again, the implication is
		//That we need to know what happened below
		//so It has to happen after previous addition
		//take it out and readd
		turfs_to_process -= T
	turfs_to_process += T
	if(recursive > 0)
		var/turf/above = GetAbove(T)
		if(above && isopenspace(above))
			add_turf(above, recursive)

// Can't trust the Open-Space subsystem to do its work properly, that piece of shit
/hook/roundstart/proc/initialize_space_transparency()
	var/list/turf/turfs = SSopen_space.turfs_to_process.Copy()
	for(var/turf/T in turfs)
		if (T && T.is_transparent)
			T.update_icon()
	return 1
