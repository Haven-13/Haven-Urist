/datum/species/skrell
  description = ""

  available_cultural_info = list(
    TAG_CULTURE = list(
      CULTURE_SPACER,
      CULTURE_RIMMER,
      CULTURE_QERR,
      CULTURE_ARDA,
      CULTURE_OTHER
    ),
    TAG_HOMEWORLD = list(
      LOCATION_QERR,
      LOCATION_ARDA,
      LOCATION_OTHER
    ),
    TAG_FACTION = list(
      FACTION_QBT,
      FACTION_RAF,
      FACTION_IND,
      FACTION_OTHER
    )
  )

  default_cultural_info = list(
    TAG_CULTURE = CULTURE_ARDA,
    TAG_HOMEWORLD = LOCATION_ARDA,
    TAG_FACTION = FACTION_IND
  )
