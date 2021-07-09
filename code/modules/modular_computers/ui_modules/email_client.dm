
/datum/ui_module/program/email_client/
	name = "Email Client"
	ui_interface_name = "programs/NtosEmailClient"

	var/stored_login = ""
	var/stored_password = ""
	var/error = ""

	var/msg_title = ""
	var/msg_body = ""
	var/msg_recipient = ""
	var/datum/computer_file/msg_attachment = null
	var/folder = "Inbox"
	var/addressbook = FALSE
	var/new_message = FALSE

	var/last_message_count = 0	// How many messages were there during last check.
	var/read_message_count = 0	// How many messages were there when user has last accessed the UI.

	var/datum/computer_file/downloading = null
	var/download_progress = 0
	var/download_speed = 0

	var/datum/computer_file/data/email_account/current_account = null
	var/datum/computer_file/data/email_message/current_message = null

/datum/ui_module/program/email_client/proc/mail_received(var/datum/computer_file/data/email_message/received_message)
	var/mob/living/L = get_holder_of_type(host, /mob/living)
	if(L)
		var/list/msg = list()
		msg += "*--*\n"
		msg += "<span class='notice'>New mail received from [received_message.source]:</span>\n"
		msg += "<b>Subject:</b> [received_message.title]\n<b>Message:</b>\n[pencode2html(received_message.stored_data)]\n"
		if(received_message.attachment)
			msg += "<b>Attachment:</b> [received_message.attachment.filename].[received_message.attachment.filetype] ([received_message.attachment.size]GQ)\n"
		msg += "<a href='?src=[REF(src)];open;reply=[received_message.uid]'>Reply</a>\n"
		msg += "*--*"
		to_chat(L, jointext(msg, null))

/datum/ui_module/program/email_client/Destroy()
	log_out()
	. = ..()

/datum/ui_module/program/email_client/proc/log_in()
	var/list/id_login

	if(istype(host, /obj/item/modular_computer))
		var/obj/item/modular_computer/computer = host
		var/obj/item/weapon/card/id/id = computer.GetIdCard()
		if(!id && ismob(computer.loc))
			var/mob/M = computer.loc
			id = M.GetIdCard()
		if(id)
			id_login = id.associated_email_login.Copy()

	var/datum/computer_file/data/email_account/target
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(!account || !account.can_login)
			continue
		if(id_login && id_login["login"] == account.login)
			target = account
			break
		if(stored_login && stored_login == account.login)
			target = account
			break

	if(!target)
		error = "Invalid Login"
		return FALSE

	if(target.suspended)
		error = "This account has been suspended. Please contact the system administrator for assistance."
		return FALSE

	var/use_pass
	if(stored_password)
		use_pass = stored_password
	else if(id_login)
		use_pass = id_login["password"]

	if(use_pass == target.password)
		current_account = target
		current_account.connected_clients |= src
		return TRUE
	else
		error = "Invalid Password"
		return FALSE

// Returns 0 if no new messages were received, 1 if there is an unread message but notification has already been sent.
// and 2 if there is a new message that appeared in this tick (and therefore notification should be sent by the program).
/datum/ui_module/program/email_client/proc/check_for_new_messages(var/messages_read = FALSE)
	if(!current_account)
		return 0

	var/list/allmails = current_account.inbox

	if(allmails.len > last_message_count)
		. = 2
	else if(allmails.len > read_message_count)
		. = 1
	else
		. = 0

	last_message_count = allmails.len
	if(messages_read)
		read_message_count = allmails.len


/datum/ui_module/program/email_client/proc/log_out()
	if(current_account)
		current_account.connected_clients -= src
	current_account = null
	downloading = null
	download_progress = 0
	last_message_count = 0
	read_message_count = 0

