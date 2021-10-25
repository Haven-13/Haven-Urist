/decl/cultural_info/culture/synth
	name = CULTURE_SYNTHMORPHS
	description = {"
		As a synthmorph, you are either a free mind born out of an artifical consciousness
		training factory, a copy of an uploaded mind pattern, or simply a consciousness
		transferred from an old body. You have the necessary identity for a synthmorph,
		and have the freedom to identify yourself to a culture of choice or other. Or just
		simply take pride in being a synthmorph.
	"}
	language = LANGUAGE_EAL
	name_language = LANGUAGE_EAL
	additional_langs = list(LANGUAGE_GALCOM)

/decl/cultural_info/culture/synth/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)
