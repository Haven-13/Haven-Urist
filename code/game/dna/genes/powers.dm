///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/dna/gene/basic/nobreath
	name="No Breathing"
	activation_messages=list("You feel no need to breathe.")
	mutation=mNobreath

/datum/dna/gene/basic/nobreath/New()
	block=GLOB.NOBREATHBLOCK

/datum/dna/gene/basic/remoteview
	name="Remote Viewing"
	activation_messages=list("Your mind expands.")
	mutation=mRemote

/datum/dna/gene/basic/remoteview/New()
	block=GLOB.REMOTEVIEWBLOCK

/datum/dna/gene/basic/remoteview/activate(mob/M, connected, flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remoteobserve

/datum/dna/gene/basic/regenerate
	name="Regenerate"
	activation_messages=list("You feel better.")
	mutation=mRegen

/datum/dna/gene/basic/regenerate/New()
	block=GLOB.REGENERATEBLOCK

/datum/dna/gene/basic/increaserun
	name="Super Speed"
	activation_messages=list("Your leg muscles pulsate.")
	mutation=mRun

/datum/dna/gene/basic/increaserun/New()
	block=GLOB.INCREASERUNBLOCK

/datum/dna/gene/basic/remotetalk
	name="Telepathy"
	activation_messages=list("You expand your mind outwards.")
	mutation=mRemotetalk

/datum/dna/gene/basic/remotetalk/New()
	block=GLOB.REMOTETALKBLOCK

/datum/dna/gene/basic/remotetalk/activate(mob/M, connected, flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remotesay

/datum/dna/gene/basic/morph
	name="Morph"
	activation_messages=list("Your skin feels strange.")
	mutation=mMorph

/datum/dna/gene/basic/morph/New()
	block=GLOB.MORPHBLOCK

/datum/dna/gene/basic/morph/activate(mob/M)
	..(M)
	M.verbs += /mob/living/carbon/human/proc/morph

/datum/dna/gene/basic/cold_resist
	name="Cold Resistance"
	activation_messages=list("Your body is filled with warmth.")
	mutation=COLD_RESISTANCE

/datum/dna/gene/basic/cold_resist/New()
	block=GLOB.FIREBLOCK

/datum/dna/gene/basic/cold_resist/can_activate(mob/M,flags)
	if(flags & MUTCHK_FORCED)
		return 1
	//	return !(/datum/dna/gene/basic/heat_resist in M.active_genes)
	// Probability check
	var/_prob=30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob,(flags&MUTCHK_FORCED)))
		return 1

/datum/dna/gene/basic/cold_resist/OnDrawUnderlays(mob/M,g,fat)
	return "fire[fat]_s"

/datum/dna/gene/basic/noprints
	name="No Prints"
	activation_messages=list("Your fingers feel numb.")
	mutation=mFingerprints

/datum/dna/gene/basic/noprints/New()
	block=GLOB.NOPRINTSBLOCK

/datum/dna/gene/basic/noshock
	name="Shock Immunity"
	activation_messages=list("Your skin feels strange.")
	mutation=mShock

/datum/dna/gene/basic/noshock/New()
	block=GLOB.SHOCKIMMUNITYBLOCK

/datum/dna/gene/basic/midget
	name="Midget"
	activation_messages=list("Your skin feels rubbery.")
	mutation=mSmallsize

/datum/dna/gene/basic/midget/New()
	block=GLOB.SMALLSIZEBLOCK

/datum/dna/gene/basic/midget/can_activate(mob/M,flags)
	// Can't be big and small.
	if(HULK in M.mutations)
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/midget/activate(mob/M, connected, flags)
	..(M,connected,flags)
	M.pass_flags |= 1

/datum/dna/gene/basic/midget/deactivate(mob/M, connected, flags)
	..(M,connected,flags)
	M.pass_flags &= ~1 //This may cause issues down the track, but offhand I can't think of any other way for humans to get passtable short of varediting so it should be fine. ~Z

/datum/dna/gene/basic/xray
	name="X-Ray Vision"
	activation_messages=list("The walls suddenly disappear.")
	mutation=XRAY

/datum/dna/gene/basic/xray/New()
	block=GLOB.XRAYBLOCK

/datum/dna/gene/basic/tk
	name="Telekenesis"
	activation_messages=list("You feel smarter.")
	mutation=TK
	activation_prob=15

/datum/dna/gene/basic/tk/New()
	block=GLOB.TELEBLOCK

/datum/dna/gene/basic/tk/OnDrawUnderlays(mob/M,g,fat)
	return "telekinesishead[fat]_s"
