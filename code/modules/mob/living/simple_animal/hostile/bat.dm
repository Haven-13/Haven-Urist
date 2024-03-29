/mob/living/simple_animal/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats - they look pretty upset."
	icon = 'resources/icons/mob/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 20
	health = 20

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "bites"
	attack_sound = 'resources/sound/weapons/bite.ogg'

	min_gas = null
	max_gas = null
	minbodytemp = 0

	environment_smash = 1

	faction = "scarybat"
	var/mob/living/owner

/mob/living/simple_animal/hostile/scarybat/New(loc, mob/living/L as mob)
	..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/FindTarget()
	. = ..()
	if(.)
		emote("flutters towards [.]")

/mob/living/simple_animal/hostile/scarybat/Found(atom/A)
	if(istype(A) && A == owner)
		return 0
	return ..()

/mob/living/simple_animal/hostile/scarybat/UnarmedAttack(atom/A, proximity)
	if(A && A == owner)
		// No attacking the owner! Bad bat!
		return 0

	. =..()

	var/mob/living/L = A
	if(istype(L))
		if(prob(15))
			L.Stun(1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")
