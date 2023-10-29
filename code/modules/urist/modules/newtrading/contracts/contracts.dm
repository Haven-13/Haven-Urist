//this is the contract file. contract datums go here, but the actual meat of the contracts go in different files. please make a note of where the contract stuff is.
//all contracts need an accompanying paper //this isn't entirely true anymore, just for the physical traders

/datum/contract
	var/name = null
	var/desc = null
	var/datum/factions/issuer_faction = null //who are we doing this for
	var/money = 0 //how much money are we getting
	var/rep_points = 0 //how much rep are we getting
	var/points_per_unit = 0
	var/neg_rep_points = 0 //how much rep do we lose
	var/datum/factions/target_faction = null //and against who
	var/amount = 0 //how much of whatever we have to do
	var/completed = 0 //how much have we done

/datum/contract/New(issuer_faction)
	..()

	var/issuer = issuer_faction || src.issuer_faction  // New() takes precedence
	if(issuer)
		if (istype(issuer, /datum/factions))
			src.issuer_faction = issuer
		else
			src.issuer_faction = SSfactions.factions_by_type[issuer]

	if(target_faction)
		target_faction = SSfactions.factions_by_type[target_faction]

	if(points_per_unit && amount)
		rep_points = (points_per_unit * amount)

/datum/contract/proc/Complete(number = 0)
	completed += number
	if(completed >= amount)
		SSfactions.update_reputation(issuer_faction, rep_points)

		if(target_faction)
			SSfactions.update_reputation(target_faction, neg_rep_points)

		var/datum/transaction/T = new("[GLOB.using_map.station_name]", "Contract Completion", money, "[issuer_faction.name]")
		station_account.do_transaction(T)
		GLOB.using_map.completed_contracts += 1
		GLOB.using_map.contracts -= src
		qdel(src)

/datum/contract/nanotrasen
	issuer_faction = /datum/factions/nanotrasen

/datum/contract/nanotrasen/anomaly //code\modules\xenoarcheaology\tools\artifact_analyser.dm
	name = "Anomaly Research Contract"

/datum/contract/nanotrasen/anomaly/New()
	amount = rand(1,3)
	money = (amount * rand(900,1750))
	rep_points = amount
	desc = "The Galactic Crisis has nearly eliminated NanoTrasen's presence in this sector. That's why NanoTrasen has contracted the [GLOB.using_map.station_name] to analyze [amount] of the anomalies in this sector for us. Good luck."

	..()

/datum/contract/terran
	issuer_faction = /datum/factions/terran

/datum/contract/uha //united human alliance
	issuer_faction = /datum/factions/uha

//shiphunting

/datum/contract/shiphunt/New()
	..()

	if(!amount)
		amount = rand(1,3)

	var/oldmoney = money
	money = (amount * oldmoney)

	desc = "This sector is plagued by [target_faction.factionid]s, [issuer_faction.name] need the [GLOB.using_map.station_name] to hunt down and destroy [amount] [target_faction.name] ships in this sector."


	if(!neg_rep_points)
		neg_rep_points -= rep_points

//money values are very much in flux

/datum/contract/shiphunt/pirate
	name = "Pirate Ship Hunt Contract"
	target_faction = /datum/factions/pirate
	points_per_unit = 3
	money = 4000

/datum/contract/shiphunt/alien
	name = "Lactera Ship Hunt Contract"
	target_faction = /datum/factions/alien
	rep_points = 7
	amount = 1
	money = 8500

//station destroy

/datum/contract/station_destroy/pirate
	name = "Pirate Hideout Destruction Contract"
	desc = "This sector is plagued by pirates. We need you to hunt down their hideout and destroy it for good."
	target_faction = /datum/factions/pirate
	rep_points = 10
	amount = 1
	money = 20000
