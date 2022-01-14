//Urist custom languages file

//Totally-not-kobaian, because why not? It's a conlang and I'm a massive nerd.
/datum/language/mekanik
	name = "Sol-Divergent"
	description = "A strange, militaristic-sounding amalgamation of Germanic and Slavic languages contaminated with French and long isolation from mainstream humanity."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = "rough"
	key = null
	flags = RESTRICTED
	space_chance = 60

	//syllables are at the bottom of the file

/datum/language/mekanik/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick(exclaim_verb)
		if("?")
			return pick(ask_verb)
	return pick(speech_verb)

/datum/language/mekanik/get_random_name(var/gender) //TODO: custom Germanesque name list
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		return ..()

//Syllable Lists

/datum/language/mekanik/syllables = list(
"hur","dah", "ant", "wurdah ", "zik", "kehn", "ork", "bahnn", "strain", "wort", "sia", "felt", "wirt",
"da", "fenk", "zort", "wuhr", "di", "heul", "urwah ", "glae", "eteuhr", "wurd", "dowuri", "rin", "sun",
"hirr", "unt", "tlait", "wowosohn", "ri", "welt"
)
