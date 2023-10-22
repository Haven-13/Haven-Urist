/decl/emote/audible/synth
	key = "beep"
	emote_message_3p = "USER beeps."
	emote_sound = 'resources/sound/machines/twobeep.ogg'

/decl/emote/audible/synth/check_user(mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/audible/synth/ping
	key = "ping"
	emote_message_3p = "USER pings."
	emote_sound = 'resources/sound/machines/ping.ogg'

/decl/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "USER buzzes."
	emote_sound = 'resources/sound/machines/buzz-sigh.ogg'

/decl/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "USER emits an affirmative blip."
	emote_sound = 'resources/sound/machines/synth_yes.ogg'

/decl/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "USER emits a negative blip."
	emote_sound = 'resources/sound/machines/synth_no.ogg'

/decl/emote/audible/synth/security
	key = "law"
	emote_message_3p = "USER shows USER_HIS legal authorization barcode."
	emote_message_3p_target = "USER shows TARGET USER_THEIR legal authorization barcode."
	emote_sound = 'resources/sound/voice/biamthelaw.ogg'

/decl/emote/audible/synth/security/check_user(mob/living/silicon/robot/user)
	return (istype(user) && istype(user.module,/obj/item/weapon/robot_module/security))

/decl/emote/audible/synth/security/halt
	key = "halt"
	emote_message_3p = "USER's speakers skreech, \"Halt! Security!\"."
	emote_sound = 'resources/sound/voice/halt.ogg'

/decl/emote/audible/synth/chirp
	key = "chirp"
	emote_message_3p = "USER emits a cheerful chirping sound."
	emote_sound = 'resources/sound/urist/chirp.ogg'
