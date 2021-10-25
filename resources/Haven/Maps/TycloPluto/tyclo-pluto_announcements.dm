/datum/map/tyclo_pluto/map_info(victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, "You're aboard the <b>[src.full_name]</b>, an independently contracted vessel owned by the Captain. Its primary mission is whatever the Captain dictates, which can include trading, scavenging or exploration.")
	to_chat(victim, "The vessel is staffed with a mix of personnel, hailing from multiple different backgrounds and factions. While the ship itself is an independently contracted vessel, the crew may have their own loyalties.")
	to_chat(victim, "This area of space is on the frontier, and is largely unsettled and unexplored. Any extensive settlements were destroyed during the Galactic Crisis.")
	to_chat(victim, "You might encounter remote outposts, pirates, or drifting hulks, but no one faction can claim to fully control this sector.")

/datum/map/tyclo_pluto/send_welcome()
	var/welcome_text = "<center><br /><font size = 3><b>[src.full_name]</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[system_name()]</b><br />"
	welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
	welcome_text += "Travel time to Sol:<br /><b>[rand(5,10)] days</b><br />"
	welcome_text += "Time since last port visit:<br /><b>[rand(30,50)] days</b><br />"
	welcome_text += "Scan results:<br />"
	var/list/space_things = list()
	var/obj/effect/overmap/self = map_sectors["1"]
	for(var/zlevel in map_sectors)
		var/obj/effect/overmap/O = map_sectors[zlevel]
		if(O.name == self.name)
			continue
		space_things |= O

	for(var/obj/effect/overmap/O in space_things)
		var/location_desc = " at present co-ordinates."
		if (O.loc != self.loc)
			var/bearing = round(90 - Atan2(O.x - self.x, O.y - self.y),5) //fucking triangles how do they work
			if(bearing < 0)
				bearing += 360
			location_desc = ", bearing [bearing]."
		welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
	welcome_text += "<br>No distress calls logged.<br />"

	post_comm_message("[src.full_name] Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")
