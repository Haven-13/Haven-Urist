/datum/ui_module/program/computer_chatclient
	name = "NTNet Relay Chat Client"
	ui_interface_name = "programs/NtosNetChat"

/datum/ui_module/program/computer_chatclient/ui_data(mob/user)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/datum/computer_file/program/chatclient/C = program

	data["adminmode"] = C.netadmin_mode
	if(C.channel)
		data["title"] = C.channel.title
		var/list/messages[0]
		for(var/M in C.channel.messages)
			messages.Add(list(list(
				"msg" = M
			)))
		data["messages"] = messages
		var/list/clients[0]
		for(var/datum/computer_file/program/chatclient/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username
			)))
		data["clients"] = clients
		C.operator_mode = (C.channel.operator == C) ? 1 : 0
		data["is_operator"] = C.operator_mode || C.netadmin_mode

	else // Channel selection screen
		var/list/all_channels[0]
		for(var/datum/ntnet_conversation/conv in ntnet_global.chat_channels)
			if(conv && conv.title)
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id
				)))
		data["all_channels"] = all_channels

	return data