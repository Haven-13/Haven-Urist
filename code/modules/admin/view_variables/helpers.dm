
// Keep these two together, they *must* be defined on both
// If /client ever becomes /datum/client or similar, they can be merged
/datum/proc/get_view_variables_header()
	return "<b>[src]</b>"

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;rename=[REF(src)]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=[REF(src)];varnameedit=dir'>[dir2text(dir)]</a> <a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=right'>>></a>
		<br><a href='?_src_=vars;datumedit=[REF(src)];varnameedit=ckey'>[ckey || "No ckey"]</a> / <a href='?_src_=vars;datumedit=[REF(src)];varnameedit=real_name'>[real_name || "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

// Same for these as for get_view_variables_header() above
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;mob_player_panel=[REF(src)]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;give_spell=[REF(src)]'>Give Spell</option>
		<option value='?_src_=vars;give_disease2=[REF(src)]'>Give Disease</option>
		<option value='?_src_=vars;give_disease=[REF(src)]'>Give TG-style Disease</option>
		<option value='?_src_=vars;godmode=[REF(src)]'>Toggle Godmode</option>
		<option value='?_src_=vars;build_mode=[REF(src)]'>Toggle Build Mode</option>

		<option value='?_src_=vars;ninja=[REF(src)]'>Make Space Ninja</option>
		<option value='?_src_=vars;make_skeleton=[REF(src)]'>Make 2spooky</option>

		<option value='?_src_=vars;direct_control=[REF(src)]'>Assume Direct Control</option>
		<option value='?_src_=vars;drop_everything=[REF(src)]'>Drop Everything</option>

		<option value='?_src_=vars;regenerateicons=[REF(src)]'>Regenerate Icons</option>
		<option value='?_src_=vars;addlanguage=[REF(src)]'>Add Language</option>
		<option value='?_src_=vars;remlanguage=[REF(src)]'>Remove Language</option>
		<option value='?_src_=vars;addorgan=[REF(src)]'>Add Organ</option>
		<option value='?_src_=vars;remorgan=[REF(src)]'>Remove Organ</option>

		<option value='?_src_=vars;addverb=[REF(src)]'>Add Verb</option>
		<option value='?_src_=vars;remverb=[REF(src)]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;gib=[REF(src)]'>Gib</option>
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/mob/living/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;addaura=[REF(src)]'>Add Aura</option>
		<option value='?_src_=vars;removeaura=[REF(src)]'>Remove Aura</option>
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;setspecies=[REF(src)]'>Set Species</option>
		<option value='?_src_=vars;dressup=[REF(src)]'>Dressup</option>
		<option value='?_src_=vars;makeai=[REF(src)]'>Make AI</option>
		<option value='?_src_=vars;makerobot=[REF(src)]'>Make cyborg</option>
		<option value='?_src_=vars;makemonkey=[REF(src)]'>Make monkey</option>
		<option value='?_src_=vars;makeslime=[REF(src)]'>Make slime</option>
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;delthis=[REF(src)]'>Delete instance</option>
		<option value='?_src_=vars;delall=[REF(src)]'>Delete all of type</option>
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/turf/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/datum/proc/get_variables()
	. = vars - VV_hidden()
	if(!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		. -= VV_secluded()

/datum/proc/get_variable_value(varname)
	return vars[varname]

/datum/proc/set_variable_value(varname, value)
	vars[varname] = value

/datum/proc/get_initial_variable_value(varname)
	return initial(vars[varname])

/datum/proc/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=[REF(src)];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;datummass=[REF(src)];varnamemass=[varname]'>M</a>)
			[hide_watch ? "" : "(<a href='?_src_=vars;datumwatch=[REF(src)];varnamewatch=[varname]'>W</a>)"]
			"}

// No mass editing of clients
/client/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;datumchange=[REF(src)];varnamechange=[varname]'>C</a>)
			[hide_watch ? "" : "(<a href='?_src_=vars;datumwatch=[REF(src)];varnamewatch=[varname]'>W</a>)"]
			"}

// These methods are all procs and don't use stored lists to avoid VV exploits

// The following vars cannot be viewed by anyone
/datum/proc/VV_hidden()
	return list()

// The following vars can only be viewed by R_ADMIN|R_DEBUG
/datum/proc/VV_secluded()
	return list()

/datum/configuration/VV_secluded()
	return vars

// The following vars cannot be edited by anyone
/datum/proc/VV_static()
	return list("parent_type")

/atom/VV_static()
	return ..() + list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "step_x", "step_y", "step_size")

/client/VV_static()
	return ..() + list("holder", "prefs")

/datum/admins/VV_static()
	return vars

// The following vars require R_DEBUG to edit
/datum/proc/VV_locked()
	return list("vars", "virus", "viruses", "cuffed")

/client/VV_locked()
	return list("vars", "mob")

/mob/VV_locked()
	return ..() + list("client")

// The following vars require R_FUN|R_DEBUG to edit
/datum/proc/VV_icon_edit_lock()
	return list()

/atom/VV_icon_edit_lock()
	return ..() + list("icon", "icon_state", "overlays", "underlays")

// The following vars require R_SPAWN|R_DEBUG to edit
/datum/proc/VV_ckey_edit()
	return list()

/mob/VV_ckey_edit()
	return list("key", "ckey")

/client/VV_ckey_edit()
	return list("key", "ckey")

/datum/proc/may_edit_var(var/user, var/var_to_edit)
	if(!user)
		return FALSE
	if(!(var_to_edit in vars))
		to_chat(user, "<span class='warning'>\The [src] does not have a var '[var_to_edit]'</span>")
		return FALSE
	if(var_to_edit in VV_static())
		return FALSE
	if((var_to_edit in VV_secluded()) && !check_rights(R_ADMIN|R_DEBUG, FALSE, C = user))
		return FALSE
	if((var_to_edit in VV_locked()) && !check_rights(R_DEBUG, C = user))
		return FALSE
	if((var_to_edit in VV_ckey_edit()) && !check_rights(R_SPAWN|R_DEBUG, C = user))
		return FALSE
	if((var_to_edit in VV_icon_edit_lock()) && !check_rights(R_FUN|R_DEBUG, C = user))
		return FALSE
	return TRUE

/proc/forbidden_varedit_object_types()
 	return list(
		/datum/admins,						//Admins editing their own admin-power object? Yup, sounds like a good idea.,
		/obj/machinery/blackbox_recorder,	//Prevents people messing with feedback gathering,
		/datum/feedback_variable			//Prevents people messing with feedback gathering
	)
