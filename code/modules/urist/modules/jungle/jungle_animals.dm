
//spawns one of the specified animal type
/obj/effect/landmark/animal_spawner
	icon_state = "x3"
	var/spawn_type
	var/mob/living/spawned_animal
	invisibility = 101
	var/spawn_time_high = 2400
	var/spawn_time_low = 1200

/obj/effect/landmark/animal_spawner/Initialize()
	. = ..()
	if(!spawn_type)
		var/new_type = pick(subtypesof(/obj/effect/landmark/animal_spawner))
		new new_type(get_turf(src))
		return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSobj, src)
	spawned_animal = new spawn_type(get_turf(src))

/obj/effect/landmark/animal_spawner/Process()
	//if any of our animals are killed, spawn new ones
	if(!spawned_animal || spawned_animal.stat == DEAD)
		spawned_animal = new spawn_type(src)
		//after a random timeout, and in a random position (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_animal.loc = locate(src.x + rand(-12,12), src.y + rand(-12,12), src.z)

/obj/effect/landmark/animal_spawner/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/landmark/animal_spawner/panther
	name = "panther spawner"
	spawn_type = /mob/living/simple_animal/hostile/huntable/panther

/obj/effect/landmark/animal_spawner/parrot
	name = "parrot spawner"
	spawn_type = /mob/living/simple_animal/parrot/jungle

/obj/effect/landmark/animal_spawner/monkey
	name = "monkey spawner"
	spawn_type = /mob/living/carbon/human/monkey/jungle

/obj/effect/landmark/animal_spawner/snake
	name = "snake spawner"
	spawn_type = /mob/living/simple_animal/hostile/snake

/obj/effect/landmark/random_animal_spawner
	icon_state = "x3"
	invisibility = 101

	var/mob/living/spawned_animal
	var/spawn_time_high = 2400
	var/spawn_time_low = 1200

	var/list/spawn_list
	var/crosstrigger = 0
	var/x_offset = 0
	var/y_offset = 0

/obj/effect/landmark/random_animal_spawner/Initialize()
	. = ..()
	if(crosstrigger)
		return
	else
		START_PROCESSING(SSobj, src)
		var/spawn_type = pick(spawn_list)
		spawned_animal = new spawn_type(get_turf(src))

/obj/effect/landmark/random_animal_spawner/Process()
	//if any of our animals are killed, spawn new ones
	if(!spawned_animal || spawned_animal.stat == DEAD)
		var/spawn_type = pick(spawn_list)
		spawned_animal = new spawn_type(src)
		//after a random timeout, and in a random position (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_animal.loc = locate(src.x + x_offset, src.y + x_offset, src.z)

/obj/effect/landmark/random_animal_spawner/Crossed(mob/living/M)
	if(crosstrigger) //if an animal crosses this thing, they "leave" the map, and then this landmark starts spawning animals
		if (istype(M, /mob/living/simple_animal) || istype(M, /mob/living/carbon/human/monkey))
			qdel(M)
			START_PROCESSING(SSobj, src)
			return

	else
		..()

/obj/effect/landmark/random_animal_spawner/jungle
	name = "jungle animal spawner"
	x_offset = -8
	crosstrigger = 1
	spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/carbon/human/monkey/jungle,
		/mob/living/simple_animal/parrot/jungle,
		/mob/living/simple_animal/hostile/huntable/deer
	)

/obj/effect/landmark/random_animal_spawner/plains
	name = "plains animal spawner"
	y_offset = -2
	spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/bear,
		/mob/living/simple_animal/hostile/snake/randvenom/green
	)

/obj/effect/landmark/random_animal_spawner/jungle/crosstrigger
	crosstrigger = 1
	icon_state = "x2"

/obj/effect/landmark/random_animal_spawner/plains/crosstrigger
	crosstrigger = 1
	icon_state = "x2"

//huntable animals

/mob/living/simple_animal/hostile/huntable
	var/hide = 0

