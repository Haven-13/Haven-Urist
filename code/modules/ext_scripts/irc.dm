/proc/send2irc(channel, msg)
	export2irc(list(type="msg", mesg=msg, chan=channel, pwd=config.comms_password))

/proc/export2irc(params)
	if(config.use_irc_bot && config.irc_bot_host)
		spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
			world.Export("http://[config.irc_bot_host]:45678?[list2params(params)]")

/proc/runtimes2irc(runtimes, revision)
	export2irc(list(pwd=config.comms_password, type="runtime", runtimes=runtimes, revision=revision))

/proc/send2mainirc(msg)
	if(config.main_irc)
		send2irc(config.main_irc, msg)
	else if(world.TgsAvailable())
		send2tgs("Server", msg, FALSE)
	return

/proc/send2adminirc(msg)
	if(config.admin_irc)
		send2irc(config.admin_irc, msg)
	else if(world.TgsAvailable())
		send2tgs("Server", msg, TRUE)
	return

/proc/send2tgs(msg,msg2,admin)
	msg = replacetext(replacetext(msg, "\proper", ""), "\improper", "")
	msg2 = replacetext(replacetext(msg2, "\proper", ""), "\improper", "")
	world.TgsTargetedChatBroadcast("[msg] | [msg2]", admin)

/proc/adminmsg2adminirc(client/source, client/target, msg)
	if(config.admin_irc)
		var/list/params[0]

		params["pwd"] = config.comms_password
		params["chan"] = config.admin_irc
		params["msg"] = msg
		params["src_key"] = source.key
		params["src_char"] = source.mob.real_name || source.mob.name
		if(!target)
			params["type"] = "adminhelp"
		else if(istext(target))
			params["type"] = "ircpm"
			params["target"] = target
			params["rank"] = source.holder ? source.holder.rank : "Player"
		else
			params["type"] = "adminpm"
			params["trg_key"] = target.key
			params["trg_char"] = target.mob.real_name || target.mob.name

		export2irc(params)
		if(world.TgsAvailable())
			send2tgs("[params["type"]] from [params["src_key"]] ([params["src_char"]]) [target ? "to [istext(target) ? "[params["target"]] ([params["rank"]])" : "[params["trg_key"]] ([params["trg_char"]])"]" : null]", msg, TRUE)

/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://[config.serverurl || (config.server || "[world.address]:[world.port]")]")
	return 1

