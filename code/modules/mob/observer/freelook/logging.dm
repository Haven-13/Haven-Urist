/datum/chunk/proc/log_visualnet(message, datum/source)
	visualnet.log_visualnet("[src] ([x]-[y]-[z]) - [message]", source)

/datum/visualnet/proc/log_visualnet(message, datum/source)
	log_debug("[src] - [message]: [istype(source) ? "[source] ([source.type])" : (source || "NULL") ]")
