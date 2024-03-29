
/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'resources/icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = BELOW_OBJ_LAYER
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_REACT

	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/list/item_records = list()
	var/datum/stored_items/currently_vending = null	//What we're putting out of the machine.
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/datum/wires/smartfridge/wires = null

/obj/machinery/smartfridge/secure
	is_secure = 1

/obj/machinery/smartfridge/New()
	..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	wires = null
	for(var/datum/stored_items/S in item_records)
		qdel(S)
	item_records = null
	return ..()

/obj/machinery/smartfridge/proc/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon = 'resources/icons/obj/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/machinery/smartfridge/seeds/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts."
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	req_one_access = list(access_medical,access_chemistry)

/obj/machinery/smartfridge/secure/medbay/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/))
		return 1
	if(istype(O,/obj/item/weapon/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/weapon/reagent_containers/pill/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access = list(access_virology)
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/machinery/smartfridge/secure/virology/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/weapon/virusdish/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/foods
	name = "\improper Hot Foods Display"
	desc = "A heated storage unit for piping hot meals."
	icon_state = "smartfridge_food"
	icon_on = "smartfridge_food"
	icon_off = "smartfridge_food-off"

/obj/machinery/smartfridge/foods/accept_check(obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks) || istype(O,/obj/item/weapon/material/kitchen/utensil))
		return 1

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	icon_state = "drying_rack"
	icon_on = "drying_rack_on"
	icon_off = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(obj/item/O as obj)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1
	return 0

/obj/machinery/smartfridge/drying_rack/Process()
	..()
	if(inoperable())
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	overlays.Cut()
	if(inoperable())
		icon_state = icon_off
	else
		icon_state = icon_on
	if(contents.len)
		overlays += "drying_rack_filled"
		if(!inoperable())
			overlays += "drying_rack_drying"

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/datum/stored_items/I in item_records)
		for(var/obj/item/weapon/reagent_containers/food/snacks/S in I.instances)
			if(S.dry || !I.get_specific_product(get_turf(src), S)) continue
			if(S.dried_type == S.type)
				S.dry = 1
				S.SetName("dried [S.name]")
				S.color = "#a38463"
				stock_item(S)
			else
				var/D = S.dried_type
				new D(get_turf(src))
				qdel(S)
			return

/obj/machinery/smartfridge/Process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(obj/item/O as obj, mob/user as mob)
	if(is_screwdriver(O))
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		SStgui.update_uis(src)
		return

	if(is_multitool(O) || is_wirecutter(O))
		if(panel_open)
			attack_hand(user)
		return

	if(stat & NOPOWER)
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		if(!user.unEquip(O))
			return
		stock_item(O)
		user.visible_message("<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")

	else if(istype(O, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/bag/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G) && P.remove_from_storage(G, src))
				plants_loaded++
				stock_item(G)

		if(plants_loaded)
			user.visible_message("<span class='notice'>\The [user] loads \the [src] with the contents of \the [P].</span>", "<span class='notice'>You load \the [src] with the contents of \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items were refused.</span>")

	else
		to_chat(user, "<span class='notice'>\The [src] smartly refuses [O].</span>")
	return 1

/obj/machinery/smartfridge/secure/emag_act(remaining_charges, mob/user)
	if(!emagged)
		emagged = 1
		locked = -1
		to_chat(user, "You short out the product lock on [src].")
		return 1

/obj/machinery/smartfridge/proc/stock_item(obj/item/O)
	for(var/datum/stored_items/I in item_records)
		if(istype(O, I.item_path) && O.name == I.item_name)
			stock(I, O)
			return

	var/datum/stored_items/I = new/datum/stored_items(src, O.type, O.name)
	dd_insertObjectList(item_records, I)
	stock(I, O)

/obj/machinery/smartfridge/proc/stock(datum/stored_items/I, obj/item/O)
	I.add_product(O)
	SStgui.update_uis(src)

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SmartFridge", name)
		ui.open()

/obj/machinery/smartfridge/ui_data(mob/user)
	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_items/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(I.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	return data

/obj/machinery/smartfridge/ui_act(action, list/params)
	UI_ACT_CHECK

	switch(action)
		if("vend")
			var/index = params["vend"]
			var/amount = params["amount"]
			var/datum/stored_items/I = item_records[index]
			var/count = I.get_amount()

			// Sanity check, there are probably ways to press the button when it shouldn't be possible.
			if(count > 0)
				if((count - amount) < 0)
					amount = count
				for(var/i = 1 to amount)
					I.get_product(get_turf(src))

			return TRUE

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/I in src.item_records)
		throw_item = I.get_product(loc)
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return 1

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN)) return 0
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !emagged && locked != -1 && href_list["vend"])
			to_chat(usr, "<span class='warning'>Access denied.</span>")
			return 0
	return ..()
