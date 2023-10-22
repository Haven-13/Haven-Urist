#define BG_READY 0
#define BG_PROCESSING 1
#define BG_COMPLETE 2
#define BG_EMPTY 3

/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'resources/icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = 0
	var/points = 0
	var/state = BG_READY
	var/denied = 0
	var/build_eff = 1
	var/eat_eff = 1
	var/ingredients = 0 //How many processable ingredients are stored inside.
	var/capacity = 10   //How many ingredients can we store?
	var/list/products = list(
		"Food" = list(
			/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton = 30,
			/obj/item/weapon/reagent_containers/food/drinks/milk = 50,
			/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh = 50),
		"Nutrients" = list(
			/obj/item/weapon/reagent_containers/glass/bottle/eznutrient = 60,
			/obj/item/weapon/reagent_containers/glass/bottle/left4zed = 120,
			/obj/item/weapon/reagent_containers/glass/bottle/robustharvest = 120),
		"Leather" = list(
			/obj/item/weapon/storage/wallet/leather = 100,
			/obj/item/clothing/gloves/thick/botany = 250,
			/obj/item/weapon/storage/belt/utility = 300,
			/obj/item/weapon/storage/backpack/satchel = 400,
			/obj/item/weapon/storage/bag/cash = 400,
			/obj/item/clothing/shoes/workboots = 400,
			/obj/item/clothing/shoes/leather = 400,
			/obj/item/clothing/shoes/dress = 400,
			/obj/item/clothing/suit/leathercoat = 500,
			/obj/item/clothing/suit/storage/toggle/brown_jacket = 500,
			/obj/item/clothing/suit/storage/toggle/bomber = 500,
			/obj/item/clothing/suit/storage/hooded/wintercoat = 500))

/obj/machinery/biogenerator/New()
	..()
	create_reagents(1000)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/biogenerator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)

	RefreshParts()

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(state == BG_READY || state == BG_COMPLETE)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(obj/item/O as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	else if(ingredients >= capacity)
		to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
	else if(istype(O, /obj/item/weapon/storage/plants))
		var/obj/item/weapon/storage/plants/P = O
		var/hadPlants = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in P.contents)
			hadPlants = 1
			P.remove_from_storage(G, src, 1) //No UI updates until we are all done.
			ingredients++
			if(ingredients >= capacity)
				to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
				break
		P.finish_bulk_removal() //Now do the UI stuff once.
		if(!hadPlants)
			to_chat(user, "<span class='notice'>\The [P] has no produce inside.</span>")
		else if(ingredients < capacity)
			to_chat(user, "<span class='notice'>You empty \the [P] into \the [src].</span>")


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else if(user.unEquip(O, src))
		ingredients++
		to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/biogenerator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Biogenerator", name)
		ui.open()

/obj/machinery/biogenerator/ui_static_data(mob/user)
	var/list/categories = list()
	for(var/c_type =1 to products.len)
		var/category_name = products[c_type]
		var/list/current_content = products[category_name]
		var/list/listed_products = list()
		for(var/c_product =1 to current_content.len)
			var/path = current_content[c_product]
			var/atom/A = path
			var/name = initial(A.name)
			var/cost = current_content[path]
			listed_products.Add(list(list(
				"id" = c_product,
				"name" = name,
				"cost" = cost)))
		categories.Add(list(list(
			"name" = category_name,
			"items" = listed_products)))
	return list(
		"capacity" = capacity,
		"categories" = categories
	)

/obj/machinery/biogenerator/ui_data(mob/user)
	. = list(
		"state" = state,
		"can_process" = BG_READY && ingredients > 0,
		"ingredients" = ingredients,
		"biomass" = points,
		"processing" = state == BG_PROCESSING
	)

/obj/machinery/biogenerator/ui_act(action, list/params)
	UI_ACT_CHECK

	switch (action)
		if("activate")
			activate()
		if("create")
			if (state == BG_PROCESSING)
				return TRUE
			var/type = params["category"]
			var/product_index = params["id"]
			var/amount = max(1, params["amount"])
			if (isnull(products[type]))
				return TRUE
			var/list/sub_products = products[type]
			if (product_index < 1 || product_index > sub_products.len)
				return TRUE
			create_product(type, sub_products[product_index], amount)
	return TRUE

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return

	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		ingredients--
		if(I.reagents.get_reagent_amount(/datum/reagent/nutriment) < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount(/datum/reagent/nutriment) * 10 * eat_eff
		qdel(I)
	if(S)
		state = BG_PROCESSING
		update_icon()
		playsound(src.loc, 'resources/sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		state = BG_READY
		update_icon()
	else
		state = BG_EMPTY
	return

/obj/machinery/biogenerator/proc/create_product(type, path, amount)
	state = BG_PROCESSING
	var/cost = products[type][path] * amount
	cost = round(cost/build_eff)
	points -= cost
	update_icon()
	sleep(30)
	for (var/i in 1 to amount)
		var/atom/movable/result = new path
		result.dropInto(loc)
	state = BG_COMPLETE
	update_icon()
	return 1


/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
