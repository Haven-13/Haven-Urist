/datum/dna/gene/basic/noir
	name="Noir"
	desc = "In recent years, there's been a real push towards 'Detective Noir' movies, but since the last black and white camera was lost many centuries ago, Scientists had to develop a way to turn any movie noir."
	activation_messages=list("The Station's bright coloured light hits your eyes for the last time, and fades into a more appropriate tone, something's different about this place, but you can't put your finger on it. You feel a need to check out the bar, maybe get to the bottom of what's going on in this godforsaken place.")
	deactivation_messages = list("You now feel soft boiled.")

	mutation=M_NOIR

/datum/dna/gene/basic/noir/New()
	block=NOIRBLOCK
	..()

/datum/dna/gene/basic/noir/activate(mob/M)
	..()
	M.update_color()

/datum/dna/gene/basic/noir/deactivate(mob/M,connected,flags)
	if(..())
		M.update_color()
