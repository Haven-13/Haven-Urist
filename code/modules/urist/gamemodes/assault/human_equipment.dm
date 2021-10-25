//human

/obj/item/weapon/grenade/frag/anforgrenade
	desc = "A small explosive meant for anti-personnel use."
	name = "ANFOR grenade"
	icon = 'resources/icons/urist/items/uristweapons.dmi'
	icon_state = "large_grenade"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=3"

///obj/item/weapon/grenade/anforgrenade/detonate()
//	explosion(src.loc, 0, 0, 2, 2)
//	qdel(src)

/obj/item/weapon/storage/box/anforgrenade
	name = "box of frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause cause death within a short radius.</B>"
	icon_state = "flashbang"
	startswith = list(/obj/item/weapon/grenade/frag/anforgrenade = 5)

/obj/item/weapon/storage/box/large/mines
	name = "box of frag mines (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause death within a short radius.</B>"
	icon_state = "flashbang"
	startswith = list(/obj/item/weapon/mine/frag = 3)

/obj/structure/assaultshieldgen
	name = "shield generator"
	desc = "The shield generator for the station. Protect it with your life. Repair it with a welding torch."
	icon = 'resources/icons/obj/power.dmi'
	icon_state = "bbox_on"
	health = 300
	var/maxhealth = 300
	anchored = 1
	density = 1

/obj/structure/assaultshieldgen/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0,user))
			if(health >= maxhealth)
				to_chat(user, "<span class='warning'>The shield generator is fully repaired alredy!</span>")
			else
				playsound(src.loc, 'resources/sound/items/Welder2.ogg', 50, 1)
				user.visible_message("[user.name] starts to patch some dents on the shield generator.", \
					"You start to patch some dents on the shield generator", \
					"You hear welding")
				if (do_after(user,20))
					if(!src || !WT.isOn()) return
					health += 10

		else
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")

	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.50
			else
		if (src.health <= 0)
			visible_message("<span class='danger'>The shield generator is smashed apart!</span>")
			kaboom()
			return
		..()

/obj/structure/assaultshieldgen/ex_act(severity)
	switch(severity)
		if(1.0)
			kaboom()
			return
		if(2.0)
			if(prob(75))
				kaboom()
				return
			else
				health -= 150
		if(3.0)
			if(prob(5))
				kaboom()
				return
			else
				health -= 50

	if(src.health <=0)
		visible_message("<span class='danger'>The shield generator is smashed apart!</span>")
		qdel(src)

	return

/obj/structure/assaultshieldgen/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage

	if(health <= 0)
		kaboom()

	..()

/obj/structure/assaultshieldgen/proc/kaboom()
	remaininggens -= 1
	qdel(src)