/datum/ui_module/program/email_client/ui_data(mob/user)
	var/list/data = host.initial_data()

	// Password has been changed by other client connected to this email account
	if(current_account)
		if(current_account.password != stored_password)
			if(!log_in())
				log_out()
				error = "Invalid Password"
		// Banned.
		else if(current_account.suspended)
			log_out()
			error = "This account has been suspended. Please contact the system administrator for assistance."

	data["error"] = error
	data["current_account"] = null
	data["addressbook"] = addressbook
	data["new_message"] = new_message
	data["view_message"] = !!current_message
	data["downloading"] = !!downloading
	if(downloading)
		data["down_filename"] = "[downloading.filename].[downloading.filetype]"
		data["down_progress"] = download_progress
		data["down_size"] = downloading.size
		data["down_speed"] = download_speed
	else if(istype(current_account))
		data["current_account"] = current_account.login
		if(addressbook)
			var/list/all_accounts = list()
			for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
				if(!account.can_login)
					continue
				all_accounts.Add(list(list(
					"login" = account.login
				)))
			data["accounts"] = all_accounts
		else if(new_message)
			data["msg_title"] = msg_title
			data["msg_preview"] = pencode2html(msg_body)
			data["msg_body"] = replacetext(msg_body, "\[br\]", "\n") // Why? Because I am done sucking Bay cock!
			data["msg_recipient"] = msg_recipient
			if(msg_attachment)
				data["msg_hasattachment"] = 1
				data["msg_attachment_filename"] = "[msg_attachment.filename].[msg_attachment.filetype]"
				data["msg_attachment_size"] = msg_attachment.size
		else if (current_message)
			data["cur_title"] = current_message.title
			data["cur_body"] = pencode2html(current_message.stored_data)
			data["cur_timestamp"] = current_message.timestamp
			data["cur_source"] = current_message.source
			data["cur_uid"] = current_message.uid
			if(istype(current_message.attachment))
				data["cur_hasattachment"] = 1
				data["cur_attachment_filename"] = "[current_message.attachment.filename].[current_message.attachment.filetype]"
				data["cur_attachment_size"] = current_message.attachment.size
		else
			data["label_inbox"] = "Inbox ([current_account.inbox.len])"
			data["label_outbox"] = "Sent ([current_account.outbox.len])"
			data["label_spam"] = "Spam ([current_account.spam.len])"
			data["label_deleted"] = "Deleted ([current_account.deleted.len])"
			data["at_prefix"] = "Received at"
			var/list/message_source
			if(folder == "Inbox")
				message_source = current_account.inbox
			else if(folder == "Sent")
				message_source = current_account.outbox
				data["at_prefix"] = "Sent at"
			else if(folder == "Spam")
				message_source = current_account.spam
			else if(folder == "Deleted")
				message_source = current_account.deleted

			if(message_source)
				data["folder"] = folder
				var/list/all_messages = list()
				for(var/datum/computer_file/data/email_message/message in message_source)
					all_messages.Add(list(list(
						"title" = message.title,
						"body" = pencode2html(message.stored_data),
						"source" = message.source,
						"timestamp" = message.timestamp,
						"uid" = message.uid
					)))
				data["messages"] = all_messages
				data["messagecount"] = all_messages.len
	else
		data["stored_login"] = stored_login
		data["stored_password"] = stars(stored_password, 0)

	return data

/datum/ui_module/program/email_client/proc/find_message_by_fuid(var/fuid)
	if(!istype(current_account))
		return null

	// href_list works with strings, so this makes it a bit easier for us
	if(istext(fuid))
		fuid = text2num(fuid)

	for(var/datum/computer_file/data/email_message/message in current_account.all_emails())
		if(message.uid == fuid)
			return message

/datum/ui_module/program/email_client/proc/clear_message()
	new_message = FALSE
	msg_title = ""
	msg_body = ""
	msg_recipient = ""
	msg_attachment = null
	current_message = null

/datum/ui_module/program/email_client/proc/relayed_process(var/netspeed)
	download_speed = netspeed
	if(!downloading)
		return FALSE

	download_progress = min(download_progress + netspeed, downloading.size)
	if(download_progress >= downloading.size)
		var/obj/item/modular_computer/MC = ui_host()
		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
			downloading = null
			download_progress = 0
			return TRUE

		if(MC.hard_drive.store_file(downloading))
			error = "File successfully downloaded to local device."
		else
			error = "Error saving file: I/O Error: The hard drive may be full or nonfunctional."
		downloading = null
		download_progress = 0
	return TRUE


