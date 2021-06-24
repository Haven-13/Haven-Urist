/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "Nanosoft Word"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	requires_ntnet = 0
	available_on_ntnet = 1
	ui_module_path = /datum/ui_module/program/computer_wordprocessor/
	var/browsing
	var/open_file
	var/loaded_data
	var/error
	var/is_edited
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/wordprocessor/proc/open_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(F)
		open_file = F.filename
		loaded_data = F.stored_data
		is_edited = 0
		return 1

/datum/computer_file/program/wordprocessor/proc/save_file(var/filename)
	var/datum/computer_file/data/F = get_file(filename)
	if(!F) //try to make one if it doesn't exist
		F = create_file(filename, loaded_data, /datum/computer_file/data/text)
		return !isnull(F)
	var/datum/computer_file/data/backup = F.clone()
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
	if(!HDD)
		return
	HDD.remove_file(F)
	F.stored_data = loaded_data
	F.calculate_size()
	if(!HDD.store_file(F))
		HDD.store_file(backup)
		return 0
	is_edited = 0
	return 1

/datum/computer_file/program/wordprocessor/proc/print_help_to_chat()
	to_chat(usr, "<span class='notice'>The hologram of a googly-eyed paper clip helpfully tells you:</span>")
	var/help = {"
	\[br\] : Creates a linebreak.
	\[center\] - \[/center\] : Centers the text.
	\[h1\] - \[/h1\] : First level heading.
	\[h2\] - \[/h2\] : Second level heading.
	\[h3\] - \[/h3\] : Third level heading.
	\[b\] - \[/b\] : Bold.
	\[i\] - \[/i\] : Italic.
	\[u\] - \[/u\] : Underlined.
	\[small\] - \[/small\] : Decreases the size of the text.
	\[large\] - \[/large\] : Increases the size of the text.
	\[field\] : Inserts a blank text field, which can be filled later. Useful for forms.
	\[date\] : Current station date.
	\[time\] : Current station time.
	\[list\] - \[/list\] : Begins and ends a list.
	\[*\] : A list item.
	\[hr\] : Horizontal rule.
	\[table\] - \[/table\] : Creates table using \[row\] and \[cell\] tags.
	\[grid\] - \[/grid\] : Table without visible borders, for layouts.
	\[row\] - New table row.
	\[cell\] - New table cell.
	\[logo\] - Inserts NT logo image.
	\[bluelogo\] - Inserts blue NT logo image.
	\[solcrest\] - Inserts SCG crest image.
	\[terraseal\] - Inserts TCC seal"}
	to_chat(usr, help)

/datum/computer_file/program/wordprocessor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch(action)
		if("text_preview")
			var/target = open_file || "Unnamed File"
			show_browser(usr, "<HTML><HEAD><TITLE>Preview: [target]</TITLE></HEAD>[pencode2html(loaded_data)]</BODY></HTML>", "window=[target]")
			return TRUE
		if("tag_help")
			print_help_to_chat()
			return TRUE
		if("clear_error")
			error = null
			return TRUE
		if("open_file")
			var/target = params["file_name"]
			if(!open_file(target))
				error = "I/O error: Unable to open file '[target]'."
		if("create_file")
			var/newname = sanitize(params["file_name"])
			if(!newname)
				return TRUE
			var/datum/computer_file/data/F = create_file(newname, "", /datum/computer_file/data/text)
			if(F)
				open_file = F.filename
				loaded_data = ""
				return TRUE
			else
				error = "I/O error: Unable to create file '[newname]'."
		if("save_as_file")
			var/newname = sanitize(params["file_name"])
			if(!newname)
				return TRUE
			var/datum/computer_file/data/F = create_file(newname, loaded_data, /datum/computer_file/data/text)
			if(F)
				open_file = F.filename
			else
				error = "I/O error: Unable to create file '[newname]'."
			return TRUE
		if("save_file")
			if(!open_file)
				open_file = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
				if(!open_file)
					return FALSE
			if(!save_file(open_file))
				error = "I/O error: Unable to save file '[open_file]'."
			return TRUE
		if("edit_file")
			var/oldtext = html_decode(loaded_data)
			oldtext = replacetext(oldtext, "\[br\]", "\n")

			var/newtext = sanitize(replacetext(params["text"], "\n", "\[br\]", MAX_TEXTFILE_LENGTH))
			if(!newtext)
				return FALSE
			loaded_data = newtext
			is_edited = 1
			return TRUE
		if("print_file")
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have the required hardware to complete this operation."
				return FALSE
			if(!computer.nano_printer.print_text(pencode2html(loaded_data)))
				error = "Hardware error: Printer was unable to print the file. It may be out of paper."
				return FALSE
			return TRUE
