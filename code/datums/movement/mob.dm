// Movement relayed to self handling
/datum/movement_handler/mob/relayed_movement
	var/prevent_host_move = FALSE
	var/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(mob/mover, is_external)
	if(is_external)
		return MOVEMENT_PROCEED
	if(mover == mob && !(prevent_host_move && LAZY_LENGTH(allowed_movers) && !LAZY_IS_IN(allowed_movers, mover)))
		return MOVEMENT_PROCEED
	if(LAZY_IS_IN(allowed_movers, mover))
		return MOVEMENT_PROCEED

	return MOVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(mover)
	LAZY_ADD_UNIQUE(allowed_movers, mover)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(mover)
	LAZY_REMOVE(allowed_movers, mover)

// Admin object possession
/datum/movement_handler/mob/admin_possess/DoMove(direction)
	if(QDELETED(mob.control_object))
		return MOVEMENT_REMOVE

	. = MOVEMENT_HANDLED

	var/atom/movable/control_object = mob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |= MOVEMENT_REMOVE
	else
		control_object.set_dir(direction)

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return
	. = MOVEMENT_HANDLED
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal/DoMove(direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	if(!mob.forceMove(T))
		return

	mob.set_dir(direction)
	mob.PostIncorporealMovement()

/mob/proc/PostIncorporealMovement()
	return

// Eye movement
/datum/movement_handler/mob/eye/DoMove(direction, mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover))
		return MOVEMENT_PROCEED
	if(is_external)
		return MOVEMENT_PROCEED
	if(!mob.eyeobj)
		return MOVEMENT_PROCEED
	return (MOVEMENT_PROCEED|MOVEMENT_HANDLED)

// Space movement
/datum/movement_handler/mob/space/DoMove(direction, mob/mover)
	if(!mob.check_solid_ground())
		var/allowmove = mob.Allow_Spacemove(0)
		if(!allowmove)
			return MOVEMENT_HANDLED
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return MOVEMENT_HANDLED
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move

/datum/movement_handler/mob/space/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.check_solid_ground())
		if(!mob.Allow_Spacemove(0))
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Buckle movement
/datum/movement_handler/mob/buckle_relay/DoMove(direction, mover)
	// TODO: Datumlize buckle-handling
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return MOVEMENT_HANDLED

	if(mob.pulledby || mob.buckled) // Wheelchair driving!
		if(istype(mob.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			mob.pulledby.DoMove(direction, mob)
		else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			if(is_human_mob(mob))
				var/mob/living/carbon/human/driver = mob
				var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
				var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
				if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
					return // No hands to drive your chair? Tough luck!
			//drunk wheelchair driving
			direction = mob.AdjustMovementDirection(direction)
			mob.buckled.DoMove(direction, mob)

/datum/movement_handler/mob/buckle_relay/MayMove(mover)
	if(mob.buckled)
		return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Movement delay
/datum/movement_handler/mob/delay
	var/next_move

/datum/movement_handler/mob/delay/DoMove(direction, mover, is_external)
	if(is_external)
		return
	next_move = world.time + max(1, mob.movement_delay())

/datum/movement_handler/mob/delay/MayMove(mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	return ((mover && mover != mob) ||  world.time >= next_move) ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/mob/delay/proc/SetDelay(delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(delay)
	next_move += max(0, delay)

// Stop effect
/datum/movement_handler/mob/stop_effect/DoMove()
	if(MayMove() == MOVEMENT_STOP)
		return MOVEMENT_HANDLED

/datum/movement_handler/mob/stop_effect/MayMove()
	for(var/obj/effect/stop/S in mob.loc)
		if(S.victim == mob)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return MOVEMENT_STOP

// Consciousness - Is the entity trying to conduct the move conscious?
/datum/movement_handler/mob/conscious/MayMove(mob/mover)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(mob/mover)
	// We only check physical capability if the host mob tried to do the moving
	return ((mover && mover != mob) || !mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING)) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(mob/mover)
	if(mob.anchored)
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're anchored down!</span>")
		return MOVEMENT_STOP

	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're buckled to \the [mob.buckled]!</span>")
		return MOVEMENT_STOP

	if(LAZY_LENGTH(mob.pinned))
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're pinned down by \a [mob.pinned[1]]!</span>")
		return MOVEMENT_STOP

	for(var/obj/item/grab/G in mob.grabbed_by)
		if(G.stop_move())
			if(mover == mob)
				to_chat(mob, "<span class='notice'>You're stuck in a grab!</span>")
			mob.ProcessGrabs()
			return MOVEMENT_STOP

	if(mob.restrained())
		for(var/mob/M in range(mob, 1))
			if(M.pulling == mob)
				if(!M.incapacitated() && mob.Adjacent(M))
					if(mover == mob)
						to_chat(mob, "<span class='notice'>You're restrained! You can't move!</span>")
					return MOVEMENT_STOP
				else
					M.stop_pulling()

	return MOVEMENT_PROCEED


/mob/living/ProcessGrabs()
	//if we are being grabbed
	if(grabbed_by.len)
		resist() //shortcut for resisting grabs

/mob/proc/ProcessGrabs()
	return


// Finally.. the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(direction, mob/mover)
	. = MOVEMENT_HANDLED
	if(mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	//We are now going to move
	mob.moving = 1

	direction = mob.AdjustMovementDirection(direction)
	step(mob, direction)

	// Something with pulling things
	var/extra_delay = HandleGrabs(direction)
	mob.ExtraMoveCooldown(extra_delay)

	for (var/obj/item/grab/G in mob)
		if (G.assailant_reverse_facing())
			mob.set_dir(GLOB.reverse_dir[direction])
		G.assailant_moved()
	for (var/obj/item/grab/G in mob.grabbed_by)
		G.adjust_position()

	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(mob/mover)
	return IS_SELF(mover) &&  mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/datum/movement_handler/mob/movement/proc/HandleGrabs(direction)
	. = 0
	// TODO: Look into making grabs use movement events instead, this is a mess.
	var/list/L = mob.ret_grab()
	if(LAZY_LENGTH(L))
		var/turf/T = get_step(mob,reverse_direction(direction))
		L -= mob
		for(var/mob/M in L)
			if ((get_dist(mob, M) <= 2 || M.loc == mob.loc))
				if (is_turf(M.loc))
					var/diag = get_dir(mob, M)
					if ((diag - 1) & diag)
					else
						diag = null
					if ((get_dist(mob, M) > 1 || diag))
						step(M, get_dir(M.loc, T))

	for (var/obj/item/grab/G in mob)
		. = max(., G.grab_slowdown())
		G.adjust_position()

// Misc. helpers
/mob/proc/MayEnterTurf(turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/mob/proc/AdjustMovementDirection(direction)
	. = direction
	if(!confused)
		return

	var/stability = MOVING_DELIBERATELY(src) ? 75 : 25
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir[.] : GLOB.ccw_dir[.]
