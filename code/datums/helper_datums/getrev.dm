var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/revision_origin
	var/date
	var/showinfo
	var/list/testmerge

/datum/getrev/New()
	branch = get_git_head_branch()
	revision = rustg_git_revparse("HEAD")
	if(revision)
		date = rustg_git_commit_date(revision)
	revision_origin = rustg_git_revparse("origin/[branch]")

/datum/getrev/proc/get_git_head_branch()
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(head_branch.len)
		. = copytext(head_branch[1], 17)

/datum/getrev/proc/load_tgs_info()
	testmerge = world.TgsTestMerges()
	var/datum/tgs_revision_information/revinfo = world.TgsRevision()
	if(revinfo)
		revision = revinfo.commit
		revision_origin = revinfo.origin_commit
		date = revinfo.timestamp || rustg_git_commit_date(revision)

	// goes to DD log and the diary log
	log_world(get_log_message())

/datum/getrev/proc/get_log_message()
	var/list/msg = list()
	msg += "Running revision: [date]"
	if(revision_origin)
		msg += "origin: [revision_origin]"

	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		msg += "- TM PR #[tm.number] @ [tm.head_commit]"

	if(revision && revision != revision_origin)
		msg += "HEAD: [revision]"
	else if(!revision_origin)
		msg += "No commit information"

	return msg.Join("\n")

/datum/getrev/proc/get_test_merge_info(header = TRUE)
	if(!testmerge.len)
		return ""
	. = header ? "The following pull requests are currently test merged:<br>" : ""
	- += "<ul>"
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.head_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " @ " + html_encode(copytext_char(cm, 1, 6))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<li><a href=\"[config.githuburl]/pull/[tm.number]\">#[tm.number][details]</a></li>"
	. += "</ul>"

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	to_chat(src, "<b>Client Version:</b> [src.byond_version].[src.byond_build]")
	to_chat(src, "<b>Server Version:</b> [world.byond_version].[world.byond_build]")
	var/server_revision = revdata.revision_origin || revdata.revision
	if(server_revision)
		if(config.githuburl && server_revision == revdata.revision_origin)
			server_revision = "<a href='[config.githuburl]/commit/[server_revision]'>[server_revision]</a>"
		if(revdata.branch)
			server_revision = "[server_revision] `[revdata.branch]`"
		if(revdata.date)
			server_revision = "[server_revision] [revdata.date]"
		to_chat(src, "<b>Server Revision:</b> [server_revision]")
	else
		to_chat(src, "<b>Server Revision:</b> Revision Unknown")
	if(revdata.testmerge.len)
		to_chat(src, revdata.GetTestMergeInfo())
	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		to_chat(src, "Server tools version: [version.raw_parameter]")
	to_chat(src, "Game ID: <b>[game_id]</b>")
	to_chat(src, "Current map: [GLOB.using_map.full_name]")
