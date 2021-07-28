/obj/structure/tool_cart
	name = "tool cart"
	desc = "The most ultimate cart"
	icon = null
	anchored = 0
	density = 1
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE

	var/list/datum/tool_cart_item/items
	var/list/datum/tool_cart_stack/stacks

/obj/structure/tool_cart/Destroy()
	. = ..()
	QDEL_NULL_LIST(items)
	QDEL_NULL_LIST(stacks)

/obj/structure/tool_cart/attackby(obj/item/I, mob/user)
	for (var/item in items)
		if(istype(I, items[item].my_type))
			if(!items[item].item)
				put_in_cart(I, user)
				items[item].item = I
				update_icon()
				return TRUE
			else
				to_chat(user, "<span class='notice'>There is already one [items[item].item.name] in [src].</span>")
	for (var/stack in stacks)
		if(istype(I, stacks[stack].my_type))
			if(stacks[stack].amount < stacks[stack].maxAmount)
				put_in_cart(I, user)
				stacks[stack].amount++
				update_icon()
				return TRUE
			else
				to_chat(user, "<span class='notice'>You can't fit more of [I.name] in [src].</span>")


/obj/structure/tool_cart/proc/put_in_cart(obj/item/I, mob/user)
	user.drop_item()
	I.loc = src
	to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
	return

/obj/structure/tool_cart/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ToolCart", name)
		ui.open()

/obj/structure/tool_cart/ui_data(mob/user)
	. = list(
		"items" = list(),
		"stacks" = list()
	)
	if(items)
		for (var/item in items)
			.["items"] += list(list(
				"key" = item,
				"label" = items[item].label,
				"name" = items[item].item ? capitalize(items[item].item.name) : null
			))
	if(stacks)
		for (var/stack in stacks)
			.["stacks"] += list(list(
				"key" = stack,
				"label" = stacks[stack].label,
				"amount" = stacks[stack].amount
			))

/obj/structure/tool_cart/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("take")
			var/target = params["take"]
			if (items && (target in items))
				. = take_cart_item(target)
			if (!(.) && stacks && (target in stacks))
				. = take_cart_stack_item(target)
	if(.)
		update_icon()

/obj/structure/tool_cart/proc/take_cart_item(target)
	var/item = items[target].item
	usr.put_in_hands(item)
	to_chat(usr, "<span class='notice'>You take [item] from [src].</span>")
	items[target].item = null
	return TRUE

/obj/structure/tool_cart/proc/take_cart_stack_item(target)
	var/item = locate(stacks[target].my_type) in src
	if(item)
		usr.put_in_hands(item)
		to_chat(usr, "<span class='notice'>You take \a [item] from [src].</span>")
		stacks[target].amount--
	else
		warning("[src] signs ([stacks[target].amount]) didn't match contents")
		stacks[target].amount = 0
	return TRUE

/obj/structure/tool_cart/update_icon()
	overlays.Cut()
	if (items)
		for (var/item in items)
			if(items[item].item)
				overlays += items[item].overlay_name
	if (stacks)
		for (var/stack in stacks)
			if(stacks[stack].amount > 0)
				overlays += "[stacks[stack].overlay_name][stacks[stack].amount]"
