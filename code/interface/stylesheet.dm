#define COLOUR_NORMAL_TEXT "#202020"

#define COLOUR_DARK_BG "#202020"
#define COLOUR_DARK_BG_DARKER "#171717"
#define COLOUR_DARK_TEXT "#d6bfa4"

#define COLOUR_DARK_BUTTON_BG "#494949"
#define COLOUR_DARK_GITHUB_BUTTON_BG "#a3a3a3"
#define COLOUR_DARK_ISSUE_BUTTON_BG "#492020"

#define COLOUR_DARK_TEXT_BODY "#eeeeee"
#define COLOUR_DARK_TEXT_MOTD "#eeeeee"

#define COLOUR_DARK_TEXT_CRITICAL "#aa19af"
#define COLOUR_DARK_TEXT_DANGER "#dd3320"
#define COLOUR_DARK_TEXT_WARNING "#f3be0e"
#define COLOUR_DARK_TEXT_NOTICE "#4495ff"
#define COLOUR_DARK_TEXT_INFO "#23e47a"

/proc/byond_map_theme()
	var/static/map_theme_cache = null
	if(!map_theme_cache)
		map_theme_cache = {"
.center {
	text-align: center;
}
.maptext {
	font-family: san-serif;
	font-size: 8px;
	color: white;
	line-height: 0.6;
	-dm-text-outline: 1px black;
}
.screen-tip {
	font-size: 12px;
	font-weight: 900;
}
.stylized {
	font-family: 'Consolas', san-serif;
}
.clown {
	font-family: 'Comic Sans MS', san-serif;
}
"}
	return map_theme_cache

/proc/byond_output_theme()
	var/static/output_theme_cache = null
	if (!output_theme_cache)
		output_theme_cache = {"
body {
	color: [COLOUR_DARK_TEXT_BODY];
	background-color:[COLOUR_DARK_BG_DARKER];
	font-family: Verdana, sans-serif;
}

h1, h2, h3, h4, h5, h6 {
	color:[COLOUR_DARK_TEXT_NOTICE];
	font-family: Georgia, Verdana, sans-serif;
}

em {
	font-style: normal;
	font-weight: bold;
}

.motd {
	color:[COLOUR_DARK_TEXT_MOTD];
	font-family: Verdana, sans-serif;
}

.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6 {
	color:[COLOUR_DARK_TEXT_MOTD];
	text-decoration: underline;
}

.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover {
	color:[COLOUR_DARK_TEXT_MOTD];
}

.prefix             {font-weight: bold;}
.log_message        {color:["#386aff"];	font-weight: bold;}

/* OOC */
.ooc                {font-weight: bold;}
.ooc img.text_tag   {width: 32px; height: 10px;}

.ooc .everyone      {color:["#174be6"];}
.ooc .looc          {color:["#2bb1b1"];}
.ooc .elevated      {color:["#2e78d9"];}
.ooc .moderator	    {color:["#275b96"];}
.ooc .developer     {color:["#2f8b35"];}
.ooc .admin         {color:["#c54014"];}
.ooc .aooc          {color:["#ca1b38"];}

/* Admin: Private Messages */
.staffwarn          {color:["#cc1f1f"]; font-weight:bold; font-size: 150%;}
.pm  .howto         {color:["#ff0000"];	font-weight: bold;		font-size: 200%;}
.pm  .in            {color:["#ff0000"];}
.pm  .out           {color:["#ff0000"];}
.pm  .other         {color:["#0000ff"];}

/* Admin: Channels */
.mod_channel        {color:["#9e6d39"];	font-weight: bold;}
.mod_channel .admin {color:["#c54014"];	font-weight: bold;}
.admin_channel      {color:["#9e43c9"];	font-weight: bold;}

/* Radio: Misc */
.deadsay            {color:["#7334c5"];}
.radio              {color:["#60a32d"];}
.deptradio          {color:["#b334b3"];}	/* when all other department colors fail */
.newscaster         {color:["#a12424"];}

/* Radio Channels */
.comradio           {color:["#375dbd"];}
.syndradio          {color:["#9c5d5e"];}
.centradio          {color:["#7373a3"];}
.airadio            {color:["#b334b3"];}
.entradio           {color:["#888888"];}

.secradio           {color:["#ac1313"];}
.engradio           {color:["#b97713"];}
.medradio           {color:["#16aaaa"];}
.sciradio           {color:["#993399"];}
.supradio           {color:["#aa884d"];}
.srvradio           {color:["#86b11b"];}
.expradio           {color:["#b4bb27"];}

/* Miscellaneous */
.name               {font-weight: bold;}
.say                {}
.alert              {color:[COLOUR_DARK_TEXT_DANGER];}
h1.alert, h2.alert  {color:[COLOUR_DARK_TEXT_BODY];}

.emote              {font-style: italic;}

/* Game Messages */
.attack	            {color:[COLOUR_DARK_TEXT_CRITICAL];}
.moderate           {color:[COLOUR_DARK_TEXT_DANGER];}
.disarm             {color:[COLOUR_DARK_TEXT_WARNING];}
.passive            {color:[COLOUR_DARK_TEXT_DANGER];}

.critical           {color:[COLOUR_DARK_TEXT_CRITICAL]; font-weight: bold;}
.danger             {color:[COLOUR_DARK_TEXT_DANGER]; font-weight: bold;}
.warning            {color:[COLOUR_DARK_TEXT_WARNING]; font-style: italic;}
.boldannounce       {color:[COLOUR_DARK_TEXT_DANGER]; font-weight: bold;}
.sinister           {color:["#800080"]; font-weight: bold;	font-style: italic;}
.rose               {color:["#ff5050"];}
.info               {color:[COLOUR_DARK_TEXT_INFO];}
.notice             {color:[COLOUR_DARK_TEXT_NOTICE];}
.alium              {color:["#00ff00"];}
.cult               {color:["#800080"]; font-weight: bold; font-style: italic;}
.fountain           {color:["#800080"]; font-style: italic; font-size: 175%;}

.reflex_shoot       {color:["#000099"]; font-style: italic;}

/* Languages */

.alien              {color:["#543354"];}
.skrell             {color:["#00ced1"];}
.soghun             {color:["#228b22"];}
.nabber_lang        {color:["#525252"];}
.solcom	            {color:["#22228b"];}
.changeling         {color:["#800080"];}
.vox                {color:["#aa00aa"];}
.rough              {font-family: \"Trebuchet MS\", cursive, sans-serif;}
.say_quote          {font-family: Georgia, Verdana, sans-serif;}
.terran             {color:["#9c250b"];}
.moon               {color:["#422863"];}
.spacer             {color:["#ff6600"];}
.adherent           {color:["#526c7a"];}

.interface          {color:["#330033"];}

.good               {color:["#4f7529"]; font-weight: bold;}
.bad                {color:["#ee0000"]; font-weight: bold;}

BIG IMG.icon        {width: 32px; height: 32px;}
"}
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

