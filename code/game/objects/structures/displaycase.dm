/obj/structure/displaycase
	name = "display case"
	icon = 'resources/icons/obj/stationobjs.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	alpha = 150
	health = 14
	var/destroyed = 0

/obj/structure/displaycase/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(AM.simulated && !AM.anchored)
			AM.forceMove(src)
	update_icon()

/obj/structure/displaycase/examine(user)
	..()
	if(contents.len)
		to_chat(user, "Inside you see [english_list(contents)].")

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/material/shard(loc)
			for(var/atom/movable/AM in src)
				AM.dropInto(loc)
			qdel(src)
		if (2)
			if (prob(50))
				take_damage(15)
		if (3)
			if (prob(50))
				take_damage(5)

/obj/structure/displaycase/bullet_act(obj/item/projectile/Proj)
	..()
	take_damage(Proj.get_structure_damage())

/obj/structure/displaycase/take_damage(damage)
	health -= damage
	if(health <= 0)
		if (!destroyed)
			set_density(0)
			destroyed = 1
			new /obj/item/weapon/material/shard(loc)
			for(var/atom/movable/AM in src)
				AM.dropInto(loc)
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'resources/sound/effects/Glasshit.ogg', 75, 1)

/obj/structure/displaycase/update_icon()
	underlays.Cut()
	if(destroyed)
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(W.force)
	..()

/obj/structure/displaycase/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(!destroyed)
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		visible_message("<span class='warning'>[usr] kicks the display case.</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(2)
