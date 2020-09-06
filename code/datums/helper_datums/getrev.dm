var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo
	var/list/testmerge

/datum/getrev/New()
	testmerge = world.TgsTestMerges()
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(head_branch.len)
		branch = copytext(head_branch[1], 17)

	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=head_log.len, line>=1, line--)
		if(head_log[line])
			var/list/last_entry = splittext(head_log[line], " ")
			if(last_entry.len < 2)	continue
			revision = last_entry[2]
			// Get date/time
			if(last_entry.len >= 5)
				var/unix_time = text2num(last_entry[5])
				if(unix_time)
					date = unix2date(unix_time)
			break

	world.log << "Running revision:"
	world.log << branch
	world.log << date
	world.log << revision

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	to_chat(src, "<b>Client Version:</b> [byond_version]")
	if(revdata.revision)
		var/server_revision = revdata.revision
		if(config.githuburl)
			server_revision = "<a href='[config.githuburl]/commit/[server_revision]'>[server_revision]</a>"
		to_chat(src, "<b>Server Revision:</b> [server_revision] - [revdata.branch] - [revdata.date]")
	else
		to_chat(src, "<b>Server Revision:</b> Revision Unknown")
	if(revdata.testmerge.len)
		to_chat(src, revdata.GetTestMergeInfo())
	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		to_chat(src, "Server tools version: [version.raw_parameter]")
	to_chat(src, "Game ID: <b>[game_id]</b>")
	to_chat(src, "Current map: [GLOB.using_map.full_name]")

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if(!testmerge.len)
		return ""
	. = header ? "The following pull requests are currently test merged:<br>" : ""
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.pull_request_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<a href=\"[config.githuburl]/pull/[tm.number]\">#[tm.number][details]</a><br>"
