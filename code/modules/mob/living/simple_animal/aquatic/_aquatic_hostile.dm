/mob/living/simple_animal/hostile/aquatic
	icon = 'resources/icons/mob/aquatic.dmi'
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish
	turns_per_move = 5
	attacktext = "bitten"
	attack_sound = 'resources/sound/weapons/bite.ogg'
	speed = 4
	mob_size = MOB_MEDIUM
	emote_see = list("gnashes")

	// They only really care if there's water around them or not.
	max_gas = list()
	min_gas = list()
	minbodytemp = 0

/mob/living/simple_animal/hostile/aquatic/Life()
	if(!submerged())
		if(icon_state == icon_living)
			icon_state = "[icon_living]_dying"
		SetStunned(3)
	. = ..()

/mob/living/simple_animal/hostile/aquatic/handle_atmos(atmos_suitable = 1)
	. = ..(atmos_suitable = submerged())
