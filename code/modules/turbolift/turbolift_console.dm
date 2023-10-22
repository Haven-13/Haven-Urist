// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'resources/icons/obj/turbolift.dmi'
	anchored = 1
	density = 0
	plane = DEFAULT_PLANE
	layer = ABOVE_OBJ_LAYER

	var/datum/turbolift/lift

/obj/structure/lift/set_dir(newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='danger'>\The [user] hammers on the lift button!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] presses the lift button.</span>")


/obj/structure/lift/New(newloc, datum/turbolift/_lift)
	lift = _lift
	return ..(newloc)

/obj/structure/lift/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_generic(mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_hand(mob/user)
	return interact(user)

/obj/structure/lift/interact(mob/user)
	if(!lift.is_functional())
		return 0
	return 1
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	var/datum/turbolift_floor/floor

/obj/structure/lift/button/New()
	..()
	set_extension(src, /datum/extension/base_icon_state, /datum/extension/base_icon_state, icon_state)

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

/obj/structure/lift/button/interact(mob/user)
	if(!..())
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor)
		lift.open_doors()
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(light_up)
		icon_state = "[bis.base_icon_state]_lit"
	else
		icon_state = bis.base_icon_state

/obj/structure/lift/button/railing
	icon_state = "railing_button"

/obj/structure/lift/button/railing/New()
	..()
	pixel_x = -10
	pixel_y = 14

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	icon_state = "panel"

/obj/structure/lift/panel/attack_ghost(mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(mob/user)
	ui_interact(user)

/obj/structure/lift/panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ElevatorPanel", "Lift Panel")
		ui.open()

/obj/structure/lift/panel/ui_data(mob/user)
	. = list()
	.["areDoorsOpen"] = lift.doors_are_open()
	.["current"] = list(
		"label" = lift.current_floor.label,
		"name" = lift.current_floor.name,
		"ref" = REF(lift.current_floor),
	)
	.["options"] = list()

	for(var/datum/turbolift_floor/floor in lift.floors)
		.["options"] += list(list(
			"label" = floor.label,
			"name" = floor.name,
			"queued" = (floor in lift.queued_floors),
			"ref" = REF(floor),
		))

/obj/structure/lift/panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return TRUE

	switch(action)
		if("move_to_floor")
			lift.queue_move_to(locate(params["ref"]))
			. = TRUE
		if("open_doors")
			lift.open_doors()
			. = TRUE
		if("close_doors")
			lift.close_doors()
			. = TRUE
		if("emergency_stop")
			lift.emergency_stop()
			. = TRUE

	if(.)
		pressed(usr)

// End panel.
