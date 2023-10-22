/mob/living/simple_animal/hostile/sound
	var/list/last_saw
	var/list/alert_message = list("screeches at")
	var/list/alert_sound
	var/next_alert

/mob/living/simple_animal/hostile/sound/Initialize()
	. = ..()
	last_saw = list()

/mob/living/simple_animal/hostile/sound/hear_say(message, verb = "says", datum/language/language = null, alt_name = "",italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)
	if(speaker)
		alerted(speaker)
	if(!client)
		MoveToTarget()
	..()

/mob/living/simple_animal/hostile/sound/PickTarget(list/visible)
	var/list/moved = list()
	if(!visible.len)
		return
	for(var/mob/living/V in visible)
		if(V.name in last_saw)
			var/mob/living/M = last_saw[V.name]["mob"]
			if(V.x != last_saw[V.name]["x"] || V.y != last_saw[V.name]["y"])
				moved += M
	last_saw = list()
	for(var/mob/VI in visible)
		last_saw[VI.name] = list("mob" = VI, "x" = VI.x, "y" = VI.y)
	if(!moved.len)
		return
	var/youmessedup = pick(moved)
	alerted(youmessedup)
	return youmessedup

/mob/living/simple_animal/hostile/sound/LoseAggro()
	..()
	last_saw = list()

/mob/living/simple_animal/hostile/sound/proc/alerted(mob/detected)
	if(is_list(alert_message) && alert_message.len)
		if(next_alert > world.time)
			var/message = pick(alert_message)
			visible_message("<span class = 'danger'><font size = 3>[src] [message] [detected]!</font></span>")
			next_alert = world.time + 15 SECONDS
	if(is_list(alert_sound) && alert_sound.len)
		var/sound = pick(alert_sound)
		playsound(src, sound, 100, 1)
