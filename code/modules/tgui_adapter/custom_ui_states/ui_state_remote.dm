/*
	This state checks that user is capable, within range of the remoter, etc. and that src_object meets the basic requirements for interaction (being powered, non-broken, etc.
	Whoever initializes this state is also responsible for deleting it properly.
*/
/datum/ui_state/remote
	var/datum/remoter
	var/datum/remote_target
	var/datum/ui_state/remoter_state

/datum/ui_state/remote/New(remoter, remote_target, datum/ui_state/remoter_state = ui_default_state())
	src.remoter = remoter
	src.remote_target = remote_target
	src.remoter_state = remoter_state
	..()

/datum/ui_state/remote/Destroy()
	src.remoter = null
	src.remoter_state = null

	// Force an UI update before we go, ensuring that any windows we may have opened for the remote target closes.
	SStgui.update_uis(remote_target.ui_container())
	remote_target = null
	return ..()

/datum/ui_state/remote/can_use_topic(datum/src_object, mob/user)
	if(!(remoter && remoter_state))	// The remoter is gone, let us leave
		return UI_CLOSE

	if(src_object != remote_target)
		error("remote - Unexpected src_object: Expected '[remote_target]'/[remote_target.type], was '[src_object]'/[src_object.type]")

	// This checks if src_object is powered, etc.
	// The interactive state is otherwise simplistic and only returns UI_INTERACTIVE and never checks distances, etc.
	. = src_object.CanUseTopic(user, ui_interactive_state())
	if(. == UI_CLOSE)
		return

	// This is the (generally) heavy checking, making sure the user is capable, within range of the remoter source, etc.
	return min(., remoter.CanUseTopic(user, remoter_state))