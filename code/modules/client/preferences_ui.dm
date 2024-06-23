#define EQUIP_PREVIEW_LOADOUT 1
#define EQUIP_PREVIEW_JOB 2
#define EQUIP_PREVIEW_ALL (EQUIP_PREVIEW_LOADOUT|EQUIP_PREVIEW_JOB)

/datum/preferences_ui
	var/datum/preferences/preferences

	var/datum/browser/panel

	//Mob preview
	var/atom/movable/map_view/preview_view = null
	var/atom/movable/screen/preview_background = null

/datum/preferences_ui/New(datum/preferences/preferences)
	src.preferences = preferences

	if(istype(preferences.client))
		preview_view = new()
		preview_view.assigned_map = "character_preview_map"
		preview_view.update_map_view(1)

		preview_background = new()
		preview_background.layer = TURF_LAYER
		preview_background.set_plane(DEFAULT_PLANE)
		preview_background.screen_loc = "character_preview_map:1,1 to 1,4"

/datum/preferences_ui/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	update_preview_icon()

	if(!get_mob_by_key(preferences.client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	var/list/dat = list("<html><body><center>")

	if(preferences.path)
		dat += "Slot - "
		dat += "<a href='?src=[REF(src)];load=1'>Load slot</a> - "
		dat += "<a href='?src=[REF(src)];save=1'>Save slot</a> - "
		dat += "<a href='?src=[REF(src)];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=[REF(src)];reload=1'>Reload slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += preferences.player_setup.header()
	dat += "<br><HR></center>"
	dat += preferences.player_setup.content(user)

	dat += "</html></body>"

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "<div align='center'>Character Setup</div>", 640, 825)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

/datum/preferences_ui/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(is_living_mob(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			open_link(user, config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences_ui/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		preferences.save_preferences()
		preferences.save_character()
	else if(href_list["reload"])
		preferences.load_preferences()
		preferences.load_character()
		preferences.sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		preferences.load_character(text2num(href_list["changeslot"]))
		preferences.sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if(preferences.real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return 0
		preferences.load_character(SAVE_RESET)
		preferences.sanitize_preferences()
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences_ui/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(preferences.path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = GLOB.using_map.character_load_path(S, i)
			from_file(S["real_name"], name)
			if(!name)	name = "Character[i]"
			if(i==preferences.default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=[REF(src)];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences_ui/proc/close_load_dialog(mob/user)
	if(panel)
		panel.close()
		panel = null
	close_browser(user, "window=saves")

/datum/preferences_ui/proc/dress_preview_mob(mob/living/carbon/human/mannequin)
	var/update_icon = FALSE
	preferences.copy_to(mannequin, TRUE)

	var/datum/job/previewJob
	if(preferences.equip_preview_mob && job_master)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if("Assistant" in preferences.job_low)
			previewJob = job_master.GetJob("Assistant")
		else
			for(var/datum/job/job in job_master.occupations)
				if(job.title == preferences.job_high)
					previewJob = job
					break
	else
		return

	if((preferences.equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
		mannequin.job = previewJob.title
		previewJob.equip_preview(mannequin, preferences.player_alt_titles[previewJob.title])
		update_icon = TRUE

	if((preferences.equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (preferences.equip_preview_mob & EQUIP_PREVIEW_JOB) && (previewJob.type == /datum/job/ai || previewJob.type == /datum/job/cyborg)))
		// Equip custom gear loadout, replacing any job items
		var/list/loadout_taken_slots = list()
		for(var/thing in preferences.Gear())
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_roles && G.allowed_roles.len)
					if(previewJob)
						for(var/job_type in G.allowed_roles)
							if(previewJob.type == job_type)
								permitted = 1
				else
					permitted = 1

				if(G.whitelisted && (G.whitelisted != mannequin.species.name))
					permitted = 0

				if(!permitted)
					continue

				if(G.slot && G.slot != slot_tie && !(G.slot in loadout_taken_slots) && G.spawn_on_mob(mannequin, preferences.gear_list[preferences.gear_slot][G.display_name]))
					loadout_taken_slots.Add(G.slot)
					update_icon = TRUE

	if(update_icon)
		mannequin.update_icons()

/datum/preferences_ui/proc/update_preview_icon()
	preview_view.client_clear_all(preferences.client)

	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(preferences.client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	COMPILE_OVERLAYS(mannequin)
	preferences.client.show_character_previews(new /mutable_appearance(mannequin))

	preview_background.icon = preferences.background_options[preferences.background_state]["icon"]
	preview_background.icon_state = preferences.background_options[preferences.background_state]["icon_state"]
	preferences.client.screen |= preview_background

	preview_view.client_add_all_active(preferences.client)
