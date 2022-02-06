#define COLOUR_NORMAL_TEXT "#202020"

#define COLOUR_DARK_BG "#202020"
#define COLOUR_DARK_BG_DARKER "#171717"
#define COLOUR_DARK_TEXT "#d6bfa4"

#define COLOUR_DARK_BUTTON_BG "#494949"
#define COLOUR_DARK_GITHUB_BUTTON_BG "#a3a3a3"
#define COLOUR_DARK_ISSUE_BUTTON_BG "#492020"

#define COLOUR_DARK_TEXT_BODY "#eeeeee"
#define COLOUR_DARK_TEXT_MOTD "#eeeeee"

/proc/byond_map_theme()
	var/static/map_theme_cache = null
	if(!map_theme_cache)
		map_theme_cache = rustg_file_read("code/interface/map-theme.css")
	return map_theme_cache

/proc/byond_output_theme()
	var/static/output_theme_cache = null
	if (!output_theme_cache)
		var/in_css = rustg_file_read("code/interface/dark-textbox.css")
		var/css_parser/p = new()
		output_theme_cache = p.substitute_custom_properties(in_css)
	return output_theme_cache

/*
 * Should be used in all unique mob/Login() procs
 */
/proc/apply_global_theme(client/user)
	apply_skin_theme(user, list(
		"mapwindow.map.style=\"[byond_map_theme()]\"",
		"outputwindow.output.style=\"[byond_output_theme()]\""
	))
	apply_dark_theme(user)

/proc/apply_skin_theme(client/user, list/theme)
	for (var/line in theme)
		winset(user, null, line)

/proc/apply_dark_theme(client/user)
	apply_skin_theme(user, list(
		"infowindow.background-color=[COLOUR_DARK_BG]",
		"infowindow.text-color=[COLOUR_DARK_TEXT]",
		"browseroutput.background-color=[COLOUR_DARK_BG]",
		"browseroutput.text-color=[COLOUR_DARK_TEXT]",
		"outputwindow.background-color=[COLOUR_DARK_BG]",
		"outputwindow.text-color=[COLOUR_DARK_TEXT]",
		"mainwindow.background-color=[COLOUR_DARK_BG]",
		"rpanewindow.background-color=[COLOUR_DARK_BG]",
		"mainvsplit.background-color=[COLOUR_DARK_BG]",

		"text-button.background-color=[COLOUR_DARK_BUTTON_BG]",
		"text-button.text-color=[COLOUR_DARK_TEXT]",
		"info-button.background-color=[COLOUR_DARK_BUTTON_BG]",
		"info-button.text-color=[COLOUR_DARK_TEXT]",
		"changelog.background-color=[COLOUR_DARK_BUTTON_BG]",
		"changelog.text-color=[COLOUR_NORMAL_TEXT]",
		"rules.background-color=[COLOUR_DARK_BUTTON_BG]",
		"rules.text-color=[COLOUR_DARK_TEXT]",
		"wiki.background-color=[COLOUR_DARK_BUTTON_BG]",
		"wiki.text-color=[COLOUR_DARK_TEXT]",
		"forum.background-color=[COLOUR_DARK_BUTTON_BG]",
		"forum.text-color=[COLOUR_DARK_TEXT]",
		"github.background-color=[COLOUR_DARK_GITHUB_BUTTON_BG]",
		"github.text-color=[COLOUR_NORMAL_TEXT]",
		"report-issue.background-color=[COLOUR_DARK_ISSUE_BUTTON_BG]",
		"report-issue.text-color=[COLOUR_DARK_TEXT]",

		"output.background-color=[COLOUR_DARK_BG_DARKER]",
		"output.text-color=[COLOUR_DARK_TEXT]",
		"rpane.background-color=[COLOUR_DARK_BG]",
		"rpane.text-color=[COLOUR_DARK_TEXT]",
		"info.background-color=[COLOUR_DARK_BG_DARKER]",
		"info.tab-background-color=[COLOUR_DARK_BG]",
		"info.tab-text-color=[COLOUR_DARK_TEXT]",
		"info.text-color=[COLOUR_DARK_TEXT]",
		"info.prefix-color=[COLOUR_DARK_TEXT]",
		"info.suffix-color=[COLOUR_DARK_TEXT]",

		"saybutton.background-color=[COLOUR_DARK_BG]",
		"saybutton.text-color=[COLOUR_DARK_TEXT]",
		"hotkey_toggle.background-color=[COLOUR_DARK_BG]",
		"hotkey_toggle.text-color=[COLOUR_DARK_TEXT]"
	))

