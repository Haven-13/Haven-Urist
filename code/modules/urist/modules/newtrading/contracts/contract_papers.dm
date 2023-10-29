/obj/item/weapon/paper/contract
	var/contract_type = null
	var/datum/contract/contract_datum = null
	var/stored_faction = null
	var/list/potential_contracts = null //only use this for random ones, it'll pick one

/obj/item/weapon/paper/contract/New(loc)
	..(loc)

	if(potential_contracts)
		contract_type = pick(potential_contracts)

	// TODO: STOP USING HARDCODED FACTION AND UNFUCK THE WAY CONTRACTS ARE GRAFTED ONTO TRADING
	contract_datum = new contract_type(/datum/factions/nanotrasen) // hard-coded faction for now

	name = contract_datum.name
	info = contract_datum.desc

	update_icon()

	if(stored_faction && !contract_datum.issuer_faction)
		contract_datum.issuer_faction = src.stored_faction

	GLOB.using_map.contracts += contract_datum

/obj/item/weapon/paper/contract/nanotrasen
	stored_faction = "NanoTrasen"

/obj/item/weapon/paper/contract/nanotrasen/anomaly
	contract_type = /datum/contract/nanotrasen/anomaly

/obj/item/weapon/paper/contract/nanotrasen/piratehunt
	contract_type = /datum/contract/shiphunt/pirate

/obj/item/weapon/paper/contract/nanotrasen/alienhunt
	contract_type = /datum/contract/shiphunt/alien

