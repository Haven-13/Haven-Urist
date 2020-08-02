#include "datums/jobs/job_access.dm"
#include "datums/jobs/job_outfits.dm"

#include "datums/jobs/jobs_command.dm"
#include "datums/jobs/jobs_engineering.dm"
#include "datums/jobs/jobs_medical.dm"
#include "datums/jobs/jobs_meme.dm"
#include "datums/jobs/jobs_security.dm"
#include "datums/jobs/jobs_service.dm"
#include "datums/jobs/jobs_supply.dm"

/datum/map/tyclo_pluto
  allowed_jobs = list(
    /datum/job/captain,
    /datum/job/firstofficer,
    /datum/job/bodybuard,
    //
    /datum/job/chief_engineer,
    /datum/job/senior_engineer,
    /datum/job/engineer,
    //
    /datum/job/qm,
    /datum/job/cargo_tech,
    //
    /datum/job/cmo,
    /datum/job/doctor,
    //
    /datum/job/hos,
    /datum/job/officer,
    //
    /datum/job/chef,
    /datum/job/janitor,
    /datum/job/chaplain,
    //
    /datum/job/ai,
    /datum/job/cyborg,
    //
    /datum/job/assistant
  )

  species_to_job_whitelist = list(

  )

  species_to_job_blacklist = list(

  )
