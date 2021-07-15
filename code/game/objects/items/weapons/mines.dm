/** *
	* The frag mine code was originally written by scrdst over at UristMcStation, thank her
	* not me. All I did was just refactor the /obj/effect/mine crap to use the beautiful
	* obj/item/weapon/mine instead
	*
 	*/

/obj/item/weapon/mine
	name = "land mine"
	desc = "Mines and libertarians have one thing in common, a 'No Step' label."
	density = 0
	anchored = 0
	plane = OBJ_PLANE
	layer = OBJ_LAYER
	throwpass = 1
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"

	var/triggered = 0
	var/armed = 0

/obj/item/weapon/mine/attack_self(mob/user as mob)
	user.visible_message(
		"<span class='warning'>[user] arms \the [src]! Be careful not to step on it!</span>",
		"<span class='warning'>You arm \the [src] and lay it on the floor. Be careful not to step on it!</span>"
	)
	user.drop_from_inventory(src, get_turf(user))

	src.armed = TRUE
	src.anchored = TRUE
	icon_state = "uglyminearmed"

	var/image/I = image('icons/urist/jungle/turfs.dmi', "exclamation")
	I.plane = src.get_float_plane(OBJ_PLANE)
	I.layer = src.layer + 0.5

	src.overlays += I

	spawn(35)
		if(src)
			src.overlays -= I

/obj/item/weapon/mine/frag/attack_hand(mob/user as mob)
	if(armed)
		user.visible_message(
			"<span class='warning'>[user] starts to disarm \the [src]!</span>",
			"<span class='warning'>You start to disarm \the [src]. Just stay very still.</span>"
		)
		if (do_after(user, 30, src))
			user.visible_message(
				"<span class='notice'>[user] disarms \the [src]!</span>",
				"<span class='notice'>You disarm \the [src]. It's safe to pick up now!</span>"
			)
			icon_state = "uglymine"
			armed = FALSE
			anchored = FALSE
	else
		..()

/obj/item/weapon/mine/New()
	if(armed)
		anchored = TRUE
		icon_state = "uglyminearmed"

/obj/item/weapon/mine/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GRILLE))
		return 1
	else
		return ..()

/obj/item/weapon/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/item/weapon/mine/Bumped(mob/M as mob|obj)
	if(!armed || triggered) return FALSE

	if(istype(M, /mob/living/carbon/human))
		M.visible_message(
			"<span class='danger'>\The [M] triggered the [src]!</span>",
			"<span class='danger'>You triggered the \the [src]!</span>",
			"<span class='warning'>You feel an omnious click under your step!</span>"
		)
		trigger(M)
		return TRUE

/obj/item/weapon/mine/proc/trigger(atom/movable/M)
	if(!triggered)
		triggered = 1
		on_trigger(M)
		qdel(src)

/obj/item/weapon/mine/proc/on_trigger(atom/movable/A)
	explosion(loc, 0, 1, 2, 3)

/obj/item/weapon/mine/radiation
	name = "radiation mine"
	icon_state = "uglymine"

/obj/item/weapon/mine/radiation/on_trigger(atom/movable/A)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	A.rad_act(50)
	randmutb(A)
	domutcheck(A,null)

/obj/item/weapon/mine/phoron
	name = "Phoron mine"
	icon_state = "uglymine"

/obj/item/weapon/mine/phoron/on_trigger(atom/movable/A)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

/obj/item/weapon/mine/n2o
	name = "N2O mine"
	icon_state = "uglymine"

/obj/item/weapon/mine/n2o/on_trigger(atom/movable/A)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

/obj/item/weapon/mine/stun
	name = "stun mine"
	icon_state = "uglymine"

/obj/item/weapon/mine/stun/on_trigger(atom/movable/A)
	if(ismob(A))
		var/mob/M = A
		M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()

/obj/item/weapon/mine/frag
	name = "frag mine"

/obj/item/weapon/mine/frag/on_trigger(atom/movable/A)
	//vars stolen for fragification
	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment
	var/num_fragments = 72  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7 //leave as is, for some reason setting this higher makes the spread pattern have gaps close to the epicenter

	var/turf/O = get_turf(src)
	if(!O) return

	var/list/target_turfs = getcircle(O, spread_range)
	var/fragments_per_projectile = round(num_fragments/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(O)

		P.pellets = fragments_per_projectile
		P.shot_from = src.name

		P.launch(T)

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in O)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 0)
			else
				P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass
