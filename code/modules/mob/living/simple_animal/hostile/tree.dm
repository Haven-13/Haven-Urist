/mob/living/simple_animal/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	icon = 'resources/icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish
	response_help = "brushes"
	response_disarm = "pushes"
	response_harm = "hits"
	speed = -1
	maxHealth = 250
	health = 250

	pixel_x = -16

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "bitten"
	attack_sound = 'resources/sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	faction = "carp"

/mob/living/simple_animal/hostile/tree/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_animal/hostile/tree/UnarmedAttack(atom/A, proximity)
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/tree/death(gibbed, deathmessage, show_dead_message)
	..(null,"is hacked into pieces!", show_dead_message)
	new /obj/item/stack/material/wood(loc)
	qdel(src)
