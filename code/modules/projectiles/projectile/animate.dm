/obj/item/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	damage = 0
	damage_type = DAMAGE_TYPE_BURN
	nodamage = 1
	check_armour = "energy"

/obj/item/projectile/animate/Bump(atom/change, forced=0)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/(O.loc, O, firer)
	..()
