/datum/browser
	var/mob/user
	var/title
	var/window_id // window_id is used as the window name for browse and onclose
	var/width = 0
	var/height = 0
	var/atom/ref = null
	var/window_options = "focus=0;can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	var/stylesheets[0]
	var/scripts[0]
	var/title_image
	var/head_elements
	var/body_elements
	var/head_content = ""
	var/content = ""
	var/title_buttons = ""
	var/static/datum/asset/simple/namespaced/common/common_asset = get_asset_datum(/datum/asset/simple/namespaced/common)


/datum/browser/New(nuser, nwindow_id, ntitle = 0, nwidth = 0, nheight = 0, var/atom/nref = null)
	user = nuser
	window_id = nwindow_id
	if (ntitle)
		title = format_text(ntitle)
	if (nwidth)
		width = nwidth
	if (nheight)
		height = nheight
	if (nref)
		ref = nref

/datum/browser/proc/set_title(ntitle)
	title = format_text(ntitle)

/datum/browser/proc/set_title_buttons(ntitle_buttons)
	title_buttons = ntitle_buttons

/datum/browser/proc/set_title_image(ntitle_image)
	title_image = ntitle_image

/datum/browser/proc/add_head_content(nhead_content)
	head_content = nhead_content

/datum/browser/proc/set_window_options(nwindow_options)
	window_options = nwindow_options

/datum/browser/proc/add_stylesheet(name, file)
	var/asset_name = "[name].css"

	stylesheets[asset_name] = file

	if (!SSassets.cache[asset_name])
		SSassets.transport.register_asset(asset_name, file)

/datum/browser/proc/add_script(name, file)
	scripts["[ckey(name)].js"] = file
	SSassets.transport.register_asset("[ckey(name)].js", file)

/datum/browser/proc/set_content(ncontent)
	content = ncontent

/datum/browser/proc/add_content(ncontent)
	content += ncontent

/datum/browser/proc/get_header()
	var/file
	head_content += "<link rel='stylesheet' type='text/css' href='[common_asset.get_url_mappings()["common.css"]]'>"
	for (file in stylesheets)
		testing("[SSassets.transport.get_asset_url(file)]")
		head_content += "<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url(file)]'>"

	for (file in scripts)
		testing("[SSassets.transport.get_asset_url(file)]")
		head_content += "<script type='text/javascript' src='[SSassets.transport.get_asset_url(file)]'></script>"

	return {"<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge'>
		[head_content]
	</head>
	<body scroll=auto>
		<div class='uiWrapper'>
			[title ? "<div class='uiTitleWrapper'><div class='uiTitle'><tt>[title]</tt></div></div>" : ""]
			<div class='uiContent'>
	"}
//" This is here because else the rest of the file looks like a string in notepad++.
/datum/browser/proc/get_footer()
	return {"
			</div>
		</div>
	</body>
</html>"}

/datum/browser/proc/get_content()
	return {"
	[get_header()]
	[content]
	[get_footer()]
	"}

/datum/browser/proc/open(use_onclose = TRUE)
	if(isnull(window_id))	//null check because this can potentially nuke goonchat
		WARNING("Browser [title] tried to open with a null ID")
		to_chat(user, "<span class='userdanger'>The [title] browser you tried to open failed a sanity check! Please report this on github!</span>")
		return
	var/window_size = ""
	if (width && height)
		window_size = "size=[width]x[height];"
	common_asset.send(user)
	if (stylesheets.len)
		testing("Sending stylesheets")
		SSassets.transport.send_assets(user, stylesheets)
	if (scripts.len)
		testing("Sending scripts")
		SSassets.transport.send_assets(user, scripts)
	user << browse(get_content(), "window=[window_id];[window_size][window_options]")
	if (use_onclose)
		setup_onclose()

/datum/browser/proc/update(var/force_open = 0, var/use_onclose = 1)
	if(force_open)
		open(use_onclose)
	else
		send_output(user, get_content(), "[window_id].browser")

/datum/browser/proc/setup_onclose()
	set waitfor = 0 //winexists sleeps, so we don't need to.
	for (var/i in 1 to 10)
		if (user && winexists(user, window_id))
			onclose(user, window_id, ref)
			break

/datum/browser/proc/close()
	if(!isnull(window_id))//null check because this can potentially nuke goonchat
		user << browse(null, "window=[window_id]")
	else
		WARNING("Browser [title] tried to close with a null ID")

// This will allow you to show an icon in the browse window
// This is added to mob so that it can be used without a reference to the browser object
// There is probably a better place for this...
/mob/proc/browse_rsc_icon(icon, icon_state, dir = -1)
	/*
	var/icon/I
	if (dir >= 0)
		I = new /icon(icon, icon_state, dir)
	else
		I = new /icon(icon, icon_state)
		dir = "default"

	var/filename = "[ckey("[icon]_[icon_state]_[dir]")].png"
	src << browse_rsc(I, filename)
	return filename
	*/


// Registers the on-close verb for a browse window (client/verb/.windowclose)
// this will be called when the close-button of a window is pressed.
//
// This is usually only needed for devices that regularly update the browse window,
// e.g. canisters, timers, etc.
//
// windowid should be the specified window name
// e.g. code is	: user << browse(text, "window=fred")
// then use 	: onclose(user, "fred")
//
// Optionally, specify the "ref" parameter as the controlled atom (usually src)
// to pass a "close=1" parameter to the atom's Topic() proc for special handling.
// Otherwise, the user mob's machine var will be reset directly.
//
/proc/onclose(mob/user, windowid, var/atom/ref=null)
	if(!user || !user.client) return
	var/param = "null"
	if(ref)
		param = "\ref[ref]"

	spawn(2)
		if(!user.client) return
		winset(user, windowid, "on-close=\".windowclose [param]\"")

//	log_debug("OnClose [user]: [windowid] : ["on-close=\".windowclose [param]\""]")



// the on-close client verb
// called when a browser popup window is closed after registering with proc/onclose()
// if a valid atom reference is supplied, call the atom's Topic() with "close=1"
// otherwise, just reset the client mob's machine var.
//
/client/verb/windowclose(var/atomref as text)
	set hidden = 1						// hide this verb from the user's panel
	set name = ".windowclose"			// no autocomplete on cmd line

//	log_debug("windowclose: [atomref]")

	if(atomref!="null")				// if passed a real atomref
		var/hsrc = locate(atomref)	// find the reffed atom
		if(hsrc)
//			log_debug("[src] Topic [href] [hsrc]")

			usr = src.mob
			src.Topic("close=1", list("close"="1"), hsrc)	// this will direct to the atom's
			return										// Topic() proc via client.Topic()

	// no atomref specified (or not found)
	// so just reset the user mob's machine var
	if(src && src.mob)
//		log_debug("[src] was [src.mob.machine], setting to null")

		src.mob.unset_machine()
	return
