/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
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

/datum/computer_file/program/wordprocessor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["PRG_txtrpeview"])
		show_browser(usr,"<HTML><HEAD><TITLE>[open_file]</TITLE></HEAD>[pencode2html(loaded_data)]</BODY></HTML>", "window=[open_file]")
		return 1

	if(href_list["PRG_taghelp"])
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
		return 1

	if(href_list["PRG_closebrowser"])
		browsing = 0
		return 1

	if(href_list["PRG_backtomenu"])
		error = null
		return 1

	if(href_list["PRG_loadmenu"])
		browsing = 1
		return 1

	if(href_list["PRG_openfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)
		browsing = 0
		if(!open_file(href_list["PRG_openfile"]))
			error = "I/O error: Unable to open file '[href_list["PRG_openfile"]]'."

	if(href_list["PRG_newfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)

		var/newname = sanitize(input(usr, "Enter file name:", "New File") as text|null)
		if(!newname)
			return 1
		var/datum/computer_file/data/F = create_file(newname, "", /datum/computer_file/data/text)
		if(F)
			open_file = F.filename
			loaded_data = ""
			return 1
		else
			error = "I/O error: Unable to create file '[href_list["PRG_saveasfile"]]'."

	if(href_list["PRG_saveasfile"])
		. = 1
		var/newname = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!newname)
			return 1
		var/datum/computer_file/data/F = create_file(newname, loaded_data, /datum/computer_file/data/text)
		if(F)
			open_file = F.filename
		else
			error = "I/O error: Unable to create file '[href_list["PRG_saveasfile"]]'."
		return 1

	if(href_list["PRG_savefile"])
		. = 1
		if(!open_file)
			open_file = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
			if(!open_file)
				return 0
		if(!save_file(open_file))
			error = "I/O error: Unable to save file '[open_file]'."
		return 1

	if(href_list["PRG_editfile"])
		var/oldtext = html_decode(loaded_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing file '[open_file]'. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return
		loaded_data = newtext
		is_edited = 1
		return 1

	if(href_list["PRG_printfile"])
		. = 1
		if(!computer.nano_printer)
			error = "Missing Hardware: Your computer does not have the required hardware to complete this operation."
			return 1
		if(!computer.nano_printer.print_text(pencode2html(loaded_data)))
			error = "Hardware error: Printer was unable to print the file. It may be out of paper."
			return 1