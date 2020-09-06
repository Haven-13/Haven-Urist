/datum/computer_file/program/ship_contact
	filename = "shipcontact"
	filedesc = "Ship to Ship Communication"
	extended_desc = "This program allows access to communication with other nearby vessels."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 4
	requires_ntnet = 1
	available_on_ntnet = 0
	ui_module_path = /datum/ui_module/ship_contact
//	usage_flags = PROGRAM_ALL

/datum/ui_module/ship_contact
	name = "Ship to Ship Communication"
	var/mob/living/simple_animal/hostile/overmapship/ship
	var/category_contents
	var/obj/machinery/computer/combatcomputer/CC
	var/shipid = "nerva"

/datum/ui_module/ship_contact/New()
	for(var/obj/machinery/computer/combatcomputer/comp in SSmachines.machinery)
		if(comp.shipid == src.shipid)
			CC = comp

//	shipid = CC.shipid

/datum/ui_module/ship_contact/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ShipContact")
		ui.open()

/datum/ui_module/ship_contact/ui_data(mob/user)
	var/list/data = host.initial_data()

	data["nearby_ship"] = category_contents

	return data

/datum/ui_module/ship_contact/Topic(href, href_list)
	ship = CC.target

//	var/mob/user = usr
	if(..())
		return 1
	if(href_list["engage"])
		if(!CC.homeship.incombat) //ew
			engage()

	if(href_list["dock"])
		if(!CC.homeship.incombat) //ew
			dock()

/datum/ui_module/ship_contact/proc/engage()
	CC.homeship.enter_combat()

/datum/ui_module/ship_contact/proc/dock()
	if(!CC.homeship.docked)
		CC.homeship.docked = 1
		ship.spawnmap()

	else
		CC.homeship.docked = 0
		CC.homeship.leave_combat()
		ship.despawnmap()
		ship.incombat = 0
		CC.homeship.set_targets()
		ship.stop_automated_movement = 0

/datum/ui_module/ship_contact/proc/generate_categories()
	category_contents = list()
	ship = null //why did i do this
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		ship = CC.target

		var/list/category[0]
		category.Add(list(list(
			"name" = ship.name,
			"desc" = ship.desc,
			"faction" = ship.hiddenfaction,
			"hull" = ship.health,
			"shield" = ship.shields
		)))
		category_contents[ship.name] = category

	ship = null