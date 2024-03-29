/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'resources/icons/obj/rubble.dmi'
	icon_state = "base"
	appearance_flags = PIXEL_SCALE
	opacity = 1
	density = 1
	anchored = 1

	var/list/loot = list(/obj/item/weapon/cell,/obj/item/stack/material/iron,/obj/item/stack/rods)
	var/lootleft = 1
	var/emptyprob = 95
	health = 40
	var/is_rummaging = 0

/obj/structure/rubble/New()
	if(prob(emptyprob))
		lootleft = 0
	..()

/obj/structure/rubble/Initialize()
	. = ..()
	update_icon()

/obj/structure/rubble/update_icon()
	overlays.Cut()
	var/list/parts = list()
	for(var/i = 1 to 7)
		var/image/I = image(icon,"rubble[rand(1,15)]")
		if(prob(10))
			var/atom/A = pick(loot)
			if(initial(A.icon) && initial(A.icon_state))
				I.icon = initial(A.icon)
				I.icon_state = initial(A.icon_state)
				I.color = initial(A.color)
			if(!lootleft)
				I.color = "#54362e"
		I.appearance_flags = PIXEL_SCALE
		I.pixel_x = rand(-16,16)
		I.pixel_y = rand(-16,16)
		var/matrix/M = matrix()
		M.Turn(rand(0,360))
		I.transform = M
		parts += I
	overlays = parts
	if(lootleft)
		overlays += image(icon,"twinkle[rand(1,3)]")

/obj/structure/rubble/attack_hand(mob/user)
	if(!is_rummaging)
		if(!lootleft)
			to_chat(user, "<span class='warning'>There's nothing left in this one but unusable garbage...</span>")
			return
		visible_message("[user] starts rummaging through \the [src].")
		is_rummaging = 1
		if(do_after(user, 30))
			var/obj/item/booty = pick(loot)
			booty = new booty(loc)
			lootleft--
			update_icon()
			to_chat(user, "<span class='notice'>You find \a [booty] and pull it carefully out of \the [src].</span>")
		is_rummaging = 0
	else
		to_chat(user, "<span class='warning'>Someone is already rummaging here!</span>")

/obj/structure/rubble/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = I
		visible_message("[user] starts clearing away \the [src].")
		if(do_after(user,P.digspeed, src))
			visible_message("[user] clears away \the [src].")
			if(lootleft && prob(1))
				var/obj/item/booty = pick(loot)
				booty = new booty(loc)
			qdel(src)
	else
		..()
		health -= I.force
		if(health < 1)
			visible_message("[user] clears away \the [src].")
			qdel(src)

/obj/structure/rubble/house
	emptyprob = 100
	loot = list()

/obj/structure/rubble/war
	emptyprob = 100
	loot = list()