/mob/living/simple_animal/hostile/huntable/harvest(mob/user)
	if (do_after(user, 60, src))
		to_chat(user, "<span class='notice'>You gut and skin [src], getting some usable meat and hide.</span>")
		for(var/i, i<=meat_amount, i++)
			new meat_type(src.loc)
		var/obj/item/stack/hide/animalhide/AH = new /obj/item/stack/hide/animalhide(src.loc)
		AH.amount = hide
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
//		new /obj/effect/gibspawner/generic(src.loc)
	qdel(src)

/mob/living/simple_animal/huntable
	var/hide = 0

/mob/living/simple_animal/huntable/harvest(mob/user)
	if (do_after(user, 60, src))
		to_chat(user, "<span class='notice'>You gut and skin [src], getting some usable meat and hide.</span>")
		for(var/i, i<=meat_amount, i++)
			new meat_type(src.loc)
		var/obj/item/stack/hide/animalhide/AH = new /obj/item/stack/hide/animalhide(src.loc)
		AH.amount = hide
		new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
//		new /obj/effect/gibspawner/generic(src.loc)
	qdel(src)

//to prevent spam from monkeys being half killed

/mob/living/carbon/human/monkey/jungle/New()
	..()
	faction = "hostile"

//to prevent lag from monkey's life()

/mob/living/simple_animal/huntable/monkey
	name = "monkey"
	desc = "It's a monkey. Seems quite content to lounge around all the time."
	icon = 'resources/icons/uristmob/monkey.dmi'
	icon_state = "preview"
	icon_living = "preview"
	icon_dead = "preview_dead"
	faction = "hostile"
	mob_size = MOB_SMALL
	speak_emote = list("chirps")
	emote_hear = list("chirps")
	emote_see = list("chirps")
	maxHealth = 30
	health = 30
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pokes"
	hide = 1
	meat_amount = 1

//to prevent spam from parrots, and deer killing parrots

/mob/living/simple_animal/parrot/jungle
	speak_chance = 0
	faction = "hostile"

//*********//
// Panther //
//*********//

/mob/living/simple_animal/hostile/huntable/panther
	name = "panther"
	desc = "A long sleek, black cat with sharp teeth and claws."
	icon = 'resources/icons/urist/jungle/mobs.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther_dead"
	icon_gib = "panther_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = 0
	maxHealth = 75
	health = 75

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "slashed"
	attack_sound = 'resources/sound/weapons/bite.ogg'
	meat_amount = 2
	hide = 4

//	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
	var/stalk_tick_delay = 3

/mob/living/simple_animal/hostile/huntable/panther/ListTargets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, 10))
		targets += H
	return targets

/mob/living/simple_animal/hostile/huntable/panther/FindTarget()
	. = ..()
	if(.)
		emote("nashes at [.]")

/mob/living/simple_animal/hostile/huntable/panther/UnarmedAttack(atom/A, proximity)
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/huntable/panther/AttackTarget()
	..()
	if(stance == HOSTILE_STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			src.loc = get_step_towards(src, target)
			stalk_tick_delay = 3

//*******//
// Snake //
//*******//

/mob/living/simple_animal/hostile/snake
	name = "snake"
	desc = "A sinuously coiled, venomous looking reptile."
	icon = 'resources/icons/urist/jungle/mobs.dmi'
	icon_state = "snake_green"
	icon_living = "snake_green"
	icon_dead = "snake_green_dead"
	icon_gib = null
	speak_chance = 0
	turns_per_move = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = 0
	maxHealth = 25
	health = 25
	vision_range = 5 //balancing snakes so they don't slither all the way across the plains to kill you.
	harm_intent_damage = 2
	melee_damage_lower = 3
	melee_damage_upper = 10
	attacktext = "bitten"
	attack_sound = 'resources/sound/weapons/bite.ogg'

//	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
	var/stalk_tick_delay = 3

/mob/living/simple_animal/hostile/snake/ListTargets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, 10))
		targets += H
	return targets

