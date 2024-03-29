/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	sanitize_and_communicate(/decl/communication_channel/pray, src, msg)
	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/Centcomm_announce(msg, mob/Sender, iamessage)
	var/mob/intercepted = check_for_interception()
	msg = "<span class='notice'><b><font color=orange>[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""][intercepted ? "(Intercepted by [intercepted])" : null]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=[REF(Sender)]'>PP</A>) (<A HREF='?_src_=vars;Vars=[REF(Sender)]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[REF(Sender)]'>SM</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=[REF(Sender)]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=[REF(Sender)]'>REPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'resources/sound/machines/signal.ogg')

/proc/Syndicate_announce(msg, mob/Sender)
	var/mob/intercepted = check_for_interception()
	msg = "<span class='notice'><b><font color=crimson>ILLEGAL[intercepted ? "(Intercepted by [intercepted])" : null]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=[REF(Sender)]'>PP</A>) (<A HREF='?_src_=vars;Vars=[REF(Sender)]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[REF(Sender)]'>SM</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=[REF(Sender)]'>BSA</A>) (<A HREF='?_src_=holder'>TAKE</a>) (<A HREF='?_src_=holder;SyndicateReply=[REF(Sender)]'>REPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'resources/sound/machines/signal.ogg')
