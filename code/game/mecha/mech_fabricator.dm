/obj/machinery/mecha_part_fabricator
	icon = 'icons/obj/robotics.dmi'
	icon_state = "fab-idle"
	name = "Exosuit Fabricator"
	desc = "A machine used for construction of robotics and mechas."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)

	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "gold" = 0, "silver" = 0, "diamond" = 0, "phoron" = 0, "uranium" = 0)
	var/res_max_amount = 200000

	var/datum/research/files
	var/datum/design/current
	var/list/datum/design/queue = list()
	var/process_queue = 0
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/sync_message = ""

/obj/machinery/mecha_part_fabricator/New()
	..()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/mechfab(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

	files = new /datum/research(src) //Setup the research data holder.
	return

/obj/machinery/mecha_part_fabricator/Initialize()
	update_categories()
	. = ..()

/obj/machinery/mecha_part_fabricator/Process()
	..()
	if(stat)
		return
	if(busy)
		use_power = 2
		progress += speed
		check_build()
	else
		use_power = 1
	update_icon()

/obj/machinery/mecha_part_fabricator/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "fab-o"
	else
		icon_state = "fab-idle"
	if(busy)
		overlays += "fab-active"

/obj/machinery/mecha_part_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/mecha_part_fabricator/RefreshParts()
	res_max_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4 // 1 -> 0.5
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	speed = T / 2 // 1 -> 3

/obj/machinery/mecha_part_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		return
	ui_interact(user)

/obj/machinery/mecha_part_fabricator/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/mecha_part_fabricator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExosuitFabricator", name)
		ui.open()

/obj/machinery/mecha_part_fabricator/ui_static_data(mob/user)
	. = list(
		"buildable" = get_build_options(),
		"categories" = categories,
	)

/obj/machinery/mecha_part_fabricator/ui_data(mob/user)
	. = list(
		"current" = current ? list(
			"name" = current.name,
			"duration" = current.time - progress,
			"time" = current.time
		) : null,
		"queue" = get_queue(),
		"isProcessingQueue" = process_queue,
		"materials" = get_materials(),
		"maxres" = res_max_amount,
		"sync" = sync_message
	)

/obj/machinery/mecha_part_fabricator/ui_act(action, list/params)
	switch(action)
		if ("add_queue_part")
			add_to_queue(params["id"])
		if ("add_queue_set")
			add_to_queue_set(params["category"])
		if("remove_queue_part")
			remove_from_queue(params["id"])
		if("build_queue")
			process_queue = 1
			update_busy()
		if("stop_queue")
			process_queue = 0
		if("clear_queue")
			queue.Cut()
		if("eject_material")
			eject_materials(params["eject_material"], params["amount"])
		if("sync_rnd")
			sync()
	return TRUE

/obj/machinery/mecha_part_fabricator/attackby(var/obj/item/I, var/mob/user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

	if(!istype(I, /obj/item/stack/material))
		return ..()

	var/obj/item/stack/material/stack = I
	var/material = stack.material.name
	var/stack_singular = "[stack.material.use_name] [stack.material.sheet_singular_name]" // eg "steel sheet", "wood plank"
	var/stack_plural = "[stack.material.use_name] [stack.material.sheet_plural_name]" // eg "steel sheets", "wood planks"
	var/amnt = stack.perunit

	if(stack.uses_charge)
		return

	if(!(material in materials))
		to_chat(user, "<span class=warning>\The [src] does not accept [stack_plural]!</span>")
		return

	if(materials[material] + amnt <= res_max_amount)
		if(stack && stack.amount >= 1)
			var/count = 0
			overlays += "fab-load-metal"
			spawn(10)
				overlays -= "fab-load-metal"
			while(materials[material] + amnt <= res_max_amount && stack.amount >= 1)
				materials[material] += amnt
				stack.use(1)
				count++
			to_chat(user, "You insert [count] [count==1 ? stack_singular : stack_plural] into the fabricator.")// 0 steel sheets, 1 steel sheet, 2 steel sheets, etc

			update_busy()
	else
		to_chat(user, "The fabricator cannot hold more [stack_plural].")// use the plural form even if the given sheet is singular


/obj/machinery/mecha_part_fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("\icon[src] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB truncated. Please contact your [GLOB.using_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("\icon[src] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/machinery/mecha_part_fabricator/proc/update_busy()
	if(current)
		if(can_build(current))
			busy = 1
		else
			busy = 0
	else if(queue.len && process_queue)
		if(can_build(queue[1]))
			busy = 1
		else
			busy = 0
	else
		busy = 0

/obj/machinery/mecha_part_fabricator/proc/add_to_queue(var/index)
	var/datum/design/D = files.known_designs[index]
	queue += D
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/add_to_queue_set(var/list/category)
	if (!istype(category) || !category.len)
		return
	for (var/i = 1 to category.len)
		add_to_queue(category[i])

/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	return 1

/obj/machinery/mecha_part_fabricator/proc/check_build()
	if(!current)
		if(!queue.len || !process_queue)
			progress = 0
			return
		var/datum/design/D = queue[1]
		if(!can_build(D))
			progress = 0
			return
		// Make sure that these two lines below are in this order, or the object will freeze.
		current = D
		remove_from_queue(1)
	if(current.time > progress)
		return
	for(var/M in current.materials)
		materials[M] = max(0, materials[M] - current.materials[M] * mat_efficiency)
	if(current.build_path)
		var/obj/new_item = current.Fabricate(loc, src)
		visible_message("\The [src] pings, indicating that \the [current] is complete.", "You hear a ping.")
		if(mat_efficiency != 1)
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
	current = null
	progress = 0
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/get_queue()
	if(!istype(queue) || !length(queue))
		return list()

	. = list()
	for (var/i = 1 to queue.len)
		. += list(get_design_info(queue[i], i))

/obj/machinery/mecha_part_fabricator/proc/get_build_options()
	. = list()

	for (var/category in categories)
		.[category] = list()

	for(var/i = 1 to files.known_designs.len)
		var/datum/design/D = files.known_designs[i]
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		.[D.category] += list(get_design_info(D, i))

/obj/machinery/mecha_part_fabricator/proc/get_design_info(var/datum/design/D, idx=0)
	. = list(
		"name" = D.name,
		"desc" = D.desc,
		"id" = idx ? idx : D.id,
		"cost" = get_design_cost(D),
		"time" = get_design_time(D)
	)

/obj/machinery/mecha_part_fabricator/proc/get_design_cost(var/datum/design/D)
	. = list()
	for(var/T in D.materials)
		.[T] = D.materials[T] * mat_efficiency

/obj/machinery/mecha_part_fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/mecha_part_fabricator/proc/update_categories()
	categories = list()
	for(var/datum/design/D in files.known_designs)
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		categories |= D.category

	if(all_robolimbs)
		for(var/A in all_robolimbs)
			var/datum/robolimb/R = all_robolimbs[A]
			if(R.unavailable_at_fab || R.applies_to_part.len)
				continue
			categories |= R.company

/obj/machinery/mecha_part_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		. += list(list(
			"name" = capitalize(T),
			"amount" = materials[T],
			"removable" = 1, // This sucks donkey balls because whoever chickendipshit wrote the materials system didn't make a database controller so we could check them against it instead of going through the highly-galaxy-cultivated method as seen in the method below. Fuck you, Bay.
			"ref" = T
		))

/obj/machinery/mecha_part_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	var/mattype
	switch(material)
		if(DEFAULT_WALL_MATERIAL)
			mattype = /obj/item/stack/material/steel
		if("glass")
			mattype = /obj/item/stack/material/glass
		if("gold")
			mattype = /obj/item/stack/material/gold
		if("silver")
			mattype = /obj/item/stack/material/silver
		if("diamond")
			mattype = /obj/item/stack/material/diamond
		if("phoron")
			mattype = /obj/item/stack/material/phoron
		if("uranium")
			mattype = /obj/item/stack/material/uranium
		else
			return
	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in get_area_all_atoms(get_area(src)))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		sync_message = "Sync complete."
	update_categories()