/mob/living/simple_animal/hostile/snake/FindTarget()
	. = ..()
	if(.)
		emote("hisses wickedly")

/mob/living/simple_animal/hostile/snake/UnarmedAttack(atom/A, proximity)
	. =..()
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/L = A
		bite(L)

/mob/living/simple_animal/hostile/snake/proc/bite(mob/living/L)
	L.apply_damage(rand(3,12), DAMAGE_TYPE_TOXIN)

/mob/living/simple_animal/hostile/snake/AttackTarget()
	..()
	if(stance == HOSTILE_STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			src.loc = get_step_towards(src, target)
			stalk_tick_delay = 3

/mob/living/simple_animal/hostile/snake/randvenom
	icon_state = "snake_brown"
	icon_living = "snake_brown"
	icon_dead = "snake_brown_dead"
	desc = "A sinuously coiled, venomous looking reptile. This one looks rather exotic."
	melee_damage_upper = 5
	var/bite_vol = 5
	var/obj/item/venom_sac/venomsac

/mob/living/simple_animal/hostile/snake/randvenom/New()
	..()
	if(!venomsac)
		venomsac = new /obj/item/venom_sac(src)

/mob/living/simple_animal/hostile/snake/randvenom/Destroy()
	venomsac = null
	..()

/mob/living/simple_animal/hostile/snake/randvenom/harvest()
	if(venomsac)
		venomsac.forceMove(src.loc)
		venomsac = null
	..()

/mob/living/simple_animal/hostile/snake/randvenom/bite(mob/living/L)
	if(L && venomsac && (venomsac in src.contents))
		venomsac.reagents.trans_to_mob(L, bite_vol, CHEM_BLOOD, copy=1)

/mob/living/simple_animal/hostile/snake/randvenom/green //so they blend into the plain's turf
	icon_state = "snake_green"
	icon_living = "snake_green"
	icon_dead = "snake_green_dead"

//******//
// Deer //
//******//

/mob/living/simple_animal/hostile/huntable/deer
	name = "deer"
	desc = "It's a deer. It has antlers, so it's a buck."
	icon = 'resources/icons/urist/jungle/mobs.dmi'
	icon_state = "deer"
	icon_living = "deer"
	icon_dead = "deer_dead"
	icon_gib = "deer_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = 0
	maxHealth = 40
	health = 40
	vision_range = 6
	aggro_vision_range = 9
	idle_vision_range = 6
	move_to_delay = 3
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "gored" //antlers
	attack_sound = 'resources/sound/weapons/bite.ogg'
	var/chase_time = 100
	hide = 4
	meat_amount = 2

/mob/living/simple_animal/hostile/huntable/deer/GiveTarget(new_target)
	target = new_target
	if(target != null)
		if(is_living_mob(target))
			Aggro()
			stance = HOSTILE_STANCE_ATTACK
			visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
			retreat_distance = 10
			minimum_distance = 10
			spawn(chase_time)
				retreat_distance = 0
				minimum_distance = 0
				stance = HOSTILE_STANCE_IDLE
				target = null
			return
	return

//******//
// Bear //
//******//

/mob/living/simple_animal/hostile/huntable/bear
	name = "bear"
	desc = "A big scary brown bear, probably best to stay away"
	icon = 'resources/icons/uristmob/64x64_mobs.dmi'
	icon_state = "bigbear"
	icon_living = "bigbear"
	icon_dead = "bigbear_dead"
	icon_gib = "bigbear_dead"
	speak_chance = 0
	turns_per_move = 4
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	stop_automated_movement_when_pulled = 0
	maxHealth = 150
	health = 150
	bound_width = 64

	harm_intent_damage = 8
	melee_damage_lower = 25
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = 'resources/sound/weapons/bite.ogg'
	meat_amount = 4
	hide = 7 //seems like a more fair reward at 7
