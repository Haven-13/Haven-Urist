SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 20 SECONDS
	priority = SS_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/donelist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 30 SECONDS
	var/datum/shuttle/autodock/ferry/supply/shuttle
	var/list/point_source_descriptions = list(
		"time" = "Base station supply",
		"manifest" = "From exported manifests",
		"crate" = "From exported crates",
		"virology" = "From uploaded antibody data",
		"gep" = "From uploaded good explorer points",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

/datum/controller/subsystem/supply/Initialize()
	. = ..()
	ordernum = rand(1,9000)

	if(GLOB.using_map.using_new_cargo) //here we do setup for the new cargo system
		points_per_process = 0


		point_source_descriptions = list(
			"time" = "Base station supply",
			"manifest" = "From exported manifests",
			"crate" = "From exported crates",
			"virology" = "From uploaded antibody data",
			"gep" = "From uploaded good explorer points",
			"trade" = "From trading items",
			"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
		)

	//Build master supply list
	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				master_supply_list += spc

	for(var/material/mat in SSmaterials.materials)
		if(mat.sale_price > 0)
			point_source_descriptions[mat.display_name] = "From exported [mat.display_name]"

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")

//	if(GLOB.using_map.using_new_cargo)
//		points = station_account.money

/datum/controller/subsystem/supply/stat_entry()
	..("Points: [points]")

//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

	if(GLOB.using_map.using_new_cargo)
	//	var/newamount = (amount * GLOB.using_map.new_cargo_inflation)
		station_account.money += amount
		points = station_account.money

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/machinery/power/supermatter))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/subsystem/supply/proc/sell()
	var/list/material_count = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue

			if(GLOB.using_map.using_new_cargo) //this allows for contracts that call for obj/structures
				for(var/datum/contract/cargo/CC in GLOB.using_map.contracts)
					if(AM.type in CC.wanted_types)
						CC.Complete(1)
						qdel(AM)
						continue

			if(istype(AM, /obj/structure/closet/crate/))
				var/obj/structure/closet/crate/CR = AM
				callHook("sell_crate", list(CR, subarea))
				add_points_from_source(CR.points_per_crate, "crate")
				var/find_slip = 1
				for(var/atom in CR)
					// Sell manifests
					var/atom/A = atom

					if(GLOB.using_map.using_new_cargo)
						for(var/datum/contract/cargo/CC in GLOB.using_map.contracts) //just in case someone shoved it in a crate
							if(A.type in CC.wanted_types)
								CC.Complete(1)
								//qdel(AM)
								continue

						if(istype(A, /obj/item/stack/material))
							var/obj/item/stack/material/P = A
							var/material/material = P.get_material()
							if(material.sale_price > 0)
								var/materialmoney = P.get_amount() * material.sale_price
								materialmoney *= GLOB.using_map.new_cargo_inflation
								materialmoney *= 0.25 //test and balance
								material_count[material.display_name] += materialmoney
//								station_account.money += materialmoney
//								points = station_account.money

						else

							var/obj/O = A
							var/addvalue = (find_item_value(O) * 0.75) //we get even less for selling in bulk
							add_points_from_source(addvalue, "trade")
//							station_account.money += addvalue
//							points = station_account.money

					if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //Any stamp works.
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Sell materials
					if(istype(A, /obj/item/stack))
						if(!GLOB.using_map.using_new_cargo) //Bay sucks cock, so now we're just doing it through our price system
							var/obj/item/stack/P = A
							var/material/material = P.get_material()
							if(material.sale_price > 0)
								material_count[material.display_name] += P.get_amount() * material.sale_price
							continue

					// Must sell ore detector disks in crates
					if(istype(A, /obj/item/weapon/disk/survey))
						var/obj/item/weapon/disk/survey/D = A
						add_points_from_source(round(D.Value() * 0.005), "gep")
			qdel(AM)

	if(material_count.len)
		for(var/material_type in material_count)
			add_points_from_source(material_count[material_type], material_type)

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T
	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/weapon/paper/manifest(A, JOINTEXT(info))
			slip.is_copy = 0

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(!is_list(SP.access))
				A.req_access = list(SP.access)
			else if(is_list(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/orderedjob = null //used for supply console printing

/datum/controller/subsystem/supply/proc/find_item_value(obj/object)
	if(!object)
		return 0

	//this uses the default SS13 item_worth procs so its a good fallback
	. = get_value(object)

	var/datum/trade_item/T

	//try and find it via the global controller
	T = SStrade_controller.trade_items_by_type[object.type]
	if(T)
		return T.value
