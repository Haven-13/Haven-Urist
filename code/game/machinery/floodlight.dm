//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'resources/icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/weapon/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0

	var/l_max_bright = 0.8 //brightness of light when on, can be negative
	var/l_inner_range = 1 //inner range of light when on, can be negative
	var/l_outer_range = 6 //outer range of light when on, can be negative

/obj/machinery/floodlight/New()
	cell = new/obj/item/weapon/cell/crap(src)
	..()

/obj/machinery/floodlight/update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/Process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(l_max_bright / 2, l_inner_range, l_outer_range)
		spawn(20)
			if(on)
				set_light(l_max_bright, l_inner_range, l_outer_range)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light(l_max_bright, l_inner_range, l_outer_range)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
		playsound(src.loc, 'resources/sound/effects/flashlight.ogg', 50, 0)
	return 1

/obj/machinery/floodlight/proc/turn_off(loud = 0)
	on = 0
	set_light(0, 0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")
		playsound(src.loc, 'resources/sound/effects/flashlight.ogg', 50, 0)

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'resources/sound/effects/flashlight.ogg', 50, 0)


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		cell.dropInto(get_turf(src))
		if(is_human_mob(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light(0)
		to_chat(user, "You remove \the [cell].")
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'resources/sound/effects/flashlight.ogg', 50, 0)

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_screwdriver(W))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	if(is_crowbar(W))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	if (istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				to_chat(user, "There's already a [cell] installed.")
			else
				if(!user.unEquip(W, src))
					return
				cell = W
				to_chat(user, "You insert \the [W].")
	update_icon()

/obj/machinery/floodlight/verb/rotate()
	set name = "Rotate Light"
	set category = "Object"
	set src in oview(1)

	if(!usr || !Adjacent(usr))
		return

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return
	else if(usr.incapacitated())
		return

	src.set_dir(turn(src.dir, 90))
	return

/obj/machinery/floodlight/AltClick()
	rotate()
