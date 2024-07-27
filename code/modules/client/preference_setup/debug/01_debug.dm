/datum/category_item/player_setup_item/save_debug/debug
	name = "Content Debug"
	sort_order = 1

/datum/category_item/player_setup_item/save_debug/debug/content()
	. = list()
	. += "<b>Loaded Preference Info:</b>"
	. += "<div style='background-color: black'>"
	. += "<pre>[html_encode(pref.loaded_preferences.ExportText())]</pre>"
	. += "</div>"
	. = jointext(., null)