/datum/ui_module/program/email_client/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/living/user = usr

	check_for_new_messages(1)		// Any actual interaction (button pressing) is considered as acknowledging received message, for the purpose of notification icons.
	switch(action)
		if ("login")
			log_in()
			return TRUE

		if ("logout")
			log_out()
			return TRUE

		if ("clear_error")
			error = ""
			return TRUE

		if ("new_message")
			new_message = TRUE
			return TRUE

		if ("cancel")
			if(addressbook)
				addressbook = FALSE
			else
				clear_message()
			return TRUE

		if ("addressbook")
			addressbook = TRUE
			return TRUE

		if ("set_recipient")
			msg_recipient = sanitize(params["value"])
			addressbook = FALSE
			return TRUE

		if ("edit_title")
			var/newtitle = sanitize(params["value"], 100)
			if(newtitle)
				msg_title = newtitle
			return TRUE

		// This uses similar editing mechanism as the FileManager program, therefore it supports various paper tags and remembers formatting.
		if ("edit_body")
			var/newtext = sanitize(replacetext(params["text"], "\n", "\[br\]"), 20000)
			if(newtext)
				msg_body = newtext
			return TRUE

		if ("edit_recipient")
			var/newrecipient = sanitize(params["value"], 100)
			if(newrecipient)
				msg_recipient = newrecipient
				addressbook = 0
			return TRUE

		if ("close_addressbook")
			addressbook = 0
			return TRUE

		if ("edit_login")
			var/newlogin = sanitize(params["value"], 100)
			if(newlogin)
				stored_login = newlogin
			return TRUE

		if ("edit_password")
			var/newpass = sanitize(params["value"], 100)
			if(newpass)
				stored_password = newpass
			return TRUE

		if ("delete")
			if(!istype(current_account))
				return TRUE
			var/datum/computer_file/data/email_message/M = find_message_by_fuid(params["delete"])
			if(!istype(M))
				return TRUE
			if(folder == "Deleted")
				current_account.deleted.Remove(M)
				qdel(M)
			else
				current_account.deleted.Add(M)
				current_account.inbox.Remove(M)
				current_account.spam.Remove(M)
			if(current_message == M)
				current_message = null
			return TRUE

		if ("send")
			if(!current_account)
				return TRUE
			if((msg_body == "") || (msg_recipient == ""))
				error = "Error sending mail: Message body is empty!"
				return TRUE
			if(!length(msg_title))
				msg_title = "No subject"

			var/datum/computer_file/data/email_message/message = new()
			message.title = msg_title
			message.stored_data = msg_body
			message.source = current_account.login
			message.attachment = msg_attachment
			if(!current_account.send_mail(msg_recipient, message))
				error = "Error sending email: this address doesn't exist."
				return TRUE
			else
				error = "Email successfully sent."
				clear_message()
				return TRUE

		if ("set_folder")
			folder = params["folder"]
			return TRUE

		if ("reply")
			var/datum/computer_file/data/email_message/M = find_message_by_fuid(params["reply"])
			if(!istype(M))
				return TRUE
			error = null
			new_message = TRUE
			msg_recipient = M.source
			msg_title = "Re: [M.title]"
			var/atom/movable/AM = host
			if(istype(AM))
				if(ismob(AM.loc))
					ui_interact(AM.loc)
			return TRUE

		if ("view")
			var/datum/computer_file/data/email_message/M = find_message_by_fuid(params["message"])
			if(istype(M))
				current_message = M
			return TRUE

		if ("changepassword")
			var/oldpassword = sanitize(params["old"], 100)
			if(!oldpassword)
				return TRUE
			var/newpassword1 = sanitize(params["new"], 100)
			if(!newpassword1)
				return TRUE
			var/newpassword2 = sanitize(params["new_verify"], 100)
			if(!newpassword2)
				return TRUE

			if(!istype(current_account))
				error = "Please log in before proceeding."
				return TRUE

			if(current_account.password != oldpassword)
				error = "Incorrect original password"
				return TRUE

			if(newpassword1 != newpassword2)
				error = "The entered passwords do not match."
				return TRUE

			current_account.password = newpassword1
			stored_password = newpassword1
			error = "Your password has been successfully changed!"
			return TRUE

		// The following entries are Modular Computer framework only, and therefore won't do anything in other cases (like AI View)

		if ("save")
			// Fully dependant on modular computers here.
			var/obj/item/modular_computer/MC = ui_host()

			if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
				error = "Error exporting file. Are you using a functional and NTOS-compliant device?"
				return TRUE

			var/filename = sanitize(input(user,"Please specify file name:", "Message export"), 100)
			if(!filename)
				return TRUE

			var/datum/computer_file/data/email_message/M = find_message_by_fuid(params["save"])
			var/datum/computer_file/data/mail = istype(M) ? M.export() : null
			if(!istype(mail))
				return TRUE
			mail.filename = filename
			if(!MC.hard_drive || !MC.hard_drive.store_file(mail))
				error = "Internal I/O error when writing file, the hard drive may be full."
			else
				error = "Email exported successfully"
			return TRUE

		if ("addattachment")
			var/obj/item/modular_computer/MC = ui_host()
			msg_attachment = null

			if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
				error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
				return TRUE

			var/list/filenames = list()
			for(var/datum/computer_file/CF in MC.hard_drive.stored_files)
				if(CF.unsendable)
					continue
				filenames.Add(CF.filename)
			var/picked_file = input(user, "Please pick a file to send as attachment (max 32GQ)") as null|anything in filenames

			if(!picked_file)
				return TRUE

			if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
				error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
				return TRUE

			for(var/datum/computer_file/CF in MC.hard_drive.stored_files)
				if(CF.unsendable)
					continue
				if(CF.filename == picked_file)
					msg_attachment = CF.clone()
					break
			if(!istype(msg_attachment))
				msg_attachment = null
				error = "Unknown error when uploading attachment."
				return TRUE

			if(msg_attachment.size > 32)
				error = "Error uploading attachment: File exceeds maximal permitted file size of 32GQ."
				msg_attachment = null
			else
				error = "File [msg_attachment.filename].[msg_attachment.filetype] has been successfully uploaded."
			return TRUE

		if ("downloadattachment")
			if(!current_account || !current_message || !current_message.attachment)
				return TRUE
			var/obj/item/modular_computer/MC = ui_host()
			if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
				error = "Error downloading file. Are you using a functional and NTOSv2-compliant device?"
				return TRUE

			downloading = current_message.attachment.clone()
			download_progress = 0
			return TRUE

		if ("canceldownload")
			downloading = null
			download_progress = 0
			return TRUE

		if ("remove_attachment")
			msg_attachment = null
			return TRUE
