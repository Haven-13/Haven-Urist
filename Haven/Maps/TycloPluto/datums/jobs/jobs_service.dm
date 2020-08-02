
/datum/job/assistant
	title = "Crewman"
	alt_titles = list(
	"Technical Assistant","Medical Intern","Cargo Assistant", "Security Deputy",
	"Botanist" = /decl/hierarchy/outfit/job/service/gardener,
	)

/datum/job/chef
	economic_power = 3
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics, access_bar, access_kitchen)
	alt_titles = list("Bartender" = /decl/hierarchy/outfit/job/service/pluto/bartender)
	supervisors = "the quartermaster and the second officer."
	minimal_player_age = 0

/datum/job/janitor
	economic_power = 2
	supervisors = "the second officer."
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 0

/datum/job/chaplain
	minimal_player_age = 0
	economic_power = 4
	title = "Chaplain"
	department = "Medical"
	department_flag = MED|CIV
	hud_icon = "hudchaplain"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer and the chief medical officer"
	access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	minimal_access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	alt_titles = list(
	"Counselor" = /decl/hierarchy/outfit/job/medical/psychiatrist/pluto,
	"Morale Officer" = /decl/hierarchy/outfit/job/chaplain,
	"Psychiatrist" = /decl/hierarchy/outfit/job/medical/psychiatrist/pluto,
	"Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist/pluto)


	outfit_type = /decl/hierarchy/outfit/job/chaplain
