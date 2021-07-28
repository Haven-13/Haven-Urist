#define AWAY_POINTS 45

/proc/createRandomZlevel()
	var/list/missions = getRandomAwayMissions()
	var/remaining = AWAY_POINTS
	admin_notice("<span class='danger'>Attempting to load away missions...</span>", R_DEBUG)
	while(remaining)
		var/randaway = pick(missions)
		var/datum/away_mission/possible_away = new randaway //TODO: datum to decl
		if(remaining - possible_away.value)
			remaining -= possible_away.value
			var/file = file(possible_away.map_path)
			if(isfile(file))
				maploader.load_map(file)
				possible_away.perform_setup()
				remaining -= possible_away.value
		missions -= randaway
		if(!missions.len)
			remaining = 0
	admin_notice("<span class='danger'>Away mission(s) loaded.</span>", R_DEBUG)

/proc/getRandomAwayMissions()
	var/list/possible_aways = subtypesof(/datum/away_mission)
	for(var/datum/away_mission/away in possible_aways)
		if(!away.random_start)
			possible_aways -= away
	return possible_aways

/proc/generateMapList(filename)
	var/list/potentialMaps = list()
	var/list/Lines = world.file2list(filename)

	if(!Lines.len)
		return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))

		else
			name = lowertext(t)

		if (!name)
			continue

		potentialMaps.Add(t)

	return potentialMaps
